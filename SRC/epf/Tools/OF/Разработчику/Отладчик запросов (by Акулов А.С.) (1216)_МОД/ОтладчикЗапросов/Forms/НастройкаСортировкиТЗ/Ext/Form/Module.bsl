﻿
Процедура НачальноеЗаполнение(ТЗ) Экспорт
	Настройки = Новый ТаблицаЗначений;
	Настройки.Колонки.Добавить("Выбран", Новый ОписаниеТипов("Булево"));
	Настройки.Колонки.Добавить("ИмяКолонки", Новый ОписаниеТипов("Строка", ,Новый КвалификаторыСтроки(200, ДопустимаяДлина.Переменная)));
	Настройки.Колонки.Добавить("НаправлениеСортировки", Новый ОписаниеТипов("НаправлениеСортировки"));
	КолонкиТЗ = ?(ТипЗнч(ТЗ)=Тип("ТаблицаЗначений"), ТЗ.Колонки, ТЗ);
	Для каждого Колонка Из КолонкиТЗ Цикл
		НС = Настройки.Добавить();
		НС.Выбран = Ложь;
		НС.ИмяКолонки = Колонка.Имя;
		НС.НаправлениеСортировки = НаправлениеСортировки.Возр;
	КонецЦикла;
КонецПроцедуры

Процедура КнопкаВыполнитьНажатие(Кнопка)
	Ответ = "";
	Для каждого Строчка Из Настройки Цикл
		Если Строчка.Выбран Тогда
			Ответ = ?(Ответ="", "", Ответ+",")+Строчка.ИмяКолонки+?(Строчка.НаправлениеСортировки=НаправлениеСортировки.Убыв, " Убыв", "");
		КонецЕсли;
	КонецЦикла;
	Закрыть(Ответ);
КонецПроцедуры
