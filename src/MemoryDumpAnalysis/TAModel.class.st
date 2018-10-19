Class {
	#name : #TAModel,
	#superclass : #Object,
	#instVars : [
		'events'
	],
	#category : #'MemoryDumpAnalysis-TraceAnalysis'
}

{ #category : #'public - adding events' }
TAModel >> addAsString: aString [
	| lines ss event |
	lines := aString lines.
	lines do: [ :l |
		ss := l substrings.
 "#('[MEM]' 'malloc(72704):' '0x55f086ef9260')"	
 "#('[MEM]' 'free:' '0x55f086f0b280')"
		(ss second beginsWith: 'malloc') ifTrue: [ 
			| mallocSize mallocAddress |
			mallocSize := (ss second substrings: '()') second asInteger.
			mallocAddress := ss third.
			event := TAMalloc new size: mallocSize; addressAsString: mallocAddress ].
		(ss second beginsWith: 'free') ifTrue: [
			event := TAFree new addressAsString: ss third.
		].
		events add: event
	].
	
	
]

{ #category : #initialization }
TAModel >> initialize [
	super initialize.
	events := OrderedCollection new
]

{ #category : #'accessing - computed' }
TAModel >> numberOfEvents [
	^ events size
]

{ #category : #'public - metrics' }
TAModel >> numberOfFrees [
	^ (events select: #isFree) size
]

{ #category : #'public - metrics' }
TAModel >> numberOfMallocs [
	^ (events select: #isMalloc) size
]
