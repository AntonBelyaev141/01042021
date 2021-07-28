#Область ДобавленнаяОбработкойФункциональность
#Область СозданиеДополнительныхЭлементов
&НаСервере
Процедура АБ_НДФЛ6Расшифровка_ПриСозданииНаСервереПосле(Отказ, СтандартнаяОбработка)
	//+1АБ Беляев 28.05.2021
	Команда1 = Команды.Добавить("АБ_НДФЛ6Расшифровка_ДополнительнаяКоманда_1");
	Команда1.Заголовок = "Дополнительная команда 1";
	Команда1.Действие = "АБ_НДФЛ6Расшифровка_СформироватьРасшифровку";
	
	Группа3 = Элементы.Найти("АБ_НДФЛ6Расшифровка_Группа3");
	ЭлементКоманда1 = Элементы.Добавить("ЭлементДополнительнаяКоманда1",Тип("КнопкаФормы"),Группа3);
	ЭлементКоманда1.Заголовок = "Дополнительная команда 1";
	ЭлементКоманда1.Вид = ВидКнопкиФормы.ОбычнаяКнопка;
	ЭлементКоманда1.ИмяКоманды = "АБ_НДФЛ6Расшифровка_ДополнительнаяКоманда_1";
	
	ИмяЭлемента = 1;
		
	ТабличныйДокумент1 = Элементы.Добавить("ТабличныйДокумент" + ИмяЭлемента, Тип("ПолеФормы"), Группа3);
	ТабличныйДокумент1.ПутьКДанным      = "Объект."+"АБ_НДФЛ6Расшифровка_ДокументРезультат"+ИмяЭлемента;
	ТабличныйДокумент1.Заголовок = "Раздел 2 Доходы";
	ТабличныйДокумент1.Вид = ВидПоляФормы.ПолеТабличногоДокумента;
	
	ИмяЭлемента = 2;
	Группа4 = Элементы.Найти("АБ_НДФЛ6Расшифровка_Группа4");
	ТабличныйДокумент2 = Элементы.Добавить("ТабличныйДокумент" + ИмяЭлемента, Тип("ПолеФормы"), Группа4);
	ТабличныйДокумент2.ПутьКДанным      = "Объект."+"АБ_НДФЛ6Расшифровка_ДокументРезультат"+ИмяЭлемента;
	ТабличныйДокумент2.Заголовок = "Раздел 2 Вычеты";
	ТабличныйДокумент2.Вид = ВидПоляФормы.ПолеТабличногоДокумента;
	
	ИмяЭлемента = 3;
	Группа5 = Элементы.Найти("АБ_НДФЛ6Расшифровка_Группа5");
	ТабличныйДокумент3 = Элементы.Добавить("ТабличныйДокумент" + ИмяЭлемента, Тип("ПолеФормы"), Группа5);
	ТабличныйДокумент3.ПутьКДанным      = "Объект."+"АБ_НДФЛ6Расшифровка_ДокументРезультат"+ИмяЭлемента;
	ТабличныйДокумент3.Заголовок = "Раздел 2 Налоги";
	ТабличныйДокумент3.Вид = ВидПоляФормы.ПолеТабличногоДокумента;
	
	ИмяЭлемента = 4;
	Группа6 = Элементы.Найти("АБ_НДФЛ6Расшифровка_Группа6");
	ТабличныйДокумент4 = Элементы.Добавить("ТабличныйДокумент" + ИмяЭлемента, Тип("ПолеФормы"), Группа6);
	ТабличныйДокумент4.ПутьКДанным      = "Объект."+"АБ_НДФЛ6Расшифровка_ДокументРезультат"+ИмяЭлемента;
	ТабличныйДокумент4.Заголовок = "Раздел 1 Налоги";
	ТабличныйДокумент4.Вид = ВидПоляФормы.ПолеТабличногоДокумента;
	
	ИмяЭлемента = 5;
	Группа7 = Элементы.Найти("АБ_НДФЛ6Расшифровка_Группа7");
	ТабличныйДокумент5 = Элементы.Добавить("ТабличныйДокумент" + ИмяЭлемента, Тип("ПолеФормы"), Группа7);
	ТабличныйДокумент5.ПутьКДанным      = "Объект."+"АБ_НДФЛ6Расшифровка_ДокументРезультат"+ИмяЭлемента;
	ТабличныйДокумент5.Заголовок = "Раздел 1 Возвраты";
	ТабличныйДокумент5.Вид = ВидПоляФормы.ПолеТабличногоДокумента;
	//-1АБ Беляев 28.05.2021
