"
I display and allow edition of dependencies of the provided ongoingPackageVersion.
"
Class {
	#name : #CGOPackageDependenciesView,
	#superclass : #CGOPackageListEditor,
	#category : 'CargoPackageManager-UI'
}

{ #category : #example }
CGOPackageDependenciesView class >> example [
	^ self openOn: (CGOOngoingPackageUnit example)
]

{ #category : #actions }
CGOPackageDependenciesView >> addAction [
	
	CGONewDependencyDialog new 
		openDialogOnAccept: [ :dependency |
			ongoingPackageVersion addDependency: dependency.
			self refreshUI ]
		onCancel: [ "Nothing" ]
]

{ #category : #configuration }
CGOPackageDependenciesView >> addButtonHelpString [
	^ 'Add a new dependency'
]

{ #category : #'private - building' }
CGOPackageDependenciesView >> buildRoots [
	
	^ ongoingPackageVersion dependencies
]

{ #category : #actions }
CGOPackageDependenciesView >> editAction [
	"only one fixed constraint managed for now"
	| dependency versionString |
	dependency := self selectedPackage.
	dependency newEditPanel
		openDialogOnAccept: [ :modifiedDependency |
			self refreshUI ]
		onCancel: [  ]
]

{ #category : #configuration }
CGOPackageDependenciesView >> editButtonHelpString [
	^ 'Edit the dependency'
]

{ #category : #configuration }
CGOPackageDependenciesView >> packageListEditorLabel [
	^ 'Dependencies:'
]

{ #category : #actions }
CGOPackageDependenciesView >> removeAction: aCGOPackageDependency [ 
	ongoingPackageVersion removeDependency: aCGOPackageDependency
]

{ #category : #configuration }
CGOPackageDependenciesView >> removeButtonHelpString [
	^ 'Remove the dependency'
]
