﻿#Область РаботаСФайлом
&НаКлиенте
Процедура КаталогИмпортаНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	РежимКаталог=РежимДиалогаВыбораФайла.ВыборКаталога;
	Диалог2=Новый ДиалогВыбораФайла(РежимКаталог);
	Если Диалог2.Выбрать() Тогда
		Объект.КаталогИмпорта=Диалог2.Каталог;
	КонецЕсли;
КонецПроцедуры
#КонецОбласти


#Область ОсновнаяОбработка
&НаКлиенте
Процедура ЗагрузитьНажатие(Команда)
	ЗагрузитьНажатиеНаСервере();
КонецПроцедуры

&НаСервере
Процедура ЗагрузитьНажатиеНаСервере()
	Если НЕ ЗначениеЗаполнено(Объект.Организация) Тогда
		Сообщить("Организация не заполнена");
		Возврат;
	ИначеЕсли НЕ ЗначениеЗаполнено(Объект.КаталогИмпорта) Тогда
		Сообщить("Каталог импорта не заполнен");
		Возврат;
	ИначеЕсли НЕ ЗначениеЗаполнено(Объект.ВидДокумента) Тогда
		Сообщить("Вид документа не заполнен");
		Возврат;
	КонецЕсли;
	
	ЗагрузитьДок();
			
КонецПроцедуры

&НаСервере
Процедура ЗагрузитьДок()
	Если Объект.ВидДокумента = "ВыплатаЗаработнойПлаты" Тогда
		ЗагрузитьВыплатуЗарплаты();
	ИначеЕсли Объект.ВидДокумента="НачисленияУдержанияСписком" Тогда
		ЗагрузитьНачисленияУдержанияСписком();
	ИначеЕсли Объект.ВидДокумента="ТабельОтработанногоВремени" Тогда
		ЗагрузитьТабельОтработанногоВремени();	
	КонецЕсли;
КонецПроцедуры

&НаСервере
Процедура ЗагрузитьВыплатуЗарплаты()
	ИмяДокумента=ПолучитьСоответствиеДокументов77и83(Объект.ВидДокумента);	
	ТекстовыйДокумент=Новый ТекстовыйДокумент;
	ТекстовыйДокумент.Прочитать(Объект.КаталогИмпорта);
	КоличествоСтрок=ТекстовыйДокумент.КоличествоСтрок();
	Если КоличествоСтрок=0 Тогда
		Сообщить("Текстовый документ пустой");
		Возврат;
	КонецЕсли;
	НовыйДокумент=Неопределено;
	НомерДокумента=Неопределено;
	ДатаДокумента=Неопределено;
	ИдентификаторСтроки=Неопределено;
	Для а=1 по КоличествоСтрок Цикл
		ТекущаяСтрока=ТекстовыйДокумент.ПолучитьСтроку(а);
		МассивПараметровДляЗаполнения=СтрРазделить(ТекущаяСтрока,"@");
	Если Лев(МассивПараметровДляЗаполнения[0],1)="#" Тогда
			Если НовыйДокумент<>Неопределено Тогда
				Попытка
					НовыйДокумент.Записать();
					Сообщить("Документ номер:" + НомерДокумента + " от: " + ДатаДокумента + "успешно записан");
				Исключение
					Сообщить("Не удалось записать документ №: " + НомерДокумента +  " от: " + ДатаДокумента);
					Возврат;
				КонецПопытки;
			КонецЕсли;
			
		НовыйДокумент=Документы[ИмяДокумента].СоздатьДокумент();
		ИдентификаторСтроки=0;
		ДлинаПервогоПарам=СтрДлина(МассивПараметровДляЗаполнения[0]);
		НомерДокумента=СокрЛП(Прав(МассивПараметровДляЗаполнения[0],ДлинаПервогоПарам-1));
		
		Если НомерДокумента="" Тогда
		НовыйДокумент=Неопределено;
		Возврат;
		КонецЕсли;
	
		ДатаДокумента=МассивПараметровДляЗаполнения[1];
		ДатаДокумента=ПолучитьДату(ДатаДокумента);
		Если ДатаДокумента=Неопределено Тогда
		НовыйДокумент=Неопределено;
		Возврат;
		КонецЕсли;

		ЗаполнитьШапкуДокумента(Объект.ВидДокумента,НовыйДокумент,НомерДокумента,ДатаДокумента,МассивПараметровДляЗаполнения);
		Если НовыйДокумент=Неопределено Тогда
			Сообщить("Проблема с документом №: " + НомерДокумента + " от: " + ДатаДокумента);
			Возврат;
		КонецЕсли;
		
	Иначе
		ИдентификаторСтроки=ИдентификаторСтроки + 1;
		ЗаполнитьСтрокуДокумента(Объект.ВидДокумента,НовыйДокумент,НомерДокумента,ДатаДокумента,МассивПараметровДляЗаполнения,ИдентификаторСтроки);
		Если НовыйДокумент=Неопределено Тогда
			Сообщить("Проблема с документом №: " + НомерДокумента + " от: " + ДатаДокумента);
			Возврат;
		КонецЕсли;
	КонецЕсли;
	КонецЦикла;
	
	Если НовыйДокумент<>Неопределено Тогда
		Попытка
			НовыйДокумент.Записать();
			Сообщить("Документ номер:" + НомерДокумента + " от: " + ДатаДокумента + "успешно записан");
		Исключение
			Сообщить("Не удалось записать документ №: " + НомерДокумента +  " от: " + ДатаДокумента);
			Возврат;
		КонецПопытки;
	КонецЕсли;
	
			
	
	
	
КонецПроцедуры

&НаСервере
Процедура ЗагрузитьНачисленияУдержанияСписком()
ИмяДокумента=ПолучитьСоответствиеДокументов77и83(Объект.ВидДокумента);
ТекстовыйДокумент=Новый ТекстовыйДокумент;
ТекстовыйДокумент.Прочитать(Объект.КаталогИмпорта);
КоличествоСтрок=ТекстовыйДокумент.КоличествоСтрок();
Если КоличествоСтрок=0 Тогда
	 Сообщить("Документ ""НачисленияУдержанияСписком"" пустой");
	 Возврат; 
