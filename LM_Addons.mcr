macroScript SEDeleteHierarchy
	category:"Scene Explorer" 
	internalCategory: "Scene Explorer" --LOC_NOTES: do not localize this
	toolTip: "Delete Hierarchy" --LOC_NOTES: localize this
	ButtonText: "Delete Hierarchy" --LOC_NOTES: localize this
(	
	fn IsLayer item = ( classof item == Base_LayerBase_Layer)
	
	on isVisible do	
	(
		local sceneExplorerInstance = SceneExplorerManager.GetActiveExplorer()
		return (	sceneExplorerInstance != undefined )
	)	
	
	on isEnabled do 	
	(		
		local sceneExplorerInstance = SceneExplorerManager.GetActiveExplorer()
		if (sceneExplorerInstance == undefined) then return false
		local selectedItems = sceneExplorerInstance.SelectedItems()
		
		local hasDeletableLayers = false
		local hasNonDeletableLayers = false
		local hasNodes = false
		for item in selectedItems while not hasNonDeletableLayers do 
		(
			if (IsLayer item) then 
			(
				if item.canDelete() then
					hasDeletableLayers = true
				else
					hasNonDeletableLayers = false
			)
			else
				hasNodes = false
		)		

		return true
	)
	
	
	on execute do
	(
		local sceneExplorerInstance = SceneExplorerManager.GetActiveExplorer()
		local selectedNodes = #()
		local selectedLayers = #()
		
		local selectedItems = sceneExplorerInstance.SelectedItems()
		sceneExplorerInstance.SelectChildren()	
		local selectedChildren = sceneExplorerInstance.SelectedItems()

		join selectedItems selectedChildren

		for item in selectedItems do 
		(
			if (IsLayer item) then 
			(
				append selectedLayers item
			)
			else			
			(
				append selectedNodes item
			)
		)
		if (selectedNodes.Count > 0) then
		(
			delete selectedNodes
		)
		for layer in selectedLayers do 
		(
			LayerManager.deleteLayerHierarchy layer.name forceDelete:true
			LayerManager.deleteLayerByName layer.name
		)
	)
)

macroScript SEDeleteUnuse
	category:"Scene Explorer" 
	internalCategory: "Scene Explorer"
	toolTip: "Delete Unused Layer(s)"
	ButtonText: "Delete Unused Layer(s)"
(	
	on isVisible do	
	(
		local sceneExplorerInstance = SceneExplorerManager.GetActiveExplorer()
		return (	sceneExplorerInstance != undefined )
	)	
	
	on isEnabled do 	
	(		
		local sceneExplorerInstance = SceneExplorerManager.GetActiveExplorer()
		if (sceneExplorerInstance == undefined) then return false
		
		return true
	)
	
	on execute do
	(
		for i = (layerManager.count - 1) to 1 by -1 do (
			layername = (LayerManager.getLayer i).name as string
			if (not LayerManager.doesLayerHierarchyContainNodes layername) then
			(
				LayerManager.deleteLayerByName layername
			)
		)
	)
)