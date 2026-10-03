local base = require("UI.UILWHero.UIHeroSimpleTip.View.UIArrowTipBase")
local UITacticalEquipResearchStageTipsView = BaseClass("UITacticalEquipResearchStageTipsView", base)
local Localization = CS.GameEntry.Localization
local TacticalEquipStaticAttriItem = require("UI.UILWTacticalWeaponEquip.UITacticalEquipUpgrade.Component.TacticalEquipStaticAttriItem")

local function ComponentDefine(self)
  base.ComponentDefine(self)
  self.textDesc = self:AddComponent(UITextMeshProUGUIEx, "Root/ImgBg/Content/desc")
  self.compContent = self:AddComponent(UIBaseContainer, "Root/ImgBg/Content/attributeNode/content")
  self.loopListView2AttributeNode = self:AddComponent(UILoopListView2, "Root/ImgBg/Content/attributeNode")
  self.loopListView2AttributeNode:InitListView(0, function(loopView, index, item)
    return self:OnGetItemByIndex(loopView, index)
  end)
  self.itemIndex = 0
end

local function ComponentDestroy(self)
  self.compContent:RemoveComponents(TacticalEquipStaticAttriItem)
  self.loopListView2AttributeNode:ClearAllItems()
  self.itemIndex = nil
  self.effectList = nil
  self.textDesc = nil
  self.compContent = nil
  self.loopListView2AttributeNode = nil
  base.ComponentDestroy(self)
end

local function RefreshShow(self)
  base.RefreshShow(self)
  self.textDesc:SetLocalText("squad_equip_research_desc_8", self.param.percentValue)
  self:RefreshAttributes()
end

function UITacticalEquipResearchStageTipsView:RefreshAttributes()
  local effectList = DataCenter.CommonEquipDataManager:GetStageAttribute(self.param.equipData.config.lv_group, self.param.percentValue)
  self.effectList = DataCenter.CommonEquipDataManager:GetAttributePairsDataList(effectList)
  if self.effectList then
    self.loopListView2AttributeNode:SetListItemCount(#self.effectList, false, false)
  end
end

function UITacticalEquipResearchStageTipsView:OnGetItemByIndex(loopScroll, index)
  if self.effectList ~= nil then
    local count = #self.effectList
    index = index + 1
    if index < 1 or count < index then
      return nil
    end
    self.itemIndex = self.itemIndex + 1
    local item = loopScroll:NewListViewItem("TacticalAttributeTipsItem")
    local script = self.compContent:GetComponent(item.gameObject.name, TacticalEquipStaticAttriItem)
    if script == nil then
      local name = "attribute_" .. self.itemIndex
      item.gameObject.name = name
      script = self.compContent:AddComponent(TacticalEquipStaticAttriItem, name)
    end
    local data = self.effectList[index]
    script:SetLocalScaleXYZ(1, 1, 1)
    script:SetData(data)
    script:SetActive(true)
    return item
  end
end

UITacticalEquipResearchStageTipsView.ComponentDefine = ComponentDefine
UITacticalEquipResearchStageTipsView.ComponentDestroy = ComponentDestroy
UITacticalEquipResearchStageTipsView.RefreshShow = RefreshShow
return UITacticalEquipResearchStageTipsView
