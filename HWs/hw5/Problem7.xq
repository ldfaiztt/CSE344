(: Chun-Wei Chen (1267040)
   CSE 344 HW5
   02/20/14
:)

(: Problem 7. :)

<result>
<waterbody>
<name>Pacific Ocean</name>
  {
    for $x in doc("mondial.xml")/mondial,
		$o in $x/sea[name/text() = "Pacific Ocean"]
	let $cs := tokenize($o/@country, '\s+')
	return <adjacent_countries>
			 {
			   for $c in $cs
			   return <country>
						<name>{ $x/country[@car_code = $c]/name/text() }</name>
					  </country>
			 }
		   </adjacent_countries>
  }
</waterbody>
</result>

(: Results
	<?xml version="1.0" encoding="UTF-8"?>
	<result>
	  <waterbody>
		<name>Pacific Ocean</name>
		<adjacent_countries>
		  <country>
			<name>Russia</name>
		  </country>
		  <country>
			<name>Japan</name>
		  </country>
		  <country>
			<name>Maldives</name>
		  </country>
		  ...
		</adjacent_countries>
	  </waterbody>
	</result>
:)