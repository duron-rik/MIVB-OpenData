"
I represent a default icon to show if not enough info is available to generate one


routeTypeIcon : default routeType
routeIdIcon : default routeId (shortName)
"
Class {
	#name : #MIVBIcon,
	#superclass : #Object,
	#category : #'MIVB-OpenData'
}

{ #category : #accessing }
MIVBIcon class >> color [
	"return the default color"

			
	^ Color red
]

{ #category : #icons }
MIVBIcon class >> drawRouteIdIconOn: aForm withText: aText color: aColor textColor: aTextColor font: aFont width: aWidth stringWidth: aStringWidth [
	"draw on aForm a rounded rectangle in color and aText in text color"

	^ self
		drawRouteIdIconOn: aForm
		withText: aText
		color: aColor
		textColor: aTextColor
		font: aFont
		width: aWidth
		stringWidth: aStringWidth
		shift: 0
]

{ #category : #icons }
MIVBIcon class >> drawRouteIdIconOn: aForm withText: aText color: aColor textColor: aTextColor font: aFont width: aWidth stringWidth: aStringWidth shift: aShift [
	"draw on aForm a rounded rectangle in color and aText in text color"

	| canvas vertices width height corner x size |
	width := aWidth.
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
	x := aShift + (width / 2 - (aStringWidth / 2) - 1) asInteger.
	canvas
		drawString: aText
		from: 1
		to: size
		at: x @ (aShift + 0)
		font: aFont
		color: aTextColor
]

{ #category : #icons }
MIVBIcon class >> drawRouteTypeIconOn: aForm withText: aText [
	"draw on aForm a rounded rectangle in red and the aText in text white."

	| canvas c width height x stringWidth font|
	width := 32.
	height := 32.
	c := Color red.
	canvas := FormCanvas on: aForm.
	canvas fillOval: 
         (Rectangle point: (0 @ 0) point: (width-1 @ height-1))
       color: c 
       borderWidth: 1 
       borderColor: c.
   font := StrikeFont
				familyName: #'Bitmap Source Sans Pro'
				size: height
				emphasized: 1.
	stringWidth := font widthOfString: aText.
	x := (((width / 2) - (stringWidth / 2))-1) asInteger.
	canvas
		drawString: aText
		from: 1
		to: 1
		at: x @ 0
		font: font
		color: Color white.
]

{ #category : #icons }
MIVBIcon class >> drawSmallRouteTypeIconOn: aForm withText: aText [
	"draw on aForm a small rounded rectangle in red and the aText in text white."

	| canvas c width height x stringWidth font|
	width := 16.
	height := 16.
	c := Color red.
	canvas := FormCanvas on: aForm.
	canvas fillOval: 
         (Rectangle point: (0 @ 0) point: (width-1 @ height-1))
       color: c 
       borderWidth: 1 
       borderColor: c.
   font := StrikeFont
				familyName: #'Bitmap Source Sans Pro'
				size: height
				emphasized: 1.
	stringWidth := font widthOfString: aText.
	x := (((width / 2) - (stringWidth / 2))-1) asInteger.
	canvas
		drawString: aText
		from: 1
		to: 1
		at: x @ 0
		font: font
		color: Color white.
]

{ #category : #icons }
MIVBIcon class >> routeIdIcon [
	"return a Form with a rounded rectangle in color and the routeId in text color"

	| form font stringWidth width |
	font := StrikeFont
		familyName: #'Bitmap Source Sans Pro'
		size: 32
		emphasized: 1.
	stringWidth := font widthOfString: self shortName.
	width := stringWidth + 8 max: 32.
	form := Form extent: width @ 32 depth: 32.
	self
		drawRouteIdIconOn: form
		withText: self shortName
		color: self color
		textColor: self textColor
		font: font
		width: width
		stringWidth: stringWidth.
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

{ #category : #accessing }
MIVBIcon class >> textColor [
	"return the default text color"

			
	^ Color white
]
