require "Cocos2d"
require "Cocos2dConstants"
require "ExtensionConstants"
require "json"

WIN_WIDTH = 0
WIN_HEIGHT = 0

local fileUtil = cc.FileUtils:getInstance()

fileUtil:addSearchPath("src")
fileUtil:addSearchPath("res")
fileUtil:addSearchPath(fileUtil:getWritablePath())
fileUtil:addSearchPath(fileUtil:getWritablePath().."scene")
fileUtil:addSearchPath(fileUtil:getWritablePath().."module")
fileUtil:addSearchPath(fileUtil:getWritablePath().."image")
fileUtil:addSearchPath(fileUtil:getWritablePath().."sound")
fileUtil:addSearchPath(fileUtil:getWritablePath().."font")

local md5 = require("md5")
require "base64"
require "trycatch"
require "utils"

cclog = function(...)
	print(string.format(...))
end

function updateBuiltIn()
	local xhr = cc.XMLHttpRequest:new()
	xhr.responseType = cc.XMLHTTPREQUEST_RESPONSE_JSON
	xhr:open("POST", "http://httpbin.org/post")

	local function onReadyStateChange()
		labelStatusCode:setString("Http Status Code:"..xhr.statusText)
		local response   = xhr.response
		local output = json.decode(response,1)
		table.foreach(output,function(i, v) print (i, v) end)
		print("headers are")
		table.foreach(output.headers,print)
	end

	xhr:registerScriptHandler(onReadyStateChange)
	xhr:send()
	
	labelStatusCode:setString("waiting...")
end

-- for CCLuaEngine traceback
function __G__TRACKBACK__(msg)
	cclog("----------------------------------------")
	cclog("LUA ERROR: " .. tostring(msg) .. "\n")
	cclog(debug.traceback())
	cclog("----------------------------------------")
	return msg
end

local consoleBack = nil
local function console(text)
	if text:len()>50 then
		text = text:sub(1,50)
	end
	if consoleBack then
		if consoleBack.ttf == nil then
			consoleBack.ttf = cc.Label:createWithSystemFont(pStrTitle, "Arial", 15)
			consoleBack.ttf:setAnchorPoint(cc.p(0,0))
			consoleBack.ttf.text = {}
			consoleBack:addChild(consoleBack.ttf)
		end

		table.insert(consoleBack.ttf.text,text)
		while(1) do
			consoleBack.ttf:setString(table.concat(consoleBack.ttf.text,"\n"))
			if consoleBack.ttf:getContentSize().height > consoleBack:getContentSize().height then
				table.remove(consoleBack.ttf.text, 1)
			else
				break
			end
		end
	end
end

function InitCocos2d(width,height)
	local director = cc.Director:getInstance()
	local glview = director:getOpenGLView()
	if nil == glview then
		if width == nil or height == nil then
			glview = cc.GLViewImpl:create("VisualNovel")
		else
			glview = cc.GLViewImpl:createWithRect("VisualNovel",cc.rect(0,0,width,height))
		end
		director:setOpenGLView(glview)
	end

	if width == nil or height == nil then
	else
		glview:setDesignResolutionSize(width , height, cc.ResolutionPolicy.NO_BORDER)
	end

	if width == nil or height == nil then
		local s = cc.Director:getInstance():getVisibleSize()
		WIN_WIDTH = s.width
		WIN_HEIGHT = s.height
	else
		WIN_WIDTH = width
		WIN_HEIGHT = height
	end
	director:setDisplayStats(false)
	director:setAnimationInterval(1.0 / 60)
end

function ScreenReSize(width,height)
	local director = cc.Director:getInstance()
	local glview = director:getOpenGLView()
	if glview then
		glview:setDesignResolutionSize(width , height, cc.ResolutionPolicy.NO_BORDER)
		glview:setFrameSize(width , height)
	end

	WIN_WIDTH = width
	WIN_HEIGHT = height

end

local function LanX_start(start)
	try{
		function()
			local targetPlatform = CCApplication:getInstance():getTargetPlatform()
			--if kTargetWindows == targetPlatform then
				package.preload["ProjectInfo"] = nil
				local proj = require("ProjectInfo")

				ScreenReSize(proj.width,proj.height)
			--end

			package.loaded["FILEMANS"] = nil
			require('FILEMANS')
			
			XVM = require("LanXVM")
			XVM:init()
			if pini then
				pini:Clear()
			end


			try{function()
				require(FILES["module/libdef.lnx"]:gsub(".lua",""))(XVM)
				end,
				catch {function(error)
					print("ERROR LOADING LIBDEF LNX",error)
				end}
			}

			try{function()
				require("PiniLib")(XVM)
				end,
				catch {function(error)
					print("ERROR LOADING PINILIB")
				end}
			}

			try{function()
					require(FILES["scene/"..start..".lnx"]:gsub(".lua",""))(XVM)
				end,
				catch {function(error)
					print("start 1 :",error)
					try{function()
							require(start)(XVM)
						end,
						catch {function(error)
							print("start 2 :",error)
							console("저장된 메인 씬이 없습니다 : \""..start.."\"")
						end}
					}
				end}
			}
			XVM:runCommand()
			consoleBack = nil
		end,
		catch {
			function(error)
				console("저장된 메인 씬이 없습니다 : \""..start.."\"")
				print(error)
		end
		}
	}
