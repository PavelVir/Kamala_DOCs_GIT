﻿////////////////////////////////////////////////////////////////////////////////
// ПЕРЕМЕННЫЕ
Перем ТаблицаСсылок;

////////////////////////////////////////////////////////////////////////////////
// ЭКСПОРТНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ

// Функция проверяет попадает ли значение в отбор
// Параметры:
//  ТекЗначение   - Значение любого типа, которое нужно проверить
//	ТекОтбор      - Отбор, в котором происходит проверка
// Возвращаемое значение:
//	Булево        - Истина, если попадает
//
Функция вВходитВОтбор(ТекЗначение, ТекОтбор) Экспорт
	ЗначениеОтбора = ТекОтбор.Значение;
	ВходитВОтбор = Ложь;
	Если ТекОтбор.Использование = Ложь Тогда
		ВходитВОтбор = Истина;
	ИначеЕсли ТекОтбор.ВидСравнения = ВидСравнения.Равно Тогда
		Если ЗначениеОтбора = ТекЗначение Тогда
			ВходитВОтбор = Истина;
		КонецЕсли;
	ИначеЕсли ТекОтбор.ВидСравнения = ВидСравнения.НеРавно Тогда
		Если ЗначениеОтбора <> ТекЗначение Тогда
			ВходитВОтбор = Истина;
		КонецЕсли;
	ИначеЕсли ТекОтбор.ВидСравнения = ВидСравнения.Содержит Тогда
		Если Найти(ТекЗначение,ЗначениеОтбора) <> 0 Тогда
			ВходитВОтбор = Истина;
		КонецЕсли;
	ИначеЕсли ТекОтбор.ВидСравнения = ВидСравнения.ВСписке Тогда
		Если ЗначениеОтбора.НайтиПоЗначению(ТекЗначение) <> Неопределено Тогда
			ВходитВОтбор = Истина;
		КонецЕсли;
	ИначеЕсли ТекОтбор.ВидСравнения = ВидСравнения.НеВСписке Тогда
		Если ЗначениеОтбора.НайтиПоЗначению(ТекЗначение) = Неопределено Тогда
			ВходитВОтбор = Истина;
		КонецЕсли;
	КонецЕсли;
	Возврат ВходитВОтбор;
КонецФункции // ВходитВРтбор()

////////////////////////////////////////////////////////////////////////////////
// СЛУЖЕБНЫЕ ПРОЦЕДУРЫ

// Выводит сообщение об ошибке 
// Параметры:
//  ТекстСообщения - строка, текст сообщения.
//
Процедура вСообщитьОбОшибке(ТекстСообщения, Статус )
    Сообщить(ТекстСообщения, Статус);
КонецПроцедуры // вСообщитьОбОшибке()

// Устанавливает доступность элементов управления в зависимости от режима
//
Процедура вДоступностьКнопок() 
	БылКонтроль = ?(ТаблицаСсылок = Ложь,Ложь,Истина);
	ЭлементыФормы.ОсновныеДействияФормы.Кнопки.Контроль.Доступность = не БылКонтроль;
	ЭлементыФормы.УдаляемыеОбъекты.Колонки.Удалять.ТолькоПросмотр = БылКонтроль;
	ЭлементыФормы.КоманднаяПанельУдаляемыхОбъектов.Кнопки.УстановитьФлажки.Доступность = не БылКонтроль;
	ЭлементыФормы.КоманднаяПанельУдаляемыхОбъектов.Кнопки.СнятьФлажки.Доступность = не БылКонтроль;
	ЭлементыФормы.ПоказыватьОбъектыКоторыеМожноУдалить.Доступность = БылКонтроль;
	ЭлементыФормы.ПоказыватьОбъектыКоторыеНельзяУдалить.Доступность = БылКонтроль;
	ЭлементыФормы.ПоказыватьСсылкиУдаляемых.Доступность = БылКонтроль;
	ЭлементыФормы.ПоказыватьСсылкиНеудаляемых.Доступность = БылКонтроль;
	Если БылКонтроль Тогда
		ВозможноУдалить = Ложь;
		Для Каждого СтрокаУдаляемогоОбъекта из УдаляемыеОбъекты Цикл
			Если СтрокаУдаляемогоОбъекта.Удалять и СтрокаУдаляемогоОбъекта.Удаляется Тогда
				ВозможноУдалить = Истина;
				Прервать;
			КонецЕсли;
		КонецЦикла;
		ЭлементыФормы.ОсновныеДействияФормы.Кнопки.Удалить.Доступность = ВозможноУдалить;
	Иначе
		ЭлементыФормы.ОсновныеДействияФормы.Кнопки.Удалить.Доступность = Ложь;
	КонецЕсли;
