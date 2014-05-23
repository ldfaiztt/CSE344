(: Chun-Wei Chen (1267040)
   CSE 344 HW5
   02/20/14
:)

(: Problem 5. :)

<result>
  {
    for $x in doc("mondial.xml")/mondial,
		$c in $x/country
	where count($x/mountain[located/@country = $c/@car_code][height > 2000]) >= 3
	return <country>
		     <name>{ $c/name/text() }</name>
			 {
			   for $m in $x/mountain[located/@country = $c/@car_code]
			   return <mountain>
					    <name>{ $m/name/text() }</name>
						<height>{ $m/height/text() }</height>
					  </mountain>
			 }
		   </country>
  }
</result>

(: Results -- the spec says list the first 3 items returned and the question is asking for names of countries; therefore, I list first three countries from the output
	<?xml version="1.0" encoding="UTF-8"?>
	<result>
	  <country>
		<name>France</name>
		<mountain>
		  <name>Mont Blanc</name>
		  <height>4808</height>
		</mountain>
		<mountain>
		  <name>Barre des Ecrins</name>
		  <height>4101</height>
		</mountain>
		<mountain>
		  <name>Grand Ballon</name>
		  <height>1424</height>
		</mountain>
		<mountain>
		  <name>Puy De Dome</name>
		  <height>1465</height>
		</mountain>
		<mountain>
		  <name>Puy de Sancy</name>
		  <height>1885</height>
		</mountain>
		<mountain>
		  <name>Vignemale</name>
		  <height>3298</height>
		</mountain>
		<mountain>
		  <name>Monte Cinto</name>
		  <height>2706</height>
		</mountain>
	  </country>
	  <country>
		<name>Spain</name>
		<mountain>
		  <name>Vignemale</name>
		  <height>3298</height>
		</mountain>
		<mountain>
		  <name>Pico de Aneto</name>
		  <height>3404</height>
		</mountain>
		<mountain>
		  <name>Torre de Cerredo</name>
		  <height>2648</height>
		</mountain>
		<mountain>
		  <name>Pico de Almanzor</name>
		  <height>2648</height>
		</mountain>
		<mountain>
		  <name>Moncayo</name>
		  <height>2313</height>
		</mountain>
		<mountain>
		  <name>Mulhacen</name>
		  <height>3482</height>
		</mountain>
		<mountain>
		  <name>Pico de Teide</name>
		  <height>3718</height>
		</mountain>
		<mountain>
		  <name>Pico de los Nieves</name>
		  <height>1949</height>
		</mountain>
		<mountain>
		  <name>Roque de los Muchachos</name>
		  <height>2426</height>
		</mountain>
	  </country>
	  <country>
		<name>Austria</name>
		<mountain>
		  <name>Zugspitze</name>
		  <height>2963</height>
		</mountain>
		<mountain>
		  <name>Grossglockner</name>
		  <height>3797</height>
		</mountain>
		<mountain>
		  <name>Hochgolling</name>
		  <height>2862</height>
		</mountain>
	  </country>
	  ...
	</result>
:)