# this is a script that can be used in krita scripter to
# get proper value of offset if "set reference script"
# does not work properly

from krita import * 

if (len(Krita.instance().views()) == 2):
	activeView = Krita.instance().windows()[0].activeView()

	for view in Krita.instance().views():
		if view != activeView:
			reference = view

	activeCan = activeView.canvas()
	referenceCan = reference.canvas()
	activeDoc = activeView.document()
	referenceDoc = reference.document()

	scale = activeDoc.width()/referenceDoc.width()
	level = activeCan.zoomLevel()*scale

	referenceCan.setZoomLevel(level)

	print("your offset value: " + str(activeCan.zoomLevel()/referenceCan.zoomLevel()))
else:
	print("open exactly two documents")