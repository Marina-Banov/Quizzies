from PySide6.QtCore import QObject, Property, Signal


class QObjectWrapper(QObject):
    def __init__(self, obj):
        QObject.__init__(self)
        self._obj = obj

    @property
    def obj(self):
        return self._obj

    def _name(self):
        return self._obj.name

    changed = Signal()
    name = Property(str, _name, notify=changed)
