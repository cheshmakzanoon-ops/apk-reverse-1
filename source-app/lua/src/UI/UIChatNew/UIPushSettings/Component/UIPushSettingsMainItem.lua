local UIPushSettingsMainItem = BaseClass("UIPushSettingsMainItem", UIBaseContainer)
local base = UIBaseContainer
local UIPushSettingsSlider = require("UI.UIChatNew.UIPushSettings.Component.UIPushSettingsSlider")
local compBook = {
  {
    path = "txtTitle",
    name = "txtTitle",
    type = UIText,
    textKey = 2900008
  },
  {
    path = "slider",
    name = "slider",
    type = UIPushSettingsSlider
  }
}

function UIPushSettingsMainItem:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
end

function UIPushSettingsMainItem:OnDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UIPushSettingsMainItem:ComponentDefine()
  self:DefineCompsByBook(compBook)
  self.slider:Switch(false)
  
  function self.slider.onSwitch(isOn)
    self:OnSliderSwitched(isOn)
  end
end

function UIPushSettingsMainItem:ComponentDestroy()
  self:ClearCompsByBook(compBook)
end

function UIPushSettingsMainItem:Refresh()
end

function UIPushSettingsMainItem:OnSliderSwitched(isOn)
  if isOn then
    self.slider:Switch(false)
    CS.GameEntry.Sdk:AskForNotifyPermission()
  end
end

return UIPushSettingsMainItem
