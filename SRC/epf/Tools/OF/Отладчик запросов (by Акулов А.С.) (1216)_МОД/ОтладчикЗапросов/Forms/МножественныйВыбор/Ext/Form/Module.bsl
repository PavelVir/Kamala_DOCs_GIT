﻿
Процедура ОсновныеДействияФормыСохранить(Кнопка)
	Закрыть(Истина);
КонецПроцедуры

Процедура ОсновныеДействияФормы1ВыбратьВсе(Кнопка)
	фл = Кнопка = ЭлементыФормы.ОсновныеДействияФормы1.Кнопки.ВыбратьВсе;
	Для каждого Элемент Из СЗ Цикл Элемент.Пометка = фл; КонецЦикла;
КонецПроцедуры
