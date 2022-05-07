INSERT INTO quiz(name) VALUES ('Mix kviz 1');
INSERT INTO quiz(name) VALUES ('Mix kviz 2');

INSERT INTO category(name, quiz_id) VALUES ('Glazba', 1);
INSERT INTO category(name, quiz_id) VALUES ('TV i film', 1);
INSERT INTO category(name, quiz_id) VALUES ('Geografija', 2);
INSERT INTO category(name, quiz_id) VALUES ('Videoigre', 2);

INSERT INTO question(short_code, question, answer, type, "order", points)
VALUES ('Barbie girl', 'Koja “one hit wonder” grupa je napisala pjesmu “Barbie girl” koja je 1997. godine postala multi-platinum hit?',
        'Aqua', 1, '1', 1);
INSERT INTO question(short_code, question, answer, type, "order", points)
VALUES ('MTV spot', 'Kada se 1981. po prvi puta na televiziji pojavio MTV, koja je (pomalo “ironična”) pjesma prva puštena na MTV-u ujedno kao i prvi spot ikada pušten preko televizije?',
        'Video killed the radio star', 1, '2', 1);
INSERT INTO question(short_code, question, answer, type, "order", points)
VALUES ('Taxi driver', 'U kojem trileru iz 1976. Robert De Niro slavno kaže “You talkin’ to me?”',
        'Taxi driver', 1, '1', 1);
INSERT INTO question(short_code, question, answer, type, "order", points)
VALUES ('La La Land', 'Koji je film pogrešno najavljen kao pobjednik za najbolji film na dodjeli Oskara 2017. godine, što se smatra jednim od najvećih pogrešaka ikada na dodjeli Oskara?',
        'La La Land', 1, '2', 1);
INSERT INTO question(short_code, question, answer, type, "order", points)
VALUES ('UK', 'Ljudi stvarno svakakvo znaju nazvati određena geografska mjesta, počevši od jezera u Massachusettsu s 45 slova do nekoliko različitih lokacija, rijeka i otoka čije se ime sastoji od samo jednog slova. Koja država ima službeno najduže ime na svijetu sa 56 slova u svome nazivu, a kada skratimo taj naziv dobijemo samo 2 slova?',
        'United Kingdom of Great Brittain and Northern Ireland (U.K.)', 1, '1', 1);
INSERT INTO question(short_code, question, answer, type, "order", points)
VALUES ('Brazil', 'Brazil je najveća država u Južnoj Americi te graniči sa svim državama tog kontinenta osim dvije. Koje to države Južne Amerike ne graniče s Brazilom?',
        'Čile i Ekvador', 1, '2', 1);
INSERT INTO question(short_code, question, answer, type, "order", points)
VALUES ('Samus Aran', 'Kako se zove glavna protagonistica, lovkinja na glave, u video igri Metroid, ujedno i jedna od prvih ženskih protagonistica videoigara?',
        'Samus Aran', 1, '1', 1);
INSERT INTO question(short_code, question, answer, type, "order", points)
VALUES ('Jumpman', 'U izvornoj arkadnoj verziji Donkey Konga, kako se zvao lik koji će kasnije biti poznat kao Mario?',
        'Jumpman', 1, '2', 1);

INSERT INTO category_question(category_id, question_id) VALUES (1, 1);
INSERT INTO category_question(category_id, question_id) VALUES (1, 2);
INSERT INTO category_question(category_id, question_id) VALUES (2, 3);
INSERT INTO category_question(category_id, question_id) VALUES (2, 4);
INSERT INTO category_question(category_id, question_id) VALUES (3, 5);
INSERT INTO category_question(category_id, question_id) VALUES (3, 6);
INSERT INTO category_question(category_id, question_id) VALUES (4, 7);
INSERT INTO category_question(category_id, question_id) VALUES (4, 8);