КонецПроцедуры
#КонецОбласти
//+1АБ Беляев 28.05.2021
#Область СтартоваяКнопкаОбработки
&НаКлиенте
Процедура АБ_НДФЛ6Расшифровка_СформироватьРасшифровку()
	
	РезультатЗапуска = ЗаполнитьАвтоНаСервере();
	
	Если РезультатЗапуска.Статус = "Выполнено" Тогда
		РегламентированнаяОтчетностьКлиент.ОбновитьДеревоРазделовВФормеОтчета(ЭтаФорма);
		Если НЕ Элементы.РазделыОтчета.ТекущиеДанные.ПолучитьРодителя() = Неопределено Тогда
			Элементы.РазделыОтчета.ТекущаяСтрока
			= Элементы.РазделыОтчета.ТекущиеДанные.ПолучитьРодителя().ПолучитьЭлементы()[0].ПолучитьИдентификатор();
		КонецЕсли;
	ИначеЕсли РезультатЗапуска.Статус = "Выполняется" Тогда
		ОповещениеОЗавершении = Новый ОписаниеОповещения("ОбработатьЗавершениеАвтозаполненияВФоне", ЭтотОбъект);
		ПараметрыОжидания = ПараметрыОжидания();
		ДлительныеОперацииКлиент.ОжидатьЗавершение(РезультатЗапуска, ОповещениеОЗавершении, ПараметрыОжидания);
	КонецЕсли;


КонецПроцедуры
#КонецОбласти
//-1АБ Беляев 28.05.2021

#Область ПерехватУправления
&НаСервере
&ИзменениеИКонтроль("ЗаполнитьАвтоНаСервере")
Функция АБ_ЗаполнитьАвтоНаСервере()

	Модифицированность = Истина;

	ОбъектОтчета = ОбъектОтчета(ЭтаФорма.ИмяФормы);

	СтруктураДанныхРазделов = ОбъектОтчета.СтруктураДанныхРазделов(СтруктураРеквизитовФормы.мВыбраннаяФорма);

	ОбъектОтчета.СохранитьДанныеРаздела(СтруктураРеквизитовФормы.мВыбраннаяФорма,
	СтруктураРеквизитовФормы,
	мСтруктураМногоуровневыхРазделов,
	СтруктураДанныхРазделов,
	ТабличныйДокумент,
	СтруктураРеквизитовФормы.НаимТекущегоРаздела);

	ОбновитьСтруктурыДанныхРазделов(СтруктураДанныхРазделов);

	РегламентированнаяОтчетность.ПоместитьВКэш(Неопределено, УникальныйИдентификатор,
	СтруктураРеквизитовФормы.АдресВоВременномХранилище);

	ВозможныеКодыПериода_Приложение1 = ОбъектОтчета.КодыОтчетногоПериодаПриКоторыхМожетБытьЗаполненоПриложение1();

	ПараметрыОтчета = Новый Структура();
	ПараметрыОтчета.Вставить("Организация",                  СтруктураРеквизитовФормы.Организация);
	ПараметрыОтчета.Вставить("ДатаНачалаПериодаОтчета",      СтруктураРеквизитовФормы.мДатаНачалаПериодаОтчета);
	ПараметрыОтчета.Вставить("ДатаКонцаПериодаОтчета",       СтруктураРеквизитовФормы.мДатаКонцаПериодаОтчета);
	ПараметрыОтчета.Вставить("НомерКорректировки",           СтруктураДанныхТитульный.НомерКорректировки);
	ПараметрыОтчета.Вставить("ДатаПодписи",                  СтруктураДанныхТитульный.ДатаПодписи);
	ПараметрыОтчета.Вставить("УникальныйИдентификаторФормы", ЭтаФорма.УникальныйИдентификатор);
	ПараметрыОтчета.Вставить("АдресВоВременномХранилище",    СтруктураРеквизитовФормы.АдресВоВременномХранилище);
	ПараметрыОтчета.Вставить("ЗаполнятьПриложение1",
	ВозможныеКодыПериода_Приложение1.Найти(СокрЛП(СтруктураДанныхТитульный.Период)) <> Неопределено);

	// Помещение данных в контейнер.
	Контейнер = Новый Структура();
	Контейнер.Вставить("Титульный", СтруктураДанныхТитульный);
	Для каждого Раздел Из мСтруктураМногоуровневыхРазделов Цикл
		Если НЕ Раздел.Значение.Свойство("Подчиненность") Тогда
			Контейнер.Вставить(Раздел.Ключ, ПолучитьИзВременногоХранилища(
			СтруктураРеквизитовФормы["АдресВоВрХранилищеДеревоДанных" + Раздел.Ключ]));
		КонецЕсли;
	КонецЦикла;

	НаименованиеЗадания = НСтр("ru = 'Автоматическое заполнение по данным информационной базы'");

	ПараметрыПроцедуры = Новый Структура;
	ПараметрыПроцедуры.Вставить("ИДОтчета", ИмяОтчета(ЭтаФорма.ИмяФормы));
	ПараметрыПроцедуры.Вставить("ИДРедакцииОтчета", ИмяФормы(ЭтаФорма.ИмяФормы));
	ПараметрыПроцедуры.Вставить("ПараметрыОтчета", ПараметрыОтчета);
	ПараметрыПроцедуры.Вставить("Контейнер", Контейнер);

	ПараметрыВыполненияВФоне = ДлительныеОперации.ПараметрыВыполненияВФоне(УникальныйИдентификатор);
	ПараметрыВыполненияВФоне.НаименованиеФоновогоЗадания = НаименованиеЗадания;
	ПараметрыВыполненияВФоне.ЗапуститьВФоне = Истина;

	#Удаление
	РезультатЗапуска = ДлительныеОперации.ВыполнитьВФоне("РегламентированнаяОтчетность.ЗаполнитьОтчетВФоне",
	ПараметрыПроцедуры, ПараметрыВыполненияВФоне);
	#КонецУдаления
	#Вставка
	//+1АБ Беляев 28.05.2021
	РезультатЗапуска = Новый Структура;
	РезультатЗапуска.Вставить("Статус","Выполняется");
	РезультатЗапуска.Вставить("ИдентификаторЗадания",Неопределено);
	РезультатЗапуска.Вставить("АдресРезультатЗапускаа",ПоместитьВоВременноеХранилище(Неопределено,ПараметрыОтчета.УникальныйИдентификаторФормы));
	РезультатЗапуска.Вставить("КраткоеПредставлениеОшибки","");
	РезультатЗапуска.Вставить("ПодробноеПредставлениеОшибки","");
	РезультатЗапуска.Вставить("Сообщения",Новый ФиксированныйМассив(Новый Массив));
	ПараметрыЭкспортнойПроцедуры = Новый Массив;
	ПараметрыЭкспортнойПроцедуры.Добавить(ПараметрыПроцедуры);
	ПараметрыЭкспортнойПроцедуры.Добавить(РезультатЗапуска.АдресРезультатЗапускаа);
	ИмяПроцедуры = "РегламентированнаяОтчетность.ЗаполнитьОтчетВФоне";
	Попытка
		ДлительныеОперации.АБ_НДФЛ6Расшифровка_ВызватьПроцедуру(ИмяПроцедуры, ПараметрыЭкспортнойПроцедуры);
		РезультатЗапуска.Статус = "Выполнено";
	Исключение
		РезультатЗапуска.Статус = "Ошибка";
		РезультатЗапуска.КраткоеПредставлениеОшибки = КраткоеПредставлениеОшибки(ИнформацияОбОшибке());
		РезультатЗапуска.ПодробноеПредставлениеОшибки = ПодробноеПредставлениеОшибки(ИнформацияОбОшибке());
		ЗаписьЖурналаРегистрации(НСтр("ru = 'Ошибка выполнения'", ОбщегоНазначения.КодОсновногоЯзыка()),УровеньЖурналаРегистрации.Ошибка,,,РезультатЗапуска.ПодробноеПредставлениеОшибки);
	КонецПопытки;
	//-1АБ Беляев 28.05.2021
	#КонецВставки

	Если РезультатЗапуска.Статус = "Выполнено" Тогда
		ЗагрузитьПодготовленныеДанные();
	ИначеЕсли РезультатЗапуска.Статус = "Ошибка" Тогда
		ВызватьИсключение РезультатЗапуска.ПодробноеПредставлениеОшибки;
	КонецЕсли;
	#Вставка
	//+1АБ Беляев 28.05.2021
	СтруктураДанных = ПолучитьИзВременногоХранилища(СтруктураРеквизитовФормы.АдресВоВременномХранилище);
	//...моя обработка расшифровки
	АБ_НДФЛ6Расшифровка_ОбработатьСтруктуруДанных(СтруктураДанных);
	//...моя обработка расшифровки
	Если ЗначениеЗаполнено(СтруктураРеквизитовФормы.АдресВоВременномХранилище) Тогда
		УдалитьИзВременногоХранилища(СтруктураРеквизитовФормы.АдресВоВременномХранилище);
	КонецЕсли;
	СтруктураРеквизитовФормы.АдресВоВременномХранилище = Неопределено;
	//-1АБ Беляев 28.05.2021
	#КонецВставки

	Возврат РезультатЗапуска;

