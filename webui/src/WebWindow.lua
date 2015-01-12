-- ****************************************************************************
-- *
-- *  PROJECT:     MTA:SA CEF utilities (https://github.com/Jusonex/mtasa_cef_tools)
-- *  FILE:        webui/src/WebWindow.lua
-- *  PURPOSE:     WebWindow class definition
-- *
-- ****************************************************************************
WebWindow = { new = function(self, ...) local o=setmetatable({},{__index=self}) o:constructor(...) return o end }

--
-- WebWindow's constructor
-- Parameters:
--    pos: the position (Vector2)
--    size: the size (Vector2)
--    initialPage: path to the initial page (string)
--    transparent: does it support transparency or is it fully opaque? (bool)
-- Returns: The WebWindow instance
--
function WebWindow:constructor(pos, size, initialPage, transparent)
	-- Read necessary information
	self.m_Position = pos
	self.m_Size = size
	self.m_Transparent = transparent

	-- Create the CEF browser in local mode
	self.m_Window = Browser.create(size.x, size.y, true, transparent)
	
	-- Load the initial page
	self.m_Window:loadURL(initialPage)
	
	-- Register the window
	WebUIManager:getInstance():registerWindow(self)
end

--
-- WebWindow's destructor
--
function WebWindow:destroy()
	-- Unlink from manager
	WebUIManager:getInstance():unregisterWindow(self)
	
	self.m_Window:destroy()
end

--
-- Returns the drawing 2D position
-- Returns: A Vector2 containing the position
--
function WebWindow:getPosition()
	return self.m_Position
end

--
-- Sets the position of the window
-- Parameters:
--    pos: A Vector2 containg the position
--
function WebWindow:setPosition(pos)
	self.m_Position = pos
end

--
-- Returns the size
-- Returns: A Vector2 containing the size
--
function WebWindow:getSize()
	return self.m_Size
end

--
-- Returns the transparency state
-- Returns: true if transparent, false if fully opaque
--
function WebWindow:isTransparent()
	return self.m_Transparent
end

--
-- Sets the rendering state
-- Parameters:
--    state: false if you want to pause rendering, true if you want to continue rendering
--
function WebWindow:setRenderingPaused(state)
	return self.m_Window:setRenderingPaused(state)
end

--
-- Returns the underlying Browser instance (for internal use only!)
-- Returns: The CEF browser (Browser, texture)
--
function WebWindow:getUnderlyingBrowser()
	return self.m_Window
end

--
-- Draws the window (normally called by the ui manager)
--
function WebWindow:draw()
	dxDrawImage(self.m_Position, self.m_Size, self.m_Window, 0, 0, 0, -1, true)
end
