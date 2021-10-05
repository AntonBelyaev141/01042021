#Область Доработка_4_НеПредоставлятьВычеты_Доработка_1_ИспользоватьНеТиповойРасчетНочныхПраздничных_Доработка_5_УправлениеУдержаниями
&НаСервере
Процедура АБ_ПриСозданииНаСервереПосле(Отказ, СтандартнаяОбработка)
		
	//1АБ Беляев 16.03.2021 + Доработка "Не предоставлять вычеты в межрасчет"
	ПроверочныйТип=Элементы.Найти("АБ_НеПредоставлятьВычеты");
	Если НЕ ТипЗнч(ПроверочныйТип) = Тип("Неопределено") Тогда
	Иначе
		ЭлементДополнительно=Элементы.Найти("ЭлементыДополнительно");
		Элемент_АБ_НеПредоставлятьВычеты=Элементы.Добавить("АБ_НеПредоставлятьВычеты",Тип("ПолеФормы"),ЭлементДополнительно);
		Элемент_АБ_НеПредоставлятьВычеты.Заголовок = "Не предоставлять вычеты";
		Элемент_АБ_НеПредоставлятьВычеты.Вид = ВидПоляФормы.ПолеФлажка;
		Элемент_АБ_НеПредоставлятьВычеты.ПутьКДанным = "Объект.АБ_НеПредоставлятьВычеты";
		Элемент_АБ_НеПредоставлятьВычеты.УстановитьДействие("ПриИзменении","АБ_РассчитатьСотрудниковНаКлиенте");		
	КонецЕсли;
	//1АБ Беляев 16.03.2021 - Доработка "Не предоставлять вычеты в межрасчет"
	
	//1АБ Беляев 05.04.2021 + Доработка "Использовать нетиповой расчет ночных/праздничных" 
	ЭлементПроверки=Элементы.Найти("ИспользоватьНеТиповойРасчетНочных");
	Если ТипЗнч(ЭлементПроверки) <> Тип("Неопределено") Тогда
	Иначе
	ЭлементыДополнительно=Элементы.Найти("ЭлементыДополнительно");
	ПолеИспользоватьНеТиповойРасчетНочных = Элементы.Вставить("ИспользоватьНеТиповойРасчетНочных", Тип("ПолеФормы"), ЭлементыДополнительно);
	ПолеИспользоватьНеТиповойРасчетНочных.Вид = ВидПоляФормы.ПолеФлажка;
	ПолеИспользоватьНеТиповойРасчетНочных.Заголовок = "Использовать нетиповой расчет ночных";
	ПолеИспользоватьНеТиповойРасчетНочных.ПутьКДанным = "Объект.АБ_ИспользоватьНеТиповойРасчетНочных";
	
	ПолеИспользоватьНеТиповойРасчетПраздничных=Элементы.Вставить("ИспользоватьНеТиповойРасчетПраздничных", Тип("ПолеФормы"), ЭлементыДополнительно);
	ПолеИспользоватьНеТиповойРасчетПраздничных.Вид = ВидПоляФормы.ПолеФлажка;
	ПолеИспользоватьНеТиповойРасчетПраздничных.Заголовок = "Использовать нетиповой расчет праздничных";
	ПолеИспользоватьНеТиповойРасчетПраздничных.ПутьКДанным = "Объект.АБ_ИспользоватьНеТиповойРасчетПраздничных";
	КонецЕсли;

	Если Параметры.Ключ.Пустая() Тогда
	Объект["АБ_ИспользоватьНеТиповойРасчетНочных"]=Истина;
	Объект["АБ_ИспользоватьНеТиповойРасчетПраздничных"]=Истина;
	Объект["АБ_НеПредоставлятьВычеты"]=Истина;
	КонецЕсли;
	//1АБ Беляев 05.04.2021 - Доработка "Использовать нетиповой расчет ночных/праздничных" 
	//1АБ Беляев 12.04.2021 + Доработка "Добавить управление расчетом удержаний"
	Если Параметры.Ключ.Пустая() Тогда
		УстановитьСвойствоРассчитыватьУдержания(ЭтотОбъект);
	КонецЕсли;
	ЭлементПроверки=Элементы.Найти("РассчитыватьУдержания");
	Если ТипЗнч(ЭлементПроверки) <> Тип("Неопределено") Тогда
	Иначе
		РасчетЗарплатыРасширенныйФормы.РассчитатьУдержанияДополнитьФорму(ЭтотОбъект);
		УстановитьДоступностьПоляРассчитыватьУдержания(ЭтотОбъект);
	КонецЕсли;
	//1АБ Беляев 12.04.2021 - Доработка "Добавить управление расчетом удержаний"

