#Область АБ_Доработка1_НепосредственноеДобавлениеФункционала_ГрафическийИнтерфейс_1
&НаСервере
Процедура АБ_ПриСозданииНаСервереПосле(Отказ, СтандартнаяОбработка)
	//1АБ Беляев 08.03.2021 + 
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
	КонецЕсли;
	//1АБ Беляев 08.03.2021 -
КонецПроцедуры
#КонецОбласти

#Область АБ_Доработка1_ПромежуточныеФункции_От_ГрафическогоИнтерфейса_До_ФункцииПолученияНужногоЗначения_2
&НаСервере
&ИзменениеИКонтроль("РезультатЗаполненияВДлительнойОперации")
Функция АБ_РезультатЗаполненияВДлительнойОперации()

	СотрудникиПерерасчет = СотрудникиПериодДействияДляПерерасчета();

	РасчетЗарплатыРасширенныйКлиентСервер.ОчиститьТаблицыДокумента(ЭтаФорма, ОписаниеДокумента(ЭтотОбъект));

	СтруктураПараметров = РасчетЗарплатыРасширенныйКлиентСервер.ПараметрыПолученияДанныхЗаполненияДокумента();
	#Вставка
	//1АБ Беляев 08.03.2021 +
	СтруктураПараметров.ИспользоватьНеТиповойРасчетНочных=Объект.АБ_ИспользоватьНеТиповойРасчетНочных;
	СтруктураПараметров.ИспользоватьНеТиповойРасчетПраздничных=Объект.АБ_ИспользоватьНеТиповойРасчетПраздничных;
	//1АБ Беляев 08.03.2021 -
	#КонецВставки	
	СтруктураПараметров.ОписаниеДокумента = ОписаниеДокумента(ЭтотОбъект);
	СтруктураПараметров.Организация = Объект.Организация;
	СтруктураПараметров.ДокументСсылка = Объект.Ссылка;
	СтруктураПараметров.Подразделение = Объект.Подразделение;
	СтруктураПараметров.МесяцНачисления = Объект.МесяцНачисления;
	СтруктураПараметров.ОкончаниеПериода = КонецМесяца(Объект.МесяцНачисления);
	СтруктураПараметров.РежимНачисления = Перечисления.РежимНачисленияЗарплаты.ОкончательныйРасчет;
	СтруктураПараметров.СотрудникиПериодДействияПерерасчет = СотрудникиПерерасчет;
	СтруктураПараметров.ИспользоватьВоеннуюСлужбу = ИспользоватьВоеннуюСлужбу;
	СтруктураПараметров.НачислениеЗарплатыВоеннослужащим = Объект.НачислениеЗарплатыВоеннослужащим;
	СтруктураПараметров.ОкончательныйРасчетНДФЛ = ОкончательныйРасчетНДФЛ;
	СтруктураПараметров.ПроверятьРегистрациюПроцентаЕНВД = Истина;
	СтруктураПараметров.ДатаВыплаты = РасчетЗарплатыРасширенныйКлиентСервер.ПланируемаяДатаВыплатыЗарплаты(Объект.Организация, Объект.МесяцНачисления);

	НаименованиеЗадания = НСтр("ru = 'Заполнение документа «Начисление зарплаты»'");

	Результат = ДлительныеОперации.ЗапуститьВыполнениеВФоне(
	УникальныйИдентификатор,
	"Документы.НачислениеЗарплаты.ПодготовитьДанныеДляЗаполнения",
	СтруктураПараметров,
	НаименованиеЗадания);

	АдресХранилища = Результат.АдресХранилища;

	Если Результат.ЗаданиеВыполнено Тогда
		ЗаполнениеПослеВыполненияДлительнойОперации();
	КонецЕсли;

	Возврат Результат;

КонецФункции