КонецФункции
&НаСервере
&ИзменениеИКонтроль("ЗагрузитьПодготовленныеДанные")
Процедура АБ_ЗагрузитьПодготовленныеДанные()

	#Удаление
	СтруктураДанных = ПолучитьИзВременногоХранилища(СтруктураРеквизитовФормы.АдресВоВременномХранилище);
	#КонецУдаления
	#Вставка
	//+1АБ Беляев 28.05.2021
	Попытка
	СтруктураДанных = ПолучитьИзВременногоХранилища(СтруктураРеквизитовФормы.АдресВоВременномХранилище);
	Исключение
	Возврат;
	КонецПопытки;
	//-1АБ Беляев 28.05.2021
	#КонецВставки

	#Удаление
	Если ЗначениеЗаполнено(СтруктураРеквизитовФормы.АдресВоВременномХранилище) Тогда
		УдалитьИзВременногоХранилища(СтруктураРеквизитовФормы.АдресВоВременномХранилище);
	КонецЕсли;
	СтруктураРеквизитовФормы.АдресВоВременномХранилище = Неопределено;
	#КонецУдаления

	Если ТипЗнч(СтруктураДанных) <> Тип("Структура") Тогда
		Возврат;
	КонецЕсли;

	Контейнер = Неопределено;
	Если СтруктураДанных.Свойство("Контейнер", Контейнер)
		И ТипЗнч(Контейнер) = Тип("Структура") Тогда

		// Получение данных из контейнера.
		СтруктураДанныхТитульный = Контейнер["Титульный"];
		Для каждого Раздел Из мСтруктураМногоуровневыхРазделов Цикл
			Если НЕ Раздел.Значение.Свойство("Подчиненность") Тогда
				РегламентированнаяОтчетность.ПоместитьВКэш(Контейнер[Раздел.Ключ], УникальныйИдентификатор,
				СтруктураРеквизитовФормы["АдресВоВрХранилищеДеревоДанных" + Раздел.Ключ]);
			КонецЕсли;
		КонецЦикла;

		СтруктураРеквизитовФормы.НомераСтрокМногоуровнегоРаздела.Очистить();
		СтруктураРеквизитовФормы.НомераСтрокМногоуровнегоРаздела.Добавить(1);

		СформироватьДеревоРазделовОтчетаНаСервере();

		Для каждого НайденныйРаздел Из РазделыОтчета.ПолучитьЭлементы() Цикл
			Если НайденныйРаздел.КолонкаРазделыОтчетаСокрНаим = СтруктураРеквизитовФормы.НаимТекущегоРаздела Тогда
				Элементы.РазделыОтчета.ТекущаяСтрока = НайденныйРаздел.ПолучитьИдентификатор();
				Прервать;
			КонецЕсли;
		КонецЦикла;

		ВывестиДанныеВТабличныйДокумент(СтруктураРеквизитовФормы.НаимТекущегоРаздела,
		СтруктураРеквизитовФормы.НомераСтрокМногоуровнегоРаздела);

		РасчетНаСервере();

		Если Элементы.Расшифровать.Видимость Тогда
			Элементы.Расшифровать.Доступность = Истина;
			Элементы.ТабличныйДокументКонтекстноеМенюРасшифровать.Доступность = Истина;
		КонецЕсли;

	КонецЕсли;

