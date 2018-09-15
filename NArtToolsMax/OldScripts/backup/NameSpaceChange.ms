for i in Objects do (
	str = i.name	
	newName =""
	for j=1 to str.count do(
		if str[j]==" " then(			
			str[j]="_"
		)
		newName += str[j]
		i.name = newName
	)
)