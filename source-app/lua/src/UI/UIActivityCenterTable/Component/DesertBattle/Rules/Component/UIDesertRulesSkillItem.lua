local UIDesertRulesSkillItem = BaseClass("UIDesertRulesSkillItem", UIAsyncContainer)
local base = UIAsyncContainer
local UIDesertRulesEpidemicSkillCell = require("UI.UIActivityCenterTable.Component.DesertBattle.Rules.Component.UIDesertRulesEpidemicSkillCell")
local PREFAB_PATH = "Assets/Main/Prefabs/UI/ActivityCenter/DesertBattle/RulesCells/DesertBattleRuleSkillCell.prefab"
local content_path = "ScrollView/Viewport/Content"
local sp_prefab = "Assets/Main/Prefabs/UI/BF_Epidemic/UIActivity/UIActEpidemicScorePoints.prefab"
local sp_cls = "UI.UIActEpidemicPopup.Component.UIActEpidemicScorePoints"
local tip_prefab = "Assets/Main/Prefabs/UI/BF_Epidemic/UIActivity/UIActEpidemicScorePointsTipRoot.prefab"
local tip_cls = "UI.UIActEpidemicPopup.Component.UIActEpidemicScorePointsTipRoot"

function UIDesertRulesSkillItem:OnCreate()
  base.OnCreate(self)
  self.content = self:AddComponent(UIBaseContainer, content_path)
  self.score_points = self:LoadComponentAsync(sp_cls, sp_prefab, self.content, function(comp)
    self.score_points:SetAsFirstSibling()
    self.score_points:LineState(true)
    if self.tip_root ~= nil and self.tip_root:AsyncLoadDone() then
      self.score_points:SetClickCb(nil, self.tip_root.tipCb)
    end
    self.score_points:SetCurrentToggleIndex(2)
    CS.UnityEngine.UI.LayoutRebuilder.ForceRebuildLayoutImmediate(self.content.rectTransform)
  end)
  self.tip_root = self:LoadComponentAsync(tip_cls, tip_prefab, self, function(comp)
    self.tip_root:SetAsLastSibling()
    self.tip_root:SetOffsetMinXY(0, 0)
    self.tip_root:SetOffsetMaxXY(0, 0)
    self.tip_root:SetSizeDeltaXY(0, 2600)
    self.tip_root:SetActive(false)
    if self.score_points ~= nil and self.score_points:AsyncLoadDone() then
      self.score_points:SetClickCb(nil, self.tip_root.tipCb)
    end
  end)
end

function UIDesertRulesSkillItem:OnDestroy()
  self.content:RemoveComponents(UIDesertRulesEpidemicSkillCell)
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

function UIDesertRulesSkillItem:ReInit(theType, battleType)
  local skills = {}
  if battleType == BattleFieldType.EpidemicZone then
    local ruleList = BattleFieldUtil.GetRuleList(battleType, theType)
    for _, rule in ipairs(ruleList) do
      local skillId = tonumber(rule.battle_skill)
      if skillId and 0 < skillId then
        local skillData = DataCenter.ActEpidemicZoneManager:GetTemplateSkillById(skillId)
        if skillData then
          table.insert(skills, skillData)
        else
          Logger.LogError(string.format("\229\176\157\232\175\149\232\175\187\229\143\150\230\136\152\229\156\186\230\138\128\232\131\189%s\229\164\177\232\180\165~", skillId))
        end
      end
    end
  end
  if skills ~= nil then
    self.reqs = {}
    for i, v in ipairs(skills) do
      if v ~= nil then
        local curIdx = i
        local skillData = v
        self.reqs[i] = self:GameObjectInstantiateAsync(PREFAB_PATH, function(req)
          if req.isError then
            return
          end
          local goItem = req.gameObject
          goItem.transform:SetParent(self.content.transform)
          goItem.transform.localScale = ResetScale
          goItem.name = "skills_" .. curIdx
          goItem:SetActive(true)
          local skillNode = self.content:AddComponent(UIDesertRulesEpidemicSkillCell, goItem.name)
          skillNode:ReInit(skillData, battleType)
        end)
      end
    end
  end
end

return UIDesertRulesSkillItem