КонецПроцедуры

// Выполняет поиск помеченных на удаление объектов
// и заполняет ими таблицу УдаляемыеОбъекты
//
Функция вОбновитьПомеченныеНаУдаление()
	Состояние("Выполняется поиск объектов, помеченных на удаление...");
	ПоказыватьОбъектыКоторыеМожноУдалить = Истина;
	ПоказыватьОбъектыКоторыеНельзяУдалить = Истина;
	ПоказыватьСсылкиУдаляемых = Истина;
	ПоказыватьСсылкиНеудаляемых = Истина;
	СсылкиНаУдаляемыеОбъекты.Очистить();
	ТаблицаСсылок = Ложь;
	УдаляемыеОбъекты.Очистить();
	СоответствиеТипаКМетаданному = Новый Соответствие;
	
	Попытка
		МассивКУдалению = НайтиПомеченныеНаУдаление();
	Исключение
		Предупреждение("У пользователя не достаточно прав на выполнение операции.");
		Возврат Ложь;
	КонецПопытки;
	
	Для каждого УдаляемыйОбъект из МассивКУдалению цикл
		СтрокаУдаляемогоОбъекта = УдаляемыеОбъекты.Добавить();
		СтрокаУдаляемогоОбъекта.ссылка = УдаляемыйОбъект;
		СтрокаУдаляемогоОбъекта.ПредставлениеСсылки = УдаляемыйОбъект;
		ТипУдаляемогоОбъекта = ТипЗНЧ(УдаляемыйОбъект);
		ИмяМетаданного = СоответствиеТипаКМетаданному[ТипУдаляемогоОбъекта];
		Если ИмяМетаданного = Неопределено Тогда
			ИмяМетаданного = УдаляемыйОбъект.Метаданные().ПолноеИмя();
			СоответствиеТипаКМетаданному.Вставить(ТипУдаляемогоОбъекта,ИмяМетаданного);
		КонецЕсли;
		СтрокаУдаляемогоОбъекта.Метаданные = ИмяМетаданного;
		СтрокаУдаляемогоОбъекта.Удалять = Истина;
		СтрокаУдаляемогоОбъекта.Удаляется = Истина;
		СтрокаУдаляемогоОбъекта.ИндексКартинки = 1;
	КонецЦикла;
	ЭлементыФормы.УдаляемыеОбъекты.ОтборСтрок.Сбросить();
	вДоступностьКнопок();
	вПодсчитатьИтогУдаляемыеОбъекты();
	Возврат Истина;
КонецФункции