КонецЕсли;

	НомерДокумента=Неопределено;
    ДатаДокумента=Неопределено;
	НовыйДокумент=Неопределено;
	ИдентификаторСтроки=0;
	 Для а=1 по КоличествоСтрок Цикл
		 ТекущаяСтрока=ТекстовыйДокумент.ПолучитьСтроку(а);
		 МассивПараметровДляЗаполнения=СтрРазделить(ТекущаяСтрока,"@");
		 Если Лев(МассивПараметровДляЗаполнения[0],1)="#" Тогда
		 ИдентификаторСтроки=0;
		 Если НовыйДокумент<>Неопределено Тогда
			 Попытка
				 НовыйДокумент.Записать();
				 Сообщить("Документ номер: " + НомерДокумента + " от: " + ДатаДокумента + " успешно записан");
			 Исключение
				 Сообщить("Не удалось записать документ номер: " + НомерДокумента + " от: " + ДатаДокумента);
				 Возврат;
			 КонецПопытки;
		 КонецЕсли;
		 
		 	 НовыйДокумент=Документы[ИмяДокумента].СоздатьДокумент();
			 ДлинаПервогоПарам=СтрДлина(МассивПараметровДляЗаполнения[0]);
			 
			 НомерДокумента=СокрЛП(Прав(МассивПараметровДляЗаполнения[0],ДлинаПервогоПарам-1));
			 Если НомерДокумента="" Тогда
				 НовыйДокумент=Неопределено;
				 Возврат;
			 КонецЕсли;
			 
			 ДатаДокумента=МассивПараметровДляЗаполнения[1];
			 ДатаДокумента=ПолучитьДату(ДатаДокумента);
			 Если ДатаДокумента=Неопределено Тогда
				 НовыйДокумент=Неопределено;
				 Возврат;
			 КонецЕсли;
			 
			 ЗаполнитьШапкуДокумента(Объект.ВидДокумента,НовыйДокумент,НомерДокумента,ДатаДокумента,МассивПараметровДляЗаполнения);
			 
			 Если НовыйДокумент=Неопределено Тогда
				 Сообщить("Проблемы с документом номер: " + НомерДокумента + " от дата: " + ДатаДокумента); 
				 Возврат;
			 КонецЕсли;
			 
		 Иначе
			 ИдентификаторСтроки=ИдентификаторСтроки+1;
			 ЗаполнитьСтрокуДокумента(Объект.ВидДокумента,НовыйДокумент,НомерДокумента,ДатаДокумента,МассивПараметровДляЗаполнения,ИдентификаторСтроки);
			 
			 Если НовыйДокумент=Неопределено Тогда
				 Сообщить("Проблемы с документом номер: " + НомерДокумента + " от дата: " + ДатаДокумента);
				 Возврат;
			 КонецЕсли;
			 
		 КонецЕсли;
	 КонецЦикла;
	 
	 Если НовыйДокумент<>Неопределено Тогда
		 Попытка
			 НовыйДокумент.Записать();
			 Сообщить("Успешно записан документ номер: " + НомерДокумента + " от: " + ДатаДокумента); 
		 Исключение
			 Сообщить("Не удалось записать документ номер: " + НомерДокумента + " от: " + ДатаДокумента);
		 КонецПопытки;
	 КонецЕсли;
	 
КонецПроцедуры

&НаСервере
Процедура ЗагрузитьТабельОтработанногоВремени()
ИмяДокумента=ПолучитьСоответствиеДокументов77и83(Объект.ВидДокумента);
ТекстовыйДокумент=Новый ТекстовыйДокумент;
ТекстовыйДокумент.Прочитать(Объект.КаталогИмпорта);
КоличествоСтрок=ТекстовыйДокумент.КоличествоСтрок();
Если КоличествоСтрок=0 Тогда
	 Сообщить("Документ ""ТабельОтработанногоВремени"" пустой");
	 Возврат; 
КонецЕсли;

	НомерДокумента=Неопределено;
    ДатаДокумента=Неопределено;
	НовыйДокумент=Неопределено;
	 Для а=1 по КоличествоСтрок Цикл
		 ТекущаяСтрока=ТекстовыйДокумент.ПолучитьСтроку(а);
		 МассивПараметровДляЗаполнения=СтрРазделить(ТекущаяСтрока,"@");
		 Если Лев(МассивПараметровДляЗаполнения[0],1)="#" Тогда
		 	 Если НовыйДокумент<>Неопределено И НовыйДокумент.ДанныеОВремени.Количество()<>0 Тогда
			 Попытка
				 НовыйДокумент.Записать();
				 Сообщить("Документ номер: " + НомерДокумента + " от: " + ДатаДокумента + " успешно записан");
			 Исключение
				 Сообщить("Не удалось записать документ номер: " + НомерДокумента + " от: " + ДатаДокумента);
				 Возврат;
			 КонецПопытки;
		 КонецЕсли;
		 
		 	 НовыйДокумент=Документы[ИмяДокумента].СоздатьДокумент();
			 ДлинаПервогоПарам=СтрДлина(МассивПараметровДляЗаполнения[0]);
			 
			 НомерДокумента=СокрЛП(Прав(МассивПараметровДляЗаполнения[0],ДлинаПервогоПарам-1));
			 Если НомерДокумента="" Тогда
				 НовыйДокумент=Неопределено;
				 Возврат;
			 КонецЕсли;
			 
			 ДатаДокумента=МассивПараметровДляЗаполнения[1];
			 ДатаДокумента=ПолучитьДату(ДатаДокумента);
			 Если ДатаДокумента=Неопределено Тогда
				 НовыйДокумент=Неопределено;
				 Возврат;
			 КонецЕсли;
			 
			 ЗаполнитьШапкуДокумента(Объект.ВидДокумента,НовыйДокумент,НомерДокумента,ДатаДокумента,МассивПараметровДляЗаполнения);
			 
			 Если НовыйДокумент=Неопределено Тогда
				 Сообщить("Проблемы с документом номер: " + НомерДокумента + " от дата: " + ДатаДокумента); 
				 Возврат;
			 КонецЕсли;
			 
			Иначе
			 ЗаполнитьСтрокуДокумента(Объект.ВидДокумента,НовыйДокумент,НомерДокумента,ДатаДокумента,МассивПараметровДляЗаполнения);
			 
			 Если НовыйДокумент=Неопределено Тогда
				 Сообщить("Проблемы с документом номер: " + НомерДокумента + " от дата: " + ДатаДокумента);
				 Возврат;
			 КонецЕсли;
			 
		 КонецЕсли;
	 КонецЦикла;
	 
	 Если НовыйДокумент<>Неопределено И НовыйДокумент.ДанныеОВремени.Количество()<>0 Тогда
		 Попытка
			 НовыйДокумент.Записать();
			 Сообщить("Успешно записан документ номер: " + НомерДокумента + " от: " + ДатаДокумента); 
		 Исключение
			 Сообщить("Не удалось записать документ номер: " + НомерДокумента + " от: " + ДатаДокумента);
		 КонецПопытки;
	 КонецЕсли;

	
