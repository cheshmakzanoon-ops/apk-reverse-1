local base = UIBaseContainer
local MiniMapGreenItem = BaseClass("MiniMapGreenItem", base)
local Icon_path = "Icon"
local Desc_path = "Desc"

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
  self.Icon = self:AddComponent(UIImage, Icon_path)
  self.Desc = self:AddComponent(UIText, Desc_path)
end

local function ComponentDestroy(self)
  self.Icon = nil
  self.Desc = nil
end

local function DataDefine(self)
end

local function DataDestroy(self)
end

function MiniMapGreenItem:ReInit(i, conf)
  self.Desc:SetLocalText(conf.name)
  if conf.innerColor then
    self.Icon:SetColor(conf.innerColor)
  end
end

MiniMapGreenItem.OnCreate = OnCreate
MiniMapGreenItem.OnDestroy = OnDestroy
MiniMapGreenItem.OnEnable = OnEnable
MiniMapGreenItem.OnDisable = OnDisable
MiniMapGreenItem.ComponentDefine = ComponentDefine
MiniMapGreenItem.ComponentDestroy = ComponentDestroy
MiniMapGreenItem.DataDefine = DataDefine
MiniMapGreenItem.DataDestroy = DataDestroy
return MiniMapGreenItem