end


local function makeBtn(pStrTitle,callback)
	-- Creates and return a button with a default background and title color. 
	local pBackgroundButton = cc.Scale9Sprite:create("extensions/button.png")
	local pBackgroundHighlightedButton = cc.Scale9Sprite:create("extensions/buttonHighlighted.png")

	pTitleButton = cc.Label:createWithSystemFont(pStrTitle, "Marker Felt", 30)

	pTitleButton:setColor(cc.c3b(159, 168, 176))

	local pButton = cc.ControlButton:create(pTitleButton, pBackgroundButton)
	pButton:setBackgroundSpriteForState(pBackgroundHighlightedButton, cc.CONTROL_STATE_HIGH_LIGHTED )
	pButton:setTitleColorForState(cc.c3b(255,255,255), cc.CONTROL_STATE_HIGH_LIGHTED )

	pButton:registerControlEventHandler(callback,cc.CONTROL_EVENTTYPE_TOUCH_UP_INSIDE)
	return pButton
end

local function initRemoteScene(width,height)
	local pScene = cc.Scene:create()
	local pLayer = cc.Layer:create()

	local pBackground = cc.Sprite:create("extensions/background.png")
	pBackground:setPosition(width/2,height/2)
	pLayer:addChild(pBackground)

	cs = pBackground:getContentSize()
	pBackground:setScale(width/cs.width,height/cs.height)

	local pRibbon = cc.Scale9Sprite:create("extensions/ribbon.png", cc.rect(1, 1, 48, 55))
	pRibbon:setContentSize(cc.size(width, 57))
	pRibbon:setPosition(cc.p(width/2, height-pRibbon:getContentSize().height / 2.0))
	pLayer:addChild(pRibbon)

	--Add the title
	pSceneTitleLabel = cc.Label:createWithSystemFont("Title", "Arial", 12)
	pSceneTitleLabel:setPosition(cc.p (width/2, height - pSceneTitleLabel:getContentSize().height / 2 - 5))
	pLayer:addChild(pSceneTitleLabel, 1)
	pSceneTitleLabel:setString("피니엔진 리모트")

	--CONSOLE
	local pBackgroundButton = cc.Scale9Sprite:create("extensions/buttonBackground.png")
	pBackgroundButton:setContentSize(cc.size(width-100, 300))
	pBackgroundButton:setAnchorPoint(cc.p(0.5,1))
	pBackgroundButton:setPosition(cc.p(width/2, height-50))
	pLayer:addChild(pBackgroundButton)

	consoleBack = pBackgroundButton

	--BUTTONS
	pButton = makeBtn("저장된 파일 실행하기",function() LanX_start("메인") end)
	pButton:setPosition(cc.p (width/2, height/2-100))
	pLayer:addChild(pButton)

	pButton = makeBtn("크래시파일 리포트",function() console("해당 기능은 아직 지원하지 않습니다.") end)
	pButton:setPosition(cc.p (width/2, height/2-150))
	pLayer:addChild(pButton)

	pScene:addChild(pLayer)
	pScene.pLayer = pLayer
	if cc.Director:getInstance():getRunningScene() then
		cc.Director:getInstance():replaceScene(pScene)
	else
		cc.Director:getInstance():runWithScene(pScene)
	end

	return pScene
end


local function main()
	collectgarbage("collect")
	collectgarbage("setpause", 100)
	collectgarbage("setstepmul", 5000)

	local ROOT_PATH = fileUtil:getWritablePath()

	local targetPlatform = CCApplication:getInstance():getTargetPlatform()
	local scene
	if kTargetWindows == targetPlatform then
		InitCocos2d(800,600)
		scene=initRemoteScene(800,600)
	else
		InitCocos2d()
		size = cc.Director:getInstance():getOpenGLView():getFrameSize()
		scene=initRemoteScene(size.width,size.height)
	end
