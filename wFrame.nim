## A frame is a top-level window whose size and position can (usually) be changed by the user.
##
## :Superclass:
##    wWindow
## :Styles:
##    ==============================  =============================================================
##    Styles                          Description
##    ==============================  =============================================================
##    wIconize                        Display the frame iconized (minimized).
##    wCaption                        Puts a caption on the frame.
##    wMinimize                       Identical to wICONIZE.
##    wMinimizeBox                    Displays a minimize box on the frame
##    wMaximize                       Displays the frame maximized
##    wMaximize_BOX                   Displays a maximize box on the frame
##    wSystemMenu                     Displays a system menu containing the list of various windows commands in the window title bar.
##    wResizeBorder                   Displays a resizable border around the window.
##    wStayOnTop                      Stay on top of all other windows.
##    wFrameToolWindow                Causes a frame with a small title bar to be created; the frame does not appear in the taskbar.
##    wDefaultFrameStyle              The default style for a frame.
##    ==============================  =============================================================

const
  wIconize* = WS_ICONIC
  wCaption* = WS_CAPTION
  wMinimize* = WS_MINIMIZE
  wMinimizeBox* = WS_MINIMIZEBOX
  wMaximize* = WS_MAXIMIZE
  wMaximize_BOX* = WS_MAXIMIZEBOX
  wSystemMenu* = WS_SYSMENU
  wResizeBorder* = WS_SIZEBOX
  wStayOnTop* = WS_EX_TOPMOST shl 32
  wFrameToolWindow* = WS_EX_TOOLWINDOW shl 32
  wDefaultFrameStyle* = wMinimizeBox or wMaximize_BOX or wResizeBorder or wSystemMenu or wCaption

method getDefaultSize*(self: wFrame): wSize {.validate.} =
  ## Returns the system suggested size of a window (usually used for GUI controls).
  # a reasonable frame size
  result = (640, 480)

proc setMenuBar*(self: wFrame, menuBar: wMenuBar) {.validate, property, inline.} =
  ## Tells the frame to show the given menu bar.
  menuBar.attach(self)

proc getMenuBar*(self: wFrame): wMenuBar {.validate, property, inline.} =
  ## Returns the menubar currently associated with the frame.
  result = mMenuBar

proc setTopMost*(self: wFrame, top = true) {.validate, property.} =
  ## Sets whether the frame top most to all windows.
  let flag = if top: HWND_TOPMOST else: HWND_NOTOPMOST
  SetWindowPos(mHwnd, flag, 0, 0, 0, 0, SWP_NOMOVE or SWP_NOSIZE)

proc createStatusBar*(self: wFrame, number: int = 1, style: wStyle = 0,
    id: wCommandID = 0): wStatusBar {.validate, property, discardable.} =
  ## Creates a status bar at the bottom of the frame.
  result = StatusBar(parent=self)
  if number != 1:
    result.setFieldsCount(number)

proc setIcon*(self: wFrame, icon: wIcon) {.validate, property.} =
  ## Sets the icon for this frame.
  mIcon = icon
  SendMessage(mHwnd, WM_SETICON, ICON_SMALL, if icon != nil: icon.mHandle else: 0)

proc getIcon*(self: wFrame): wIcon {.validate, property, inline.} =
  ## Returns the standard icon.
  result = mIcon

proc minimize*(self: wFrame, flag = true) {.validate.} =
  ## Minimizes or restores the frame
  if isShownOnScreen():
    ShowWindow(mHwnd, if flag: SW_MINIMIZE else: SW_RESTORE)

proc iconize*(self: wFrame, flag = true) {.validate, inline.} =
  ## Iconizes or restores the frame. The same as minimize().
  minimize(flag)

proc maximize*(self: wFrame, flag = true) {.validate.} =
  ## Maximizes or restores the frame.
  if isShownOnScreen():
    ShowWindow(mHwnd, if flag: SW_MAXIMIZE else: SW_RESTORE)

proc restore*(self: wFrame) {.validate, inline.} =
  ## Restore a previously iconized or maximized frame to its normal state.
  ShowWindow(mHwnd, SW_RESTORE)

proc isIconized*(self: wFrame): bool {.validate, inline.} =
  ## Returns true if the frame is iconized.
  result = IsIconic(mHwnd) != 0

proc isMaximized*(self: wFrame): bool {.validate, inline.} =
  ## Returns true if the frame is maximized.
  result = IsZoomed(mHwnd) != 0

