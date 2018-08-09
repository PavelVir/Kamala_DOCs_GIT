﻿Перем мИмяФайла;                        // имя файла запросов
Перем мИмяПути;                         // путь к файлу запорсов

Перем мЗаголовокФормы;                  // заголовок формы

Перем мТекущаяСтрока;                   // текущая(прошлая) строка дерева запросов.
Перем мИдетДобавление;                  // признак добавления
Перем мАктивизированаДобавляемаяЗапись; // признак активизации добавленной записи

Перем мРезЗапроса;                      // результат 

Перем мФормаПараметров;                 // форма параметров

Перем мТаблицаЗагружена;                // признак того, что рез-т запроса загружен в табличное поле
Перем мСводнаяТаблицаЗагружена;         // признак того, что рез-т запроса загружен в сводную таблицу

Перем ОбъектЗапрос;

///////////////////////////////////////////////////////////////////////////////
// ВСПОМОГАТЕЛЬНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ

// Получает текст запроса из текстового поля
//
// Параметры:
//  СВыделением - признак получения только выделенного текста.
//
// Возвращаемое значение:
//	Текст запроса в виде строки.
//
Функция вПолучитьТекстЗапроса(СВыделением)

	Если Не СВыделением Тогда
		Возврат ЭлементыФормы.ТекстЗапроса.ПолучитьТекст();
	КонецЕсли;

    ТекстЗап = ЭлементыФормы.ТекстЗапроса.ПолучитьВыделенныйТекст();
	Если СтрДлина(ТекстЗап) <> 0 Тогда
		Возврат ТекстЗап;
	Иначе
		Возврат ЭлементыФормы.ТекстЗапроса.ПолучитьТекст();
	КонецЕсли;

КонецФункции // ПолучитьТекстЗапроса()

// Устанавливает текст запроса в текстовом поле
//
// Параметры:
//  Текст - устанавливаемый текст запроса.
//
Процедура вЗадатьТекстЗапроса(Текст)

	ЭлементыФормы.ТекстЗапроса.УстановитьТекст(Текст);

КонецПроцедуры // ЗадатьТекстЗапроса()

// Устанавливает заголовок формы по имени файла запросов
//
// Параметры:
//  Нет.
//
Процедура вУстановитьЗаголовокФормы()
	
	Если мИмяФайла <> "" Тогда
		Заголовок = мЗаголовокФормы + " : " + мИмяФайла;
	Иначе
		Заголовок = мЗаголовокФормы;
	КонецЕсли;
	
КонецПроцедуры // УстановитьЗаголовокФормы()

// Записывает в дерево запросов текст запроса из текстового поля
//
// Параметры:
//  Нет.
//
Процедура вСохранитьЗапросТекущейСтроки()

	Если ДеревоЗапросов.Строки.Количество() <> 0 И мТекущаяСтрока <> НеОпределено Тогда

		Если мТекущаяСтрока.ТекстЗапроса <> вПолучитьТекстЗапроса(Ложь) Тогда
			Модифицированность = Истина;
		КонецЕсли;
		     
		мТекущаяСтрока.ТекстЗапроса = вПолучитьТекстЗапроса(Ложь);
		мТекущаяСтрока.ПараметрыЗапроса = мФормаПараметров.Параметры.Скопировать();
		мТекущаяСтрока.СпособВыгрузки = СпособВыгрузки;

	КонецЕсли;

КонецПроцедуры // СохранитьЗапросТекущейСтроки()

// Очищает дерево запросов, текстовое поле, список параметров
//
// Параметры:
//  Нет.
//
Процедура вОчиститьЗначения()

	ДеревоЗапросов.Строки.Очистить();
	вЗадатьТекстЗапроса("");
	мФормаПараметров.Параметры.Очистить();

КонецПроцедуры // ОчиститьЗначения()

// Сохраняет имя файла и путь к нему для использования в последующих сеансах работы
//
// Параметры:
//  Нет.
//
Процедура вСохранитьИмяФайла()

	СохранитьЗначение("КонсольЗапросов_ИмяФайла", мИмяФайла);
	СохранитьЗначение("КонсольЗапросов_ИмяПути",  мИмяПути);

КонецПроцедуры // СохранитьИмяФайла()

// Восстанавливает имя открывавшегося в предыдущем сеансе работы файла и путь к нему 
//
// Параметры:
//  Нет.
//
Процедура вВосстановитьИмяФайла()

	мИмяФайла = ВосстановитьЗначение("КонсольЗапросов_ИмяФайла");
	мИмяПути  = ВосстановитьЗначение("КонсольЗапросов_ИмяПути");

	Если мИмяФайла = НеОпределено Тогда
		мИмяФайла = "";
	КонецЕсли;

	Если мИмяПути = НеОпределено Тогда
		мИмяПути = "";
	КонецЕсли;

КонецПроцедуры // ВосстановитьИмяФайла()

// Копирует дерево запросов
//
// Параметры:
//  ИсходноеДерево
//	НовоеДерево.
//
Процедура вСкопироватьДеревоЗапросов(ИсходноеДерево, НовоеДерево)

	НовоеДерево.Строки.Очистить();

	Если ИсходноеДерево.Строки.Количество() = 0 Тогда
		Возврат;
	КонецЕсли;

	Для каждого СтрокаДерева из ИсходноеДерево.Строки Цикл

		НоваяСтрока = НовоеДерево.Строки.Добавить();
		НоваяСтрока[0] = СтрокаДерева[0]; // Запрос
		НоваяСтрока[1] = СтрокаДерева[1]; // ТекстЗапроса
		НоваяСтрока[2] = СтрокаДерева[2]; // ПараметрыЗапроса
		НоваяСтрока[3] = СтрокаДерева[3]; // СпособВыгрузки

		вСкопироватьДеревоЗапросов(СтрокаДерева, НоваяСтрока);
		
	КонецЦикла;

