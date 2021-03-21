"
I represent the stops in one direction for a GTFSRoute.

direction is either 'Suburb' or 'City'
destination is a dictionary with key 'nl' and 'fr' with the text used to indicate the direction of the route in Dutch or French
lineId is the line indicator of the route 
points is the collection of stops in the order of the itinary


"
Class {
	#name : #GTFSLineStops,
	#superclass : #Object,
	#instVars : [
		'destination',
		'direction',
		'lineId',
		'points',
		'route'
	],
	#category : #'MIVB-OpenData'
}

{ #category : #'instance creation' }
GTFSLineStops class >> forRoute: aRouteShortName [
	"return the GTFSLineStops in both directions for aRouteShortName"

	^ self fromLines: (MIVBGtfs pointsByLine: aRouteShortName)
]

{ #category : #'instance creation' }
GTFSLineStops class >> fromDestinations: aDict [
	"return a GTFSLineStop with data returned from MIVBGtfs pointsByLine"
	
	| res |

	res := self new
		destination: (aDict at: 'destination');
		direction: (aDict at: 'direction');
		lineId: (aDict at: 'lineId');
		points:
			((aDict at: 'points')
				collect: [ :p | MIVBGtfs defaultStops at: (p at: 'id') ifAbsent: [ nil ] ]).
	res initialize.
	^ res
]

{ #category : #'instance creation' }
GTFSLineStops class >> fromLines: aLinesDict [
	"return a GTFSLineStop array with the lines data returned from MIVBGtfs pointsByLine"

	^ (aLinesDict at: 'lines')
		collect: [ :aDestinationDict | self fromDestinations: aDestinationDict ]
]

{ #category : #accessing }
GTFSLineStops >> destination [
	^ destination
]

{ #category : #accessing }
GTFSLineStops >> destination: anObject [
	destination := anObject
]

{ #category : #accessing }
GTFSLineStops >> direction [
	^ direction
]

{ #category : #accessing }
GTFSLineStops >> direction: anObject [
	direction := anObject
]

{ #category : #'gt-inspector-extension' }
GTFSLineStops >> gtInspectorRouteIn: composite [
	<gtInspectorPresentationOrder: 30>
	^ composite table
		title: 'Route';
		display: [ 
					{'routeId' -> self route routeId.
					'shortName' -> self route shortName.
					'longName' -> self route longName.
					'routeType' -> self route routeType.
					'routeSymbol' -> self route routeSymbol.
					'textColor' -> self route textColor.
					'color' -> self route color.
					'routeIdIcon' -> self routeIdIcon.
					'routeTypeIcon' -> self routeTypeIcon } ];
		column: 'Key' evaluated: #key;
		column: 'Value' evaluated: #value;
		send: #value
]

{ #category : #'gt-inspector-extension' }
GTFSLineStops >> gtInspectorStopsIn: composite [
    <gtInspectorPresentationOrder: 40>
    <gtInspectorTag: #basic> 
 
    composite list
      title: 'Stops';
      display: [ self points ];
      icon: [ self routeTypeIcon  ]
   
]

{ #category : #initialization }
GTFSLineStops >> initialize [
	"initialize route"

   super initialize.
   self route: (GTFSRoute fromShortName: self lineId)
]

{ #category : #accessing }
GTFSLineStops >> lineId [
	^ lineId
]

{ #category : #accessing }
GTFSLineStops >> lineId: anObject [
	lineId := anObject
]

{ #category : #accessing }
GTFSLineStops >> points [
	^ points
]

{ #category : #accessing }
GTFSLineStops >> points: anObject [
	points := anObject
]

{ #category : #printing }
GTFSLineStops >> printOn: aStream [
	super printOn: aStream.
	aStream
		nextPut: $(;
		nextPutAll: self lineId;
		space;
		nextPutAll: self direction;
		space;
		nextPutAll: (self destination at: 'nl');
		space;
      nextPutAll: (self destination at: 'fr');
		nextPut: $)
]

{ #category : #accessing }
GTFSLineStops >> route [
	"return the route corresponding to lineId"

	route ifNil: [ self route: (GTFSRoute fromShortName: self lineId) ].
	^ route
]

{ #category : #accessing }
GTFSLineStops >> route: anObject [
	route := anObject
]

{ #category : #icons }
GTFSLineStops >> routeIdIcon [
	"return the routeId icon from the route"

   ^ self route routeIdIcon 
]

{ #category : #icons }
GTFSLineStops >> routeTypeIcon [
	"return the routeType icon from the route"

   ^ self route routeTypeIcon 
]
