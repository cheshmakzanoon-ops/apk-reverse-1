local LWPowerOverviewItem = BaseClass("LWPowerOverviewItem", UIBaseContainer)
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization
local LWPowerOverviewItemTitle = require("UI.LWPowerOverview.Component.LWPowerOverviewItemTitle")
local LWPowerOverviewItemContent = require("UI.LWPowerOverview.Component.LWPowerOverviewItemContent")
local lw_power_overview_item_content_path = "LWPowerOverviewItemContent"
local power_source_type_content_path = "PowerSourceTypeContent"
local button_path = "LWPowerOverviewItemTitle/Content/buttonContent/button"

function LWPowerOverviewItem:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function LWPowerOverviewItem:OnDestroy()
  self:ComponentDestroy()
  self:DataDestroy()
  base.OnDestroy(self)
end

function LWPowerOverviewItem:ComponentDefine()
  self.LWPowerOverviewItemTitle = self:AddComponent(LWPowerOverviewItemTitle, "LWPowerOverviewItemTitle")
  self.goItem = self.transform:Find(lw_power_overview_item_content_path).gameObject
  self.goItem:GameObjectCreatePool()
  self.power_source_type_content = self:AddComponent(UIBaseContainer, power_source_type_content_path)
  self.button = self:AddComponent(UIButton, button_path)
  self.button:SetOnClick(function()
    self:OnClick()
  end)
end

function LWPowerOverviewItem:ComponentDestroy()
  self.LWPowerOverviewItemTitle = nil
  self.goItem:GameObjectRecycleAll()
  self.power_source_type_content:RemoveComponents(LWPowerOverviewItemContent)
  self.power_source_type_content = nil
  self.button = nil
end

function LWPowerOverviewItem:DataDefine()
end

function LWPowerOverviewItem:DataDestroy()
end

function LWPowerOverviewItem:Refresh(data)
  self.data = data
  self.goItem:GameObjectRecycleAll()
  self.power_source_type_content:RemoveComponents(LWPowerOverviewItemContent)
  local powerSourceList = self.data.sourceTab
  for i = 1, table.count(powerSourceList) do
    local goObj = self.goItem:GameObjectSpawn(self.power_source_type_content.transform)
    goObj.name = "item_" .. i
    goObj:SetActive(true)
    local itemRender = self.power_source_type_content:AddComponent(LWPowerOverviewItemContent, goObj.name)
    itemRender:Refresh(powerSourceList[i])
  end
  self:RefreshShowTypeView()
end

function LWPowerOverviewItem:RefreshShowTypeView()
  if self.data.sourceTab and #self.data.sourceTab > 0 then
    self.power_source_type_content:SetActive(self.data.isShowDetail)
  else
    self.power_source_type_content:SetActive(false)
  end
  self.LWPowerOverviewItemTitle:Refresh(self.data)
end

function LWPowerOverviewItem:OnClick()
  self.data.isShowDetail = not self.data.isShowDetail
  self:RefreshShowTypeView()
end

return LWPowerOverviewItem
