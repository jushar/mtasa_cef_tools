-- ****************************************************************************
-- *
-- *  PROJECT:     MTA:SA CEF utilities (https://github.com/Jusonex/mtasa_cef_tools)
-- *  FILE:        webui/examples/Main.lua
-- *  PURPOSE:     Resource entry point
-- *
-- ****************************************************************************

addEventHandler("onClientResourceStart", resourceRoot,
	function()
		-- Do not load anything if we do not want to
		if not get("show_examples") then	
			return
		end

		-- Retrieve and set some basic information we need
		local screenWidth, screenHeight = guiGetScreenSize()
		local width, height = 640, 480
	
		-- Initialise the web ui manager (to be able to render web UIs)
		WebUIManager:new()
		
		-- Create our (local) UIs
		local window1 = WebWindow:new(Vector2(screenWidth/2-width/2-100, screenHeight/2-height/2-100), Vector2(width, height), "tests/html/ui2.html", true)
		local window2 = WebWindow:new(Vector2(screenWidth/2-width/2, screenHeight/2-height/2), Vector2(width, height), "tests/html/ui3.html", true)
		
		-- Create some (remote) websites
		local window3 = WebWindow:new(Vector2(screenWidth/2-width/2+100, screenHeight/2-height/2+100), Vector2(width, height), "http://youtube.com", true)
		
		-- Draw framewindows
		local window4 = FrameWebWindow:new(Vector2(screenWidth/2-width/2+200, screenHeight/2-height/2+200), Vector2(width, height), "tests/html/ui1.html", true)
		window4:setTitle("Window #5")
		
		window1:addEvent("ui2:onClose",
			function(webwindow)
				outputChatBox("Closing ui2...")
				webwindow:destroy()
			end
		)
		
		showCursor(true)
	end
)
