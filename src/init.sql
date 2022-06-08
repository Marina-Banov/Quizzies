-- all comments should end with a semicolon;
CREATE TABLE IF NOT EXISTS quiz (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    name TEXT NOT NULL
);

INSERT INTO quiz(name) VALUES ('Mix kviz 1');
INSERT INTO quiz(name) VALUES ('Mix kviz 2');

CREATE TABLE IF NOT EXISTS category (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    name TEXT NOT NULL,
    quiz_id INTEGER NOT NULL,
    FOREIGN KEY (quiz_id) REFERENCES quiz (id) ON DELETE CASCADE
);

INSERT INTO category(name, quiz_id) VALUES ('Glazba', 1);
INSERT INTO category(name, quiz_id) VALUES ('TV i film', 1);
INSERT INTO category(name, quiz_id) VALUES ('Geografija', 2);
INSERT INTO category(name, quiz_id) VALUES ('Videoigre', 2);

-- if a category is deleted the questions won't be deleted
-- that is intended behaviour because a question could belong
-- to multiple categories if used in multiple quizzes
-- consider adding those list checkboxes to enable
-- deleting multiple questions and/or categories at once;
CREATE TABLE IF NOT EXISTS question (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    name VARCHAR(30) NOT NULL,
    question TEXT,
    answer TEXT,
    qtype INTEGER NOT NULL,
    'order' TEXT NOT NULL,
    points INTEGER,
    image BLOB
);

INSERT INTO question(question, name, answer, qtype, "order", points) VALUES (
    'Koja “one hit wonder” grupa je napisala pjesmu “Barbie girl” koja je 1997. godine postala multi-platinum hit?',
    'Barbie girl', 'Aqua', 1, '1', 1
);
INSERT INTO question(question, name, answer, qtype, "order", points) VALUES (
    'Kada se 1981. po prvi puta na televiziji pojavio MTV, koja je (pomalo “ironična”) pjesma prva puštena na MTV-u ujedno kao i prvi spot ikada pušten preko televizije?',
    'MTV spot', 'Video killed the radio star', 1, '2', 1
);
INSERT INTO question(question, name, answer, qtype, "order", points) VALUES (
    'U kojem trileru iz 1976. Robert De Niro slavno kaže “You talkin’ to me?”',
    'Taxi driver', 'Taxi driver', 1, '1', 1
);
INSERT INTO question(question, name, answer, qtype, "order", points) VALUES (
    'Koji je film pogrešno najavljen kao pobjednik za najbolji film na dodjeli Oskara 2017. godine, što se smatra jednim od najvećih pogrešaka ikada na dodjeli Oskara?',
    'Blam na Oskarima', 'La La Land', 1, '2', 1
);
INSERT INTO question(question, name, answer, qtype, "order", points) VALUES (
    'Ljudi stvarno svakakvo znaju nazvati određena geografska mjesta, počevši od jezera u Massachusettsu s 45 slova do nekoliko različitih lokacija, rijeka i otoka čije se ime sastoji od samo jednog slova. Koja država ima službeno najduže ime na svijetu s 56 slova u svome nazivu, a kada skratimo taj naziv dobijemo samo 2 slova?',
    'Najdulje ime države', 'United Kingdom of Great Britain and Northern Ireland (U.K.)', 1, '1', 1
);
INSERT INTO question(question, name, answer, qtype, "order", points) VALUES (
    'Brazil je najveća država u Južnoj Americi te graniči sa svim državama tog kontinenta osim dvije. Koje to države Južne Amerike ne graniče s Brazilom?',
    'Ne graniče s Brazilom', 'Čile i Ekvador', 1, '2', 1
);
INSERT INTO question(question, name, answer, qtype, "order", points) VALUES (
    'Kako se zove glavna protagonistica, lovkinja na glave, u video igri Metroid, ujedno i jedna od prvih ženskih protagonistica videoigara?',
    'Samus Aran', 'Samus Aran', 1, '1', 1
);
INSERT INTO question(question, name, answer, qtype, "order", points) VALUES (
    'U izvornoj arkadnoj verziji Donkey Konga, kako se zvao lik koji će kasnije biti poznat kao Mario?',
    'Donkey Kong lik', 'Jumpman', 1, '2', 1
);

CREATE TABLE IF NOT EXISTS choice (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    choice TEXT NOT NULL,
    question_id INTEGER NOT NULL,
    FOREIGN KEY (question_id) REFERENCES question (id) ON DELETE CASCADE
);

CREATE TABLE IF NOT EXISTS category_question (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    category_id INTEGER NOT NULL,
    question_id INTEGER NOT NULL,
    FOREIGN KEY (category_id) REFERENCES category (id) ON DELETE CASCADE,
    FOREIGN KEY (question_id) REFERENCES question (id) ON DELETE CASCADE
);

INSERT INTO category_question(category_id, question_id) VALUES (1, 1);
INSERT INTO category_question(category_id, question_id) VALUES (1, 2);
INSERT INTO category_question(category_id, question_id) VALUES (2, 3);
INSERT INTO category_question(category_id, question_id) VALUES (2, 4);
INSERT INTO category_question(category_id, question_id) VALUES (3, 5);
INSERT INTO category_question(category_id, question_id) VALUES (3, 6);
INSERT INTO category_question(category_id, question_id) VALUES (4, 7);
INSERT INTO category_question(category_id, question_id) VALUES (4, 8);