КонецПроцедуры
&НаСервере
Процедура ЗаполнитьШапкуДокумента(ВидДокумента,НовыйДокумент,НомерДокумента,ДатаДокумента,МассивПараметровДляЗаполнения)
	Если ВидДокумента="ВыплатаЗаработнойПлаты" Тогда
		ЗаполнитьШапкуДокумента1(ВидДокумента,НовыйДокумент,НомерДокумента,ДатаДокумента,МассивПараметровДляЗаполнения);
	ИначеЕсли ВидДокумента="НачисленияУдержанияСписком" Тогда
		ЗаполнитьШапкуДокумента2(ВидДокумента,НовыйДокумент,НомерДокумента,ДатаДокумента,МассивПараметровДляЗаполнения);
	ИначеЕсли ВидДокумента="ТабельОтработанногоВремени" Тогда
		ЗаполнитьШапкуДокумента3(ВидДокумента,НовыйДокумент,НомерДокумента,ДатаДокумента,МассивПараметровДляЗаполнения);	
	КонецЕсли;
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьШапкуДокумента1(ВидДокумента83,НовыйДокумент,НомерДокумента,ДатаДокумента,МассивПараметровДляЗаполнения)
	НовыйДокумент.Организация=Объект.Организация;
	
	НовыйДокумент.Дата=ДатаДокумента;
	
	ПериодРегистрации=МассивПараметровДляЗаполнения[2];
	ПериодРегистрации=ПолучитьДату(ПериодРегистрации);
	Если ПериодРегистрации=Неопределено Тогда
		НовыйДокумент=Неопределено;
		Возврат;
	КонецЕсли;
	НовыйДокумент.ПериодРегистрации=НачалоМесяца(ПериодРегистрации);
	
	НовыйДокумент.Комментарий="// Соответствует документу номер: " + НомерДокумента + "; // " +  МассивПараметровДляЗаполнения[3];
	
	НовыйДокумент.СтатьяФинансирования=ПолучитьСтатьюФинансированияПоУмолчанию();
	НовыйДокумент.СтатьяРасходов=ПолучитьСтатьюРасходовПоУмолчанию("211");
	НовыйДокумент.ВидДоходаИсполнительногоПроизводства=ПолучитьВидДоходаИсполнительногоПроизводстваПоУмолчанию();
	НовыйДокумент.ЗарплатныйПроект=ПолучитьЗарплатныйПроектПоУмолчанию();
	НовыйДокумент.СпособВыплаты=ПолучитьСпособВыплатыПоУмолчанию();
	НовыйДокумент.Округление=ПолучитьСпособОкругленияПоУмолчанию();
	НовыйДокумент.ПроцентВыплаты=100;
	НовыйДокумент.ДатаВыплаты=ДатаДокумента;
	НовыйДокумент.ПеречислениеНДФЛВыполнено=Истина;
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьШапкуДокумента2(ВидДокумента83,НовыйДокумент,НомерДокумента,ДатаДокумента,МассивПараметровДляЗаполнения)
НовыйДокумент.Организация=Объект.Организация;
НовыйДокумент.Дата=ДатаДокумента;
НовыйДокумент.ПериодРегистрации=НачалоМесяца(ДатаДокумента);
НовыйДокумент.Комментарий="Соответствует документу номер: " +НомерДокумента;
ВидПремии=ПолучитьВидРасчетаПоНаименованию(МассивПараметровДляЗаполнения[2]);
Если ВидПремии=Неопределено Тогда
	Сообщить("Не удалось определить вид расчета: " + МассивПараметровДляЗаполнения[2]);
	НовыйДокумент=Неопределено;
	Возврат;
КонецЕсли;
НовыйДокумент.ВидПремии=ВидПремии;
НовыйДокумент.ФиксБазовыйПериод=Истина;
НовыйДокумент.ДатаНачалаБазовогоПериода=НачалоМесяца(ДатаДокумента);
НовыйДокумент.ДатаОкончанияБазовогоПериода=КонецМесяца(ДатаДокумента);
НовыйДокумент.ПорядокВыплаты=Перечисления.ХарактерВыплатыЗарплаты.Межрасчет;
НовыйДокумент.ПланируемаяДатаВыплаты=ДатаДокумента;
НовыйДокумент.ДокументРассчитан=Истина;
НовыйДокумент.СтатьяФинансирования=ПолучитьСтатьюФинансированияПоУмолчанию();
НовыйДокумент.СтатьяРасходов=ПолучитьСтатьюРасходовПоУмолчанию("211");
НовыйДокумент.СпособОтраженияЗарплатыВБухучете=ПолучитьСпособОтраженияПоУмолчанию();
НовыйДокумент.РассчитыватьУдержания=Истина;
НовыйДокумент.ИсчислятьНалогПриОкончательномРасчете=Ложь;
НовыйДокумент.УдержатьНалогПриВыплатеЗарплаты=Ложь;
НовыйДокумент.ДоначислитьЗарплатуПриНеобходимости=Ложь;
НовыйДокумент.ДатаЗапрета=Дата(1,1,1);
НовыйДокумент.ПоказательПремирования=НовыйДокумент.ВидПремии.ПоказательПремирования;
НовыйДокумент.АБ_НеПредоставлятьВычеты=Истина;


