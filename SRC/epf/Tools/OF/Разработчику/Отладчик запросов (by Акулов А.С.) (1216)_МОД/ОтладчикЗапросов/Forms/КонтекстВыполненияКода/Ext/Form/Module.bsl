﻿Перем ОписаниеОшибки Экспорт;

Функция ПерепровестиДокумент(Док, ВТранзакции=Истина)
	Попытка
		Если не Док.Проведен Тогда
			Возврат Ложь;
		КонецЕсли;
	Исключение
		Возврат Истина;
	КонецПопытки;
	Если ВТранзакции Тогда
		НачатьТранзакцию();
	КонецЕсли;
	Попытка
		ДокОбъект = ?(ТипЗнч(Док)=Тип("ДокументОбъект."+Док.Метаданные().Имя), Док, Док.Ссылка.ПолучитьОбъект());
		ДокОбъект.Записать(РежимЗаписиДокумента.ОтменаПроведения);
		ДокОбъект.Записать(РежимЗаписиДокумента.Проведение, РежимПроведенияДокумента.Неоперативный);
		Если ВТранзакции и ТранзакцияАктивна()	Тогда
			ЗафиксироватьТранзакцию();
		КонецЕсли;
		Возврат Истина;
	Исключение
		Если ВТранзакции и ТранзакцияАктивна() Тогда
			ОтменитьТранзакцию();
		КонецЕсли;
		Возврат Ложь;
	КонецПопытки;
КонецФункции

Функция ВыполнитьЛокально(Код) Экспорт
	Попытка
		ОписаниеОшибки = Неопределено;
		Выполнить(Код);
		ОписаниеОшибки = "";
		Возврат Истина;
	Исключение
		ОписаниеОшибки = ОписаниеОшибки();
		Возврат Ложь;
	КонецПопытки;
КонецФункции

Функция ПростоВыполнитьКод(Код) Экспорт
	Выполнить(Код);
	Возврат Истина;
КонецФункции

Функция ВыполнитьКодУстановкиПараметров(Запрос, Код, Параметры) Экспорт
	Выполнить(Код);
	Возврат Истина;
КонецФункции
