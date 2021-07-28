
&НаКлиенте
Процедура ПутьКФайлуНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	РежимКаталог=РежимДиалогаВыбораФайла.ВыборКаталога;
	Диалог2=Новый ДиалогВыбораФайла(РежимКаталог);
	Если Диалог2.Выбрать() Тогда
		Объект.ПутьКФайлу=Диалог2.Каталог;
	КонецЕсли;
КонецПроцедуры


&НаКлиенте
Процедура Команда1(Команда)
	Если Не ЗначениеЗаполнено(Объект.Организация) Или Не ЗначениеЗаполнено(Объект.ДокументПремия) Или НЕ ЗначениеЗаполнено(Объект.ПутьКФайлу) Или Не ЗначениеЗаполнено(Объект.ПоказательРасчетнаяБаза) Или НЕ ЗначениеЗаполнено(Объект.ПоказательПроцентКвартальнойПремии) Тогда
		Сообщить("Не все поля заполнены, необходимо дозаполнить");
		Возврат;
	КонецЕсли;
	
	ТабДок=Новый ТабличныйДокумент;
	ТабДок.Прочитать(Объект.ПутьКФайлу);
	МассивСоСтруктурами=Новый Массив;
	Для а=2 по ТабДок.ВысотаТаблицы Цикл
	СтруктураДляМассива=Новый Структура("Сотрудник,Сумма",ТабДок.Область(а,1).Текст,ТабДок.Область(а,5).Текст);
	МассивСоСтруктурами.Добавить(СтруктураДляМассива);
	КонецЦикла;	
	Команда1НаСервере(МассивСоСтруктурами);
	ТабДок=Неопределено;
КонецПроцедуры