КонецПроцедуры
#КонецОбласти
//+1АБ Беляев 28.05.2021
#Область ВыводДополнительныхТаблиц
&НаСервере
Процедура АБ_НДФЛ6Расшифровка_ОбработатьСтруктуруДанных(СтруктураДанных)
	Контейнер = Неопределено;
	ВременноеОписаниеТаблиц = Неопределено;
	Если ТипЗнч(СтруктураДанных) <>Тип("Неопределено") Тогда
	Если СтруктураДанных.Свойство("Контейнер",Контейнер) Тогда
	Если Контейнер.Свойство("ПолноеОписаниеТаблиц",ВременноеОписаниеТаблиц) Тогда
	//...обработка расшифровки
	АБ_НДФЛ6Расшифровка_ВывестиРасшифровку_Раздел2Доходы(ВременноеОписаниеТаблиц);
	АБ_НДФЛ6Расшифровка_ВывестиРасшифровку_Раздел2Вычеты(ВременноеОписаниеТаблиц);
	АБ_НДФЛ6Расшифровка_ВывестиРасшифровку_Раздел2Налоги(ВременноеОписаниеТаблиц);
	АБ_НДФЛ6Расшифровка_ВывестиРасшифровку_Раздел1Налоги(ВременноеОписаниеТаблиц);
	АБ_НДФЛ6Расшифровка_ВывестиРасшифровку_Раздел1Возвраты(ВременноеОписаниеТаблиц);
	//...обработка расшифровки
	КонецЕсли;
	КонецЕсли;
	КонецЕсли;
КонецПроцедуры

#Область ВыводРаздела2_Доходы
Процедура АБ_НДФЛ6Расшифровка_ВывестиРасшифровку_Раздел2Доходы(ВременноеОписаниеТаблиц)
	//1 Раздел
	ТекОбъект=РеквизитФормыВЗначение("Объект");
	ТекущаяСхемаКомпоновкиДанных=ТекОбъект.ПолучитьМакет("АБ_НДФЛ6Расшифровка_СхемаКомпоновкиДанных_Раздел2Доходы");
 	
	Настройки=ТекущаяСхемаКомпоновкиДанных.НастройкиПоУмолчанию;
	КомпоновщикМакета= Новый КомпоновщикМакетаКомпоновкиДанных;
	МакетКомпоновки=КомпоновщикМакета.Выполнить(ТекущаяСхемаКомпоновкиДанных,Настройки);
	ПроцессорКомпоновки=Новый ПроцессорКомпоновкиДанных;
	//+
	ТаблицаДанных_Раздел2Доходы=Новый ТаблицаЗначений;
	АБ_НДФЛ6Расшифровка_ПереписатьВУдобнойФорме_Раздел2Доходы(ТаблицаДанных_Раздел2Доходы,ВременноеОписаниеТаблиц.Раздел2Доходы);
	//-
	ВнешнийНабор=Новый Структура("ТаблицаДанных_Раздел2Доходы",ТаблицаДанных_Раздел2Доходы);
	ПроцессорКомпоновки.Инициализировать(МакетКомпоновки,ВнешнийНабор);
	
	ТекОбъект.АБ_НДФЛ6Расшифровка_ДокументРезультат1.Очистить();
	ПроцессорВывода=Новый ПроцессорВыводаРезультатаКомпоновкиДанныхВТабличныйДокумент;
	ПроцессорВывода.УстановитьДокумент(ТекОбъект.АБ_НДФЛ6Расшифровка_ДокументРезультат1);
	ПроцессорВывода.Вывести(ПроцессорКомпоновки);
	ЗначениеВРеквизитФормы(ТекОбъект,"Объект");

КонецПроцедуры

