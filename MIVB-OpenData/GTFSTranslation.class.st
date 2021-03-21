"
I represent a GTFS Translation

The data is retrieved from translations.txt in the GTFS file retrieved from the MIVB Open Data api 

mapping

<- translations.txt

trans_id,translation,lang
STIB,STIB,fr
STIB,MIVB,nl
http://www.stib-mivb.be,http://www.stib-mivb.be/index.htm?l=fr,fr
http://www.stib-mivb.be,http://www.stib-mivb.be/index.htm?l=nl,nl
ABBAYE,Abbaye,fr
ABBAYE,Abdij,nl
ACACIAS,Acacias,fr
ACACIAS,Acacia,nl
...

-> GTFSTranslation 

routeId : '1'
shortName : '1'
longName : 'GARE DE L'OUEST - STOCKEL'
routeType : '1'
color : 'C4008F'
textColor : 'FFFFFF'

"
Class {
	#name : #GTFSTranslation,
	#superclass : #Object,
	#instVars : [
		'translationId',
		'language',
		'translation'
	],
	#category : #'MIVB-OpenData'
}

{ #category : #'instance creation' }
GTFSTranslation class >> from: anArray [
	"return a translation based on the array returned from the translations.txt csv file"

	^ self new
		translationId: (anArray at: 1);
		translation: (anArray at: 2);
		language: (anArray at: 3)

]

{ #category : #navigation }
GTFSTranslation class >> translationsFor: aKey [
	"return the GTFSTranslations for aKey"

	^ self translationsIn: (MIVBGtfs defaultTranslations) for: aKey asUncommentedCode 
]

{ #category : #navigation }
GTFSTranslation class >> translationsIn: aGTFSTranslationDictionary for: aKey [
	"return the GTFSTranslations for aKey"

	| translations |
	translations := OrderedDictionary new.
	aGTFSTranslationDictionary
		keysAndValuesDo: [ :aTranslationId :aGTFSTranslation | 
			aGTFSTranslation translationId = aKey
				ifTrue: [ translations at: aTranslationId put: aGTFSTranslation ] ].
	^ translations
]

{ #category : #accessing }
GTFSTranslation >> language [
	^ language
]

{ #category : #accessing }
GTFSTranslation >> language: anObject [
	language := anObject
]

{ #category : #printing }
GTFSTranslation >> printOn: aStream [
	super printOn: aStream.
	aStream
		nextPut: $(;
		nextPutAll: self translationId;
		space;
		nextPutAll: self language;
		space;
		nextPutAll: self translation;
		nextPut: $)
]

{ #category : #accessing }
GTFSTranslation >> translation [
	^ translation
]

{ #category : #accessing }
GTFSTranslation >> translation: anObject [
	translation := anObject
]

{ #category : #accessing }
GTFSTranslation >> translationId [
	^ translationId
]

{ #category : #accessing }
GTFSTranslation >> translationId: anObject [
	translationId := anObject
]
