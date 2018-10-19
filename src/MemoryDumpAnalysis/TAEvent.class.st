Class {
	#name : #TAEvent,
	#superclass : #Object,
	#instVars : [
		'index',
		'address',
		'addressAsString'
	],
	#category : #'MemoryDumpAnalysis-TraceAnalysis'
}

{ #category : #accessing }
TAEvent >> address [
	^ address
]

{ #category : #accessing }
TAEvent >> address: anInteger [
	address := anInteger
]

{ #category : #accessing }
TAEvent >> addressAsString [
	^ addressAsString
]

{ #category : #accessing }
TAEvent >> addressAsString: aString [
	addressAsString := aString.
	self address: (Number readFrom: (aString copyFrom: 3 to: aString size) base: 16)
]

{ #category : #accessing }
TAEvent >> index [
	^ index
]

{ #category : #accessing }
TAEvent >> index: anObject [
	index := anObject
]

{ #category : #'public - testing' }
TAEvent >> isFree [
	^ false
]

{ #category : #'public - testing' }
TAEvent >> isMalloc [
	^ false
]
