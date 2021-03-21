"
I represent a GTFS Stop

The data is retrieved from stops.txt in the GTFS file retrieved from the MIVB Open Data api 

mapping

<- stops.txt

stop_id,stop_code,stop_name,stop_desc,stop_lat,stop_lon,zone_id,stop_url,location_type,parent_station
0089,,""MONTGOMERY"",,  50.838006,   4.408970,,,0,13

-> GTFSStop 

stopId : '0089'
name : 'MONTGOMERY'
stopType : '0'
parentId : '13'

"
Class {
	#name : #GTFSStop,
	#superclass : #Object,
	#instVars : [
		'stopId',
		'name',
		'stopType',
		'parentId'
	],
	#classVars : [
		'StopSymbols'
	],
	#category : #'MIVB-OpenData'
}

{ #category : #'instance creation' }
GTFSStop class >> from: anArray [
	"return a route based on the array returned from the routes.txt csv file"

	anArray size < 6
		ifTrue: [ ^ self new
				stopId: (anArray at: 1);
				name: (anArray at: 2);
				stopType: (anArray at: 5)].
	^ self new
		stopId: (anArray at: 1);
		name: (anArray at: 2);
		stopType: (anArray at: 5);
		parentId: (anArray at: 6)
]

{ #category : #'class initialization' }
GTFSStop class >> initialize [
	"initialize the class variables"

	StopSymbols := Dictionary
		newFrom:
			{('0' -> #StopOrPlatform).
			('1' -> #Station).
			('2' -> #StationEntryOrExit).
			('3' -> #GenericNode).
			('4' -> #BoardingArea)}
]

{ #category : #navigation }
GTFSStop >> children [
	"return the GTFSStops that have a parentId pointing to my stopId using the default stops"

	^ self childrenIn: MIVBGtfs defaultStops 
]

{ #category : #navigation }
GTFSStop >> childrenIn: aGTFSStopDictionary [
	"return the GTFSStops that have a parentId pointing to my stopId"

	| children |
	children := OrderedDictionary new.
	aGTFSStopDictionary
		keysAndValuesDo: [ :aStopId :aGTFSStop | 
			aGTFSStop parentId = self stopId
				ifTrue: [ children at: aStopId put: aGTFSStop ] ].
	^ children
]

{ #category : #'gt-inspector-extension' }
GTFSStop >> gtInspectorChildrenIn: composite [
    <gtInspectorPresentationOrder: 40>
    <gtInspectorTag: #basic> 
 
    composite list
      title: 'Children';
      display: [ self children ];
      when: [ self children notEmpty ]
]

{ #category : #'gt-inspector-extension' }
GTFSStop >> gtInspectorDetailsIn: composite [
	<gtInspectorPresentationOrder: 30>
	^ composite table
		title: 'Details';
		display: [ 
					{'stopId' -> self stopId.
					'name' -> self name.
					'stopType' -> self stopType.
					'stopSymbol' -> self stopSymbol.
					'parentId' -> self parentId.
					'parent' -> self parent } ];
		column: 'Key' evaluated: #key;
		column: 'Value' evaluated: #value;
		send: #value
]

{ #category : #'gt-inspector-extension' }
GTFSStop >> gtInspectorPassingTimesIn: composite [
	<gtInspectorPresentationOrder: 50>
	<gtInspectorTag: #basic>
	composite list
		title: 'PassingTimes';
		display: [ self passingTimes ];
		icon:
				[ :each | each ifNotNil: [ each routeIdIcon ] ifNil: [ MIVBIcon routeIdIcon ] ]
]

{ #category : #'gt-inspector-extension' }
GTFSStop >> gtInspectorTranslationsIn: composite [
    <gtInspectorPresentationOrder: 60>
    <gtInspectorTag: #basic> 
 
    composite list
      title: 'Translations';
      display: [ GTFSTranslation translationsFor: self name ].
]

{ #category : #accessing }
GTFSStop >> name [
	^ name
]

{ #category : #accessing }
GTFSStop >> name: anObject [
	name := anObject
]

{ #category : #navigation }
GTFSStop >> parent [
	"return the parent stop from the default Stops using parentId"

    self parentId ifNotNil: [  
       ^ MIVBGtfs defaultStops at: self parentId].
    ^ nil
	
]

{ #category : #accessing }
GTFSStop >> parentId [
	^ parentId
]

{ #category : #accessing }
GTFSStop >> parentId: anObject [
	parentId := anObject
]

{ #category : #navigation }
GTFSStop >> passingTimes [
	"return the passingTimes for this stop"

   | res | 
   res := GTFSPassingTimes forStop: self stopId.
   res isEmpty ifFalse: [ 
	  ^ res first ].
   ^ nil



]

{ #category : #printing }
GTFSStop >> printOn: aStream [
	super printOn: aStream.
	aStream
		nextPut: $(;
		nextPutAll: self stopId;
		space;
		nextPutAll: self name;
		space;
		nextPutAll: self stopSymbol.
	self parentId ifNotNil: [  
		aStream space;
		nextPutAll: self parentId.
	].
	aStream nextPut: $).
]

{ #category : #accessing }
GTFSStop >> stopId [
	^ stopId
]

{ #category : #accessing }
GTFSStop >> stopId: anObject [
	stopId := anObject
]

{ #category : #accessing }
GTFSStop >> stopSymbol [
	"return the stop symbol that is in the stopType"

	^ StopSymbols at: stopType
]

{ #category : #accessing }
GTFSStop >> stopType [
	^ stopType
]

{ #category : #accessing }
GTFSStop >> stopType: anObject [
	stopType := anObject
]