КонецПроцедуры

&НаСервере
Процедура ЗаполнитьШапкуДокумента3(ВидДокумента83,НовыйДокумент,НомерДокумента,ДатаДокумента,МассивПараметровДляЗаполнения)
НовыйДокумент.Организация=Объект.Организация;
НовыйДокумент.Дата=ДатаДокумента;
НовыйДокумент.ПериодРегистрации=НачалоМесяца(ПолучитьДату(МассивПараметровДляЗаполнения[2]));
НовыйДокумент.ДатаНачалаПериода=НачалоМесяца(НовыйДокумент.ПериодРегистрации);
НовыйДокумент.ДатаОкончанияПериода=КонецМесяца(НовыйДокумент.ПериодРегистрации);
НовыйДокумент.ПериодВводаДанныхОВремени=Перечисления.ПериодыВводаДанныхОВремени.ТекущийМесяц;
НовыйДокумент.Комментарий="Соответствует документу номер: " + НомерДокумента;


КонецПроцедуры
&НаСервере
Процедура ЗаполнитьСтрокуДокумента(ВидДокумента,НовыйДокумент,НомерДокумента,ДатаДокумента,МассивПараметровДляЗаполнения,а=Неопределено)
	Если ВидДокумента="ВыплатаЗаработнойПлаты" Тогда
		ЗаполнитьСтрокуДокумента1(ВидДокумента,НовыйДокумент,НомерДокумента,ДатаДокумента,МассивПараметровДляЗаполнения,а);
	ИначеЕсли ВидДокумента="НачисленияУдержанияСписком" Тогда
		ЗаполнитьСтрокуДокумента2(ВидДокумента,НовыйДокумент,НомерДокумента,ДатаДокумента,МассивПараметровДляЗаполнения,а);
	ИначеЕсли ВидДокумента="ТабельОтработанногоВремени" Тогда
		ЗаполнитьСтрокуДокумента3(ВидДокумента,НовыйДокумент,НомерДокумента,ДатаДокумента,МассивПараметровДляЗаполнения);	
	КонецЕсли;
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьСтрокуДокумента1(ВидДокумента83,НовыйДокумент,НомерДокумента,ДатаДокумента,МассивПараметровДляЗаполнения,а)
	ТабЧастьЗарплата=НовыйДокумент.Зарплата;
	ТабЧастьCостав=НовыйДокумент.Состав;
	ТабЧастьФизическиеЛица=НовыйДокумент.ФизическиеЛица;
	
	
	//Табчасть Зарплата	
	НоваяСтрока=ТабЧастьЗарплата.Добавить();
	Сотрудник=ПолучитьСотрудникаПоКоду(МассивПараметровДляЗаполнения[0]);
	Если Сотрудник=Неопределено Тогда
		Сообщить("Не найден сотрудник с кодом: " + МассивПараметровДляЗаполнения[0] + " для документа номер: " +НомерДокумента  + " от: " + ДатаДокумента);
		НовыйДокумент=Неопределено;
		Возврат;
	КонецЕсли;
	НоваяСтрока.ИдентификаторСтроки=Новый УникальныйИдентификатор();
	НоваяСтрока.Сотрудник=Сотрудник;
	НоваяСтрока.ФизическоеЛицо=Сотрудник.ФизическоеЛицо;
	НоваяСтрока.Подразделение=ПолучитьПодразделениеСотрудника(Сотрудник,ДатаДокумента);
	НоваяСтрока.ПериодВзаиморасчетов=НовыйДокумент.ПериодРегистрации;
	НоваяСтрока.СтатьяФинансирования=НовыйДокумент.СтатьяФинансирования;
	НоваяСтрока.СтатьяРасходов=НовыйДокумент.СтатьяРасходов;
	НоваяСтрока.ДокументОснование=Документы.НачислениеЗарплаты.ПустаяСсылка();
	НоваяСтрока.ВидДоходаИсполнительногоПроизводства=НовыйДокумент.ВидДоходаИсполнительногоПроизводства;
	КВыплате=ПолучитьЧисло(МассивПараметровДляЗаполнения[1]);
	Если КВыплате=Неопределено Тогда
		Сообщить("Проблемы со строкой: "  + Строка(а) + " документа номер: " + НомерДокумента + " от: " + ДатаДокумента);
		НовыйДокумент=Неопределено;
		Возврат;
	КонецЕсли;
	НоваяСтрока.КВыплате=КВыплате;
	НоваяСтрока.НомерЛицевогоСчета=ПолучитьЛицевойСчетСотрудника(Сотрудник,ДатаДокумента);
	
	//Табчасть Состав
	НоваяСтрокаСостава=ТабЧастьCостав.Добавить();
	НоваяСтрокаСостава.ИдентификаторСтроки=НоваяСтрока.ИдентификаторСтроки;
	НоваяСтрокаСостава.ФизическоеЛицо=Сотрудник.ФизическоеЛицо;
	НоваяСтрокаСостава.НомерЛицевогоСчета=НоваяСтрока.НомерЛицевогоСчета;
	
	//ТабЧасть ФизическиеЛица
	НоваяСтрокаФизическиеЛица=ТабЧастьФизическиеЛица.Добавить();
	НоваяСтрокаФизическиеЛица.ФизическоеЛицо=Сотрудник.ФизическоеЛицо;
	
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьСтрокуДокумента2(ВидДокумента83,НовыйДокумент,НомерДокумента,ДатаДокумента,МассивПараметровДляЗаполнения,а)
	ТабЧастьНачисления=НовыйДокумент.Начисления;
	ТабЧастьПоказатели=НовыйДокумент.Показатели;
	ТабЧастьРаспределениеРезультатовНачислений=НовыйДокумент.РаспределениеРезультатовНачислений;
	ТабЧастьФизическиеЛица=НовыйДокумент.ФизическиеЛица;
	
	//ТабЧастьНачисления
	НоваяСтрока=ТабЧастьНачисления.Добавить();
	
	Сотрудник=ПолучитьСотрудникаПоКоду(МассивПараметровДляЗаполнения[0]);
	Если Сотрудник=Неопределено Тогда
		Сообщить("Не найден сотрудник с кодом: " + МассивПараметровДляЗаполнения[0]);
		НовыйДокумент=Неопределено;
		Возврат;
	КонецЕсли;
	НоваяСтрока.Сотрудник=Сотрудник;
	
	Результат=ПолучитьЧисло(МассивПараметровДляЗаполнения[3]);
	Если Результат=Неопределено Тогда
		Сообщить("Не удалось прочитать число у сотрудника: " + Сотрудник + " в документе номер: " + НомерДокумента);
		НовыйДокумент=Неопределено;
		Возврат;
	КонецЕсли;
	НоваяСтрока.Результат = Результат;
	
	Подразделение=ПолучитьПодразделениеСотрудника(Сотрудник,ДатаДокумента);
	НоваяСтрока.Подразделение=Подразделение;
	НоваяСтрока.ФиксРасчет=Ложь;
	НоваяСтрока.ФиксЗаполнение=Ложь;
	НоваяСтрока.ФиксСтрока=Ложь;
	НоваяСтрока.ИдентификаторСтрокиВидаРасчета=а;
	НоваяСтрока.ПериодДействия=НачалоМесяца(ДатаДокумента);
	НоваяСтрока.ОтработаноДней=0;
	НоваяСтрока.ОтработаноЧасов=0;
	НоваяСтрока.НормаДней=0;
	НоваяСтрока.НормаЧасов=0;
	НоваяСтрока.ОплаченоДней=0;
	НоваяСтрока.ОплаченоЧасов=0;
	НоваяСтрока.ФиксРасчетВремени=Ложь;
	НоваяСтрока.ВремяВЧасах=Ложь;
	НоваяСтрока.ВремяВЦеломЗаПериод=Истина;
	НоваяСтрока.ПериодРегистрацииВремени=НачалоМесяца(ДатаДокумента);
	НоваяСтрока.ГрафикРаботыНорма=ПолучитьГрафикРаботыСотрудника(Сотрудник,ДатаДокумента);
	НоваяСтрока.ВидУчетаВремени=Справочники.ВидыИспользованияРабочегоВремени.Явка;
	НоваяСтрока.ДатаНачала=НачалоМесяца(ДатаДокумента);
	НоваяСтрока.ДатаОкончания=КонецМесяца(ДатаДокумента);
	НоваЯСтрока.ГрафикРаботы=ПолучитьГрафикРаботыСотрудника(Сотрудник,ДатаДокумента);
	НоваяСтрока.ОбщийГрафик=ПолучитьГрафикРаботыСотрудника(Сотрудник,ДатаДокумента);
	НоваяСтрока.ПериодРегистрацииНормыВремени=НачалоМесяца(ДатаДокумента);
	НоваяСтрока.РассчитыватьПоРазовымНачислениямДокумента=Ложь;
	НоваяСтрока.РанееНачислено=0;
	НоваяСтрока.КорректировкаРанееВыполненногоНачисления=Ложь;	
	
	//ТабЧастьПоказатели
	НоваяСтрокаПоказатели=ТабЧастьПоказатели.Добавить();
	Показатель=ПолучитьПоказательПоВидуРасчета(НовыйДокумент.ВидПремии);
	Если Показатель=Справочники.ПоказателиРасчетаЗарплаты.ПустаяСсылка() Тогда
	Иначе
	НоваяСтрокаПоказатели.Показатель=Показатель;
	НоваяСтрокаПоказатели.Значение=Результат;
	НоваяСтрокаПоказатели.ИдентификаторСтрокиВидаРасчета=а;
	КонецЕсли;
	
	//ТабЧастьРаспределениеРезультатовНачислений
	НоваяСтрокаРаспределениеРезультатовНачислений=ТабЧастьРаспределениеРезультатовНачислений.Добавить();
	НоваяСтрокаРаспределениеРезультатовНачислений.ИдентификаторСтроки=а;
	НоваяСтрокаРаспределениеРезультатовНачислений.СтатьяФинансирования=НовыйДокумент.СтатьяФинансирования;
	НоваяСтрокаРаспределениеРезультатовНачислений.СтатьяРасходов=НовыйДокумент.СтатьяРасходов;
	НоваяСтрокаРаспределениеРезультатовНачислений.СпособОтраженияЗарплатыВБухучете=ПолучитьСпособОтраженияПоУмолчанию();
	НоваяСтрокаРаспределениеРезультатовНачислений.ОблагаетсяЕНВД=Ложь;
	НоваяСтрокаРаспределениеРезультатовНачислений.Результат=Результат;
	НоваяСтрокаРаспределениеРезультатовНачислений.ПодразделениеУчетаЗатрат=Подразделение;
	
	
	//ТабЧастьФизическиеЛица
	НоваяСтрокаФизическиеЛица=ТабЧастьФизическиеЛица.Добавить();
	НоваяСтрокаФизическиеЛица.ФизическоеЛицо=Сотрудник.ФизическоеЛицо;
	
	
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьСтрокуДокумента3(ВидДокумента83,НовыйДокумент,НомерДокумента,ДатаДокумента,МассивПараметровДляЗаполнения)
	
	ТабЧастьДанныеОВремени=НовыйДокумент.ДанныеОВремени;
	ТабЧастьФизическиеЛица=НовыйДокумент.ФизическиеЛица;
	
	Продолжать=Ложь;
	ВидВремениЯвки=Справочники.ВидыИспользованияРабочегоВремени.Явка;
	ВидВремениНочные=Справочники.ВидыИспользованияРабочегоВремени.РаботаНочныеЧасы;
	ВидВремени=ВидВремениЯвки;
	Если МассивПараметровДляЗаполнения[1]="Ночные" И НЕ (МассивПараметровДляЗаполнения[0]="0000000069" ИЛИ МассивПараметровДляЗаполнения[0]="0000000769" ИЛИ МассивПараметровДляЗаполнения[0]="0000000136" ИЛИ МассивПараметровДляЗаполнения[0]="0000000917" ИЛИ
		МассивПараметровДляЗаполнения[0]="0000000118" ИЛИ МассивПараметровДляЗаполнения[0]="0000000130" ИЛИ МассивПараметровДляЗаполнения[0]="0000001171" ИЛИ МассивПараметровДляЗаполнения[0]="0000000258" ИЛИ
		МассивПараметровДляЗаполнения[0]="0000000313" ИЛИ МассивПараметровДляЗаполнения[0]="0000000252" ИЛИ МассивПараметровДляЗаполнения[0]="0000000994" ИЛИ МассивПараметровДляЗаполнения[0]="0000000932" ИЛИ
		МассивПараметровДляЗаполнения[0]="0000001208" ИЛИ МассивПараметровДляЗаполнения[0]="0000001128" ИЛИ МассивПараметровДляЗаполнения[0]="0000000133" ИЛИ МассивПараметровДляЗаполнения[0]="0000000117" ИЛИ
		МассивПараметровДляЗаполнения[0]="0000000622" ИЛИ МассивПараметровДляЗаполнения[0]="0000001129" ИЛИ МассивПараметровДляЗаполнения[0]="0000000303" ИЛИ МассивПараметровДляЗаполнения[0]="0000001170" ИЛИ
		МассивПараметровДляЗаполнения[0]="0000001258" ИЛИ МассивПараметровДляЗаполнения[0]="0000000911" ИЛИ МассивПараметровДляЗаполнения[0]="0000000742" ИЛИ МассивПараметровДляЗаполнения[0]="0000000206" ИЛИ
		МассивПараметровДляЗаполнения[0]="0000000935" ИЛИ МассивПараметровДляЗаполнения[0]="0000000116" ИЛИ МассивПараметровДляЗаполнения[0]="0000001034" ИЛИ МассивПараметровДляЗаполнения[0]="0000001238" ИЛИ
		МассивПараметровДляЗаполнения[0]="0000000820" ИЛИ МассивПараметровДляЗаполнения[0]="0000001262" ИЛИ МассивПараметровДляЗаполнения[0]="0000000095" ИЛИ МассивПараметровДляЗаполнения[0]="0000000029" ИЛИ
		МассивПараметровДляЗаполнения[0]="0000001169" ИЛИ МассивПараметровДляЗаполнения[0]="0000000336") Тогда
		Продолжать=Истина;
		ВидВремени=ВидВремениНочные;
	Иначе
	КонецЕсли;
	
	Если Продолжать Тогда
	//ТабЧасть ДанныеОВремени
	НоваяСтрока=ТабЧастьДанныеОВремени.Добавить();
	
	Сотрудник=ПолучитьСотрудникаПоКоду(МассивПараметровДляЗаполнения[0]);
	Если Сотрудник=Неопределено Тогда
		Сообщить("Не найден сотрудник с кодом: " + МассивПараметровДляЗаполнения[0]);
		НовыйДокумент=Неопределено;
		Возврат;
	КонецЕсли;
	НоваяСтрока.Сотрудник=Сотрудник;
	
	
	Для НомерДня=1 по 31 Цикл
	ЧислоОтработанныхЧасов=ПолучитьЧисло(МассивПараметровДляЗаполнения[НомерДня+3]);
	Если ЧислоОтработанныхЧасов=Неопределено Тогда
		Сообщить("Не удалось прочитать число ночных часов у сотрудника: " + Сотрудник + " в документе номер: " + НомерДокумента + "в дне: " + НомерДня);
		НовыйДокумент=Неопределено;
		Возврат;
	КонецЕсли;
	КолонкаЧасов="Часов"+Строка(НомерДня);
	КолонкаВидВремени="ВидВремени"+Строка(НомерДня);
	Если ЧислоОтработанныхЧасов<>0 Тогда
	НоваяСтрока[КолонкаЧасов]=ЧислоОтработанныхЧасов;
	НоваяСтрока[КолонкаВидВремени]=ВидВремени;
	КонецЕсли;
