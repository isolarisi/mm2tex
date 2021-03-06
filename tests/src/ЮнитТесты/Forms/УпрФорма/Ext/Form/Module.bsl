﻿&НаКлиенте
Перем КонтекстЯдра;
&НаКлиенте
Перем Ожидаем;
&НаКлиенте
Перем Утверждения;
&НаКлиенте
Перем СтроковыеУтилиты;

#Область ИнтерфейсТестирования

&НаКлиенте
Процедура Инициализация(КонтекстЯдраПараметр) Экспорт
	КонтекстЯдра = КонтекстЯдраПараметр;
	Утверждения = КонтекстЯдра.Плагин("БазовыеУтверждения");
	Ожидаем = КонтекстЯдра.Плагин("УтвержденияBDD");
	СтроковыеУтилиты = КонтекстЯдра.Плагин("СтроковыеУтилиты");
КонецПроцедуры

&НаКлиенте
Процедура ЗаполнитьНаборТестов(НаборТестов) Экспорт
	НаборТестов.Добавить("ТестДолжен_ПроверитьНаличиеРеквизита_ИмяФайла", , "Проверка наличия реквизита ""ИмяФайла""");
	НаборТестов.Добавить("ТестДолжен_ПроверитьТипРеквизита_ИмяФайла_Строка500", , "Проверка типа реквизита ""ИмяФайла"" = Строка(500)");
	НаборТестов.Добавить("ТестДолжен_ПроверитьРезультатЧтенияФайла", , "Проверка результата чтения файла");
	НаборТестов.Добавить("ТестДолжен_ПроверитьПравильностьФормированияТитульногоЛиста", , "Проверка Формирования титульного листа");
	НаборТестов.Добавить("ТестДолжен_ПроверитьКорректностьФормированияТекстаКомментария", , "Проверка формирования комментария");
	НаборТестов.Добавить("ТестДолжен_СформироватьФайлСоСтруткуройРазделов", , "Проверка формирования структуры разделов секции");
	НаборТестов.Добавить("ТестДолжен_СформироватьФайлСоСтруткуройРазделовИТекстомРазделов", , "Проверка формирования структуры разделов секции с тектом заметок");
	НаборТестов.Добавить("ТестДолжен_ПроверитьНаличиеРеквизита_КаталогВыгрузки", , "Проверка наличия реквизита ""КаталогВыгрузки""");
	НаборТестов.Добавить("ТестДолжен_ПроверитьТипРеквизита_КаталогВыгрузки_Строка500", , "Проверка типа реквизита ""КаталогВыгрузки"" = Строка(500)");
	НаборТестов.Добавить("ТестДолжен_ПроверитьПравильностьВыгрузкиТестовогоФайлаВДокументы", , "Проверка правильности выгрузки тестового файла в результирующие файлы");
	НаборТестов.Добавить("ТестДолжен_ПроверитьПравильностьПреобразованияИсходногоТектаДоКонвертации", , "Проверка правильности преобразования текста файла до преобразований");
КонецПроцедуры 

#КонецОбласти

#Область СамиТесты

&НаКлиенте
Процедура ТестДолжен_ПроверитьНаличиеРеквизита_ИмяФайла() Экспорт

	Ожидаем.Что(ПроверитьНаличиеРеквизита("ИмяФайла"), "У обработки нет реквизита ""Имя файла""").ЭтоИстина();
	
КонецПроцедуры

&НаКлиенте
Процедура ТестДолжен_ПроверитьТипРеквизита_ИмяФайла_Строка500() Экспорт

	Ожидаем.Что(ПроверитьТипРеквизита("ИмяФайла"), "У реквизита обработки ""Имя файла"" тип не Строка(500)").ЭтоИстина();
	
КонецПроцедуры

