﻿
&НаСервере
Функция ВыполнитьПреобразованиеНаСервере()
	РезультатЧтения = РазобратьXML();
	ТитульныйЛист = СформироватьТитульныйЛист(РезультатЧтения);
	ДокументыРазделов = ПолучитьДокументыРазделов(РезультатЧтения);
	Возврат Новый Структура("ТитульныйЛист, ДокументыРазделов", ТитульныйЛист, ДокументыРазделов);
КонецФункции

&НаСервере
Функция ПолучитьДокументыРазделов(РезультатЧтения)
	Результат = Новый Массив;
	Если Не РезультатЧтения.node.Свойство("node") Тогда
		Возврат Результат;
	КонецЕсли;
	Если ТипЗнч(РезультатЧтения.node.node) = Тип("Массив") Тогда
		Для каждого Раздел из РезультатЧтения.node.node Цикл
			ДокументРаздела = Новый ТекстовыйДокумент;
			ДокументРаздела.ДобавитьСтроку(СформироватьТекстФайлаРаздела(Раздел));
			Результат.Добавить(ДокументРаздела);
		КонецЦикла;
	Иначе
		ДокументРаздела = Новый ТекстовыйДокумент;
		ДокументРаздела.ДобавитьСтроку(СформироватьТекстФайлаРаздела(РезультатЧтения.node.node));
		Результат.Добавить(ДокументРаздела);
	КонецЕсли;
	Возврат Результат;
КонецФункции

&НаСервере
Функция СформироватьТитульныйЛист(РезультатЧтения)
	//ВызватьИсключение "Не реализовано";
	ТитульныйЛист = Новый ТекстовыйДокумент;  
	ТитульныйЛист.ДобавитьСтроку("\thispagestyle{titlepage}");
	ТитульныйЛист.ДобавитьСтроку("");
	ТитульныйЛист.ДобавитьСтроку("\vspace*{8cm}");
	ТитульныйЛист.ДобавитьСтроку("");
	ТитульныйЛист.ДобавитьСтроку("\begin{center}");
	ТитульныйЛист.ДобавитьСтроку("    {\LARGE "+РезультатЧтения.node.TEXT+"\\ [1cm] }");
	ТитульныйЛист.ДобавитьСтроку("\end{center}");

	Возврат ТитульныйЛист;
КонецФункции

