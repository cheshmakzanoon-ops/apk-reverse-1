local UIPVEResourceCell = BaseClass("UIPVEResourceCell", UIBaseContainer)
local base = UIBaseContainer
local slider_text_path = "ResourceNum"
local slider_icon_path = "ResourceIcon"

local function OnCreate(self)
  base.OnCreate(self)
  self:DataDefine()
  self:ComponentDefine()
end

local function OnDestroy(self)
  self:ComponentDestroy()
  self:DataDestroy()
  base.OnDestroy(self)
end

local function ComponentDefine(self)
  self.slider_text = self:AddComponent(UIText, slider_text_path)
  self.slider_icon = self:AddComponent(UIImage, slider_icon_path)
end

local function ComponentDestroy(self)
  self.slider_text = nil
  self.slider_icon = nil
end

local function DataDefine(self)
  self.param = nil
  self.iconName = nil
  self.num = 0
end

local function DataDestroy(self)
  self.param = nil
  self.iconName = nil
  self.num = nil
end

local function OnEnable(self)
  base.OnEnable(self)
end

local function OnDisable(self)
  base.OnDisable(self)
end

local function OnAddListener(self)
  base.OnAddListener(self)
end

local function OnRemoveListener(self)
  base.OnRemoveListener(self)
end

local function ReInit(self, param)
  self:ChangeParam(param)
end

local function ChangeParam(self, param)
  self.param = param
  if self.iconName ~= param.icon then
    self.iconName = param.icon
    self.slider_icon:LoadSprite(self.iconName)
  end
  if self.num ~= param.curNum then
    self.num = param.curNum
    self.slider_text:SetText(string.GetFormattedStr(self.num))
  end
end

local function GetFlyNode(self)
  return self.slider_icon.gameObject
end

UIPVEResourceCell.OnCreate = OnCreate
UIPVEResourceCell.OnDestroy = OnDestroy
UIPVEResourceCell.ComponentDefine = ComponentDefine
UIPVEResourceCell.ComponentDestroy = ComponentDestroy
UIPVEResourceCell.DataDefine = DataDefine
UIPVEResourceCell.DataDestroy = DataDestroy
UIPVEResourceCell.OnEnable = OnEnable
UIPVEResourceCell.OnDisable = OnDisable
UIPVEResourceCell.OnAddListener = OnAddListener
UIPVEResourceCell.OnRemoveListener = OnRemoveListener
UIPVEResourceCell.ChangeParam = ChangeParam
UIPVEResourceCell.ReInit = ReInit
UIPVEResourceCell.GetFlyNode = GetFlyNode
return UIPVEResourceCell
