from krita import *

class sketchbookExtension(Extension):

	def __init__(self, parent):
		super(sketchbookExtension, self).__init__(parent)

	def newPage(self):

		MAXPAGES = 160
		doc = Krita.instance().windows()[0].activeView().document()

		root = doc.rootNode()
		nodes = doc.topLevelNodes()
		for node in nodes:
		    print(node.name())

		for i in range(1,MAXPAGES + 1):
		    found = False
		    name = "Page" + str(i)
		    for node in nodes:
		        if name == node.name():
		            found = True      
		            break           
		    if not found:
		        break
		    if i == MAXPAGES:
		    	return 0

		#all except the newly added     
		for node in nodes:
		    if node.name()[:4] == "Page":
		        node.setCollapsed(True)
		        # node.setLocked(True)
		        node.setVisible(False)
		                
		root = doc.rootNode()
		group = doc.createGroupLayer(name)
		root.addChildNode(group, None)

		n = doc.createNode("Layer", "paintlayer")
		
		group.addChildNode(n, None)
		doc.setActiveNode(n)

		doc.refreshProjection()

	def prevPage(self):

		doc = Krita.instance().windows()[0].activeView().document()
		root = doc.rootNode()
		nodes = doc.topLevelNodes()

		id = 0
		for node in nodes:
		    if node.name()[:4] == "Page" and node.visible():
		        id = node.name()[4:]
		        break

		for prevNode in nodes:
		    if prevNode.name() == "Page" + str(int(id)-1):       
		        node.setVisible(False)  
		        # node.setLocked(True)      
		        node.setCollapsed(True)
		              
		        prevNode.setVisible(True)
		        # prevNode.setLocked(False)
		        prevNode.setCollapsed(False)

		        for i in range(5):
		        	if prevNode.type() == "grouplayer":
		        		prevNode = prevNode.childNodes()[-1]
		        	else:
		        		break
		        doc.setActiveNode(prevNode)

		        doc.refreshProjection()

	def nextPage(self):

		doc = Krita.instance().windows()[0].activeView().document()
		root = doc.rootNode()
		nodes = doc.topLevelNodes()

		id = 0
		for node in nodes:
		    if node.name()[:4] == "Page" and node.visible():
		        id = node.name()[4:]
		        break

		for nextNode in nodes:
		    if nextNode.name() == "Page" + str(int(id)+1):       
		        node.setVisible(False)  
		        # node.setLocked(True)      
		        node.setCollapsed(True)
		              
		        nextNode.setVisible(True)
		        # nextNode.setLocked(False)
		        nextNode.setCollapsed(False)

		        for i in range(5):
		        	if nextNode.type() == "grouplayer":
		        		nextNode = nextNode.childNodes()[-1]
		        	else:
		        		break
		        doc.setActiveNode(nextNode)

		        doc.refreshProjection()

	def setup(self):
		pass

	def createActions(self, window):
		newPage = window.createAction("newPage", "create new sketchbook page")
		newPage.triggered.connect(self.newPage)

		prevPage = window.createAction("prevPage", "go to previous sketchbook page")
		prevPage.triggered.connect(self.prevPage)

		nextPage = window.createAction("nextPage", "go to next sketchbook page")
		nextPage.triggered.connect(self.nextPage)

Krita.instance().addExtension(sketchbookExtension(Krita.instance()))