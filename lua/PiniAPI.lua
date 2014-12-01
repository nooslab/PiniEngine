require("trycatch")
if OnPreview then
else
	require("AudioEngine") 
end

function class(base, init)
	local c = {}	 -- a new class instance
	if not init and type(base) == 'function' then
		init = base
		base = nil
	elseif type(base) == 'table' then
		for i,v in pairs(base) do
			c[i] = v
		end
		c._base = base
	end
	c.__index = c

	local mt = {}
	mt.__call = function(class_tbl, ...)
		local obj = {}
		setmetatable(obj,c)
		if init then
			init(obj,...)
		elseif class_tbl.init then
			class_tbl.init(obj,...)
		else 
			if base and base.init then
			base.init(obj, ...)
			end
		end
		return obj
	end
	c.init = init
	c.is_a = function(self, klass)
		local m = getmetatable(self)
		while m do 
			if m == klass then return true end
			m = m._base
		end
		return false
	end
	setmetatable(c, mt)
	return c
end

---------------------------------------------
-- PINI API 
---------------------------------------------

---------------------------------------------------------------
--위치 선정
---------------------------------------------------------------
fs_position={}
fs_size = {}
---------------------------------------------------------------
fs_position["왼쪽상단"]=function(w,sx,sy)
	return {sx/2,sy/2}
end
fs_position["오른쪽상단"]=function(w,sx,sy)
	return {w.width-sx/2,sy/2}
end
fs_position["화면중앙"]=function(w,sx,sy)
	return {w.width/2,w.height/2}
end
fs_position["왼쪽하단"]=function(w,sx,sy)
	return {sx/2,w.height-sy/2}
end
fs_position["오른쪽하단"]=function(w,sx,sy)
	return {w.width-sx/2,w.height-sy/2}
end
fs_position["100,100"]=nil
fs_position["200,200"]=nil
fs_position["300,300"]=nil

---------------------------------------------------------------
--사이즈 선정
---------------------------------------------------------------

fs_size["원본크기"]=function(w,sx,sy)
	return {1,1}
end
fs_size["두배"]=function(w,sx,sy)
	return {2,2}
end
fs_size["화면맞춤"]=function(w,sx,sy)
	return {w.width/sx,w.height/sy}
end

---------------------------------------------------------------
--이미지 등장 효과 관리
---------------------------------------------------------------
fs_imageEffect = {}
fs_imageDeleteEffect = {}
---------------------------------------------------------------
fs_imageEffect["페이드"]=function(node,sec)
	node:setOpacity(0)
	local action = pini.Anim.FadeTo(sec,255)
	action:run(node)
end
fs_imageEffect["업페이드"]=function(node,sec)
	local x,y
	x,y = node:position()
	node:setPosition(x,y+10)
	node:setOpacity(0)
	local action = pini.Anim.Spawn(
		pini.Anim.MoveBy(sec,0,-10),
		pini.Anim.FadeTo(sec,255)
	)
	action:run(node)
end
fs_imageEffect["다운페이드"]=function(node,sec)
	local x,y
	x,y = node:position()
	node:setPosition(x,y+10)
	node:setOpacity(0)
	local action = pini.Anim.Spawn(
		pini.Anim.MoveBy(sec,0,-10),
		pini.Anim.FadeTo(sec,255)
	)
	action:run(node)
end
fs_imageEffect["줌인페이드"]=function(node,sec)
	local x,y
	x,y = node:scale()
	node:setScale(x-0.1,y-0.1)
	node:setOpacity(0)
	local action = pini.Anim.Spawn(
		pini.Anim.ScaleTo(sec,x,y),
		pini.Anim.FadeTo(sec,255)
	)
	action:run(node)
end
fs_imageEffect["줌아웃페이드"]=function(node,sec)
	local x,y
	x,y = node:scale()
	node:setScale(x+0.1,y+0.1)
	node:setOpacity(0)
	local action = pini.Anim.Spawn(
		pini.Anim.ScaleTo(sec,x,y),
		pini.Anim.FadeTo(sec,255)
	)
	action:run(node)
end

---------------------------------------------------------------
--이미지 퇴장 효과 관리
---------------------------------------------------------------
fs_imageDeleteEffect["페이드"]=function(node,sec)
	local action = pini.Anim.FadeTo(sec,0)
	action:run(node)
end
fs_imageDeleteEffect["업페이드"]=function(node,sec)
	local action = pini.Anim.Spawn(
		pini.Anim.MoveBy(sec,0,10),
		pini.Anim.FadeTo(sec,0)
	)
	action:run(node)
end
fs_imageDeleteEffect["다운페이드"]=function(node,sec)
	local action = pini.Anim.Spawn(
		pini.Anim.MoveBy(sec,0,-10),
		pini.Anim.FadeTo(sec,0)
	)
	action:run(node)
end
fs_imageDeleteEffect["줌인페이드"]=function(node,sec)
	local x,y
	x,y = node:scale()
	local action = pini.Anim.Spawn(
		pini.Anim.ScaleTo(sec,x-0.1,y-0.1),
		pini.Anim.FadeTo(sec,0)
	)
	action:run(node)
end
fs_imageDeleteEffect["줌아웃페이드"]=function(node,sec)
	local x,y
	x,y = node:scale()
	local action = pini.Anim.Spawn(
		pini.Anim.ScaleTo(sec,x+0.1,y+0.1),
		pini.Anim.FadeTo(sec,0)
	)
	action:run(node)
end

---------------------------------------------
-- Animation
---------------------------------------------
local MoveBy = class()
function MoveBy:init(sec,x,y)
	self.x = x
	if OnPreview then
		self.y = y
	else
		self.y = -y
	end
	self.sec = sec
end
function MoveBy:cocosObj()
	return cc.MoveBy:create(self.sec,cc.p(self.x,self.y))
end
function MoveBy:run(node)
	if OnPreview then
		local x,y
		x,y = node:position()
		node:setPosition(self.x+x,self.y+y)
	else
		node.node:runAction(self:cocosObj())
	end
end
---------------------------------------------
local MoveTo = class()
function MoveTo:init(sec,x,y)
	self.x = x
	if OnPreview then
		self.y = y
	else
		self.y = WIN_HEIGHT-y
	end
	self.sec = sec
end
function MoveTo:cocosObj()
	return cc.MoveTo:create(self.sec,cc.p(self.x,self.y))
end
function MoveTo:run(node)
	if OnPreview then
		node:setPosition(self.x,self.y)
	else
		node.node:runAction(self:cocosObj())
	end