КонецЦикла;

	
	
    //ТабЧасть ФизическиеЛица
	НоваяСтрока=ТабЧастьФизическиеЛица.Добавить();
	НоваяСтрока.ФизическоеЛицо=Сотрудник.ФизическоеЛицо;
	КонецЕсли;
КонецПроцедуры
#КонецОбласти


#Область ВспомогательныеФункции
&НаСервере
Функция ПолучитьСоответствиеДокументов77и83(ВидДокумента)
	
	СоответствиеДокументов77и83=Новый Соответствие();
	СоответствиеДокументов77и83.Вставить("ВыплатаЗаработнойПлаты","ВедомостьНаВыплатуЗарплатыВБанк");
	СоответствиеДокументов77и83.Вставить("НачисленияУдержанияСписком","Премия");
	СоответствиеДокументов77и83.Вставить("ТабельОтработанногоВремени","ТабельУчетаРабочегоВремени");
	
	Возврат СоответствиеДокументов77и83.Получить(ВидДокумента);
	
КонецФункции

&НаСервере
Функция ПолучитьДату(ДатаДокумента)
	Попытка
		ДатаДокумента=Дата(ДатаДокумента);
	Исключение
		Сообщить("Дата не разобрана");
		ДатаДокумента=Неопределено;
	КонецПопытки;
	
	Возврат ДатаДокумента;
	
