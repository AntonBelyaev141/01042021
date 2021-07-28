#Область Доработка4_НеПредоставлятьВычеты
&НаСервере
Процедура АБ_ПриСозданииНаСервереПосле(Отказ, СтандартнаяОбработка)
	ПроверочныйТип=Элементы.Найти("АБ_НепредоставлятьВычеты");
	Если НЕ ТипЗнч(ПроверочныйТип) = Тип("Неопределено") Тогда
	Иначе
		ГруппаДополнительно=Элементы.Найти("ЭлементыДополнительно");
		ЭлементАБ_НеПредоставлятьВычеты=Элементы.Добавить("АБ_НеПредоставлятьВычеты",Тип("ПолеФормы"),ГруппаДополнительно);
		ЭлементАБ_НеПредоставлятьВычеты.Заголовок="Не предоставлять вычеты";
		ЭлементАБ_НеПредоставлятьВычеты.Вид=ВидПоляФормы.ПолеФлажка;
		ЭлементАБ_НеПредоставлятьВычеты.ПутьКДанным="Объект.АБ_НеПредоставлятьВычеты";
		ЭлементАБ_НеПредоставлятьВычеты.УстановитьДействие("ПриИзменении","АБ_РассчитатьСотрудниковНаКлиенте");
	КонецЕсли;
	
	Если Параметры.Ключ.Пустая() Тогда
	Объект.АБ_НеПредоставлятьВычеты = Истина;
	КонецЕсли;

КонецПроцедуры


&НаСервере
&ИзменениеИКонтроль("ЗаполнитьНастройкиМенеджераРасчета")
Процедура АБ_ЗаполнитьНастройкиМенеджераРасчета(ФизическиеЛица, МенеджерРасчета, СохранятьИсправления)

	МенеджерРасчета.ИсключаемыйРегистратор = Объект.Ссылка;

	ИсправлениеДокументовРасчетЗарплаты.НастроитьМенеджерРасчета(МенеджерРасчета, ЭтаФорма, ОписаниеДокумента(ЭтаФорма));

	МенеджерРасчета.НастройкиРасчета.РассчитыватьНачисления = Истина;
	МенеджерРасчета.НастройкиРасчета.РассчитыватьУдержания = Объект.РассчитыватьУдержания;
	МенеджерРасчета.НастройкиРасчета.РассчитыватьНДФЛ = УчетНДФЛРасширенный.МежрасчетныйДокументИсчисляетНДФЛ(Объект.Организация, ОтложитьРасчетНалогаДоРасчетаЗарплатыВКонцеМесяца, Объект.ПорядокВыплаты, ОбязательныйРасчетНДФЛ);
	МенеджерРасчета.НастройкиРасчета.РассчитыватьКорректировкиВыплаты = Истина;
	МенеджерРасчета.НастройкиРасчета.СохранятьИсправления = СохранятьИсправления;

	МенеджерРасчета.НастройкиУдержаний.РассчитыватьТолькоПоТекущемуДокументу = Истина;

	МенеджерРасчета.НастройкиНДФЛ.Сотрудники = ФизическиеЛица;
	МенеджерРасчета.НастройкиНДФЛ.ДатаВыплаты = Объект.ПланируемаяДатаВыплаты;
	МенеджерРасчета.НастройкиНДФЛ.ОкончательныйРасчет = ОкончательныйРасчетНДФЛ;
	#Вставка
	//1АБ Беляев 14.03.2021 +
	МенеджерРасчета.НастройкиНДФЛ.АБ_НеПредоставлятьВычеты=Объект.АБ_НеПредоставлятьВычеты;
	//1АБ Беляев 14.03.2021 - 
	#КонецВставки

	МенеджерРасчета.НастройкиБухучета.НастройкиБухучетаДокумента = Документы.Премия.ДанныеДляБухучетаЗарплатыПервичныхДокументов(Объект)["ТаблицаБухучетЗарплаты"];

КонецПроцедуры

&НаКлиенте
Процедура АБ_РассчитатьСотрудниковНаКлиенте()
	АБ_РассчитатьСотрудниковНаСервере();
КонецПроцедуры

&НаСервере
Процедура АБ_РассчитатьСотрудниковНаСервере()
	РассчитатьСотрудниковНаСервере(ОбщегоНазначения.ВыгрузитьКолонку(Объект.Начисления, "Сотрудник"), ОписаниеТаблицыНачислений(РегистрацияНачисленийДоступна), Истина);
КонецПроцедуры

#КонецОбласти