end
---------------------------------------------
local RotateTo = class()
function RotateTo:init(sec,rot)
	self.sec = sec
	self.rot = rot
end
function RotateTo:cocosObj()
	return cc.RotateTo:create(self.sec,self.rot)
end
function RotateTo:run(node)
	if OnPreview then
		node:setRotate(self.rot)
	else
		node.node:runAction(self:cocosObj())
	end
end
---------------------------------------------
local FadeTo = class()
function FadeTo:init(sec,op)
	self.opacity = op
	self.sec = sec
end
function FadeTo:cocosObj()
	return cc.FadeTo:create(self.sec,self.opacity)
end
function FadeTo:run(node)
	if OnPreview then
		node:setOpacity(self.opacity)
	else
		node.node:runAction(self:cocosObj())
	end
end
---------------------------------------------
local ScaleTo= class()
function ScaleTo:init(sec,x,y)
	self.x = x
	self.y = y
	self.sec = sec
end
function ScaleTo:cocosObj()
	return cc.ScaleTo:create(self.sec,self.x,self.y)
end
function ScaleTo:run(node)
	if OnPreview then
		node:setScale(self.x,self.y)
	else
		node.node:runAction(self:cocosObj())
	end
end
---------------------------------------------
local ScaleBy=class()
function ScaleBy:init(sec,x,y)
	self.x = x
	self.y = y
	self.sec = sec
end
function ScaleBy:cocosObj()
	return cc.ScaleBy:create(self.sec,self.x,self.y)
end
function ScaleBy:run(node)
	if OnPreview then
		local x,y
		x,y = node:scale()
		node:setScale(x*self.x,y*self.y)
	else
		node.node:runAction(self:cocosObj())
	end
end
---------------------------------------------
local Spawn=class()
function Spawn:init(...)
	self.list = {...}
end
function Spawn:cocosObj()
	local _list = {}
	for k,v in ipairs(self.list) do
		table.insert(_list,v:cocosObj())
	end
	return cc.Spawn:create(unpack(_list))
end
function Spawn:run(node)
	if OnPreview then
		for i,v in ipairs(self.list) do
			v:run(node)
		end
	else
		node.node:runAction(self:cocosObj())
	end
end
---------------------------------------------
local Sequence=class()
function Sequence:init(...)
	self.list = {...}
end
function Sequence:cocosObj()
	local _list = {}
	for k,v in ipairs(self.list) do
		table.insert(_list,v:cocosObj())
	end
	return cc.Sequence:create(unpack(_list))
end
function Sequence:run(node)
	if OnPreview then
		for i,v in ipairs(self.list) do
			v:run(node)
		end
	else
		node.node:runAction(self:cocosObj())
	end
end
---------------------------------------------
local TintTo=class()
function TintTo:init(sec,r,g,b)
	self.r = r
	self.g = g
	self.b = b
	self.sec = sec
end
function TintTo:cocosObj()
	return cc.TintTo:create(self.sec,self.r,self.g,self.b)
end
function TintTo:run(node)
	if OnPreview then
		node:setColor(self.r,self.g,self.b)
	else
		node.node:runAction(self:cocosObj())
	end
end
---------------------------------------------
local JumpTo=class()
function JumpTo:init(sec,x,y,height,count)
	self.x = x
	if OnPreview then
		self.y = y
	else
		self.y = WIN_HEIGHT-y
	end
	self.h = height
	self.c = count
	self.sec = sec
end
function JumpTo:cocosObj()
	return cc.JumpTo:create(self.sec,cc.p(self.x,self.y),self.h,self.c)
end
function JumpTo:run(node)
	if OnPreview then
		node:setPosition(self.x,self.y)
	else
		node.node:runAction(self:cocosObj())
	end
end
---------------------------------------------
local Blink=class()
function Blink:init(sec,count)
	self.sec = sec
	self.c = count
end
function Blink:cocosObj()
	return cc.Blink:create(self.sec,self.c)
end
function Blink:run(node)
	if OnPreview then
	else
		node.node:runAction(self:cocosObj())
	end
end
---------------------------------------------
local Forever=class()
function Forever:init(action)
	self.action = action
end
function Forever:cocosObj()
	return cc.RepeatForever:create(self.action:cocosObj())
end
function Forever:run(node)
	if OnPreview then
		self.action:run(node)
	else
		node.node:runAction(self:cocosObj())
	end
end
---------------------------------------------
local EaseSineIn=class()
function EaseSineIn:init(action)
	self.action = action
end
function EaseSineIn:cocosObj()
	return cc.EaseSineIn:create(self.action:cocosObj())
end
function EaseSineIn:run(node)
	if OnPreview then
		self.action:run(node)
	else
		node.node:runAction(self:cocosObj())
	end
end
---------------------------------------------
local EaseSineOut=class()
function EaseSineOut:init(action)
	self.action = action
end
function EaseSineOut:cocosObj()
	return cc.EaseSineOut:create(self.action:cocosObj())
end
function EaseSineOut:run(node)
	if OnPreview then
		self.action:run(node)
	else
		node.node:runAction(self:cocosObj())
	end
end
---------------------------------------------
local EaseSineInOut=class()
function EaseSineInOut:init(action)
	self.action = action
end
function EaseSineInOut:cocosObj()
	return cc.EaseSineInOut:create(self.action:cocosObj())
end
function EaseSineInOut:run(node)
	if OnPreview then
		self.action:run(node)
	else
		node.node:runAction(self:cocosObj())
	end
end
---------------------------------------------
local EaseBounceIn=class()
function EaseBounceIn:init(action)
	self.action = action
end
function EaseBounceIn:cocosObj()
	return cc.EaseBounceIn:create(self.action:cocosObj())
end
function EaseBounceIn:run(node)
	if OnPreview then
		self.action:run(node)
	else
		node.node:runAction(self:cocosObj())
	end
end
---------------------------------------------
local EaseBounceOut=class()
function EaseBounceOut:init(action)
	self.action = action
end
function EaseBounceOut:cocosObj()
	return cc.EaseBounceOut:create(self.action:cocosObj())
end
function EaseBounceOut:run(node)
	if OnPreview then
		self.action:run(node)
	else
		node.node:runAction(self:cocosObj())
	end
end
---------------------------------------------
local EaseBounceInOut=class()
function EaseBounceInOut:init(action)
	self.action = action
end
function EaseBounceInOut:cocosObj()
	return cc.EaseBounceInOut:create(self.action:cocosObj())
