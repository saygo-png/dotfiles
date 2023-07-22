from krita import *

class wojtrybExtension(Extension):

	def __init__(self, parent):
		super(wojtrybExtension, self).__init__(parent)

	def switchBlendingMode(self):
		modesList = ["normal", "overlay", "color"]

		view = Krita.instance().windows()[0].activeView()

		for i, mode in enumerate(modesList):
			if mode == view.currentBlendingMode() and i+1 != len(modesList):
				view.setCurrentBlendingMode(modesList[i+1])
				return

		view.setCurrentBlendingMode(modesList[0])

	def switchOpacity(self):
		opacityList = [1, 0.5]

		view = Krita.instance().windows()[0].activeView()

		for i, opacity in enumerate(opacityList):
			if opacity == view.paintingOpacity() and i+1 != len(opacityList):
				view.setPaintingOpacity(opacityList[i+1])
				return

		view.setPaintingOpacity(opacityList[0])

	def setReferenceImage(self):
		offsetWorkaround = 0.72

		if (len(Krita.instance().views()) == 2):
			activeView = Krita.instance().windows()[0].activeView()

			for view in Krita.instance().views():
				if view != activeView:
					reference = view

			activeCan = activeView.canvas()
			referenceCan = reference.canvas()
			activeDoc = activeView.document()
			referenceDoc = reference.document()

			referenceCan.setMirror(activeCan.mirror())
			referenceCan.resetRotation()
			referenceCan.setRotation(activeCan.rotation())

			scale = activeDoc.width()/referenceDoc.width()
			level = activeCan.zoomLevel()*scale*offsetWorkaround

			referenceCan.setZoomLevel(level)

	def switchSelectionMask(self):
		activeDoc = Krita.instance().windows()[0].activeView().document()
		activeNode = activeDoc.activeNode()
		# activeNode.setCollapsed(True)
		childList = activeNode.childNodes()

		selectionMasksList = []
		for child in childList:
		    if child.type() == 'selectionmask':
		        selectionMasksList.append(child)

		rightChild = None
		for i, child in enumerate(selectionMasksList):
		    if child.colorLabel() == 2:
		        child.setColorLabel(0)
		        if i + 1 != len(selectionMasksList):
		            rightChild = selectionMasksList[i+1];
		            break;

		if rightChild == None and len(selectionMasksList) != 0:
		    rightChild = selectionMasksList[0]

		if rightChild != None:
		    selectionToSet = rightChild.selection()        
		    activeDoc.setSelection(selectionToSet)
		    rightChild.setColorLabel(2)

	def setup(self):
		pass

	def createActions(self, window):
		switchBlendingMode = window.createAction("switchBlendingMode", "Switch blending mode")
		switchBlendingMode.triggered.connect(self.switchBlendingMode)

		switchOpacity = window.createAction("switchOpacity", "Switch opacity")
		switchOpacity.triggered.connect(self.switchOpacity)

		setReferenceImage = window.createAction("setReferenceImage", "Set reference image")
		setReferenceImage.triggered.connect(self.setReferenceImage)

		switchSelectionMask = window.createAction("switchSelectionMask", "Switch selection mask")
		switchSelectionMask.triggered.connect(self.switchSelectionMask)

Krita.instance().addExtension(wojtrybExtension(Krita.instance()))
