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
		if id:len() > 0 and nodes[id] then
			local v = nodes[id]
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
				--[[
				parent = v:getParent()
				if parent == scene.layer then
					parent = nil
				end
				]]
			end
		end
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
	vm:doNext()
end

function LNX_MONOLOG(vm,arg)
	local forceOn = vm.variable["독백.유지"] or "아니오"
	local arg = vm.variable["system.arg"]

	--print(">LNX_MONOLOG")
	--print(print_r(arg))

	pini.Dialog:setKeep(forceOn=="예")
	pini.Dialog:setName(nil)
	pini.Dialog:UseConfig("독백")
	pini.Dialog:Run(vm,arg["targ"])
end

function LNX_DIALOG(vm,arg)
	local name = vm.variable["대화.이름"] or ""
	local forceOn = vm.variable["대화.유지"] or "아니오"
	local arg = vm.variable["system.arg"]

	--vm:showCallStack()
	--print(">LNX_DIALOG")
	--print(print_r(arg))

	name = tostring(name)
	if name:len() > 0 then
		pini.Dialog:setName(name)
	else
		pini.Dialog:setName(nil)
	end
	pini.Dialog:setKeep(forceOn=="예")
	pini.Dialog:UseConfig("대화")
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
	
	--[[
	node = nodes[id] or systemNode[id]
	if node and fs_animation[t] then
		fs_animation[t][2](vm,node)
	end
	]]
	vm:doNext()
end

function LNX_RETURN(vm,arg)
	vm:_return()
end

function LNX_STOP(vm,arg)
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

	local glprogramstate = cc.GLProgramState:getOrCreateWithGLProgram(program);
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

function LNX_SCENE_TRANSITION(vm,arg)
	pini.Scene()
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
		link_color={255,255,255,60},
		cursor={
			width=20,
			height=10,
			color={255,255,255,255},
			sprite=nil,
			anim=pini.Anim.Sequence(pini.Anim.FadeTo(0.5,100),pini.Anim.FadeTo(0.5,255))
		}
	})
	pini.Dialog:SetConfig("대화",{
		x=10,
		y=WIN_HEIGHT-10,
		width=WIN_WIDTH-20,
		height=250,
		background_color={60,60,60,122},
		text_color={255,255,255,255},
		link_color={255,255,255,60},
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
		}
	})

	LNX_SCENE_TRANSITION(LanXVM)
end
return ret