end
function EaseBounceInOut:run(node)
	if OnPreview then
		self.action:run(node)
	else
		node.node:runAction(self:cocosObj())
	end
end
---------------------------------------------
local EaseBackIn=class()
function EaseBackIn:init(action)
	self.action = action
end
function EaseBackIn:cocosObj()
	return cc.EaseBackIn:create(self.action:cocosObj())
end
function EaseBackIn:run(node)
	if OnPreview then
		self.action:run(node)
	else
		node.node:runAction(self:cocosObj())
	end
end
---------------------------------------------
local EaseBackOut=class()
function EaseBackOut:init(action)
	self.action = action
end
function EaseBackOut:cocosObj()
	return cc.EaseBackOut:create(self.action:cocosObj())
end
function EaseBackOut:run(node)
	if OnPreview then
		self.action:run(node)
	else
		node.node:runAction(self:cocosObj())
	end
end
---------------------------------------------
local EaseBackInOut=class()
function EaseBackInOut:init(action)
	self.action = action
end
function EaseBackInOut:cocosObj()
	return cc.EaseBackInOut:create(self.action:cocosObj())
end
function EaseBackInOut:run(node)
	if OnPreview then
		self.action:run(node)
	else
		node.node:runAction(self:cocosObj())
	end
end
---------------------------------------------
local EaseElasticIn=class()
function EaseElasticIn:init(action)
	self.action = action
end
function EaseElasticIn:cocosObj()
	return cc.EaseElasticIn:create(self.action:cocosObj())
end
function EaseElasticIn:run(node)
	if OnPreview then
		self.action:run(node)
	else
		node.node:runAction(self:cocosObj())
	end
end
---------------------------------------------
local EaseElasticOut=class()
function EaseElasticOut:init(action)
	self.action = action
end
function EaseElasticOut:cocosObj()
	return cc.EaseElasticOut:create(self.action:cocosObj())
end
function EaseElasticOut:run(node)
	if OnPreview then
		self.action:run(node)
	else
		node.node:runAction(self:cocosObj())
	end
end
---------------------------------------------
local EaseElasticInOut=class()
function EaseElasticInOut:init(action)
	self.action = action
end
function EaseElasticInOut:cocosObj()
	return cc.EaseElasticInOut:create(self.action:cocosObj())
end
function EaseElasticInOut:run(node)
	if OnPreview then
		self.action:run(node)
	else
		node.node:runAction(self:cocosObj())
	end
end
---------------------------------------------
local anim = {}
anim["MoveBy"] = MoveBy
anim["MoveTo"] = MoveTo
anim["FadeTo"] = FadeTo
anim["ScaleTo"] = ScaleTo
anim["ScaleBy"] = ScaleBy
anim["TintTo"] = TintTo
anim["Spawn"] = Spawn
anim["Sequence"] = Sequence
anim["RotateTo"] = RotateTo
anim["JumpTo"] = JumpTo
anim["Blink"] = Blink
anim["Forever"] = Forever

anim["EaseSineIn"] = EaseSineIn
anim["EaseSineOut"] = EaseSineOut
anim["EaseSineInOut"] = EaseSineInOut
anim["EaseBounceIn"] = EaseBounceIn
anim["EaseBounceOut"] = EaseBounceOut
anim["EaseBounceInOut"] = EaseBounceInOut
anim["EaseBackIn"] = EaseBackIn
anim["EaseBackOut"] = EaseBackOut
anim["EaseBackInOut"] = EaseBackInOut
anim["EaseElasticIn"] = EaseElasticIn
anim["EaseElasticOut"] = EaseElasticOut
anim["EaseElasticInOut"] = EaseElasticInOut

----------------------------------------------
-- Shader
----------------------------------------------
local Shader = class()
function Shader:init(vsh,fsh)
	if OnPreview then
	else
		self.program = cc.GLProgram:create(vsh,fsh)
		self.program:bindAttribLocation(cc.ATTRIBUTE_NAME_POSITION, cc.VERTEX_ATTRIB_POSITION) 
		self.program:bindAttribLocation(cc.ATTRIBUTE_NAME_TEX_COORD, cc.VERTEX_ATTRIB_TEX_COORD)
		self.program:link()
		self.program:updateUniforms()

		self.glprogramstate = cc.GLProgramState:getOrCreateWithGLProgram( self.program );
	end
end

function Shader:bind(node)
	if OnPreview then
	else
		node.node:setGLProgram( self.program )
		node.node:setGLProgramState( self.glprogramstate );
	end
end

function Shader:setUniformFloat(name,value)
	if OnPreview then
	else
		self.glprogramstate:setUniformFloat(name,value)
	end
end

function Shader:setUniformTexture(name,spr)
	if OnPreview then
	else
		self.glprogramstate:setUniformTexture(name, spr:getTextureName());
	end
end

---------------------------------------------
-- Node 
---------------------------------------------
local Node = class()
if OnPreview then
	OnPreviewDrawOrder=0		
end
function Node:init(id)
	self.id = id
	self.type = "Node"
	if OnPreview then
		self:initialize()
	else
		self.node = cc.Node:create()
		self.node.obj = self
	end
end
function Node:initialize()
	self.visible = true
	self.x = 0
	self.y = 0
	self.scaleX = 1
	self.scaleY = 1
	self.rotate = 0
	self.anchorX = 0.5
	self.anchorY = 0.5
	self.zOrder = 0
	self.color = {255,255,255}
	self.opacity = 255
	self._children = {}
	if OnPreview then
		self.drawOrder = OnPreviewDrawOrder
		OnPreviewDrawOrder = OnPreviewDrawOrder+1
	end
end

function Node:release()
	if OnPreview then

	else
		self.node:release()
	end
end

function Node:retain()
	if OnPreview then

	else
		self.node:retain()
	end
end

function Node:setZ(z)
	if OnPreview then
		self.zOrder = z
	else
		self.node:setZOrder(z)
	end
end

function Node:setVisible(v)
	if OnPreview then
		self.visible = v
	else
		self.node:setVisible(v)
	end
end

function Node:isVisible(v)
	if OnPreview then
		return self.visible
	else
		return self.node:isVisible()
	end
end

function Node:removeSelf(cleanup)
	if OnPreview then
		if self.parent then
			k,v = self.parent:findChild(self.id)
			if k then
				table.remove(self.parent._children,k)
				self.parent = nil

				if cleanup ~= false then
					self.node = nil
				end
			end
		end
	else
		--print("****************************")
		--print(self.id)
		--print(debug.traceback())
		--print("****************************")
		try{
			function()
				self.node:removeFromParent()
			end,
			catch{function(error)
				print(" error self.node:removeFromParent ")
			end}
		}
		self.parent = nil
		if cleanup ~= false then
			self.node = nil
		end
	end
