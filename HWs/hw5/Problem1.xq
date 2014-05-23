(: Chun-Wei Chen (1267040)
   CSE 344 HW5
   02/20/14
:)

(: Problem 1. :)

<result>
<country>
<name>Peru</name>
  {
	for $x in doc("mondial.xml")/mondial/country[name/text() = "Peru"]//city/name
	order by $x/text()
	return <city>{ $x/text() }</city>
  }
</country>
</result>


(: Results
	<?xml version="1.0" encoding="UTF-8"?>
	<result>
	  <country>
		<name>Peru</name>
		<city>
		  <name>Abancay</name>
		</city>
		<city>
		  <name>Arequipa</name>
		</city>
		<city>
		  <name>Ayacucho</name>
		</city>
		...
	  </country>
	</result>
:)