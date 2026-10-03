local UIDesertRulesRoleItem = BaseClass("UIDesertRulesRoleItem", UIAsyncContainer)
local base = UIAsyncContainer
local TMProExText = typeof(CS.TextMeshProUGUIEx)
local PREFAB_PATH = "Assets/Main/Prefabs/UI/ActivityCenter/DesertBattle/RulesCells/DesertBattleRuleNormalCell.prefab"
local UIDesertRulesPassiveSkillGroup = require("UI.UIActivityCenterTable.Component.DesertBattle.Rules.Component.UIDesertRulesPassiveSkillGroup")
local content_path = "ScrollView/Viewport/Content"

function UIDesertRulesRoleItem:OnCreate()
  base.OnCreate(self)
  self.content = self:AddComponent(UIBaseContainer, content_path)
end

function UIDesertRulesRoleItem:OnDestroy()
  self.content:RemoveComponents(UIDesertRulesPassiveSkillGroup)
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

function UIDesertRulesRoleItem:ReInit(theType, battleType)
  local dataList = BattleFieldUtil.GetRuleList(battleType, theType)
  self.reqs = {}
  for i, v in ipairs(dataList) do
    if v ~= nil then
      local curIdx = i
      local ruleData = v
      self.reqs[i] = self:GameObjectInstantiateAsync(PREFAB_PATH, function(req)
        if req.isError then
          return
        end
        local goItem = req.gameObject
        goItem.transform:SetParent(self.content.transform)
        goItem.transform.localScale = ResetScale
        goItem.name = "Item" .. curIdx
        goItem:SetActive(true)
        local nameObj = goItem.transform:Find("bg/name"):GetComponent(TMProExText)
        nameObj:SetLocalText(ruleData.title)
        local descObj = goItem.transform:Find("desc"):GetComponent(TMProExText)
        if string.IsNullOrEmpty(ruleData.desc1) then
          descObj.gameObject:SetActive(false)
        else
          descObj:SetLocalText(ruleData.desc1)
          descObj.gameObject:SetActive(true)
        end
        local skills = ruleData.battle_skill
        local isSkill = not string.IsNullOrEmpty(skills)
        if isSkill then
          local skillGroup = self.content:AddComponent(UIDesertRulesPassiveSkillGroup, goItem.name)
          skillGroup:ReInit(string.string2array_i_oneSep(skills, ","), battleType)
        else
        end
      end)
    end
  end
end

return UIDesertRulesRoleItem
