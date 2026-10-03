local base = UIBaseContainer
local GrowBagContentComponent = BaseClass("GrowBagContentComponent", UIBaseContainer)
local Localization = CS.GameEntry.Localization
local UIEquipItemComponent = require("UI.UILWStageSkyBattleChapter.Components.UIEquipItemComponent")
local RecycleItemsPanelComponent = require("UI.UILWStageSkyBattleChapter.Components.RecycleItemsPanelComponent")

function GrowBagContentComponent:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
  self:Init()
end

function GrowBagContentComponent:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function GrowBagContentComponent:ComponentDefine()
  self.viewSkin = self:AddComponent(UIViewSkinBridge, "")
  self.btnRecycle = self.viewSkin:AddComponent(self, UIButton, 1)
  self.btnRecycle:SetOnClick(function()
    self:OnBtnRecycleClick()
  end)
  self.scrollRectItemsHolder = self.viewSkin:AddComponent(self, UIScrollRect, 2)
  self.gridInfinityScrollViewItemsContent = self.viewSkin:AddComponent(self, GridInfinityScrollView, 3)
  self.compSelectedItemDetail = self.viewSkin:AddComponent(self, UIBaseComponent, 4)
  self.btnWear = self.viewSkin:AddComponent(self, UIButton, 5)
  self.btnWear:SetOnClick(function()
    self:OnBtnWearClick()
  end)
  self.textBtnWearTxt = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 6)
  self.imgSelectedItemIconBg = self.viewSkin:AddComponent(self, UIImage, 7)
  self.imgSelectedItemIcon = self.viewSkin:AddComponent(self, UIImage, 8)
  self.textSelectedItemTitle = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 9)
  self.textSelectedItemPowerTxt = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 10)
  self.textSelectedItemProperty2 = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 11)
  self.textSelectedItemProperty1 = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 12)
  self.imgSelectedFrame = self.viewSkin:AddComponent(self, UIImage, 13)
  self.textSelectedItemProperty3 = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 14)
  self.textSelectedItemProperty4 = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 15)
  self.compRecycleItemsPanel = self.viewSkin:AddComponent(self, RecycleItemsPanelComponent, 16)
  self.compSelectedItemDetail:SetActive(false)
  self.compRecycleItemsPanel:SetActive(false)
end

function GrowBagContentComponent:ComponentDestroy()
  self:ClearItemCell()
  self.imgSelectedFrame:SetActive(false)
  self.imgSelectedFrame.transform:SetParent(self.transform)
  self.viewSkin = nil
  self.btnRecycle = nil
  self.scrollRectItemsHolder = nil
  self.gridInfinityScrollViewItemsContent = nil
  self.compSelectedItemDetail = nil
  self.btnWear = nil
  self.textBtnWearTxt = nil
  self.imgSelectedItemIconBg = nil
  self.imgSelectedItemIcon = nil
  self.textSelectedItemTitle = nil
  self.textSelectedItemPowerTxt = nil
  self.textSelectedItemProperty2 = nil
  self.textSelectedItemProperty1 = nil
  self.imgSelectedFrame = nil
  self.textSelectedItemProperty3 = nil
  self.textSelectedItemProperty4 = nil
  self.compRecycleItemsPanel = nil
end

function GrowBagContentComponent:DataDefine()
  self.cacheSelectCell = 0
  self.curSelectCell = self.cacheSelectCell
  self.curItemCount = 1
  self.equipItemList = {}
  self.listGO = {}
  self.selectedProperties = {}
  table.insert(self.selectedProperties, self.textSelectedItemProperty1)
  table.insert(self.selectedProperties, self.textSelectedItemProperty2)
  table.insert(self.selectedProperties, self.textSelectedItemProperty3)
  table.insert(self.selectedProperties, self.textSelectedItemProperty4)
end

function GrowBagContentComponent:DataDestroy()
  self.cacheSelectCell = 0
  self.curSelectCell = self.cacheSelectCell
  self.curItemCount = 1
  self.equipItemList = nil
  self.listGO = nil
  self.selectedProperties = nil
  self.showedEquipData = nil
end