КонецФункции

&НаСервере
Функция ПолучитьСотрудникаПоКоду(Код)
	Запрос=Новый Запрос;
	Запрос.Текст="ВЫБРАТЬ
	             |	Сотрудники.Ссылка КАК Ссылка
	             |ИЗ
	             |	Справочник.Сотрудники КАК Сотрудники
	             |ГДЕ
	             |	Сотрудники.Код = &Код";
	Запрос.УстановитьПараметр("Код",СокрЛП(Код));
	Результат=Запрос.Выполнить();
	Выборка=Результат.Выбрать();
	Cотрудник=Неопределено;
	Пока Выборка.Следующий() Цикл
		Сотрудник=Выборка.Ссылка;
	КонецЦикла;
	Возврат Сотрудник;
КонецФункции

&НаСервере
Функция ПолучитьВидРасчетаПоНаименованию(Наименование)
	Запрос=Новый Запрос;
	Запрос.Текст="ВЫБРАТЬ
	             |	Начисления.Ссылка КАК Ссылка
	             |ИЗ
	             |	ПланВидовРасчета.Начисления КАК Начисления
	             |ГДЕ
	             |	Начисления.Наименование = &Наименование";
	Запрос.УстановитьПараметр("Наименование",Наименование);
	Результат=Запрос.Выполнить();
	Выборка=Результат.Выбрать();
	ВидРасчета=Неопределено;
	Пока Выборка.Следующий() Цикл
		ВидРасчета=Выборка.Ссылка;
	КонецЦикла;
	Возврат ВидРасчета;
