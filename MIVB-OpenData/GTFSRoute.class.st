"
I represent a GTFS Route

The data is retrieved from routes.txt in the GTFS file retrieved from the MIVB Open Data api 

mapping

<- routes.txt

route_id,route_short_name,route_long_name,route_desc,route_type,route_url,route_color,route_text_color
1,1,""GARE DE L'OUEST - STOCKEL"",,1,,C4008F,FFFFFF

-> GTFSRoute 

routeId : '1'
shortName : '1'
longName : 'GARE DE L'OUEST - STOCKEL'
routeType : '1'
color : 'C4008F'
textColor : 'FFFFFF'

"
Class {
	#name : #GTFSRoute,
	#superclass : #Object,
	#instVars : [
		'routeId',
		'shortName',
		'longName',
		'routeType',
		'color',
		'textColor'
	],
	#classVars : [
		'RouteSymbols',
		'RouteText'
	],
	#category : #'MIVB-OpenData'
}

{ #category : #'instance creation' }
GTFSRoute class >> from: anArray [
	"return a route based on the array returned from the routes.txt csv file"

	^ self new
		routeId: (anArray at: 1);
		shortName: (anArray at: 2);
		longName: (anArray at: 3);
		routeType: (anArray at: 4);
		color: (anArray at: 5);
		textColor: (anArray at: 6)
]

{ #category : #'instance creation' }
GTFSRoute class >> fromShortName: aShortName [
	"return the GTSRoute from the default Routes based on aShortName"

			
	MIVBGtfs defaultRoutes
	    keysAndValuesDo: [ :routeId :aGTFSRoute |
		  aGTFSRoute shortName = aShortName ifTrue: [ ^aGTFSRoute ] ]
]

{ #category : #'class initialization' }
GTFSRoute class >> initialize [
	"initialize the class variables"

	RouteSymbols := Dictionary
		newFrom:
			{('0' -> #Tram).
			('1' -> #Subway).
			('2' -> #Rail).
			('3' -> #Bus).
			('4' -> #Ferry).
			('5' -> #CableCar).
			('6' -> #Gondolla).
			('7' -> #Funicular)}.
			
	RouteText := Dictionary 
	   newFrom:
			{('0' -> 'T').
			('1' -> 'M').
			('2' -> 'R').
			('3' -> 'B').
			('4' -> 'F').
			('5' -> 'C').
			('6' -> 'G').
			('7' -> 'F')}
		
		
]

{ #category : #accessing }
GTFSRoute >> color [
	^ color
]

{ #category : #accessing }
GTFSRoute >> color: anObject [
	color := anObject
]

{ #category : #'gt-inspector-extension' }
GTFSRoute >> gtInspectorDetailsIn: composite [
	<gtInspectorPresentationOrder: 30>
	^ composite table
		title: 'Details';
		display: [ 
					{'routeId' -> self routeId.
					'shortName' -> self shortName.
					'longName' -> self longName.
					'routeType' -> self routeType.
					'routeSymbol' -> self routeSymbol.
					'textColor' -> self textColor.
					'color' -> self color.
					'routeIdIcon' -> self routeIdIcon.
					'routeTypeIcon' -> self routeTypeIcon } ];
		column: 'Key' evaluated: #key;
		column: 'Value' evaluated: #value;
		send: #value
]

{ #category : #'gt-inspector-extension' }
GTFSRoute >> gtInspectorLineStopsIn: composite [
	<gtInspectorPresentationOrder: 40>
	<gtInspectorTag: #basic>
	composite list
		title: 'LineStops';
		display: [ self lineStops ];
		icon:
				[ :each | each ifNotNil: [ each routeIdIcon ] ifNil: [ MIVBIcon routeIdIcon ] ]
]

{ #category : #'gt-inspector-extension' }
GTFSRoute >> gtInspectorTranslationsIn: composite [
    <gtInspectorPresentationOrder: 50>
    <gtInspectorTag: #basic> 
 
    composite list
      title: 'Translations';
      display: [ GTFSTranslation translationsFor: self longName ].
   
]

{ #category : #navigation }
GTFSRoute >> lineStops [
	"return the lineStops for this route"

   ^ GTFSLineStops forRoute: self shortName.
]

{ #category : #accessing }
GTFSRoute >> longName [
	^ longName
]

{ #category : #accessing }
GTFSRoute >> longName: anObject [
	longName := anObject
]

{ #category : #printing }
GTFSRoute >> printOn: aStream [
	super printOn: aStream.
	aStream
		nextPut: $(;
		nextPutAll: self routeId;
		space;
		nextPutAll: self shortName;
		space;
		nextPutAll: self longName;
		space;
		nextPutAll: self routeSymbol;
		nextPut: $)
]

{ #category : #accessing }
GTFSRoute >> routeId [
	^ routeId
]

{ #category : #accessing }
GTFSRoute >> routeId: anObject [
	routeId := anObject
]

{ #category : #icons }
GTFSRoute >> routeIdIcon [
	"return a Form with a rounded rectangle in color and the routeId in text color"

	| form font stringWidth width shift |
	shift := 8.
	font := StrikeFont
		familyName: #'Bitmap Source Sans Pro'
		size: 32
		emphasized: 1.
	stringWidth := font widthOfString: self shortName.
	width := stringWidth + 8 max: 32.
	form := Form extent: (width + shift) @ (32 + shift) depth: 32.
	MIVBIcon 
		drawRouteIdIconOn: form
		withText: self shortName
		color: (Color fromHexString: self color)
		textColor: (Color fromHexString: self textColor)
		font: font
		width: width
		stringWidth: stringWidth
		shift: shift.
	MIVBIcon 
	   drawSmallRouteTypeIconOn: form 
	   withText: self routeTypeIconText.
	    
	^ form
]

{ #category : #accessing }
GTFSRoute >> routeSymbol [
	"return the route symbol that is in routeType"

	^ RouteSymbols at: routeType
]

{ #category : #accessing }
GTFSRoute >> routeType [
	^ routeType
]

{ #category : #accessing }
GTFSRoute >> routeType: anObject [
	routeType := anObject
]

{ #category : #icons }
GTFSRoute >> routeTypeIcon [
	"return a Form with a rounded rectangle in routeTypeColor and the routeTypeLetter in text white"

  	| form |
	form := Form extent: 32 @ 32 depth: 32.
	MIVBIcon drawRouteTypeIconOn: form withText: self routeTypeIconText.
	^ form
]

{ #category : #icons }
GTFSRoute >> routeTypeIconText [
	"return the text to use in the routeTypeIcon"

			
	^ RouteText at: self routeType
]

{ #category : #accessing }
GTFSRoute >> shortName [
	^ shortName
]

{ #category : #accessing }
GTFSRoute >> shortName: anObject [
	shortName := anObject
]

{ #category : #accessing }
GTFSRoute >> textColor [
	^ textColor
]

{ #category : #accessing }
GTFSRoute >> textColor: anObject [
	textColor := anObject
]
