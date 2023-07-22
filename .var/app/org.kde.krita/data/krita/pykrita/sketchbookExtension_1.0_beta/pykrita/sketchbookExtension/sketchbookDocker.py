from PyQt5.QtWidgets import *
from krita import *
from sketchbookExtension import sketchbookExtension

class SketchbookManager(DockWidget):

	def __init__(self):
		super().__init__()
		self.setWindowTitle("Sketchbook Manager")
		mainWidget = QWidget(self)
		self.setWidget(mainWidget)

		buttonNewPage = QPushButton("New Page", mainWidget)
		buttonNewPage.clicked.connect(self.newPageButton)

		buttonPrevPage = QPushButton("Prev", mainWidget)
		buttonPrevPage.clicked.connect(self.prevPageButton)

		buttonNextPage = QPushButton("Next", mainWidget)
		buttonNextPage.clicked.connect(self.nextPageButton)

		globalBox = QVBoxLayout()
		globalBox.addWidget(buttonNewPage)

		box = QHBoxLayout()
		box.addWidget(buttonPrevPage)
		box.addWidget(buttonNextPage)

		globalBox.addLayout(box)
		globalBox.addStretch()

		mainWidget.setLayout(globalBox)

	def newPageButton(self):
		if Krita.instance().activeDocument() != None:
			Krita.instance().action("newPage").trigger()

	def prevPageButton(self):
		if Krita.instance().activeDocument() != None:
			Krita.instance().action("prevPage").trigger()

	def nextPageButton(self):
		if Krita.instance().activeDocument() != None:
			Krita.instance().action("nextPage").trigger()

	def canvasChanged(self, canvas):
		pass

Krita.instance().addDockWidgetFactory(DockWidgetFactory("SketchbookManager", DockWidgetFactoryBase.DockRight, SketchbookManager))