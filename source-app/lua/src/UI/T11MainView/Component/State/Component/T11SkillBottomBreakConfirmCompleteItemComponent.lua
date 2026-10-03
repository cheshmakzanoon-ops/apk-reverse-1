local base = UIBaseContainer
local T11SkillBottomBreakConfirmCompleteItemComponent = BaseClass("T11SkillBottomBreakConfirmCompleteItemComponent", UIBaseContainer)
local Localization = CS.GameEntry.Localization
local T11SoldierSkillItemComponent = require("UI.T11Common.T11SoldierSkillItemComponent")
local t11_soldier_skill_item_path = "UnlockInfo/T11SoldierSkillItem"

function T11SkillBottomBreakConfirmCompleteItemComponent:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function T11SkillBottomBreakConfirmCompleteItemComponent:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function T11SkillBottomBreakConfirmCompleteItemComponent:ComponentDefine()
  self.viewSkin = self:AddComponent(UIViewSkinBridge, "")
  self.btnResearch = self.viewSkin:AddComponent(self, UIButton, 1)
  self.btnResearch:SetOnClick(function()
    self:OnBtnResearchClick()
  end)
  self.unlockSkillItem = self:AddComponent(T11SoldierSkillItemComponent, t11_soldier_skill_item_path)
end

function T11SkillBottomBreakConfirmCompleteItemComponent:ComponentDestroy()
  self.viewSkin = nil
  self.btnResearch = nil
end

function T11SkillBottomBreakConfirmCompleteItemComponent:DataDefine()
end

function T11SkillBottomBreakConfirmCompleteItemComponent:DataDestroy()
end

function T11SkillBottomBreakConfirmCompleteItemComponent:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.T11SuccessChangeSoldierMode, self.RefreshView)
end

function T11SkillBottomBreakConfirmCompleteItemComponent:OnRemoveListener()
  self:RemoveUIListener(EventId.T11SuccessChangeSoldierMode, self.RefreshView)
  base.OnRemoveListener(self)
end

function T11SkillBottomBreakConfirmCompleteItemComponent:OnBtnResearchClick()
  local curBreakQueue = T11Util.GetCurBreakQueueInfo()
  if not curBreakQueue then
    T11Util.ShowLog("T11UnlockConfirmCompleteItemComponent:OnBtnCompletedClick curBreakQueue is nil")
    return
  end
  SFSNetwork.SendMessage(MsgDefines.QueueFinish, {
    uuid = curBreakQueue.uuid
  })
end

function T11SkillBottomBreakConfirmCompleteItemComponent:RefreshView()
  local unlockSkillData = T11Util.GetNextStageSkillData()
  self.unlockSkillItem:Init(unlockSkillData)
end

return T11SkillBottomBreakConfirmCompleteItemComponent