КонецПроцедуры

//1АБ Беляев 16.03.2021 +  Доработк "Не предоставлять вычеты в межрасчет" + "Использовать нетиповой расчет ночных/праздничных"
&НаКлиенте
Процедура АБ_РассчитатьСотрудниковНаКлиенте(Команда)
	АБ_РассчитатьСотрудниковНаСервере();
КонецПроцедуры

&НаСервере
Процедура АБ_РассчитатьСотрудниковНаСервере()
	ПерезаполнитьНачисленияСотрудника(, , Ложь);
КонецПроцедуры



&НаСервере
&ИзменениеИКонтроль("ЗаполнитьНастройкиМенеджераРасчета")
Процедура АБ_ЗаполнитьНастройкиМенеджераРасчета(МенеджерРасчета, ПериодРасчетаЗарплаты, СохранятьИсправления = Истина)

	МенеджерРасчета.ИсключаемыйРегистратор = Объект.Ссылка;

	ИсправлениеДокументовРасчетЗарплаты.НастроитьМенеджерРасчета(МенеджерРасчета, ЭтаФорма, ОписаниеДокумента(ЭтаФорма));

	Если ОбщегоНазначения.ПодсистемаСуществует("ЗарплатаКадрыКорпоративнаяПодсистемы.УправленческаяЗарплата") Тогда
		Модуль = ОбщегоНазначения.ОбщийМодуль("УправленческаяЗарплата");
		Модуль.ПриИнициализацииМенеджераРасчетаДляЗаполненияДокументаРасчетаЗарплаты(МенеджерРасчета);
	КонецЕсли;

	МенеджерРасчета.НастройкиРасчета.РассчитыватьНачисления = Истина;
	МенеджерРасчета.НастройкиРасчета.РассчитыватьНДФЛ = Истина;
	МенеджерРасчета.НастройкиРасчета.РассчитыватьКорректировкиВыплаты = Истина;
	МенеджерРасчета.НастройкиРасчета.РассчитыватьЗаймы = ПериодРасчетаЗарплаты <> Неопределено;
	#Удаление
	МенеджерРасчета.НастройкиРасчета.РассчитыватьУдержания = ЭтоМежрасчетнаяВыплата(Объект.ПорядокВыплаты);
	#КонецУдаления
	#Вставка
	//1АБ Беляев 12.04.2021 + Доработка "Добавить управление расчетом удержаний"
	МенеджерРасчета.НастройкиРасчета.РассчитыватьУдержания = Объект.РассчитыватьУдержания;
	//1АБ Беляев 12.04.2021 - Доработка "Добавить управление расчетом удержаний"
	#КонецВставки
	МенеджерРасчета.НастройкиРасчета.СохранятьИсправления = СохранятьИсправления;
	МенеджерРасчета.НастройкиРасчета.РасчетЗарплаты = ПериодРасчетаЗарплаты <> Неопределено;
	
	МенеджерРасчета.НастройкиНДФЛ.Сотрудники = Объект.Сотрудник;
	МенеджерРасчета.НастройкиНДФЛ.ДатаВыплаты = Объект.ПланируемаяДатаВыплаты;
	МенеджерРасчета.НастройкиНДФЛ.ОкончательныйРасчет = Ложь;
	МенеджерРасчета.НастройкиНДФЛ.ДоходПолученНаТерриторииРФ = Объект.ДоходПолученНаТерриторииРФ;

	ЗасчитыватьДанныеАвансов = Объект.РассчитатьЗарплату;	
	Если ЗасчитыватьДанныеАвансов
		И ИсправлениеДокументовРасчетЗарплатыКлиентСервер.ИсправлениеВТекущемПериоде(ЭтаФорма)
		И ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Объект.ИсправленныйДокумент, "РассчитатьЗарплату") Тогда
		ЗасчитыватьДанныеАвансов = Ложь
	КонецЕсли;
	МенеджерРасчета.НастройкиНДФЛ.ЗасчитыватьДанныеАвансов = ЗасчитыватьДанныеАвансов;

	МенеджерРасчета.НастройкиУдержаний.РассчитыватьТолькоПоТекущемуДокументу = Истина;
	Если ПериодРасчетаЗарплаты <> Неопределено Тогда
		МенеджерРасчета.НастройкиЗаймов.Сотрудники = Объект.Сотрудник;
		МенеджерРасчета.НастройкиЗаймов.ДатаПогашения = ПериодРасчетаЗарплаты.ДатаОкончания;
	КонецЕсли;
	МенеджерРасчета.НастройкиБухучета.НастройкиБухучетаДокумента = Документы.Отпуск.ДанныеДляБухучетаЗарплатыПервичныхДокументов(Объект)["ТаблицаБухучетЗарплаты"];

	МенеджерРасчета.ДобавитьДатуНачалаСобытия(Объект.Сотрудник, Объект.ДатаНачалаСобытия);	
    #Вставка
	//1АБ Беляев 16.03.2021 +
	МенеджерРасчета.НастройкиНДФЛ.АБ_НеПредоставлятьВычеты = Объект.АБ_НеПредоставлятьВычеты;
	//1АБ Беляев 16.03.2021 -
	#КонецВставки
	#Вставка
	//1АБ Беляев 05.04.2021 +
	МенеджерРасчета.НастройкиНачислений.ИспользоватьНеТиповойРасчетНочных = Объект.АБ_ИспользоватьНеТиповойРасчетНочных;
	МенеджерРасчета.НастройкиНачислений.ИспользоватьНеТиповойРасчетПраздничных = Объект.АБ_ИспользоватьНеТиповойРасчетПраздничных;
	//1АБ Беляев 05.04.2021 -
	#КонецВставки

