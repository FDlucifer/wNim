#====================================================================
#
#               wNim - Nim's Windows GUI Framework
#                 (c) Copyright 2017-2018 Ward
#
#====================================================================

## These events are generated by menu or sample controls. More complex controls,
## such as wTreeCtrl, have separate command event classes. Note that the
## wCommandEvent and wCommandEvent-derived event classes by default propagate
## upward from the source window up to the first parent which processes the event.
#
## :Superclass:
##   `wEvent <wEvent.html>`_
#
## :Subclasses:
##   `wStatusBarEvent <wStatusBarEvent.html>`_
##   `wSpinEvent <wSpinEvent.html>`_
##   `wListEvent <wListEvent.html>`_
##   `wTreeEvent <wTreeEvent.html>`_
##   `wHyperLinkEvent <wHyperLinkEvent.html>`_
#
## :Events:
##   ==============================  =============================================================
##   wCommandEvent                   Description
##   ==============================  =============================================================
##   wEvent_Menu                     A menu item is selected.
##   wEvent_CommandLeftClick         Clicked the left mouse button within the control.
##   wEvent_CommandLeftDoubleClick   Double-clicked the left mouse button within the control.
##   wEvent_CommandRightClick        Clicked the right mouse button within the control.
##   wEvent_CommandRightDoubleClick  Double-clicked the right mouse button within the control.
##   wEvent_CommandSetFocus          When the control receives the keyboard focus.
##   wEvent_CommandKillFocus         When the control loses the keyboard focus.
##   wEvent_CommandEnter             When enter key was pressed in a control.
##
##   wButton                         Description
##   ==============================  =============================================================
##   wEvent_Button                   The button is clicked.
##   wEvent_ButtonEnter              The mouse is entering the button.
##   wEvent_ButtonLeave              The mouse is leaving the button.
##
##   wCheckBox                       Description
##   ==============================  =============================================================
##   wEvent_CheckBox                 The check box is clicked.
##
##   wRadioButton                    Description
##   ==============================  =============================================================
##   wEvent_RadioButton              The radio button is clicked.
##
##   wListBox                        Description
##   ==============================  =============================================================
##   wEvent_ListBox                  When an item on the list is selected or the selection changes.
##   wEvent_ListBoxDoubleClick       When the listbox is double-clicked.
##
##   wComboBox                       Description
##   ==============================  =============================================================
##   wEvent_ComboBox                 When an item on the list is selected, calling getValue() returns the new value of selection.
##   wEvent_ComboBoxCloseUp          When the list box of the combo box disappears.
##   wEvent_ComboBoxDropDown         When the list box part of the combo box is shown.
##
##   wToolBar                        Description
##   ==============================  =============================================================
##   wEvent_Tool                     Click left mouse button on the tool bar. Same as wEvent_Menu.
##   wEvent_ToolRightClick           Click right mouse button on the tool bar.
##   wEvent_ToolDropDown             Drop down menu selected. If unhandled, displays the default dropdown menu.
##   wEvent_ToolEnter                The mouse cursor has moved into or moved off a tool.
##
##   wTextCtrl                       Description
##   ==============================  =============================================================
##   wEvent_Text                     When the text changes.
##   wEvent_TextUpdate               When the control is about to redraw itself.
##   wEvent_TextMaxlen               When the user tries to enter more text into the control than the limit.
##   wEvent_TextEnter                When pressing Enter key.
##
##   wNoteBook                       Description
##   ==============================  =============================================================
##   wEvent_NoteBookPageChanged      The page selection was changed.
##   wEvent_NoteBookPageChanging     The page selection is about to be changed. This event can be vetoed.
##
##   wCalendarCtrl                   Description
##   ==============================  =============================================================
##   wEvent_CalendarSelChanged       The selected date changed.
##   wEvent_CalendarViewChanged      The control view changed.
##
##   wDatePickerCtrl                 Description
##   ==============================  =============================================================
##   wEvent_DateChanged              The selected date changed.
##
##   wTimePickerCtrl                 Description
##   ==============================  =============================================================
##   wEvent_TimeChanged              The selected time changed.
##
##   wSplitter                       Description
##   ==============================  =============================================================
##   wEvent_Splitter                 The position is dragging by user. This event can be vetoed.
##   ==============================  =============================================================

DefineIncrement(wEvent_CommandFirst):
  wEvent_Menu
  wEvent_Button
  wEvent_ButtonEnter
  wEvent_ButtonLeave
  wEvent_CheckBox
  wEvent_ListBox
  wEvent_ListBoxDoubleClick
  wEvent_CheckListBox
  wEvent_RadioBox
  wEvent_RadioButton
  wEvent_ComboBox
  wEvent_ToolRightClick
  wEvent_ToolDropDown
  wEvent_ToolEnter
  wEvent_ComboBoxDropDown
  wEvent_ComboBoxCloseUp
  wEvent_Text
  wEvent_TextCopy
  wEvent_TextCut
  wEvent_TextPaste
  wEvent_TextUpdate
  wEvent_TextEnter
  wEvent_TextMaxlen
  wEvent_CommandLeftClick
  wEvent_CommandLeftDoubleClick
  wEvent_CommandRightClick
  wEvent_CommandRightDoubleClick
  wEvent_CommandSetFocus
  wEvent_CommandKillFocus
  wEvent_CommandEnter
  wEvent_CommandTab
  wEvent_NoteBookPageChanged
  wEvent_NoteBookPageChanging
  wEvent_CalendarSelChanged
  wEvent_CalendarViewChanged
  wEvent_DateChanged
  wEvent_Splitter

const
  wEvent_Tool* = wEvent_Menu
  wEvent_TimeChanged* = wEvent_DateChanged

proc isCommandEvent(msg: UINT): bool {.inline.} =
  msg in wEvent_CommandFirst..wEvent_CommandLast