&НаКлиенте
Процедура ТестДолжен_ПроверитьРезультатЧтенияФайла() Экспорт
	ФормаОбработки = ПолучитьФормуОбработки();
	ФормаОбработки.Объект.ИмяФайла = "D:\mm2tex\tests\data\Тест.mm";
	РезультатЧтенияФайла = ФормаОбработки.РазобратьXML();
	Ожидаем.Что(ТипЗнч(РезультатЧтенияФайла), "Результат чтения файла должна быть Структура").Равно(Тип("Структура"));
	Ожидаем.Что(РезультатЧтенияФайла.node.TEXT).Равно("Титульный лист");
	Ожидаем.Что(РезультатЧтенияФайла.node.node[0].TEXT).Равно("Раздел 1");
	Ожидаем.Что(РезультатЧтенияФайла.node.node[0].node[1].TEXT).Равно("Подраздел 2");
	Ожидаем.Что(РезультатЧтенияФайла.node.node[0].node[1].node.TEXT).Равно("ПодПодРаздел3");
	Ожидаем.Что(РезультатЧтенияФайла.node.node[0].node[0].node[0].TEXT).Равно("ПодПодРаздел1");
КонецПроцедуры

&НаКлиенте
Процедура ТестДолжен_ПроверитьПравильностьФормированияТитульногоЛиста() Экспорт
	ФормаОбработки = ПолучитьФормуОбработки();
	РезультатЧтенияФайла = Новый Структура("node",Новый Структура("TEXT", "Титульный лист"));
	ТитульныйЛист = ФормаОбработки.СформироватьТитульныйЛист(РезультатЧтенияФайла);
	ТекстТитульногоЛиста = ТитульныйЛист.ПолучитьТекст();
	ЭталонныйТекстТитульногоЛиста = ПолучитьТекстМакета("ТестТитульногоЛиста");
	Ожидаем.Что(ТипЗнч(ТитульныйЛист)).Равно(Тип("ТекстовыйДокумент"));
	Ожидаем.Что(ТекстТитульногоЛиста).Равно(ЭталонныйТекстТитульногоЛиста);
КонецПроцедуры