--[[
	require("PiniAPI")
	local player = pini.VideoPlayer("PV.avi")
	print("player 1")
	player:play();
	print("player 2",scene,player.node)
	scene:addChild(player.node)
	print("player 3")
]]

	console(tostring(kTargetWindows == targetPlatform))

	co = coroutine.create(
	function ()
		console("리모트 실행")
		local socket = require("socket")
		
		function newset()
			local reverse = {}
			local set = {}
			return setmetatable(set, {__index = {
				insert = function(set, value)
					if not reverse[value] then
						table.insert(set, value)
						reverse[value] = #set
					end
				end,
				remove = function(set, value)
					local index = reverse[value]
					if index then
						reverse[value] = nil
						local top = table.remove(set)
						if top ~= value then
							reverse[top] = index
							set[index] = top
						end
					end
				end,
				find = function(set,value)
					local index = reverse[value]
					return index
				end
			}})
		end

		set = newset()

		local server = assert(socket.bind("*", 45674))
		local ip, port = server:getsockname()
		local clients = {}

		console("아이피 할당 : "..socket.dns.toip(socket.dns.gethostname()))

		local recv_error = nil
		local function recv(socket,size)
			data, recv_error = socket:receive(size)
			if recv_error then
				--send(socket,"lost","c")
				--socket:close()
				console("리시브드 코드 : "..recv_error)

				local idx = set:find(socket)
				console("연결 종료\n")

				clients[idx] = 0
				socket:close()
				set:remove(socket)

				recv_error = nil
				return nil
			end
			return data
		end

		local function send(socket,order,payload)
			console("<<"..order.."<<"..payload)
			local size = tostring(#payload)
			for i=#size,11-1,1 do
				size = size.." "
			end
			socket:send(order)
			socket:send(size)
			socket:send(payload)
		end

		local function recvedInt(str,c)
			local buffer = ""
			for i=1,c,1 do
				local t = str:byte(i)
				if t >= 48 and t <= 57 then
					local c = string.char(t)
					buffer = buffer..c
				else
					break
				end
			end
			return tonumber(buffer)
		end

		console("리모트 서버 정상 작동")
		set:insert(server)
		while 1 do
			local readable, _, error = socket.select(set, nil,0)
			for _, input in ipairs(readable) do
				if input == server then 
					local new = input:accept()
					if new then
						new:settimeout(1)
						set:insert(new)
						console("툴과 연결됨")

						clients[set:find(new)] = 0
						console("툴과 연결됨1")
					else
					end
				else
					local line, error;
					local idx = set:find(input)

					console(">> 데이터 수신")
					if clients[idx] == 0 then
						console("명령 해석 중")
						header = recv(input,4)
						console("해더 입력 완료")
						if header then 
							size = recv(input,11)
							size = tostring(size)
							size = recvedInt(size,11)
							
							clients[idx] = {header,size,0}
							console("ok!")
						else
							console("정상 연결 해제.")
						end
					else 
						order = clients[idx][1]
						console("명령 인자 : "..order)
						print("order >> "..order)
						if order == "tran" then
							s1 = tonumber(recv(input,4))
							fileDist = recv(input,s1)
							s2 = tonumber(recv(input,4))
							fileName = recv(input,s2)
							fileData = recv(input,clients[idx][2]-s1-s2-4-4)

							local fullpath = ROOT_PATH..fileDist.."/"..fileName
							if not fileUtil:isDirectoryExist(ROOT_PATH..fileDist) then
								fileUtil:createDirectory(ROOT_PATH..fileDist)
							end

							console(fullpath)

							file = fileName:StripExtension()
							if package.loaded[file] then
								package.loaded[file] = nil
							end

							local out = io.open(fullpath, "wb")
							local t = {}
							out:write(fileData)
							out:close()

						elseif order == "flst" then
							if consoleBack == nil then
								size = cc.Director:getInstance():getOpenGLView():getFrameSize()
								initRemoteScene(size.width,size.height)
							end

							payload = recv(input,clients[idx][2])
							function readAll(file)
								local f = io.open(file, "rb")
								if f then
									local content = f:read("*all")
									f:close()
									return content
								end
								return nil
							end

							local fileList = json.decode(payload)
							local updateList = {}
							for k,v in pairs(fileList)do
								local fullpath = ROOT_PATH .. k
								local data = readAll(fullpath)
								local needUpdate = true
								if data then
									local hex = md5.sumhexa(data)
									local checksum = to_base64(hex)
									if checksum == v then
										needUpdate = false
									end
								end
								if needUpdate then
									table.insert(updateList,k)
								end
							end
							print(json.encode(updateList))
							send(input,"ulst",json.encode(updateList))
						elseif order == "ufin" then
							startScene = recv(input,clients[idx][2])
							console("업데이트 완료!")
							console("===========================================")
							console("씬 실행 "..startScene)
							LanX_start(startScene:gsub(".lua",""))
						
							send(input,"ufin","finish")
						elseif order == "ping" then
							recv(input,clients[idx][2])
							platform = CCApplication:getInstance():getTargetPlatform()

							if platform == kTargetWindows then
								send(input,"pong","WINOW")
							elseif platform == kTargetMacOS then
								send(input,"pong","MACIN")
							elseif platform == kTargetAndroid then
								send(input,"pong","ANDRO")
							elseif platform == kTargetIphone then
								send(input,"pong","IPHON")
							elseif platform == kTargetIpad then
								send(input,"pong","IPADD")
							else 
								send(input,"pong","UNKNO")
							end

						else
							recv(input,clients[idx][2])
							console("가비지 size:"..clients[idx][2])
						end

						clients[idx] = 0
					end

					if recv_error then
						console("Removing client from set\n")
						clients[idx] = 0
						input:close()
						set:remove(input)
						recv_error = nil
					else
						--??
					end
				end
			end
			coroutine.yield()
		end
	end)

	local function networkUpdate()
		coroutine.resume(co)
	end
	
	local scheduler = cc.Director:getInstance():getScheduler()
	schedulerEntry = scheduler:scheduleScriptFunc(networkUpdate, 0.1, false)
end

local status, msg = xpcall(main, __G__TRACKBACK__)
if not status then
	error(msg)
end