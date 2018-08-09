﻿Перем Инициализирован Экспорт;

Процедура ОсновныеДействияФормы1Стоп(Кнопка)	
	Инициализирован = Ложь;
	ВладелецФормы.ЗавершитьПошаговоеВыполнениеПакета(Истина);
	//ВладелецФормы.ЭлементыФормы.ДействияФормы.Кнопки.ПошаговоеВыполнениеПакетаЗапросов.Пометка = Ложь;
КонецПроцедуры

Процедура ИнициализироватьПакет(ТекстЗапроса) Экспорт
	Перем сч, Строчка;
	Пакет = ПарсерТекстаЗапроса.РазложитьПакетЗапросов(ТекстЗапроса);
	Пакет.Колонки.Добавить("Статус");
	Пакет.Колонки.Добавить("ИмяЗапроса");
	Пакет.Колонки.Добавить("Останов");
	сч = 0;
	Для каждого Строчка Из Пакет Цикл
		сч = сч + 1;
		Строчка.Статус = 2;
		Строчка.Останов = Истина;
		Строчка.ИмяЗапроса = "Запрос "+Формат(сч, "ЧДЦ=0; ЧН=; ЧГ=")+"  ("+Строчка.ТипЗапроса+")";
		Строчка.Текст = СокрЛП(Строчка.Текст);
	КонецЦикла;
	Инициализирован = Истина;
КонецПроцедуры

Процедура ПакетВыбор(Элемент, ВыбраннаяСтрока, Колонка, СтандартнаяОбработка)
	СтандартнаяОбработка = Ложь;
	Если ВыбраннаяСтрока.Статус=2 или ВыбраннаяСтрока.Статус=3 Тогда
		ВыбраннаяСтрока.Статус = ?(ВыбраннаяСтрока.Статус=2, 3, 2);
		ВыбраннаяСтрока.Останов = (ВыбраннаяСтрока.Статус=2);
	Иначе
		КоманднаяПанель1ПоказатьЗапрос(Элемент);
	КонецЕсли;
КонецПроцедуры

Процедура КнопкаВыполнитьНажатие(Кнопка)
	ВладелецФормы.СформироватьНажатие(Кнопка);
КонецПроцедуры

Процедура КоманднаяПанель1ПоказатьЗапрос(Кнопка)
	Перем Стр;
	Стр = ЭлементыФормы.Пакет.ТекущиеДанные;
	Если Стр<>Неопределено И ВладелецФормы<>Неопределено Тогда
		ВладелецФормы.Активизировать();
		ВладелецФормы.ТекущийЭлемент = ВладелецФормы.ЭлементыФормы.ТекстЗапроса;
		ВладелецФормы.ЭлементыФормы.ТекстЗапроса.УстановитьГраницыВыделения(Стр.НачПозиция, Стр.КонПозиция);
	КонецЕсли;
КонецПроцедуры

Процедура ОсновныеДействияФормы1ШагНазад(Кнопка)
	// Вставить содержимое обработчика.
КонецПроцедуры

Процедура КоманднаяПанель1ШагНазад(Кнопка)
	ВладелецФормы.ПакетЗапросовШагНазад();
КонецПроцедуры

Процедура КоманднаяПанель1ОбновитьПараметрыЗапроса(Кнопка)
	ВладелецФормы.ПакетЗапросовОбновитьПараметрыЗапроса();
КонецПроцедуры

Инициализирован = Ложь