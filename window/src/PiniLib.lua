require("utils")
require("trycatch")
require("PiniAPI")

require("BuiltIn_Animation")
try{
	function() require(FILES["module/Animation"]) end,
	catch {function(error)end}
}

--##########################################################################
-- LanXVM 라이브러리 기능
--##########################################################################
function LNX_IMAGE(vm,arg)
	local id = vm.variable["이미지.아이디"] or ""
	local path = vm.variable["이미지.파일명"] or ""
	local pos = vm.variable["이미지.위치"] or "화면중앙"
	local effect = vm.variable["이미지.효과"] or ""
	local effectSec = vm.variable["이미지.효과시간"] or 0.25
	local size = vm.variable["이미지.크기"] or "원본크기"
	local connect = vm.variable["이미지.연결"] or ""
	local parent = vm.variable["이미지.관계"] or ""

	if path:len() > 0 then
		local img = pini.Sprite(id,path)
		local p = pos:explode(",")
		local s = size:explode(",")
		img:setScale(s[1],s[2])
		img:setPosition(p[1],p[2])
		
		pini:AttachDisplay(img,parent)

		if connect:len() > 0 then
			pini.TouchManager:registNode(img)
			img.onTouchUp = function()
				vm:GotoBookmark(connect)
				vm:doNext()
			end
		end

		if effect:len() > 0 then
			if fs_imageEffect[effect] then
				fs_imageEffect[effect](img,effectSec)
			end
		end
	else
		--[[
		if id:len() > 0 and pini._regist_.Display[id] then
			local v = pini._regist_.Display[id]
			if v then
				v = v.obj

				if size:len() > 0 then
					local p = size:explode(",")
					v:setScale(p[1],p[2])
				end
				if pos:len() > 0 then
					local p = pos:explode(",")
					v:setPosition(p[1],p[2])
				end

				parent = v:getParent()
				if parent == scene.layer then
					parent = nil
				end
			end
		end
		]]
	end
	vm:doNext()
end

function LNX_TEXT(vm,arg)
	local id = vm.variable["텍스트.아이디"] or ""
	local text = vm.variable["텍스트.텍스트"] or ""
	local pos = vm.variable["텍스트.위치"] or "화면중앙"
	local effect = vm.variable["텍스트.효과"] or ""
	local effectSec = vm.variable["텍스트.효과시간"] or 0
	local font = vm.variable["텍스트.글꼴"] or "NanumBarunGothic"
	local size = vm.variable["텍스트.크기"] or 20
	local color = vm.variable["텍스트.색상"] or "255,255,255"
	local parent = vm.variable["텍스트.관계"] or ""
	
	if text:len() > 0 then
		local label = pini.Label(id,text,font,size)
		local p = pos:explode(",")
		label:setPosition(p[1],p[2])
		
		pini:AttachDisplay(label,parent)

		if color:len() > 0 then 
			color = color:explode(",")
			label:setColor(color[1],color[2],color[3])
		end

		if effect:len() > 0 then
			if fs_imageEffect[effect] then
				fs_imageEffect[effect](label,effectSec)
			end
		end
	end
	vm:doNext()
end

function LNX_DELETENODE(vm,arg)
	local id = vm.variable["삭제.아이디"] or ""
	local effect = vm.variable["삭제.효과"] or ""
	local effectSec = vm.variable["삭제.효과시간"] or 0.25

	if id:len() > 0 then
		local node = pini:FindNode(id)
		if node then 
			if effect:len() > 0 then
				if fs_imageDeleteEffect[effect] then
					fs_imageDeleteEffect[effect](node,effectSec)
					pini.Timer(nil,effectSec,function()
						pini:DetachDisplay(node)
					end,false):run()
				end
			else
				pini:DetachDisplay(node)
			end
		end
	end
	vm:doNext()
end

function LNX_MONOLOG(vm,arg)
	local forceOn = vm.variable["독백.유지"] or "아니오"
	local window = vm.variable["독백.대사창"] or "독백"
	local arg = vm.variable["system.arg"]
	--print(">LNX_MONOLOG")
	--print(print_r(arg))

	pini.Dialog:setKeep(forceOn=="예")
	pini.Dialog:setName(nil)
	pini.Dialog:UseConfig(window)
	pini.Dialog:Run(vm,arg["targ"])
end

function LNX_DIALOG(vm,arg)
	local name = vm.variable["대화.이름"] or ""
	local forceOn = vm.variable["대화.유지"] or "아니오"
	local window = vm.variable["대화.대사창"] or "대화"
	local arg = vm.variable["system.arg"]

	name = tostring(name)
	if name:len() > 0 then
		pini.Dialog:setName(name)
	else
		pini.Dialog:setName(nil)
	end
	pini.Dialog:setKeep(forceOn=="예")
	pini.Dialog:UseConfig(window)
	pini.Dialog:Run(vm,arg["targ"])