// Выполняет поиск ссылок на помеченные на удаление объекты,
// заполняет ими таблицу значений "ТаблицаСсылок",
// производит контроль на возможность удаления
//
Процедура вКонтроль()
	ЕстьПомеченныеНеВОтборе = Ложь;
	ТекОтбор = ЭлементыФормы.УдаляемыеОбъекты.ОтборСтрок.Метаданные;
	Для Каждого СтрокаУдаляемогоОбъекта из УдаляемыеОбъекты Цикл
		Если СтрокаУдаляемогоОбъекта.Удалять  Тогда
			Если Не вВходитВОтбор(СтрокаУдаляемогоОбъекта.Метаданные,ТекОтбор) Тогда
				ЕстьПомеченныеНеВОтборе = Истина;
			КонецЕсли;
		КонецЕсли;
	КонецЦикла;
	Если ЕстьПомеченныеНеВОтборе Тогда
		Ответ = Вопрос("Существуют выбранные записи не попавшие в текущий отбор.
		|Снять флажки у непопавших в отбор?", РежимДиалогаВопрос.ДаНетОтмена);
		Если Ответ = КодВозвратаДиалога.Отмена Тогда
			Возврат;
		ИначеЕсли Ответ = КодВозвратаДиалога.Да Тогда
			Для Каждого СтрокаУдаляемогоОбъекта из УдаляемыеОбъекты Цикл
				Если СтрокаУдаляемогоОбъекта.Удалять  Тогда
					Если Не вВходитВОтбор(СтрокаУдаляемогоОбъекта.Метаданные,ТекОтбор) Тогда
						СтрокаУдаляемогоОбъекта.Удалять = Ложь;
					КонецЕсли;
				КонецЕсли;
			КонецЦикла;
		КонецЕсли;
	КонецЕсли;
	Состояние("Выполняется поиск ссылок на объекты, помеченные на удаление...");
	МассивКУдалению = Новый Массив;
	Для Каждого СтрокаУдаляемогоОбъекта из УдаляемыеОбъекты Цикл
		Если СтрокаУдаляемогоОбъекта.Удалять  Тогда
			МассивКУдалению.Добавить(СтрокаУдаляемогоОбъекта.Ссылка);
			СтрокаУдаляемогоОбъекта.Удаляется = Истина;
		Иначе
			СтрокаУдаляемогоОбъекта.Удаляется = Ложь;
		КонецЕсли;
		СтрокаУдаляемогоОбъекта.НеУдаляемыхСсылок = 0;
		СтрокаУдаляемогоОбъекта.Ссылок = 0;
	КонецЦикла;
	СсылкиНаУдаляемыеОбъекты.Очистить();
	ТаблицаСсылок = НайтиПоСсылкам(МассивКУдалению);
	ТаблицаСсылок.Колонки.Добавить("СтрокаУдаляемого");
	ТаблицаСсылок.Колонки.Добавить("СтрокаДанного");
	ТаблицаСсылок.Колонки.Добавить("ИндексКартинки");
	ТаблицаСсылок.Колонки.Добавить("Удаляется");

	Для каждого ЭлементТаблицыСсылок из ТаблицаСсылок Цикл
		Ссылка = ЭлементТаблицыСсылок.ссылка;
		Данные = ЭлементТаблицыСсылок.Данные;
		СтрокаСсылки = УдаляемыеОбъекты.Найти(Ссылка,"Ссылка");
		МетаданныеДанных = ЭлементТаблицыСсылок.Метаданные;
		ИмяМетаданных = МетаданныеДанных.ПолноеИмя();
		
		Если Лев(ИмяМетаданных,15) = "РегистрСведений" Тогда
			ИзмеренияРегистраСведений = МетаданныеДанных.Измерения;
			УдаляетсяРегистрСведений = Ложь;
			Для Каждого Измерение Из ИзмеренияРегистраСведений Цикл
				Если Измерение.Ведущее Тогда
					Если Ссылка = Данные[Измерение.Имя] Тогда
						УдаляетсяРегистрСведений = Истина;
						ЭлементТаблицыСсылок.Данные = ссылка;
						Данные = ссылка;
						Прервать;
					КонецЕсли;
				КонецЕсли;
			КонецЦикла;
			Если Не УдаляетсяРегистрСведений Тогда
				ЭлементТаблицыСсылок.Данные = Неопределено;
				Данные = Неопределено;
			КонецЕсли;
		КонецЕсли;

		Если Данные = Неопределено Тогда
			ЭлементТаблицыСсылок.ИндексКартинки = 3;
			СтрокаДанного = Неопределено;
		Иначе
			СтрокаДанного = ?(Данные = Ссылка,СтрокаСсылки,УдаляемыеОбъекты.Найти(Данные,"Ссылка"));
			ЭлементТаблицыСсылок.ИндексКартинки =?(Данные.ПометкаУдаления,1,0);
		КонецЕсли;
		СтрокаСсылки.Ссылок = СтрокаСсылки.Ссылок + 1;
		УдаляетсяСсылка = СтрокаСсылки.Удаляется;
		Если СтрокаДанного = Неопределено Тогда
			УдаляетсяДанное = Ложь;
			Если УдаляетсяСсылка Тогда
				СтрокаСсылки.Удаляется = Ложь;
			КонецЕсли;
		Иначе
			УдаляетсяДанное = СтрокаДанного.Удаляется;
			Если Не УдаляетсяДанное Тогда
				Если УдаляетсяСсылка Тогда
					СтрокаСсылки.Удаляется = ложь;
				КонецЕсли;
			КонецЕсли;
		КонецЕсли;
		Если УдаляетсяДанное = ложь Тогда
			СтрокаСсылки.НеУдаляемыхСсылок = СтрокаСсылки.НеУдаляемыхСсылок + 1;
		КонецЕсли;
		ЭлементТаблицыСсылок.Удаляется = УдаляетсяДанное;
		ЭлементТаблицыСсылок.СтрокаУдаляемого = СтрокаСсылки;
		ЭлементТаблицыСсылок.СтрокаДанного = СтрокаДанного;
	КонецЦикла;
	НашлиДляИсключения = Истина;
	Пока НашлиДляИсключения Цикл
		НашлиДляИсключения = Ложь;
		Для каждого ЭлементТаблицыСсылок из ТаблицаСсылок Цикл
			СтрокаДанного = ЭлементТаблицыСсылок.СтрокаДанного;
			Если  СтрокаДанного <> Неопределено Тогда
				УдаляетсяДанное = СтрокаДанного.Удаляется;
				Удаляется = ЭлементТаблицыСсылок.Удаляется;
				СтрокаСсылки = ЭлементТаблицыСсылок.СтрокаУдаляемого;
				УдаляетсяСсылка = СтрокаСсылки.Удаляется;
				Если Удаляется и Не УдаляетсяДанное  Тогда
					ЭлементТаблицыСсылок.Удаляется = Ложь;
					СтрокаСсылки.НеУдаляемыхСсылок = СтрокаСсылки.НеУдаляемыхСсылок + 1;
				КонецЕсли;
				Если УдаляетсяСсылка И Не УдаляетсяДанное Тогда
					СтрокаСсылки.Удаляется = ложь;
					НашлиДляИсключения = Истина;
				КонецЕсли;
			КонецЕсли;
		КонецЦикла;
	КонецЦикла;
	вДоступностьКнопок();
	вПодсчитатьИтогУдаляемыеОбъекты();
	вПодсчитатьИтогСсылкиНаУдаляемыеОбъекты();
	вПоказатьСсылкиНаУдаляемыйОбъект();
КонецПроцедуры

// Выполняет удаление помеченные объектов,
// Которые возможно удалить
//
Процедура вУдалить()
	ЕстьПомеченныеНеВОтборе = Ложь;
	ТекОтбор = ЭлементыФормы.УдаляемыеОбъекты.ОтборСтрок.Метаданные;
	Для Каждого СтрокаУдаляемогоОбъекта из УдаляемыеОбъекты Цикл
		Если СтрокаУдаляемогоОбъекта.Удалять  Тогда
			Если не вВходитВОтбор(СтрокаУдаляемогоОбъекта.Метаданные,ТекОтбор) Тогда
				ЕстьПомеченныеНеВОтборе = Истина;
			КонецЕсли;
		КонецЕсли;
	КонецЦикла;
	Если ЕстьПомеченныеНеВОтборе Тогда
		Если Вопрос("Существуют выбранные записи не попавшие в текущий отбор
		|Продолжить?", РежимДиалогаВопрос.ДаНет) = КодВозвратаДиалога.Нет Тогда
			Возврат;
		КонецЕсли;
	КонецЕсли;
	вСообщитьОбОшибке("---------------------- Удаление объектов -----------------------",);
	Удалено = 0;
	НеУдалено = 0;
	СтруктураОтбора = Новый Структура;
	СтруктураОтбора.Вставить("Удаляется",Истина);
	МассивУдаляемых = УдаляемыеОбъекты.НайтиСтроки(СтруктураОтбора);
	СтруктураОтбора.Очистить();
	Для Каждого СтрокаУдаляемогоОбъекта из МассивУдаляемых Цикл
		Ссылка = СтрокаУдаляемогоОбъекта.Ссылка;
		Объект = Ссылка.ПолучитьОбъект();
		
		Попытка 
			
			Если Не Объект = Неопределено Тогда
				Объект.Удалить();
			КонецЕсли;
			
			вСообщитьОбОшибке("Удален объект :"+СокрЛП(СтрокаУдаляемогоОбъекта.Метаданные)+": "+СтрокаУдаляемогоОбъекта.ПредставлениеСсылки,СтатусСообщения.Информация);
			УдаляемыеОбъекты.Удалить(СтрокаУдаляемогоОбъекта);
			СтруктураОтбора.Вставить("Ссылка",Ссылка);
			МассивСсылок = ТаблицаСсылок.НайтиСтроки(СтруктураОтбора);
			Для Каждого СтрокаСсылки из МассивСсылок Цикл
				ТаблицаСсылок.Удалить(СтрокаСсылки);
			КонецЦикла;
			Удалено = Удалено+1;
		Исключение
			вСообщитьОбОшибке("Не удален объект :"+СокрЛП(СтрокаУдаляемогоОбъекта.Метаданные)+": "+СтрокаУдаляемогоОбъекта.ПредставлениеСсылки,СтатусСообщения.Важное);
			вСообщитьОбОшибке("         "+ОписаниеОшибки(),СтатусСообщения.Важное);
			НеУдалено = НеУдалено+1;
		КонецПопытки;
		
	КонецЦикла;
	вСообщитьОбОшибке("Удаление объектов закончено. Удалено объектов : "+Удалено
	+?(НеУдалено <> 0,"   Не удалено объектов : "+НеУдалено,""),);
	вДоступностьКнопок();
	
КонецПроцедуры // вУдалить() 

// Подсчитывает количество Помеченных, Выбранных, Удаляемых и НеУдаляемых объектов
//
Процедура вПодсчитатьИтогУдаляемыеОбъекты()
	ТекстНадписи =  "Помечено: "+УдаляемыеОбъекты.Количество()
	+"   Выбрано "+УдаляемыеОбъекты.итог("Удалять");
	Если ТаблицаСсылок <> Ложь Тогда
		ВозможноУдалить = 0;
		Для Каждого СтрокаУдаляемогоОбъекта из УдаляемыеОбъекты Цикл
			Если СтрокаУдаляемогоОбъекта.Удалять и СтрокаУдаляемогоОбъекта.Удаляется Тогда
				ВозможноУдалить = ВозможноУдалить+1;
			КонецЕсли;
		КонецЦикла;
		ТекстНадписи = ТекстНадписи +"   Возможно удалить: "+ВозможноУдалить
		+"   Невозможно удалить: "+(УдаляемыеОбъекты.Количество()-ВозможноУдалить);
	КонецЕсли;
	ЭлементыФормы.НадписьОбъекты.Значение = ТекстНадписи;
КонецПроцедуры

// Подсчитывает количество Найденных, Удаляемых и НеУдаляемых ссылок на текущий объектов
//
Процедура вПодсчитатьИтогСсылкиНаУдаляемыеОбъекты()
	СтрокаУдаляемыхОбъектов = ЭлементыФормы.УдаляемыеОбъекты.ТекущиеДанные;
	Если СтрокаУдаляемыхОбъектов = Неопределено или ТаблицаСсылок = Ложь Тогда
		ЭлементыФормы.НадписьСсылки.Значение = "";
	Иначе
		ЭлементыФормы.НадписьСсылки.Значение = "Найдено: " + СтрокаУдаляемыхОбъектов.Ссылок
		+ "     Удаляемых: " + (СтрокаУдаляемыхОбъектов.Ссылок-СтрокаУдаляемыхОбъектов.НеУдаляемыхСсылок)
		+ "     Неудаляемых: " + СтрокаУдаляемыхОбъектов.НеУдаляемыхСсылок;
	КонецЕсли;
КонецПроцедуры

// Показывает ссылки в таблице СсылкиНаУдаляемыеОбъекты
// на текущий удаляемый объект из таблицы УдаляемыеОбъекты
//
Процедура вПоказатьСсылкиНаУдаляемыйОбъект()
	СтрокаУдаляемыхОбъектов = ЭлементыФормы.УдаляемыеОбъекты.ТекущиеДанные;
	СсылкиНаУдаляемыеОбъекты.Очистить();
	Если ТаблицаСсылок = Ложь или СтрокаУдаляемыхОбъектов = Неопределено Тогда
		
	Иначе
		МассивСсылок = ТаблицаСсылок.НайтиСтроки(Новый Структура("Ссылка",СтрокаУдаляемыхОбъектов.Ссылка));
		Для каждого Строка Из МассивСсылок Цикл
			НоваяСтрока = СсылкиНаУдаляемыеОбъекты.Добавить();
			НоваяСтрока.Ссылка = Строка.Ссылка;
			НоваяСтрока.Данные = Строка.Данные;
			НоваяСтрока.Метаданные = Строка.Метаданные.ПолноеИмя();
			НоваяСтрока.ИндексКартинки = Строка.ИндексКартинки;
			НоваяСтрока.Удалять = Истина;
			НоваяСтрока.Удаляется = Строка.Удаляется;
		КонецЦикла;
	КонецЕсли;
	вПодсчитатьИтогСсылкиНаУдаляемыеОбъекты();
КонецПроцедуры // () 

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ФОРМЫ

// Процедура - обработчик события "ПередОткрытием" формы
//
Процедура ПередОткрытием(Отказ, СтандартнаяОбработка)
	
	Ответ = Вопрос("Подготовка к удалению помеченных объектов может занять продолжительное время!
	|Продолжить выполнение операции?", РежимДиалогаВопрос.ДаНет);
	Если Ответ = КодВозвратаДиалога.Да Тогда
		
		Если Не вОбновитьПомеченныеНаУдаление() Тогда
			Отказ = Истина;
		КонецЕсли;
		
		ЭлементыФормы.УдаляемыеОбъекты.НастройкаОтбораСтрок.Ссылка.Доступность = Ложь;
		
	Иначе
		Отказ = Истина;
	КонецЕсли;
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ЭЛЕМЕНТОВ ФОРМЫ

// Процедура вызывается при нажатии кнопки "Контроль" Основных действий формы,
//
Процедура ОсновныеДействияФормыКонтроль(Кнопка)
	Ответ = Вопрос("Выполнить после ""Контроля""   ""Удаление"" объектов, которые возможно удалить?", РежимДиалогаВопрос.ДаНетОтмена);
	Если Ответ <>  КодВозвратаДиалога.Отмена Тогда
		вКонтроль();
		Если Не ТаблицаСсылок = Ложь и Ответ = КодВозвратаДиалога.Да Тогда
			вУдалить();
		КонецЕсли;
	КонецЕсли;
КонецПроцедуры

// Процедура вызывается при нажатии кнопки "Удалить" Основных действий формы,
//
Процедура ОсновныеДействияФормыУдалить(Кнопка)
	вУдалить();
КонецПроцедуры

// Процедура вызывается при изменении флажков:
//	ПоказыватьОбъектыКоторыеМожноУдалить,ПоказыватьОбъектыКоторыеНельзяУдалить
//
Процедура ПоказыватьОбъектыПриИзменении(Элемент)
	ОтборСтрок = ЭлементыФормы.УдаляемыеОбъекты.ОтборСтрок;
	Если ПоказыватьОбъектыКоторыеМожноУдалить и ПоказыватьОбъектыКоторыеНельзяУдалить тогда
		ОтборСтрок.Удаляется.Использование = Ложь;
		ОтборСтрок.Удалять.Использование = Ложь;
	ИначеЕсли не ПоказыватьОбъектыКоторыеМожноУдалить и не ПоказыватьОбъектыКоторыеНельзяУдалить тогда
		ОтборСтрок.Удаляется.Установить(Истина,Истина);
		ОтборСтрок.Удалять.Установить(Ложь,Истина);
	ИначеЕсли ПоказыватьОбъектыКоторыеНельзяУдалить тогда
		ОтборСтрок.Удаляется.Установить(Ложь,Истина);
		ОтборСтрок.Удалять.Использование = Ложь;
	Иначе
		ОтборСтрок.Удаляется.Установить(Истина,Истина);
		ОтборСтрок.Удалять.Использование = Ложь;
	КонецЕсли;
КонецПроцедуры

// Процедура вызывается при изменении флажков:
//	ПоказыватьСсылкиУдаляемых,ПоказыватьСсылкиНеудаляемых
//
Процедура ПоказыватьСсылкиПриИзменении(Элемент)
	Если ПоказыватьСсылкиУдаляемых = ПоказыватьСсылкиНеудаляемых тогда
		ЭлементыФормы.СсылкиНаУдаляемыеОбъекты.ОтборСтрок.Удаляется.Использование = Ложь;
		ЭлементыФормы.СсылкиНаУдаляемыеОбъекты.ОтборСтрок.Удалять.Установить(ПоказыватьСсылкиУдаляемых,Истина);
	Иначе
		ЭлементыФормы.СсылкиНаУдаляемыеОбъекты.ОтборСтрок.Удалять.Использование = Ложь;
		ЭлементыФормы.СсылкиНаУдаляемыеОбъекты.ОтборСтрок.Удаляется.Установить(ПоказыватьСсылкиУдаляемых,Истина);
	КонецЕсли;
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ КОМАНДНОЙ ПАНЕЛИ "КоманднаяПанельУдаляемыхОбъектов"

// Процедура вызывается при нажатии кнопки "Обновить" командной панели "Удаляемые Объекты"
//
Процедура КоманднаяПанельУдаляемыхОбъектовОбновить(Кнопка)
	вОбновитьПомеченныеНаУдаление()
КонецПроцедуры

// Процедура вызывается при нажатии кнопки "Установить Флажки" командной панели "Удаляемые Объекты"
//
Процедура КоманднаяПанельУдаляемыхОбъектовУстановитьФлажки(Кнопка)
	ТекОтбор = ЭлементыФормы.УдаляемыеОбъекты.ОтборСтрок.Метаданные;
	Для каждого СтрокаУдаляемогоОбъекта Из УдаляемыеОбъекты Цикл
		Если вВходитВОтбор(СтрокаУдаляемогоОбъекта.Метаданные,ТекОтбор) Тогда
			СтрокаУдаляемогоОбъекта.Удалять = Истина;
		КонецЕсли;
	КонецЦикла;
	вПодсчитатьИтогУдаляемыеОбъекты();
КонецПроцедуры

// Процедура вызывается при нажатии кнопки "Снять Флажки" командной панели "Удаляемые Объекты"
//
Процедура КоманднаяПанельУдаляемыхОбъектовСнятьФлажки(Кнопка)
	Для каждого СтрокаУдаляемогоОбъекта Из УдаляемыеОбъекты Цикл
		СтрокаУдаляемогоОбъекта.Удалять = Ложь;
	КонецЦикла;
	вПодсчитатьИтогУдаляемыеОбъекты();
КонецПроцедуры

// Процедура вызывается при нажатии кнопки "Отбор по категориям" командной панели "Удаляемые Объекты",
//	и открывает модальную форму "ВыборОбъектовДляОтбора"
//
Процедура КоманднаяПанельУдаляемыхОбъектовОтборПоОбъектамМетаданных(Кнопка)
	ЭтотОбъект.ПолучитьФорму("ФормаУдалениеПомеченныхОбъектовВыборОбъектовДляОтбора",ЭтаФорма).ОткрытьМодально();
	ТекОтбор = ЭлементыФормы.УдаляемыеОбъекты.ОтборСтрок.Метаданные;
	БылОтбор = ТекОтбор.Использование;
	ТекОтбор.Использование = Не БылОтбор;
	ТекОтбор.Использование = БылОтбор;
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ТАБЛИЧНОЙ ЧАСТИ "Удаляемые Объекты"

// Процедура вызывается при активизации строки табличного поля "Удаляемые объекты"
//
Процедура УдаляемыеОбъектыПриАктивизацииСтроки(Элемент)
	вПоказатьСсылкиНаУдаляемыйОбъект();
КонецПроцедуры

// Процедура вызывается при выоде строки табличного поля "Удаляемые объекты"
//
Процедура УдаляемыеОбъектыПриВыводеСтроки(Элемент, ОформлениеСтроки, ДанныеСтроки)
	ЯчейкаКартинки = ОформлениеСтроки.Ячейки.Картинка;
	ЯчейкаКартинки.ИндексКартинки = ДанныеСтроки . ИндексКартинки;
	Если ТаблицаСсылок <> Ложь и ДанныеСтроки.Удалять Тогда
		Если ДанныеСтроки.Удаляется Тогда
			ОформлениеСтроки.Ячейки.Удалять.ЦветТекста = WebЦвета.ВесеннеЗеленый;
		Иначе
			ОформлениеСтроки.Ячейки.Удалять.ЦветТекста = WebЦвета.Красный;
		КонецЕсли;
	КонецЕсли;
КонецПроцедуры

// Процедура вызывается перед началом изменения табличного поля "Удаляемые объекты"
//
Процедура УдаляемыеОбъектыПередНачаломИзменения(Элемент, Отказ)
	Если Элемент.ТекущаяКолонка.ДанныеФлажка <> "Удалять" Тогда
		ФормаОбъекта = ЭлементыФормы.УдаляемыеОбъекты.ТекущиеДанные.ссылка.ПолучитьФорму(,,);
		ФормаОбъекта.Открыть();
		Отказ = Истина;
	КонецЕсли;
КонецПроцедуры

// Процедура вызывается при изменении флажка табличного поля "Удаляемые объекты"
//
Процедура УдаляемыеОбъектыПриИзмененииФлажка(Элемент, Колонка)
	вПодсчитатьИтогУдаляемыеОбъекты();
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ТАБЛИЧНОЙ ЧАСТИ "Ссылки на удаляемые объекты"

// Процедура вызывается при выоде строки табличного поля "Ссылки на удаляемые объекты"
//
Процедура СсылкиНаУдаляемыеОбъектыПриВыводеСтроки(Элемент, ОформлениеСтроки, ДанныеСтроки)
	Ячейки = ОформлениеСтроки.Ячейки;
	Ячейки.Удалять.ОтображатьТекст = Ложь;
	Если ДанныеСтроки.Удаляется Тогда
		Ячейки.Удалять.ЦветТекста = WebЦвета.ВесеннеЗеленый;
	Иначе
		Ячейки.Удалять.ЦветТекста = WebЦвета.Красный;
	КонецЕсли;
	Ячейки.Картинка.ИндексКартинки = ДанныеСтроки.ИндексКартинки;
КонецПроцедуры

// Процедура вызывается перед началом изменения строки табличного поля "Ссылки на удаляемые объекты"
//
Процедура СсылкиНаУдаляемыеОбъектыПередНачаломИзменения(Элемент, Отказ)
	Если ЭлементыФормы.СсылкиНаУдаляемыеОбъекты.ТекущиеДанные <> Неопределено Тогда
		Данные = ЭлементыФормы.СсылкиНаУдаляемыеОбъекты.ТекущиеДанные.Данные;
		Если Данные <> Неопределено Тогда
			ФормаОбъекта = Данные.ПолучитьФорму(,,);
			ФормаОбъекта.Открыть();
		КонецЕсли;
	КонецЕсли;
	Отказ = Истина;
КонецПроцедуры
