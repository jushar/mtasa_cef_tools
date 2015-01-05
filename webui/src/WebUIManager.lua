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
	self.m_Map = {}
	
	addEventHandler("onClientRender", root,
		function()
			for k, ui in ipairs(self.m_Map) do
				ui:draw()
			end
		end
	)
	
	addEventHandler("onClientCursorMove", root,
		function(relX, relY, absX, absY)
			for k, ui in pairs(self.m_Map) do
				local browser = ui:getUnderlyingBrowser()
				browser:injectMouseMove(absX, absY)
			end
		end
	)
	
	addEventHandler("onClientClick", root,
		function(button, state, absX, absY)
			-- TODO: Add support for several browser layers (=> Z-ordering)
			local isDown = state == "down"
			
			for k, ui in pairs(self.m_Map) do
				local browser = ui:getUnderlyingBrowser()
				if isDown then
					browser:injectMouseDown(button)
				else
					browser:injectMouseUp(button)
				end
			end
		end
	)
end

function WebUIManager:registerWindow(window)
	table.insert(self.m_Map, window)
end

function WebUIManager:unregisterWindow(window)
	for k, v in pairs(self.m_Map) do
		if window == v then
			table.remove(self.m_Map, k)
			break
		end
	end
end
