local base = require("UI.UILWHero.UIHeroSimpleTip.View.UIArrowTipBase")
local UITacticalEquipItemTipsView = BaseClass("UITacticalEquipItemTipsView", base)
local Localization = CS.GameEntry.Localization
local TacticalEquipStaticAttriItem = require("UI.UILWTacticalWeaponEquip.UITacticalEquipUpgrade.Component.TacticalEquipStaticAttriItem")

local function ComponentDefine(self)
  base.ComponentDefine(self)
  self.textTitle = self:AddComponent(UITextMeshProUGUIEx, "Root/ImgBg/Content/TitleText")
  self.textPowerNumber = self:AddComponent(UITextMeshProUGUIEx, "Root/ImgBg/Content/PowerIcon/powerNumberText")
  self.compContent = self:AddComponent(UIBaseContainer, "Root/ImgBg/Content/attributeNode/content")
  self.loopListView2AttributeNode = self:AddComponent(UILoopListView2, "Root/ImgBg/Content/attributeNode")
  self.loopListView2AttributeNode:InitListView(0, function(loopView, index, item)
    return self:OnGetItemByIndex(loopView, index)
  end)
  self.itemIndex = 0
end

local function ComponentDestroy(self)
  self.itemIndex = nil
  self.effectList = nil
  if self.compContent then
    self.compContent:RemoveComponents(TacticalEquipStaticAttriItem)
  end
  if self.loopListView2AttributeNode then
    self.loopListView2AttributeNode:ClearAllItems()
  end
  self.textTitle = nil
  self.textPowerNumber = nil
  self.compContent = nil
  self.loopListView2AttributeNode = nil
  base.ComponentDestroy(self)
end

function UITacticalEquipItemTipsView:RefreshShow()
  base.RefreshShow(self)
  self.textTitle:SetLocalText(self.param.equipData.config.name)
  self.textPowerNumber:SetText(self.param.equipData.config.power)
  self:RefreshAttributes()
end

function UITacticalEquipItemTipsView:RefreshAttributes()
  self.effectList = DataCenter.CommonEquipDataManager:GetAttributePairsDataList(self.param.equipData:GetEffects())
  if self.effectList then
    self.loopListView2AttributeNode:SetListItemCount(#self.effectList, false, false)
  end
end

function UITacticalEquipItemTipsView:OnGetItemByIndex(loopScroll, index)
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

UITacticalEquipItemTipsView.ComponentDefine = ComponentDefine
UITacticalEquipItemTipsView.ComponentDestroy = ComponentDestroy
return UITacticalEquipItemTipsView
