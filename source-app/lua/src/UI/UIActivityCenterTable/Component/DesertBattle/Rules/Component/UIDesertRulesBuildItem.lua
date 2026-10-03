local UIDesertRulesBuildItem = BaseClass("UIDesertRulesBuildItem", UIAsyncContainer)
local base = UIAsyncContainer
local UIDesertRulesBuildItemCell = require("UI.UIActivityCenterTable.Component.DesertBattle.Rules.Component.UIDesertRulesBuildItemCell")
local PREFAB_PATH = "Assets/Main/Prefabs/UI/ActivityCenter/DesertBattle/RulesCells/DesertBattleRuleBuildCell.prefab"
local content_path = "ScrollView/Viewport/Content"

function UIDesertRulesBuildItem:OnCreate()
  base.OnCreate(self)
  self.content = self:AddComponent(UIBaseContainer, content_path)
end

function UIDesertRulesBuildItem:OnDestroy()
  self.content:RemoveComponents(UIDesertRulesBuildItemCell)
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

function UIDesertRulesBuildItem:ReInit(theType, battleType)
  local templates = {}
  local ruleList = BattleFieldUtil.GetRuleList(battleType, theType)
  for _, rule in ipairs(ruleList) do
    local template = BattleFieldUtil.GetBuildTemplate(rule.battle_building, battleType)
    if template ~= nil then
      table.insert(templates, template)
    end
  end
  if 0 < #templates then
    table.sort(templates, function(a, b)
      return a.id < b.id
    end)
    self.reqs = {}
    for i, v in ipairs(templates) do
      if v ~= nil then
        local curIdx = i
        local template = v
        self.reqs[i] = self:GameObjectInstantiateAsync(PREFAB_PATH, function(req)
          if req.isError then
            return
          end
          local goItem = req.gameObject
          goItem.transform:SetParent(self.content.transform)
          goItem.transform.localScale = ResetScale
          goItem.name = "build_" .. curIdx
          goItem:SetActive(true)
          local itemNode = self.content:AddComponent(UIDesertRulesBuildItemCell, goItem.name)
          itemNode:ReInit(template, battleType)
        end)
      end
    end
  end
end

return UIDesertRulesBuildItem
