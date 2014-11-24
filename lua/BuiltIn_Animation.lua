fs_animation={}
fs_ease={}

fs_ease["사인인"] = function(a) return pini.Anim.EaseSineIn(a) end
fs_ease["사인아웃"] = function(a) return pini.Anim.EaseSineOut(a) end
fs_ease["사인인아웃"] = function(a) return pini.Anim.EaseSineInOut(a) end
fs_ease["바운스인"] = function(a) return pini.Anim.EaseBounceIn(a) end
fs_ease["바운스아웃"] = function(a) return pini.Anim.EaseBounceOut(a) end
fs_ease["바운스인아웃"] = function(a) return pini.Anim.EaseBounceInOut(a) end
fs_ease["백인"] = function(a) return pini.Anim.EaseBackIn(a) end
fs_ease["백아웃"] = function(a) return pini.Anim.EaseBackOut(a) end
fs_ease["백인아웃"] = function(a) return pini.Anim.EaseBackInOut(a) end
fs_ease["엘라스틱인"] = function(a) return pini.Anim.EaseElasticIn(a) end
fs_ease["엘라스틱아웃"] = function(a) return pini.Anim.EaseElasticOut(a) end
fs_ease["엘라스틱인아웃"] = function(a) return pini.Anim.EaseElasticInOut(a) end

local function posStrToPt(pos)
    local winSize = {width=WIN_WIDTH,height=WIN_HEIGHT}--cc.Director:getInstance():getVisibleSize()
	local pos = pos:explode(",")
	--if OnPreview then
		return tonumber(pos[1] or 0),tonumber(pos[2] or 0)
	--else
	--	return tonumber(pos[1] or 0),winSize.height-tonumber(pos[2] or 0)
	--end
end

fs_animation["이동"] = {
	"위치=\"0,0\" 시간=\"1\" 가속=\"\" ",
	function(vm,node)
		local pos = vm.variable["애니메이션.위치"] or "0,0"
		local sec = vm.variable["애니메이션.시간"] or 1
		local ease = vm.variable["애니메이션.가속"] or ""
		local rep = vm.variable["애니메이션.지속"] or "아니오"

		local x,y = posStrToPt(pos)
		local action = pini.Anim.MoveTo(sec,x,y)

		if fs_ease[ease] then
			action = fs_ease[ease](action)
		end

		action:run(node)
	end
}

fs_animation["회전"] = {
	"각도=\"90\" 시간=\"1\" 가속=\"\" ",
	function(vm,node)
		local rot = vm.variable["애니메이션.각도"] or 0
		local sec = vm.variable["애니메이션.시간"] or 1
		local ease = vm.variable["애니메이션.가속"] or ""
		local rep = vm.variable["애니메이션.지속"] or "아니오"

		local action = pini.Anim.RotateTo(sec,rot)

		if fs_ease[ease] then
			action = fs_ease[ease](action)
		end
		if rep == "예" then
			--action = cc.Repeat:create(action,999)
		end
		action:run(node)
	end
}

fs_animation["크기"] = {
	"크기=\"100,100\" 시간=\"1\" 가속=\"\" ",
	function(vm,node)
		local size = vm.variable["애니메이션.크기"] or "100,100"
		local sec = vm.variable["애니메이션.시간"] or 1
		local ease = vm.variable["애니메이션.가속"] or ""
		local rep = vm.variable["애니메이션.지속"] or "아니오"
		
		local size = size:explode(",")
		local action = pini.Anim.ScaleTo(sec,tonumber(size[1]),tonumber(size[2]))

		if fs_ease[ease] then
			action = fs_ease[ease](action)
		end
		if rep == "예" then
			--action = cc.RepeatForever:create(action)
		end
		action:run(node)
	end
}

fs_animation["점프"] = {
	"위치=\"100,0\" 횟수=\"1\" 높이=\"50\" 시간=\"1\" 가속=\"\"",
	function(vm,node)
		local pos = vm.variable["애니메이션.위치"] or "0,0"
		local count = vm.variable["애니메이션.횟수"] or 0
		local height = vm.variable["애니메이션.높이"] or 0
		local sec = vm.variable["애니메이션.시간"] or 1
		local ease = vm.variable["애니메이션.가속"] or ""
		
		local x,y = posStrToPt(pos)
		local action = pini.Anim.JumpTo(sec,x,y,height,count)

		if fs_ease[ease] then
			action = fs_ease[ease](action)
		end
		if rep == "예" then
			--action = cc.RepeatForever:create(action)
		end
		action:run(node)
	end
}

fs_animation["투명"] = {
	"투명=\"1\" 시간=\"1\" 가속=\"\"",
	function(vm,node)
		local fade = vm.variable["애니메이션.투명"] or 1
		local sec = vm.variable["애니메이션.시간"] or 1
		local ease = vm.variable["애니메이션.가속"] or ""

		fade = fade*255
		local action = pini.Anim.FadeTo(sec,fade)

		if fs_ease[ease] then
			action = fs_ease[ease](action)
		end
		if rep == "예" then
			--action = cc.RepeatForever:create(action)
		end
		action:run(node)
	end
}

