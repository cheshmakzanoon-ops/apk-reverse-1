local UIDesertRulesItem1 = BaseClass("UIDesertRulesItem1", UIAsyncContainer)
local base = UIAsyncContainer
local TMProExText = typeof(CS.TextMeshProUGUIEx)
local PREFAB_PATH = "Assets/Main/Prefabs/UI/ActivityCenter/DesertBattle/RulesCells/DesertBattleRuleNormalCell.prefab"
local content_path = "ScrollView/Viewport/Content"

function UIDesertRulesItem1:OnCreate()
  base.OnCreate(self)
  self.content = self:AddComponent(UIBaseContainer, content_path)
end

function UIDesertRulesItem1:OnDestroy()
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

function UIDesertRulesItem1:ReInit(theType, battleType)
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
        goItem.name = "time_" .. curIdx
        goItem:SetActive(true)
        local nameObj = goItem.transform:Find("bg/name"):GetComponent(TMProExText)
        local descObj = goItem.transform:Find("desc"):GetComponent(TMProExText)
        nameObj:SetLocalText(ruleData.title)
        descObj:SetLocalText(ruleData.desc1)
      end)
    end
  end
end

return UIDesertRulesItem1