КонецФункции

&НаСервере
Функция ПолучитьЧисло(Число1)
	Попытка
		Число1=Число(Число1);
	Исключение
		Сообщить("Не удалось получить число");
		Возврат Неопределено;
	КонецПопытки;
	Возврат Число1;
КонецФункции

Функция ПолучитьСтатьюФинансированияПоУмолчанию()
	Запрос=Новый Запрос;
	Запрос.Текст="ВЫБРАТЬ
	             |	СтатьиФинансированияЗарплата.Ссылка КАК Ссылка
	             |ИЗ
	             |	Справочник.СтатьиФинансированияЗарплата КАК СтатьиФинансированияЗарплата
	             |ГДЕ
	             |	СтатьиФинансированияЗарплата.Наименование = &Наименование";
	Запрос.УстановитьПараметр("Наименование","Бюджетное финансирование");
	Результат=Запрос.Выполнить();
	Выборка=Результат.Выбрать();
	СтатьяФинансированияПоУмолчанию=Неопределено;
	Пока Выборка.Следующий() Цикл
		СтатьяФинансированияПоУмолчанию=Выборка.Ссылка;
	КонецЦикла;
	Возврат СтатьяФинансированияПоУмолчанию;
КонецФункции

&НаСервере
Функция ПолучитьСтатьюРасходовПоУмолчанию(Код)
	лТекст = "
		|ВЫБРАТЬ
		|	Сотрудники.Ссылка КАК Ссылка
		|ИЗ
		|	Справочник.СтатьиРасходовЗарплата КАК Сотрудники
		|ГДЕ Сотрудники.Код=&Код
		|";

	лЗапрос = Новый Запрос(лТекст);

	лЗапрос.УстановитьПараметр("Код", Код);


	лВыборка = лЗапрос.Выполнить().Выбрать();
	
	Пока лВыборка.Следующий() Цикл
		
		Возврат лВыборка.Ссылка;
		
	КонецЦикла;
	
	Возврат Неопределено;

КонецФункции

&НаСервере
Функция ПолучитьСпособОтраженияПоУмолчанию()
	Запрос=Новый Запрос;
	Запрос.Текст="ВЫБРАТЬ
	             |	СпособыОтраженияЗарплатыВБухУчете.Ссылка КАК Ссылка
	             |ИЗ
	             |	Справочник.СпособыОтраженияЗарплатыВБухУчете КАК СпособыОтраженияЗарплатыВБухУчете
	             |ГДЕ
	             |	СпособыОтраженияЗарплатыВБухУчете.Наименование = &Наименование";
	Запрос.УстановитьПараметр("Наименование","401.20 Расходы текущего финансового года");
	Результат=Запрос.Выполнить();
	Выборка=Результат.Выбрать();
	СпособОтраженияПоУмолчанию=Справочники.СпособыОтраженияЗарплатыВБухУчете.НайтиПоНаименованию("401.20 Расходы текущего финансового года");
	Пока Выборка.Следующий() Цикл
		СпособОтраженияПоУмолчанию=Выборка.Ссылка;
	КонецЦикла;
	Возврат СпособОтраженияПоУмолчанию;
КонецФункции

&НаСервере
Функция ПолучитьПодразделениеСотрудника(Сотрудник,Дата)
	Запрос=Новый Запрос;
	Запрос.Текст="ВЫБРАТЬ
	             |	КадроваяИсторияСотрудниковИнтервальный.Подразделение КАК Ссылка
	             |ИЗ
	             |	РегистрСведений.КадроваяИсторияСотрудниковИнтервальный КАК КадроваяИсторияСотрудниковИнтервальный
	             |ГДЕ
	             |	КадроваяИсторияСотрудниковИнтервальный.Сотрудник = &Сотрудник
	             |	И КадроваяИсторияСотрудниковИнтервальный.ДатаНачала <= КОНЕЦПЕРИОДА(&Дата, МЕСЯЦ)
	             |	И КадроваяИсторияСотрудниковИнтервальный.ДатаОкончания >= КОНЕЦПЕРИОДА(&Дата, МЕСЯЦ)";
	Запрос.УстановитьПараметр("Сотрудник",Сотрудник);
	Запрос.УстановитьПараметр("Дата",Дата);
	Подразделение=Справочники.ПодразделенияОрганизаций.ПустаяСсылка();
	Результат=Запрос.Выполнить();
	Выборка=Результат.Выбрать();
	Пока Выборка.Следующий() Цикл
		Подразделение=Выборка.Ссылка;
	КонецЦикла;
	Возврат Подразделение;
КонецФункции

