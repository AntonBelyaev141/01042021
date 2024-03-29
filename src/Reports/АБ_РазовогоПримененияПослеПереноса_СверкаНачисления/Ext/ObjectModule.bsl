﻿
&НаСервере
Процедура ПриКомпоновкеРезультата(ДокументРезультат, ДанныеРасшифровки, СтандартнаяОбработка) Экспорт
	
	//1 База - > Результат0
	Запрос=Новый Запрос;
	МенеджерВременныхТаблиц=Новый МенеджерВременныхТаблиц;
	Запрос.МенеджерВременныхТаблиц=МенеджерВременныхТаблиц;
	Запрос.Текст="ВЫБРАТЬ
	             |	НачисленияУдержанияПоСотрудникам.ФизическоеЛицо КАК Сотрудник83,
	             |	СУММА(НачисленияУдержанияПоСотрудникам.Сумма) КАК Начислено83
	             |ИЗ
	             |	РегистрНакопления.НачисленияУдержанияПоСотрудникам КАК НачисленияУдержанияПоСотрудникам
	             |ГДЕ
	             |	НАЧАЛОПЕРИОДА(НачисленияУдержанияПоСотрудникам.Период, МЕСЯЦ) = &ПериодРегистрации
	             |	И НачисленияУдержанияПоСотрудникам.ГруппаНачисленияУдержанияВыплаты = ЗНАЧЕНИЕ(Перечисление.ГруппыНачисленияУдержанияВыплаты.Начислено)
	             |	И НачисленияУдержанияПоСотрудникам.НачислениеУдержание В (&НачислениеУдержание1, &НачислениеУдержание2)
	             |
	             |СГРУППИРОВАТЬ ПО
	             |	НачисленияУдержанияПоСотрудникам.ФизическоеЛицо
	             |
	             |УПОРЯДОЧИТЬ ПО
	             |	НачисленияУдержанияПоСотрудникам.ФизическоеЛицо.Наименование
	             |АВТОУПОРЯДОЧИВАНИЕ";
	Запрос.УстановитьПараметр("ПериодРегистрации",НачалоМесяца(НачалоПериода));
	Запрос.УстановитьПараметр("НачислениеУдержание1",ВидРасчета1);
	Запрос.УстановитьПараметр("НачислениеУдержание2",ВидРасчета2);
	Результат0=Запрос.Выполнить().Выгрузить();
	
	//2 Таблица - Результат2	
	Результат2=Новый ТаблицаЗначений;
	Результат2.Колонки.Добавить("Сотрудник82",Новый ОписаниеТипов("СправочникСсылка.ФизическиеЛица"));
	Результат2.Колонки.Добавить("Начислено82",Новый ОписаниеТипов("Число"));
	
	ТабличныйДокумент=Новый ТабличныйДокумент;
	ТабличныйДокумент.Прочитать(АдресФайла);
	КоличествоСтрок=ТабличныйДокумент.ВысотаТаблицы;
	
	

	Для НомерСтроки=НомерНачальнойСтроки по КоличествоСтрок Цикл	
		//физическое лицо
		ФамилияСотрудника=СтрРазделить(ТабличныйДокумент.Область(НомерСтроки,3).Текст," ");
		КодСотрудника=Прав(ТабличныйДокумент.Область(НомерСтроки,2).Текст,2);
		Если ФамилияСотрудника.Количество()>0 И КодСотрудника<>"" Тогда
			ФизическоеЛицо=ПолучитьФизическоеЛицо(ФамилияСотрудника[0],КодСотрудника);
		Иначе
			Продолжить;
		КонецЕсли;
		
		//Сумма по виду расчета 1
		ПремияСтрока=ТабличныйДокумент.Область(НомерСтроки,НомерСравниваемойКолонки).Текст;
		ПремияСтрока=СтрЗаменить(ПремияСтрока," ","");
		Попытка
		ПремияЧисло=Число(ПремияСтрока);
		Исключение
		ПремияЧисло=0;
		КонецПопытки;
		
		//Сумма по виду расчета 2
		Премия2Строка=ТабличныйДокумент.Область(НомерСтроки,НомерСравниваемойКолонкиЕще).Текст;
		Премия2Строка=СтрЗаменить(Премия2Строка," ","");
		Попытка
		ПремияЧисло2=Число(Премия2Строка);
		Исключение
		ПремияЧисло2=0;
		КонецПопытки;
		
		//Итоговая сумма
		НоваяСтрока2=Результат2.Добавить();
		НоваяСтрока2.Сотрудник82=ФизическоеЛицо;
		НоваяСтрока2.Начислено82=ПремияЧисло+ПремияЧисло2;
	КонецЦикла;
	
	//3 Сравнение
	Результат3=Новый ТаблицаЗначений;
	Результат3=Результат0.СкопироватьКолонки();
	Результат3.Колонки.Добавить("Сотрудник82",Новый ОписаниеТипов("СправочникСсылка.ФизическиеЛица"));
	Результат3.Колонки.Добавить("Начислено82",Новый ОписаниеТипов("Число"));
		
	//Совпадающие и те, что есть только в 83
	Для Каждого Строка Из Результат0 Цикл
	СтруктураОтбора=Новый Структура("Сотрудник82",Строка.Сотрудник83);
	МассивНайденныхСтрок=Результат2.НайтиСтроки(СтруктураОтбора);
	Если МассивНайденныхСтрок.Количество()<>0 Тогда
		НоваяСтрока=Результат3.Добавить();
		ЗаполнитьЗначенияСвойств(НоваяСтрока,Строка);
		НужнаяСтрока=МассивНайденныхСтрок[0];
		ЗаполнитьЗначенияСвойств(НоваяСтрока,НужнаяСтрока);
	Иначе
		НоваяСтрока=Результат3.Добавить();
		ЗаполнитьЗначенияСвойств(НоваяСтрока,Строка);
		НоваяСтрока.Сотрудник82=Строка.Сотрудник83;
		НоваяСтрока.Начислено82=0;
	КонецЕсли;
	КонецЦикла;
	
	//Те, что есть только в 82
	Для Каждого Строка2 Из Результат2 Цикл
		СтруктураОтбора2=Новый Структура("Сотрудник83",Строка2.Сотрудник82);
		МассивНайденныхСтрок2=Результат0.НайтиСтроки(СтруктураОтбора2);
		Если МассивНайденныхСтрок2.Количество()=0 Тогда
			НоваяСтрока2=Результат3.Добавить();
			ЗаполнитьЗначенияСвойств(НоваяСтрока2,Строка2);
			НоваяСтрока2.Сотрудник83=Строка2.Сотрудник82;
			НоваяСтрока2.Начислено83=0;
		КонецЕсли;
	КонецЦикла;
	
	//4 Вывод в макет
	СтандартнаяОбработка=Ложь;
	Настройки=КомпоновщикНастроек.ПолучитьНастройки();
	КомпоновщикМакета= Новый КомпоновщикМакетаКомпоновкиДанных;
	МакетКомпоновки=КомпоновщикМакета.Выполнить(СхемаКомпоновкиДанных,Настройки);
	ПроцессорКомпоновки=Новый ПроцессорКомпоновкиДанных;
	
	ВнешнийНабор=Новый Структура("ТаблицаДанных",Результат3);
	ПроцессорКомпоновки.Инициализировать(МакетКомпоновки,ВнешнийНабор);
	ПроцессорВывода=Новый ПроцессорВыводаРезультатаКомпоновкиДанныхВТабличныйДокумент;
	ПроцессорВывода.УстановитьДокумент(ДокументРезультат);
	ПроцессорВывода.Вывести(ПроцессорКомпоновки);	

КонецПроцедуры

&НаСервере
Функция ПолучитьФизическоеЛицо(Фамилия,КодСотрудника)
	Запрос=Новый Запрос;
	Запрос.Текст="ВЫБРАТЬ
	             |	ФизическиеЛица.Ссылка КАК Ссылка,
	             |	ФизическиеЛица.Наименование КАК Наименование,
				 |	ФизическиеЛица.Код Как Код
	             |ИЗ
	             |	Справочник.Сотрудники КАК ФизическиеЛица";
	Результат=Запрос.Выполнить();
	Выборка=Результат.Выбрать();
	ФизическоеЛицо=Неопределено;
	Пока Выборка.Следующий() Цикл
		ФамилияФизлица=СтрРазделить(Выборка.Наименование," ");
		Если Фамилия=ФамилияФизлица[0] И КодСотрудника=Прав(Выборка.Код,2) Тогда
		ФизическоеЛицо=Выборка.Ссылка.ФизическоеЛицо;
		Прервать;
		КонецЕсли;
	КонецЦикла;
	Возврат ФизическоеЛицо;	
КонецФункции
