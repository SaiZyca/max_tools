Macroscript VrayGPUSeparateFolders
category: "Moonshine"
tooltip: "toggle VrayGPU Output SeparateFolders"
(
	local checked = false

	on execute do
	(
		if classOf renderers.current == V_Ray_GPU_5__hotfix_2 then
		(
			renderers.current.V_Ray_settings.output_separateFolders = not renderers.current.V_Ray_settings.output_separateFolders
			format "VrayGPU Output SeparateFolders: % \n" (renderers.current.V_Ray_settings.output_separateFolders)
			checked = renderers.current.V_Ray_settings.output_separateFolders 
		)
		else ( format "Current Renderer is not VrayGPU \n" )
	)
	on isChecked return checked
)
