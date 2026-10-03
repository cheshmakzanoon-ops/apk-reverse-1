local TacticalEquipEmptyPanel = BaseClass("TacticalEquipEmptyPanel", UIBaseContainer)
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization
local TacticalEquipItem = require("UI.UILWTacticalWeaponEquip.UITacticalEquipUpgrade.Component.TacticalEquipItem")

local function OnCreate(self)
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

local function OnDestroy(self)
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

local function OnEnable(self)
  base.OnEnable(self)
end

local function OnDisable(self)
  self.curSelectEquip = nil
  self.equipData = nil
  self.slot = nil
  self.freeEquips, self.freeEquipsCount = nil, nil
  base.OnDisable(self)
end

local function ComponentDefine(self)
  self.textNoneTips = self:AddComponent(UITextMeshProUGUIEx, "noneTips")
  self.loopGridViewItemHolder = self:AddComponent(UILoopGridView, "ItemHolder")
  self.compItemContent = self:AddComponent(UIBaseContainer, "ItemHolder/Viewport/ItemContent")
  self.compCostPropsNode = self:AddComponent(UIBaseContainer, "costPropsNode")
  self.textCostPropsDesc = self:AddComponent(UITextMeshProUGUIEx, "costPropsNode/costPropsDesc")
  self.textPropsNeedNum = self:AddComponent(UITextMeshProUGUIEx, "costPropsNode/propsNeedNum")
  self.textNoneCostTips = self:AddComponent(UITextMeshProUGUIEx, "costPropsNode/noneCostTips")
end

local function ComponentDestroy(self)
  self.textNoneTips = nil
  self.loopGridViewItemHolder = nil
  self.compItemContent = nil
  self.compCostPropsNode = nil
  self.textCostPropsDesc = nil
  self.textPropsNeedNum = nil
  self.textNoneCostTips = nil
end

local function DataDefine(self)
  self.compCostEquipItem = self:AddComponent(TacticalEquipItem, "costPropsNode/propsNode/costEquipItem")
  self.loopGridViewItemHolder:InitGridView(0, function(loopScroll, index, item)
    return self:OnGetItemByRowColumn(loopScroll, index)
  end)
  self.textPropsNeedNum:SetActive(false)
end

local function DataDestroy(self)
  self.compItemContent:RemoveComponents(TacticalEquipItem)
  if self.loopGridViewItemHolder then
    self.loopGridViewItemHolder:ClearAllItems()
  end
end

local function OnAddListener(self)
  base.OnAddListener(self)
end

local function OnRemoveListener(self)
  base.OnRemoveListener(self)
end

function TacticalEquipEmptyPanel:SetData(equipData, slot, isFromShortcutKey)
  self.equipData = equipData
  self.slot = slot
  self:RefreshOwnList()
  self:RefreshCost()
  self:RefreshBtnStatus()
end

function TacticalEquipEmptyPanel:RefreshOwnList()
  self.freeEquips, self.freeEquipsCount = DataCenter.CommonEquipDataManager:GetAllFreeEquipBagData(self.slot)
  if self.freeEquipsCount > 0 then
    self.loopGridViewItemHolder:SetListItemCount(self.freeEquipsCount)
    self.loopGridViewItemHolder:RefreshAllShownItem()
    self.holder:SetShowBtn({
      TacticalEquipBtnStatus.Use
    })
  end
  self.loopGridViewItemHolder:SetActive(self.freeEquipsCount > 0)
  self.textNoneCostTips:SetActive(self.freeEquipsCount <= 0)
  self.textCostPropsDesc:SetActive(self.freeEquipsCount > 0)
end

function TacticalEquipEmptyPanel:RefreshCost()
  if self.freeEquipsCount > 0 then
    local equip = DataCenter.CommonEquipDataManager:GetOwnMaxLvFreeEquip(self.slot)
    self.compCostEquipItem:SetData(equip, self.slot)
    self.compCostEquipItem:SetItemCountActive(false)
    self.curSelectEquip = equip
  end
  self.compCostEquipItem:SetActive(self.freeEquipsCount > 0)
end

function TacticalEquipEmptyPanel:RefreshBtnStatus()
  if self.freeEquipsCount > 0 then
    self.holder:SetShowBtn({
      TacticalEquipBtnStatus.Use
    })
  else
    self.holder:SetShowBtn({
      TacticalEquipBtnStatus.GetMore
    })
  end
end

function TacticalEquipEmptyPanel:GetCurSelectEquipData()
  return self.curSelectEquip
end

function TacticalEquipEmptyPanel:OnGetItemByRowColumn(loopScroll, index)
  if self.freeEquips ~= nil then
    local count = #self.freeEquips
    index = index + 1
    if index < 1 or index > self.freeEquipsCount then
      return nil
    end
    local item = loopScroll:NewListViewItem("TacticalEquipItem")
    local script = self.compItemContent:GetComponent(item.gameObject.name, TacticalEquipItem)
    if script == nil then
      local name = "equip_" .. index
      item.gameObject.name = name
      script = self.compItemContent:AddComponent(TacticalEquipItem, name)
    end
    local data = self.freeEquips[index]
    script:SetLocalScaleXYZ(0.7, 0.7, 0.7)
    script:SetData(data, self.slot)
    script:SetBtnActive(false)
    script:SetActive(true)
    return item
  end
end

TacticalEquipEmptyPanel.OnCreate = OnCreate
TacticalEquipEmptyPanel.OnDestroy = OnDestroy
TacticalEquipEmptyPanel.OnEnable = OnEnable
TacticalEquipEmptyPanel.OnDisable = OnDisable
TacticalEquipEmptyPanel.ComponentDefine = ComponentDefine
TacticalEquipEmptyPanel.ComponentDestroy = ComponentDestroy
TacticalEquipEmptyPanel.DataDefine = DataDefine
TacticalEquipEmptyPanel.DataDestroy = DataDestroy
TacticalEquipEmptyPanel.OnAddListener = OnAddListener
TacticalEquipEmptyPanel.OnRemoveListener = OnRemoveListener
return TacticalEquipEmptyPanel
