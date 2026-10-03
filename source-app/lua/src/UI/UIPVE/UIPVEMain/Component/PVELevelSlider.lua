local PVELevelSlider = BaseClass("PVELevelSlider", UIBaseContainer)
local base = UIBaseContainer
local slider_path = "Slider"
local slider_text_path = "SliderText"
local slider_icon_path = "SliderIcon"

local function OnCreate(self)
  base.OnCreate(self)
  self:DataDefine()
  self:ComponentDefine()
  self:SetVisible(false)
end

local function OnDestroy(self)
  self:ComponentDestroy()
  self:DataDestroy()
  base.OnDestroy(self)
end

local function ComponentDefine(self)
  self.slider = self:AddComponent(UISlider, slider_path)
  self.slider_text = self:AddComponent(UIText, slider_text_path)
  self.slider_icon = self:AddComponent(UIImage, slider_icon_path)
end

local function ComponentDestroy(self)
  self.slider = nil
  self.slider_text = nil
  self.slider_icon = nil
end

local function DataDefine(self)
  self.visible = nil
  self.curNum = nil
  self.allNum = nil
end

local function DataDestroy(self)
  self.visible = nil
  self.curNum = nil
  self.allNum = nil
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

local function SetData(self, param)
  self.allNum = param.allNum == nil and 1 or param.allNum
  if self.icon ~= param.icon then
    self.icon = param.icon
    self.slider_icon:LoadSprite(self.icon)
  end
  self:RefreshNum(param.curNum)
  self:SetVisible(true)
end

local function RefreshNum(self, curNum)
  if self.curNum ~= curNum then
    self.curNum = curNum
    self.slider:SetValue(self.curNum / self.allNum)
    self.slider_text:SetText(self.curNum .. "/" .. self.allNum)
  end
end

local function SetVisible(self, visible)
  if self.visible ~= visible then
    self.visible = visible
    self.gameObject:SetActive(visible)
  end
end

PVELevelSlider.OnCreate = OnCreate
PVELevelSlider.OnDestroy = OnDestroy
PVELevelSlider.ComponentDefine = ComponentDefine
PVELevelSlider.ComponentDestroy = ComponentDestroy
PVELevelSlider.DataDefine = DataDefine
PVELevelSlider.DataDestroy = DataDestroy
PVELevelSlider.OnEnable = OnEnable
PVELevelSlider.OnDisable = OnDisable
PVELevelSlider.OnAddListener = OnAddListener
PVELevelSlider.OnRemoveListener = OnRemoveListener
PVELevelSlider.SetData = SetData
PVELevelSlider.RefreshNum = RefreshNum
PVELevelSlider.SetVisible = SetVisible
return PVELevelSlider