КонецПроцедуры

//1АБ Беляев 16.03.2021 -  Доработк "Не предоставлять вычеты в межрасчет" + "Использовать нетиповой расчет ночных/праздничных"

//1АБ Беляев 12.04.2021 + Доработка 5 "Добавить управление расчетом удержаний"
&НаКлиентеНаСервереБезКонтекста
Процедура УстановитьСвойствоРассчитыватьУдержания(Форма)
	
	ЗарплатаКадрыРасширенныйКлиентСервер.УстановитьСвойствоРассчитыватьУдержания(Форма);
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Процедура УстановитьДоступностьПоляРассчитыватьУдержания(Форма)
	
	ЗарплатаКадрыРасширенныйКлиентСервер.УстановитьДоступностьПоляРассчитыватьУдержания(Форма);
	
КонецПроцедуры

&НаСервере
&ИзменениеИКонтроль("ЗаполнитьУдержания")
Процедура АБ_ЗаполнитьУдержания(МенеджерРасчета)

	#Удаление
	Если Не ЭтоМежрасчетнаяВыплата(Объект.ПорядокВыплаты) Тогда
		Возврат;
	КонецЕсли;
	#КонецУдаления
	#Вставка
	//1АБ Беляев 12.04.2021 + Доработка "Добавить управление расчетом удержаний"
	Если НЕ Объект.РассчитыватьУдержания Тогда
		Возврат;
	КонецЕсли;
	//1АБ Беляев 12.04.2021 - Доработка "Добавить управление расчетом удержаний"
	#КонецВставки

	МенеджерРасчета.ЗаполнитьУдержанияСотрудникаЗаПериод(Объект.Сотрудник, Объект.ПериодРегистрации, КонецМесяца(Объект.ПериодРегистрации));

КонецПроцедуры

&НаСервере
&ИзменениеИКонтроль("УдержанияДоступны")
Функция АБ_УдержанияДоступны()

	Если Не ИспользуетсяРасчетЗарплаты Тогда
		Возврат Ложь;
	Иначе
		#Удаление
		Возврат ЭтоМежрасчетнаяВыплата(Объект.ПорядокВыплаты);
		#КонецУдаления
		#Вставка
		//1АБ Беляев 12.04.2021 + Доработка "Добавить управление расчетом удержаний"
		Возврат Объект.РассчитыватьУдержания;
		//1АБ Беляев 12.04.2021 - Доработка "Добавить управление расчетом удержаний"
		#КонецВставки
	КонецЕсли;

