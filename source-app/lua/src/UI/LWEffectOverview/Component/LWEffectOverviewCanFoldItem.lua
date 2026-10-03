local LWEffectOverviewCanFoldItem = BaseClass("LWEffectOverviewCanFoldItem", UIBaseContainer)
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization
local LWPowerOverviewItemTitle = require("UI.LWEffectOverview.Component.LWEffectOverviewCanFoldItemTitle")
local LWPowerOverviewItemContent = require("UI.LWEffectOverview.Component.LWPowerOverviewCanFoldItemContent")
local lw_power_overview_item_content_path = "propertyRow"
local power_source_type_content_path = "PowerSourceTypeContent"
local button_path = "title/Content/buttonContent/button"

function LWEffectOverviewCanFoldItem:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function LWEffectOverviewCanFoldItem:OnDestroy()
  self:ComponentDestroy()
  self:DataDestroy()
  base.OnDestroy(self)
end

function LWEffectOverviewCanFoldItem:ComponentDefine()
  self.LWPowerOverviewItemTitle = self:AddComponent(LWPowerOverviewItemTitle, "title")
  self.goItem = self.transform:Find(lw_power_overview_item_content_path).gameObject
  self.goItem:GameObjectCreatePool()
  self.effect_source_type_content = self:AddComponent(UIBaseContainer, power_source_type_content_path)
  self.button = self:AddComponent(UIButton, button_path)
  self.button:SetOnClick(function()
    self:OnClick()
  end)
end

function LWEffectOverviewCanFoldItem:ComponentDestroy()
  self.LWPowerOverviewItemTitle = nil
  self.goItem:GameObjectRecycleAll()
  self.effect_source_type_content:RemoveComponents(LWPowerOverviewItemContent)
  self.effect_source_type_content = nil
  self.button = nil
end

function LWEffectOverviewCanFoldItem:DataDefine()
end

function LWEffectOverviewCanFoldItem:DataDestroy()
end

function LWEffectOverviewCanFoldItem:Refresh(data)
  self.data = data
  self.LWPowerOverviewItemTitle:Refresh(self.data)
  self.goItem:GameObjectRecycleAll()
  self.effect_source_type_content:RemoveComponents(LWPowerOverviewItemContent)
  local effectSourceList = DataCenter.LWEffectOverviewManager:GetUnlockEffectSourceList(self.data.id)
  for i = 1, table.count(effectSourceList) do
    local effectSourceType = effectSourceList[i]
    local goObj = self.goItem:GameObjectSpawn(self.effect_source_type_content.transform)
    goObj.name = "item_" .. i
    goObj:SetActive(true)
    local itemRender = self.effect_source_type_content:AddComponent(LWPowerOverviewItemContent, goObj.name)
    itemRender:Refresh(self.data, effectSourceType)
  end
end

function LWEffectOverviewCanFoldItem:RefreshShowTypeView()
  local effectSourceList = DataCenter.LWEffectOverviewManager:GetUnlockEffectSourceList(self.data.id)
  if effectSourceList and 0 < #effectSourceList then
    self.effect_source_type_content:SetActive(self.data.isShowDetail)
  else
    self.effect_source_type_content:SetActive(false)
  end
  self.LWPowerOverviewItemTitle:Refresh(self.data)
end

function LWEffectOverviewCanFoldItem:OnClick()
  self.data.isShowDetail = not self.data.isShowDetail
  self:RefreshShowTypeView()
end

return LWEffectOverviewCanFoldItem