Процедура АБ_НДФЛ6Расшифровка_ПереписатьВУдобнойФорме_Раздел2Доходы(ТаблицаДанных_Раздел2Доходы,Таблица_Раздел2Доходы)
	КвЧ = Новый КвалификаторыЧисла(15,2);
	КвС = Новый КвалификаторыСтроки(20);
	КвЧ2 = Новый КвалификаторыЧисла(2,0);
	ТаблицаДанных_Раздел2Доходы.Колонки.Добавить("П000020011003",Новый ОписаниеТипов("Число",,,КвЧ));
	ТаблицаДанных_Раздел2Доходы.Колонки.Добавить("П000020011103",Новый ОписаниеТипов("Число",,,КвЧ));
	ТаблицаДанных_Раздел2Доходы.Колонки.Добавить("П000020011203",Новый ОписаниеТипов("Число",,,КвЧ));
	ТаблицаДанных_Раздел2Доходы.Колонки.Добавить("П000020011303",Новый ОписаниеТипов("Число",,,КвЧ));
	ТаблицаДанных_Раздел2Доходы.Колонки.Добавить("КБК",Новый ОписаниеТипов("Строка",,,,КвС));
	ТаблицаДанных_Раздел2Доходы.Колонки.Добавить("Ставка",Новый ОписаниеТипов("ПеречислениеСсылка.НДФЛСтавки"));
	ТаблицаДанных_Раздел2Доходы.Колонки.Добавить("СтавкаНалога",Новый ОписаниеТипов("Число",,,КвЧ2));
	ТаблицаДанных_Раздел2Доходы.Колонки.Добавить("ФизическоеЛицо",Новый ОписаниеТипов("СправочникСсылка.ФизическиеЛица"));
	ТаблицаДанных_Раздел2Доходы.Колонки.Добавить("Начисление",Новый ОписаниеТипов("ПланВидовРасчетаСсылка.Начисления"));
	ТаблицаДанных_Раздел2Доходы.Колонки.Добавить("ДатаПолученияДохода",Новый ОписаниеТипов("Дата"));
	
	ТипНачисление = Метаданные.ОпределяемыеТипы.ДокументыОснованияНДФЛ;
	МассивТипов = Новый Массив;
	МассивТипов.Добавить(ТипНачисление);	
	ТаблицаДанных_Раздел2Доходы.Колонки.Добавить("Регистратор",Новый ОписаниеТипов(МассивТипов));
	Для Каждого Строка Из Таблица_Раздел2Доходы Цикл
		НоваяСтрока = ТаблицаДанных_Раздел2Доходы.Добавить();
		ЗаполнитьЗначенияСвойств(НоваяСтрока,Строка,"П000020011003,П000020011103,П000020011203,П000020011303,КБК,Ставка,СтавкаНалога,ФизическоеЛицо,Начисление,Регистратор");
		НоваяСтрока.ДатаПолученияДохода = Строка.Период;
	КонецЦикла;
КонецПроцедуры
#КонецОбласти

#Область ВыводРаздела2_Вычеты
Процедура АБ_НДФЛ6Расшифровка_ВывестиРасшифровку_Раздел2Вычеты(ВременноеОписаниеТаблиц)
	//1 Раздел
	ТекОбъект=РеквизитФормыВЗначение("Объект");
	ТекущаяСхемаКомпоновкиДанных=ТекОбъект.ПолучитьМакет("АБ_НДФЛ6Расшифровка_СхемаКомпоновкиДанных_Раздел2Вычеты");
 	
	Настройки=ТекущаяСхемаКомпоновкиДанных.НастройкиПоУмолчанию;
	КомпоновщикМакета= Новый КомпоновщикМакетаКомпоновкиДанных;
	МакетКомпоновки=КомпоновщикМакета.Выполнить(ТекущаяСхемаКомпоновкиДанных,Настройки);
	ПроцессорКомпоновки=Новый ПроцессорКомпоновкиДанных;
	//+
	ТаблицаДанных_Раздел2Вычеты=Новый ТаблицаЗначений;
	АБ_НДФЛ6Расшифровка_ПереписатьВУдобнойФорме_Раздел2Вычеты(ТаблицаДанных_Раздел2Вычеты,ВременноеОписаниеТаблиц.Раздел2Вычеты);
	//-
	ВнешнийНабор=Новый Структура("ТаблицаДанных_Раздел2Вычеты",ТаблицаДанных_Раздел2Вычеты);
	ПроцессорКомпоновки.Инициализировать(МакетКомпоновки,ВнешнийНабор);
	
	ТекОбъект.АБ_НДФЛ6Расшифровка_ДокументРезультат2.Очистить();
	ПроцессорВывода=Новый ПроцессорВыводаРезультатаКомпоновкиДанныхВТабличныйДокумент;
	ПроцессорВывода.УстановитьДокумент(ТекОбъект.АБ_НДФЛ6Расшифровка_ДокументРезультат2);
	ПроцессорВывода.Вывести(ПроцессорКомпоновки);
	ЗначениеВРеквизитФормы(ТекОбъект,"Объект");

КонецПроцедуры