КонецПроцедуры // СкопироватьДеревоЗапросов()

// Подготовка к созданию нового файла запросов
//
// Параметры:
//  Нет.
//
Процедура вСоздатьНовыйФайлЗапросов()

	мИмяФайла = "";
	мИмяПути = "";
	вСохранитьИмяФайла();

	вОчиститьЗначения();
	вУстановитьЗаголовокФормы();
	мТекущаяСтрока = НеОпределено;

	мТекущаяСтрока = ДеревоЗапросов.Строки.Добавить();
	мТекущаяСтрока.Запрос = "Запросы";
	мТекущаяСтрока.ТекстЗапроса = "";
	
	Модифицированность = Ложь;
	
КонецПроцедуры // СоздатьНовыйФайлЗапросов()

// Загружает дерево запросов из файла
//
// Параметры:
//  Нет.
//
Процедура вЗагрузитьЗапросыИзФайла()

	//Проверим существование файла.
	ФайлЗначения = Новый Файл(мИмяФайла);
	ПолученноеЗначение = ?(ФайлЗначения.Существует(), ЗначениеИзФайла(мИмяФайла), Неопределено);

	Если ТипЗнч(ПолученноеЗначение) = Тип("ТаблицаЗначений") Тогда

		вОчиститьЗначения();
		Для каждого СтрокаВремТаблицы из ПолученноеЗначение Цикл
			НовСтрока = ДеревоЗапросов.Строки.Добавить();
			НовСтрока[0] = СтрокаВремТаблицы[0]; // Запрос
			НовСтрока[1] = СтрокаВремТаблицы[1]; // ТекстЗапроса
			НовСтрока[2] = СтрокаВремТаблицы[2]; // ПараметрыЗапроса
			Если ПолученноеЗначение.Колонки.Количество() > 3 Тогда
				НовСтрока[3] = СтрокаВремТаблицы[3]; // СпособВыгрузки
			КонецЕсли;
		КонецЦикла;
		Модифицированность = Ложь;

	ИначеЕсли ТипЗнч(ПолученноеЗначение) = Тип("ДеревоЗначений") Тогда

		вОчиститьЗначения();
		вСкопироватьДеревоЗапросов(ПолученноеЗначение, ДеревоЗапросов);
		Модифицированность = Ложь;

	Иначе // Формат файла не опознан
		Предупреждение("Невозможно загрузить список запросов из указанного файла!
					   |Выберите другой файл.");

	КонецЕсли;

	вУстановитьЗаголовокФормы();

КонецПроцедуры // ЗагрузитьЗапросыИзФайла()

// Сохраняет дерево запросов в файл
//
// Параметры:
//  ЗапрашиватьСохранение - признак необходимости предупрежедния перед сохранением
//	ЗапрашиватьИмяФайла - признак необходимости запроса имени файла.
//
Функция вСохранитьЗапросыВФайл(ЗапрашиватьСохранение = Ложь, ЗапрашиватьИмяФайла = Ложь)

	вСохранитьЗапросТекущейСтроки();

	Если Не ЗапрашиватьИмяФайла Тогда
		Если ЗапрашиватьСохранение Тогда
			Если Не Модифицированность Тогда
				Возврат Истина;
			Иначе
				Ответ = Вопрос("Сохранить текущие запросы?", РежимДиалогаВопрос.ДаНетОтмена);
				Если Ответ = КодВозвратаДиалога.Отмена Тогда
					Возврат Ложь;
				ИначеЕсли Ответ = КодВозвратаДиалога.Нет Тогда
					Возврат Истина;
				КонецЕсли;
			КонецЕсли;
		КонецЕсли;
	КонецЕсли;

	Если ПустаяСтрока(мИмяФайла) или ЗапрашиватьИмяФайла Тогда

		Длг = Новый ДиалогВыбораФайла(РежимДиалогаВыбораФайла.Сохранение);

		Длг.ПолноеИмяФайла = мИмяФайла;
		Длг.Каталог = мИмяПути;
		Длг.Заголовок = "Укажите файл для списка запросов";
		Длг.Фильтр = "Файлы запросов (*.sel)|*.sel|Все файлы (*.*)|*.*";
		Длг.Расширение = "sel";
		
		Если Длг.Выбрать() Тогда
			мИмяФайла = Длг.ПолноеИмяФайла;
			мИмяПути = Длг.Каталог;
		Иначе
			Возврат Ложь;
		КонецЕсли;

	КонецЕсли;

	ЗначениеВФайл(мИмяФайла, ДеревоЗапросов);
	Модифицированность = Ложь;
	вСохранитьИмяФайла();
	вУстановитьЗаголовокФормы();

	Возврат Истина;

КонецФункции // СохранитьЗапросыВФайл()

// Загружает результат запроса в таблицу или сводную таблицу
//
// Параметры:
//  Нет.
//
Процедура вЗагрузитьРезультат()
	
	Если мРезЗапроса <> Неопределено Тогда
		
		Если ЭлементыФормы.ПанельРезультата.ТекущаяСтраница.Имя = "Результат" Тогда
			Если мТаблицаЗагружена = Ложь Тогда
				ЭлементыФормы.ТаблицаРезультата.Колонки.Очистить();
				Если СпособВыгрузки = 2 Тогда // Дерево
					РезультатДерево = мРезЗапроса.Выгрузить(ОбходРезультатаЗапроса.ПоГруппировкамСИерархией);
					ЭлементыФормы.ТаблицаРезультата.Данные = "РезультатДерево";
					ЭлементыФормы.ТаблицаРезультата.СоздатьКолонки();
				Иначе // Список
					РезультатТаблица = мРезЗапроса.Выгрузить(ОбходРезультатаЗапроса.Прямой);
					ЭлементыФормы.ТаблицаРезультата.Данные = "РезультатТаблица";
					ЭлементыФормы.ТаблицаРезультата.СоздатьКолонки();
				КонецЕсли;
				мТаблицаЗагружена = Истина;
			КонецЕсли;
		ИначеЕсли ЭлементыФормы.ПанельРезультата.ТекущаяСтраница.Имя = "СводнаяТаблица" Тогда
			Если мСводнаяТаблицаЗагружена = Ложь Тогда
				Попытка
					ЭлементыФормы.РезультатТабДокСвод.ВстроенныеТаблицы.СводнаяТаблица.ИсточникДанных = мРезЗапроса;
				Исключение
				КонецПопытки;
				мСводнаяТаблицаЗагружена = Истина;
			КонецЕсли;
		КонецЕсли;

	КонецЕсли;
		
КонецПроцедуры // ЗагрузитьРезультат()

// Добавляет строки при копировании строки дерева запросов
//
// Параметры:
//  ТекСтрока - текущая строка
//	ДобСтрока - добавляемая строка
//	Дерево - дерево значений.
//
Процедура вДобавитьСтроки(ТекСтрока, ДобСтрока, Дерево)

	Для Каждого Кол Из Дерево.Колонки Цикл
		ДобСтрока[Кол.Имя] = ТекСтрока[Кол.Имя];
	КонецЦикла;
	
	Для Каждого Строка Из ТекСтрока.Строки Цикл
		НоваяСтрока = ДобСтрока.Строки.Добавить();
		вДобавитьСтроки(Строка, НоваяСтрока, Дерево);
	КонецЦикла;

КонецПроцедуры // ДобавитьСтроки()

// Включает или отключает запуск автосохранения.
//
// Параметры:
//  Нет.
//
Процедура вОбработкаАвтосохранения()

	Если ИспользоватьАвтосохранение Тогда
		ПодключитьОбработчикОжидания("Сохранить", ИнтервалАвтосохранения);
	Иначе
		ОтключитьОбработчикОжидания("Сохранить");
	КонецЕсли;

КонецПроцедуры // ОбработкаАвтосохранения()

///////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ КОМАНДНОЙ ПАНЕЛИ

// Обработчик нажатия кнопки командной панели "Новый список запросов"
//
Процедура НовыйФайл()

	Если вСохранитьЗапросыВФайл(Истина) Тогда
		вСоздатьНовыйФайлЗапросов();
	КонецЕсли;

КонецПроцедуры // НовыйФайл()

// Обработчик нажатия кнопки командной панели "Открыть файл запросов"
//
Процедура ОткрытьФайл()

	Если вСохранитьЗапросыВФайл(Истина) Тогда

		Длг = Новый ДиалогВыбораФайла(РежимДиалогаВыбораФайла.Открытие);
		
		Длг.ПолноеИмяФайла = мИмяФайла;
		Длг.Каталог = мИмяПути;
		Длг.Заголовок = "Выберите файл со списком запросов";
		Длг.Фильтр = "Файлы запросов (*.sel)|*.sel|Все файлы (*.*)|*.*";
		Длг.Расширение = "sel";
		
		Если Длг.Выбрать() Тогда
			мИмяФайла = Длг.ПолноеИмяФайла;
			мИмяПути = Длг.Каталог;
			вЗагрузитьЗапросыИзФайла();
			мТекущаяСтрока = НеОпределено;
			вСохранитьИмяФайла();
		КонецЕсли;

	КонецЕсли;

КонецПроцедуры // ОткрытьФайл()

// Обработчик нажатия кнопки командной панели "Сохранить"
//
Процедура Сохранить()

	вСохранитьЗапросыВФайл();

КонецПроцедуры // Сохранить()

// Обработчик нажатия кнопки командной панели "Сохранить как"
//
Процедура СохранитьКак()

	вСохранитьЗапросыВФайл(Ложь, Истина);

КонецПроцедуры // СохранитьКак()

// Обработчик нажатия кнопки командной панели "Настройка автосохранения"
//
Процедура НастройкаАвтосохранения()

	ФормаНастройкиАвтосохранения = ПолучитьФорму("ФормаКонсольЗапросовНастройкиАвтосохранения");
	ФормаНастройкиАвтосохранения.ОткрытьМодально();

	вОбработкаАвтосохранения();

КонецПроцедуры // НастройкаАвтосохранения()

// Обработчик нажатия кнопки командной панели "Перенести в другую группу"
//
Процедура ПеренестиСтрокуДерева()

	ФормаВыбораСтрокиДереваЗапросов = ПолучитьФорму("ФормаКонсольЗапросовВыбораСтрокиДереваЗапросов", ЭтаФорма);
	ФормаВыбораСтрокиДереваЗапросов.ЗакрыватьПриВыборе = Истина;

	ФормаВыбораСтрокиДереваЗапросов.ДеревоЗапросов = ДеревоЗапросов;
	ФормаВыбораСтрокиДереваЗапросов.ТекущаяСтрокаВладельца = ЭлементыФормы.ДеревоЗапросов.ТекущаяСтрока;
	ФормаВыбораСтрокиДереваЗапросов.ЭлементыФормы.ДеревоЗапросов.ТекущаяСтрока = ЭлементыФормы.ДеревоЗапросов.ТекущаяСтрока;

	ФормаВыбораСтрокиДереваЗапросов.ОткрытьМодально();

КонецПроцедуры // ПеренестиСтрокуДерева()

// Обработчик нажатия кнопки командной панели "Выполнить"
//
Процедура ВыполнитьЗапрос()

	вСохранитьЗапросТекущейСтроки();

	Для каждого СтрокаПараметров Из мФормаПараметров.Параметры Цикл
		Если СтрокаПараметров.ЭтоВыражение Тогда
			ОбъектЗапрос.УстановитьПараметр(СтрокаПараметров.ИмяПараметра, Вычислить(СтрокаПараметров.ЗначениеПараметра));
		Иначе
			ОбъектЗапрос.УстановитьПараметр(СтрокаПараметров.ИмяПараметра, СтрокаПараметров.ЗначениеПараметра);
		КонецЕсли;
	КонецЦикла;

	ОбъектЗапрос.Текст = СтрЗаменить(вПолучитьТекстЗапроса(Истина), "|", "");

	Если ПустаяСтрока(ОбъектЗапрос.Текст) Тогда
		Предупреждение("Не заполнен текст запроса!", 30);
		Возврат;
	КонецЕсли;

	ДатаНачала = ТекущаяДата();
	
	УничтожитьВременныеТаблицыВЗапросе(ОбъектЗапрос);
	
	Попытка
		мРезЗапроса = ОбъектЗапрос.Выполнить();
		ДатаКонцаВыполнения = ТекущаяДата();

		мТаблицаЗагружена = Ложь;
		мСводнаяТаблицаЗагружена = Ложь;

		вЗагрузитьРезультат();
		
		ДатаКонца = ТекущаяДата();

	Исключение
		Предупреждение(Сред(ОписаниеОшибки(),69));
	КонецПопытки;

КонецПроцедуры // ВыполнитьЗапрос()

// Обработчик нажатия кнопки командной панели "Параметры"
//
Процедура Параметры()

	Если мФормаПараметров.Открыта() = Истина Тогда
		мФормаПараметров.Закрыть();
	Иначе
		мФормаПараметров.Открыть();
	КонецЕсли;

КонецПроцедуры // Параметры()

// Обработчик нажатия кнопки командной панели "Сохранить в табличный документ"
//
Процедура СохранитьРезультат()
	Перем ЗаголовокКолонки;

	Если мРезЗапроса <> Неопределено Тогда
		ТабДок = Новый ТабличныйДокумент;
		КоличествоКолонок = мРезЗапроса.Колонки.Количество();

		Выборка = мРезЗапроса.Выбрать(ОбходРезультатаЗапроса.Прямой);

        ДетальнаяСтрока = ТабДок.ПолучитьОбласть(1, , 1, );
		ОбластьОбщихИтогов = ТабДок.ПолучитьОбласть(1, , 1, );
	    ОбластьОбщихИтогов.Область().Шрифт = Новый Шрифт(ОбластьОбщихИтогов.Область().Шрифт, , , Истина, , ,);
		ОбластьИерархическихЗаписей = ТабДок.ПолучитьОбласть(1, , 1, );
	    ОбластьИерархическихЗаписей.Область().Шрифт = Новый Шрифт(ОбластьИерархическихЗаписей.Область().Шрифт, , , Истина, , ,);
		ОбластьГрупповыхЗаписей = ТабДок.ПолучитьОбласть(1, , 1, );
	    ОбластьГрупповыхЗаписей.Область().Шрифт = Новый Шрифт(ОбластьГрупповыхЗаписей.Область().Шрифт, , , Истина, , ,);
		ОбластьЗаголвка = ТабДок.ПолучитьОбласть(1, , 1, );
		
		Для ТекущееПоле = 0 По КоличествоКолонок - 1 Цикл
			Область = ОбластьЗаголвка.Область(1, ТекущееПоле + 1);
			Область.Текст = мРезЗапроса.Колонки[ТекущееПоле].Имя;
            Область.ШиринаКолонки = мРезЗапроса.Колонки[ТекущееПоле].Ширина;
		КонецЦикла;
		ТабДок.Вывести(ОбластьЗаголвка);
		ОбластьЗаголвка = ТабДок.Область(1, 1, 1, КоличествоКолонок);
		
		ОбластьЗаголвка.Шрифт = Новый Шрифт(ОбластьЗаголвка.Шрифт, , , Истина, , ,);
		ОбластьЗаголвка.ЦветФона = Новый Цвет(255, 255, 0);
		ОбластьЗаголвка.ГраницаСнизу = Новый Линия(ТипЛинииЯчейкиТабличногоДокумента.Сплошная, 1);

        ТабДок.НачатьАвтогруппировкуСтрок();
		Пока Выборка.Следующий() Цикл
			Если Выборка.ТипЗаписи() = ТипЗаписиЗапроса.ИтогПоГруппировке Тогда 
				ИсходнаяСтрока = ОбластьГрупповыхЗаписей;
			ИначеЕсли Выборка.ТипЗаписи() = ТипЗаписиЗапроса.ИтогПоИерархии Тогда 
				ИсходнаяСтрока = ОбластьИерархическихЗаписей;
			ИначеЕсли Выборка.ТипЗаписи() = ТипЗаписиЗапроса.ОбщийИтог Тогда 
				ИсходнаяСтрока = ОбластьОбщихИтогов;
			Иначе
				ИсходнаяСтрока = ДетальнаяСтрока;
			КонецЕсли;
				
			Для ТекущееПоле = 0 По КоличествоКолонок - 1 Цикл
				Область = ИсходнаяСтрока.Область(1, ТекущееПоле + 1);
				Область.Текст = Выборка[ТекущееПоле];
			КонецЦикла;
			ТабДок.Вывести(ИсходнаяСтрока, Выборка.Уровень());
		КонецЦикла;
		ТабДок.ЗакончитьАвтогруппировкуСтрок();

		ТабДок.Показать();
	КонецЕсли;
	
КонецПроцедуры // СохранитьРезультат()

///////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ЭЛЕМЕНТОВ УПРАВЛЕНИЯ

// Обработчик выбора строки в дереве запросов
//
Процедура ДеревоЗапросовВыбор(Элемент, ВыбраннаяСтрока, Колонка, СтандартнаяОбработка)

	СтандартнаяОбработка = Ложь;
	ВыполнитьЗапрос();

КонецПроцедуры // ДеревоЗапросовВыбор()

// Обработчик активизации строки в дереве запросов
//
Процедура ДеревоЗапросовПриАктивизацииСтроки(Элемент)

	НадоСохранять = Истина;
	
	Если мИдетДобавление Тогда
		Если мАктивизированаДобавляемаяЗапись Тогда

			// Произошла отмена добавления записи.
			НадоСохранять = Ложь;
			мАктивизированаДобавляемаяЗапись = Ложь;
		Иначе
			мАктивизированаДобавляемаяЗапись = Истина;
		КонецЕсли;
	КонецЕсли;

	Если НадоСохранять Тогда
		вСохранитьЗапросТекущейСтроки();
	КонецЕсли;

	мТекущаяСтрока = ЭлементыФормы.ДеревоЗапросов.ТекущаяСтрока;

	Если ДеревоЗапросов.Строки.Количество() <> 0 И мТекущаяСтрока <> НеОпределено Тогда

		вЗадатьТекстЗапроса(мТекущаяСтрока.ТекстЗапроса);

		ИсходнаяТаблицаПараметров = мТекущаяСтрока.ПараметрыЗапроса;
		мФормаПараметров.Параметры.Очистить();
		Если Не ИсходнаяТаблицаПараметров = НеОпределено Тогда
			Для каждого СтрокаИсходнойТаблицы из ИсходнаяТаблицаПараметров Цикл
				НоваяСтрока = мФормаПараметров.Параметры.Добавить();
				НоваяСтрока[0] = СтрокаИсходнойТаблицы[0]; // Имя параметра
				НоваяСтрока[1] = СтрокаИсходнойТаблицы[1]; // Вид параметра
				НоваяСтрока[2] = СтрокаИсходнойТаблицы[2]; // Значение
			КонецЦикла;
		КонецЕсли;

        Если мТекущаяСтрока.СпособВыгрузки = Неопределено Тогда
			мТекущаяСтрока.СпособВыгрузки = 1;
		КонецЕсли;

		СпособВыгрузки = мТекущаяСтрока.СпособВыгрузки;

	Иначе

		вЗадатьТекстЗапроса("");
		мФормаПараметров.Параметры.Очистить();

	КонецЕсли;

КонецПроцедуры // ДеревоЗапросовПриАктивизацииСтроки()

// Обработчик события перед началом добавления строки в дереве запросов
//
Процедура ДеревоЗапросовПередНачаломДобавления(Элемент, Отказ, Копирование, Родитель)

	Если Копирование Тогда
		Отказ = Истина;
		ТекСтрока = Элемент.ТекущаяСтрока;
		Если ТекСтрока.Родитель <> Неопределено Тогда
			НоваяСтрока = ТекСтрока.Родитель.Строки.Добавить();
		Иначе
			НоваяСтрока = Элемент.Значение.Строки.Добавить();
		КонецЕсли;
		вДобавитьСтроки(ТекСтрока, НоваяСтрока, Элемент.Значение);
	КонецЕсли;
	
	мИдетДобавление = Истина;
	
КонецПроцедуры // ДеревоЗапросовПередНачаломДобавления()

// Обработчик события перед удалением строки в дереве запросов
//
Процедура ДеревоЗапросовПередУдалением(Элемент, Отказ)

	мТекущаяСтрока = НеОпределено;
	Модифицированность = Истина;

КонецПроцедуры // ДеревоЗапросовПередУдалением()

// Обработчик события при окончании редактирования строки в дереве запросов
//
Процедура ДеревоЗапросовПриОкончанииРедактирования(Элемент, НоваяСтрока, ОтменаРедактирования)

	Если НоваяСтрока и Элемент.ТекущаяСтрока.СпособВыгрузки = НеОпределено Тогда
		Элемент.ТекущаяСтрока.СпособВыгрузки = 1;
	КонецЕсли;

	ДеревоЗапросовПриАктивизацииСтроки(Элемент);

	Если мИдетДобавление Тогда

		Если ОтменаРедактирования Тогда
			мТекущаяСтрока = Неопределено;
		КонецЕсли;
		
		мИдетДобавление = Ложь;
	КонецЕсли;

	Модифицированность = Истина;

КонецПроцедуры // ДеревоЗапросовПриОкончанииРедактирования()

// Обработчик изменения способа выгрузки
//
Процедура СпособВыгрузкиПриИзменении(Элемент)

	Модифицированность = Истина;

КонецПроцедуры // СпособВыгрузкиПриИзменении()

// Обработчик выбора строки в таблице результата
//
Процедура ТаблицаРезультатаВыбор(Элемент, ВыбраннаяСтрока, Колонка, СтандартнаяОбработка)

	СтандартнаяОбработка = Ложь;
	
    СодержимоеЯчейки = ВыбраннаяСтрока[Колонка.Имя];

	Если ТипЗнч(СодержимоеЯчейки) = Тип("ТаблицаЗначений") Тогда
		ФормаВложеннойТаблицы = Обработка.ПолучитьФорму("ФормаКонсольЗапросовВложеннойТаблицы", ЭтаФорма);
		ФормаВложеннойТаблицы.ВложеннаяТаблица = СодержимоеЯчейки;
		ФормаВложеннойТаблицы.ЭлементыФормы.ВложеннаяТаблица.СоздатьКолонки();
		ФормаВложеннойТаблицы.Открыть();
	Иначе
		ОткрытьЗначение(СодержимоеЯчейки);
	КонецЕсли;

КонецПроцедуры // ТаблицаРезультатаВыбор()

///////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ФОРМЫ

// Обработчик события при открытии формы
//
Процедура ПриОткрытии()

	// Создадим структуру дерева запросов
	ДеревоЗапросов.Колонки.Добавить("ТекстЗапроса");
	ДеревоЗапросов.Колонки.Добавить("ПараметрыЗапроса");
	ДеревоЗапросов.Колонки.Добавить("СпособВыгрузки");

	// Попытаемся загрузить последний открывавшийся файл запросов
	вВосстановитьИмяФайла();
	Если ПустаяСтрока(мИмяФайла) Тогда
		вСоздатьНовыйФайлЗапросов();
	Иначе
		вЗагрузитьЗапросыИзФайла();
		мТекущаяСтрока = НеОпределено;
	КонецЕсли;

	ИспользоватьАвтосохранение = ВосстановитьЗначение("КонсольЗапросов_ИспользоватьАвтосохранение");
	ИнтервалАвтосохранения = ВосстановитьЗначение("КонсольЗапросов_ИнтервалАвтосохранения");
	вОбработкаАвтосохранения();

КонецПроцедуры // ПриОткрытии()

// Обработчик события выбора в подчиненной форме
//
Процедура ОбработкаВыбора(ЗначениеВыбора, Источник)

	НоваяСтрока = ЗначениеВыбора.Строки.Добавить();
	НоваяСтрока[0] = мТекущаяСтрока[0]; // Запрос
	НоваяСтрока[1] = мТекущаяСтрока[1]; // ТекстЗапроса
	НоваяСтрока[2] = мТекущаяСтрока[2]; // ПараметрыЗапроса
	НоваяСтрока[3] = мТекущаяСтрока[3]; // СпособВыгрузки

	вСкопироватьДеревоЗапросов(мТекущаяСтрока, НоваяСтрока);

    РодительТекущейСтроки = ?(мТекущаяСтрока.Родитель = НеОпределено, ДеревоЗапросов, мТекущаяСтрока.Родитель);
	РодительТекущейСтроки.Строки.Удалить(РодительТекущейСтроки.Строки.Индекс(мТекущаяСтрока));
	мТекущаяСтрока = НеОпределено;

	ЭлементыФормы.ДеревоЗапросов.ТекущаяСтрока = НоваяСтрока;

	Модифицированность = Истина;

КонецПроцедуры // ОбработкаВыбора()

// Обработчик события преред закрытием формы
//
Процедура ПередЗакрытием(Отказ, СтандартнаяОбработка)

	Если вСохранитьЗапросыВФайл(Истина) Тогда
		СохранитьЗначение("КонсольЗапросов_ИспользоватьАвтосохранение", ИспользоватьАвтосохранение);
		СохранитьЗначение("КонсольЗапросов_ИнтервалАвтосохранения", ИнтервалАвтосохранения);
	Иначе
        СтандартнаяОбработка = Ложь;
		Отказ = Истина;
	КонецЕсли;

КонецПроцедуры // ПередЗакрытием()

// Обработчик события при смене страницы панели
//
Процедура ПанельРезультатаПриСменеСтраницы(Элемент, ТекущаяСтраница)
	
	вЗагрузитьРезультат();
	
КонецПроцедуры // ПанельРезультатаПриСменеСтраницы()

Функция ПолучитьОбъектныеТипы()
    Рез=Новый Массив();
    Для Каждого Стр из Метаданные.Справочники Цикл
        Рез.Добавить(Тип("СправочникСсылка."+Стр.Имя));
    КонецЦикла;
    Для Каждого Стр из Метаданные.Документы Цикл
        Рез.Добавить(Тип("ДокументСсылка."+Стр.Имя));
    КонецЦикла;
    Для Каждого Стр из Метаданные.ПланыВидовХарактеристик Цикл
        Рез.Добавить(Тип("ПланВидовХарактеристикСсылка."+Стр.Имя));
    КонецЦикла;
    Для Каждого Стр из Метаданные.ПланыСчетов Цикл
        Рез.Добавить(Тип("ПланСчетовСсылка."+Стр.Имя));
    КонецЦикла;
    Для Каждого Стр из Метаданные.ПланыВидовРасчета Цикл
        Рез.Добавить(Тип("ПланВидовРасчетаСсылка."+Стр.Имя));
    КонецЦикла;
    Для Каждого Стр из Метаданные.БизнесПроцессы Цикл
        Рез.Добавить(Тип("БизнесПроцессСсылка."+Стр.Имя));
    КонецЦикла;
    Для Каждого Стр из Метаданные.Задачи Цикл
        Рез.Добавить(Тип("ЗадачаСсылка."+Стр.Имя));
    КонецЦикла;
    Для Каждого Стр из Метаданные.ПланыОбмена Цикл
        Рез.Добавить(Тип("ПланОбменаСсылка."+Стр.Имя));
    КонецЦикла;
    Возврат Рез;
КонецФункции

Функция ПолучитьТипыДокумент()
    Рез=Новый Массив();
    Для Каждого Стр из Метаданные.Документы Цикл
        Рез.Добавить(Тип("ДокументСсылка."+Стр.Имя));
    КонецЦикла;
    Возврат Рез;
КонецФункции

Процедура УдалитьОбъектыНажатие(Элемент)
    Если Вопрос("Вы действительно хотите удалить все объекты в таблице?",РежимДиалогаВопрос.ДаНет,,КодВозвратаДиалога.Нет,"ВНИМАНИЕ!!!")=КодВозвратаДиалога.Нет Тогда
        Возврат;
    КонецЕсли;
    Типы=ПолучитьОбъектныеТипы();
    Количество=РезультатТаблица.Количество();
    Сч=0;
	Для Каждого Стр из РезультатТаблица Цикл
	    Для Каждого Кол из РезультатТаблица.Колонки Цикл
	        Если Типы.Найти(ТипЗнч(Стр[Кол.Имя]))<>Неопределено Тогда
	            Попытка
	                Объект=Стр[Кол.Имя].ПолучитьОбъект();
	                Объект.Удалить();
	            Исключение
	                Сообщить("Не удалось обработать объект: "+Стр[Кол.Имя]+Символы.ПС+ОписаниеОшибки(),СтатусСообщения.Важное);
	            КонецПопытки;
	        КонецЕсли;
	    КонецЦикла;
	    Сч=Сч+1;
	    Состояние("Обработано "+Цел(100*Сч/Количество)+"%");
	КонецЦикла;
КонецПроцедуры

Процедура КоманднаяПанельФормыОчиститьВТ(Кнопка)
	ОбъектЗапрос.МенеджерВременныхТаблиц.Закрыть();
	ОбъектЗапрос.МенеджерВременныхТаблиц=Новый МенеджерВременныхТаблиц();
КонецПроцедуры

Функция ПолучитьМассивСлов(Текст)
    Рез=Новый Массив();
    Сч=0;
    СтрД=СтрДлина(Текст);
    РусскиеБуквы="йцукенгшщзхъфывапролджэячсмитьбюё";
    АнглийскиеБуквы="qwertyuiopasdfghjklzxcvbnm";
    Цифры="0123456789";
    СтрокаСимволовИДН="_"+РусскиеБуквы+ВРег(РусскиеБуквы)+АнглийскиеБуквы+ВРег(АнглийскиеБуквы)+Цифры;
    Слово="";
    Пока Сч<СтрД Цикл
        Сч=Сч+1;
        Сим=Сред(Текст,Сч,1);
        Если Найти(СтрокаСимволовИДН,Сим)>0 Тогда
            Слово=Слово+Сим;
        Иначе
            Если Слово<>"" Тогда
                Рез.Добавить(Слово);
            КонецЕсли;
            Слово="";
        КонецЕсли;
    КонецЦикла;
    Возврат Рез;
КонецФункции

Функция ПолучитьСписокВремТаб(Текст)
    Рез=Новый Массив();
    МасСлов=ПолучитьМассивСлов(Текст);
    Для Сч=1 по МасСлов.Количество()-1 Цикл
        Если (ВРег(МасСлов[Сч-1])="ПОМЕСТИТЬ") Тогда
            Рез.Добавить(МасСлов[Сч]);
        КонецЕсли;
    КонецЦикла;
    Возврат Рез;
КонецФункции

Процедура УничтожитьВременныеТаблицыВЗапросе(Зап)
    ИсходныйТекст=Зап.Текст;
    СписокВремТаб=ПолучитьСписокВремТаб(ИсходныйТекст);
    Для Каждого Имя из СписокВремТаб Цикл
        Зап.Текст="УНИЧТОЖИТЬ "+Имя;
        Попытка
        	Зап.Выполнить();
        Исключение
        
        КонецПопытки;
    КонецЦикла;
    Зап.Текст=ИсходныйТекст;
КонецПроцедуры

Процедура КоманднаяПанельФормыПоказать(Кнопка)
    ИсходныйТекст=СтрЗаменить(вПолучитьТекстЗапроса(Истина), "|", "");
    СписокВремТаб=ПолучитьСписокВремТаб(ИсходныйТекст);
    Если СписокВремТаб.Количество()=1 Тогда
        ИмяТаб=СписокВремТаб[0];
    ИначеЕсли СписокВремТаб.Количество()>1 Тогда
        СпВыб=Новый СписокЗначений();
        Для Каждого Имя из СписокВремТаб Цикл
           СпВыб.Добавить(Имя,Имя);
        КонецЦикла;
        Эл=СпВыб.ВыбратьЭлемент("Выбирите врем. таб.");
        Если Эл=Неопределено Тогда
            Возврат;
        КонецЕсли;
        ИмяТаб=Эл.Значение;
    Иначе
        Предупреждение("Временных таблиц не обнаружено!");
        Возврат;
    КонецЕсли;

	ОбъектЗапрос.Текст = "ВЫБРАТЬ * ИЗ "+ИмяТаб+" КАК Таб";

	ДатаНачала = ТекущаяДата();
	
	Попытка
		мРезЗапроса = ОбъектЗапрос.Выполнить();
		ДатаКонцаВыполнения = ТекущаяДата();

		мТаблицаЗагружена = Ложь;
		мСводнаяТаблицаЗагружена = Ложь;

		вЗагрузитьРезультат();
		
		ДатаКонца = ТекущаяДата();

	Исключение
		Предупреждение(Сред(ОписаниеОшибки(),69));
	КонецПопытки;
КонецПроцедуры

Процедура КоманднаяПанельФормыСохранитьТекТабВФайл(Кнопка)
	Режим = РежимДиалогаВыбораФайла.Сохранение;
	ДиалогОткрытияФайла = Новый ДиалогВыбораФайла(Режим);
	ДиалогОткрытияФайла.ПолноеИмяФайла = "";
	Фильтр = "Текст(*.1S)|*.1S";
	ДиалогОткрытияФайла.Фильтр = Фильтр;
	ДиалогОткрытияФайла.МножественныйВыбор = Ложь;
	Если ДиалогОткрытияФайла.Выбрать() Тогда
		ЗначениеВФайл(ДиалогОткрытияФайла.ПолноеИмяФайла,РезультатТаблица);
	КонецЕсли;
КонецПроцедуры

Процедура КоманднаяПанельФормыВосстановитьТекТабВоВремТаб(Кнопка)
	Режим = РежимДиалогаВыбораФайла.Открытие;
	ДиалогОткрытияФайла = Новый ДиалогВыбораФайла(Режим);
	ДиалогОткрытияФайла.ПолноеИмяФайла = "";
	Фильтр = "Текст(*.1S)|*.1S";
	ДиалогОткрытияФайла.Фильтр = Фильтр;
	ДиалогОткрытияФайла.МножественныйВыбор = Ложь;
	ИмяВремТаб="ВремТаб1";
	Если ДиалогОткрытияФайла.Выбрать() и ВвестиСтроку(ИмяВремТаб,"Имя временной таблицы") Тогда
		РезультатТаблица=ЗначениеИЗФайла(ДиалогОткрытияФайла.ПолноеИмяФайла);
		ЭлементыФормы.ТаблицаРезультата.Колонки.Очистить();
		ЭлементыФормы.ТаблицаРезультата.СоздатьКолонки();
		ОбъектЗапрос.Текст="ВЫБРАТЬ * ПОМЕСТИТЬ "+ИмяВремТаб+" ИЗ &Таб КАК Таб";
		ОбъектЗапрос.УстановитьПараметр("Таб",РезультатТаблица);
		ОбъектЗапрос.Выполнить();
		ЭлементыФормы.ТекстЗапроса.УстановитьТекст("ВЫБРАТЬ * ИЗ "+ИмяВремТаб+" КАК Таб");
	КонецЕсли;
КонецПроцедуры

Процедура КоманднаяПанель1УдалитьДвиженияДокументов(Кнопка)
	Если Вопрос("Вы действительно хотите удалить все движения документов в таблице?",РежимДиалогаВопрос.ДаНет,,КодВозвратаДиалога.Нет,"ВНИМАНИЕ!!!")=КодВозвратаДиалога.Нет Тогда
        Возврат;
    КонецЕсли;
    Типы=ПолучитьТипыДокумент();
    Количество=РезультатТаблица.Количество();
    Сч=0;
	Для Каждого Стр из РезультатТаблица Цикл
	    Для Каждого Кол из РезультатТаблица.Колонки Цикл
	        Если Типы.Найти(ТипЗнч(Стр[Кол.Имя]))<>Неопределено Тогда
	            НачатьТранзакцию();
	            Попытка
	                Объект=Стр[Кол.Имя].ПолучитьОбъект();
	                Движения=Объект.Движения;
	                Для Каждого Движ из Движения Цикл
	                    Движ.Очистить();
	                    Движ.Записать(Истина);
	                КонецЦикла;
	            Исключение
	                ОтменитьТранзакцию();
	                Сообщить("Не удалось обработать объект: "+Стр[Кол.Имя]+Символы.ПС+ОписаниеОшибки(),СтатусСообщения.Важное);
	                Продолжить;
	            КонецПопытки;
	            ЗафиксироватьТранзакцию();
	        КонецЕсли;
	    КонецЦикла;
	    Сч=Сч+1;
	    Состояние("Обработано "+Цел(100*Сч/Количество)+"%");
	КонецЦикла;
КонецПроцедуры

Процедура КоманднаяПанель1ПерезаписатьОбъекты(Кнопка)
	Если Вопрос("Вы действительно хотите перезаписать все объекты в таблице?",РежимДиалогаВопрос.ДаНет,,КодВозвратаДиалога.Нет,"ВНИМАНИЕ!!!")=КодВозвратаДиалога.Нет Тогда
        Возврат;
    КонецЕсли;
    Типы=ПолучитьОбъектныеТипы();
    Количество=РезультатТаблица.Количество();
    Сч=0;
	Для Каждого Стр из РезультатТаблица Цикл
	    Для Каждого Кол из РезультатТаблица.Колонки Цикл
	        Если Типы.Найти(ТипЗнч(Стр[Кол.Имя]))<>Неопределено Тогда
	            Попытка
	                Объект=Стр[Кол.Имя].ПолучитьОбъект();
	                Объект.Записать();
	            Исключение
	                Сообщить("Не удалось обработать объект: "+Стр[Кол.Имя]+Символы.ПС+ОписаниеОшибки(),СтатусСообщения.Важное);
	            КонецПопытки;
	        КонецЕсли;
	    КонецЦикла;
	    Сч=Сч+1;
	    Состояние("Обработано "+Цел(100*Сч/Количество)+"%");
	КонецЦикла;
КонецПроцедуры

Процедура КоманднаяПанель1СохранитьТаблицу(Кнопка)
	Режим = РежимДиалогаВыбораФайла.Сохранение;
	ДиалогОткрытияФайла = Новый ДиалогВыбораФайла(Режим);
	ДиалогОткрытияФайла.ПолноеИмяФайла = "";
	Фильтр = "Текст(*.1S)|*.1S";
	ДиалогОткрытияФайла.Фильтр = Фильтр;
	ДиалогОткрытияФайла.Заголовок = "Выберите файл";
	Если ДиалогОткрытияФайла.Выбрать() Тогда
		ЗначениеВФайл(ДиалогОткрытияФайла.ПолноеИмяФайла,РезультатТаблица);
	КонецЕсли;
КонецПроцедуры

Процедура КоманднаяПанель1ОткрытьТаблицу(Кнопка)
	Режим = РежимДиалогаВыбораФайла.Открытие;
	ДиалогОткрытияФайла = Новый ДиалогВыбораФайла(Режим);
	ДиалогОткрытияФайла.ПолноеИмяФайла = "";
	Фильтр = "Текст(*.1S)|*.1S";
	ДиалогОткрытияФайла.Фильтр = Фильтр;
	ДиалогОткрытияФайла.Заголовок = "Выберите файл";
	Если ДиалогОткрытияФайла.Выбрать() Тогда
		РезультатТаблица=ЗначениеИзФайла(ДиалогОткрытияФайла.ПолноеИмяФайла);
		ЭлементыФормы.ТаблицаРезультата.СоздатьКолонки();
	КонецЕсли;
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ОПЕРАТОРЫ ОСНОВНОЙ ПРОГРАММЫ

мИмяФайла = "";
мИмяПути = "";

мЗаголовокФормы = Заголовок;

мТекущаяСтрока = НеОпределено;
мИдетДобавление = Ложь;
мАктивизированаДобавляемаяЗапись = Ложь;

мФормаПараметров = Обработка.ПолучитьФорму("ФормаКонсольЗапросовПараметров", ЭтаФорма);
мФормаПараметров.РазрешитьСостояниеПрикрепленное = Истина;
мФормаПараметров.РазрешитьСостояниеПрячущееся = Ложь;
мФормаПараметров.РазрешитьСостояниеСвободное = Истина;
мТаблицаЗагружена = Ложь;
мСводнаяТаблицаЗагружена = Ложь;

ОбъектЗапрос = Новый Запрос;
ОбъектЗапрос.МенеджерВременныхТаблиц=Новый МенеджерВременныхТаблиц();