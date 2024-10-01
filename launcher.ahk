﻿#SingleInstance, force

;Прогрузка билдов
IniRead, a, builds.ini, build_names, a
IniRead, b, builds.ini, build_names, b
IniRead, c, builds.ini, build_names, c
IniRead, d, builds.ini, build_names, d
IniRead, e, builds.ini, build_names, e
IniRead, f, builds.ini, build_names, f
IniRead, g, builds.ini, build_names, g
IniRead, h, builds.ini, build_names, h
IniRead, i, builds.ini, build_names, i
IniRead, g, builds.ini, build_names, g
;Сбрасываем настройки
IniWrite, 0, conf.ini, settings, stateIndex
IniWrite, 1, conf.ini, settings, antiAfk
IniWrite, 0, conf.ini, settings, stateSpells
IniWrite, %a%, temp.ini, currentBuild, build

PID := 0
selfPID := DllCall("GetCurrentProcessId")

;main() {
	Gui, Font, S11 CDefault, consolas
	Gui, Add, Checkbox, x72 y9 w100 h30 Checked vAntiAfk gUpdate +Center, Антиафк ;Антиафк
	Gui, Font, S11 CDefault, consolas
	Gui, Add, Button, x32 y99 w180 h50 gSpells, Автопрожатие способностей ;Запуск автоспособностей
	Gui, Add, DropDownList, x72 y199 w100 h20 gSubmitAll vBuild, %a%||%b%|%c%|%d%|%e%|%f%|%g%|%h%|%i%|%g% ;Лист с билдами
	Gui, Add, Button, x72 y49 w100 h40 gIndex, Автоиндекс ;Запуск индекса
	Gui, Add, Button, x57 y159 w130 h30 gBuildChoose, Редактор билдов
	; Generated using SmartGUI Creator for SciTE
	Gui, Show, w244 h246, AutoBot
	Gui, Submit, NoHide
	return
;return
;}

;Индекс
Index:
	IniRead, stateSpells, conf.ini, settings, stateSpells
	if !stateSpells {
		IniRead, stateIndex, conf.ini, settings, stateIndex
		if !stateIndex {
			IniWrite, !%stateIndex%, conf.ini, settings, stateIndex
			Run, index.ahk
		}
		else
			MsgBox, 262192, Ошибка, Бот уже активирован.`nЧтобы начать`, нажмите *
	}
	else
		MsgBox, 262192, Ошибка, Запущен другой скрипт
return

;Антиафк
Update:
	Gui, Submit, NoHide
	IniWrite, %AntiAfk%, conf.ini, settings, antiAfk
return

;Автоспособности
Spells:
	IniRead, stateIndex, conf.ini, settings, stateIndex
	if !stateIndex {
		IniRead, stateSpells, conf.ini, settings, stateSpells
		if !stateSpells {
			IniWrite, !%stateSpells%, conf.ini, settings, stateSpells
			Run, spells.ahk
		}
		else
			MsgBox, 262192, Ошибка, Бот уже активирован.`nЧтобы начать`, нажмите *
	}
	else
		MsgBox, 262192, Ошибка, Запущен другой скрипт
return

;Выбор билда для автоспособностей
SubmitAll:
	Gui, Submit, Nohide
	IniWrite, %Build%, temp.ini, currentBuild, build
return

;Запуск редактора билдов
BuildChoose:
	Gui, Destroy
	Run, build_choose.ahk
return

;Выход
GuiClose:
	MsgBox, 262433, Закрыть приложение, Вы уверены?`nВсе скрипты завершатся
	ifMsgBox OK
	{
		;Закрываем index.ahk
		IniRead, PID, temp.ini, PID, indexPID
		if (PID != 0)
			Process, Close, %PID%
		PID := 0
		;Закрываем spells.ahk
		IniRead, PID, temp.ini, PID, spellsPID
		if (PID != 0)
			Process, Close, %PID%

		FileDelete, temp.ini
		ExitApp
	}
	else
		return
return