КонецФункции

&НаКлиенте
Процедура Подключаемый_РассчитыватьУдержанияПриИзменении(Элемент)
	
	//полностью дублируем текст процедуры "Подключаемый_ПорядокВыплатыПриИзменении",
	//но не можем прямо на нее сослаться из-за зацикливания,
	//так как возвращаемся сюда
	ПерезаполнитьНачисления = Неопределено;
	ПорядокВыплатыПриИзмененииНаСервере(ПерезаполнитьНачисления);
	
	Если ПерезаполнитьНачисления = Истина Тогда
		ВыполнитьРасчетИПерезаполнениеНачислений();
	ИначеЕсли ПерезаполнитьНачисления = Ложь Тогда
		ВыполнитьРасчетИПерезаполнениеНачислений(Ложь);
	КонецЕсли;

	
КонецПроцедуры


&НаКлиенте
&Перед("Подключаемый_ПорядокВыплатыПриИзменении")
Процедура АБ_Подключаемый_ПорядокВыплатыПриИзменении(Элемент)
	УстановитьСвойствоРассчитыватьУдержания(ЭтотОбъект);
	УстановитьДоступностьПоляРассчитыватьУдержания(ЭтотОбъект);
	УстановитьВидимостьУдержаний();
КонецПроцедуры

