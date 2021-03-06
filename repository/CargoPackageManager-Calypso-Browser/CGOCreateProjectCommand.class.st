"
Calypso command providing a contextual menu to create a new (empty) Cargo project
"
Class {
	#name : #CGOCreateProjectCommand,
	#superclass : #CGOClyCommand,
	#instVars : [
		'projectName'
	],
	#category : 'CargoPackageManager-Calypso-Browser-CargoPackageManager-Calypso-Browser'
}

{ #category : #accessing }
CGOCreateProjectCommand class >> canBeExecutedInContext: aToolContext [

	^ aToolContext isProjectSelected not
]

{ #category : #accessing }
CGOCreateProjectCommand class >> defaultMenuIconName [
	^#configNew
]

{ #category : #activation }
CGOCreateProjectCommand class >> systemBrowserMenuActivator [
	<classAnnotation>
	
	^ CmdContextMenuActivation byRootGroupItemFor: ClyProjectContextOfFullBrowser
]

{ #category : #activation }
CGOCreateProjectCommand class >> systemBrowserShortcutActivator [
	<classAnnotation>
	
	^ CmdShortcutActivation by: $n meta, $p meta for: ClyProjectContextOfFullBrowser
]

{ #category : #activation }
CGOCreateProjectCommand class >> systemBrowserToolbarActivator [
	<classAnnotation>
	^ ClyToolbarCommandActivation
		byItemOf: ClyButtonToolbarGroup
		for: ClyProjectContextOfFullBrowser
]

{ #category : #execution }
CGOCreateProjectCommand >> applyResultInContext: aToolContext [
	self refreshCalypsoRoot
]

{ #category : #initialization }
CGOCreateProjectCommand >> defaultMenuItemName [
	^ 'New project'
]

{ #category : #execution }
CGOCreateProjectCommand >> execute [
	packageManager createProjectNamed: projectName
]

{ #category : #execution }
CGOCreateProjectCommand >> prepareFullExecutionInContext: aToolContext [
	super prepareFullExecutionInContext: aToolContext.
	
	projectName := UIManager default 
		request: 'Project name' 
		initialAnswer: ''.
	projectName isEmptyOrNil ifTrue: [ CmdCommandAborted signal ].
]
