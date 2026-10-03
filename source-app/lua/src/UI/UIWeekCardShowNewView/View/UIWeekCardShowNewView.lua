local UIWeekCardShowNewView = BaseClass("UIWeekCardShowNewView", UIBaseView)
local base = UIBaseView
local Localization = CS.GameEntry.Localization
local WeekCardData = require("DataCenter.WeekCard.WeekCardData")
local WeekCardItem = require("UI.UIGiftPackage.Component.WeekCard.WeekCardItem")

function UIWeekCardShowNewView:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
  self:ReInit()
end

function UIWeekCardShowNewView:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UIWeekCardShowNewView:ComponentDefine()
  self.viewSkin = self:AddComponent(UIViewSkinBridge, "")
  self.compWeekCardItemLast = self.viewSkin:AddComponent(self, WeekCardItem, 1)
  self.compWeekCardItemNew = self.viewSkin:AddComponent(self, WeekCardItem, 2)
  self.btnMask = self.viewSkin:AddComponent(self, UIButton, 3)
  self.btnMask:SetOnClick(function()
    self:OnBtnMaskClick()
  end)
end

function UIWeekCardShowNewView:ComponentDestroy()
  self.viewSkin = nil
  self.compWeekCardItemLast = nil
  self.compWeekCardItemNew = nil
  self.btnMask = nil
end

function UIWeekCardShowNewView:DataDefine()
end

function UIWeekCardShowNewView:DataDestroy()
end

function UIWeekCardShowNewView:ReInit()
  self.weekCardInfo = self:GetUserData()
  if self.weekCardInfo == nil then
    return
  end
  self.packageInfo = GiftPackManager.get(self.weekCardInfo.exchangeId)
  local weekCardTemplate = LocalController:instance():getLine(TableName.WeekCard, self.weekCardInfo.id)
  if string.IsNullOrEmpty(weekCardTemplate.reward_change_group) then
    self.ctrl:CloseSelf()
    return
  end
  local actRewardChange = LocalController:instance():getLine(TableName.ACTIVITY_REWARD_CHANGE, weekCardTemplate.reward_change_group)
  if string.IsNullOrEmpty(actRewardChange.type_para2) then
    self.ctrl:CloseSelf()
    return
  end
  local idStrList = string.split(actRewardChange.type_para2, "|")
  if not idStrList or #idStrList ~= 2 or string.IsNullOrEmpty(idStrList[1]) then
    self.ctrl:CloseSelf()
    return
  end
  local lastCardTemplate = LocalController:instance():getLine(TableName.WeekCard, idStrList[1])
  local lastCard = WeekCardData.New()
  lastCard:ParseData(lastCardTemplate)
  lastCard.typeFunction = 2
  self.compWeekCardItemLast:SetShowNewStatus(true)
  self.compWeekCardItemNew:SetShowNewStatus(true)
  self.compWeekCardItemLast:SetItemLocal(lastCard)
  self.compWeekCardItemNew:SetItem(self.weekCardInfo)
end

function UIWeekCardShowNewView:OnAddListener()
  base.OnAddListener(self)
end

function UIWeekCardShowNewView:OnRemoveListener()
  base.OnRemoveListener(self)
end

function UIWeekCardShowNewView:OnBtnMaskClick()
  EventManager:GetInstance():Broadcast(EventId.UIWeekCardShowNewClose)
  self.ctrl:CloseSelf()
end

return UIWeekCardShowNewView
