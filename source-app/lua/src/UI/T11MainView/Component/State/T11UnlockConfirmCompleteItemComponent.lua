local base = UIBaseContainer
local T11UnlockConfirmCompleteItemComponent = BaseClass("T11UnlockConfirmCompleteItemComponent", UIBaseContainer)
local Localization = CS.GameEntry.Localization

function T11UnlockConfirmCompleteItemComponent:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function T11UnlockConfirmCompleteItemComponent:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function T11UnlockConfirmCompleteItemComponent:ComponentDefine()
  self.viewSkin = self:AddComponent(UIViewSkinBridge, "")
  self.btnCompleted = self.viewSkin:AddComponent(self, UIButton, 1)
  self.btnCompleted:SetOnClick(function()
    self:OnBtnCompletedClick()
  end)
end

function T11UnlockConfirmCompleteItemComponent:ComponentDestroy()
  self.viewSkin = nil
  self.btnCompleted = nil
end

function T11UnlockConfirmCompleteItemComponent:DataDefine()
end

function T11UnlockConfirmCompleteItemComponent:DataDestroy()
end

function T11UnlockConfirmCompleteItemComponent:OnAddListener()
  base.OnAddListener(self)
end

function T11UnlockConfirmCompleteItemComponent:OnRemoveListener()
  base.OnRemoveListener(self)
end

function T11UnlockConfirmCompleteItemComponent:OnBtnCompletedClick()
  local curBreakQueue = T11Util.GetCurBreakQueueInfo()
  if not curBreakQueue then
    T11Util.ShowLog("T11UnlockConfirmCompleteItemComponent:OnBtnCompletedClick curBreakQueue is nil")
    return
  end
  SFSNetwork.SendMessage(MsgDefines.QueueFinish, {
    uuid = curBreakQueue.uuid
  })
end

return T11UnlockConfirmCompleteItemComponent