fs_animation["블링크"] = {
	"횟수=\"5\" 시간=\"1\" 가속=\"\"",
	function(vm,node)
		local count = vm.variable["애니메이션.횟수"] or 1
		local sec = vm.variable["애니메이션.시간"] or 1
		local ease = vm.variable["애니메이션.가속"] or ""

		local action = pini.Anim.Blink(sec,count)

		if fs_ease[ease] then
			action = fs_ease[ease](action)
		end
		if rep == "예" then
			--action = cc.RepeatForever:create(action)
		end
		action:run(node)
	end
}

fs_animation["색상"] = {
	"색상=\"255,255,255\" 시간=\"1\" 가속=\"\"",
	function(vm,node)
		local color = vm.variable["애니메이션.색상"] or "255,255,255"
		local sec = vm.variable["애니메이션.시간"] or 1
		local ease = vm.variable["애니메이션.가속"] or ""

		color = color:explode(",")
		local action = pini.Anim.TintTo(sec,tonumber(color[1] or 255),
											tonumber(color[2] or 255),
											tonumber(color[3] or 255))

		if fs_ease[ease] then
			action = fs_ease[ease](action)
		end
		if rep == "예" then
			--action = cc.RepeatForever:create(action)
		end
		action:run(node)
	end
}

fs_animation["상하흔들기"] = {
	"폭=\"50\" 횟수=\"1\" 시간=\"1\" 가속=\"\"",
	function(vm,node)
		local width = vm.variable["애니메이션.폭"] or 1
		local count = vm.variable["애니메이션.횟수"] or 1
		local sec = vm.variable["애니메이션.시간"] or 1
		local ease = vm.variable["애니메이션.가속"] or ""

		local action = nil
		for i=1,count,1 do 
			local a = pini.Anim.Sequence(
				pini.Anim.MoveBy(sec/(4*count),0,width/2),
				pini.Anim.MoveBy(sec/(4*count),0,-width/2),
				pini.Anim.MoveBy(sec/(4*count),0,-width/2),
				pini.Anim.MoveBy(sec/(4*count),0,width/2)
			)
			if action then
				action = pini.Anim.Sequence(action,a)
			else
				action = a
			end
		end

		if fs_ease[ease] then
			action = fs_ease[ease](action)
		end
		if rep == "예" then
			--action = cc.RepeatForever:create(action)
		end
		action:run(node)
	end
}

fs_animation["좌우흔들기"] = {
	"폭=\"50\" 횟수=\"1\" 시간=\"1\" 가속=\"\"",
	function(vm,node)
		local width = vm.variable["애니메이션.폭"] or 1
		local count = vm.variable["애니메이션.횟수"] or 1
		local sec = vm.variable["애니메이션.시간"] or 1
		local ease = vm.variable["애니메이션.가속"] or ""

		local action = nil
		for i=1,count,1 do 
			local a = pini.Anim.Sequence(
				pini.Anim.MoveBy(sec/(4*count),width/2,0),
				pini.Anim.MoveBy(sec/(4*count),-width/2,0),
				pini.Anim.MoveBy(sec/(4*count),-width/2,0),
				pini.Anim.MoveBy(sec/(4*count),width/2,0)
			)
			if action then
				action = pini.Anim.Sequence(action,a)
			else
				action = a
			end
		end

		if fs_ease[ease] then
			action = fs_ease[ease](action)
		end
		if rep == "예" then
			--action = cc.RepeatForever:create(action)
		end
		action:run(node)
	end
}

fs_animation["떨림"] = {
	"폭=\"4\" 시간=\"1\" 가속=\"\"",
	function(vm,node)
		local width = vm.variable["애니메이션.폭"] or 1
		local sec = vm.variable["애니메이션.시간"] or 1
		local ease = vm.variable["애니메이션.가속"] or ""

		local actions = {}
		local x,y = node:position()

		local t1,t2
		t1=pini.Timer(pini:GetUUID(),0,function()
			local dx = math.random()*width - width/2
			local dy = math.random()*width - width/2
			node:setPosition(dx+x,dy+y)
		end,true)
		t2=pini.Timer(pini:GetUUID(),sec,function()
			t1:stop()
			t2:stop()
			node:setPosition(x,y)
			t1 = nil
			t2 = nil
		end,true)
	end
}

fs_animation["걷기"] = {
	"폭=\"40\" 횟수=\"5\" 확대=\"1.3,1.3\" 시간=\"1\" 가속=\"\"",
	function(vm,node)
		local width = vm.variable["애니메이션.폭"] or 1
		local count = vm.variable["애니메이션.횟수"] or 1
		local sec = vm.variable["애니메이션.시간"] or 1
		local ease = vm.variable["애니메이션.가속"] or ""
		local scale = vm.variable["애니메이션.확대"] or ""

		local action = nil
		for i=1,count,1 do 
			local a = pini.Anim.Sequence(
				pini.Anim.MoveBy(sec/(2*count),0,width/2),
				pini.Anim.MoveBy(sec/(2*count),0,-width/2)
			)
			if action then
				action = pini.Anim.Sequence(action,a)
			else
				action = a
			end
		end

		scale = scale:explode(",")

		action = pini.Anim.Spawn(
			pini.Anim.ScaleBy(sec,tonumber(scale[1]) or 1.3,tonumber(scale[2])or 1.3),
			action
		)

		if fs_ease[ease] then
			action = fs_ease[ease](action)
		end
		if rep == "예" then
			--action = cc.RepeatForever:create(action)
		end
		action:run(node)
	end
}