Процедура АБ_НДФЛ6Расшифровка_ПереписатьВУдобнойФорме_Раздел2Вычеты(ТаблицаДанных_Раздел2Вычеты,Таблица_Раздел2Вычеты)
	КвЧ = Новый КвалификаторыЧисла(15,2);
	КвС = Новый КвалификаторыСтроки(20);
	КвЧ2 = Новый КвалификаторыЧисла(2,0);
	ТаблицаДанных_Раздел2Вычеты.Колонки.Добавить("П000020013003",Новый ОписаниеТипов("Число",,,КвЧ));
	ТаблицаДанных_Раздел2Вычеты.Колонки.Добавить("КБК",Новый ОписаниеТипов("Строка",,,,КвС));
	ТаблицаДанных_Раздел2Вычеты.Колонки.Добавить("Ставка",Новый ОписаниеТипов("ПеречислениеСсылка.НДФЛСтавки"));
	ТаблицаДанных_Раздел2Вычеты.Колонки.Добавить("СтавкаНалога",Новый ОписаниеТипов("Число",,,КвЧ2));
	ТаблицаДанных_Раздел2Вычеты.Колонки.Добавить("ФизическоеЛицо",Новый ОписаниеТипов("СправочникСсылка.ФизическиеЛица"));
	ТаблицаДанных_Раздел2Вычеты.Колонки.Добавить("КодВычета",Новый ОписаниеТипов("СправочникСсылка.ВидыВычетовНДФЛ"));
	ТаблицаДанных_Раздел2Вычеты.Колонки.Добавить("ДатаПолученияДохода",Новый ОписаниеТипов("Дата"));
	
		
	ТипНачисление = Метаданные.ОпределяемыеТипы.ДокументыОснованияНДФЛ;
	МассивТипов = Новый Массив;
	МассивТипов.Добавить(ТипНачисление);	
	ТаблицаДанных_Раздел2Вычеты.Колонки.Добавить("Регистратор",Новый ОписаниеТипов(МассивТипов));
	Для Каждого Строка Из Таблица_Раздел2Вычеты Цикл
		НоваяСтрока = ТаблицаДанных_Раздел2Вычеты.Добавить();
		ЗаполнитьЗначенияСвойств(НоваяСтрока,Строка,"П000020013003,КБК,Ставка,СтавкаНалога,ФизическоеЛицо,КодВычета,Регистратор");
		НоваяСтрока.ДатаПолученияДохода = Строка.Период;
	КонецЦикла;
КонецПроцедуры
#КонецОбласти

#Область ВыводРаздела2_Налоги
Процедура АБ_НДФЛ6Расшифровка_ВывестиРасшифровку_Раздел2Налоги(ВременноеОписаниеТаблиц)
	//1 Раздел
	ТекОбъект=РеквизитФормыВЗначение("Объект");
	ТекущаяСхемаКомпоновкиДанных=ТекОбъект.ПолучитьМакет("АБ_НДФЛ6Расшифровка_СхемаКомпоновкиДанных_Раздел2Налоги");
 	
	Настройки=ТекущаяСхемаКомпоновкиДанных.НастройкиПоУмолчанию;
	КомпоновщикМакета= Новый КомпоновщикМакетаКомпоновкиДанных;
	МакетКомпоновки=КомпоновщикМакета.Выполнить(ТекущаяСхемаКомпоновкиДанных,Настройки);
	ПроцессорКомпоновки=Новый ПроцессорКомпоновкиДанных;
	//+
	ТаблицаДанных_Раздел2Налоги=Новый ТаблицаЗначений;
	АБ_НДФЛ6Расшифровка_ПереписатьВУдобнойФорме_Раздел2Налоги(ТаблицаДанных_Раздел2Налоги,ВременноеОписаниеТаблиц.Раздел2Налоги);
	//-
	ВнешнийНабор=Новый Структура("ТаблицаДанных_Раздел2Налоги",ТаблицаДанных_Раздел2Налоги);
	ПроцессорКомпоновки.Инициализировать(МакетКомпоновки,ВнешнийНабор);
	
	ТекОбъект.АБ_НДФЛ6Расшифровка_ДокументРезультат3.Очистить();
	ПроцессорВывода=Новый ПроцессорВыводаРезультатаКомпоновкиДанныхВТабличныйДокумент;
	ПроцессорВывода.УстановитьДокумент(ТекОбъект.АБ_НДФЛ6Расшифровка_ДокументРезультат3);
	ПроцессорВывода.Вывести(ПроцессорКомпоновки);
	ЗначениеВРеквизитФормы(ТекОбъект,"Объект");

КонецПроцедуры

