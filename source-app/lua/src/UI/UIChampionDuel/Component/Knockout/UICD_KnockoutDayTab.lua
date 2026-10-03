local UICD_KnockoutDayTab = BaseClass("UICD_KnockoutDayTab", UIBaseContainer)
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization
local text1_path = "tab_text1"
local text2_path = "Choose/tab_text2"

function UICD_KnockoutDayTab:OnCreate()
  base.OnCreate(self)
  self.toggle = self:AddComponent(UIToggle, "")
  self.toggle:SetOnValueChanged(function(tf)
    if tf then
      self:OnSel()
    end
  end)
  self.text1 = self:AddComponent(UIText, text1_path)
  self.text2 = self:AddComponent(UIText, text2_path)
end

function UICD_KnockoutDayTab:OnDestroy()
  base.OnDestroy(self)
end

function UICD_KnockoutDayTab:OnSel()
  if self.cb then
    self.cb(self.index)
  end
end

function UICD_KnockoutDayTab:SetIsOn(tf)
  self.toggle:SetIsOn(tf)
end

function UICD_KnockoutDayTab:GetIsOn()
  return self.toggle:GetIsOn()
end

function UICD_KnockoutDayTab:ReInit(index, time, cb)
  self.index = index
  self.time = time
  self.cb = cb
  local key = DataCenter.ChampionDuelManager:GetFinalStrKey(index)
  local year, month, day = UITimeManager:GetInstance():TimeStampToServerTime(time * 1000)
  local str = string.format([[
%d.%02d.%02d
%s]], year, month, day, Localization:GetString(key))
  self.text1:SetText(str)
  self.text2:SetText(str)
end

return UICD_KnockoutDayTab
