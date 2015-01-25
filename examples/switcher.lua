local examples = {
	{"https://html5test.com/", "HTML5 test", {"whichbrowser.com", "api.whichbrowser.com", "api.whichbrowser.net"}},
	{"http://whatsmyuseragent.com/", "HTML5 test"},
	{"https://www.youtube.com/watch?v=4pU4goxloIM?html5=1", "YouTube"},
	{"http://hakim.se/experiments/html5/origami/", "HTML5 Origami"},
	{"http://www.craftymind.com/factory/html5video/CanvasVideo.html", "HTML5 Video"},
}

local function trimDomains(t)
	local temp = {}
	for k, v in pairs(examples) do
		temp[k] = pregMatch(v[1], "https\?://(.*?)/")[1]
	end
	return temp
end

-- Request all not yet whitelisted URL
requestBrowserDomains(trimDomains(examples))
-- Request additional domains
for k, v in pairs(examples) do
	if v[3] then
		requestBrowserDomains(v[3])
	end
end

local screenWidth, screenHeight = guiGetScreenSize()
local webWindow = exports.webui:createWebWindow(100, 100, screenWidth-2*100, screenHeight-2*100, "http://", true)

local buttonSwitchLeft = guiCreateButton(5, screenHeight/2-50/2, 50, 50, "<", false)
local buttonSwitchRight = guiCreateButton(screenWidth-50-5, screenHeight/2-50/2, 50, 50, ">", false)

local currentIndex = 1
exports.webui:loadWebWindowURL(webWindow, examples[currentIndex][1])

addEventHandler("onClientGUIClick", buttonSwitchLeft,
	function(button, state)
		if button == "left" and state == "up" then
			currentIndex = currentIndex - 1
			if currentIndex < 1 then
				currentIndex = 1
			end
			
			local url, title = unpack(examples[currentIndex])
			exports.webui:loadWebWindowURL(webWindow, url)
		end
	end
)

addEventHandler("onClientGUIClick", buttonSwitchRight,
	function(button, state)
		if button == "left" and state == "up" then
			currentIndex = currentIndex + 1
			if currentIndex > #examples then
				currentIndex = #examples
			end
			
			local url, title = unpack(examples[currentIndex])
			exports.webui:loadWebWindowURL(webWindow, url)
		end
	end
)
