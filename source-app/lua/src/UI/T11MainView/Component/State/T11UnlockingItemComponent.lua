local base = UIBaseContainer
local T11UnlockingItemComponent = BaseClass("T11UnlockingItemComponent", UIBaseContainer)
local Localization = CS.GameEntry.Localization

function T11UnlockingItemComponent:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function T11UnlockingItemComponent:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function T11UnlockingItemComponent:ComponentDefine()
  self.viewSkin = self:AddComponent(UIViewSkinBridge, "")
  self.btnSpeedUp = self.viewSkin:AddComponent(self, UIButton, 1)
  self.btnSpeedUp:SetOnClick(function()
    self:OnBtnSpeedUpClick()
  end)
  self.textRemainTimeValue = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 2)
end

function T11UnlockingItemComponent:ComponentDestroy()
  self.viewSkin = nil
  self.btnSpeedUp = nil
  self.textRemainTimeValue = nil
end

function T11UnlockingItemComponent:DataDefine()
end

function T11UnlockingItemComponent:DataDestroy()
end

function T11UnlockingItemComponent:OnAddListener()
  base.OnAddListener(self)
end

function T11UnlockingItemComponent:OnRemoveListener()
  base.OnRemoveListener(self)
end

function T11UnlockingItemComponent:RefreshView()
  self.curBreakQueueData = T11Util.GetCurBreakQueueInfo()
  self:UpdateUnlockRemainDurationInfo()
end

function T11UnlockingItemComponent:Update1000MS()
  self:UpdateUnlockRemainDurationInfo()
  self:CheckQueueFinish()
end

function T11UnlockingItemComponent:CheckQueueFinish()
  if not self.curBreakQueueData then
    return
  end
  if self.curBreakQueueData:IsEnd() then
    EventManager:GetInstance():Broadcast(EventId.T11ResearchStateUpdate)
  end
end

function T11UnlockingItemComponent:UpdateUnlockRemainDurationInfo()
  local remainTime = 0
  if self.curBreakQueueData then
    local serverTime = UITimeManager:GetInstance():GetServerTime()
    remainTime = math.max(0, self.curBreakQueueData.endTime - serverTime)
  end
  self.textRemainTimeValue:SetText(UITimeManager:GetInstance():SecondToFmtString(remainTime / 1000))
end

function T11UnlockingItemComponent:OnBtnSpeedUpClick()
  if not self.curBreakQueueData then
    T11Util.ShowLog("T11UnlockingItemComponent:OnBtnSpeedUpClick curBreakQueueData is nil")
    return
  end
  UIManager:GetInstance():OpenWindow(UIWindowNames.UISpeed, {anim = true}, ItemSpdMenu.ItemSpdT11_BreakUpgrade, self.curBreakQueueData.uuid)
end

return T11UnlockingItemComponent
