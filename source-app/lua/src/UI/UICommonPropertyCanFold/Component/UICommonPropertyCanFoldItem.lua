local UICommonPropertyCanFoldItem = BaseClass("UICommonPropertyCanFoldItem", UIBaseContainer)
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization
local UICommonPropertyCanFoldItemTitle = require("UI.UICommonPropertyCanFold.Component.UICommonPropertyCanFoldItemTitle")
local UICommonPropertyCanFoldItemRow = require("UI.UICommonPropertyCanFold.Component.UICommonPropertyCanFoldItemRow")
local lw_power_overview_item_content_path = "propertyRow"
local power_source_type_content_path = "PowerSourceTypeContent"
local button_path = "title/Content/buttonContent/button"

function UICommonPropertyCanFoldItem:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function UICommonPropertyCanFoldItem:OnDestroy()
  self:ComponentDestroy()
  self:DataDestroy()
  base.OnDestroy(self)
end

function UICommonPropertyCanFoldItem:ComponentDefine()
  self.titleCpt = self:AddComponent(UICommonPropertyCanFoldItemTitle, "title")
  self.goItem = self.transform:Find(lw_power_overview_item_content_path).gameObject
  self.goItem:GameObjectCreatePool()
  self.effect_source_type_content = self:AddComponent(UIBaseContainer, power_source_type_content_path)
  self.button = self:AddComponent(UIButton, button_path)
  self.button:SetOnClick(function()
    self:OnClick()
  end)
end

function UICommonPropertyCanFoldItem:ComponentDestroy()
  self.titleCpt = nil
  self.goItem:GameObjectRecycleAll()
  self.effect_source_type_content:RemoveComponents(UICommonPropertyCanFoldItemRow)
  self.effect_source_type_content = nil
  self.button = nil
end

function UICommonPropertyCanFoldItem:DataDefine()
end

function UICommonPropertyCanFoldItem:DataDestroy()
end

function UICommonPropertyCanFoldItem:Refresh(data)
  self.data = data
  self.titleCpt:Refresh(self.data)
  self.goItem:GameObjectRecycleAll()
  self.effect_source_type_content:RemoveComponents(UICommonPropertyCanFoldItemRow)
  for i = 1, table.count(data.propertyList) do
    local goObj = self.goItem:GameObjectSpawn(self.effect_source_type_content.transform)
    goObj.name = "item_" .. i
    goObj:SetActive(true)
    local itemRender = self.effect_source_type_content:AddComponent(UICommonPropertyCanFoldItemRow, goObj.name)
    itemRender:Refresh(data.propertyList[i])
  end
end

function UICommonPropertyCanFoldItem:RefreshShowTypeView()
  if self.data.hasRows then
    self.effect_source_type_content:SetActive(self.data.isShowDetail)
  else
    self.effect_source_type_content:SetActive(false)
  end
  self.titleCpt:Refresh(self.data)
  CS.UnityEngine.UI.LayoutRebuilder.ForceRebuildLayoutImmediate(self.titleCpt.transform.parent.parent.parent.parent)
end

function UICommonPropertyCanFoldItem:OnClick()
  self.data.isShowDetail = not self.data.isShowDetail
  self:RefreshShowTypeView()
end

return UICommonPropertyCanFoldItem
