-- ****************************************************************************
-- *
-- *  PROJECT:     MTA:SA CEF utilities (https://github.com/Jusonex/mtasa_cef_tools)
-- *  FILE:        webui/src/ExportsAPI.lua
-- *  PURPOSE:     Exports interface for people who don't want to add webui to their project
-- *
-- ****************************************************************************
local webWindows = {}

function startUp()
	WebUIManager:new()
end

function createWebWindow(posX, posY, sizeX, sizeY, url, transparent)
	local identifier = #webWindows + 1
	webWindows[identifier] = WebWindow:new(Vector2(posX, posY), Vector2(sizeX, sizeY), url, transparent)
	
	return identifier
end

function destroyWebWindow(identifier)
	local webWindow = webWindows[identifier]
	if not webWindow then return false end
	
	webWindow:destroy()
	webWindows[webWindow] = nil
	return true
end

function getWebWindowPosition(identifier)
	local webWindow = webWindows[identifier]
	if not webWindow then return false end
	
	local pos = webWindow:getPosition()
	return pos.x, pos.y
end

function setWebWindowPosition(identifier, x, y)
	local webWindow = webWindows[identifier]
	if not webWindow then return false end
	
	return webWindow:setPosition(x, y)
end

function loadWebWindowURL(identifier, url)
	local webWindow = webWindows[identifier]
	if not webWindow then return false end
	
	return webWindow:getUnderlyingBrowser():loadURL(url)
end

function getWebWindowTexture(identifier)
	local webWindow = webWindows[identifier]
	if not webWindow then return false end
	
	return webWindow:getTexture()
end