function GrowBagContentComponent:Init()
  self:ClearItemCell()
  local bindFunc1 = BindCallback(self, self.OnInitScroll)
  local bindFunc2 = BindCallback(self, self.OnUpdateScroll)
  local bindFunc3 = BindCallback(self, self.OnDestroyScrollItem)
  self.gridInfinityScrollViewItemsContent:Init(bindFunc1, bindFunc2, bindFunc3)
end

function GrowBagContentComponent:OnEnable()
  base.OnEnable(self)
  self:RefreshList()
end

function GrowBagContentComponent:ClearItemCell()
  self.cellItems = {}
  self.scrollRectItemsHolder:RemoveComponents(UIEquipItemComponent)
  self.gridInfinityScrollViewItemsContent:DestroyChildNode()
end

function GrowBagContentComponent:OnInitScroll(go, index)
  local item = self.scrollRectItemsHolder:AddComponent(UIEquipItemComponent, go)
  self.listGO[go] = item
end

function GrowBagContentComponent:OnUpdateScroll(go, index)
  local cellItem = self.listGO[go]
  go.name = "bag_item_" .. index
  local realIndex = index + 1
  local equipData = self.equipItemList[realIndex]
  if equipData then
    cellItem:SetData(self.equipItemList[realIndex], realIndex, true, function(trans, index)
      self:CellsCallBack(trans, index)
    end)
    cellItem:SetActive(true)
    local oldEquipItemData = self.curSelectCell and self.equipItemList[self.curSelectCell] or nil
    if equipData and oldEquipItemData and oldEquipItemData.uuid == equipData.uuid then
      self.cacheSelectCell = nil
      self.curSelectCell = self.cacheSelectCell
      self:CellsCallBack(cellItem.transform, realIndex)
    end
  else
    cellItem:SetActive(false)
  end
  self.cellItems[realIndex] = cellItem
end

function GrowBagContentComponent:OnDestroyScrollItem(go, index)
  local realIndex = index + 1
  if realIndex == self.curSelectCell then
    self.imgSelectedFrame:SetActive(false)
  end
  self.cellItems[realIndex] = nil
end

function GrowBagContentComponent:CellsCallBack(trans, index)
  if self.curSelectCell ~= index then
    self.cacheSelectCell = index
    self.curSelectCell = self.cacheSelectCell
    self.imgSelectedFrame.transform:SetParent(trans:GetChild(0))
    self.imgSelectedFrame.transform:SetAsLastSibling()
    self.imgSelectedFrame.transform:Set_localPosition(0, 0, 0)
    self.imgSelectedFrame.transform:Set_localScale(ResetScale.x, ResetScale.y, ResetScale.z)
    self.imgSelectedFrame:SetActive(true)
    self:RefreshInfo()
  else
    self:RefreshInfo()
  end
end

function GrowBagContentComponent:RefreshInfo()
  if not self.curSelectCell or self.curSelectCell == 0 then
    self.compSelectedItemDetail:SetActive(false)
    return
  end
  self.showedEquipData = self.equipItemList[self.curSelectCell]
  if not self.showedEquipData then
    self.compSelectedItemDetail:SetActive(false)
    return
  end
  self.compSelectedItemDetail:SetActive(true)
  self.imgSelectedItemIconBg:LoadSprite(DataCenter.LWSkyBattleGrowthChapterManager:GetQualityIcon(self.showedEquipData.quality))
  self.imgSelectedItemIcon:LoadSprite(self.showedEquipData.icon)
  self.textSelectedItemTitle:SetLocalText(self.showedEquipData.name)
  self.textSelectedItemPowerTxt:SetText(string.GetFormattedStr(self.showedEquipData.power))
  for type, propertyItem in ipairs(self.selectedProperties) do
    if self.showedEquipData.properties[type] then
      local properTxt = Localization:GetString(DataCenter.LWSkyBattleGrowthChapterManager:GetEquipPropertyNameKey(type))
      local properValue = self.showedEquipData.properties[type].value
      propertyItem:SetText(string.format("%s: %s%d", properTxt, 0 < properValue and "+" or "", properValue))
      propertyItem:SetActive(true)
    else
      propertyItem:SetActive(false)
    end
  end
  local key = self.showedEquipData.wearing and "No-Key-EquipOn" or "430743"
  self.textBtnWearTxt:SetLocalText(key)