&НаКлиенте
Процедура ТестДолжен_ПроверитьКорректностьФормированияТекстаКомментария() Экспорт
	ФормаОбработки = ПолучитьФормуОбработки();
	МассивУзлов = Новый Массив;                       
	МассивУзлов.Добавить(Новый Структура("richcontent", "
|      Текст раздела. Текст раздела. Текст раздела. Текст раздела. Текст раздела. Текст раздела. Текст раздела. Текст раздела. Текст раздела. Текст раздела. Текст раздела. Текст раздела. Текст раздела. Текст раздела. Текст раздела. Текст раздела. Текст раздела. Текст раздела. Текст раздела. Текст раздела. Текст раздела. Текст раздела. Текст раздела. Текст раздела. Текст раздела. Текст раздела. Текст раздела. Текст раздела.
|    "));
	РезультатЧтенияФайла = Новый Структура("node",Новый Структура("node", МассивУзлов));
	
	ТекстПараграфа = ФормаОбработки.ПолучитьТекстПараграфа(РезультатЧтенияФайла.node.node[0].richcontent);
	ЭталонныйТекстПараграфа = ПолучитьТекстМакета("ТестЗаметкиВОдинПараграф");
	Ожидаем.Что(ТекстПараграфа).Равно(ЭталонныйТекстПараграфа);
КонецПроцедуры

&НаКлиенте
Процедура ТестДолжен_СформироватьФайлСоСтруткуройРазделов() Экспорт
	ФормаОбработки = ПолучитьФормуОбработки();
	//РезультатЧтения.node.node[0]
	МассивРазделовЧетвертогоИНижеУровней = Новый Массив;
	МассивРазделовЧетвертогоИНижеУровней.Добавить(Новый Структура("TEXT","Раздел четвертого и более уровня"));
	МассивПодПодразделов = Новый Массив;
	МассивПодПодразделов.Добавить(Новый Структура("TEXT, node","ПодПодРаздел1", МассивРазделовЧетвертогоИНижеУровней));
	МассивПодПодразделов.Добавить(Новый Структура("TEXT","ПодПодРаздел2"));
	МассивПодразделов = Новый Массив;
	МассивПодразделов.Добавить(Новый Структура("TEXT, node","ПодРаздел1",МассивПодПодразделов));
	МассивПодразделов.Добавить(Новый Структура("TEXT, node","ПодРаздел2"));
	СтруктураРаздела = Новый Структура("TEXT, node", "Раздел1", МассивПодразделов);
	
	ТекстФайлаРаздела = ФормаОбработки.СформироватьТекстФайлаРаздела(СтруктураРаздела);
	ЭталонныйТекстРаздела = ПолучитьТекстМакета("ТестТекстаРаздела");
	Ожидаем.Что(ТекстФайлаРаздела).Равно(ЭталонныйТекстРаздела);
КонецПроцедуры

&НаКлиенте
Процедура ТестДолжен_СформироватьФайлСоСтруткуройРазделовИТекстомРазделов() Экспорт
	ФормаОбработки = ПолучитьФормуОбработки();
	//РезультатЧтения.node.node[0]
    ТекстРаздела = "
|      Текст раздела. Текст раздела. Текст раздела. Текст раздела. Текст раздела. Текст раздела. Текст раздела. Текст раздела. Текст раздела. Текст раздела. Текст раздела. Текст раздела. Текст раздела. Текст раздела. Текст раздела. Текст раздела. Текст раздела. Текст раздела. Текст раздела. Текст раздела. Текст раздела. Текст раздела. Текст раздела. Текст раздела. Текст раздела. Текст раздела. Текст раздела. Текст раздела.
|    
|      Текст второго параграфа.
|      ";
	
	МассивРазделовЧетвертогоИНижеУровней = Новый Массив;
	МассивРазделовЧетвертогоИНижеУровней.Добавить(Новый Структура("TEXT, richcontent","Раздел четвертого и более уровня", ТекстРаздела));
	МассивПодПодразделов = Новый Массив;
	МассивПодПодразделов.Добавить(Новый Структура("TEXT, node, richcontent","ПодПодРаздел1", МассивРазделовЧетвертогоИНижеУровней, ТекстРаздела));
	МассивПодПодразделов.Добавить(Новый Структура("TEXT, richcontent","ПодПодРаздел2", ТекстРаздела));
	МассивПодразделов = Новый Массив;
	МассивПодразделов.Добавить(Новый Структура("TEXT, node, richcontent","ПодРаздел1",МассивПодПодразделов, ТекстРаздела));
	МассивПодразделов.Добавить(Новый Структура("TEXT, node, richcontent","ПодРаздел2",, ТекстРаздела));
	
	СтруктураРаздела = Новый Структура("TEXT, node, richcontent", "Раздел1", МассивПодразделов, ТекстРаздела);
	
	ТекстФайлаРаздела = ФормаОбработки.СформироватьТекстФайлаРаздела(СтруктураРаздела);
	ЭталонныйТекстРаздела = ПолучитьТекстМакета("ТестТекстаРазделаСТекстом");
	Ожидаем.Что(ТекстФайлаРаздела).Равно(ЭталонныйТекстРаздела);
КонецПроцедуры

&НаКлиенте
Процедура ТестДолжен_ПроверитьНаличиеРеквизита_КаталогВыгрузки() Экспорт

	Ожидаем.Что(ПроверитьНаличиеРеквизита("КаталогВыгрузки"), "У обработки нет реквизита ""КаталогВыгрузки""").ЭтоИстина();
	
КонецПроцедуры

&НаКлиенте
Процедура ТестДолжен_ПроверитьТипРеквизита_КаталогВыгрузки_Строка500() Экспорт

	Ожидаем.Что(ПроверитьТипРеквизита("КаталогВыгрузки"), "У реквизита обработки ""КаталогВыгрузки"" тип не Строка(500)").ЭтоИстина();
	
КонецПроцедуры

&НаКлиенте
Процедура ТестДолжен_ПроверитьПравильностьВыгрузкиТестовогоФайлаВДокументы() Экспорт
	ФормаОбработки = ПолучитьФормуОбработки();
	ФормаОбработки.Объект.ИмяФайла = "D:\mm2tex\tests\data\Тест.mm";
	ФормаОбработки.Объект.КаталогВыгрузки = "D:\mm2tex\tests\data\РезультатПреобразования";
	ФормаОбработки.ВыполнитьПреобразованиеНаКлиенте(); 
	МассивСгенерированныхФайлов = НайтиФайлы("D:\mm2tex\tests\data\РезультатПреобразования\","*");
	Ожидаем.Что(МассивСгенерированныхФайлов.Количество(), "По тестовому файлу должно быть создано 3 файла").Равно(3);
	Для каждого Файл из МассивСгенерированныхФайлов Цикл
		ЭталонныйТекстФайла = ПолучитьТекстМакета(Файл.ИмяБезРасширения);
		НовыйДокумент = Новый ТекстовыйДокумент;
		НовыйДокумент.Прочитать(Файл.ПолноеИмя);
		РезультатВыгрузки = НовыйДокумент.ПолучитьТекст();
		Ожидаем.Что(РезультатВыгрузки).Равно(ЭталонныйТекстФайла);
	КонецЦикла;
	
КонецПроцедуры

&НаКлиенте
Процедура ТестДолжен_ПроверитьПравильностьПреобразованияИсходногоТектаДоКонвертации() Экспорт
	ФормаОбработки = ПолучитьФормуОбработки();
	ТекстФайлаДоПреобразования = ПолучитьТекстМакета("ТекстФайлаДоПреобразованияHTML");
	ТекстФайлаПослеПреобразованияЭталон = ПолучитьТекстМакета("ТекстФайлаПослеПреобразованияHTML");
	ТекстФайлаПослеПреобразования = ФормаОбработки.ВыполнитьПредварительноеПреобразование(ТекстФайлаДоПреобразования);
	
	Ожидаем.Что(ТекстФайлаПослеПреобразования).Равно(ТекстФайлаПослеПреобразованияЭталон);
КонецПроцедуры

#КонецОбласти

#Область ВспомогательныеВызовы
&НаСервере
Функция ПолучитьТекстМакета(ИмяМакета)
	ОбработкаОбъект = РеквизитФормыВЗначение("Объект");
	Макет = ОбработкаОбъект.ПолучитьМакет(ИмяМакета);
	Если ТипЗнч(Макет) = Тип("ТекстовыйДокумент") Тогда
		Возврат Макет.ПолучитьТекст();
	Иначе
		НовыйДокумент = Новый ТекстовыйДокумент;
		ИмяВременногоФайла = ПолучитьИмяВременногоФайла();
		Макет.Записать(ИмяВременногоФайла);
		НовыйДокумент.Прочитать(ИмяВременногоФайла);
		Возврат НовыйДокумент.ПолучитьТекст();
	КонецЕсли;
КонецФункции

&НаСервере
Функция ПроверитьНаличиеРеквизита(ИмяРеквизита)                                                           
	ВнешняяОбработка = ВнешниеОбработки.Создать("D:\mm2tex\build\mm2tex.epf");
	Возврат ОбщегоНазначения.ЕстьРеквизитОбъекта(ИмяРеквизита,  ВнешняяОбработка.Метаданные());
КонецФункции

&НаСервере
Функция ПроверитьТипРеквизита(ИмяРеквизита)                                                           
	ВнешняяОбработка = ВнешниеОбработки.Создать("D:\mm2tex\build\mm2tex.epf");
	ТипЗначения = ОбщегоНазначения.ОписаниеТипаСтрока(500);  
	Возврат ВнешняяОбработка.Метаданные().Реквизиты[ИмяРеквизита].Тип = ТипЗначения;
КонецФункции

&НаКлиенте
Функция ПолучитьФормуОбработки()

    //Помещаем обработку во временном хранилище
    АдресХранилища = "";
    Результат = ПоместитьФайл(АдресХранилища, "D:\mm2tex\build\mm2tex.epf", , Ложь);           
    ИмяОбработки = ПодключитьВнешнююОбработку(АдресХранилища);
    
    // Откроем форму подключенной внешней обработки
    Возврат ПолучитьФорму("ВнешняяОбработка."+ ИмяОбработки +".Форма");

КонецФункции

&НаСервере
Функция ПодключитьВнешнююОбработку(АдресХранилища)

    Возврат ВнешниеОбработки.Подключить(АдресХранилища,,Ложь);

КонецФункции       

#КонецОбласти

&НаКлиенте
Процедура Команда1(Команда)
	ТестДолжен_ПроверитьПравильностьВыгрузкиТестовогоФайлаВДокументы();
КонецПроцедуры