&НаСервере
&ИзменениеИКонтроль("ПерезаполнитьНачисленияСотрудника")
Процедура АБ_ПерезаполнитьНачисленияСотрудника(Сотрудник, СохранятьИсправления, ПерезаполнитьНачисления)

	ОчиститьРассчитанныеДанные(ПерезаполнитьНачисления);
	
	НачалоПериода = ?(ПерезаполнитьНачисления, НачальныйПериодРасчетаЗарплаты().ДатаНачала, Неопределено);
	ПериодРасчетаЗарплаты = ПериодРасчетаЗарплатыДоНачалаОтпуска(НачалоПериода);
	
	МенеджерРасчета = РасчетЗарплатыРасширенный.СоздатьМенеджерРасчета(Объект.ПериодРегистрации, Объект.Организация);
	ЗаполнитьНастройкиМенеджераРасчета(МенеджерРасчета, ПериодРасчетаЗарплаты, СохранятьИсправления);
	
	ЗафиксированныеСтрокиОплатыТруда = Новый Соответствие;
	
	Если ПерезаполнитьНачисления Тогда
		
		Если (Объект.РассчитатьЗарплату Или Объект.ПредоставитьЕдиновременнуюВыплатуКОтпуску
			Или (Объект.ПредоставитьМатериальнуюПомощьПриОтпуске И Объект.РасчетДенежногоСодержания))
			И ОтпускНачинаетсяВСледующемМесяце(НачалоПериода) Тогда
			
			ЗаполнитьНачисления(МенеджерРасчета, ПериодРасчетаЗарплаты);
			ЗаполнитьПерерасчеты(МенеджерРасчета);
			
			Если Не СкорректированСреднийЗаработок Тогда 
				ОбновитьДанныеДляРасчетаСреднего = Истина;
			КонецЕсли;
			
			ЗафиксированныеСтрокиОплатыОтпуска = УстановитьПризнакФиксРасчетНачислениямОплатыОтпуска(МенеджерРасчета);
			
			НастройкиРасчетаОтпуска = ОбщегоНазначения.СкопироватьРекурсивно(МенеджерРасчета.НастройкиРасчета);
			МенеджерРасчета.УстановитьНастройкиРасчетаПоУмолчанию();
			#Вставка
			//1АБ Беляев 16.03.2021 +
			МенеджерРасчета.НастройкиНДФЛ.АБ_НеПредоставлятьВычеты = Объект.АБ_НеПредоставлятьВычеты;
			//1АБ Беляев 16.03.2021 -
			#КонецВставки
			#Вставка
			//1АБ Беляев 05.04.2021 +
			МенеджерРасчета.НастройкиНачислений.ИспользоватьНеТиповойРасчетНочных = Объект.АБ_ИспользоватьНеТиповойРасчетНочных;
			МенеджерРасчета.НастройкиНачислений.ИспользоватьНеТиповойРасчетПраздничных = Объект.АБ_ИспользоватьНеТиповойРасчетПраздничных;
			//1АБ Беляев 05.04.2021 -
			#КонецВставки
			МенеджерРасчета.НастройкиРасчета.Сотрудники = НастройкиРасчетаОтпуска.Сотрудники;
			МенеджерРасчета.НастройкиРасчета.ФизическиеЛица = НастройкиРасчетаОтпуска.ФизическиеЛица;
			МенеджерРасчета.НастройкиРасчета.РассчитыватьНачисления = Истина;			
			
			МенеджерРасчета.РассчитатьЗарплату();
			
			ЗаполнитьНастройкиМенеджераРасчетаПоШаблону(МенеджерРасчета, НастройкиРасчетаОтпуска);
			РезультатРасчетаНачисленийВДанныеФормы(МенеджерРасчета.Зарплата);
			
			НоваяТранзакция = НачатьНовуюТранзакцию();
			ЗарегистрироватьНачисленияОплатыТруда(МенеджерРасчета.Зарплата);
			ОбновитьДанныеДляРасчетаСохраняемогоЗаработка();
			Если НоваяТранзакция Тогда
				ОтменитьТранзакцию();
			КонецЕсли;	
			
			ОчиститьРассчитанныеДанные(ПерезаполнитьНачисления);
			ОчиститьДанныеДляРасчетаСреднегоЗаПериодРегистрации();
			СброситьПризнакФиксРасчет(МенеджерРасчета, ЗафиксированныеСтрокиОплатыОтпуска);
			
			ЗафиксированныеСтрокиОплатыТруда = УстановитьПризнакФиксРасчетНачислениямОплатыТруда(МенеджерРасчета);
		Иначе
			ОбновитьДанныеДляРасчетаСохраняемогоЗаработка();	
		КонецЕсли;
		МенеджерРасчета = РасчетЗарплатыРасширенный.СоздатьМенеджерРасчета(Объект.ПериодРегистрации, Объект.Организация);
		ЗаполнитьНастройкиМенеджераРасчета(МенеджерРасчета, ПериодРасчетаЗарплаты, СохранятьИсправления);
		ЗаполнитьНачисления(МенеджерРасчета, ПериодРасчетаЗарплаты);
		ЗаполнитьПерерасчеты(МенеджерРасчета);
		
		МенеджерРасчета.НастройкиБухучета.КоэффициентыСреднегоЗаработкаДокумента = УчетСреднегоЗаработка.КоэффициентыРаспределенияСреднегоЗаработкаДокумента(Объект, ОписаниеДокумента(ЭтаФорма));
		МенеджерРасчета.НастройкиБухучета.КоэффициентыРаспределенияДенежногоСодержания = Объект.КоэффициентыРаспределенияДенежногоСодержания.Выгрузить();
		
	Иначе
		ДанныеФормыВДанныеМенеджераРасчета(МенеджерРасчета);
	КонецЕсли;	
	
	ЗаполнитьУдержания(МенеджерРасчета);
	
	МенеджерРасчета.РассчитатьЗарплату();
	
	СброситьПризнакФиксРасчет(МенеджерРасчета, ЗафиксированныеСтрокиОплатыТруда); 
	
	РасчетЗарплатыВДанныеФормы(МенеджерРасчета.Зарплата);
	
КонецПроцедуры
//1АБ Беляев 12.04.2021 - Доработка 5 "Добавить управление расчетом удержаний"

#КонецОбласти