end

function LNX_REMOVEDIALOG(vm,arg)
	vm.variable["대화.유지"] = nil
	vm.variable["독백.유지"] = nil
	pini.Dialog:Reset()

	vm:doNext()
end

function LNX_ANIMATION(vm,arg)
	local id = vm.variable["애니메이션.아이디"] or ""
	local t = vm.variable["애니메이션.타입"] or ""
	
	node = pini._regist_.Display[id]
	if node and fs_animation[t] then
		fs_animation[t][2](vm,node)
	end
	vm:doNext()
end

function LNX_RETURN(vm,arg)
	vm:_return()
end

function LNX_STOP(vm,arg)
	if OnPreview then
		vm:doNext()
	end
end

function LNX_WAIT(vm,arg)
	local time = tonumber(vm.variable["대기.시간"]) or 0
	vm:stop()

	pini.Timer(nil,time,function()
		vm:resume()
	end,false):run()
end

function LNX_CLICKWAIT(vm,arg)
	if OnPreview ~= true then
		vm:stop()
		
		local node = pini.Node("ClickWait")
		node:setContentSize(99999,99999)
		pini.TouchManager:registNode(node)
		node.onTouchUp = function()
			vm:resume()
			pini:DetachDisplay(node)
		end
		pini:AttachDisplay(node)
	else
		vm:doNext()
	end
end

function LNX_PLAYSOUND(vm,arg)
	local id = vm.variable["효과음.아이디"] or ""
	local path = vm.variable["효과음.파일명"] or ""
	pini:PlaySound(id,path)
	vm:doNext()
end

function LNX_PLAYBGM(vm,arg)
	local path = vm.variable["배경음.파일명"] or ""
	local brep = vm.variable["배경음.반복"] or "예"
	pini:PlayBGM(path,brep=="예")
	vm:doNext()
end

function LNX_STOPBGM(vm,arg)
	pini:StopBGM()
	vm:doNext()
end

function LNX_STOPSOUND(vm,arg)
	local id = vm.variable["효과음끄기.아이디"] or ""
	pini:StopBGM(id)
	vm:doNext()
end

function LNX_TIMER(vm,arg)
	local id = vm.variable["타이머.아이디"] or ""
	local func = vm.variable["타이머.함수"] or nil
	local sec = vm.variable["타이머.시간"] or "1"

	pini.Timer(id,sec,function()
		vm:call(func)
		vm:doNext()
	end,true):run()

	vm:doNext();
end

function LNX_TIMER_EXIT(vm,arg)
	local id = vm.variable["타이머종료.아이디"] or ""
	pini:StopTimer(id)
	vm:doNext();
end

function LNX_SCREENCLEAN(vm,arg)
	pini:ClearDisplay()
	vm:doNext()
end

function LNX_CLEARVARIABLE(vm,arg)
	vm:CleanArgVariable()
	vm:doNext()
end

--[[
LanXVM:registFunc("전환",function(vm,arg)
	local id = vm.variable["전환.아이디"] or ""
	local sec = vm.variable["전환.시간"] or ""
	local scale = vm.variable["전환.인자이미지"] or ""
	local path = vm.variable["전환.이미지"] or ""

	local img1 = cc.Sprite:create(FILES["image/"..scale])
	local img2 = cc.Sprite:create(FILES["image/"..path])

	local target = cc.RenderTexture:create(winSize.width, winSize.height, cc.TEXTURE2_D_PIXEL_FORMAT_RGB_A8888)
	target:clear(0,0,0,255)
	target:begin()
	scene.layer:visit()
    target:endToLua()

	local sprite = cc.Sprite:createWithTexture(target:getSprite():getTexture())
	sprite:setPosition(winSize.width/2, winSize.height/2)
    sprite:setFlippedY(true);

	local program = cc.GLProgram:create("transition.vsh", "transition.fsh")
	program:bindAttribLocation(cc.ATTRIBUTE_NAME_POSITION, cc.VERTEX_ATTRIB_POSITION) 
	program:bindAttribLocation(cc.ATTRIBUTE_NAME_TEX_COORD, cc.VERTEX_ATTRIB_TEX_COORD)
	program:link()
	program:updateUniforms()
	sprite:setGLProgram( program )

	local glprogramstate = cc.GLProgramState:getOrCreateWithGLProgram( program );
	sprite:setGLProgramState(glprogramstate);

	glprogramstate:setUniformTexture("u_fadetex", img1:getTexture():getName());
	glprogramstate:setUniformTexture("u_disttex", img2:getTexture():getName());

	local scheduler = cc.Director:getInstance():getScheduler()
	local schedulerEntry
	local threshold = 0
	function UPDATE()
		if threshold == 0 then
			scene.layer:removeAllChildren(true)
			nodes={}

			scene.layer:addChild(sprite)
			sprite:release()
			if id:len() > 0 then
				nodes[id] = sprite
			end

			vm:doNext()
		end
		glprogramstate:setUniformFloat("threshold",threshold)
		threshold = threshold+0.005
		if threshold >= 1 then
			scheduler:unscheduleScriptEntry(schedulerEntry)
		end
	end

	schedulerEntry = scheduler:scheduleScriptFunc(UPDATE,0, false)
	sprite:retain()
end)
]]

