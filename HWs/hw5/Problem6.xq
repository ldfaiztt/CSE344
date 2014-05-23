(: Chun-Wei Chen (1267040)
   CSE 344 HW5
   02/20/14
:)

(: Problem 6. :)

<html>
<head>
<title>Rivers Crossing Two or More Countries</title>
</head>
<body>
<h1>List the name of the river which crosses at least 2 countries along with the names of the countries it crosses in desending order of the numbers of countries crossed</h1>
<ul>
  {
    for $x in doc("mondial.xml")/mondial,
		$r in $x/river
	let $cs := tokenize($r/@country, '\s+')
	let $n := count($cs)
	where $n >= 2
	order by $n descending
	return <li>
		     <div>{ $r/name/text() }</div>
			 <ol>
			 {
			   for $c in $cs
			   return <li>{ $x/country[@car_code = $c]/name/text() }</li>
			 }
			 </ol>
		   </li>
  }
</ul>
</body>
</html>