
local browser = {}
browser.browsers = {}
browser.homepage = "http://youtube.com/"
browser.images = {}
browser.tabs = {}
browser.buttons = {}
browser.history = {}
browser.historyPos = {}
browser.window = nil
browser.tabpanel = nil
browser.currentTab = nil
browser.pages = requestBrowserDomains({"google.com", "youtube.com", "twitch.tv", "pandora.com"})
local sx, sy = guiGetScreenSize()
 
function newTab()
	for i=1,10 do
		if browser.tabs[i] == nil then
			browser.browsers[i] = createBrowser ( 1110, 700, false )
			browser.history[i] = {}
			browser.tabs[i] = guiCreateTab ( "Tab #"..i, browser.tabpanel )
			browser.buttons[i] = {
				guiCreateButton ( 0, 5, 20, 20, "X", false, browser.tabs[i] ),
				guiCreateEdit ( 20, 5, 480, 20, browser.homepage, false, browser.tabs[i] ),
				guiCreateButton ( 500, 5, 20, 20, "Go", false, browser.tabs[i] ),
				guiCreateButton ( 520, 5, 20, 20, "<", false, browser.tabs[i] ),
				guiCreateButton ( 540, 5, 20, 20, ">", false, browser.tabs[i] )
			}
			addEventHandler ( "onClientGUIClick", browser.buttons[i][1], closeTab, false )
			addEventHandler ( "onClientGUIClick", browser.buttons[i][3], goPage, false )
			addEventHandler ( "onClientGUIClick", browser.buttons[i][4], goBack, false )
			addEventHandler ( "onClientGUIClick", browser.buttons[i][5], goForward, false )
                       
			addEventHandler ( "onClientCursorMove", root,
				function ( relx, rely, absx, absy )
					local ix, iy = guiGetPosition ( browser.window, false )
					ix, iy = ix + 20, iy + 80
					injectBrowserMouseMove ( browser.browsers[i], absx-ix, absy-iy )
				end )
			addEventHandler ( "onClientClick", root,
				function ( button, state )
					if state == "down" then
						injectBrowserMouseDown ( browser.browsers[i], button )
                                               else
						injectBrowserMouseUp ( browser.browsers[i], button )
                                                
					end
end )
	           		
                               function onKey(button)
	                              if button == "mouse_wheel_down" then
		                               injectBrowserMouseWheel(browser.browsers[i], -40, 0)
	                             else
		                                injectBrowserMouseWheel(browser.browsers[i], 40, 0)
                                     end
end
 addEventHandler("onClientKey", root, onKey)	

			browser.historyPos[i] = 1
			browser.currentTab = i
			addEventHandler ( "onClientBrowserCreated", browser.browsers[i], function() loadBrowserURL ( source, guiGetText ( browser.buttons[i][2] ) ) end )
			browser.history[i][1] = guiGetText ( browser.buttons[i][2] )
			break
		end
		if i == 10 then
			outputChatBox ( "10 tabs maximum" )
			break
		end
	end
end
 
function closeTab()
	if #browser.tabs > 1 then
		destroyElement ( browser.browsers[browser.currentTab] )
		browser.browsers[browser.currentTab] = nil
		for k,v in ipairs ( browser.buttons[browser.currentTab] ) do
			destroyElement ( v )
		end
		browser.buttons[browser.currentTab] = nil
		guiDeleteTab ( browser.tabs[browser.currentTab], browser.tabpanel )
		browser.tabs[browser.currentTab] = nil
	else
		outputChatBox ( "Cannot close tab - at least one tab must be open." )
	end
end
 
function changeTab()
	for k,v in ipairs ( browser.tabs ) do
		if v == source then
			browser.currentTab = k
		end
	end
end
 
function goPage()
	browser.history[browser.currentTab][#browser.history[browser.currentTab]+1] = guiGetText ( browser.buttons[browser.currentTab][2] )
	browser.historyPos[browser.currentTab] = #browser.history[browser.currentTab]
	loadBrowserURL ( browser.browsers[browser.currentTab], guiGetText ( browser.buttons[browser.currentTab][2] ) )
end
 
function stopPage()
 
end
 
function goBack()
	if browser.historyPos[browser.currentTab] > 1 then
		browser.historyPos[browser.currentTab] = browser.historyPos[browser.currentTab]-1
		loadBrowserURL ( browser.browsers[browser.currentTab], browser.history[browser.currentTab][browser.historyPos[browser.currentTab]] )
		guiSetText ( browser.buttons[browser.currentTab][2], browser.history[browser.currentTab][browser.historyPos[browser.currentTab]] )
	end
end
 
function goForward()
	if browser.historyPos[browser.currentTab] < #browser.history[browser.currentTab] then
		browser.historyPos[browser.currentTab] = browser.historyPos[browser.currentTab]+1
		loadBrowserURL ( browser.browsers[browser.currentTab], browser.history[browser.currentTab][browser.historyPos[browser.currentTab]] )
		guiSetText ( browser.buttons[browser.currentTab][2], browser.history[browser.currentTab][browser.historyPos[browser.currentTab]] )
	end
end
 
function browserToggle()
	if guiGetVisible ( browser.window ) then
		guiSetVisible ( browser.window, false )
		showCursor ( false )
		focusBrowser ( nil )
	else
		guiSetVisible ( browser.window, true )
		showCursor ( true )
		focusBrowser ( browser.browsers[browser.currentTab] )
		guiSetInputEnabled ( true )
	end
end
 
function clientRender()
	if guiGetVisible ( browser.window ) then
		local ix, iy = guiGetPosition ( browser.window, false )
		ix, iy, iw, ih = ix + 20, iy + 80, 1110, 700
		dxDrawImage ( ix, iy, iw, ih, browser.browsers[browser.currentTab], 0, 0, 0, tocolor ( 255, 255, 255, 255 ), true )
	end
end
 
function resourceStart()
	browser.window = guiCreateWindow ( sx/2-575, sy/2-400, 1200, 800, "Woovie's Browser v0.1", false )
	guiSetVisible ( browser.window, false )
	browser.tabpanel = guiCreateTabPanel ( 10, 30, 1180, 760, false, browser.window )
	addEventHandler ( "onClientGUITabSwitched", browser.tabpanel, changeTab )
	newTab()
	bindKey ( "b", "up", browserToggle )
end
 
addEventHandler ( "onClientRender", root, clientRender )
addEventHandler ( "onClientResourceStart", resourceRoot, resourceStart )