proc enableCloseButton*(self: wFrame, flag = true) {.validate.} =
  ## Enables or disables the Close button.
  var hmenu = GetSystemMenu(mHwnd, 0)
  EnableMenuItem(hmenu, SC_CLOSE, UINT(MF_BYCOMMAND or (if flag: MF_ENABLED else : MF_GRAYED)))
  DrawMenuBar(mHwnd)

proc disableCloseButton*(self: wFrame) {.validate, inline.} =
  ## Disables the Close button.
  enableCloseButton(false)

proc enableMaximizeButton*(self: wFrame, flag = true) {.validate.} =
  ## Enables or disables the Maximize button.
  var value = GetWindowLongPtr(mHwnd, GWL_STYLE)
  SetWindowLongPtr(mHwnd, GWL_STYLE, if flag: value or WS_MAXIMIZEBOX else: value and (not WS_MAXIMIZEBOX))

proc disableMaximizeButton*(self: wFrame) {.validate, inline.} =
  ## Disables the Maximize button.
  enableMaximizeButton(false)

proc enableMinimizeButton*(self: wFrame, flag = true) {.validate.} =
  ## Enables or disables the Minimize button.
  var value = GetWindowLongPtr(mHwnd, GWL_STYLE)
  SetWindowLongPtr(mHwnd, GWL_STYLE, if flag: value or WS_MINIMIZEBOX else: value and (not WS_MINIMIZEBOX))

proc disableMinimizeButton*(self: wFrame) {.validate, inline.} =
  ## Disables the Minimize button.
  enableMinimizeButton(false)

proc showModal*(self: wFrame): int {.validate, discardable.} =
  ## Shows the frame as an application-modal dialog.
  ## Program flow does not return until the dialog has been dismissed with EndModal.
  mDisableList = newSeq[wWindow]()

  for topwin in wAppTopLevelWindows():
    if topwin != self and topwin.isEnabled():
      topwin.disable()
      mDisableList.add(topwin)

  show()
  result = MessageLoop(isMainLoop=false)

proc endModal*(self: wFrame, retCode: int = 0) =
  ## Ends a modal dialog, passing a value to be returned from the ShowModal() invocation.

  # MSDN: the application must enable the main window before destroying the dialog box
  for topwin in mDisableList:
    topwin.enable()
  mDisableList = nil

  # use wEvent_AppQuit to end the loop in showModal
  PostMessage(0, wEvent_AppQuit, WPARAM retCode, 0)
  hide()

proc wFrame_DoSize(event: wEvent) =
  # If the frame has exactly one child window, not counting the status and toolbar,
  # this child is resized to take the entire frame client area.
  # If two or more windows are present, they should be laid out explicitly by manually.
  let self = event.mWindow
  if self.mChildren.len > 0:
    let clientSize = self.getClientSize()
    for child in self.mChildren:
      if (not (child of wStatusBar)) and (not (child of wToolBar)):
        child.setSize(0, 0, clientSize.width, clientSize.height)

proc findFocusableChild(self: wWindow): wWindow =
  for win in mChildren:
    if win.isFocusable():
      return win
    elif win.mChildren.len > 0:
      result = win.findFocusableChild()
      if result != nil: return

proc wFrame_OnSetFocus(event: wEvent) =
  # when a frame got focus, try to pass focus to mSaveFocus or first focusable control
  let self = event.mWindow
  var processed = false
  defer: event.skip(if processed: false else: true)

  if self.mSaveFocus != nil:
    self.mSaveFocus.setFocus()
    processed = true

  else:
    # set focus to first focusable control
    let win = self.findFocusableChild()
    if win != nil:
      win.setFocus()
      self.mSaveFocus = win
      processed = true

proc wFrame_OnMenuHighlight(event: wEvent) =
  # The default handler for wEvent_MenuHighlight in wFrame displays help text in the status bar.
  let self = wFrame event.mWindow
  var processed = false
  defer: event.skip(if processed: false else: true)

  if self.mStatusBar != nil and self.mMenuBar != nil:
    let
      hmenu = event.mLparam.HMENU
      flag = HIWORD(event.mWparam)
      menuId = LOWORD(event.mWparam)

    var selectedItem: wMenuItem
    block loop:
      for menu in self.mMenuBar.mMenuList:
        if menu.mHmenu == hmenu:
          if (flag and MF_POPUP) != 0:
            let hSubMenu = GetSubMenu(hmenu, int32 menuId)
            for item in menu.mItemList:
              if item.mSubmenu != nil and item.mSubmenu.mHmenu == hSubMenu:
                selectedItem = item
                break loop
          else:
            for item in menu.mItemList:
              if item.mId == menuId.wCommandID:
                selectedItem = item
                break loop

    self.mStatusBar.setStatusText(if selectedItem != nil: selectedItem.mHelp else: "")
    processed = true

