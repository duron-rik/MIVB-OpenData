"
I represent the gtfs file downloader using the MIVB open api

Downloads will be stored using the format gtfs-yyyymmdd.zip in the current users download folderName 

The file if it exists will be removed first to ensure the download
"
Class {
	#name : #MIVBGtfs,
	#superclass : #Object,
	#classVars : [
		'DefaultDownloadDate',
		'Routes',
		'Stops',
		'Translations'
	],
	#category : #'MIVB-OpenData'
}

{ #category : #accessing }
MIVBGtfs class >> defaultDownloadDate: aDate [
	"set the default download date to used to find the default gtfs files"

			
	DefaultDownloadDate := aDate
]

{ #category : #'accessing - data' }
MIVBGtfs class >> defaultReference [
	"return the default MIVB GTFS file reference"

	^ (self fileLocatorOfDate: DefaultDownloadDate)
		asFileReference
]

{ #category : #'accessing - data' }
MIVBGtfs class >> defaultRoutes [
	"return the routes from the default reference"
	
	Routes ifNil: [ 
		Routes :=  self routesForReference: self defaultReference].

	^ Routes
]

{ #category : #'accessing - data' }
MIVBGtfs class >> defaultStops [
	"return the stops from the default reference"

	Stops
		ifNil: [ Stops := self stopsForReference: self defaultReference ].
	^ Stops
]

{ #category : #'accessing - data' }
MIVBGtfs class >> defaultTranslations [
	"return the translations from the default reference"
	
	Translations ifNil: [ 
		 Translations := self translationsForReference: self defaultReference].

	^ Translations
]

{ #category : #actions }
MIVBGtfs class >> download [
	"download the gtfs file from the mivb open api using the MIVBToken"

	^ self downloadWithSignal: false
]

{ #category : #actions }
MIVBGtfs class >> downloadWithFeedBack [
	"download the gtfs file with progress feedback"

	UIManager default
		informUserDuring: [ :bar | 
			bar label: 'Downloading mivb gtfs zip file ...'.
			[ ^ self downloadWithSignal: true ]
				on: HTTPProgress
				do: [ :progress | 
					bar label: progress printString.
					progress isEmpty
						ifFalse: [ bar current: progress percentage ].
					progress resume ] ]
]

{ #category : #actions }
MIVBGtfs class >> downloadWithSignal: aBoolean [
	"download the gtfs file from the mivb open api using the MIVBToken"

	[ self fileReference delete ]
		on: Error
		do: [].
	^ ZnClient new
		logToTranscript;
		signalProgress: aBoolean;
		url: 'https://opendata-api.stib-mivb.be/Files/2.0/Gtfs';
		headerAt: 'Authorization' put: 'Bearer ' , self token;
		headerAt: 'Accept' put: 'application/zip';
		downloadTo: self fileReference
]

{ #category : #accessing }
MIVBGtfs class >> fileLocator [
	"return the file locator to use to store the gtfs file"

	^ self fileLocatorOfTheDay 
]

{ #category : #accessing }
MIVBGtfs class >> fileLocatorOfDate: aDate [
	"return the file locator for the date"

	^ FileLocator downloads / 'gtfs' , aDate yyyymmdd , 'zip'
]

{ #category : #accessing }
MIVBGtfs class >> fileLocatorOfTheDay [
	"return the file locator for today"

	^ self fileLocatorOfDate: Date today
]

{ #category : #accessing }
MIVBGtfs class >> fileReference [
	"return the file reference to use to store the gtfs file"

	^ self fileLocator asFileReference
]

{ #category : #'class initialization' }
MIVBGtfs class >> initialize [
	"initialize the 3 dictionaries with default nil"

   Stops := nil.
   Routes := nil.
   Translations := nil.
   DefaultDownloadDate := Date today
]

{ #category : #actions }
MIVBGtfs class >> passingTimeByPoint: aStopId [
	"retrieve the passing through information related to the stop id"

	^ STONJSON
		fromString:
			(ZnClient new
				logToTranscript;
				url:
					'https://opendata-api.stib-mivb.be/OperationMonitoring/4.0/PassingTimeByPoint/'
						, aStopId ;
				headerAt: 'Authorization' put: 'Bearer ' , self token;
				headerAt: 'Accept' put: 'application/json';
				get)
]

{ #category : #actions }
MIVBGtfs class >> pointsByLine: aShortName [
	"retrieve the stops information related to the route short name"

	^ STONJSON
		fromString:
			(ZnClient new
				logToTranscript;
				url:
					'https://opendata-api.stib-mivb.be/NetworkDescription/1.0/PointByLine/'
						, aShortName;
				headerAt: 'Authorization' put: 'Bearer ' , self token;
				headerAt: 'Accept' put: 'application/json';
				get)
]

{ #category : #importing }
MIVBGtfs class >> routesForReference: aReference [
	"return a Dictionary with all routes in the GTFS file in aReference"

	| routes fs rs line split route |
	routes := OrderedDictionary new.
	fs := FileSystem
		zip: aReference.
	fs open.
	rs := (fs entryAt: 'routes.txt') readStream.
	rs nextLine.
	[ line := rs nextLine.
	line isNotNil
		ifTrue: [ split := line substrings: #($,).
			route := GTFSRoute from: split.
			routes at: (route routeId) put: route ] ]
		doWhileTrue: [ line isNotNil ].
	^ routes
]

{ #category : #importing }
MIVBGtfs class >> stopsForReference: aReference [
	"return a Dictionary with all stops in the GTFS file for aReference"

	| stops fs rs line split stop |
	stops := OrderedDictionary new.
	fs := FileSystem
		zip: aReference.
	fs open.
	rs := (fs entryAt: 'stops.txt') readStream.
	rs nextLine.
	[ line := rs nextLine. 
	line isNotNil
		ifTrue: [ split := line substrings: #($,).
			stop := GTFSStop from: split.
			stops at: (stop stopId) put: stop ] ]
		doWhileTrue: [ line isNotNil ].
	^ stops
]

{ #category : #accessing }
MIVBGtfs class >> token [
	"return a valid token from MIVBToken"

	^ MIVBToken token
]

{ #category : #importing }
MIVBGtfs class >> translationsForReference: aReference [
	"return a Dictionary with all translations in the GTFS file for aReference"

	| translations fs rs line split translation |
	translations := OrderedDictionary new.
	fs := FileSystem
		zip: aReference.
	fs open.
	rs := (fs entryAt: 'translations.txt') readStream.
	rs nextLine.
	[ line := rs nextLine.
	line isNotNil
		ifTrue: [ split := line substrings: #($,).
			translation := GTFSTranslation from: split.
			translations at: {(translation translationId). (translation language)} put: translation ] ]
		doWhileTrue: [ line isNotNil ].
	^ translations
]