//1АБ Беляев 04.07.2021 - Доработка 7 "Изменить дату начала для расчета среднего для единовременной выплаты с периода регистрации на дату начала события"
#Область Доработка_7_СреднийЗаработокДляЕдиновременнойВыплаты
&НаСервере
&ИзменениеИКонтроль("ДополнитьНачисленияВыплачиваемыеКОтпуску")
Процедура АБ_ДополнитьНачисленияВыплачиваемыеКОтпуску(ТаблицаНачислений, МенеджерРасчета, ПериодРасчетаЗарплаты)
	
	ПредоставляетсяЕдиновременнаяВыплатаКОтпуску =
		Объект.ПредоставитьЕдиновременнуюВыплатуКОтпуску И ЗначениеЗаполнено(Объект.ВидРасчетаЕдиновременнойВыплатыКОтпуску);
		
	ПериодРегистрацииЕдиновременнойВыплаты = Объект.ПериодРегистрации;
	ПериодРегистрацииМатериальнойПомощи = Объект.ПериодРегистрации;
	#Вставка
	//1АБ Беляев +
	НачалоПериода1 = Объект.ПериодРегистрации;
	Если ОтпускНачинаетсяВСледующемМесяце(НачалоПериода1) И ПредоставляетсяЕдиновременнаяВыплатаКОтпуску Тогда
		ПериодРегистрацииЕдиновременнойВыплаты = НачалоМесяца(Объект.ДатаНачалаСобытия);
	КонецЕсли;
	//1АБ Беляев -
	#КонецВставки	
	
	// Если потребуется начислять единоразовые начисления и при этом данный документ - исправление,
	// нужно переопределить периоды действия для единоразовых начислений.
	ПараметрыИсправленного = Неопределено;
	Если ИсправлениеДокументовЗарплатаКадрыКлиентСервер.ЭтоИсправление(ЭтотОбъект, ПараметрыИсправленного)
		И (ПредоставляетсяЕдиновременнаяВыплатаКОтпуску	Или Объект.ПредоставитьМатериальнуюПомощьПриОтпуске) Тогда
			
		РеквизитыИсправленного = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(ПараметрыИсправленного.Ссылка,
			"ПредоставитьЕдиновременнуюВыплатуКОтпуску,ВидРасчетаЕдиновременнойВыплатыКОтпуску,ПредоставитьМатериальнуюПомощьПриОтпуске");
		
		ПервичныйДокумент = ИсправлениеДокументовЗарплатаКадры.ПервыйДокументЦепочкиИсправлений(ПараметрыИсправленного.Ссылка);
		ПервичныйПериодРегистрации = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(ПервичныйДокумент, "ПериодРегистрации");
		#Вставка
		ДатаНачалаСобытия1 = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(ПервичныйДокумент, "ДатаНачалаСобытия");
		#КонецВставки
		
		// Если единовременная выплата начислялась и будет начисляться - сохраним ее период в документе-исправлении.
		Если ПредоставляетсяЕдиновременнаяВыплатаКОтпуску
			И РеквизитыИсправленного.ПредоставитьЕдиновременнуюВыплатуКОтпуску И ЗначениеЗаполнено(РеквизитыИсправленного.ВидРасчетаЕдиновременнойВыплатыКОтпуску) Тогда
			ПериодРегистрацииЕдиновременнойВыплаты = ПервичныйПериодРегистрации;
			#Вставка
			ПериодРегистрацииЕдиновременнойВыплаты = НачалоМесяца(ДатаНачалаСобытия1);
			#КонецВставки
		КонецЕсли;
		// Если матпомощь начислялась и будет начисляться - сохраним ее период в документе-исправлении.
		Если Объект.ПредоставитьМатериальнуюПомощьПриОтпуске И РеквизитыИсправленного.ПредоставитьМатериальнуюПомощьПриОтпуске Тогда
			ПериодРегистрацииМатериальнойПомощи = ПервичныйПериодРегистрации;
		КонецЕсли;
	КонецЕсли;
	
	ТаблицаВедущихНачислений = МенеджерРасчета.НовыйВедущиеНачисленияСотрудников();
	
	РегистраторРазовыхНачислений = ДокументыРазовыхНачислений.РегистраторРазовогоНачисления(Объект.Ссылка);
	
	Если ПредоставляетсяЕдиновременнаяВыплатаКОтпуску Тогда
		НовыйИнтервал = ТаблицаНачислений.Добавить();
		НовыйИнтервал.Сотрудник = Объект.Сотрудник;
		НовыйИнтервал.Начисление = Объект.ВидРасчетаЕдиновременнойВыплатыКОтпуску;
		НовыйИнтервал.ДатаНачала = НачалоМесяца(ПериодРегистрацииЕдиновременнойВыплаты);
		НовыйИнтервал.ДатаОкончания = КонецМесяца(ПериодРегистрацииЕдиновременнойВыплаты);
		НовыйИнтервал.ПериодПолученияПоказателей = Объект.ДатаНачалаСобытия;
		НовыйИнтервал.РегистраторРазовогоНачисления = РегистраторРазовыхНачислений;
		
		СтрокаТаблицыВедущих = ТаблицаВедущихНачислений.Добавить();
		ЗаполнитьЗначенияСвойств(СтрокаТаблицыВедущих, НовыйИнтервал); 
	КонецЕсли;
	
	Если Объект.ПредоставитьМатериальнуюПомощьПриОтпуске Тогда
		НовыйИнтервал = ТаблицаНачислений.Добавить();
		НовыйИнтервал.Сотрудник = Объект.Сотрудник;
		НовыйИнтервал.Начисление = Объект.ВидРасчетаМатериальнойПомощиПриОтпуске;
		НовыйИнтервал.ДатаНачала = НачалоМесяца(ПериодРегистрацииМатериальнойПомощи);
		НовыйИнтервал.ДатаОкончания = КонецМесяца(ПериодРегистрацииМатериальнойПомощи);
		НовыйИнтервал.ПериодПолученияПоказателей = Объект.ДатаНачалаСобытия;
		НовыйИнтервал.РегистраторРазовогоНачисления = РегистраторРазовыхНачислений;
		
		СтрокаТаблицыВедущих = ТаблицаВедущихНачислений.Добавить();
		ЗаполнитьЗначенияСвойств(СтрокаТаблицыВедущих, НовыйИнтервал); 
	КонецЕсли;
	
	Если ТаблицаВедущихНачислений.Количество() > 0 Тогда	
		ЗависимыеНачисления = МенеджерРасчета.ЗависимыеНачисленияРассчитываемыеСРазовыми(ТаблицаВедущихНачислений);
		Для Каждого СтрокаЗависимогоНачисления Из ЗависимыеНачисления Цикл
			Если ПериодРасчетаЗарплаты <> Неопределено
				И ОбщегоНазначенияБЗК.ДатаВИнтервале(СтрокаЗависимогоНачисления.ДатаНачала, ПериодРасчетаЗарплаты.ДатаНачала, ПериодРасчетаЗарплаты.ДатаОкончания, Истина) 
				И ОбщегоНазначенияБЗК.ДатаВИнтервале(СтрокаЗависимогоНачисления.ДатаОкончания, ПериодРасчетаЗарплаты.ДатаНачала, ПериодРасчетаЗарплаты.ДатаОкончания, Истина) Тогда
				
				Продолжить;
			КонецЕсли;	
			
			Если ПериодРасчетаЗарплаты <> Неопределено
				И ОбщегоНазначенияБЗК.ДатаВИнтервале(СтрокаЗависимогоНачисления.ДатаНачала, ПериодРасчетаЗарплаты.ДатаНачала, ПериодРасчетаЗарплаты.ДатаОкончания, Истина) Тогда
				
				НовыйИнтервал = ТаблицаНачислений.Добавить();	
				ЗаполнитьЗначенияСвойств(НовыйИнтервал, СтрокаЗависимогоНачисления);
				НовыйИнтервал.РассчитыватьПоРазовымНачислениямДокумента = Истина;
				НовыйИнтервал.РегистраторРазовогоНачисления = РегистраторРазовыхНачислений;
				НовыйИнтервал.ДатаНачала = КонецДня(ПериодРасчетаЗарплаты.ДатаОкончания) + 1;
			Иначе
				НовыйИнтервал = ТаблицаНачислений.Добавить();	
				ЗаполнитьЗначенияСвойств(НовыйИнтервал, СтрокаЗависимогоНачисления);
				НовыйИнтервал.РассчитыватьПоРазовымНачислениямДокумента = Истина;
				НовыйИнтервал.РегистраторРазовогоНачисления = РегистраторРазовыхНачислений;
			КонецЕсли;	
		КонецЦикла;	
	КонецЕсли;
КонецПроцедуры
#КонецОбласти
//1АБ Беляев 04.07.2021 - Доработка 7 "Изменить дату начала для расчета среднего для единовременной выплаты с периода регистрации на дату начала события"