;*****************************************
;TnhToanKhaNangChiuLua.au3 by ductu
;Created with ISN AutoIt Studio v. 1.02
;*****************************************
; -- Created with ISN Form Studio 2 for ISN AutoIt Studio -- ;
#include <StaticConstants.au3>
#include <GUIConstantsEx.au3>
#include <GuiListBox.au3>
#include <WindowsConstants.au3>
#Include <GuiButton.au3>
#include <EditConstants.au3>
#include <ListBoxConstants.au3>
#include <WinAPIFiles.au3>
#include <Date.au3>
;#include <Math.au3>
Func Log10($fNb)
    Return Log($fNb) / Log(10) ; 10 is the base
EndFunc   ;==>Log10
Func ghiLog($log) 
		_GUICtrlListBox_BeginUpdate($listLog)
			_GUICtrlListBox_InsertString($listLog, $log,0)
			_GUICtrlListBox_UpdateHScroll($listLog)
			_GUICtrlListBox_EndUpdate($listLog)
			_GUICtrlListBox_SetSel($listLog, 0)
			$fileLog= FileOpen($dirRun&"\"&"KetQua.txt",   $FO_APPEND )
			FileWriteLine($fileLog, $log)
			FileClose($fileLog)
			
EndFunc
Global $maxxxtime = 36000
Global $TinhToanKhaNangChiuLua = GUICreate("Tinh Toan Kha Nang Chiu Lua",563,397,-1,-1,-1,-1)
Global $btnChonFIOS = GUICtrlCreateButton("Chọn File Tiết diện",413,20,118,24,-1,-1)
Global $txtFIOS = GUICtrlCreateInput("Chú ý, thư mục chứa file FIOS phải có file Safirdemo.exe",40,20,349,24,-1,$WS_EX_CLIENTEDGE)
GUICtrlSetState(-1,BitOr($GUI_SHOW,$GUI_DISABLE))
;GUICtrlCreateLabel("Số lượng R từ",45,112,50,15,-1,-1)
;GUICtrlSetBkColor(-1,"-2")
;Global $txtRmin = GUICtrlCreateInput("1",115,112,73,20,-1,$WS_EX_CLIENTEDGE)
;Global $txtRmax = GUICtrlCreateInput("180",314,112,80,20,-1,$WS_EX_CLIENTEDGE)
;GUICtrlCreateLabel("đến",205,112,50,15,-1,-1)
;GUICtrlSetBkColor(-1,"-2")
Global $btnRun = GUICtrlCreateButton("Tạo File và gọi Safir",413,105,118,30,-1,-1)
GUICtrlSetState($btnRun,$GUI_DISABLE)
Global $listLog = GUICtrlCreatelist("Chú ý: Thông báo mới sẽ được hiện lên đầu tiên!",24,161,507,188,-1,$WS_EX_CLIENTEDGE)
Global $txtFileChiuTai =GUICtrlCreateInput("Chú ý: File chịu tải phải cùng thư mục với file tiết diện và có nội dung phù hợp",40,60,349,24,-1,$WS_EX_CLIENTEDGE)
GUICtrlSetState($txtFileChiuTai,$GUI_DISABLE)
;GUICtrlCreateLabel("File chịu tải",48,69,63,15,-1,-1)
GUICtrlSetBkColor(-1,"-2")
Global $btnFileChiuTai = GUICtrlCreateButton("Chọn File chịu tải",413,60,118,24,-1,-1)
GUICtrlSetState($btnFileChiuTai,$GUI_DISABLE)
GUISetState(@SW_SHOW,$TinhToanKhaNangChiuLua)
;ConsoleWrite("10="&Log10(10))
While 1
	$nMsg = GUIGetMsg()
	Switch $nMsg
		
		Case $GUI_EVENT_CLOSE
			Exit
		Case $btnChonFIOS
			Global $urlFileFIOS=FileOpenDialog("Chon file FIOS", @WindowsDir & "\", "fiso (*.txt;*.in)", $FD_FILEMUSTEXIST + $FD_MULTISELECT)
			Global $hFileOpen = FileOpen($urlFileFIOS, $FO_READ)
			If $hFileOpen = -1 Then
				MsgBox($MB_SYSTEMMODAL, "", "Không đọc được file nhiệt độ FISO.")
			Else
				GUICtrlSetData($txtFIOS,$urlFileFIOS);
				Global $arrayFISO = StringSplit($urlFileFIOS,"\");
				Global $nameFISO  = StringSplit($arrayFISO[UBound($arrayFISO)-1],".")[1];
				Global $dirRun ="";
				For $i=1 to UBound($arrayFISO)-2 
					$dirRun = $dirRun& $arrayFISO[$i]&"\"				
				Next
				GUICtrlSetState($btnFileChiuTai,$GUI_ENABLE)	
			EndIf 
			
		Case $btnFileChiuTai
			Global $urlFileFIOS2=FileOpenDialog("Chon file Chiu Tai", @WindowsDir & "\", "fiso (*.in)", $FD_FILEMUSTEXIST + $FD_MULTISELECT)
			Global $hFileOpen2 = FileOpen($urlFileFIOS2, $FO_READ)
			If $hFileOpen2 = -1 Then
				MsgBox($MB_SYSTEMMODAL, "", "Không đọc được file chịu tải FIOS.")
			Else
				GUICtrlSetData($txtFileChiuTai,$urlFileFIOS2);
				Global $arrayFISO2 = StringSplit($urlFileFIOS2,"\");
				Global $nameFISO2  = StringSplit($arrayFISO2[UBound($arrayFISO2)-1],".")[1];
				Global $dirRun2 ="";
				For $i=1 to UBound($arrayFISO2)-2 
					$dirRun2 = $dirRun2& $arrayFISO2[$i]&"\"				
				Next
				If $dirRun<>$dirRun2 Then 
					MsgBox($MB_SYSTEMMODAL, "", "File FISO va file Chiu tai khong cung thu muc!")
				Else
					GUICtrlSetState($btnRun,$GUI_ENABLE)
				EndIf
			EndIf 

		Case $btnRun
			;MsgBox(0,"fff","Thu muc chay: "&$dirRun)
			;_Now
			FileDelete($dirRun&"\"&"KetQua.txt")
			Call("ghiLog","Bắt đầu chạy lúc: "&_NowCalc());
			Call("ghiLog","Chạy nhiệt độ FISO");
			WinSetOnTop($TinhToanKhaNangChiuLua, "", $WINDOWS_NOONTOP)
			Run($dirRun&"SAFIR2011demo.exe",$dirRun)
			WinWaitActive($dirRun&"SAFIR2011demo.exe");
			Send($nameFISO&"{ENTER}")
			WinSetOnTop($TinhToanKhaNangChiuLua, "", $WINDOWS_ONTOP)
			WinWaitClose($dirRun&"SAFIR2011demo.exe")
			WinSetOnTop($TinhToanKhaNangChiuLua, "", $WINDOWS_NOONTOP)
			Call("ghiLog","Hoàn thành nhiệt độ FISO");
			;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
			Global $contenFISO = FileRead($hFileOpen)
			FileClose($hFileOpen)	
			Call("ghiLog","Chạy chịu tải FISO");
			Run($dirRun&"SAFIR2011demo.exe");
			WinWaitActive($dirRun&"SAFIR2011demo.exe");
			Send($nameFISO2&"{ENTER}")
			WinSetOnTop($TinhToanKhaNangChiuLua, "", $WINDOWS_ONTOP)
			WinWaitClose($dirRun&"SAFIR2011demo.exe")
			WinSetOnTop($TinhToanKhaNangChiuLua, "", $WINDOWS_NOONTOP)
			Call("ghiLog","Hoàn thành chịu tải FISO");
			Global $contenFISO2 = FileRead($hFileOpen2)
			FileClose($hFileOpen2)	
			Global $logIso = FileOpen($nameFISO2&".LOG", $FO_READ)
			Global $contenLogIso  = FileReadLine ($logIso, -1)
			FileClose($logIso)
			If $contenLogIso==-1 or StringLen($contenLogIso)<1  Then 
				MsgBox(0,"Loi file Chiu tai","Khong doc duoc file log: "&$nameFISO2&".LOG - Co the do file IN khong dung");
			Else
				Global $timeIsoS = StringSplit($contenLogIso,";")[2]
				Global $timeIsoM = Int($timeIsoS/60)
				Call("ghiLog","Thời gian phá hủy theo FIOS: "&$timeIsoM);
				Call("ghiLog","---------------------------------------------------------------");
				Call("ghiLog","Chạy tìm thời gian phá hủy thật sự");
				While 1 ;;lap R 
					$timeIsoM = $timeIsoM-5
					Call("ghiLog","****************R"&$timeIsoM&"****************");
					Global $newString = "R"&$timeIsoM&".FCT"
					Global $sString = StringReplace($contenFISO, "FISO",$newString)
					$fileRIN = StringReplace($nameFISO,"FISO","R"&$timeIsoM)
					;tao file .IN
					$fileR = FileOpen($dirRun&"\"&StringReplace($nameFISO,"FISO","R"&$timeIsoM)&".in", $FO_OVERWRITE )
					FileWrite($fileR, $sString)
					FileClose($fileR)
					Call("ghiLog","Tạo file "&$fileRIN&" xong");
					;Tao file Tai R 
					Global $newString2 = "R"&$timeIsoM
					Global $sString2 = StringReplace($contenFISO2, "FISO",$newString2)
					$fileRIN2 = StringReplace($nameFISO2,"FISO","R"&$timeIsoM)
					;tao file .IN
					$fileR2 = FileOpen($dirRun&"\"&StringReplace($nameFISO2,"FISO","R"&$timeIsoM)&".in", $FO_OVERWRITE )
					FileWrite($fileR2, $sString2)
					FileClose($fileR2)
					Call("ghiLog","Tạo file "&$fileRIN2&" xong");
					;tao file FCT
					$fileFCT= FileOpen($dirRun&"\"&"R"&$timeIsoM&".FCT", $FO_OVERWRITE )
					$time = 0;
					$tempmax = 345 * Log10(8*$timeIsoM + 1) + 20;
					$temp = 0;
					
					While 1 ; Lap thoi gian de tao FCT
						If $time <= $timeIsoM Then 
							$temp = 345 * Log10(8*$time + 1) + 20;
							;ConsoleWrite("log: "&$time&" = "&Log(8*$time))
						ElseIf $timeIsoM <= 30 Then
							$temp = $tempmax -10.417*($time-$timeIsoM)
							ElseIf $timeIsoM  <=120 Then 
								$temp = $tempmax -4.167*(3-$timeIsoM/60)*($time-$timeIsoM);
								Else
									$temp = $tempmax -4.167*($time-$timeIsoM)
						EndIf
						$temp = Int($temp)
						if $temp < 20 Then
							ExitLoop
						EndIf
						FileWriteLine($fileFCT,($time*60)&" "&$temp);
						$time = $time+1
					Wend
					FileWriteLine($fileFCT,$maxxxtime&" 20");
					FileClose($fileFCT)
					Call("ghiLog","Tạo File R"&$timeIsoM&".FCT xong");
					Call("ghiLog","Chạy nhiệt độ R"&$timeIsoM);
					Run($dirRun&"SAFIR2011demo.exe",$dirRun)
					WinWaitActive($dirRun&"SAFIR2011demo.exe");
					Send($fileRIN&"{ENTER}")
					WinSetOnTop($TinhToanKhaNangChiuLua, "", $WINDOWS_ONTOP)
					WinWaitClose($dirRun&"SAFIR2011demo.exe")
					WinSetOnTop($TinhToanKhaNangChiuLua, "", $WINDOWS_NOONTOP)
					Call("ghiLog","Hoàn thành chạy nhiệt độ R"&$timeIsoM);
					Call("ghiLog","Chạy chịu tải R"&$timeIsoM);
					Run($dirRun&"SAFIR2011demo.exe",$dirRun)
					WinWaitActive($dirRun&"SAFIR2011demo.exe");
					Send($fileRIN2&"{ENTER}")
					WinSetOnTop($TinhToanKhaNangChiuLua, "", $WINDOWS_ONTOP)
					WinWaitClose($dirRun&"SAFIR2011demo.exe")
					WinSetOnTop($TinhToanKhaNangChiuLua, "", $WINDOWS_NOONTOP)
					Call("ghiLog","Hoàn thành chạy chịu tải R"&$timeIsoM);					
					$logR = FileOpen(StringReplace($nameFISO2,"FISO","R"&$timeIsoM)&".LOG", $FO_READ)
					$contenLogR  = FileReadLine ($logR, -1)
					$timeRS = Int(StringSplit($contenLogR,";")[2])
					Call("ghiLog","Thời gian kết thúc = "&$timeRS&"s");	
					$timeRM = Int($timeIsoS/60)
					if $timeIsoM <= 1 or $timeRS >= $maxxxtime Then 
						Call("ghilog","Tìm ra khoảng phá hủy từ: R"&($timeIsoM+5)&" đến "&$timeIsoM)
						ExitLoop
					EndIf
				Wend
				Call("ghilog","---------------------------------------------------------")
				Call("ghilog","Tiếp tục tìm từ R"&($timeIsoM+5)&" đến R:"&$timeIsoM)
				;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
				$timeIsoM = $timeIsoM+5
				While 1 ;;lap R 
					$timeIsoM = $timeIsoM-1
					Call("ghiLog","****************R"&$timeIsoM&"****************");
					Global $newString = "R"&$timeIsoM&".FCT"
					Global $sString = StringReplace($contenFISO, "FISO",$newString)
					$fileRIN = StringReplace($nameFISO,"FISO","R"&$timeIsoM)
					;tao file .IN
					$fileR = FileOpen($dirRun&"\"&StringReplace($nameFISO,"FISO","R"&$timeIsoM)&".in", $FO_OVERWRITE )
					FileWrite($fileR, $sString)
					FileClose($fileR)
					Call("ghiLog","Tao file "&$fileRIN&" xong");
					;Tao file Tai R 
					Global $newString2 = "R"&$timeIsoM
					Global $sString2 = StringReplace($contenFISO2, "FISO",$newString2)
					$fileRIN2 = StringReplace($nameFISO2,"FISO","R"&$timeIsoM)
					;tao file .IN
					$fileR2 = FileOpen($dirRun&"\"&StringReplace($nameFISO2,"FISO","R"&$timeIsoM)&".in", $FO_OVERWRITE )
					FileWrite($fileR2, $sString2)
					FileClose($fileR2)
					Call("ghiLog","Tao file "&$fileRIN2&" xong");
					;tao file FCT
					$fileFCT= FileOpen($dirRun&"\"&"R"&$timeIsoM&".FCT", $FO_OVERWRITE )
					$time = 0;
					$tempmax = 345 * Log10(8*$timeIsoM + 1) + 20;
					$temp = 0;
					
					While 1 ; Lap thoi gian de tao FCT
						If $time <= $timeIsoM Then 
							$temp = 345 * Log10(8*$time + 1) + 20;
							;ConsoleWrite("log: "&$time&" = "&Log(8*$time))
						ElseIf $timeIsoM <= 30 Then
							$temp = $tempmax -10.417*($time-$timeIsoM)
							ElseIf $timeIsoM  <=120 Then 
								$temp = $tempmax -4.167*(3-$timeIsoM/60)*($time-$timeIsoM);
								Else
									$temp = $tempmax -4.167*($time-$timeIsoM)
						EndIf
						$temp = Int($temp)
						if $temp < 20 Then
							ExitLoop
						EndIf
						FileWriteLine($fileFCT,($time*60)&" "&$temp);
						$time = $time+1
					Wend
					FileWriteLine($fileFCT,$maxxxtime&" 20");
					FileClose($fileFCT)
					Call("ghiLog","Tao File R"&$timeIsoM&".FCT xong");
					Call("ghiLog","Chạy nhiệt độ R"&$timeIsoM);
					Run($dirRun&"SAFIR2011demo.exe",$dirRun)
					WinWaitActive($dirRun&"SAFIR2011demo.exe");
					Send($fileRIN&"{ENTER}")
					WinSetOnTop($TinhToanKhaNangChiuLua, "", $WINDOWS_ONTOP)
					WinWaitClose($dirRun&"SAFIR2011demo.exe")
					WinSetOnTop($TinhToanKhaNangChiuLua, "", $WINDOWS_NOONTOP)
					Call("ghiLog","Hoàn thành chạy nhiệt độ R"&$timeIsoM);
					Call("ghiLog","Chạy chịu tải R"&$timeIsoM);
					Run($dirRun&"SAFIR2011demo.exe",$dirRun)
					WinWaitActive($dirRun&"SAFIR2011demo.exe");
					Send($fileRIN2&"{ENTER}")
					WinSetOnTop($TinhToanKhaNangChiuLua, "", $WINDOWS_ONTOP)
					WinWaitClose($dirRun&"SAFIR2011demo.exe")
					WinSetOnTop($TinhToanKhaNangChiuLua, "", $WINDOWS_NOONTOP)
					Call("ghiLog","Hoàn thành chạy chịu tải R"&$timeIsoM);					
					$logR = FileOpen(StringReplace($nameFISO2,"FISO","R"&$timeIsoM)&".LOG", $FO_READ)
					$contenLogR  = FileReadLine ($logR, -1)
					$timeRS = Int(StringSplit($contenLogR,";")[2])
					Call("ghiLog","time =: "&$timeRS);	
					$timeRM = Int($timeIsoS/60)
					if $timeIsoM == 1 or $timeRS == $maxxxtime Then 
						Call("ghilog","*******************************************")
						Call("ghilog","Tìm ra thời gian phá hủy: R: "&($timeIsoM+1))
						Call("ghilog","*******************************************")
						ExitLoop
					EndIf
				Wend
			EndIf
			
			Call("ghiLog","Hoàn thành nhiệm vụ lúc: "&_NowCalc());
			Call("ghiLog","-----------------------------------------------");
			;Call("ghiLog","Phan tinh R va tim ra thoi gian pha huy that su em lam sau anh nhe @-@");
			
			
	EndSwitch
WEnd