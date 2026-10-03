local UIPushSettingsSubItem = BaseClass("UIPushSettingsSubItem", UIBaseContainer)
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization
local UIPushSettingsSlider = require("UI.UIChatNew.UIPushSettings.Component.UIPushSettingsSlider")
local compBook = {
  {
    path = "txtTitle",
    name = "txtTitle",
    type = UIText
  },
  {
    path = "txtDesc",
    name = "txtDesc",
    type = UIText
  },
  {
    path = "slider",
    name = "slider",
    type = UIPushSettingsSlider
  },
  {
    path = "redPoint",
    name = "redPoint",
    type = UIImage
  }
}

function UIPushSettingsSubItem:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
end

function UIPushSettingsSubItem:OnDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
  self.data = nil
end

function UIPushSettingsSubItem:ComponentDefine()
  self:DefineCompsByBook(compBook)
  
  function self.slider.onSwitch(isOn, isInit)
    self:OnSliderSwitched(isOn, isInit)
  end
end

function UIPushSettingsSubItem:ComponentDestroy()
  self:ClearCompsByBook(compBook)
end

function UIPushSettingsSubItem:Refresh(data)
  self.data = data
  self.txtTitle:SetText(Localization:GetString(data.title))
  self.txtDesc:SetText(Localization:GetString(data.desc))
  self.isInit = true
  self.slider:Switch(data.isOn, true)
  self.redPoint:SetActive(DataCenter.PushSettingsManager:IsPushUnread(data.id))
end

function UIPushSettingsSubItem:OnSliderSwitched(isOn, isInit)
  self.data.isOn = isOn
  if isOn and not CS.GameEntry.Sdk:GetIsNotifyOpen() and DataCenter.PushSettingsManager:GetIsPushJump() and not self.isInit then
    DataCenter.PushSettingsManager:SetLastPushOpenTime()
    CS.GameEntry.Sdk:AskForNotifyPermission()
  end
  if self.isInit then
    self.isInit = false
  end
end

return UIPushSettingsSubItem
