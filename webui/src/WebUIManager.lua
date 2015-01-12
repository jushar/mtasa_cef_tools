-- ****************************************************************************
-- *
-- *  PROJECT:     MTA:SA CEF utilities (https://github.com/Jusonex/mtasa_cef_tools)
-- *  FILE:        webui/src/WebUIManager.lua
-- *  PURPOSE:     WebUIManager class definition
-- *
-- ****************************************************************************
WebUIManager = {
	new = function(self, ...) local o=setmetatable({},{__index=self}) o:constructor(...) WebUIManager.Instance = o return o end;
	getInstance = function() assert(WebUIManager.Instance, "WebUIManager has not been initialised yet") return WebUIManager.Instance end;
	
	Settings = {
		ScrollSpeed = 50;
	};
}

--
-- WebUIManager's constructor
-- Returns: The WebUIManager instance
--
function WebUIManager:constructor()
	self.m_Stack = {}
	
	addEventHandler("onClientRender", root,
		function()
			-- Draw from bottom to top
			for k, ui in ipairs(self.m_Stack) do
				ui:draw()
			end
		end
	)
	
	addEventHandler("onClientCursorMove", root,
		function(relX, relY, absX, absY)
			for k, ui in pairs(self.m_Stack) do
				local browser = ui:getUnderlyingBrowser()
				local pos = ui:getPosition()
				browser:injectMouseMove(absX - pos.x, absY - pos.y)
			end
		end
	)
	
	local function onMouseWheel(key, state, direction)
		local browser = WebUIManager.getFocussedBrowser()
		if browser then
			browser:injectMouseWheel(direction*WebUIManager.Settings.ScrollSpeed, 0)
		end
	end
	bindKey("mouse_wheel_up", "down", onMouseWheel, 1)
	bindKey("mouse_wheel_down", "down", onMouseWheel, -1)
	
	addEventHandler("onClientClick", root,
		function(button, state, absX, absY)
			local topIndex = #self.m_Stack
		
			-- Process from top to bottom
			for i = topIndex, 1, -1 do
				local ui = self.m_Stack[i]
				local pos, size = ui:getPosition(), ui:getSize()
				local browser = ui:getUnderlyingBrowser()
				
				-- Are we within the browser rect?
				if absX >= pos.x and absY >= pos.y and absX < pos.x + size.x and absY < pos.y + size.y then
					if state == "down" then
						browser:injectMouseDown(button)
					else
						browser:injectMouseUp(button)
					end
					
					-- Move to front if the current browser isn't the currently foccused one
					if i ~= topIndex then
						self:moveWindowToFrontByIndex(i)
					end
					browser:focus()
					
					-- Stop here (the click has been processed!)
					break
				end
			end
		end
	)
end

--
-- Registers a window at the manager
-- Parameters:
--    window: The web UI window (WebWindow)
--
function WebUIManager:registerWindow(window)
	table.insert(self.m_Stack, window)
end

--
-- Unlinks a window from the manager
-- Parameters:
--     window: The web UI window (WebWindow)
--
function WebUIManager:unregisterWindow(window)
	for k, v in pairs(self.m_Stack) do
		if v == window then
			table.remove(self.m_Stack, k)
			return true
		end
	end
	return false
end

--
-- Moves the specified window to the front (by WebWindow instance)
-- Parameters:
--     window: The web UI window you want to move to the front (WebWindow)
--
function WebUIManager:moveWindowToFront(window)
	-- TODO
end

--
-- Moves a window to the front by index (fast internal use)
-- Parameters:
--      index: The index the window has on the drawing stack
--
function WebUIManager:moveWindowToFrontByIndex(index)
	-- Make a backup of the window at the specified index
	local ui = self.m_Stack[index]
	
	-- Remove it from the list temporally
	table.remove(self.m_Stack, index)
	
	-- Append it to the end
	table.insert(self.m_Stack, ui)
end

--
-- Static function that returns the currently focussed browser
-- Returns: The focussed browser element
--
function WebUIManager.getFocussedBrowser()
	for k, browser in pairs(getElementsByType("webbrowser")) do
		if browser:isFocused() then
			return browser
		end
	end
	return false
end
