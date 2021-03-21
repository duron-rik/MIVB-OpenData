"
I represent the token fetcher for the mivb open api 
"
Class {
	#name : #MIVBToken,
	#superclass : #Object,
	#category : #'MIVB-OpenData'
}

{ #category : #accessing }
MIVBToken class >> authorization [
	"return the authorization key and secret in the required format"

	^ 'Basic '
		,
			(ZnBase64Encoder new
				encode: (self key , ':' , self secret) asByteArray)
]

{ #category : #actions }
MIVBToken class >> fetchToken [
	"retrieve a new token from the mivb open api to use in the api calls for authorization"

	^ STONJSON
		fromString:
			(ZnClient new
			   logToTranscript;
			   beOneShot;
				url: 'https://opendata-api.stib-mivb.be/token';
				formAt: 'grant_type' put: 'client_credentials';
				headerAt: 'Authorization' put: self authorization;
				post)
]

{ #category : #accessing }
MIVBToken class >> key [
	"return the key obtained from the OSEnvironment in order to fetch the token"

	^ OSEnvironment current at: 'MIVB_OPENDATA_KEY'
]

{ #category : #accessing }
MIVBToken class >> secret [
	"return the secret from the OSEnvironment in order to fetch the token"

	^ OSEnvironment current at: 'MIVB_OPENDATA_SECRET'
]

{ #category : #accessing }
MIVBToken class >> token [
	"return a newly fetched token from the MIVB open api token end point"

	^ self fetchToken at: 'access_token'
]
