fs_animation={}
fs_ease={}

fs_ease["사인인"] = function(a) return cc.EaseSineIn:create(a) end
fs_ease["사인아웃"] = function(a) return cc.EaseSineOut:create(a) end
fs_ease["사인인아웃"] = function(a) return cc.EaseSineInOut:create(a) end
fs_ease["바운스인"] = function(a) return cc.EaseBounceIn:create(a) end
fs_ease["바운스아웃"] = function(a) return cc.EaseBounceOut:create(a) end
fs_ease["바운스인아웃"] = function(a) return cc.EaseBounceInOut:create(a) end
fs_ease["백인"] = function(a) return cc.EaseBackIn:create(a) end
fs_ease["백아웃"] = function(a) return cc.EaseBackOut:create(a) end
fs_ease["백인아웃"] = function(a) return cc.EaseBackInOut:create(a) end
fs_ease["엘라스틱인"] = function(a) return cc.EaseElasticIn:create(a) end
fs_ease["엘라스틱아웃"] = function(a) return cc.EaseElasticOut:create(a) end
fs_ease["엘라스틱인아웃"] = function(a) return cc.EaseElasticInOut:create(a) end

function posStrToPt(pos)
    local winSize = cc.Director:getInstance():getVisibleSize()
	local pos = pos:explode(",")
	return cc.p(tonumber(pos[1]),winSize.height-tonumber(pos[2]))
end

fs_animation["이동"] = {
	"위치=\"0,0\" 시간=\"1\" 가속=\"\" ",
	function(vm,node)
		local pos = vm.variable["애니메이션.위치"] or "0,0"
		local sec = vm.variable["애니메이션.시간"] or 1
		local ease = vm.variable["애니메이션.가속"] or ""
		local rep = vm.variable["애니메이션.지속"] or "아니오"

		local action = cc.MoveTo:create(sec,posStrToPt(pos))

		if fs_ease[ease] then
			action = fs_ease[ease](action)
		end

		node:runAction(action)
	end
}

fs_animation["회전"] = {
	"각도=\"90\" 시간=\"1\" 가속=\"\" ",
	function(vm,node)
		local rot = vm.variable["애니메이션.각도"] or 0
		local sec = vm.variable["애니메이션.시간"] or 1
		local ease = vm.variable["애니메이션.가속"] or ""
		local rep = vm.variable["애니메이션.지속"] or "아니오"

		local action = cc.RotateTo:create(sec,rot)

		if fs_ease[ease] then
			action = fs_ease[ease](action)
		end
		if rep == "예" then
			action = cc.Repeat:create(action,999)
		end
		node:runAction(action)
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

		local psx
		local psy
		psx,psy = nodeParentsScale(node:getParent())

		local origin = node:getContentSize()
		local sx = size[1] / origin.width / psx
		local sy = size[2] / origin.height / psy

		local action = cc.ScaleTo:create(sec,sx,sy)

		if fs_ease[ease] then
			action = fs_ease[ease](action)
		end
		if rep == "예" then
			action = cc.RepeatForever:create(action)
		end
		node:runAction(action)
	end
}

fs_animation["점프"] = {
	"위치=\"100,0\" 횟수=\"1\" 높이=\"\" 시간=\"1\" 가속=\"\"",
	function(vm,node)
		local pos = vm.variable["애니메이션.위치"] or "0,0"
		local count = vm.variable["애니메이션.횟수"] or 0
		local height = vm.variable["애니메이션.높이"] or 0
		local sec = vm.variable["애니메이션.시간"] or 1
		local ease = vm.variable["애니메이션.가속"] or ""

		local action = cc.JumpTo:create(sec,posStrToPt(pos),height,count)

		if fs_ease[ease] then
			action = fs_ease[ease](action)
		end
		if rep == "예" then
			action = cc.RepeatForever:create(action)
		end
		node:runAction(action)
	end
}

