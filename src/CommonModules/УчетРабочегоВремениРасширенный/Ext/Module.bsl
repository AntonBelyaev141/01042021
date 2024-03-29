﻿#Область АБ_Доработка2_ЧтобыМожноБылоВводитьТабельНочныхЧасовКакВ_77

&ИзменениеИКонтроль("ПроверитьСоответствиеРегистрируемыхЧасовДлинеСуток")
Процедура АБ_ПроверитьСоответствиеРегистрируемыхЧасовДлинеСуток(МенеджерВТ, ОписанияОшибокВводаВремени, Отказ) Экспорт
	Запрос = Новый Запрос;
	Запрос.МенеджерВременныхТаблиц = МенеджерВТ;
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	ДанныеОВремени.Дата КАК Дата,
	|	ДанныеОВремени.Сотрудник КАК Сотрудник,
	|	Сотрудники.Наименование КАК СотрудникНаименование,
	|	СУММА(ДанныеОВремени.Часов) КАК Часов
	|ИЗ
	|	ВТДанныеОВремени КАК ДанныеОВремени
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Справочник.ВидыИспользованияРабочегоВремени КАК ВидыИспользованияРабочегоВремени
	|		ПО ДанныеОВремени.ВидВремени = ВидыИспользованияРабочегоВремени.Ссылка
	|			И (ВидыИспользованияРабочегоВремени.ОсновноеВремя <> ЗНАЧЕНИЕ(Справочник.ВидыИспользованияРабочегоВремени.ПустаяСсылка))
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Справочник.Сотрудники КАК Сотрудники
	|		ПО ДанныеОВремени.Сотрудник = Сотрудники.Ссылка
	|
	|СГРУППИРОВАТЬ ПО
	|	ДанныеОВремени.Дата,
	|	ДанныеОВремени.ПереходящаяЧастьСмены,
	|	ДанныеОВремени.Сотрудник,
	|	Сотрудники.Наименование
	#Удаление
	|
	|ИМЕЮЩИЕ
	|	(СУММА(ДанныеОВремени.Часов) > 24
	|		ИЛИ СУММА(ДанныеОВремени.Часов) < 0)";
	#КонецУдаления
	#Вставка
	//1АБ Беляев 08.03.2021 + 
	|
	|ИМЕЮЩИЕ
	|	(СУММА(ДанныеОВремени.Часов) > 24
	|		ИЛИ СУММА(ДанныеОВремени.Часов) < 0)
	|И Ложь";
	//1АБ Беляев 08.03.2021 -
	#КонецВставки

	УстановитьПривилегированныйРежим(Истина);
	Выборка = Запрос.Выполнить().Выбрать();
	УстановитьПривилегированныйРежим(Ложь);

	ТекстОшибкиПревышениеШаблон = НСтр("ru = '%1: за %2 зарегистрировано более 24 часов.'");
	ТекстОшибкиОтрицательныеЧасыШаблон = НСтр("ru = '%1: за %2 зарегистрировано отрицательное число часов.'");


	Пока Выборка.Следующий() Цикл
		Отказ = Истина;		

		ОписаниеОшибкиВводаВремени = НовыйОписаниеОшибкиВводаВремени();

		ОписаниеОшибкиВводаВремени.Сотрудник = Выборка.Сотрудник;

		Если Выборка.Часов > 24 Тогда 
			ТекстОшибкиШаблон = ТекстОшибкиПревышениеШаблон;
		Иначе
			ТекстОшибкиШаблон = ТекстОшибкиОтрицательныеЧасыШаблон;
		КонецЕсли;	

		ТекстОшибки = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(ТекстОшибкиШаблон, Выборка.СотрудникНаименование,
		Формат(Выборка.Дата, "ДФ='dd.MM.yyyy ""г.""'"));

		ОписаниеОшибкиВводаВремени.ТекстОшибки = ТекстОшибки;	

		ОписаниеОшибкиВводаВремени.Дата = Выборка.Дата;

		ОписанияОшибокВводаВремени.Добавить(ОписаниеОшибкиВводаВремени);
	КонецЦикла;	

КонецПроцедуры