end

function GrowBagContentComponent:RefreshList(moveScroll)
  self.compRecycleItemsPanel:SetActive(false)
  self.compSelectedItemDetail:SetActive(false)
  self.imgSelectedFrame:SetActive(false)
  local battleEquipVersion = DataCenter.LWSkyBattleGrowthChapterManager.battleEquipVersion
  self.equipItemList = DataCenter.LWSkyBattleGrowthChapterManager.battleEquipInfo
  if not self.equipItemList then
    return
  end
  if self.battleEquipVersion and self.battleEquipVersion == battleEquipVersion then
    return
  end
  self.battleEquipVersion = battleEquipVersion
  self.cacheSelectCell = 1
  self.curSelectCell = 1
  local itemCount = #self.equipItemList
  self.scrollRectItemsHolder:SetActive(0 < itemCount)
  if 0 < itemCount then
    if itemCount < self.curSelectCell then
      self.curSelectCell = itemCount
    end
    self.gridInfinityScrollViewItemsContent:SetItemCount(itemCount)
    if moveScroll then
      self.gridInfinityScrollViewItemsContent:MoveItemByIndex(self.curSelectCell - 1, 0)
    end
  end
  self.gridInfinityScrollViewItemsContent:ForceUpdate()
end

function GrowBagContentComponent:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.SkyBattleEquipInstall, self.OnEquipStatusChange)
  self:AddUIListener(EventId.SkyBattleEquipUnInstall, self.OnEquipStatusChange)
  self:AddUIListener(EventId.SkyBattleEquipRecycled, self.OnEquipRecycled)
  self:AddUIListener(EventId.SkyBattleChapterGrowthBattleInfoInit, self.RefreshList)
  self:AddUIListener(EventId.SkyBattleChapterGrowthBattleSlotInfoRefresh, self.RefreshList)
  self:AddUIListener(EventId.SkyBattleChapterGrowthBattleEquipInfoRefresh, self.RefreshList)
end

function GrowBagContentComponent:OnRemoveListener()
  self:RemoveUIListener(EventId.SkyBattleEquipInstall, self.OnEquipStatusChange)
  self:RemoveUIListener(EventId.SkyBattleEquipUnInstall, self.OnEquipStatusChange)
  self:RemoveUIListener(EventId.SkyBattleEquipRecycled, self.OnEquipRecycled)
  self:RemoveUIListener(EventId.SkyBattleChapterGrowthBattleInfoInit, self.RefreshList)
  self:RemoveUIListener(EventId.SkyBattleChapterGrowthBattleSlotInfoRefresh, self.RefreshList)
  self:RemoveUIListener(EventId.SkyBattleChapterGrowthBattleEquipInfoRefresh, self.RefreshList)
  base.OnRemoveListener(self)
end

function GrowBagContentComponent:OnBtnRecycleClick()
  if not self.showedEquipData then
    return
  end
  self.compRecycleItemsPanel:SetActive(true)
end

function GrowBagContentComponent:OnBtnWearClick()
  if not self.showedEquipData then
    return
  end
  if self.showedEquipData.wearing then
    return
  end
  local wearing = self.showedEquipData.wearing
  if wearing then
    return
  end
  SFSNetwork.SendMessage(MsgDefines.UserSkyBattleEquipInstall, {
    [self.showedEquipData.equipLocation] = self.showedEquipData.uuid
  })
end

function GrowBagContentComponent:OnEquipStatusChange()
  if self.showedEquipData then
    self:RefreshInfo()
  end
  for i, equipItem in pairs(self.cellItems) do
    equipItem:Refresh()
  end
end

function GrowBagContentComponent:OnEquipRecycled()
  self.compSelectedItemDetail:SetActive(false)
  self:RefreshList()
end

function GrowBagContentComponent:GetGuidePosition(guide)
  if guide == SkyBattleChapterGrowthGuideType.Recycle then
    return self.btnRecycle.transform.position
  end
end

return GrowBagContentComponent
