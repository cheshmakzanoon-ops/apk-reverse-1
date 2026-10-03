local UISeasonOfficialApplyEffectPanel = BaseClass("UISeasonOfficialApplyEffectPanel", UIBaseContainer)
local base = UIBaseContainer
local PresidentBuffItem = require("UI.UIGovernment.PresidentBuff.Component.PresidentBuffItem")
local row_path = "Row"
local row_height = 66

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
  self.content = self:AddComponent(UIBaseContainer, "")
  self.theItem = self.transform:Find(row_path).gameObject
  self.theItem:GameObjectCreatePool()
end

local function ComponentDestroy(self)
  self:ClearRow()
  self.content = nil
  self.theItem = nil
end

local function DataDefine(self)
end

local function DataDestroy(self)
end

local function OnAddListener(self)
end

local function OnRemoveListener(self)
end

local function SetData(self, cfgId)
  self:ClearRow()
  local goItem, itemNode
  local buffs = DataCenter.GovernmentManager:GetEffectBuffs(cfgId, 0)
  for index, buff in ipairs(buffs) do
    local effectId = buff.effectId
    local buffAddNum = buff.buffAddNum
    local effectName = buff.effectName
    local levelName = "eff_" .. effectId
    goItem = self.theItem:GameObjectSpawn(self.content.transform)
    goItem.name = levelName
    goItem:SetActive(true)
    itemNode = self.content:AddComponent(PresidentBuffItem, levelName)
    itemNode:ReInit(effectName, buffAddNum)
  end
  if itemNode ~= nil then
    itemNode:HideLine()
  end
  self:SetSizeDeltaY(table.count(buffs) * row_height)
end

local function ClearRow(self)
  self.content:RemoveComponents(PresidentBuffItem)
  self.theItem:GameObjectRecycleAll()
end

UISeasonOfficialApplyEffectPanel.OnCreate = OnCreate
UISeasonOfficialApplyEffectPanel.OnDestroy = OnDestroy
UISeasonOfficialApplyEffectPanel.OnEnable = OnEnable
UISeasonOfficialApplyEffectPanel.OnDisable = OnDisable
UISeasonOfficialApplyEffectPanel.ComponentDefine = ComponentDefine
UISeasonOfficialApplyEffectPanel.ComponentDestroy = ComponentDestroy
UISeasonOfficialApplyEffectPanel.DataDefine = DataDefine
UISeasonOfficialApplyEffectPanel.DataDestroy = DataDestroy
UISeasonOfficialApplyEffectPanel.OnAddListener = OnAddListener
UISeasonOfficialApplyEffectPanel.OnRemoveListener = OnRemoveListener
UISeasonOfficialApplyEffectPanel.SetData = SetData
UISeasonOfficialApplyEffectPanel.ClearRow = ClearRow
return UISeasonOfficialApplyEffectPanel