&НаСервере
Процедура Команда1НаСервере(МассивСоСтруктурами)
	
	ТекущийДокумент=Объект.ДокументПремия.ПолучитьОбъект();
	Начисления=ТекущийДокумент.Начисления;
	Показатели=ТекущийДокумент.Показатели;
	РаспределениеРезультатовНачислений=ТекущийДокумент.РаспределениеРезультатовНачислений;
	
	//Начисления
	Для а=0 по МассивСоСтруктурами.ВГраница() Цикл
		ТекущаяСтруктура=МассивСоСтруктурами[а];
		НоваяСтрока=Начисления.Добавить();
		ДатаДокумента=ТекущийДокумент.Дата;
		
		Сотрудник=ПолучитьСотрудникаПоПолномуНаименованию(ТекущаяСтруктура.Сотрудник);
		Если НЕ ЗначениеЗаполнено(Сотрудник) Тогда
			Сообщить("Не найден сотрудник: " + ТекущаяСтруктура.Сотрудник);
			Возврат;
		КонецЕсли;
		НоваяСтрока.Сотрудник=Сотрудник;
		
		Сумма=ПолучитьЧисло(ТекущаяСтруктура.Сумма);
		Если Не ЗначениеЗаполнено(Сумма) Тогда
			Сообщить("Не удалось прочитать число у сотрудника: " + ТекущаяСтруктура.Сотрудник);
			Возврат;
		КонецЕсли;
		НоваяСтрока.Результат=Сумма;
		
		Подразделение=ПолучитьПодразделениеСотрудника(Сотрудник,ДатаДокумента);
		НоваяСтрока.Подразделение=Подразделение;
		НоваяСтрока.ФиксРасчет=Ложь;
		НоваяСтрока.ФиксЗаполнение=Истина;
		НоваяСтрока.ФиксСтрока=Истина;
		НоваяСтрока.ИдентификаторСтрокиВидаРасчета=а+1;
		НоваяСтрока.ПериодДействия=НачалоМесяца(ДатаДокумента);
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
		
		НоваяСтрока.ОтработаноДней=0;
		НоваяСтрока.ОтработаноЧасов=0;
		НоваяСтрока.НормаДней=0;
		НоваяСтрока.НормаЧасов=0;
		НоваяСтрока.ОплаченоДней=0;
		НоваяСтрока.ОплаченоЧасов=0;
		
		НоваяСтрока.ПериодРегистрацииНормыВремени=НачалоМесяца(ДатаДокумента);
		НоваяСтрока.РассчитыватьПоРазовымНачислениямДокумента=Ложь;
		НоваяСтрока.РанееНачислено=0;
		НоваяСтрока.КорректировкаРанееВыполненногоНачисления=Ложь;	
	

	КонецЦикла;
	
	//Показатели
	Для а=0 по МассивСоСтруктурами.ВГраница() Цикл
		
		ТекущаяСтруктура=МассивСоСтруктурами[а];
		
		НоваяСтрока=Показатели.Добавить();
		НоваяСтрока.ИдентификаторСтрокиВидаРасчета=а+1;
		НоваяСтрока.Показатель=Объект.ПоказательРасчетнаяБаза;
		
		Сумма=ПолучитьЧисло(ТекущаяСтруктура.Сумма);
		Если Не ЗначениеЗаполнено(Сумма) Тогда
			Сообщить("Не удалось прочитать число у сотрудника: " + ТекущаяСтруктура.Сотрудник);
			Возврат;
		КонецЕсли;
		НоваяСтрока.Значение=Сумма;
		
		
		
		НоваяСтрока=Показатели.Добавить();
		НоваяСтрока.ИдентификаторСтрокиВидаРасчета=а+1;
		НоваяСтрока.Показатель=Объект.ПоказательПроцентКвартальнойПремии;
		НоваяСтрока.Значение=100;
		
	КонецЦикла;
	
	
	//РаспределениеРезультатовНачислений
	Для а=0 по МассивСоСтруктурами.ВГраница() Цикл
		ТекущаяСтруктура=МассивСоСтруктурами[а];
		
		НоваяСтрока=РаспределениеРезультатовНачислений.Добавить();
		НоваяСтрока.ИдентификаторСтроки=а+1;
		НоваяСтрока.СтатьяФинансирования=ПолучитьСтатьюФинансированияПоУмолчанию();
		НоваяСтрока.СтатьяРасходов=ПолучитьСтатьюРасходовПоУмолчанию();
		НоваяСтрока.СпособОтраженияЗарплатыВБухучете=ПолучитьСпособОтраженияПоУмолчанию();
		
		Сотрудник=ПолучитьСотрудникаПоПолномуНаименованию(ТекущаяСтруктура.Сотрудник);
		Если НЕ ЗначениеЗаполнено(Сотрудник) Тогда
			Сообщить("Не найден сотрудник: " + ТекущаяСтруктура.Сотрудник);
			Возврат;
		КонецЕсли;

		Сумма=ПолучитьЧисло(ТекущаяСтруктура.Сумма);
		Если Не ЗначениеЗаполнено(Сумма) Тогда
			Сообщить("Не удалось прочитать число у сотрудника: " + ТекущаяСтруктура.Сотрудник);
			Возврат;
		КонецЕсли;
		НоваяСтрока.Результат=Сумма;

		НоваяСтрока.ПодразделениеУчетаЗатрат=ПолучитьПодразделениеСотрудника(Сотрудник,КонецМесяца(ТекущийДокумент.ПериодРегистрации));
		
		
	КонецЦикла;
	
	Попытка
	ТекущийДокумент.Записать(РежимЗаписиДокумента.Запись);
	Исключение
	Сообщить("Не удалось записать документ: " + ТекущийДокумент);
	КонецПопытки;
	

КонецПроцедуры


&НаСервере
Функция ПолучитьСотрудникаПоПолномуНаименованию(Наименование)
	Запрос=Новый Запрос;
	Запрос.Текст="ВЫБРАТЬ
	             |	Сотрудники.Ссылка КАК Ссылка
	             |ИЗ
	             |	Справочник.Сотрудники КАК Сотрудники
	             |ГДЕ
	             |	Сотрудники.Наименование = &Наименование";
	Запрос.УстановитьПараметр("Наименование",СокрЛП(Наименование));
	Результат=Запрос.Выполнить();
	Выборка=Результат.Выбрать();
	Cотрудник=Неопределено;
	Пока Выборка.Следующий() Цикл
		Сотрудник=Выборка.Ссылка;
	КонецЦикла;
	Возврат Сотрудник;
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
Функция ПолучитьСтатьюРасходовПоУмолчанию()
	лТекст = "
		|ВЫБРАТЬ
		|	Сотрудники.Ссылка КАК Ссылка
		|ИЗ
		|	Справочник.СтатьиРасходовЗарплата КАК Сотрудники
		|ГДЕ Сотрудники.Код=&Код
		|";

	лЗапрос = Новый Запрос(лТекст);

	лЗапрос.УстановитьПараметр("Код", "211");


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



