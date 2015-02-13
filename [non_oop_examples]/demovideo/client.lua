local screenWidth, screenHeight = guiGetScreenSize()

-- Initialise the WebUIManager
exports.webui:startUp()
--requestBrowserDomains{"nyan.cat"}

-- Create the web window
local webWindow = exports.webui:createWebWindow(screenWidth-800, screenHeight-480, 800, 480, "https://www.youtube.com/tv?gl=DE&hl=de#/", true)
local texture = false

addEventHandler("onClientRender", root,
	function()
		-- Retrieve the texture only one time | Keep in mind that exports are very slow!
		if not texture then
			texture = exports.webui:getWebWindowTexture(webWindow)
		end
	
		-- Draw it into the 3d world
		local x, y = 110.7, 1024.15
		dxDrawMaterialLine3D(x, y, 23.25, x, y, 14.75, texture, 18.2, tocolor(255, 255, 255, 255), x, y+1, 19)
	end
)

bindKey("b", "down", function() showCursor(not isCursorShowing()) end)
addCommandHandler("d", function() exports.webui:destroyWebWindow(webWindow) end)