&НаКлиенте
&ИзменениеИКонтроль("ПересчитатьСотрудника")
Процедура АБ_ПересчитатьСотрудника(ИмяТаблицы, ВыбранныеСтроки, ВедущееПоле, ТипВедущегоПоля, СохранятьИсправления)

	ОчиститьСообщения();

	Если Не РасчетЗарплатыРасширенныйКлиентСервер.ФормаДокументаГотоваДляРасчетаЗарплаты(ЭтаФорма, ОписаниеДокумента(ЭтотОбъект)) Тогда
		Возврат;
	КонецЕсли;		

	ТабличнаяЧасть = ОбщегоНазначенияКлиентСервер.ПолучитьРеквизитФормыПоПути(ЭтотОбъект, "Объект." + ИмяТаблицы);

	ФизическиеЛицаСотрудников = Новый Массив;
	Для Каждого ИдентификаторСтроки Из ВыбранныеСтроки Цикл

		ПерерассчитываемаяСтрока = ТабличнаяЧасть.НайтиПоИдентификатору(ИдентификаторСтроки);
		Сотрудник = ПерерассчитываемаяСтрока[ВедущееПоле];
		Если ТипЗнч(Сотрудник) = Тип("СправочникСсылка.Сотрудники") Тогда
			ФизическиеЛицаСотрудников.Добавить(СотрудникиКлиентСерверПовтИсп.ФизическиеЛицаСотрудников(Сотрудник)[0]);
		Иначе
			ФизическиеЛицаСотрудников.Добавить(Сотрудник);
		КонецЕсли;
	КонецЦикла;

	ФизическиеЛицаСотрудников = ОбщегоНазначенияКлиентСервер.СвернутьМассив(ФизическиеЛицаСотрудников);
	Сотрудники = Новый Массив;
	ОписаниеДокумента = ОписаниеДокумента(ЭтаФорма);

	СодержимоеДокумента = СодержимоеСотрудниковДокумента(ФизическиеЛицаСотрудников, Сотрудники, ТипВедущегоПоля);

	СтруктураПараметров = РасчетЗарплатыРасширенныйКлиентСервер.ПараметрыПолученияДанныхЗаполненияДокумента();
	СтруктураПараметров.Организация = Объект.Организация;
	СтруктураПараметров.ДокументСсылка = Объект.Ссылка;
	СтруктураПараметров.Подразделение = Объект.Подразделение;
	СтруктураПараметров.МесяцНачисления = Объект.МесяцНачисления;
	СтруктураПараметров.ДатаВыплаты = РасчетЗарплатыРасширенныйКлиентСервер.ПланируемаяДатаВыплатыЗарплаты(Объект.Организация, Объект.МесяцНачисления);
	СтруктураПараметров.Сотрудники = Сотрудники;
	СтруктураПараметров.ФизическиеЛица = ФизическиеЛицаСотрудников;
	СтруктураПараметров.ОкончаниеПериода = КонецМесяца(Объект.МесяцНачисления);
	СтруктураПараметров.РежимНачисления = ПредопределенноеЗначение("Перечисление.РежимНачисленияЗарплаты.ОкончательныйРасчет");
	СтруктураПараметров.ОписаниеДокумента = ОписаниеДокумента;
	СтруктураПараметров.СохранятьИсправления = СохранятьИсправления;
	СтруктураПараметров.СодержимоеДокумента = СодержимоеДокумента;
	СтруктураПараметров.РежимПересчетаНДФЛ = РежимПересчетаНДФЛ;
	СтруктураПараметров.РежимПересчетаВзносов = РежимПересчетаВзносов;
	СтруктураПараметров.ОкончательныйРасчетНДФЛ = ОкончательныйРасчетНДФЛ;
	СтруктураПараметров.ПозицииВставки = Неопределено;
	СтруктураПараметров.НачислениеЗарплатыВоеннослужащим = Объект.НачислениеЗарплатыВоеннослужащим;
	#Вставка
	//1АБ Беляев 08.03.2021 +
	СтруктураПараметров.ИспользоватьНеТиповойРасчетНочных=Объект.АБ_ИспользоватьНеТиповойРасчетНочных;
	СтруктураПараметров.ИспользоватьНеТиповойРасчетПраздничных=Объект.АБ_ИспользоватьНеТиповойРасчетПраздничных;
	//1АБ Беляев 08.03.2021 -
	#КонецВставки

	АдресаРаспределения = Новый Структура;
	АдресРаспределенияПоТерриториямУсловиямТруда = Неопределено;

	Если ОписаниеДокумента.ОписанияТаблицДляРаспределенияРезультата <> Неопределено Тогда 
		Для Каждого КлючИЗначение Из ОписаниеДокумента.ОписанияТаблицДляРаспределенияРезультата Цикл
			ПутьКДанным = КлючИЗначение.Значение.ПутьКДаннымАдресРаспределенияРезультатовВХранилище;
			Если ЗначениеЗаполнено(ПутьКДанным) И ЗначениеЗаполнено(ЭтаФорма[ПутьКДанным]) И Не АдресаРаспределения.Свойство(ПутьКДанным) Тогда
				АдресаРаспределения.Вставить(ПутьКДанным, ЭтаФорма[ПутьКДанным]);
			КонецЕсли;
			ПутьКДанным = КлючИЗначение.Значение.ПутьКДаннымАдресРаспределенияПоТерриториямУсловиямТруда;
			Если ЗначениеЗаполнено(ПутьКДанным) И ЗначениеЗаполнено(ЭтаФорма[ПутьКДанным]) И АдресРаспределенияПоТерриториямУсловиямТруда = Неопределено Тогда
				АдресРаспределенияПоТерриториямУсловиямТруда = ЭтаФорма[ПутьКДанным];
			КонецЕсли;
		КонецЦикла;
	КонецЕсли;

	Результат = ПересчитатьСотрудникаНаСервере(СтруктураПараметров, УникальныйИдентификатор, СохранятьИсправления, АдресаРаспределения, АдресРаспределенияПоТерриториямУсловиямТруда);

	Если Результат = Неопределено Тогда
		Возврат;
	КонецЕсли;

	Если Результат <> Неопределено Тогда
		АдресХранилища = Результат.АдресХранилища;
	КонецЕсли;

	Если Результат <> Неопределено И Результат.ЗаданиеВыполнено Тогда
		ЗаполнениеПослеВыполненияДлительнойОперацииНаКлиенте();	
	КонецЕсли;

	Если Результат.ЗаданиеВыполнено Тогда
		РасчетЗарплатыРасширенныйКлиент.ОчиститьСписокСотрудниковКРасчету(ЭтаФорма);
		УстановитьЗначенияКонтролируемыхПолей();
	Иначе
		ИдентификаторЗадания = Результат.ИдентификаторЗадания;
		АдресХранилища		 = Результат.АдресХранилища;
		ПересчетСотрудникаВДлительнойОперации = Истина;

		ДлительныеОперацииКлиент.ИнициализироватьПараметрыОбработчикаОжидания(ПараметрыОбработчикаОжидания);
		ПодключитьОбработчикОжидания("Подключаемый_ПроверитьВыполнениеЗадания", 1, Истина);
		ФормаДлительнойОперации = ДлительныеОперацииКлиент.ОткрытьФормуДлительнойОперации(ЭтаФорма, ИдентификаторЗадания);
	КонецЕсли;

КонецПроцедуры
#КонецОбласти