&НаСервере
Функция СформироватьТекстФайлаРаздела(СтруктураРаздела)
	ТекстРаздела = "";
	Если СтруктураРаздела = Неопределено Тогда
		Возврат ТекстРаздела;
	КонецЕсли;
	ТекстРаздела = "\section{"+СтруктураРаздела.TEXT+"}"+Символы.ПС+Символы.ПС;
	Если СтруктураРаздела.Свойство("richcontent") Тогда
		ТекстРаздела = ТекстРаздела + ПолучитьТекстПараграфа(СтруктураРаздела.richcontent);
	КонецЕсли;
	Если СтруктураРаздела.Свойство("node") Тогда
		Если ТипЗнч(СтруктураРаздела.node) = Тип("Массив") Тогда
			Для каждого Узел из СтруктураРаздела.node Цикл
				Если Узел <> Неопределено И Узел.Свойство("TEXT") Тогда
					ТекстРаздела = ТекстРаздела + "\subsection{"+Узел.TEXT+"}"+Символы.ПС+Символы.ПС;  
				КонецЕсли;
				Если Узел.Свойство("richcontent") Тогда
					ТекстРаздела = ТекстРаздела + ПолучитьТекстПараграфа(Узел.richcontent);
				КонецЕсли;
				Если Узел.Свойство("node") Тогда
					Если ТипЗнч(Узел.node) = Тип("Массив") Тогда
						Для каждого УзелПодраздела из Узел.node Цикл
							Если УзелПодраздела <> Неопределено И УзелПодраздела.Свойство("TEXT") Тогда
								ТекстРаздела = ТекстРаздела + "\subsubsection{"+УзелПодраздела.TEXT+"}"+Символы.ПС+Символы.ПС;
							КонецЕсли;
							Если УзелПодраздела.Свойство("richcontent") Тогда
								ТекстРаздела = ТекстРаздела + ПолучитьТекстПараграфа(УзелПодраздела.richcontent);
							КонецЕсли;
							Если УзелПодраздела.Свойство("node") Тогда
								ТекстРаздела = ТекстРаздела + СобратьТекстПодчиненныхУзлов(УзелПодраздела.node);
							КонецЕсли;
						КонецЦикла;
					Иначе
						Если Узел.node <> Неопределено Тогда
							Если Узел.node.Свойство("TEXT") Тогда
								ТекстРаздела = ТекстРаздела + "\subsubsection{"+Узел.node.TEXT+"}"+Символы.ПС+Символы.ПС;
							КонецЕсли;
							Если Узел.node.Свойство("richcontent") Тогда
								ТекстРаздела = ТекстРаздела + ПолучитьТекстПараграфа(Узел.node.richcontent);
							КонецЕсли;
							Если Узел.node.Свойство("node") Тогда
								ТекстРаздела = ТекстРаздела + СобратьТекстПодчиненныхУзлов(Узел.node.node);
							КонецЕсли;
						КонецЕсли;
					КонецЕсли;
				КонецЕсли;
			КонецЦикла;
		Иначе
			Если СтруктураРаздела.node.Свойство("TEXT") Тогда
				ТекстРаздела = ТекстРаздела + "\subsection{"+СтруктураРаздела.node.TEXT+"}"+Символы.ПС+Символы.ПС;
			КонецЕсли;
			Если СтруктураРаздела.node.Свойство("node") Тогда 
				Если ТипЗнч(СтруктураРаздела.node.node) = Тип("Массив") Тогда
					Для каждого УзелПодраздела из СтруктураРаздела.node.node Цикл
						Если УзелПодраздела.Свойство("TEXT") Тогда
							ТекстРаздела = ТекстРаздела + "\subsubsection{"+УзелПодраздела.TEXT+"}"+Символы.ПС+Символы.ПС;
						КонецЕсли;
						Если УзелПодраздела.Свойство("richcontent") Тогда
							ТекстРаздела = ТекстРаздела + ПолучитьТекстПараграфа(УзелПодраздела.richcontent);
						КонецЕсли;
						Если УзелПодраздела.Свойство("node") Тогда
							ТекстРаздела = ТекстРаздела + СобратьТекстПодчиненныхУзлов(УзелПодраздела.node);
						КонецЕсли;
					КонецЦикла;
				Иначе
					Если СтруктураРаздела.node.node.Свойство("TEXT") Тогда
						ТекстРаздела = ТекстРаздела + "\subsubsection{"+СтруктураРаздела.node.node.TEXT+"}"+Символы.ПС+Символы.ПС;
					КонецЕсли;
					Если СтруктураРаздела.node.node.Свойство("richcontent") Тогда
						ТекстРаздела = ТекстРаздела + ПолучитьТекстПараграфа(СтруктураРаздела.node.node.richcontent);
					КонецЕсли;
					Если СтруктураРаздела.node.node.Свойство("node") Тогда
						ТекстРаздела = ТекстРаздела + СобратьТекстПодчиненныхУзлов(СтруктураРаздела.node.node.node);
					КонецЕсли;
				КонецЕсли;
			КонецЕсли;
		КонецЕсли;
	КонецЕсли;
	Возврат ТекстРаздела;
КонецФункции

&НаСервере
Функция СобратьТекстПодчиненныхУзлов(МассивУзлов)
	ТекстРазделов = "";
	Если ТипЗнч(МассивУзлов) = Тип("Массив") Тогда
		Для каждого Узел из МассивУзлов Цикл
			Если Узел.Свойство("node") Тогда
				Если ТипЗнч(Узел.node) = Тип("Массив") Тогда
					Возврат СобратьТекстПодчиненныхУзлов(Узел.node);
				Иначе
					Если Узел.Свойство("richcontent") Тогда
						ТекстРазделов = ТекстРазделов + ПолучитьТекстПараграфа(Узел.richcontent);
					КонецЕсли;
				КонецЕсли;
			Иначе
				Если Узел.Свойство("richcontent") Тогда
					ТекстРазделов = ТекстРазделов + ПолучитьТекстПараграфа(Узел.richcontent);
				КонецЕсли;
			КонецЕсли;
		КонецЦикла;
	Иначе
		Если МассивУзлов.Свойство("richcontent") Тогда
			ТекстРазделов = ТекстРазделов + ПолучитьТекстПараграфа(МассивУзлов.richcontent);
		КонецЕсли;
	КонецЕсли;
	Возврат ТекстРазделов;
