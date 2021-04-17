"
BaseLineOfMIVBOpenData defines the dependencies for the project MIVB-OpenData
"
Class {
	#name : #BaselineOfMIVBOpenData,
	#superclass : #Object,
	#category : #BaselineOfMIVBOpenData
}

{ #category : #baselines }
BaselineOfMIVBOpenData >> baseline: spec [
	<baseline>
	spec for: #common do: [ spec package: 'MIVB-OpenData' ]
]