end

function Node:children()
	if OnPreview then
		return self._children
	else
		local ret = {}
		local children = {}
		try{
			function()
				children = self.node:getChildren()
			end,
			catch{function(error)end}
		}
		for k,v in ipairs(children)do
			table.insert(ret,v.obj)
		end
		return ret
	end
end

function Node:setContentSize(x,y)
	if OnPreview then
		if self.type == "ColorLayer" then
			self.width  = x
			self.height = y
		end
	else
		self.node:setContentSize(cc.size(x,y))
	end
end

function Node:findChild(idx)
	if OnPreview then
		for k,v in ipairs(self._children) do
			if v.id == idx then
				return k,v
			end
		end
	else
	end
end

function Node:addChild(node)
	node.parent = self
	if OnPreview then
		table.insert(self._children,node)
	else
		self.node:addChild(node.node)
	end
end

function Node:removeChild(node)
	if OnPreview then

	else
		self.node:removeChild(node.node)
		node.node = nil
	end
end

function Node:setPositionX(x)
	self._x = x
	if OnPreview then
		self.x = x
	else
		self.node:setPositionX(tonumber(x))
	end
end

function Node:setPositionY(y)
	self._y = y
	if OnPreview then
		self.y = y
	else
		local height = WIN_HEIGHT
		if self.parent and self.parent.type ~= "Scene" then
			height = self.parent:contentSize().height
		end
		self.node:setPositionY(height-tonumber(y))
	end
end

function Node:position()
	return tonumber(self._x) or 0,tonumber(self._y) or 0
end

function Node:setAnchorPoint(x,y)
	if OnPreview then
		self.anchorX = tonumber(x)
		self.anchorY = tonumber(y)
	else
		self.node:setAnchorPoint(cc.p(x,y))
	end
end

function Node:anchor()
	if OnPreview then
		return tonumber(self.anchorX) or 0.5,tonumber(self.anchorY) or 0.5
	else
		local p = self.node:getAnchorPoint()
		return p.x,p.y
	end
end

function Node:setPosition(x,y)
	if y == nil and tonumber(x) == nil then 
		if fs_position[x] then
			local sx,sy,psx,psy
			local ps = self:parentSize()
			local size = self:contentSize()
			sx,sy = self:scale()
			psx,psy = self:parentsNodeScale()
			sx = size.width  * psx * sx
			sy = size.height * psy * sy 
			x = fs_position[x](ps,sx,sy)
			x,y = x[1],x[2]
		else
			x = tonumber(x) or 0
			y = tonumber(y) or 0
		end
	end
	self._x = x
	self._y = y
	if OnPreview then
		self.x = x
		self.y = y
	else
		local height = WIN_HEIGHT
		local dx = 0
		local dy = 0
		if self.parent then
			local ax,ay,width

			if self.parent.type ~= "Scene" then
				width  = self.parent:contentSize().width
				height = self.parent:contentSize().height
				ax,ay  = self.parent:anchor()
			else
				width = WIN_WIDTH
				ax,ay = 0,1
			end

			dx = width*ax
			dy = height*(1-ay)
		end
		self.node:setPosition(tonumber(x)+dx,height-tonumber(y)-dy)
	end
end

function Node:setScale(x,y)
	if y == nil and tonumber(x) == nil then 
		if fs_size[x] then
			local sx,sy,psx,psy
			local ps = self:parentSize()
			local s = self:contentSize()
			x = fs_size[x](ps,s.width,s.height)
			x,y = x[1],x[2]
		else
			x = tonumber(x) or 1
			y = tonumber(y) or 1
		end
	end
	if OnPreview then
		self.scaleX = x
		self.scaleY = y
	else
		self.node:setScale(tonumber(x),tonumber(y))
	end
end

function Node:parentSize()
	local psx,psy
	local ps = {width=WIN_WIDTH,height=WIN_HEIGHT}
	if self.parent then
		ps = self.parent:contentSize()
		psx,psy = self:parentsNodeScale(self.parent)
		ps.width  = ps.width * psx
		ps.height = ps.height * psy
	end
	return ps
end

function Node:scale()
	if OnPreview then
		return tonumber(self.scaleX) or 1,tonumber(self.scaleY) or 1
	else
		return self.node:getScaleX(),self.node:getScaleY()
	end
end

function Node:contentSize()
	if OnPreview then
		if self.type == "Sprite" then
			local s = PiniLuaHelper:imageSize(self.path);
			return {width=s[0],height=s[1]}
		elseif self.type=="ColorLayer" then
			return {width=self.width,height=self.height}
		elseif self.type=="Label" then
			local s = PiniLuaHelper:fontSize(self.text,self.size,self.font)
			return {width=s[0],height=s[1]}
		end
	else
		return self.node:getContentSize()
	end
end

function Node:parentsNodeScale(node)
	if OnPreview then
		return 1,1
	end

	if node == nil then
		node = self
	end

	local scaleX,scaleY
	scaleX,scaleY = node:scale()
	if node.parent and node.parent.type ~= "Scene" then
		local sx,sy
		sx,sy = self:parentsNodeScale(node.parent)
		scaleX = scaleX * sx
		scaleY = scaleY * sy
	end
	return scaleX,scaleY
end

function Node:setColor(r,g,b)
	if OnPreview then
		self.color = {r,g,b}
	else
		self.node:setColor(cc.c3b(r,g,b))
	end
end

function Node:setOpacity(a)
	if OnPreview then
		self.opacity = a
	else
		self.node:setOpacity(a)
	end
end

function Node:setRotate(angle)
	if OnPreview then
		self.rotate = angle
	else
		self.node:setRotation(angle)
	end
end

function Node:getRotate()
	if OnPreview then
		return self.rotate
	else
		return self.node:getRotation()
	end
end

function Node:StopAction()
	if OnPreview then
	else
		self.node:stopAllActions()
	end
end

function Node:setFlippedY(b)
	if OnPreview then
	else
		self.node:setFlippedY(b)
	end
end

---------------------------------------------
-- Sprite 
---------------------------------------------
local Sprite = class(Node)
function Sprite:init(id,path)
	self.id = id
	self.type = "Sprite"
	if OnPreview then
		self:initialize()
		self.path = path
	else
		if type(path) == "string" then
			self.node = cc.Sprite:create(FILES["image/"..path])
		else
			self.node = cc.Sprite:createWithTexture(path)
		end
		self.node.obj = self
	end

	self:setPosition(0,0)
