local LWUIActivityAlarmClockTopView = BaseClass("LWUIActivityAlarmClockTopView", UIBaseView)
local base = UIBaseView
local Localization = CS.GameEntry.Localization
local LWMainUIActivityAlarmClockObj = require("UI.LWMainUI.Component.UIMainTop.LWMainUIActivityAlarmClockObj")

function LWUIActivityAlarmClockTopView:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function LWUIActivityAlarmClockTopView:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function LWUIActivityAlarmClockTopView:ComponentDefine()
  self.viewSkin = self:AddComponent(UIViewSkinBridge, "")
  self.compLWMainUIActivityAlarmClockObj = self.viewSkin:AddComponent(self, LWMainUIActivityAlarmClockObj, 1)
end

function LWUIActivityAlarmClockTopView:ComponentDestroy()
  self.viewSkin = nil
  self.compLWMainUIActivityAlarmClockObj = nil
end

function LWUIActivityAlarmClockTopView:DataDefine()
  local alarmClockData = self:GetUserData()
  self:RefreshShowActivityAlarmClockView(alarmClockData)
end

function LWUIActivityAlarmClockTopView:DataDestroy()
end

function LWUIActivityAlarmClockTopView:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.UpdateActivityAlarmClockTopView, self.RefreshShowActivityAlarmClockView)
end

function LWUIActivityAlarmClockTopView:OnRemoveListener()
  base.OnRemoveListener(self)
  self:RemoveUIListener(EventId.UpdateActivityAlarmClockTopView, self.RefreshShowActivityAlarmClockView)
end

function LWUIActivityAlarmClockTopView:RefreshShowActivityAlarmClockView(alarmClockData)
  self.alarmClockData = alarmClockData
  if alarmClockData ~= nil then
    self.compLWMainUIActivityAlarmClockObj:SetActive(true)
    self.compLWMainUIActivityAlarmClockObj:ReInit(alarmClockData)
  else
    self.ctrl:CloseSelf()
  end
end

function LWUIActivityAlarmClockTopView:IsShow()
  if self.compLWMainUIActivityAlarmClockObj then
    return self.compLWMainUIActivityAlarmClockObj.isShow
  end
  return true
end

return LWUIActivityAlarmClockTopView