fs_animation["투명"] = {
	"투명=\"1\" 시간=\"1\" 가속=\"\"",
	function(vm,node)
		local fade = vm.variable["애니메이션.투명"] or 1
		local sec = vm.variable["애니메이션.시간"] or 1
		local ease = vm.variable["애니메이션.가속"] or ""

		fade = fade*255
		local action = cc.FadeTo:create(sec,fade)

		if fs_ease[ease] then
			action = fs_ease[ease](action)
		end
		if rep == "예" then
			action = cc.RepeatForever:create(action)
		end
		node:runAction(action)
	end
}

fs_animation["블링크"] = {
	"횟수=\"5\" 시간=\"1\" 가속=\"\"",
	function(vm,node)
		local count = vm.variable["애니메이션.횟수"] or 1
		local sec = vm.variable["애니메이션.시간"] or 1
		local ease = vm.variable["애니메이션.가속"] or ""

		local action = cc.Blink:create(sec,count)

		if fs_ease[ease] then
			action = fs_ease[ease](action)
		end
		if rep == "예" then
			action = cc.RepeatForever:create(action)
		end
		node:runAction(action)
	end
}

fs_animation["색상"] = {
	"색상=\"255,255,255\" 시간=\"1\" 가속=\"\"",
	function(vm,node)
		local color = vm.variable["애니메이션.색상"] or "255,255,255"
		local sec = vm.variable["애니메이션.시간"] or 1
		local ease = vm.variable["애니메이션.가속"] or ""

		color = color:explode(",")
		local action = cc.TintTo:create(sec,color[1],color[2],color[3])

		if fs_ease[ease] then
			action = fs_ease[ease](action)
		end
		if rep == "예" then
			action = cc.RepeatForever:create(action)
		end
		node:runAction(action)
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
			local a = cc.Sequence:create(
				cc.MoveBy:create(sec/(4*count),cc.p(0,width/2)),
				cc.MoveBy:create(sec/(4*count),cc.p(0,-width/2)),
				cc.MoveBy:create(sec/(4*count),cc.p(0,-width/2)),
				cc.MoveBy:create(sec/(4*count),cc.p(0,width/2))
			)
			if action then
				action = cc.Sequence:create(action,a)
			else
				action = a
			end
		end

		if fs_ease[ease] then
			action = fs_ease[ease](action)
		end
		if rep == "예" then
			action = cc.RepeatForever:create(action)
		end
		node:runAction(action)
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
			local a = cc.Sequence:create(
				cc.MoveBy:create(sec/(4*count),cc.p(width/2,0)),
				cc.MoveBy:create(sec/(4*count),cc.p(-width/2,0)),
				cc.MoveBy:create(sec/(4*count),cc.p(-width/2,0)),
				cc.MoveBy:create(sec/(4*count),cc.p(width/2,0))
			)
			if action then
				action = cc.Sequence:create(action,a)
			else
				action = a
			end
		end

		if fs_ease[ease] then
			action = fs_ease[ease](action)
		end
		if rep == "예" then
			action = cc.RepeatForever:create(action)
		end
		node:runAction(action)
	end
}

fs_animation["떨림"] = {
	"폭=\"4\" 시간=\"1\" 가속=\"\"",
	function(vm,node)
		local width = vm.variable["애니메이션.폭"] or 1
		local sec = vm.variable["애니메이션.시간"] or 1
		local ease = vm.variable["애니메이션.가속"] or ""

		local actions = {}

		local x,y = node:getPosition()

		local scheduler = cc.Director:getInstance():getScheduler()
		local scheduleEntry
		local scheduleEntry1
		scheduleEntry = scheduler:scheduleScriptFunc(function()
			local dx = math.random()*width - width/2
			local dy = math.random()*width - width/2
			node:setPosition(dx+x,dy+y)
		end, 0, false)
		scheduleEntry1 = scheduler:scheduleScriptFunc(function()
			scheduler:unscheduleScriptEntry(scheduleEntry)
			scheduler:unscheduleScriptEntry(scheduleEntry1)
			node:setPosition(x,y)
		end, sec, false)

	end
}