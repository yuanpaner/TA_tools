-- panyuan 2015-4
-- xml file writing

struct NArtXml(

	/* ------------------------
	add child node to parent node
	xmlFile : xxx\\xxx\xxx.xml
	 ------------------------*/	

	fn AppendChild_simple xmlFile parentNode childNodeName =
	(
		
		dotNet.loadAssembly "system.xml"
		xmlDoc = dotNetObject "System.Xml.XmlDocument"

		childElement=xmlDoc.createElement childNodeName
		
		if ( parentNode == 1 ) then (
			xmlDoc.appendChild childElement
			childElement.setAttribute "name" "root"			
			)
		else ( 
				if (doesFileExist xmlFile) then
				(
					if(parentNode == 2) then
					(
-- 						print "file has existed"
						xmlDoc.load xmlFile
						docEle = xmlDoc.documentElement
-- 						print docEle.name
-- 						showProperties docEle
-- 						showProperties docEle.Attributes
-- 						print "this is docEle"
-- 						showProperties docEle.ChildNodes
-- 						print docEle.ChildNodes.count
						docEle.appendChild childElement
						
					)
					if(parentNode == 3) then
					(
						xmlDoc.load xmlFile
						docEle = xmlDoc.documentElement
-- 						print docEle.name
-- 						print docEle.ChildNodes.count
-- 						showProperties docEle.ChildNodes.itemOf[0]
-- 						print docEle.ChildNodes[1].name
-- 						print docEle.ChildNodes.itemOf[1]
						docEle.ChildNodes.itemOf[docEle.ChildNodes.count-1].appendChild childElement
						
					)
					
				)
			)
		
		xmlDoc.Save(xmlFile)

		
	),
	fn AppendChild_attr3 xmlFile parentNode childNodeName attri1Name attri1 attri2Name attri2 attri3Name attri3 =
	(
		
		dotNet.loadAssembly "system.xml"
		xmlDoc = dotNetObject "System.Xml.XmlDocument"

		childElement=xmlDoc.createElement childNodeName
		
		if ( parentNode == 1 ) then (
			xmlDoc.appendChild childElement
			childElement.setAttribute attri1Name attri1
			childElement.setAttribute attri2Name attri2
			childElement.setAttribute attri3Name attri3			
			)
		else ( 
				if (doesFileExist xmlFile) then
				(
					if(parentNode == 2) then
					(
-- 						print "file has existed, this is level 2"
						xmlDoc.load xmlFile
						docEle = xmlDoc.documentElement
-- 						print docEle.name
-- 						showProperties docEle
-- 						showProperties docEle.Attributes
-- 						print "this is docEle"
-- 						showProperties docEle.ChildNodes
-- 						print docEle.ChildNodes.count
						if ( attri1Name != "none") then childElement.setAttribute attri1Name attri1
						if ( attri2Name != "none") then childElement.setAttribute attri2Name attri2
						if ( attri3Name != "none") then childElement.setAttribute attri3Name attri3	
						docEle.appendChild childElement
						
					)
					if(parentNode == 3) then
					(
						xmlDoc.load xmlFile
						docEle = xmlDoc.documentElement
-- 						print docEle.name
-- 						print docEle.ChildNodes.count
-- 						showProperties docEle.ChildNodes.itemOf[0]
-- 						print docEle.ChildNodes[1].name
-- 						print docEle.ChildNodes.itemOf[1]
						if ( attri1Name != "none") then childElement.setAttribute attri1Name attri1
						if ( attri2Name != "none") then childElement.setAttribute attri2Name attri2
						if ( attri3Name != "none") then childElement.setAttribute attri3Name attri3		
						docEle.ChildNodes.itemOf[docEle.ChildNodes.count-1].appendChild childElement
						
					)
					
				)
			)
		
		xmlDoc.Save(xmlFile)

		
	),
	fn AppendChild_attr4 xmlFile parentNode childNodeName attri1Name attri1 attri2Name attri2 attri3Name attri3 attri4Name attri4 =
	(
		
		dotNet.loadAssembly "system.xml"
		xmlDoc = dotNetObject "System.Xml.XmlDocument"

		childElement=xmlDoc.createElement childNodeName
		
		if ( parentNode == 1 ) then (
-- 			xmlDoc.appendChild childElement
			childElement.setAttribute attri1Name attri1
			childElement.setAttribute attri2Name attri2
			childElement.setAttribute attri3Name attri3
			childElement.setAttribute attri4Name attri4	
			xmlDoc.appendChild childElement
			)
		else ( 
				if (doesFileExist xmlFile) then
				(
					if(parentNode == 2) then
					(
-- 						print "file has existed, this is level 2"
						xmlDoc.load xmlFile
						docEle = xmlDoc.documentElement
-- 						print docEle.name
-- 						showProperties docEle
-- 						showProperties docEle.Attributes
-- 						print "this is docEle"
-- 						showProperties docEle.ChildNodes
-- 						print docEle.ChildNodes.count
						childElement.setAttribute attri1Name attri1
						childElement.setAttribute attri2Name attri2
						childElement.setAttribute attri3Name attri3	
						childElement.setAttribute attri4Name attri4
						docEle.appendChild childElement
						
					)
					if(parentNode == 3) then
					(
						xmlDoc.load xmlFile
						docEle = xmlDoc.documentElement
-- 						print docEle.name
-- 						print docEle.ChildNodes.count
-- 						showProperties docEle.ChildNodes.itemOf[0]
-- 						print docEle.ChildNodes[1].name
-- 						print docEle.ChildNodes.itemOf[1]
						childElement.setAttribute attri1Name attri1
						childElement.setAttribute attri2Name attri2
						childElement.setAttribute attri3Name attri3	
						childElement.setAttribute attri4Name attri4
						docEle.ChildNodes.itemOf[docEle.ChildNodes.count-1].appendChild childElement
						
					)
					
				)
			)
		
		xmlDoc.Save(xmlFile)

		
	),

	fn AppendChild_innerText xmlFile parentNode childNodeName innerText =
	(
		dotNet.loadAssembly "system.xml"
		xmlDoc = dotNetObject "System.Xml.XmlDocument"

		childElement=xmlDoc.createElement childNodeName
		childElement.InnerText = (innerText as string)
		if (doesFileExist xmlFile)  then (
			xmlDoc.load xmlFile
			if ( parentNode == 4 ) then
				(
						xmlDoc.load xmlFile
						docEle = xmlDoc.documentElement
						geoNo = docEle.ChildNodes.count
						geoProNo = docEle.ChildNodes.itemOf[geoNo-1].ChildNodes.count
						docEle.ChildNodes.itemOf[geoNo-1].ChildNodes.itemOf[geoProNo-1].appendChild childElement
					
				)
			if ( parentNode == 3 ) then
				(
						xmlDoc.load xmlFile
						docEle = xmlDoc.documentElement
						geoNo = docEle.ChildNodes.count
						geoProNo = docEle.ChildNodes.itemOf[geoNo-1].ChildNodes.count
						docEle.ChildNodes.itemOf[geoNo-1].appendChild childElement
					
				)
			)	
		/*
		if ( parentNode != 4 ) then (
			print "the hierarchy is wrong"	
			)
		else ( 
				if (doesFileExist xmlFile) then
				(

						xmlDoc.load xmlFile
						docEle = xmlDoc.documentElement
-- 						print docEle.name
-- 						print docEle.ChildNodes.count
-- 						showProperties docEle.ChildNodes.itemOf[0]
-- 						print docEle.ChildNodes[1].name
-- 						print docEle.ChildNodes.itemOf[1]
-- 						print "this is level 4"
-- 						docEle.ChildNodes.itemOf[docEle.ChildNodes.count-1].ChildNodes.itemOf[doc.geo.itemOf[docEle.ChildNodes.count-1].ChildNodes.itemOf[docEle.ChildNodes.itemOf[docEle.ChildNodes.count-1]]] appendChild childElement
						geoNo = docEle.ChildNodes.count
-- 						print geoNo
						geoProNo = docEle.ChildNodes.itemOf[geoNo-1].ChildNodes.count
-- 						print geoProNo
						docEle.ChildNodes.itemOf[geoNo-1].ChildNodes.itemOf[geoProNo-1].appendChild childElement
					
				)
			)
		*/
		xmlDoc.Save(xmlFile)

		
	)
	
)

print "Load NArtXml"
