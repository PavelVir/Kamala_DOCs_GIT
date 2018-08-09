﻿Перем ТЗ Экспорт;
Перем СтароеИмя;

Процедура ПриОткрытии()
	Для Каждого Колонка из ТЗ.Колонки Цикл
		ЗаполнитьЗначенияСвойств(ТабКолонки.Добавить(), Колонка);
	КонецЦикла;
	Для Каждого Строка из ТабКолонки Цикл
		Строка.НовоеИмя = Строка.Имя;
	КонецЦикла;
	ЭлементыФормы.ТабКолонки.ТолькоПросмотр = флТолькоПросмотр;
КонецПроцедуры

Процедура ОсновныеДействияФормыДействиеОК(Кнопка)
	Перем мКолонки, Колонка, Строчка, сч, инд;
	мКолонки = новый Массив;
	// Удаление и переименование колонок
	Для Каждого Колонка из ТЗ.Колонки Цикл
		Строчка = ТабКолонки.Найти(Колонка.Имя, "Имя");
		Если Строчка=Неопределено Тогда
			мКолонки.Добавить(Колонка.Имя);
		Иначе
			Колонка.Имя = Строчка.НовоеИмя;
		КонецЕсли;
	КонецЦикла;
	Для Каждого Колонка из мКолонки Цикл
		ТЗ.Колонки.Удалить(Колонка);
	КонецЦикла;
	// Создание колонок
	Для каждого Строчка из ТабКолонки Цикл		
		Если ПустаяСтрока(Строчка.Имя) или (ТЗ.Колонки.Найти(Строчка.Имя)=Неопределено) Тогда
			ТЗ.Колонки.Добавить(Строчка.НовоеИмя, Строчка.ТипЗначения);
		КонецЕсли;
	КонецЦикла;
	// Сортировка колонок
	сч = 0;
	Для каждого Строчка из ТабКолонки Цикл
		Колонка = ТЗ.Колонки.Найти(Строчка.НовоеИмя);
		инд = ?(Колонка=Неопределено, -1, ТЗ.Колонки.Индекс(Колонка));
		Если (инд>0) и (инд<>сч) Тогда
			ТЗ.Колонки.Сдвинуть(Колонка, сч-инд);
		КонецЕсли;
		сч = сч + 1;
	КонецЦикла;
	Закрыть(Истина);
КонецПроцедуры

Процедура ТабКолонкиНовоеИмякОкончаниеВводаТекста(Элемент, Текст, Значение, СтандартнаяОбработка)
КонецПроцедуры

Процедура ТабКолонкиПередОкончаниемРедактирования(Элемент, НоваяСтрока, ОтменаРедактирования, Отказ)
	ТекСтр = ЭлементыФормы.ТабКолонки.ТекущаяСтрока;
	Если ОтменаРедактирования Тогда
		ТекСтр.НовоеИмя = СтароеИмя;
		Возврат;
	КонецЕсли;
	Значение = ТекСтр.НовоеИмя;
	Значение = СтрЗаменить(ТРЕГ(СокрЛП(Значение)), " ", "");
	Если Значение="" Тогда
		сч = 1;
		Пока (сч<=1000000) Цикл
			Значение = "Колонка"+Формат(сч, "ЧДЦ=0; ЧН=; ЧГ=");
			Если ТабКолонки.Найти(Значение, "НовоеИмя")=Неопределено Тогда
				Прервать;
			КонецЕсли;
			сч = сч + 1;
		КонецЦикла;
		ТекСтр.НовоеИмя = Значение;
	Иначе
		ТекСтр.НовоеИмя = Значение;
		Массив = ТабКолонки.НайтиСтроки(Новый Структура("НовоеИмя", Значение));
		Для Каждого Строка из Массив Цикл
			Если Строка<>ТекСтр Тогда
				Сообщить("Уже есть колонка с таким именем!", СтатусСообщения.Информация);
				Отказ = Истина;
				Возврат;
			КонецЕсли;
		КонецЦикла;
	КонецЕсли;
КонецПроцедуры

Процедура ТабКолонкиПередНачаломИзменения(Элемент, Отказ)
	СтароеИмя = ЭлементыФормы.ТабКолонки.ТекущаяСтрока.НовоеИмя
КонецПроцедуры

Процедура ТабКолонкиТипЗначенияНачалоВыбора(Элемент, СтандартнаяОбработка)
	СтандартнаяОбработка = ложь;
	Форма = ПолучитьФорму("ВыборТипаЗначения");
	Форма.БезКоллекций = Истина;
	Форма.БезПустых = Истина;
	Форма.НастраиватьТип = Истина;
	Форма.ВыбЗнач = ЭлементыФормы.ТабКолонки.ТекущаяСтрока.ТипЗначения;
	Если форма.ОткрытьМодально()=Истина Тогда
		ЭлементыФормы.ТабКолонки.ТекущаяСтрока.ТипЗначения = Форма.ВыбЗнач;
	КонецЕсли;
КонецПроцедуры