&ИзменениеИКонтроль("ПроверитьРегистрациюЦелосменногоВремени")
Процедура АБ_ПроверитьРегистрациюЦелосменногоВремени(МенеджерВТ, ОписанияОшибокВводаВремени, Отказ) Экспорт

	Запрос = Новый Запрос;
	Запрос.МенеджерВременныхТаблиц = МенеджерВТ;
	Запрос.Текст = 
	"ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	ДанныеОВремениЦелосменное.Дата КАК Дата,
	|	ДанныеОВремениЦелосменное.Сотрудник КАК Сотрудник,
	|	ДанныеОВремениЦелосменное.ВидВремени КАК ВидВремени,
	|	ВидыИспользованияРабочегоВремени.Наименование КАК ВидВремениНаименование,
	|	Сотрудники.Наименование КАК СотрудникНаименование
	|ИЗ
	|	ВТДанныеОВремени КАК ДанныеОВремениЦелосменное
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Справочник.ВидыИспользованияРабочегоВремени КАК ВидыИспользованияРабочегоВремени
	|		ПО ДанныеОВремениЦелосменное.ВидВремени = ВидыИспользованияРабочегоВремени.Ссылка
	|			И (ВидыИспользованияРабочегоВремени.Целосменное)
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ ВТДанныеОВремени КАК ДанныеОВремениДополнительно
	|		ПО ДанныеОВремениЦелосменное.Дата = ДанныеОВремениДополнительно.Дата
	|			И ДанныеОВремениЦелосменное.Сотрудник = ДанныеОВремениДополнительно.Сотрудник
	|			И ДанныеОВремениЦелосменное.ВидВремени <> ДанныеОВремениДополнительно.ВидВремени
	|			И (НЕ ДанныеОВремениДополнительно.ПереходящаяЧастьСмены
	|				ИЛИ ДанныеОВремениДополнительно.ОтражатьЧасыВДеньНачалаСмены)
	|			И ДанныеОВремениЦелосменное.ВидВремени <> ДанныеОВремениДополнительно.ВидВремени
	|		ЛЕВОЕ СОЕДИНЕНИЕ Справочник.Сотрудники КАК Сотрудники
	|		ПО ДанныеОВремениЦелосменное.Сотрудник = Сотрудники.Ссылка
	#Удаление
	|ГДЕ
	|	НЕ Сотрудники.Ссылка ЕСТЬ NULL";
	#КонецУдаления
	#Вставка
	//1АБ Беляев 16.03.2021 +
	|ГДЕ
	|	НЕ Сотрудники.Ссылка ЕСТЬ NULL
	|И ЛОЖЬ";
	//1АБ Беляев 16.03.2021 -
	#КонецВставки

	УстановитьПривилегированныйРежим(Истина);
	Выборка = Запрос.Выполнить().Выбрать();
	УстановитьПривилегированныйРежим(Ложь);

	ТекстОшибкиШаблон = НСтр("ru = '%1: за %2 вместе с целосменным видом времени %3 не может быть введен другой вид времени.'");

	Пока Выборка.Следующий() Цикл
		Отказ = Истина;		

		ОписаниеОшибкиВводаВремени = НовыйОписаниеОшибкиВводаВремени();

		ОписаниеОшибкиВводаВремени.Сотрудник = Выборка.Сотрудник;
		ОписаниеОшибкиВводаВремени.ВидВремени = Выборка.ВидВремени;
		ТекстОшибки = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(ТекстОшибкиШаблон, Выборка.СотрудникНаименование,
		Формат(Выборка.Дата, "ДФ='dd.MM.yyyy ""г.""'"),
		Выборка.ВидВремениНаименование);

		ОписаниеОшибкиВводаВремени.ТекстОшибки = ТекстОшибки;	

		ОписаниеОшибкиВводаВремени.Дата = Выборка.Дата;

		ОписанияОшибокВводаВремени.Добавить(ОписаниеОшибкиВводаВремени);
	КонецЦикла;	
КонецПроцедуры

