
fn getUpperFolder currentPath =
(
	pathAr = filterString  currentPath "\\"
-- 	print pathAr[1]
	if pathAr.count > 1 then
	(
		res = findString pathAr[1] ":"
	)
	-- find ":" in path
	
	if res == undefined then
	(
		upperPath = "\\\\"
	)
	else
	(
		upperPath = ""
	)
	
	
	for i = 1 to (pathAr.count - 1) do
	(
		upperPath =upperPath + pathAr[i] + "\\"
	)
	upperPath
)	

-- getUpperFolder maxFilePath


fn publishVersion pathbase assetName version =
(
	-- create folder
	newFolder = pathbase + "\\" + assetName +"\\" + (returnDigit version)
	newFolder
	makeDir newFolder	
	-- create version info file
	-- update asset info file
	-- save version max file
)


fn returnDigit num =
(
	numStr = ""
	if num<=9 then numStr = "00" + (num as string)
	else if num>9 then numStr = "0" + (num as string)
	else if num>99 then numStr = (num as string)
	numStr
)