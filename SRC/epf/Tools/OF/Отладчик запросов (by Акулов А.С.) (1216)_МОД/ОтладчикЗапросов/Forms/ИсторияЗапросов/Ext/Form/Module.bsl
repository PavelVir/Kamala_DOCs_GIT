﻿
Процедура КнопкаВыполнитьНажатие(Кнопка)
	Если ЭлементыФормы.СписокФайлов.ТекущаяСтрока<>Неопределено Тогда
		ЭтаФорма.Закрыть(ЭлементыФормы.СписокФайлов.ТекущаяСтрока.Значение);
	КонецЕсли;
КонецПроцедуры

Процедура ОсновныеДействияФормы1ОчиститьСписок(Кнопка)
	СписокФайлов.Очистить();
	СохранитьЗначение("нкОтладчик_ИсторияФайлов", "");
	ЭтаФорма.Закрыть(ложь);
КонецПроцедуры

Процедура ПриОткрытии()
	СписокФайлов.Очистить();
	СЗ = ВосстановитьЗначение("нкОтладчик_ИсторияФайлов");
	Если ТипЗнч(СЗ)<>Тип("Массив") Тогда
		Возврат;
	КонецЕсли;
	Для каждого ИмяФайла Из СЗ Цикл
		ПолноеИмяФайла = СокрЛП(ИмяФайла);
		Если ПолноеИмяФайла<>"" Тогда
			Файл = Новый Файл(ПолноеИмяФайла);
			Если Файл.Существует() Тогда
				СписокФайлов.Добавить(ПолноеИмяФайла, Файл.Имя + " ("+ПолноеИмяФайла+")");
			КонецЕсли;
		КонецЕсли;
	КонецЦикла;
КонецПроцедуры

Процедура СписокФайловВыбор(Элемент, ЭлементСписка)
	КнопкаВыполнитьНажатие(ЭлементСписка);
КонецПроцедуры