"
I represent a default icon to show if not enough info is available to generate one


routeTypeIcon : default routeType
routeIdIcon : default routeId (shortName)
"
Class {
	#name : #MIVBIcon,
	#superclass : #Object,
	#classVars : [
		'IconFont',
		'SmallIconFont'
	],
	#category : #'MIVB-OpenData'
}

{ #category : #accessing }
MIVBIcon class >> color [
	"return the default color"

			
	^ Color red
]

{ #category : #icons }
MIVBIcon class >> drawRouteIdIconOn: aForm withText: aText color: aColor textColor: aTextColor [
	"draw on aForm a rounded rectangle in color and aText in text color"

	^ self
		drawRouteIdIconOn: aForm
		withText: aText
		color: aColor
		textColor: aTextColor
		shift: 0
]

{ #category : #icons }
MIVBIcon class >> drawRouteIdIconOn: aForm withText: aText color: aColor textColor: aTextColor shift: aShift [
	"draw on aForm a rounded rectangle in color and aText in text color"

	| canvas vertices width height corner x size |
	width := self widthFor: aText.
	height := 32.
	size := aText size.
	corner := 3.
	vertices := {((aShift + corner) @ (aShift + 0)).
	((aShift + 0) @ (aShift + corner)).
	((aShift + 0) @ (aShift + height - corner - 1)).
	((aShift + corner) @ (aShift + height - 1)).
	((aShift + width - corner - 1) @ (aShift + height - 1)).
	((aShift + width - 1) @ (aShift + height - corner - 1)).
	((aShift + width - 1) @ (aShift + corner)).
	((aShift + width - corner - 1) @ (aShift + 0))}.
	canvas := FormCanvas on: aForm.
	canvas
		drawPolygon: vertices
		color: aColor
		borderWidth: 1
		borderColor: aColor.
	x := aShift + (width / 2 - ((self stringWidthFor: aText) / 2) - 1) asInteger.
	canvas
		drawString: aText
		from: 1
		to: size
		at: x @ (aShift + 0)
		font: IconFont 
		color: aTextColor
]

{ #category : #icons }
MIVBIcon class >> drawRouteTypeIconOn: aForm withText: aText [
	"draw on aForm a rounded rectangle in red and the aText in text white."

	| canvas c width height x  |
	width := 32.
	height := 32.
	c := Color red.
	canvas := FormCanvas on: aForm.
	canvas fillOval: 
         (Rectangle point: (0 @ 0) point: (width-1 @ height-1))
       color: c 
       borderWidth: 1 
       borderColor: c.
	x := (((width / 2) - ((self stringWidthFor: aText) / 2))-1) asInteger.
	canvas
		drawString: aText
		from: 1
		to: 1
		at: x @ 0
		font: IconFont
		color: Color white.
]

{ #category : #icons }
MIVBIcon class >> drawSmallRouteTypeIconOn: aForm withText: aText [
	"draw on aForm a small rounded rectangle in red and the aText in text white."

	| canvas c width height x |
	width := 16.
	height := 16.
	c := Color red.
	canvas := FormCanvas on: aForm.
	canvas fillOval: 
         (Rectangle point: (0 @ 0) point: (width-1 @ height-1))
       color: c 
       borderWidth: 1 
       borderColor: c.
	x := (((width / 2) - ((self smallStringWidthFor: aText) / 2))-1) asInteger.
	canvas
		drawString: aText
		from: 1
		to: 1
		at: x @ 0
		font: SmallIconFont 
		color: Color white.
]

{ #category : #'class initialization' }
MIVBIcon class >> initialize [
	"initialize the fonts"

	IconFont := StrikeFont
		familyName: #'Bitmap Source Sans Pro'
		size: 32
		emphasized: 1.
	SmallIconFont := StrikeFont
		familyName: #'Bitmap Source Sans Pro'
		size: 16
		emphasized: 1
]

{ #category : #icons }
MIVBIcon class >> routeIdIcon [
	"return a Form with a rounded rectangle in color and the routeId in text color"

	| form |

	form := Form extent: self width @ 32 depth: 32.
	self
		drawRouteIdIconOn: form
		withText: self shortName
		color: self color
		textColor: self textColor.
	^ form
]

{ #category : #icons }
MIVBIcon class >> routeTypeIcon [
	"return a Form with a rounded rectangle in red and the routeTypeIconText in text white"

	| form |
	form := Form extent: 32 @ 32 depth: 32.
	self drawRouteTypeIconOn: form withText: self routeTypeIconText.
	^ form
]

{ #category : #icons }
MIVBIcon class >> routeTypeIconText [
	"return the default routeTypeIconText"

   ^ '?'
]

{ #category : #accessing }
MIVBIcon class >> shortName [
	"return the default shortName"

			
	^ '?'
]

{ #category : #icons }
MIVBIcon class >> smallStringWidthFor: aText [
   "return the string width for aText in the small routeIdIcon"

   ^ SmallIconFont widthOfString: aText.

   
]

{ #category : #icons }
MIVBIcon class >> stringWidthFor: aText [
   "return the string width for aText in the routeIdIcon"

   ^ IconFont widthOfString: aText.

   
]

{ #category : #accessing }
MIVBIcon class >> textColor [
	"return the default text color"

	^ Color white
]

{ #category : #accessing }
MIVBIcon class >> width [ 
	"return the width of the routeIdIcon"
	
   ^ self widthFor: (self shortName)
]

{ #category : #accessing }
MIVBIcon class >> widthFor: aText [
	"return the width of the routeIdIcon"

	^ (self stringWidthFor: aText) + 8 max: 32
]
