local base = UIBaseContainer
local UIBFDsbDuelActBattleRuleContentItem = BaseClass("UIBFDsbDuelActBattleRuleContentItem", UIBaseContainer)
local Localization = CS.GameEntry.Localization
local UIBFDsbDuelActBattleRuleItem = require("UI.BFDsbDuel.BFDsbDuelMain.Component.Battle.UIBFDsbDuelActBattleRuleItem")

function UIBFDsbDuelActBattleRuleContentItem:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function UIBFDsbDuelActBattleRuleContentItem:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UIBFDsbDuelActBattleRuleContentItem:ComponentDefine()
  self.viewSkin = self:AddComponent(UIViewSkinBridge, "")
  self.compRuleItem1 = self.viewSkin:AddComponent(self, UIBFDsbDuelActBattleRuleItem, 1)
  self.compRuleItem2 = self.viewSkin:AddComponent(self, UIBFDsbDuelActBattleRuleItem, 2)
  self.compRuleItem3 = self.viewSkin:AddComponent(self, UIBFDsbDuelActBattleRuleItem, 3)
end

function UIBFDsbDuelActBattleRuleContentItem:ComponentDestroy()
  self.viewSkin = nil
  self.compRuleItem1 = nil
  self.compRuleItem2 = nil
  self.compRuleItem3 = nil
end

function UIBFDsbDuelActBattleRuleContentItem:DataDefine()
end

function UIBFDsbDuelActBattleRuleContentItem:DataDestroy()
end

function UIBFDsbDuelActBattleRuleContentItem:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.DsbDuelActTimePhaseChange, self.OnDsbDuelActTimePhaseChange)
end

function UIBFDsbDuelActBattleRuleContentItem:OnRemoveListener()
  self:RemoveUIListener(EventId.DsbDuelActTimePhaseChange, self.OnDsbDuelActTimePhaseChange)
  base.OnRemoveListener(self)
end

function UIBFDsbDuelActBattleRuleContentItem:RefreshActive()
  local isRegisteredAct = BattlefieldDsbDuelUtils.ActInfo:IsRegistered()
  local isInSignUpPhase = BattlefieldDsbDuelUtils.ActInfo:IsInSignUpPhase()
  local isInGroupPhase = BattlefieldDsbDuelUtils.ActInfo:IsInGroupPhase()
  local IsInTeamWaitSignUpPhase = BattlefieldDsbDuelUtils.ActInfo:IsInTeamWaitSignUpPhase()
  self:SetActive(not isRegisteredAct or isInSignUpPhase or isInGroupPhase or IsInTeamWaitSignUpPhase)
end

function UIBFDsbDuelActBattleRuleContentItem:OnDsbDuelActTimePhaseChange()
end

function UIBFDsbDuelActBattleRuleContentItem:SetData(templateList)
  local count = #templateList
  self.compRuleItem1:SetActive(0 < count)
  self.compRuleItem2:SetActive(1 < count)
  self.compRuleItem3:SetActive(2 < count)
  if 0 < count then
    self.compRuleItem1:SetData(templateList[1])
  end
  if 1 < count then
    self.compRuleItem2:SetData(templateList[2])
  end
  if 2 < count then
    self.compRuleItem3:SetData(templateList[3])
  end
  self:RefreshActive()
end

return UIBFDsbDuelActBattleRuleContentItem