Процедура АБ_НДФЛ6Расшифровка_ПереписатьВУдобнойФорме_Раздел2Налоги(ТаблицаДанных_Раздел2Налоги,Таблица_Раздел2Налоги)
	КвЧ = Новый КвалификаторыЧисла(15,2);
	КвС = Новый КвалификаторыСтроки(20);
	КвЧ2 = Новый КвалификаторыЧисла(2,0);
	ТаблицаДанных_Раздел2Налоги.Колонки.Добавить("П000020014003",Новый ОписаниеТипов("Число",,,КвЧ));
	ТаблицаДанных_Раздел2Налоги.Колонки.Добавить("П000020016003",Новый ОписаниеТипов("Число",,,КвЧ));
	ТаблицаДанных_Раздел2Налоги.Колонки.Добавить("П000020019003",Новый ОписаниеТипов("Число",,,КвЧ));
	ТаблицаДанных_Раздел2Налоги.Колонки.Добавить("КБК",Новый ОписаниеТипов("Строка",,,,КвС));
	ТаблицаДанных_Раздел2Налоги.Колонки.Добавить("Ставка",Новый ОписаниеТипов("ПеречислениеСсылка.НДФЛСтавки"));
	ТаблицаДанных_Раздел2Налоги.Колонки.Добавить("СтавкаНалога",Новый ОписаниеТипов("Число",,,КвЧ2));
	ТаблицаДанных_Раздел2Налоги.Колонки.Добавить("ФизическоеЛицо",Новый ОписаниеТипов("СправочникСсылка.ФизическиеЛица"));
	ТаблицаДанных_Раздел2Налоги.Колонки.Добавить("ДатаУдержания",Новый ОписаниеТипов("Дата"));
	ТаблицаДанных_Раздел2Налоги.Колонки.Добавить("ДатаПолученияДохода",Новый ОписаниеТипов("Дата"));
	ТипНачисление = Метаданные.ОпределяемыеТипы.ДокументыОснованияНДФЛ;
	МассивТипов = Новый Массив;
	МассивТипов.Добавить(ТипНачисление);	
	ТаблицаДанных_Раздел2Налоги.Колонки.Добавить("Регистратор",Новый ОписаниеТипов(МассивТипов));
	Для Каждого Строка Из Таблица_Раздел2Налоги Цикл
		НоваяСтрока = ТаблицаДанных_Раздел2Налоги.Добавить();
		ЗаполнитьЗначенияСвойств(НоваяСтрока,Строка,"П000020014003,П000020016003,П000020019003,КБК,Ставка,СтавкаНалога,ФизическоеЛицо,ДатаПолученияДохода,ДатаУдержания,Регистратор");
	КонецЦикла;
КонецПроцедуры
#КонецОбласти

#Область ВыводРаздела1_СрокиПеречисления
Процедура АБ_НДФЛ6Расшифровка_ВывестиРасшифровку_Раздел1Налоги(ВременноеОписаниеТаблиц)
	//1 Раздел
	ТекОбъект=РеквизитФормыВЗначение("Объект");
	ТекущаяСхемаКомпоновкиДанных=ТекОбъект.ПолучитьМакет("АБ_НДФЛ6Расшифровка_СхемаКомпоновкиДанных_Раздел1Налоги");
 	
	Настройки=ТекущаяСхемаКомпоновкиДанных.НастройкиПоУмолчанию;
	КомпоновщикМакета= Новый КомпоновщикМакетаКомпоновкиДанных;
	МакетКомпоновки=КомпоновщикМакета.Выполнить(ТекущаяСхемаКомпоновкиДанных,Настройки);
	ПроцессорКомпоновки=Новый ПроцессорКомпоновкиДанных;
	//+
	ТаблицаДанных_Раздел1Налоги=Новый ТаблицаЗначений;
	АБ_НДФЛ6Расшифровка_ПереписатьВУдобнойФорме_Раздел1Налоги(ТаблицаДанных_Раздел1Налоги,ВременноеОписаниеТаблиц.Раздел1Налоги);
	//-
	ВнешнийНабор=Новый Структура("ТаблицаДанных_Раздел1Налоги",ТаблицаДанных_Раздел1Налоги);
	ПроцессорКомпоновки.Инициализировать(МакетКомпоновки,ВнешнийНабор);
	
	ТекОбъект.АБ_НДФЛ6Расшифровка_ДокументРезультат4.Очистить();
	ПроцессорВывода=Новый ПроцессорВыводаРезультатаКомпоновкиДанныхВТабличныйДокумент;
	ПроцессорВывода.УстановитьДокумент(ТекОбъект.АБ_НДФЛ6Расшифровка_ДокументРезультат4);
	ПроцессорВывода.Вывести(ПроцессорКомпоновки);
	ЗначениеВРеквизитФормы(ТекОбъект,"Объект");

КонецПроцедуры

Процедура АБ_НДФЛ6Расшифровка_ПереписатьВУдобнойФорме_Раздел1Налоги(ТаблицаДанных_Раздел1Налоги,Таблица_Раздел1Налоги)
	КвЧ = Новый КвалификаторыЧисла(15,2);
	КвС = Новый КвалификаторыСтроки(20);
	КвЧ2 = Новый КвалификаторыЧисла(2,0);
	ТаблицаДанных_Раздел1Налоги.Колонки.Добавить("П00001М102101",Новый ОписаниеТипов("Дата"));
	ТаблицаДанных_Раздел1Налоги.Колонки.Добавить("П00001М102201",Новый ОписаниеТипов("Число",,,КвЧ));
	ТаблицаДанных_Раздел1Налоги.Колонки.Добавить("КБК",Новый ОписаниеТипов("Строка",,,,КвС));
	ТаблицаДанных_Раздел1Налоги.Колонки.Добавить("ФизическоеЛицо",Новый ОписаниеТипов("СправочникСсылка.ФизическиеЛица"));
	ТаблицаДанных_Раздел1Налоги.Колонки.Добавить("ДатаУдержания",Новый ОписаниеТипов("Дата"));
	ТаблицаДанных_Раздел1Налоги.Колонки.Добавить("ДатаПолученияДохода",Новый ОписаниеТипов("Дата"));
	
	ТипНачисление = Метаданные.ОпределяемыеТипы.ДокументыОснованияНДФЛ;
	МассивТипов = Новый Массив;
	МассивТипов.Добавить(ТипНачисление);	
	ТаблицаДанных_Раздел1Налоги.Колонки.Добавить("Регистратор",Новый ОписаниеТипов(МассивТипов));
	Для Каждого Строка Из Таблица_Раздел1Налоги Цикл
		НоваяСтрока = ТаблицаДанных_Раздел1Налоги.Добавить();
		ЗаполнитьЗначенияСвойств(НоваяСтрока,Строка,"П00001М102101,П00001М102201,КБК,ФизическоеЛицо,ДатаПолученияДохода,ДатаУдержания,Регистратор");
	КонецЦикла;
