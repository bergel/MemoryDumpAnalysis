Class {
	#name : #MemoryDumpAnalysis,
	#superclass : #Object,
	#instVars : [
		'index',
		'label',
		'view',
		'file',
		'readStream'
	],
	#category : #MemoryDumpAnalysis
}

{ #category : #'instance creation' }
MemoryDumpAnalysis >> decreaseIndex [
	index := index - 10.
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
	index := index + 10.
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
	| extent aForm b |
	file := '/Users/alexandrebergel/Desktop/Yang_nature_book_part.pdf' asFileReference.
	readStream := file binaryReadStream.
	
	view := RTView new.
	extent := 300 @ 300.
	view addMenu: '<<' callback: [ self decreaseIndex ].
	view addMenu: '>>' callback: [ self increaseIndex ].
	aForm := self getFormFor: extent.
	b := RTBitmap new
		form: aForm;
		element.
	view add: b.
	label := RTLabel new elementOn: 10.
	view add: label.
	TRConstraint move: label onTheLeftOf: b.
	view inspect
]

{ #category : #'instance creation' }
MemoryDumpAnalysis >> updateBitmap [
	
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
	| result |
	result := readStream nextInt32.
	^ 16rFF * 256 * 256 * 256 + result
]
