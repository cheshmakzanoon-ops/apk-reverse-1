local base = UIBaseContainer
local T11SkillBottomUnlockingComponent = BaseClass("T11SkillBottomUnlockingComponent", UIBaseContainer)
local Localization = CS.GameEntry.Localization
local T11SoldierSkillItemComponent = require("UI.T11Common.T11SoldierSkillItemComponent")
local t11_soldier_skill_item_path = "UnlockDurationInfo/Layout/skillIIconPoint/T11SoldierSkillItem"

function T11SkillBottomUnlockingComponent:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function T11SkillBottomUnlockingComponent:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function T11SkillBottomUnlockingComponent:ComponentDefine()
  self.viewSkin = self:AddComponent(UIViewSkinBridge, "")
  self.btnResearch = self.viewSkin:AddComponent(self, UIButton, 1)
  self.btnResearch:SetOnClick(function()
    self:OnBtnResearchClick()
  end)
  self.textResearchDurationValue = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 2)
  self.unlockingSkillItem = self:AddComponent(T11SoldierSkillItemComponent, t11_soldier_skill_item_path)
end

function T11SkillBottomUnlockingComponent:ComponentDestroy()
  self.viewSkin = nil
  self.btnResearch = nil
  self.textResearchDurationValue = nil
end

function T11SkillBottomUnlockingComponent:DataDefine()
end

function T11SkillBottomUnlockingComponent:DataDestroy()
end

function T11SkillBottomUnlockingComponent:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.T11SuccessChangeSoldierMode, self.RefreshView)
end

function T11SkillBottomUnlockingComponent:OnRemoveListener()
  self:RemoveUIListener(EventId.T11SuccessChangeSoldierMode, self.RefreshView)
  base.OnRemoveListener(self)
end

function T11SkillBottomUnlockingComponent:RefreshView()
  self.curBreakQueueData = T11Util.GetCurBreakQueueInfo()
  self:UpdateUnlockRemainDurationInfo()
  local unlockingSkillData = T11Util.GetNextStageSkillData()
  if unlockingSkillData then
    self.unlockingSkillItem:Init(unlockingSkillData)
  end
end

function T11SkillBottomUnlockingComponent:Update1000MS()
  self:UpdateUnlockRemainDurationInfo()
  self:CheckQueueFinish()
end

function T11SkillBottomUnlockingComponent:CheckQueueFinish()
  if not self.curBreakQueueData then
    return
  end
  if self.curBreakQueueData:IsEnd() then
    EventManager:GetInstance():Broadcast(EventId.T11ResearchStateUpdate)
  end
end

function T11SkillBottomUnlockingComponent:UpdateUnlockRemainDurationInfo()
  local remainTime = 0
  if self.curBreakQueueData then
    local serverTime = UITimeManager:GetInstance():GetServerTime()
    remainTime = math.max(0, self.curBreakQueueData.endTime - serverTime)
  end
  self.textResearchDurationValue:SetText(UITimeManager:GetInstance():SecondToFmtString(remainTime / 1000))
end

function T11SkillBottomUnlockingComponent:OnBtnResearchClick()
  if not self.curBreakQueueData then
    T11Util.ShowLog("T11UnlockingItemComponent:OnBtnSpeedUpClick curBreakQueueData is nil")
    return
  end
  UIManager:GetInstance():OpenWindow(UIWindowNames.UISpeed, {anim = true}, ItemSpdMenu.ItemSpdT11_BreakUpgrade, self.curBreakQueueData.uuid)
end

return T11SkillBottomUnlockingComponent
