Class {
	#name : #TAModel,
	#superclass : #Object,
	#instVars : [
		'events'
	],
	#category : #'MemoryDumpAnalysis-TraceAnalysis'
}

{ #category : #'public - events' }
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
			ss third = '(nil)' 
				ifTrue: [ event := TAFree new ]
				ifFalse: [ event := TAFree new addressAsString: ss third ]
			
		].
		events add: event.
		event index: events size.
	].

	self bindMallocsAndFrees
	
	
]

{ #category : #private }
TAModel >> bindMallocsAndFrees [
	self frees do: [ :f |
		| m | 
		m := self mallocFromAddress: f address startingAtIndex: f index.
		m ifNotNil: [
			f correspondingMalloc: m.
			m correspondingFree: f ]
	]
]

{ #category : #visualizations }
TAModel >> description [
	| s |
	s := WriteStream on: String new.
	s nextPutAll: 'Summary:'.
	s cr.
	s nextPutAll: 'Number of events: '.
	s nextPutAll: self numberOfEvents asStringWithCommas.
	s cr.
	s nextPutAll: 'Number of mallocs: '.
	s nextPutAll: self numberOfMallocs asStringWithCommas.
	s cr.
	s nextPutAll: 'Number of frees: '.
	s nextPutAll: self numberOfFrees asStringWithCommas.
	s cr.
	
	s nextPutAll: 'Total malloc size: '.
	s nextPutAll: (self mallocs sum: #size) asStringWithCommas.
	s cr.
	
	s nextPutAll: 'Total free size: '.
	self frees isEmpty 
		ifTrue: [ s nextPutAll: '0' ]
		ifFalse: [ s nextPutAll: (self frees sum: #size) asStringWithCommas ].
	s cr.
	
	s nextPutAll: 'Total freed malloc size: '.
	s nextPutAll: ((self mallocs select: #isBound) sum: #size) asStringWithCommas.	
	s cr.

	s nextPutAll: 'Total non-freed malloc size: '.
	s nextPutAll: ((self mallocs reject: #isBound) sum: #size) asStringWithCommas.	
	s cr.

	^ s contents
]

{ #category : #'public - examples' }
TAModel >> example01 [
	<script: 'self new example01 inspect'>
	
	^ TAModel new addAsString: TAData new example01
]

{ #category : #'public - metrics' }
TAModel >> frees [
	^ events select: #isFree
]

{ #category : #visualizations }
TAModel >> gtInspectorSummaryIn: composite [
	<gtInspectorPresentationOrder: -10>
	composite text
		title: 'Summary';
		display: self description
]

{ #category : #visualizations }
TAModel >> gtInspectorViewIn: composite [
	<gtInspectorPresentationOrder: -10>
	composite roassal2
		title: 'View';
		initializeView: [ self produceView ]
]

{ #category : #initialization }
TAModel >> initialize [
	super initialize.
	events := OrderedCollection new
]

{ #category : #'public - events' }
TAModel >> mallocFromAddress: anAddress startingAtIndex: anIndex [
	^ (events first: anIndex) reversed detect: [ :e | e isMalloc and: [ e address = anAddress ] ] ifNone: [ nil ]
]

{ #category : #'public - metrics' }
TAModel >> mallocs [
	^ events select: #isMalloc
]

{ #category : #'accessing - computed' }
TAModel >> numberOfEvents [
	^ events size
]

{ #category : #'public - metrics' }
TAModel >> numberOfFrees [
	^ self frees size
]

{ #category : #'public - metrics' }
TAModel >> numberOfMallocs [
	^ self mallocs size
]

{ #category : #visualizations }
TAModel >> produceView [

	| v elements |
	v := RTView new.
	
	elements := RTBox new height: 40; color: [:m | Color random trans ]; elementsOn: self mallocs.
	v addAll: elements.
	elements @ RTPopup.
	
	RTMetricNormalizer new
		view: v;
		elements: elements;
		normalizeWidth: #size;
		normalizeTopLeftOfX: #address min: 0 max: 200
		"normalizeX: #address;
		normalizeColor: #index."
	.
	RTGridLayout on: elements.
	^ v
]
