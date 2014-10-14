require "Cocos2d"
require "Cocos2dConstants"

cclog = function(...)
    print(string.format(...))
end

-- for CCLuaEngine traceback
function __G__TRACKBACK__(msg)
    cclog("----------------------------------------")
    cclog("LUA ERROR: " .. tostring(msg) .. "\n")
    cclog(debug.traceback())
    cclog("----------------------------------------")
    return msg
end

function InitCocos2d(width,height)

    local director = cc.Director:getInstance()
    local glview = director:getOpenGLView()
    if nil == glview then
        glview = cc.GLView:createWithRect("VisualNovel", cc.rect(0,0,width,height))
        director:setOpenGLView(glview)
    end
    
    glview:setDesignResolutionSize(width,height, cc.ResolutionPolicy.NO_BORDER)
    director:setDisplayStats(true)
    director:setAnimationInterval(1.0 / 60)
end

local function main()
    collectgarbage("collect")
    collectgarbage("setpause", 100)
    collectgarbage("setstepmul", 5000)

    cc.FileUtils:getInstance():addSearchPath("src")
    cc.FileUtils:getInstance():addSearchPath("res")
    
    local proj = require("ProjectInfo")
    InitCocos2d(proj.width,proj.height)
    
	XVM = require("LanXVM")
	XVM:init()
	require("EmulateVM")(XVM)

	require("MainScript")(XVM)

	XVM:runCommand()
end

local status, msg = xpcall(main, __G__TRACKBACK__)
if not status then
    error(msg)
end