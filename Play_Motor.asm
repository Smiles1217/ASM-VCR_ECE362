	XREF	disp, SetLCD_StartMenu, SetLCD_PlayMenu, SetLCD_SettingsMenu, SetLCD_LoadVHS, SetLCD_ParentPswrdSet, SetLCD_DateTime, SetLCD_PreviousMenu, SetLCD_PlayMovie, SetLCD_RecordNow, SetLCD_RecordLater, SetLCD_EjectVHS, SetLCD_FastForward, SetLCD_Rewind, SetLCD_Playing, SetLCD_Paused, SetLCD_MainMenuReturn, Option, Pot_Menu_Selector, Menu, SetLCD_Error
	XREF	display_string, SetLCD_SelectSettingsMenu, DelayCounter, PB_Testing, Port_P, PreviousMenu, Action_EjectVHS
	XREF 	SetLCD_MainMenu
	XDEF	Play_Motor
	
Play_Motor:

;Probably will need to move this whole thing into an RTI
;Will need similar things in the RTI for Rewind and FF
;Will need to Create Variables for them

;Should probably look at a better way to get the RTI to ignore the Load and Eject garbage unless it needs to run them

	