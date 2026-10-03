local base = UIBaseContainer
local SoldierDeadRuleGrid = BaseClass("SoldierDeadRuleGrid", base)
local RuleLineItem = require("UI.UILWSoldierDeadRateRule.Component.RuleLineItem")
local lineItme_path = "lineItem"

local function OnCreate(self)
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

local function OnDestroy(self)
  self:ComponentDestroy()
  self:DataDestroy()
  base.OnDestroy(self)
end

local function OnEnable(self)
  base.OnEnable(self)
end

local function OnDisable(self)
  base.OnDisable(self)
end

local function ComponentDefine(self)
  self.lineItem = self:AddComponent(UIBaseContainer, lineItme_path)
  self.lintItemObj = self.lineItem.gameObject
  self.lintItemObj:GameObjectCreatePool()
end

local function ComponentDestroy(self)
  self.lineItem = nil
  self:RemoveComponents(RuleLineItem)
  self.lintItemObj:GameObjectRecycleAll()
end

local function DataDefine(self)
end

local function DataDestroy(self)
end

local function SetData(self, list)
  if list == nil then
    return
  end
  self:RemoveComponents(RuleLineItem)
  self.lintItemObj:GameObjectRecycleAll()
  for i = 1, #list do
    local item = self.lintItemObj:GameObjectSpawn(self.transform)
    item:SetActive(true)
    item.transform.localScale = Vector3.one
    item.transform.localPosition = Vector3.New(0, 0, 0)
    local nameStr = string.format("lineItem%s", i)
    item.name = nameStr
    local itemData = list[i]
    local itemScript = self:AddComponent(RuleLineItem, nameStr)
    itemScript:SetData(itemData.name, itemData.val1, itemData.val2, i)
  end
end

SoldierDeadRuleGrid.OnCreate = OnCreate
SoldierDeadRuleGrid.OnDestroy = OnDestroy
SoldierDeadRuleGrid.OnEnable = OnEnable
SoldierDeadRuleGrid.OnDisable = OnDisable
SoldierDeadRuleGrid.ComponentDefine = ComponentDefine
SoldierDeadRuleGrid.ComponentDestroy = ComponentDestroy
SoldierDeadRuleGrid.DataDefine = DataDefine
SoldierDeadRuleGrid.DataDestroy = DataDestroy
SoldierDeadRuleGrid.SetData = SetData
return SoldierDeadRuleGrid
