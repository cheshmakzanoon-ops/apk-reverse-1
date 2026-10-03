local base = UIAsyncContainer
local UIWorldPointHSRComponent = BaseClass("UIWorldPointHSRComponent", UIAsyncContainer)
local HSRProgressComponent = require("UI.UIHSR.HSRProgressComponent")
local Localization = CS.GameEntry.Localization

function UIWorldPointHSRComponent:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function UIWorldPointHSRComponent:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UIWorldPointHSRComponent:ComponentDefine()
  self.viewSkin = self:AddComponent(UIViewSkinBridge, "")
  self.textMoney = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 1)
  self.textGoods = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 2)
  self.textMoneyNum = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 3)
  self.textDesTxt = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 4)
  self.textDesc = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 5)
  self.layoutElementHSRProgress = self.viewSkin:AddComponent(self, HSRProgressComponent, 6)
  self.textTitle = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 7)
  self.textPeople = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 8)
  self.textGoodsNum = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 9)
  self.textPeopleNum = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 10)
  self.animator = self:AddComponent(UIAnimator, "")
  self.textTitle:SetLocalText("activity_1200044_tips63")
  self.textPeople:SetLocalText("activity_1200044_tips91", "")
  self.textGoods:SetLocalText("activity_1200044_tips92", "")
  self.textMoney:SetLocalText("activity_1200044_tips93", "")
  self.textDesTxt:SetLocalText(457574)
end

function UIWorldPointHSRComponent:ComponentDestroy()
  self.viewSkin = nil
  self.textMoney = nil
  self.textGoods = nil
  self.textMoneyNum = nil
  self.textDesTxt = nil
  self.textDesc = nil
  self.layoutElementHSRProgress = nil
  self.textTitle = nil
  self.textPeople = nil
  self.textGoodsNum = nil
  self.textPeopleNum = nil
end

function UIWorldPointHSRComponent:DataDefine()
end

function UIWorldPointHSRComponent:DataDestroy()
end

function UIWorldPointHSRComponent:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.HSRActivityDataRefresh, self.RefreshData)
end

function UIWorldPointHSRComponent:OnRemoveListener()
  self:RemoveUIListener(EventId.HSRActivityDataRefresh, self.RefreshData)
  base.OnRemoveListener(self)
end

function UIWorldPointHSRComponent:RefreshData()
  local activityData = DataCenter.HSRDataManager:GetActivityData()
  if activityData then
    self.textPeopleNum:SetText(string.GetFormattedSeparatorNum(activityData.passengerCount))
    self.textGoodsNum:SetText(string.GetFormattedSeparatorNum(activityData.remainNum))
    self.textMoneyNum:SetText(string.GetFormattedSeparatorNum(activityData.totalProfit))
  end
end

function UIWorldPointHSRComponent:Update1000MS()
  local now = UITimeManager:GetInstance():GetServerTime()
  local nextTime, progress = DataCenter.HSRDataManager:GetDrivingProgress()
  if now > nextTime then
    self.textDesc:SetLocalText(457520)
  else
    local text = Localization:GetString("activity_1200044_tips65")
    self.textDesc:SetText(text .. UITimeManager:GetInstance():MilliSecondToFmtStringWithoutDay(nextTime - now))
  end
end

function UIWorldPointHSRComponent:OnInfoClick()
  self.animator:Enable(true)
  self.animator:Play("switchEnter", 0, 0)
end

function UIWorldPointHSRComponent:OnReturnClick()
  self.animator:Enable(true)
  self.animator:Play("switchOut", 0, 0)
end

return UIWorldPointHSRComponent
