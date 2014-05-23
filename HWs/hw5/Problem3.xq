(: Chun-Wei Chen (1267040)
   CSE 344 HW5
   02/20/14
:)

(: Problem 3. :)

<result>
<country>
<name>United States</name>
  {
    for $x in doc("mondial.xml")/mondial/country[name/text() = "United States"]/province
	let $r := number($x/population) div number($x/area)
	order by $r descending
	return <state>
		     <name>{ $x/name/text() }</name>
			 <population_density>{ $r }</population_density>
		   </state>
  }
</country>
</result>

(: Results
	<?xml version="1.0" encoding="UTF-8"?>
	<result>
	  <country>
		<name>United States</name>
		<state>
		  <name>Distr. Columbia</name>
		  <population_density>2955.106145251397</population_density>
		</state>
		<state>
		  <name>New Jersey</name>
		  <population_density>399.28842721142405</population_density>
		</state>
		<state>
		  <name>Rhode Island</name>
		  <population_density>314.56801529149413</population_density>
		</state>
		...
	  </country>
	</result>
:)