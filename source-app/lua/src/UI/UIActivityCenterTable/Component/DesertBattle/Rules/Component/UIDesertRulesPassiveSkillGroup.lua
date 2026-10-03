local UIDesertRulesPassiveSkillGroup = BaseClass("UIDesertRulesPassiveSkillGroup", UIBaseContainer)
local base = UIBaseContainer
local UIDesertRulesEpidemicSkillCell = require("UI.UIActivityCenterTable.Component.DesertBattle.Rules.Component.UIDesertRulesEpidemicSkillCell")
local PREFAB_PATH = "Assets/Main/Prefabs/UI/ActivityCenter/DesertBattle/RulesCells/DesertBattleRuleSkillCell.prefab"

function UIDesertRulesPassiveSkillGroup:OnCreate()
  base.OnCreate(self)
end

function UIDesertRulesPassiveSkillGroup:OnDestroy()
  self:RemoveComponents(UIDesertRulesEpidemicSkillCell)
  if self.reqs ~= nil then
    for _, v in pairs(self.reqs) do
      if v then
        v:Destroy()
      end
    end
    self.reqs = nil
  end
  base.OnDestroy(self)
end

function UIDesertRulesPassiveSkillGroup:ReInit(skills, battleType)
  self.reqs = {}
  for i, id in ipairs(skills) do
    local skillData
    if battleType == BattleFieldType.EpidemicZone then
      skillData = DataCenter.ActEpidemicZoneManager:GetTemplateSkillById(id)
    end
    if skillData then
      local curIdx = i
      local curSkillData = skillData
      self.reqs[i] = self:GameObjectInstantiateAsync(PREFAB_PATH, function(req)
        if req.isError then
          return
        end
        local goItem = req.gameObject
        goItem.transform:SetParent(self.transform)
        goItem.transform.localScale = ResetScale
        goItem.name = "skills_" .. curIdx
        goItem:SetActive(true)
        local skillNode = self:AddComponent(UIDesertRulesEpidemicSkillCell, goItem.name)
        skillNode:ReInit(curSkillData, battleType, true)
        CS.UnityEngine.UI.LayoutRebuilder.ForceRebuildLayoutImmediate(self.rectTransform)
      end)
    end
  end
end

return UIDesertRulesPassiveSkillGroup
