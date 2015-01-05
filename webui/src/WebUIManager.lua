-- ****************************************************************************
-- *
-- *  PROJECT:     MTA:SA CEF utilities (https://github.com/Jusonex/mtasa_cef_tools)
-- *  FILE:        webui/src/WebUIManager.lua
-- *  PURPOSE:     WebUIManager class definition
-- *
-- ****************************************************************************
WebUIManager = {
	new = function(...) local o=setmetatable({}, WebUIManager) o:constructor(...) WebUIManager.Instance = o return o end;
	getInstance = function() assert(WebUIManager.Instance, "WebUIManager has not been initialised yet") return WebUIManager.Instance end;
}

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
				browser:injectMouseMove(absX, absY)
			end
		end
	)
	
	addEventHandler("onClientClick", root,
		function(button, state, absX, absY)
			local topIndex = #self.m_Stack
		
			-- Process from top to bottom
			for i = topIndex, 1, -1 do
				local ui = self.m_Stack[i]
				local pos, size = ui:getPosition(), ui:getSize()
				
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
					
					-- Stop here (the click has been processed!)
					break
				end
			end
		end
	)
end

function WebUIManager:registerWindow(window)
	table.insert(self.m_Stack, window)
end

function WebUIManager:unregisterWindow(window)
	for k, v in pairs(self.m_Stack) do
		if window == v then
			table.remove(self.m_Stack, k)
			break
		end
	end
end

function WebUIManager:moveWindowToFront(window)
	-- TODO
end

function WebUIManager:moveWindowToFrontByIndex(index)
	-- Make a backup of the window at the specified index
	local ui = self.m_Stack[index]
	
	-- Remove it from the list temporally
	table.remove(self.m_Stack, index)
	
	-- Append it to the end
	table.insert(self.m_Stack, ui)
end