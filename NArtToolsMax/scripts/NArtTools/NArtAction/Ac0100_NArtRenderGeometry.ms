_obj = undefined
_path = @"e:\MaxRender\"

if Geometry.count == 1 then(
	_obj = Geometry[1]
)else (
	if selection.count == 1 do(
		_obj = selection[1]
	)
)

if _obj != undefined do(
	_with = NArtGeometry.GetWidth _obj
	NArtGeometry.CopyGeoForRender _obj (_with + _with/100)
	clearSelection()
	actionMan.executeAction 0 "40060"  -- Views: Front View
	actionMan.executeAction 0 "311"  -- Tools: Zoom Extents All Selected
	
	rendSaveFile = true
	rendOutputFilename = _path + (GetFileNamefile maxfilename) + ".jpg"
	print rendOutputFilename
	makedir _path
	renderWidth  = 5000
	renderHeight = 5000
	actionMan.executeAction 0 "50031"  -- Render: Render
)