end

function Sprite:setSprite(path)
	if OnPreview then
	else
		local texture = cc.TextureCache:getInstance():addImage(FILES["image/"..path])
		self.node:setTexture(texture)
		self.node:setTextureRect(texture:getContentSize())
	end
end

function Sprite:getTextureName()
	if OnPreview then
	else
		return self.node:getTexture():getName()
	end
end

---------------------------------------------
-- Scene 
---------------------------------------------
local Scene=class()
function Scene:init()
	self.type = "Scene"
	if OnPreview then
	else
		self.scene = cc.Scene:create()
		self.layer = cc.Node:create()

		self.scene:addChild(self.layer)
		if cc.Director:getInstance():getRunningScene() then
			cc.Director:getInstance():replaceScene(self.scene)
		else
			cc.Director:getInstance():runWithScene(self.scene)
		end

		local function onNodeEvent(tag)
			if tag == "exit" then
				pini:ClearDisplay()
			end
		end
		self.scene:registerScriptHandler(onNodeEvent)
	end
	pini:SetScene(self)
end
function Scene:addChild(node)
	if OnPreview then
	else
		self.layer:addChild(node.node)
		node.parent = self
	end
end

function Scene:removeChild(node)
	if OnPreview then

	else
		self.layer:removeChild(node.node)
		node.node = nil
	end
end
function Scene:clear()
	if OnPreview then

	else
		try{
			function()
				self.layer:removeAllChildren(true)
			end,
			catch{function(error)end}
		}
	end
end
function Scene:visit()
	if OnPreview then

	else
		self.layer:visit()
	end
end

---------------------------------------------
-- ColorRect 
---------------------------------------------
local ColorLayer=class(Node)
function ColorLayer:init(id,r,g,b,a,w,h)
	self.id = id
	self.type = "ColorLayer"
	if OnPreview then
		self:initialize()
		self.width  = w
		self.height = h
		self.color  = {r,g,b}
		self.opacity = a
		self.anchorX = 0.0
		self.anchorY = 1.0
	else
		self.node = cc.LayerColor:create(cc.c4b(r,g,b,a),w,h)
		self.node:setAnchorPoint(cc.p(0,0))
		self.node.obj = self
	end
end

---------------------------------------------
-- label 
---------------------------------------------
local Label = class(Node)
function Label:init(id,str,fnt,size)
	self.id = id
	self.type = "Label"
	if OnPreview then
		self:initialize()
		self.text = str
		self.font = fnt
		self.size = size
	else
		self.node = cc.Label:createWithTTF(str,fnt..".ttf",size)
		self.node.obj = self
	end
end

---------------------------------------------
-- Timer 
---------------------------------------------
local Timer = class()
function Timer:init(id,time,func,re)
	self.id = id
	self.time = tonumber(time)
	self.func = func
	self.rep = re
	self.entry = nil
end
function Timer:run()
	if self.id then
		pini:RegistTimer(self)
	end
	if OnPreview then
		self.func()
		self:stop()
	else
		if self.entry then
			return 
		end
		local scheduler = cc.Director:getInstance():getScheduler()
		self.entry = scheduler:scheduleScriptFunc(function()
			try{
				function()
					self.func()
				end,
				catch{function(error)end}
			}
			if self.rep == false then
				self:stop()
			end
		end, self.time, false)
	end
end
function Timer:stop()
	if self.id then
		pini:UnregistTimer(self)
	end
	if OnPreview then

	else
		if self.entry then
			local scheduler=cc.Director:getInstance():getScheduler()
			scheduler:unscheduleScriptEntry(self.entry)
			self.entry = nil
		end
	end
end

--##########################################################################
-- 터치 매니저
--##########################################################################
local TouchManager = nil
if OnPreview then
	TouchManager = {
		SetScene = function(scene)
		end,
		clearNode = function()
		end,
		removeNode = function(node)
		end,
		registNode = function(node)
		end,
		onTouchBegan = function (touch, event)
		end,
		onTouchEnded = function (touch, event)
		end
	}
else
	TouchManager = {
		nodes = {},
		touchNode = nil,
		SetScene = function(self,scene)
			scene = scene.scene
			
			self:clearNode()

			local listener = cc.EventListenerTouchOneByOne:create()
			listener:registerScriptHandler(self.onTouchBegan,cc.Handler.EVENT_TOUCH_BEGAN )
			listener:registerScriptHandler(self.onTouchEnded,cc.Handler.EVENT_TOUCH_ENDED )

			local eventDispatcher = scene:getEventDispatcher()
			eventDispatcher:addEventListenerWithSceneGraphPriority(listener, scene)
		end,
		clearNode = function(self)
			self.nodes = {}
		end,
		removeNode = function(self,node)
			for k,v in ipairs(self.nodes) do
				if v == node then
					table.remove(self.nodes,k)
					if self.touchNode == v then
						self.touchNode = nil
					end
					return
				end
			end
		end,
		registNode = function(self,node)
			local function onNodeEvent(tag)
				if tag == "exit" then
					self:removeNode(node)
				end
			end
			node.node:registerScriptHandler(onNodeEvent)
			table.insert(self.nodes,node)
		end,
		onTouchBegan = function (touch, event)
			local self = TouchManager
			local nodes = self.nodes

			local location = touch:getLocation()
			for k,v in ipairs(nodes) do
				local tloc = v.node:convertToNodeSpace(location);
				local b = v:contentSize()
				if tloc.x > 0 and tloc.y > 0 and tloc.x < b.width and tloc.y < b.height then
					self.touchNode = v

					if v.sx == nil then
						v.sx,v.sy = v:scale()
					end
					if v.onTouchDown then
						v.onTouchDown(location) 
					end

					local anim = pini.Anim.ScaleTo(0.2,v.sx+(10/b.width),v.sy+(10/b.height))
					anim:run(v)

					return true
				end
			end
			return false
		end,
		onTouchEnded = function (touch, event)
			local self = TouchManager
			local v = self.touchNode
			if v then
				local location = touch:getLocation()
				local tloc = v.node:convertToNodeSpace(location);
				local b = v:contentSize()
				if tloc.x > 0 and tloc.y > 0 and tloc.x < b.width and tloc.y < b.height then
					if v.onTouchUp then
						v.onTouchUp(location)
					end
				end
				if v.node then
					local anim = pini.Anim.ScaleTo(0.2,v.sx,v.sy)
					anim:run(v)
				end
				self.touchNode = nil
			end
		end
	}