КонецПроцедуры
#КонецОбласти

#Область ВыводРаздела1_Возвраты
Процедура АБ_НДФЛ6Расшифровка_ВывестиРасшифровку_Раздел1Возвраты(ВременноеОписаниеТаблиц)
	//1 Раздел
	ТекОбъект=РеквизитФормыВЗначение("Объект");
	ТекущаяСхемаКомпоновкиДанных=ТекОбъект.ПолучитьМакет("АБ_НДФЛ6Расшифровка_СхемаКомпоновкиДанных_Раздел1Возвраты");
 	
	Настройки=ТекущаяСхемаКомпоновкиДанных.НастройкиПоУмолчанию;
	КомпоновщикМакета= Новый КомпоновщикМакетаКомпоновкиДанных;
	МакетКомпоновки=КомпоновщикМакета.Выполнить(ТекущаяСхемаКомпоновкиДанных,Настройки);
	ПроцессорКомпоновки=Новый ПроцессорКомпоновкиДанных;
	//+
	ТаблицаДанных_Раздел1Возвраты=Новый ТаблицаЗначений;
	АБ_НДФЛ6Расшифровка_ПереписатьВУдобнойФорме_Раздел1Возвраты(ТаблицаДанных_Раздел1Возвраты,ВременноеОписаниеТаблиц.Раздел1Возвраты);
	//-
	ВнешнийНабор=Новый Структура("ТаблицаДанных_Раздел1Возвраты",ТаблицаДанных_Раздел1Возвраты);
	ПроцессорКомпоновки.Инициализировать(МакетКомпоновки,ВнешнийНабор);
	
	ТекОбъект.АБ_НДФЛ6Расшифровка_ДокументРезультат5.Очистить();
	ПроцессорВывода=Новый ПроцессорВыводаРезультатаКомпоновкиДанныхВТабличныйДокумент;
	ПроцессорВывода.УстановитьДокумент(ТекОбъект.АБ_НДФЛ6Расшифровка_ДокументРезультат5);
	ПроцессорВывода.Вывести(ПроцессорКомпоновки);
	ЗначениеВРеквизитФормы(ТекОбъект,"Объект");

КонецПроцедуры

Процедура АБ_НДФЛ6Расшифровка_ПереписатьВУдобнойФорме_Раздел1Возвраты(ТаблицаДанных_Раздел1Возвраты,Таблица_Раздел1Возвраты)
	КвЧ = Новый КвалификаторыЧисла(15,2);
	КвС = Новый КвалификаторыСтроки(20);
	КвЧ2 = Новый КвалификаторыЧисла(2,0);
	ТаблицаДанных_Раздел1Возвраты.Колонки.Добавить("П00001М203101",Новый ОписаниеТипов("Дата"));
	ТаблицаДанных_Раздел1Возвраты.Колонки.Добавить("П00001М203201",Новый ОписаниеТипов("Число",,,КвЧ));
	ТаблицаДанных_Раздел1Возвраты.Колонки.Добавить("КБК",Новый ОписаниеТипов("Строка",,,,КвС));
	ТаблицаДанных_Раздел1Возвраты.Колонки.Добавить("ФизическоеЛицо",Новый ОписаниеТипов("СправочникСсылка.ФизическиеЛица"));
	ТаблицаДанных_Раздел1Возвраты.Колонки.Добавить("ДатаПолученияДохода",Новый ОписаниеТипов("Дата"));
	
	ТипНачисление = Метаданные.ОпределяемыеТипы.ДокументыОснованияНДФЛ;
	МассивТипов = Новый Массив;
	МассивТипов.Добавить(ТипНачисление);	
	ТаблицаДанных_Раздел1Возвраты.Колонки.Добавить("Регистратор",Новый ОписаниеТипов(МассивТипов));
	Для Каждого Строка Из Таблица_Раздел1Возвраты Цикл
		НоваяСтрока = ТаблицаДанных_Раздел1Возвраты.Добавить();
		ЗаполнитьЗначенияСвойств(НоваяСтрока,Строка,"П00001М203101,П00001М203201,КБК,ФизическоеЛицо,ДатаПолученияДохода,Регистратор");
	КонецЦикла;
КонецПроцедуры

#КонецОбласти
#КонецОбласти
//-1АБ Беляев 28.05.2021
#КонецОбласти
