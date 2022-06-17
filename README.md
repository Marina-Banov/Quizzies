# Quizzies

Quizzies is a desktop application for all the trivia quiz lovers which allows them to create and showcase their own quizzes.

## Setup

Requirements:
- [Python 3.9](https://www.python.org/downloads/release/python-396/)
- [Qt 6.2.3](https://www.qt.io/download-qt-installer)

**Note:** you might want to initialize a Python [virtual environment](https://docs.python.org/3/tutorial/venv.html).

To start the application, position yourself inside the `src/` folder and run:
```
pip install pyside6
pyside6-rcc res.qrc > qrc.py
python main.py
```