КонецФункции

&НаСервере
Функция ПолучитьТекстПараграфа(СтруктураЗаметки)
	ТекстПараграфа = "";
	Если СтруктураЗаметки.Свойство("html") И СтруктураЗаметки.html.Свойство("body") И СтруктураЗаметки.html.body.Свойство("p") Тогда
		Если ТипЗнч(СтруктураЗаметки.html.body.p) = Тип("Массив") Тогда
			Для Каждого ЭлементМассива Из СтруктураЗаметки.html.body.p Цикл
				Если ТипЗнч(ЭлементМассива) = Тип("Структура") Тогда
					ТекстПараграфа = ТекстПараграфа +  Символы.ПС;
				Иначе
					ТекстПараграфа = ТекстПараграфа + ЭлементМассива;   
				КонецЕсли;
			КонецЦикла;
		Иначе
			ТекстПараграфа = СтруктураЗаметки.html.body.p;
		КонецЕсли;
	КонецЕсли;
	Возврат ТекстПараграфа;
КонецФункции

&НаКлиенте
Процедура ВыполнитьПреобразование(Команда)
	СтруктураДокументов = ВыполнитьПреобразованиеНаСервере();
	КаталогВыгрузки = СокрЛП(Объект.КаталогВыгрузки);
	Если Прав(КаталогВыгрузки,1) <> "\" Тогда
		КаталогВыгрузки = КаталогВыгрузки + "\"; 
	КонецЕсли;
	ИмяФайла = "titul"; 
	СтруктураДокументов.ТитульныйЛист.Записать(КаталогВыгрузки+ИмяФайла+".tex");
	й = 1;
	ШаблонИмениФайла = "chapter"; 
	Для каждого Документ из СтруктураДокументов.ДокументыРазделов Цикл
		ИмяФайла = ШаблонИмениФайла + Прав("00"+й,2);
		Документ.Записать(КаталогВыгрузки+ИмяФайла+".tex");
		й = й+1;
	КонецЦикла;
КонецПроцедуры

#Область РазборФайла

&НаСервере
Функция РазобратьXML()
	ЧтениеXML = Новый ЧтениеXML;
	ЧтениеXML.ОткрытьФайл(Объект.ИмяФайла);
	ФайлXDTO = ФабрикаXDTO.ПрочитатьXML(ЧтениеXML);
	РезультатЧтения = РазобратьОбъектXDTO(ФайлXDTO);
	Возврат РезультатЧтения;
КонецФункции

&НаСервере
Функция РазобратьОбъектXDTO(Элемент)
	Результат = Новый Структура;
	Для каждого Свойство из Элемент.Свойства() Цикл
		Если ТипЗнч(Элемент[Свойство.Имя]) = Тип("ОбъектXDTO") Тогда
			Результат.Вставить(Свойство.Имя, РазобратьОбъектXDTO(Элемент[Свойство.Имя]));
		ИначеЕсли ТипЗнч(Элемент[Свойство.Имя]) = Тип("СписокXDTO") Тогда
			Результат.Вставить(Свойство.Имя,РазобратьСписокXDTO(Элемент[Свойство.Имя]));
		Иначе
			Результат.Вставить(Свойство.Имя,Элемент[Свойство.Имя]);
		КонецЕсли;
	КонецЦикла;
	Возврат Результат;
КонецФункции

&НаСервере
Функция РазобратьСписокXDTO(СписокЭлементов)
	Результат = Новый Массив;
	Для каждого Элемент из СписокЭлементов Цикл
		Если ТипЗнч(Элемент) = Тип("ОбъектXDTO") Тогда
			Результат.Добавить(РазобратьОбъектXDTO(Элемент));
		Иначе
			Результат.Добавить(Элемент);
		КонецЕсли;
	КонецЦикла;
	Возврат Результат;
КонецФункции

#КонецОбласти