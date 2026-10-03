local base = require("UI.UILWHero.UIHeroSimpleTip.View.UIArrowTipBase")
local UIHeroGroupedPropertyDetailTipView = BaseClass("UIHeroGroupedPropertyDetailTipView", base)
local Localization = CS.GameEntry.Localization
local UIHeroPropertyCell = require("UI.UILWHero.UIHeroPropertyDetailTip.Component.UIHeroPropertyCell_hero")
local Screen = CS.UnityEngine.Screen
local cell_path = "PropertyItem"
local cell_content_path = "Root/ImgBg/Content/cells_content"
local main_prop_name_path = "Root/ImgBg/Content/PropertyMain/Name"
local main_prop_value_path = "Root/ImgBg/Content/PropertyMain/Value"

function UIHeroGroupedPropertyDetailTipView:OnCreate()
  base.OnCreate(self)
  self.hasRefreshed = false
  SFSNetwork.SendMessage(MsgDefines.HeroDetailEffect, self.param.heroData.uuid)
end

function UIHeroGroupedPropertyDetailTipView:OnDestroy()
  base.OnDestroy(self)
  self.hasRefreshed = nil
end

function UIHeroGroupedPropertyDetailTipView:ComponentDefine()
  base.ComponentDefine(self)
  self.cells = {}
  self.cellPrefab = self.transform:Find(cell_path).gameObject
  self.cellPrefab:GameObjectCreatePool()
  self.cellContent = self:AddComponent(UIBaseContainer, cell_content_path)
  self.mainPropName = self:AddComponent(UIText, main_prop_name_path)
  self.mainPropValue = self:AddComponent(UIText, main_prop_value_path)
  self.compContent = self:AddComponent(UIBaseComponent, "Root/ImgBg/Content")
  self.compEmpty = self:AddComponent(UIBaseComponent, "Root/ImgBg/EmptyGroup")
end

function UIHeroGroupedPropertyDetailTipView:ComponentDestroy()
  if self.cells ~= nil then
    self:ClearCell()
    self.cells = nil
  end
  self.cellPrefab = nil
  self.cellContent = nil
  self.mainPropName = nil
  self.mainPropValue = nil
  self.compContent = nil
  self.compEmpty = nil
  base.ComponentDestroy(self)
end

function UIHeroGroupedPropertyDetailTipView:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.HeroPropertyGroupedDetailDataUpdate, self.OnHeroPropertyGroupedDetailDataUpdate)
end

function UIHeroGroupedPropertyDetailTipView:OnRemoveListener()
  self:RemoveUIListener(EventId.HeroPropertyGroupedDetailDataUpdate, self.OnHeroPropertyGroupedDetailDataUpdate)
  base.OnRemoveListener(self)
end

function UIHeroGroupedPropertyDetailTipView:RefreshShow()
  self.compContent:SetActive(false)
  self.compEmpty:SetActive(true)
end

function UIHeroGroupedPropertyDetailTipView:OnHeroPropertyGroupedDetailDataUpdate(uuid)
  if self.hasRefreshed then
    return
  end
  if self.param.heroData == nil or self.param.heroData.uuid ~= uuid then
    return
  end
  if self.param.heroData == nil then
    return
  end
  local propertyGroupedDetailData = self.param.heroData:GetPropertyGroupedDetailData()
  if propertyGroupedDetailData == nil then
    return
  end
  self.hasRefreshed = true
  self.compContent:SetActive(true)
  self.compEmpty:SetActive(false)
  local showData = self.ctrl:GetShowData(self.param.heroData, self.param.propertyType)
  self.mainPropName:SetText(showData.mainPropName)
  self.mainPropValue:SetText(string.GetFormattedSeparatorNum(showData.mainPropValue))
  local totalCount = #showData.splitProp
  if totalCount <= 0 then
    return
  end
  local index = 0
  for k, v in ipairs(showData.splitProp) do
    local c = self.cellPrefab:GameObjectSpawn(self.cellContent.transform)
    table.insert(self.cells, c)
    NameCount = NameCount + 1
    c.name = tostring(NameCount)
    c.gameObject:SetActive(true)
    local cell = self.cellContent:AddComponent(UIHeroPropertyCell, c.name)
    cell:Refresh(v, index % 2 == 0)
    index = index + 1
  end
  self:ReAlign()
end

function UIHeroGroupedPropertyDetailTipView:ClearCell()
  if self.cells ~= nil then
    self.cellContent:RemoveComponents(UIHeroPropertyCell)
    self.cellPrefab:GameObjectRecycleAll()
    self.cells = {}
  end
end

return UIHeroGroupedPropertyDetailTipView