end
-----------------------------------------------
----- VideoPlayer
-----------------------------------------------
local VideoPlayer = class()
function VideoPlayer:init(path)
	if OnPreview then
	else
		self.req_video = require "npini.videoplayer"
		self.node = self.req_video.create(path)
	end
end

function VideoPlayer:play()
	if OnPreview then
	else
		self.req_video.play(self.node)
	end
end

function VideoPlayer:stop()
	if OnPreview then
	else
		self.req_video.stop(self.node)
	end
end

function VideoPlayer:setCallback()
	if OnPreview then
	else
		self.req_video.setCallback(self.node)
	end
end

-----------------------------------------------
----- Dialog
-----------------------------------------------
local Dialog=class()
function Dialog:init()
	self.name = nil
	self.targ = {}
	self.linker = {}
	self.background = nil
	self.nameWindow = nil
	self.cursor = nil
	self.keepFlag = false
	self.configs = {}
	self.configIdx = nil
	self.needUpdate = true
	self.lastX = 0
	self.lastY = 0
	self.lastMaxY = 0
end
function Dialog:config(idx)
	return self.configs[idx] 
end
function Dialog:SetConfig(idx,data)
	self.configs[idx] = data
end
function Dialog:UseConfig(idx)
	if self.configIdx ~= idx then
		self.needUpdate = true
	end
	self.configIdx = idx
end
function Dialog:Clear()
	if self.background then
		pini:DetachDisplay(self.background)
	end
	if self.nameWindow then
		pini:DetachDisplay(self.nameWindow)
	end
--	if self.cursor then 
--		pini:DetachDisplay(self.cursor)
--	end
	self.background = nil
	self.nameWindow = nil
	self.cursor = nil
	self.cursor = nil
	self.linker = {}
end
function Dialog:Reset()
	self.lastX = 0
	self.lastY = 0
	self.lastMaxY = 0
	self.targ = {}
	self:Clear()
end
function Dialog:setKeep(keepFlag)
	self.keepFlag = keepFlag;
end
function Dialog:_make()
	local config = self.configs[self.configIdx]
	if self.background == nil or self.background.node == nil then
		self.needUpdate = true
	end
	if self.needUpdate then
		self:Clear()
		local x,y

		-- create dialog window
		x,y = config["x"] or 0 ,config["y"] or 0 
		if config["path"] then
			self.background = pini.Sprite("dialog_background",config["path"])
			self.background:setAnchorPoint(0,0);
			--x,y = x+self.background:contentSize().width/2,y-self.background:contentSize().height/2
		else
			self.background = pini.ColorLayer("dialog_background",0,0,0,0,config["width"] or 300,config["height"] or 300)
		end

		local backColor = config["background_color"] or {255,255,255,255}
		self.background:setColor(backColor[1] or 255,
								 backColor[2] or 255,
								 backColor[3] or 255)
		self.background:setOpacity(backColor[4] or 255)
		self.background:setPosition(x,y)
		self.background:setZ(9000);
		pini:AttachDisplay(self.background)

		--create name window
		if self.name then
			local nameWindow = config["name"] or {}
			x,y = nameWindow["x"] or 0 ,nameWindow["y"] or 0 
			if nameWindow["path"] then
				self.nameWindow = pini.Sprite("dialog_name",nameWindow["path"])
				self.nameWindow:setAnchorPoint(0,0);
			else
				self.nameWindow = pini.ColorLayer("dialog_name",60,60,60,122,nameWindow["width"] or 300,nameWindow["height"] or 50)
			end
			local backColor = nameWindow["background_color"] or {255,255,255,255}
			self.nameWindow:setColor(backColor[1] or 255,
									 backColor[2] or 255,
									 backColor[3] or 255)
			self.nameWindow:setOpacity(backColor[4] or 255)
			self.nameWindow:setPosition(x,y)
			self.nameWindow:setZ(50000);
			pini:AttachDisplay(self.nameWindow)
		end

		--create cursor
		local cursorConf = config["cursor"] or {}
		if cursorConf["sprite"] and cursorConf["sprite"]:len() > 0 then
			self.cursor = pini.Sprite("dialog_cursor",cursorConf["sprite"])
			--self.cursor:setAnchorPoint(0,0)
		else
			self.cursor = pini.ColorLayer("dialog_cursor",0,0,0,0,cursorConf["width"] or 20,cursorConf["height"] or 10)
		end
		local color = cursorConf["color"] or {255,255,255,255}
		self.cursor:setColor(color[1] or 255,
							 color[2] or 255,
							 color[3] or 255)
		self.cursor:setOpacity(color[4] or 255)
		self.cursor:setVisible(false)
		self.cursor:setZ(50000);
		pini:AttachDisplay(self.cursor,self.background.id)

		if cursorConf["anim"] then
			local action = pini.Anim.Forever(cursorConf["anim"])
			action:run(self.cursor)
		end
	end
	self.needUpdate = false