function LNX_TRANSITION(vm,arg)
	local id = vm.variable["전환.아이디"] or ""
	local sec = vm.variable["전환.시간"] or ""
	local scale = vm.variable["전환.인자이미지"] or ""
	local path = vm.variable["전환.이미지"] or ""

	-- 화면 전환 효과는 inGame에서만 작동됨
	if OnPreview then
		pini:ClearDisplay()

		local img = pini.Sprite(id,path)
		img:setScale("화면맞춤")
		img:setPosition("화면중앙")
		
		pini:AttachDisplay(img)
		vm:doNext()
	else
		pini:takeScreenShot(function(sprite)
			pini:ClearDisplay()
			pini:Scene():clear()

			pini:AttachDisplay(sprite)
			sprite:release()
			
			local shader = pini.Shader("transition.vsh", "transition.fsh")
			shader:bind(sprite)

			local img1 = pini.Sprite("transition1",scale)
			local img2 = pini.Sprite("transition2",path)

			shader:setUniformTexture("u_fadetex", img1)
			shader:setUniformTexture("u_disttex", img2)

			local threshold = 0
			local timer = nil
			timer = pini.Timer(pini:GetUUID(),0,function()
				shader:setUniformFloat("threshold",threshold)
				if threshold >= 1 then
					timer:stop()
				end
				threshold = threshold+0.005
			end,true)
			timer:run()

			vm:doNext()
		end)
	end
end

function LNX_SCENE_TRANSITION(vm,arg)
	pini.Scene() 
	vm:doNext()
end