proc wFrame_OnMenuCommand(event: wEvent) =
  let self = event.mWindow
  var processed = false
  defer: event.skip(if processed: false else: true)

  let
    pos = int event.mWparam
    hmenu = cast[HMENU](event.mLparam)

  var menuInfo = MENUINFO(cbSize: sizeof(MENUINFO), fMask: MIM_MENUDATA)
  GetMenuInfo(hmenu, menuInfo)
  if menuInfo.dwMenuData != 0:
    let
      menu = cast[wMenu](menuInfo.dwMenuData)
      item = menu.mItemList[pos]

    if item.mKind == wItemCheck:
      menu.toggle(pos)

    elif item.mKind == wItemRadio:
      menu.check(pos)

    # convet to wEvent_Menu message.
    processed = self.processMessage(wEvent_Menu, cast[WPARAM](item.mId), 0, event.mResult)

when defined(useWinXP):
  # under Windows XP, menu icon must draw by outself
  proc wFrame_OnMeasureItem(event: wEvent) =
    var processed = false
    defer: event.skip(if processed: false else: true)

    var pStruct = cast[LPMEASUREITEMSTRUCT](event.mLparam)
    if pStruct.CtlType == ODT_MENU and pStruct.itemData != 0:
      # here pStruct.itemData maybe a wMenu or a wMenuItem
      let
        menu = cast[wMenu](pStruct.itemData)
        bmp = (if IsMenu(menu.mHmenu): menu.mBitmap else: cast[wMenuItem](pStruct.itemData).mBitmap)
        iconHeight = GetSystemMetrics(SM_CYMENUSIZE)
        iconWidth = GetSystemMetrics(SM_CXMENUSIZE)

      if bmp != nil:
        pStruct.itemHeight = max(bmp.mHeight + 2, iconHeight)
        pStruct.itemWidth = max(bmp.mWidth + 4, iconWidth)
        event.mResult = TRUE
        processed = true

  proc wFrame_OndrawItem(event: wEvent) =
    var processed = false
    defer: event.skip(if processed: false else: true)

    var pStruct = cast[LPDRAWITEMSTRUCT](event.mLparam)
    if pStruct.CtlType == ODT_MENU and pStruct.itemData != 0:
      let
        menu = cast[wMenu](pStruct.itemData)
        bmp = (if IsMenu(menu.mHmenu): menu.mBitmap else: cast[wMenuItem](pStruct.itemData).mBitmap)

      if bmp != nil:
        let
          width = bmp.mWidth
          height = bmp.mHeight
          memdc = CreateCompatibleDC(0)
          prev = SelectObject(memdc, bmp.mHandle)
          x = (pStruct.rcItem.right - pStruct.rcItem.left - width) div 2
          y = (pStruct.rcItem.bottom - pStruct.rcItem.top - height) div 2

        var bf = BLENDFUNCTION(BlendOp: AC_SRC_OVER, SourceConstantAlpha: 255, AlphaFormat: AC_SRC_ALPHA)
        AlphaBlend(pStruct.hDC, x, y, width, height, memdc, 0, 0, width, height, bf)

        SelectObject(memdc, prev)
        DeleteDC(memdc)
        event.mResult = TRUE
        processed = true

proc init(self: wFrame, owner: wWindow = nil, title = "", pos: wPoint, size: wSize,
    style: wStyle = wDefaultFrameStyle, className = "wFrame") =

  self.wWindow.init(title=title, pos=pos, size=size, style=style or WS_CLIPCHILDREN, owner=owner,
    className=className, bgColor=GetSysColor(COLOR_APPWORKSPACE))

  systemConnect(wEvent_Size, wFrame_DoSize)

  hardConnect(wEvent_SetFocus, wFrame_OnSetFocus)
  hardConnect(wEvent_MenuHighlight, wFrame_OnMenuHighlight)
  hardConnect(WM_MENUCOMMAND, wFrame_OnMenuCommand)

  when defined(useWinXP):
    hardConnect(WM_MEASUREITEM, wFrame_OnMeasureItem)
    hardConnect(WM_DRAWITEM, wFrame_OndrawItem)

proc Frame*(owner: wWindow = nil, title = "", pos = wDefaultPoint, size = wDefaultSize,
    style: wStyle = wDefaultFrameStyle, className = "wFrame"): wFrame {.discardable.} =
  ## Constructor, creating the frame. A frame is the top-level window so it cannot have a parent.
  ## However, it can has an owner. The frame will be minimized when its owner is minimized and
  ## restored when it is restored.
  new(result)
  result.init(owner=owner, title=title, pos=pos, size=size, style=style, className=className)
