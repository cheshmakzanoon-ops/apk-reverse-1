local PowerDetailSoldierNumTips = BaseClass("PowerDetailSoldierNumTips", UIBaseContainer)
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization
local des_text_path = "DesText"
local soldier_num_slider_path = "SliderNewRoot/SoldierNumSlider"
local soldier_num_progress_text_path = "SliderNewRoot/SoldierNumSlider/SoldierNumProgressText"
local soldier_icon_image_path = "SliderNewRoot/SoldierIcon"
local des2_text_path = "DesText2"

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
  self.desText = self:AddComponent(UIText, des_text_path)
  self.soldierNumSlider = self:AddComponent(UISlider, soldier_num_slider_path)
  self.soldierNumProgressText = self:AddComponent(UIText, soldier_num_progress_text_path)
  self.soldierIcon = self:AddComponent(UIImage, soldier_icon_image_path)
  self.des2Text = self:AddComponent(UIText, des2_text_path)
end

local function ComponentDestroy(self)
  self.desText = nil
  self.soldierNumSlider = nil
  self.soldierNumProgressText = nil
  self.soldierIcon = nil
  self.des2Text = nil
end

local function DataDefine(self)
end

local function DataDestroy(self)
end

local function OnAddListener(self)
  base.OnAddListener(self)
end

local function OnRemoveListener(self)
  base.OnRemoveListener(self)
end

local function RefreshUI(self, param)
  self.param = param
  if string.IsNullOrEmpty(self.param.content) then
    self.desText:SetActive(false)
  else
    self.desText:SetActive(true)
    self.desText:SetText(self.param.content)
  end
  if string.IsNullOrEmpty(self.param.content2) then
    self.des2Text:SetEnable(false)
  else
    self.des2Text:SetEnable(true)
    self.des2Text:SetText(self.param.content2)
  end
  if self.param then
    local soldierTotal = self.param.soldierCount
    local soldierUpperLimit = self.param.soldierCapacity
    self.soldierNumProgressText:SetText(soldierTotal .. "/" .. soldierUpperLimit)
    self.soldierNumSlider:SetValue(soldierTotal / soldierUpperLimit)
  end
end

PowerDetailSoldierNumTips.OnCreate = OnCreate
PowerDetailSoldierNumTips.OnDestroy = OnDestroy
PowerDetailSoldierNumTips.OnEnable = OnEnable
PowerDetailSoldierNumTips.OnDisable = OnDisable
PowerDetailSoldierNumTips.ComponentDefine = ComponentDefine
PowerDetailSoldierNumTips.ComponentDestroy = ComponentDestroy
PowerDetailSoldierNumTips.DataDefine = DataDefine
PowerDetailSoldierNumTips.DataDestroy = DataDestroy
PowerDetailSoldierNumTips.OnAddListener = OnAddListener
PowerDetailSoldierNumTips.OnRemoveListener = OnRemoveListener
PowerDetailSoldierNumTips.RefreshUI = RefreshUI
return PowerDetailSoldierNumTips
