local base = UIBaseContainer
local UILWAllianceLeaveTipsItemRender = BaseClass("UILWAllianceLeaveTipsItemRender", base)
local icon_path = "Icon"
local desText_path = "DesText"

local function OnCreate(self)
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

local function OnDestroy(self)
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

local function OnEnable(self)
  base.OnEnable(self)
end

local function OnDisable(self)
  base.OnDisable(self)
end

local function ComponentDefine(self)
  self.icon = self:AddComponent(UIImage, icon_path)
  self.desText = self:AddComponent(UIText, desText_path)
end

local function ComponentDestroy(self)
  self.icon = nil
  self.desText = nil
end

local function DataDefine(self)
end

local function DataDestroy(self)
end

local function ReInit(self, data)
  self.template = data
  self.icon:LoadSprite(self.template.icon)
  self.desText:SetLocalText(self.template.desc, self.template.time)
end

UILWAllianceLeaveTipsItemRender.OnCreate = OnCreate
UILWAllianceLeaveTipsItemRender.OnDestroy = OnDestroy
UILWAllianceLeaveTipsItemRender.OnEnable = OnEnable
UILWAllianceLeaveTipsItemRender.OnDisable = OnDisable
UILWAllianceLeaveTipsItemRender.ComponentDefine = ComponentDefine
UILWAllianceLeaveTipsItemRender.ComponentDestroy = ComponentDestroy
UILWAllianceLeaveTipsItemRender.DataDefine = DataDefine
UILWAllianceLeaveTipsItemRender.DataDestroy = DataDestroy
UILWAllianceLeaveTipsItemRender.ReInit = ReInit
return UILWAllianceLeaveTipsItemRender