end
function Dialog:build()
	self:_make()

	local config = self.configs[self.configIdx]
	local args = self.targ
	if self.name then
		local nameConf = config["name"] or {}
		local font = nameConf["font"] or config["font"] or "NanumBarunGothic"

		local ax,ay = self.nameWindow:anchor()
		local originX = -self.nameWindow:contentSize().width * ax
		local originY = -self.nameWindow:contentSize().height* (1-ay)
		
		local label = pini.Label(pini:GetUUID(),self.name,font,nameConf["text_size"] or 30)
		pini:AttachDisplay(label,self.nameWindow.id)
		label:setColor(nameConf["text_color"][1] or 255,
					   nameConf["text_color"][2] or 255,
					   nameConf["text_color"][3] or 255)
		label:setPosition(nameConf["text_align"] or "화면중앙")
		local x,y = label:position()
		label:setPosition(x+originX,y+originY)
	end
	local font = config["font"] or "NanumBarunGothic"
	local default_color = config["text_color"] or {255,255,255}
	local default_size = config["size"] or 40
	
	local ax,ay = self.background:anchor();

	local additionalX = 0--self.background:contentSize().width * ax
	local additionalY = self.background:contentSize().height*(1-ay)

	local lastedX = self.lastX + additionalX-(config["marginX"] or 0)
	local lastedY = self.lastY + additionalY
	if (self.lastX ==0 and self.lastY == 0) or self.keepFlag == false then
		lastedX = 0
		lastedY = (config["marginY"] or 0)
	end

	local originX = (config["marginX"] or 0)-additionalX--lastedX-additionalX
	local originY = lastedY-additionalY
	local x = originX+lastedX
	local y = originY

	local maxY = self.lastMaxY or default_size
	local color = default_color
	local size = default_size
	local link = nil
	local lineGap = 5
	local wordGap = 0

	for k,v in ipairs(args) do
		print_str = nil
		if v["type"] == "string" then
			if v["v"] == "\n" then
				x = originX
				y = y+maxY+lineGap
				maxY = default_size
			elseif v["v"]:len() > 0 then
				print_str = v["v"]
			end
		else
			_v = v["v"]
			_a = _v["args"]

			if _v["name"] == "색상" then
				color = {tonumber(_a[1]),tonumber(_a[2]),tonumber(_a[3])}
			elseif _v["name"] == "/색상" then
				color = default_color

			elseif _v["name"] == "크기" then
				size = tonumber(_a[1])

			elseif _v["name"] == "/크기" then
				size = default_size

			elseif _v["name"] == "공백" then
				x = x+tonumber(_a[1])
 
			elseif _v["name"] == "자간" then
				wordGap = tonumber(_a[1])

			elseif _v["name"] == "행간" then
				lineGap = tonumber(_a[1])+5

			elseif _v["name"]:startsWith("=") then
				local _id = _v["name"]:sub(2,#_v["name"])
				print_str = tostring(self.vm.variable[_id])
				
			elseif _v["name"] == "연결" then
				if #_a > 0 then 
					link = _a[1]:sub(2,#_a[1]-1)
				else 
					link = ""
				end
			elseif _v["name"] == "/연결" then
				link = nil
			elseif _v["name"] == "클릭" then
				table.insert(self.letters,1)
			end
		end
		if print_str then 
			local wordWrap = false
			x,y,mY,wordWrap = self:makeBlock(x,y,print_str,color,size,link,wordGap,font,maxY,originX,originY)
			if maxY < mY or wordWrap then maxY = mY end 
			self.lastX = x
			self.lastY = y
			self.lastMaxY = mY
			
			self.cursor:setVisible(true)
			self.cursor:setPosition(self.lastX,self.lastY+mY)
			--if #blocks > 0 then
			--	table.insert(self.linker,blocks)
			--end
		end
	end
end
function Dialog:makeBlock(startX,startY,str,color,size,link,wordGap,font,maxY,originX,originY)
	local config = self.configs[self.configIdx]
	local bconfig = config["linkBlock"] or {}
	local block = nil
	function makeLink(x)
		x = x-originX+(config["marginX"] or 0)

		local c = bconfig["color"] or {}
		local back=nil
		if tostring(bconfig["unselect"] or ""):len() > 0 then
			back = pini.Sprite(pini:GetUUID(),bconfig["unselect"])
		else
			back = pini.ColorLayer(pini:GetUUID(),c[1] or 255,c[2] or 255,c[3] or 255,c[4] or 100,0,0)
		end
		back.link = link
		back:setPositionX(x)

		pini:AttachDisplay(back,self.background.id)
		block = back;

		table.insert(self.linker,back)
	end
	function blockModify(y,w,h)
		local my = y-originY+(config["marginY"] or 0)
		if OnPreview then
			my = y
		end

		if block.type=="Sprite" then
			local size = block:contentSize()
			local sx = w/size.width
			if bconfig["fitWidth"] then
				sx = (config["width"] or 0)/size.width
				block:setPositionX(config["marginX"] or 0)
			end
			block:setPositionY(my)
			block:setScale(sx,maxY/size.height)
			block:setAnchorPoint(0,0)
		else
			block:setPositionY(my)
			block:setContentSize(w,maxY)
		end
		
	end
	if link then
		makeLink(startX)
	end

	local wordWrap = false
	local strs  = {}
	local p = ""
	local x = startX
	local y = startY
	local width = 0

	str:gsub(".",function(c)
		table.insert(strs,c)
	end)
	
	for k,v in ipairs(strs) do
		local char = ""
		if string.byte(v) < 127 then
			char = v
		else
			p = p .. v
			if p:len() == 3 then
				char = p
				p=""
			end
		end
		if char:len() > 0 then
			local label = pini.Label(pini:GetUUID(),char,font,size)
			pini:AttachDisplay(label,self.background.id)
			table.insert(self.letters,label)

			local cs = label:contentSize()
			if x + cs.width - originX > config["width"] then
				x = originX
				y = y+maxY
				maxY = 0
				width = 0
				wordWrap = true
				if block then 
					makeLink(0)
				end
			end
			
			label:setPosition(x+cs.width/2,y+cs.height/2)
			--label:setPosition(0,0)
			label:setColor(color[1],color[2],color[3])
			label:setVisible(false)
			x = x + cs.width + wordGap
			width = width + cs.width + wordGap
			if maxY < cs.height then
				maxY = cs.height
			end
			if block then 
				blockModify(y+maxY,width,maxY)
			end

			table.insert(self.letters,label)
		end
	end
	return x,y,maxY,wordWrap--,blocks
end
function Dialog:showAllLetters()
	for k,v in ipairs(self.letters) do
		if v ~= 1 then
			v:setVisible(true)
		end
	end
end
function Dialog:setName(name)
	self.name = name
end
function Dialog:Run(vm,targ)
	local config = self.configs[self.configIdx]
	if self.keepFlag == false then
		self:Reset()
	end

	self.vm = vm
	self.letters = {}
	for k,v in pairs(targ) do
		table.insert(self.targ,v)
	end

	if OnPreview then
		if self.keepFlag then
			table.remove(self.targ,#self.targ)
		end
		vm:doNext()
	else
		local touches = pini.Node("dialog_ClickWait")
		function fin()
			self.targ = {}
			pini:DetachDisplay(touches)
			pini:StopTimer("DialogUpdate")
			if self.keepFlag == false then
				self:Reset()
			end
			vm:doNext()
		end

		pini.Timer("DialogUpdate",config["time"] or 0,function()
			local function e()
				if #self.letters > 0 then
					local v = self.letters[1]
					if v == 1 then
						self.cursor:setVisible(true)
						return
					end
					v:setVisible(true)

					local x,y=v:position()
					local s=v:contentSize()
					self.cursor:setPosition(x+s.width/2,y+s.height/2)
					self.cursor:setVisible(false)
					
					table.remove(self.letters,1)
				else
					self.cursor:setVisible(true)
				end
			end
			e()
			e()
		end,true):run()
		local config = self.configs[self.configIdx]
		local bconfig = config["linkBlock"] or {}
		local lc = bconfig["color"] or {255,255,255,60}
		local linkOp = lc[4] or 60
		touches:setContentSize(99999,99999)
		touches.onTouchUp = function(location)
			for k,v in ipairs(self.linker) do
				v:StopAction()
				v:setOpacity(linkOp)

				if tostring(bconfig["unselect"] or ""):len() > 0 then
					v:setSprite(bconfig["unselect"])
				end
				
				local tloc = v.node:convertToNodeSpace(location);
				local b = v:contentSize()
				if tloc.x > 0 and tloc.y > 0 and tloc.x < b.width and tloc.y < b.height then
					if v.focus then
						vm:GotoBookmark(v.link)
						return fin()
					else
						if tostring(bconfig["select"] or ""):len() > 0 then
							v:setSprite(bconfig["select"])
						end
						local action = pini.Anim.Forever(
							pini.Anim.Sequence(
								pini.Anim.FadeTo(0.5,linkOp/10),
								pini.Anim.FadeTo(0.5,linkOp)
							)
						)
						action:run(v)
						v.focus = true
					end
				else
					v.focus = nil
				end
			end

			if #self.letters > 0 then
				if self.letters[1] == 1 then
					table.remove(self.letters,1)
				else
					while #self.letters > 0 do 
						local v = self.letters[1]
						if v == 1 then 
							self.cursor:setVisible(true)
							return 
						end
						v:setVisible(true)

						local x,y=v:position();
						local s=v:contentSize()
						self.cursor:setPosition(x+s.width/2,y+s.height/2)
						table.remove(self.letters,1)
					end
				end
			else
				if #self.linker == 0 then
					fin()
				end
			end
		end
		pini.TouchManager:registNode(touches)
		pini:AttachDisplay(touches)

		self:build()
	end
end
-----------------------------------------------
-----PINI MAINS
-----------------------------------------------
pini={
	_regist_={
		Sounds = {},
		Display = {},
		SystemNode = {},
		Timers = {},
		LatestScene=nil
	}
}

pini["Node"] = Node
pini["Sprite"] = Sprite
pini["Scene"] = Scene
pini["Timer"] = Timer
pini["Label"] = Label
pini["ColorLayer"] = ColorLayer
pini["TouchManager"] = TouchManager
pini["Dialog"] = Dialog()
pini["Anim"] = anim
pini["Shader"] = Shader
pini["VideoPlayer"] = VideoPlayer


function pini:SetScene(scene)
	self._regist_.LatestScene = scene
	TouchManager:SetScene(scene)
end

function pini:GetUUID()
	local time = tostring(os.time())
	local uuid = time
	local count = 0;
	while true do
		if self._regist_.Display[uuid] == nil and 
		   self._regist_.Timers[uuid] == nil  and 
		   self._regist_.Sounds[uuid] == nil then
			return uuid
		end
		uuid = time..count
		count = count+1
	end
end

function pini:AttachDisplay(node,parent)
	local displays = self._regist_.Display

	if node.id:len() > 0 then
		if displays[node.id] then
			local node = displays[node.id]
			self:DetachDisplay(node)
		end
		displays[node.id] = node
	end
	if parent and parent:len() > 0 and node.id ~= parent and displays[parent] then
		displays[parent]:addChild(node)
		return displays[parent]
	else
		self:scene():addChild(node)
	end
	return false
end
function pini:DetachDisplay(node,cleanup)
	local displays = self._regist_.Display;
	if cleanup ~= false then
		for k,v in ipairs(node:children()) do
			pini:DetachDisplay(v,cleanup)
		end
		displays[node.id] = nil
	end
	node:removeSelf(cleanup)
end
function pini:Clear()
	self:ClearSound()
	self:ClearTimer()
	self:ClearDisplay()
	self:ClearScene()
end
function pini:ClearScene()
	if self._regist_.LatestScene then
		self._regist_.LatestScene:clear()
		--self._regist_.LatestScene:removeSelf()
		self._regist_.LatestScene = nil
	end
end
function pini:ClearSound()
	for k in pairs(self._regist_.Sounds) do
		self:StopSound(k)
	end
end
function pini:ClearTimer()
	for k in pairs(self._regist_.Timers) do
		self:StopTimer(k)
	end
end
function pini:ClearDisplay()
	self.Dialog:Reset()
	for k in pairs (self._regist_.Display) do
		self._regist_.Display[k] = nil
	end
end
function pini:RegistTimer(timer)
	local timers = self._regist_.Timers
	if timers[timer.id] then
		timers[timer.id]:stop()
	end
	timers[timer.id] = timer
end
function pini:UnregistTimer(timer)
	local timers = self._regist_.Timers
	if timers[timer.id] then
		timers[timer.id] = nil
	end
end
function pini:StopTimer(idx)
	local timers = self._regist_.Timers
	if timers[idx] then
		timers[idx]:stop()
	end
end
function pini:PlaySound(idx,path)
	if path:len() > 0 then
		local sid
		if OnPreview then
		else
			sid = AudioEngine.playEffect(FILES["sound/"..path])
		end
		if idx:len() > 0 then
			self._regist_.Sounds[idx] = sid
		end
	end
end
function pini:StopSound(idx)
	local sid = self._regist_.Sounds[idx]
	if OnPreview then
	else
		AudioEngine.stopEffect(sid)
		self._regist_.Sounds[idx] = nil
	end
end
function pini:PlayBGM(path,brep)
	if path:len() > 0 then
		if OnPreview then
		else
			AudioEngine.stopMusic()
			AudioEngine.playMusic(FILES["sound/"..path], brep )
		end
	end
end
function pini:StopBGM()
	if OnPreview then
	else
		AudioEngine.stopMusic()
	end
end
function pini:scene()
	return self._regist_.LatestScene
end
function pini:FindNode(idx)
	return self._regist_.Display[idx]
end
function pini:takeScreenShot(callback)
	if OnPreview then
		callback(nil)
	else
		local target = cc.RenderTexture:create(
								WIN_WIDTH, 
								WIN_HEIGHT, 
								cc.TEXTURE2_D_PIXEL_FORMAT_RGB_A8888)
		target:clear(0,0,0,255)
		target:begin()
		self:scene():visit()
		target:endToLua()

		local sprite = pini.Sprite("ScreenShot",target:getSprite():getTexture())
		sprite:setPosition(WIN_WIDTH/2, WIN_HEIGHT/2)
		sprite:setFlippedY(true);
		sprite:retain()

		pini.Timer("takeScreenShot",0,function()
			callback(sprite)
		end,false):run()
	end
end