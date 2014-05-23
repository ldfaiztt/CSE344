(: Chun-Wei Chen (1267040)
   CSE 344 HW5
   02/20/14
:)

(: Problem 2. :)

<result>
  {
    for $x in doc("mondial.xml")/mondial/country
	let $c := count(distinct-values($x/province/@id))
	where $c > 20
	order by $c descending
	return <country num_provinces="{$c}">
	         <name>{ $x/name/text() }</name>
		   </country>
  }
</result>

(: Results
	<?xml version="1.0" encoding="UTF-8"?>
	<result>
	  <country num_provinces="81">
		<name>United Kingdom</name>
	  </country>
	  <country num_provinces="80">
		<name>Russia</name>
	  </country>
	  <country num_provinces="73">
		<name>Turkey</name>
	  </country>
	  ...
	</result>
:)