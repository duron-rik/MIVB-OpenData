"
I represent a passing time for a stopId
"
Class {
	#name : #GTFSPassingTimes,
	#superclass : #Object,
	#instVars : [
		'pointId',
		'destination',
		'lineId',
		'expectedArrival',
		'message',
		'route'
	],
	#category : #'MIVB-OpenData'
}

{ #category : #'instance creation' }
GTFSPassingTimes class >> forStop: aStopId [
	"return the PassingTimes for aStopId"
	
	^ self fromPoints: (MIVBGtfs passingTimeByPoint: aStopId).
	
	

]

{ #category : #'instance creation' }
GTFSPassingTimes class >> fromPassingTime: aDict at: aPointId [
	"return a GTFSPassingTime from the data returned from MIVBGtfs passingTimeByPoint"

	| res |
	res := self new
		pointId: aPointId;
		destination: (aDict at: 'destination' ifAbsent: [ nil ]);
		lineId: (aDict at: 'lineId');
		expectedArrival: (aDict at: 'expectedArrivalTime' ifAbsent: [ '' ]);
		message: (aDict at: 'message' ifAbsent: [ nil ]).
	res initialize.
	^ res
]

{ #category : #'instance creation' }
GTFSPassingTimes class >> fromPassingTimes: aDict [
	"return a GTFSPassingTime array from the data returned from MIVBGtfs passingTimeByPoint"
		
	^ (aDict at: 'passingTimes') collect: [ :aPassingTimeDict | 
		  self fromPassingTime: aPassingTimeDict at: (aDict at: 'pointId')
		 ].

]

{ #category : #'instance creation' }
GTFSPassingTimes class >> fromPoints: aPointsDict [
	"return a GTFSPassingTime array from the data returned from MIVBGtfs passingTimeByPoint"

	^ (aPointsDict at: 'points')
		collect:
			[ :aPassingTimesDict | self fromPassingTimes: aPassingTimesDict ]
]

{ #category : #accessing }
GTFSPassingTimes >> destination [
	^ destination
]

{ #category : #accessing }
GTFSPassingTimes >> destination: anObject [
	destination := anObject
]

{ #category : #accessing }
GTFSPassingTimes >> expectedArrival [
	^ expectedArrival
]

{ #category : #accessing }
GTFSPassingTimes >> expectedArrival: anObject [
	expectedArrival := anObject
]

{ #category : #printing }
GTFSPassingTimes >> expectedArrivalString [
	"return the expected arrival in number of minutes if available"

	self expectedArrival isEmpty
		ifFalse: [ ^ (DateAndTime now to:
				(DateAndTime fromString: self expectedArrival)) asDuration minutes
					asString , ' min' ].
	^ 'N/A'
]

{ #category : #'gt-inspector-extension' }
GTFSPassingTimes >> gtInspectorRouteIn: composite [
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

{ #category : #initialization }
GTFSPassingTimes >> initialize [
	"initialize route"

   super initialize.
   self route: (GTFSRoute fromShortName: self lineId)
]

{ #category : #accessing }
GTFSPassingTimes >> lineId [
	^ lineId
]

{ #category : #accessing }
GTFSPassingTimes >> lineId: anObject [
	lineId := anObject
]

{ #category : #accessing }
GTFSPassingTimes >> message [
	^ message
]

{ #category : #accessing }
GTFSPassingTimes >> message: anObject [
	message := anObject
]

{ #category : #accessing }
GTFSPassingTimes >> pointId [
	^ pointId
]

{ #category : #accessing }
GTFSPassingTimes >> pointId: anObject [
	pointId := anObject
]

{ #category : #printing }
GTFSPassingTimes >> printOn: aStream [
	super printOn: aStream.
	aStream
		nextPut: $(;
		nextPutAll: self lineId;
		space;
		nextPutAll: self pointId.
	self destination
		ifNotNil: [ aStream
				space;
				nextPutAll: (self destination at: 'nl');
				space;
				nextPutAll: (self destination at: 'fr') ].
	aStream
		space;
		nextPutAll: self expectedArrivalString.
	self message
		ifNotNil: [ aStream
				space;
				nextPutAll: (self message at: 'nl');
				space;
				nextPutAll: (self message at: 'fr') ].
	aStream nextPut: $)
]

{ #category : #accessing }
GTFSPassingTimes >> route [
	"return the route corresponding to lineId"

	route ifNil: [ self route: (GTFSRoute fromShortName: self lineId) ].
	^ route
]

{ #category : #accessing }
GTFSPassingTimes >> route: anObject [
	route := anObject
]

{ #category : #icons }
GTFSPassingTimes >> routeIdIcon [
	"return the routeId icon from the route"

   ^ self route routeIdIcon 
]

{ #category : #icons }
GTFSPassingTimes >> routeTypeIcon [
	"return the routeType icon from the route"

	^ self route routeTypeIcon
]
