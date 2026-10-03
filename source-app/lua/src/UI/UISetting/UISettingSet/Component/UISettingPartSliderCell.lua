local UISettingPartSliderCell = BaseClass("UISettingPartSliderCell", UIBaseContainer)
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization
local Setting = CS.GameEntry.Setting
local GameQualitySettings = require("Util.GameQualitySettings")
local Param = DataClass("Param", ParamData)
local ParamData = {
  setType
}
local push_name_path = "PushName"
local low_des_path = "low"
local mid_des_path = "mid"
local high_des_path = "high"
local slider_path = "Slider"
local low_toggle_path = "Group/lowToggle"
local mid_toggle_path = "Group/midToggle"
local high_toggle_path = "Group/highToggle"
local LeftBtn_path = "LeftBtn"
local RightBtn_path = "RightBtn"

local function OnCreate(self)
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

local function OnDestroy(self)
  self:ComponentDestroy()
  self:DataDestroy()
  base.OnDestroy(self)
end

local function OnEnable(self)
  base.OnEnable(self)
end

local function OnDisable(self)
  base.OnDisable(self)
end

local function ComponentDefine(self)
  self.push_name = self:AddComponent(UIText, push_name_path)
  self.low_des = self:AddComponent(UIText, low_des_path)
  self.mid_des = self:AddComponent(UIText, mid_des_path)
  self.high_des = self:AddComponent(UIText, high_des_path)
  self.slider = self:AddComponent(UISlider, slider_path)
  self.level = GameQualitySettings.GetQuality()
  self.slider:SetValue(self.level - 1)
  self.low_toggle = self:AddComponent(UIToggle, low_toggle_path)
  self.low_toggle:SetIsOn(self.level == 1)
  self.mid_toggle = self:AddComponent(UIToggle, mid_toggle_path)
  self.mid_toggle:SetIsOn(self.level == 2)
  self.high_toggle = self:AddComponent(UIToggle, high_toggle_path)
  self.high_toggle:SetIsOn(self.level == 3)
  self.low_toggle:SetOnValueChanged(function(tf)
    if tf then
      self:ToggleControlBorS()
    end
  end)
  self.mid_toggle:SetOnValueChanged(function(tf)
    if tf then
      self:ToggleControlBorS()
    end
  end)
  self.high_toggle:SetOnValueChanged(function(tf)
    if tf then
      self:ToggleControlBorS()
    end
  end)
  self.low_des:SetLocalText(129079)
  self.mid_des:SetLocalText(129080)
  self.high_des:SetLocalText(129081)
  self.leftBtn = self:AddComponent(UIButton, LeftBtn_path)
  self.rightBtn = self:AddComponent(UIButton, RightBtn_path)
  self.leftBtn:SetOnClick(function()
    self:LeftBtnClick()
  end)
  self.rightBtn:SetOnClick(function()
    self:RightBtnClick()
  end)
end

local function ComponentDestroy(self)
  self.push_name = nil
  self.push_des = nil
  self.slider = nil
  self.low_des = nil
  self.mid_des = nil
  self.high_des = nil
end

local function DataDefine(self)
  self.param = {}
  self.level = self.level or GameQualitySettings.GetQuality()
end

local function DataDestroy(self)
  self.param = nil
  self.level = nil
end

local function ReInit(self, param)
  self.param = param
  self:SetName()
end

local function SetName(self)
  if self.param.setType == SettingSetType.ShaderLod then
    self.push_name:SetText("")
  end
end

local function ToggleControlBorS(self)
  if self.low_toggle:GetIsOn() then
    self.level = 1
    GameQualitySettings.SetQuality(EGameQuality.Low)
  elseif self.mid_toggle:GetIsOn() then
    self.level = 2
    GameQualitySettings.SetQuality(EGameQuality.Mid)
  elseif self.high_toggle:GetIsOn() then
    self.level = 3
    GameQualitySettings.SetQuality(EGameQuality.High)
  end
  EventManager:GetInstance():Broadcast(EventId.Settings_Graphic_Lv_Changed)
  self.slider:SetValue(self.level - 1)
end

local function LeftBtnClick(self)
  if self.level > 1 then
    self.level = self.level - 1
    if self.level == 1 then
      self.low_toggle:SetIsOn(self.level == 1)
    elseif self.level == 2 then
      self.mid_toggle:SetIsOn(self.level == 2)
    elseif self.level == 3 then
      self.high_toggle:SetIsOn(self.level == 3)
    end
  end
end

local function RightBtnClick(self)
  if self.level < 3 then
    self.level = self.level + 1
    if self.level == 1 then
      self.low_toggle:SetIsOn(self.level == 1)
    elseif self.level == 2 then
      self.mid_toggle:SetIsOn(self.level == 2)
    elseif self.level == 3 then
      self.high_toggle:SetIsOn(self.level == 3)
    end
  end
end

function UISettingPartSliderCell:Refresh()
  if not self.low_toggle then
    return
  end
  self.level = GameQualitySettings.GetQuality()
  self.slider:SetValue(self.level - 1)
end

UISettingPartSliderCell.OnCreate = OnCreate
UISettingPartSliderCell.OnDestroy = OnDestroy
UISettingPartSliderCell.Param = Param
UISettingPartSliderCell.OnEnable = OnEnable
UISettingPartSliderCell.OnDisable = OnDisable
UISettingPartSliderCell.ComponentDefine = ComponentDefine
UISettingPartSliderCell.ComponentDestroy = ComponentDestroy
UISettingPartSliderCell.DataDefine = DataDefine
UISettingPartSliderCell.DataDestroy = DataDestroy
UISettingPartSliderCell.ReInit = ReInit
UISettingPartSliderCell.SetName = SetName
UISettingPartSliderCell.ToggleControlBorS = ToggleControlBorS
UISettingPartSliderCell.LeftBtnClick = LeftBtnClick
UISettingPartSliderCell.RightBtnClick = RightBtnClick
return UISettingPartSliderCell
