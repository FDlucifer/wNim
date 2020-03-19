#====================================================================
#
#               wNim - Nim's Windows GUI Framework
#                 (c) Copyright 2017-2020 Ward
#
#====================================================================

## These events are generated by common dialogs.
#
## :Superclass:
##   `wEvent <wEvent.html>`_
#
## :Seealso:
##   `wDialog <wDialog.html>`_
#
## :Events:
##   ==============================  =============================================================
##   wDialogEvent                    Description
##   ==============================  =============================================================
##   wEvent_DialogCreated            When the dialog is created but not yet shown.
##   wEvent_DialogClosed             When the dialog is being closed.
##   wEvent_DialogHelp               When the Help button is pressed.
##   wEvent_DialogApply              When the Apply button is pressed.
##   wEvent_FindNext                 When find next button was pressed.
##   wEvent_Replace                  When replace button was pressed.
##   wEvent_ReplaceAll               When replace all button was pressed .
##   wEvent_PrinterChanged           When the selected printer is changed.
##   ==============================  =============================================================

{.experimental, deadCodeElim: on.}
when defined(gcDestructors): {.push sinkInference: off.}

import ../wBase

DefineEvent:
  wEvent_DialogFirst
  wEvent_DialogCreated
  wEvent_DialogClosed
  wEvent_DialogHelp
  wEvent_DialogApply
  wEvent_FindNext
  wEvent_Replace
  wEvent_ReplaceAll
  wEvent_PrinterChanged
  wEvent_DialogLast

proc isDialogEvent(msg: UINT): bool {.inline, shield.} =
  msg in wEvent_DialogFirst..wEvent_DialogLast
