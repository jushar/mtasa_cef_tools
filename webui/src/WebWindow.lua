-- ****************************************************************************
-- *
-- *  PROJECT:     MTA:SA CEF utilities (https://github.com/Jusonex/mtasa_cef_tools)
-- *  FILE:        webui/src/WebWindow.lua
-- *  PURPOSE:     WebWindow class definition
-- *
-- ****************************************************************************
WebWindow = { new = function(...) local o=setmetatable({}, WebWindow) o:constructor(...) return o end }

--
-- WebWindow's constructor
-- Parameters:
--    pos: the position (Vector2)
--    size: the size (Vector2)
--    initialPage: path to the initial page (string)
--    transparent: does it support transparency or is it fully opaque? (bool)
--
function WebWindow:constructor(pos, size, initialPage, transparent)
	-- Read necessary information
	self.m_Position = pos
	self.m_Size = size
	self.m_Transparent = transparent

	-- Create the CEF browser in local mode
	self.m_Window = Browser.create(size.x, size.y, true, transparent)
	
	-- Load the initial page
	self.m_Window:loadURL(url)
	
	-- Register the window
	WebUIManager:getInstance():registerWindow(self)
end

function WebWindow:destructor()
	-- Unlink from manager
	WebUIManager:getInstance():unregisterWindow(self)
	
	self.m_Window:destroy()
end

function WebWindow:getPosition()
	return self.m_Position
end

function WebWindow:setPosition(pos)
	self.m_Position = pos
end

function WebWindow:getSize()
	return self.m_Size
end

function WebWindow:isTransparent()
	return self.m_Transparent
end

function WebWindow:setRenderingPaused(state)
	return self.m_Window:setRenderingPaused(state)
end

function WebWindow:getUnderlyingBrowser()
	return self.m_Window
end

function WebWindow:draw()
	dxDrawImage(self.m_Position, self.m_Size, self.m_Window, 0, 0, 0, -1, true)
end
