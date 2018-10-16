Class {
	#name : #MemoryDumpAnalysis,
	#superclass : #Object,
	#instVars : [
		'index',
		'label',
		'view',
		'file',
		'readStream',
		'bitmap',
		'extent'
	],
	#category : #MemoryDumpAnalysis
}

{ #category : #'instance creation' }
MemoryDumpAnalysis >> decreaseIndex [
	index := index - self step.
	index <= 0 ifTrue: [ index := 0 ].
	self updatePosition.
	self updateLabel.
	self updateBitmap
]

{ #category : #'instance creation' }
MemoryDumpAnalysis >> getFormFor: extent [
	| result newBitmap |
	result := Form extent: extent depth: 32.
	newBitmap := Bitmap new: result bits size.
	
	1 to: newBitmap size do: [ :in |
		newBitmap at: in put: self valueFromStream.
	].
	
"	newBitmap atAllPut: (16rFF * 256 * 256 * 256) + (16rFF * 256).
"	
	
"	1 to: newBitmap size do: [ :in |
		newBitmap at: in put: ((16rFF * 256 * 256 * 256) + (255 atRandom * 256 * 256)).
	].
	"
	result bits: newBitmap.
	^ result
]

{ #category : #'instance creation' }
MemoryDumpAnalysis >> increaseIndex [
	index := index + self step.
	self updatePosition.
	self updateLabel.
	self updateBitmap
]

{ #category : #'instance creation' }
MemoryDumpAnalysis >> initialize [
	super initialize.
	index := 0. 
]

{ #category : #'instance creation' }
MemoryDumpAnalysis >> open [
	<script: 'self new open'>
	"Example to generate a dump:
	gcore -o ~/Desktop/finder.txt 2287
	"
	file := '/Users/alexandrebergel/Desktop/finder.txt' asFileReference.
	readStream := file binaryReadStream.
	
	view := RTView new.
	extent := 800 @ 500.
	view addMenu: '<<' callback: [ self decreaseIndex ].
	view addMenu: '>>' callback: [ self increaseIndex ].
	bitmap := RTBitmap new
		form: #yourself;
		elementOn: (self getFormFor: extent).
	view add: bitmap.
	label := RTLabel new elementOn: 10.
	view add: label.
	TRConstraint move: label onTheLeftOf: bitmap.
	view inspect
]

{ #category : #'instance creation' }
MemoryDumpAnalysis >> step [
	^ extent x * 3 * 30
]

{ #category : #'instance creation' }
MemoryDumpAnalysis >> updateBitmap [
	bitmap trachelShape form: (self getFormFor: extent)
]

{ #category : #'instance creation' }
MemoryDumpAnalysis >> updateLabel [
	label trachelShape text: index asString.
	view signalUpdate
]

{ #category : #'instance creation' }
MemoryDumpAnalysis >> updatePosition [
	readStream position: index
]

{ #category : #'instance creation' }
MemoryDumpAnalysis >> valueFromStream [	
	^ 16rFF * 256 * 256 * 256 + (readStream uint8 * 256 * 256) + (readStream uint8 * 256) + (readStream uint8)
]
