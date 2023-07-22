from krita import *
doc = Krita.instance().windows()[0].activeView().document()

nodes = doc.topLevelNodes()
i = 0
for node in nodes:
    if node.visible():
        name = node.name()
        node.setName(str(i) + "_" + name)
        i+=1