&ИзменениеИКонтроль("ПроверитьУникальностьВводаИтоговыхДанных")
Процедура АБ_ПроверитьУникальностьВводаИтоговыхДанных(МенеджерВТ, Регистратор, ПериодРегистрации, ОписанияОшибокВводаВремени, ПлановыеДанные)
	Запрос = Новый Запрос;
	Запрос.МенеджерВременныхТаблиц = МенеджерВТ;
	Запрос.УстановитьПараметр("План", ПлановыеДанные);
	Запрос.УстановитьПараметр("ПериодРегистрации", ПериодРегистрации);
	Запрос.УстановитьПараметр("Регистратор", Регистратор);
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	РабочееВремяСотрудников.Период КАК Период,
	|	РабочееВремяСотрудников.Регистратор КАК Регистратор,
	|	РабочееВремяСотрудников.Сотрудник КАК Сотрудник,
	|	РабочееВремяСотрудников.ВидУчетаВремени КАК ВидУчетаВремени,
	|	РабочееВремяСотрудников.Территория КАК Территория,
	|	РабочееВремяСотрудников.УсловияТруда КАК УсловияТруда,
	|	РабочееВремяСотрудников.ПереходящаяЧастьПредыдущейСмены КАК ПереходящаяЧастьПредыдущейСмены,
	|	РабочееВремяСотрудников.ПереходящаяЧастьТекущейСмены КАК ПереходящаяЧастьТекущейСмены,
	|	РабочееВремяСотрудников.Смена КАК Смена,
	|	РабочееВремяСотрудников.Организация КАК Организация
	|ПОМЕСТИТЬ ВТДанныеТабельногоУчетаБезОткрытыхСторноЗаписей
	|ИЗ
	|	РегистрНакопления.ДанныеТабельногоУчетаРабочегоВремениСотрудников КАК РабочееВремяСотрудников
	|ГДЕ
	|	РабочееВремяСотрудников.ПериодРегистрации = &ПериодРегистрации
	|	И РабочееВремяСотрудников.Регистратор <> &Регистратор
	|
	|СГРУППИРОВАТЬ ПО
	|	РабочееВремяСотрудников.ПереходящаяЧастьТекущейСмены,
	|	РабочееВремяСотрудников.Территория,
	|	РабочееВремяСотрудников.ВидУчетаВремени,
	|	РабочееВремяСотрудников.ПереходящаяЧастьПредыдущейСмены,
	|	РабочееВремяСотрудников.УсловияТруда,
	|	РабочееВремяСотрудников.Смена,
	|	РабочееВремяСотрудников.Организация,
	|	РабочееВремяСотрудников.Период,
	|	РабочееВремяСотрудников.Регистратор,
	|	РабочееВремяСотрудников.Сотрудник
	|
	|ИМЕЮЩИЕ
	|	СУММА(РабочееВремяСотрудников.Дни) >= 0 И
	|	СУММА(РабочееВремяСотрудников.Часы) >= 0
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	РабочееВремяСотрудников.Сотрудник КАК Сотрудник,
	|	РабочееВремяСотрудников.Сотрудник.Наименование КАК СотрудникНаименование,
	|	РабочееВремяСотрудников.Регистратор КАК Регистратор,
	|	ПРЕДСТАВЛЕНИЕ(РабочееВремяСотрудников.Регистратор) КАК РегистраторПредставление
	|ИЗ
	|	ВТДанныеОВремени КАК ДанныеОВремени
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ РегистрНакопления.ДанныеИндивидуальныхГрафиковСотрудников КАК РабочееВремяСотрудников
	|		ПО ДанныеОВремени.Сотрудник = РабочееВремяСотрудников.Сотрудник
	|			И ДанныеОВремени.Дата = РабочееВремяСотрудников.Период
	|			И (НЕ ДанныеОВремени.ПереходящаяЧастьСмены)
	|			И (НЕ РабочееВремяСотрудников.ПереходящаяЧастьПредыдущейСмены)
	|			И (&План)
	|			И (РабочееВремяСотрудников.ПериодРегистрации = &ПериодРегистрации)
	|			И (РабочееВремяСотрудников.Регистратор <> &Регистратор)
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	РабочееВремяСотрудников.Сотрудник,
	|	РабочееВремяСотрудников.Сотрудник.Наименование,
	|	РабочееВремяСотрудников.Регистратор,
	|	ПРЕДСТАВЛЕНИЕ(РабочееВремяСотрудников.Регистратор)
	|ИЗ
	|	ВТДанныеОВремени КАК ДанныеОВремени
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ ВТДанныеТабельногоУчетаБезОткрытыхСторноЗаписей КАК РабочееВремяСотрудников
	#Удаление
	|		ПО ДанныеОВремени.Сотрудник = РабочееВремяСотрудников.Сотрудник
	|			И ДанныеОВремени.Дата = РабочееВремяСотрудников.Период
	|			И (НЕ ДанныеОВремени.ПереходящаяЧастьСмены)
	|			И (НЕ РабочееВремяСотрудников.ПереходящаяЧастьПредыдущейСмены)
	|			И (НЕ &План)";
	#КонецУдаления
	#Вставка
	//1АБ Беляев 18.03.2021 + 
	|		ПО ДанныеОВремени.Сотрудник = РабочееВремяСотрудников.Сотрудник
	|			И ДанныеОВремени.Дата = РабочееВремяСотрудников.Период
	|			И (НЕ ДанныеОВремени.ПереходящаяЧастьСмены)
	|			И (НЕ РабочееВремяСотрудников.ПереходящаяЧастьПредыдущейСмены)
	|			И (НЕ &План)
	|			И (НЕ ДанныеОВремени.ВидВремени = &НочноеВремя)";
	Запрос.УстановитьПараметр("НочноеВремя",Справочники.ВидыИспользованияРабочегоВремени.РаботаНочныеЧасы);
	//1АБ Беляев 18.03.2021 -
	#КонецВставки

	УстановитьПривилегированныйРежим(Истина);
	Выборка = Запрос.Выполнить().Выбрать();
	УстановитьПривилегированныйРежим(Ложь);

	Если ПлановыеДанные Тогда
		ТекстОшибкиШаблон = НСтр("ru = 'Для сотрудника %1 уже введен документ  ""Индивидуальный график"": %2.'");
	Иначе
		ТекстОшибкиШаблон = НСтр("ru = 'Для сотрудника %1 уже введен документ ""Табель учета рабочего времени"": %2.'");
	КонецЕсли;	

	Пока Выборка.Следующий() Цикл
		ОписаниеОшибкиВводаВремени = НовыйОписаниеОшибкиВводаВремени();

		ОписаниеОшибкиВводаВремени.Сотрудник = Выборка.Сотрудник;

		ТекстОшибки = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(ТекстОшибкиШаблон, Выборка.СотрудникНаименование,
		Выборка.РегистраторПредставление);
		ОписаниеОшибкиВводаВремени.ТекстОшибки = ТекстОшибки;
		ОписаниеОшибкиВводаВремени.Документ = Выборка.Регистратор;

		ОписанияОшибокВводаВремени.Добавить(ОписаниеОшибкиВводаВремени);
	КонецЦикла;	

КонецПроцедуры


#КонецОбласти