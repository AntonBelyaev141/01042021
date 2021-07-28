#Область Доработка_5_Управление_Расчетом_Удержаний
&НаСервере
Процедура АБ_ПриСозданииНаСервереПосле(Отказ, СтандартнаяОбработка)
	
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
&ИзменениеИКонтроль("ЗаполнитьНастройкиМенеджераРасчета")
Процедура АБ_ЗаполнитьНастройкиМенеджераРасчета(МенеджерРасчета, ПериодРасчетаЗарплаты, СохранятьИсправления)

	МенеджерРасчета.ИсключаемыйРегистратор = Объект.Ссылка;

	ИсправлениеДокументовРасчетЗарплаты.НастроитьМенеджерРасчета(МенеджерРасчета, ЭтаФорма, ОписаниеДокумента(ЭтаФорма));

	МенеджерРасчета.НастройкиРасчета.РассчитыватьНачисления = Истина;
	МенеджерРасчета.НастройкиРасчета.РассчитыватьНДФЛ = Истина;
	МенеджерРасчета.НастройкиРасчета.РассчитыватьЗаймы = ПериодРасчетаЗарплаты <> Неопределено;
	#Удаление
	МенеджерРасчета.НастройкиРасчета.РассчитыватьУдержания = ЭтоМежрасчетнаяВыплата(Объект.ПорядокВыплаты);
	#КонецУдаления
	#Вставка
	//1АБ Беляев 12.04.2021 + Доработка "Добавить управление расчетом удержаний"
	МенеджерРасчета.НастройкиРасчета.РассчитыватьУдержания = Объект.РассчитыватьУдержания;
	//1АБ Беляев 12.04.2021 - Доработка "Добавить управление расчетом удержаний"
	#КонецВставки
	МенеджерРасчета.НастройкиРасчета.РассчитыватьКорректировкиВыплаты = Истина;
	МенеджерРасчета.НастройкиРасчета.СохранятьИсправления = СохранятьИсправления;
	МенеджерРасчета.НастройкиРасчета.РасчетЗарплаты = ПериодРасчетаЗарплаты <> Неопределено;

	МенеджерРасчета.НастройкиУдержаний.РассчитыватьТолькоПоТекущемуДокументу = Истина;

	МенеджерРасчета.НастройкиНДФЛ.Сотрудники = Объект.Сотрудник;
	МенеджерРасчета.НастройкиНДФЛ.ДатаВыплаты = Объект.ПланируемаяДатаВыплаты;
	МенеджерРасчета.НастройкиНДФЛ.ОкончательныйРасчет = Ложь;
	МенеджерРасчета.НастройкиНДФЛ.ДоходПолученНаТерриторииРФ = Объект.ДоходПолученНаТерриторииРФ;

	МенеджерРасчета.НастройкиПособий.Вставить("ЭЛНКарантинПоКоронавирусу", Объект.ЭЛНКарантинПоКоронавирусу);

	ЗасчитыватьДанныеАвансов = Объект.РассчитатьЗарплату;	
	Если ЗасчитыватьДанныеАвансов
		И ИсправлениеДокументовРасчетЗарплатыКлиентСервер.ИсправлениеВТекущемПериоде(ЭтаФорма)
		И ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Объект.ИсправленныйДокумент, "РассчитатьЗарплату") Тогда
		ЗасчитыватьДанныеАвансов = Ложь
	КонецЕсли;
	МенеджерРасчета.НастройкиНДФЛ.ЗасчитыватьДанныеАвансов = ЗасчитыватьДанныеАвансов;

	Если ПериодРасчетаЗарплаты <> Неопределено Тогда
		МенеджерРасчета.НастройкиЗаймов.Сотрудники = Объект.Сотрудник;
		МенеджерРасчета.НастройкиЗаймов.ДатаПогашения = ПериодРасчетаЗарплаты.ДатаОкончания;
	КонецЕсли;
	МенеджерРасчета.НастройкиБухучета.КоэффициентыСреднегоЗаработкаФССДокумента = КоэффициентыСреднегоЗаработка();
	МенеджерРасчета.НастройкиБухучета.КоэффициентыРаспределенияДенежногоСодержания = Объект.КоэффициентыРаспределенияДенежногоСодержания.Выгрузить();

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
	РассчитатьСПерезаполнением = Неопределено;
	РасчетЗарплатыРасширенныйКлиентСервер.УстановитьПланируемуюДатуВыплаты(ЭтотОбъект, ОписаниеДокумента(ЭтотОбъект));
	
	БылоРассчитатьЗарплату = Объект.РассчитатьЗарплату;
	
	ПорядокВыплатыПриИзмененииНаСервере();
	
	Если Объект.РассчитатьЗарплату И БылоРассчитатьЗарплату <> Объект.РассчитатьЗарплату Тогда
		НачатьПерезаполнениеИРасчетНачисленийНаКлиенте();
	Иначе
		ВыполнитьРасчетНачислений();
	КонецЕсли;


	
КонецПроцедуры

&НаКлиенте
&Перед("Подключаемый_ПорядокВыплатыПриИзменении")
Процедура АБ_Подключаемый_ПорядокВыплатыПриИзменении(Элемент)
	УстановитьСвойствоРассчитыватьУдержания(ЭтотОбъект);
	УстановитьДоступностьПоляРассчитыватьУдержания(ЭтотОбъект);
	УстановитьВидимостьУдержаний();
КонецПроцедуры

//1АБ Беляев 12.04.2021 - Доработка 5 "Добавить управление расчетом удержаний"
#КонецОбласти