&НаСервере 
Функция ПолучитьГрафикРаботыСотрудника(Сотрудник,Дата)
	Запрос=Новый Запрос;
	Запрос.Текст="ВЫБРАТЬ
	             |	ГрафикРаботыСотрудниковИнтервальный.ГрафикРаботы КАК Ссылка
	             |ИЗ
	             |	РегистрСведений.ГрафикРаботыСотрудниковИнтервальный КАК ГрафикРаботыСотрудниковИнтервальный
	             |ГДЕ
	             |	ГрафикРаботыСотрудниковИнтервальный.Сотрудник = &Сотрудник
	             |	И ГрафикРаботыСотрудниковИнтервальный.ДатаОкончания >= &Дата
	             |	И ГрафикРаботыСотрудниковИнтервальный.ДатаНачала <= &Дата";
	Запрос.УстановитьПараметр("Сотрудник",Сотрудник);
	Запрос.УстановитьПараметр("Дата",КонецМесяца(Дата));
	Результат=Запрос.Выполнить();
	Выборка=Результат.Выбрать();
	ГрафикРаботы=Справочники.ГрафикиРаботыСотрудников.НайтиПоНаименованию("Основной график (оплата по окладу)");
	Пока Выборка.Следующий() Цикл
		ГрафикРаботы = Выборка.Ссылка;
	КонецЦикла;
	Возврат ГрафикРаботы;
КонецФункции

&НаСервере
Функция ПолучитьПоказательПоВидуРасчета(ВидРасчета)
Запрос=Новый Запрос;
Запрос.Текст="ВЫБРАТЬ
             |	НачисленияПоказатели.Показатель КАК Ссылка
             |ИЗ
             |	ПланВидовРасчета.Начисления.Показатели КАК НачисленияПоказатели
             |ГДЕ
             |	НачисленияПоказатели.Ссылка = &Ссылка";
Запрос.УстановитьПараметр("Ссылка",ВидРасчета);
Результат=Запрос.Выполнить();
Выборка=Результат.Выбрать();
Показатель=Справочники.ПоказателиРасчетаЗарплаты.ПустаяСсылка();
Пока Выборка.Следующий() Цикл
	Показатель=Выборка.Ссылка;
КонецЦикла;
 Возврат Показатель;
КонецФункции

#КонецОбласти


#Область ЗначенияДляДокументаЗарплатаКВыплатеПоУмолчанию
&НаСервере
Функция ПолучитьЗарплатныйПроектПоУмолчанию()
	Запрос=Новый Запрос;
	Запрос.Текст="ВЫБРАТЬ
	             |	ЗарплатныеПроекты.Ссылка КАК Ссылка
	             |ИЗ
	             |	Справочник.ЗарплатныеПроекты КАК ЗарплатныеПроекты
	             |ГДЕ
	             |	ЗарплатныеПроекты.Наименование = &Наименование";
	Запрос.УстановитьПараметр("Наименование","Банк для перечисления зарплаты на карточки");
	ЗарплатныйПроектПоУмолчанию=Неопределено;
	Результат=Запрос.Выполнить();
	Выборка=Результат.Выбрать();
	Пока Выборка.Следующий() Цикл
		ЗарплатныйПроектПоУмолчанию=Выборка.Ссылка;
	КонецЦикла;
	Возврат ЗарплатныйПроектПоУмолчанию;
КонецФункции

&НаСервере
Функция ПолучитьВидДоходаИсполнительногоПроизводстваПоУмолчанию()
	Возврат Перечисления.ВидыДоходовИсполнительногоПроизводства.ЗарплатаВознаграждения;
КонецФункции

&НаСервере
Функция ПолучитьСпособВыплатыПоУмолчанию()
	Возврат Справочники.СпособыВыплатыЗарплаты.Зарплата;
КонецФункции

&НаСервере
Функция ПолучитьСпособОкругленияПоУмолчанию()
	Запрос=Новый Запрос;
	Запрос.Текст="ВЫБРАТЬ
	             |	СпособыОкругленияПриРасчетеЗарплаты.Ссылка КАК Ссылка
	             |ИЗ
	             |	Справочник.СпособыОкругленияПриРасчетеЗарплаты КАК СпособыОкругленияПриРасчетеЗарплаты
	             |ГДЕ
	             |	СпособыОкругленияПриРасчетеЗарплаты.Наименование = &Наименование";
	Запрос.УстановитьПараметр("Наименование","Округление до копейки");
	Результат=Запрос.Выполнить();
	Выборка=Результат.Выбрать();
	СпособОкругленияПоУмолчанию=Неопределено;
	Пока Выборка.Следующий() Цикл
		СпособОкругленияПоУмолчанию=Выборка.Ссылка;
	КонецЦикла;
	Возврат СпособОкругленияПоУмолчанию;
КонецФункции

&НаСервере
Функция ПолучитьЛицевойСчетСотрудника(Сотрудник,Дата)
	Запрос=Новый Запрос;
	Запрос.Текст="ВЫБРАТЬ
	             |	ЛицевыеСчетаСотрудниковПоЗарплатнымПроектам.НомерЛицевогоСчета КАК Ссылка
	             |ИЗ
	             |	РегистрСведений.ЛицевыеСчетаСотрудниковПоЗарплатнымПроектам КАК ЛицевыеСчетаСотрудниковПоЗарплатнымПроектам
	             |ГДЕ
	             |	ЛицевыеСчетаСотрудниковПоЗарплатнымПроектам.ФизическоеЛицо = &ФизическоеЛицо
	             |	И ЛицевыеСчетаСотрудниковПоЗарплатнымПроектам.ЗарплатныйПроект = &ЗарплатныйПроект
	             |	И ЛицевыеСчетаСотрудниковПоЗарплатнымПроектам.Организация = &Организация
	             |	И ЛицевыеСчетаСотрудниковПоЗарплатнымПроектам.ДатаОткрытияЛицевогоСчета <= &ДатаОткрытияЛицевогоСчета";
	Запрос.УстановитьПараметр("ФизическоеЛицо",Сотрудник.ФизическоеЛицо);
	Запрос.УстановитьПараметр("Организация",Объект.Организация);
	Запрос.УстановитьПараметр("ЗарплатныйПроект",ПолучитьЗарплатныйПроектПоУмолчанию());
	Запрос.УстановитьПараметр("ДатаОткрытияЛицевогоСчета",КонецМесяца(Дата));
	ЛицевойСчетСотрудника="";
	Результат=Запрос.Выполнить();
	Выборка=Результат.Выбрать();
	Пока Выборка.Следующий() Цикл
		ЛицевойСчетСотрудника=Выборка.Ссылка;
	КонецЦикла;
	Возврат ЛицевойСчетСотрудника;
КонецФункции

#КонецОбласти