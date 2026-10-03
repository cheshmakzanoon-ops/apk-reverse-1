local base = UIBaseContainer
local T11SkillBottomUnlockableComponent = BaseClass("T11SkillBottomUnlockableComponent", UIBaseContainer)
local Localization = CS.GameEntry.Localization
local T11SoldierSkillItemComponent = require("UI.T11Common.T11SoldierSkillItemComponent")
local CommonGroupCost = require("UI.UICommonCostGroup.CommonGroupCostComponent")
local t11_soldier_skill_item_path = "UnlockDurationInfo/Layout/skillIIconPoint/T11SoldierSkillItem"

function T11SkillBottomUnlockableComponent:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function T11SkillBottomUnlockableComponent:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function T11SkillBottomUnlockableComponent:ComponentDefine()
  self.viewSkin = self:AddComponent(UIViewSkinBridge, "")
  self.textResearchDurationValue = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 1)
  self.btnResearch = self.viewSkin:AddComponent(self, UIButton, 2)
  self.btnResearch:SetOnClick(function()
    self:OnBtnResearchClick()
  end)
  self.compCommonGroupCost = self.viewSkin:AddComponent(self, CommonGroupCost, 3)
  self.unlockSkillItem = self:AddComponent(T11SoldierSkillItemComponent, t11_soldier_skill_item_path)
end

function T11SkillBottomUnlockableComponent:ComponentDestroy()
  self.viewSkin = nil
  self.textResearchDurationValue = nil
  self.btnResearch = nil
  self.compCommonGroupCost = nil
end

function T11SkillBottomUnlockableComponent:DataDefine()
end

function T11SkillBottomUnlockableComponent:DataDestroy()
end

function T11SkillBottomUnlockableComponent:OnEnable()
  base.OnEnable(self)
  self:RefreshBreakCost()
end

function T11SkillBottomUnlockableComponent:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.T11SuccessChangeSoldierMode, self.RefreshView)
end

function T11SkillBottomUnlockableComponent:OnRemoveListener()
  self:RemoveUIListener(EventId.T11SuccessChangeSoldierMode, self.RefreshView)
  base.OnRemoveListener(self)
end

function T11SkillBottomUnlockableComponent:RefreshView()
  self.nextStageTmp = T11Util.GetNextStageTmp()
  if not self.nextStageTmp then
    T11Util.ShowLog("T11UnlockableItemComponent:RefreshView nextStageTmp is nil")
    return
  end
  local unlockSkillData = T11Util.GetNextStageSkillData()
  self.unlockSkillItem:Init(unlockSkillData)
  self:RefreshBreakDuration()
  self:RefreshBreakCost()
end

function T11SkillBottomUnlockableComponent:RefreshBreakCost()
  local nextStageCostData = T11Util.GetNextStageUpgradeCostData()
  if not nextStageCostData then
    self.compCommonGroupCost:SetActive(false)
    return
  end
  self.compCommonGroupCost:SetActive(true)
  self.compCommonGroupCost:ReInit(nextStageCostData, true)
end

function T11SkillBottomUnlockableComponent:RefreshBreakDuration()
  local breakDuration = self.nextStageTmp.cost_time
  local showDuration = UITimeManager:GetInstance():SecondToFmtString(breakDuration)
  self.textResearchDurationValue:SetText(showDuration)
end

function T11SkillBottomUnlockableComponent:OnBtnResearchClick()
  local isExistLackRes = self.compCommonGroupCost:CheckIsLackRes(true)
  if isExistLackRes then
    return
  end
  SFSNetwork.SendMessage(MsgDefines.SoldierElevenStage)
end

return T11SkillBottomUnlockableComponent