function LNX_DIALOG_CONFIG(vm,arg)
	local id 		  = vm.variable["대화창수정.아이디"] 

	local margin	  = vm.variable["대화창수정.여백"] 
	local size 		  = vm.variable["대화창수정.영역"] 
	local pos 		  = vm.variable["대화창수정.위치"] 
	local color 	  = vm.variable["대화창수정.색상"] 
	local image 	  = vm.variable["대화창수정.이미지"]
	local fnt 		  = vm.variable["대화창수정.폰트"] 
	local fntcolor    = vm.variable["대화창수정.폰트색상"]
	local fntsize     = vm.variable["대화창수정.폰트크기"]
	
	local cursorImg   = vm.variable["대화창수정.커서이미지"]
	local cursorSize  = vm.variable["대화창수정.커서크기"]
	local cursorColor = vm.variable["대화창수정.커서색상"]
	
	local namepos 		= vm.variable["대화창수정.이름창위치"]
	local namesize 		= vm.variable["대화창수정.이름창영역"]
	local namecolor 	= vm.variable["대화창수정.이름창색상"]
	local nameimage 	= vm.variable["대화창수정.이름창이미지"]
	local namefntsize 	= vm.variable["대화창수정.이름창폰트크기"]
	local namefntcolor 	= vm.variable["대화창수정.이름창폰트색상"]
	local namefnt 		= vm.variable["대화창수정.이름창폰트"]

	local linkImg 		= vm.variable["대화창수정.연결이미지"]
	local linkColor		= vm.variable["대화창수정.연결색상"]
	local linkWidthFit	= vm.variable["대화창수정.연결넓이맞춤"]
	local linkSelectImg = vm.variable["대화창수정.연결선택시이미지"]

	if id then
		local config = pini.Dialog:config(id) or {}
		if pos then
			local s = pos:explode(",")
			config["x"] = tonumber(s[1] or config["x"])
			config["y"] = tonumber(s[2] or config["y"])
		end
		if size then
			local s = size:explode(",")
			config["width"] = tonumber(s[1] or config["width"])
			config["height"]= tonumber(s[2] or config["height"])
		end
		if color then
			local s = color:explode(",")
			config["background_color"] = {
				tonumber(s[1] or config["background_color"][1]),
				tonumber(s[2] or config["background_color"][2]),
				tonumber(s[3] or config["background_color"][3]),
				tonumber(s[4] or config["background_color"][4])
			}
		end
		if fntcolor then
			local s = fntcolor:explode(",")
			config["text_color"] = {
				tonumber(s[1] or config["text_color"][1]),
				tonumber(s[2] or config["text_color"][2]),
				tonumber(s[3] or config["text_color"][3]),
				tonumber(s[4] or config["text_color"][4])
			}
		end
		if margin then
			local s = margin:explode(",")
			config["marginX"] = tonumber(s[1] or config["marginX"])
			config["marginY"] = tonumber(s[2] or config["marginY"])
		end
		config["font"] = fnt or config["font"]
		config["path"] = image or config["path"]
		config["size"] = tonumber(fntsize or config["size"])

		-- name window!
		config["name"] = config["name"] or {}
		local nconfig = config["name"]
		if namepos then
			local s = namepos:explode(",")
			nconfig["x"] = tonumber(s[1] or nconfig["x"])
			nconfig["y"] = tonumber(s[2] or nconfig["y"])
		end
		if namesize then
			local s = namesize:explode(",")
			nconfig["width"] = tonumber(s[1] or nconfig["width"])
			nconfig["height"]= tonumber(s[2] or nconfig["height"])
		end
		if namecolor then
			local s = namecolor:explode(",")
			nconfig["background_color"] = {
				tonumber(s[1] or nconfig["background_color"][1]),
				tonumber(s[2] or nconfig["background_color"][2]),
				tonumber(s[3] or nconfig["background_color"][3]),
				tonumber(s[4] or nconfig["background_color"][4])
			}
		end
		if namefntcolor then
			local s = namefntcolor:explode(",")
			nconfig["text_color"] = {
				tonumber(s[1] or nconfig["text_color"][1]),
				tonumber(s[2] or nconfig["text_color"][2]),
				tonumber(s[3] or nconfig["text_color"][3]),
				tonumber(s[4] or nconfig["text_color"][4])
			}
		end
		nconfig["font"] = namefnt or nconfig["font"]
		nconfig["path"] = nameimage or nconfig["path"]
		nconfig["text_size"] = tonumber(namefntsize or nconfig["text_size"])

		--link block
		config["linkBlock"] = config["linkBlock"] or {}
		bconfig = config["linkBlock"]
		if linkColor then
			local s = linkColor:explode(",")
			bconfig["color"] = {
				tonumber(s[1] or bconfig["color"][1]),
				tonumber(s[2] or bconfig["color"][2]),
				tonumber(s[3] or bconfig["color"][3]),
				tonumber(s[4] or bconfig["color"][4])
			}
		end
		if linkWidthFit then
			bconfig["fitWidth"] = linkWidthFit == "예" 
		end
		bconfig["select"] = linkSelectImg or bconfig["select"]
		bconfig["unselect"] = linkImg or bconfig["unselect"]
		
		pini.Dialog:SetConfig(id,config);
	end

	for k,v in pairs(vm.variable) do 
		if k:startsWith("대화창수정.") then
			vm.variable[k] = nil
		end	
	end

	vm:doNext()
end

local ret = function(LanXVM)
	if OnPreview then
		LanXVM.unuse_goto = true;
	end
	pini.Dialog:SetConfig("독백",{
		x=10,
		y=WIN_HEIGHT-10,
		width=WIN_WIDTH-20,
		height=WIN_HEIGHT-20,
		background_color={60,60,60,122},
		text_color={255,255,255,255},
		cursor={
			width=20,
			height=10,
			color={255,255,255,255},
			sprite=nil,
			anim=pini.Anim.Sequence(pini.Anim.FadeTo(0.5,100),pini.Anim.FadeTo(0.5,255))
		}
		--[[,
		linkBlock={
			color={255,255,255,255},
			select="select.png",
			unselect="unselect.png",
			fitWidth=true,
			anim=pini.Anim.Sequence(pini.Anim.FadeTo(0.5,100),pini.Anim.FadeTo(0.5,255))
		}]]
	})
	pini.Dialog:SetConfig("대화",{
		x=10,
		y=WIN_HEIGHT-10,
		width=WIN_WIDTH-20,
		height=250,
		background_color={60,60,60,122},
		text_color={255,255,255,255},
--		path="textArea.png",
		cursor={
			width=20,
			height=10,
			color={255,255,255,255},
			sprite=nil,
			anim=pini.Anim.Sequence(pini.Anim.FadeTo(0.5,100),pini.Anim.FadeTo(0.5,255))
		},
		name={
			x=10,
			y=WIN_HEIGHT-270,
			background_color={60,60,60,122},
			text_color={255,255,255,255},
			text_size=30,
			text_align="화면중앙",
		}--[[,
		linkBlock={
			color={255,255,255,60},
			select="select.png",
			unselect="unselect.png",
			fitWidth=false,
			anim=pini.Anim.Sequence(pini.Anim.FadeTo(0.5,100),pini.Anim.FadeTo(0.5,255))
		}]]
	})

	LNX_SCENE_TRANSITION(LanXVM)
end
return ret