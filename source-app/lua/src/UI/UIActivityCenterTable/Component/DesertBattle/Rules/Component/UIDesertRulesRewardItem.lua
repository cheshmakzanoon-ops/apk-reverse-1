local UIDesertRulesRewardItem = BaseClass("UIDesertRulesRewardItem", UIAsyncContainer)
local base = UIAsyncContainer
local Prefab_Base = "Assets/Main/Prefabs/UI/ActivityCenter/DesertBattle/RulesCells/DesertBattleRuleContentReward%s.prefab"
local Cls_Base = "UI.UIActivityCenterTable.Component.DesertBattle.Rules.Component.UIDesertRulesRewardContent%s"

function UIDesertRulesRewardItem:OnCreate()
  base.OnCreate(self)
  self.content = self:AddComponent(UIBaseContainer, "Content")
end

function UIDesertRulesRewardItem:OnDestroy()
  self.ruleList = nil
  self.bfType = nil
  self.curComp = nil
  base.OnDestroy(self)
end

function UIDesertRulesRewardItem:ReInit(theType, battleType)
  self.ruleList = BattleFieldUtil.GetRuleList(battleType, theType)
  self.bfType = battleType
  self:RefreshView()
end

function UIDesertRulesRewardItem:UpdateData()
  if self.ruleList == nil or self.bfType == nil then
    return
  end
  if self.curComp == nil then
    local ex
    if self.bfType == BattleFieldType.Desert then
      ex = "D"
    else
      ex = "W"
    end
    local cls = string.format(Cls_Base, ex)
    local prefab = string.format(Prefab_Base, ex)
    self.curComp = self:LoadComponentAsync(cls, prefab, self.content)
  end
  self.curComp:ReInit(self.bfType, self.ruleList)
end

return UIDesertRulesRewardItem
