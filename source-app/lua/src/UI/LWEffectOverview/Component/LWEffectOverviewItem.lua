local LWEffectOverviewItem = BaseClass("LWEffectOverviewItem", UIBaseContainer)
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization
local LWEffectOverviewItemTitle = require("UI.LWEffectOverview.Component.LWEffectOverviewItemTitle")
local LWEffectOverviewItemContent = require("UI.LWEffectOverview.Component.LWEffectOverviewItemContent")
local lw_effect_overview_item_content_path = "LWEffectOverviewItemContent"
local effect_source_type_content_path = "EffectSourceTypeContent"

function LWEffectOverviewItem:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function LWEffectOverviewItem:OnDestroy()
  self:ComponentDestroy()
  self:DataDestroy()
  base.OnDestroy(self)
end

function LWEffectOverviewItem:ComponentDefine()
  self.LWEffectOverviewItemTitle = self:AddComponent(LWEffectOverviewItemTitle, "LWEffectOverviewItemTitle")
  self.goItem = self.transform:Find(lw_effect_overview_item_content_path).gameObject
  self.goItem:GameObjectCreatePool()
  self.effect_source_type_content = self:AddComponent(UIBaseContainer, effect_source_type_content_path)
end

function LWEffectOverviewItem:ComponentDestroy()
  self.LWEffectOverviewItemTitle = nil
  self.goItem:GameObjectRecycleAll()
  self.effect_source_type_content:RemoveComponents(LWEffectOverviewItemContent)
  self.effect_source_type_content = nil
end

function LWEffectOverviewItem:DataDefine()
end

function LWEffectOverviewItem:DataDestroy()
end

function LWEffectOverviewItem:Refresh(data)
  self.data = data
  self.LWEffectOverviewItemTitle:Refresh(self.data)
  self.goItem:GameObjectRecycleAll()
  self.effect_source_type_content:RemoveComponents(LWEffectOverviewItemContent)
  local effectSourceList = DataCenter.LWEffectOverviewManager:GetUnlockEffectSourceList(self.data.id)
  for i = 1, table.count(effectSourceList) do
    local effectSourceType = effectSourceList[i]
    local goObj = self.goItem:GameObjectSpawn(self.effect_source_type_content.transform)
    goObj.name = "item_" .. i
    goObj:SetActive(true)
    local itemRender = self.effect_source_type_content:AddComponent(LWEffectOverviewItemContent, goObj.name)
    itemRender:Refresh(self.data, effectSourceType)
  end
end

return LWEffectOverviewItem
