local base = UIBaseContainer
local RecycleItemsPanelComponent = BaseClass("RecycleItemsPanelComponent", UIBaseContainer)
local Localization = CS.GameEntry.Localization
local UIEquipItemComponent = require("UI.UILWStageSkyBattleChapter.Components.UIEquipItemComponent")

function RecycleItemsPanelComponent:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
  self:Init()
end

function RecycleItemsPanelComponent:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function RecycleItemsPanelComponent:ComponentDefine()
  self.viewSkin = self:AddComponent(UIViewSkinBridge, "")
  self.btnClose = self.viewSkin:AddComponent(self, UIButton, 1)
  self.btnClose:SetOnClick(function()
    self:OnBtnCloseClick()
  end)
  self.imgRecycleResourceIcon = self.viewSkin:AddComponent(self, UIImage, 2)
  self.textRecycleNum = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 3)
  self.textRecycleTip = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 4)
  self.gridInfinityScrollViewItemsContent = self.viewSkin:AddComponent(self, GridInfinityScrollView, 5)
  self.btnRecycleImidiately = self.viewSkin:AddComponent(self, UIButton, 6)
  self.btnRecycleImidiately:SetOnClick(function()
    self:OnBtnRecycleImidiatelyClick()
  end)
  self.textBtnRecycleImidiatelyTxt = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 7)
  self.btnAutoSelect = self.viewSkin:AddComponent(self, UIButton, 8)
  self.btnAutoSelect:SetOnClick(function()
    self:OnBtnAutoSelectClick()
  end)
  self.textBtnAotoSelectTxt = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 9)
  self.textEmptyEquipContent = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 10)
  self.btnQuickSelectBar = self.viewSkin:AddComponent(self, UIButton, 11)
  self.btnQuickSelectBar:SetOnClick(function()
    self:OnBtnQuickSelectBarClick()
  end)
  self.textBtn = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 12)
  self.compQuickSelectMenu = self.viewSkin:AddComponent(self, UIBaseComponent, 13)
  self.btnGreenQuality = self.viewSkin:AddComponent(self, UIButton, 14)
  self.btnGreenQuality:SetOnClick(function()
    self:OnBtnGreenQualityClick()
  end)
  self.textGreenQualityBtn = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 15)
  self.imgGreenQualityBtnSelectedIcon = self.viewSkin:AddComponent(self, UIImage, 16)
  self.btnBlueQuality = self.viewSkin:AddComponent(self, UIButton, 17)
  self.btnBlueQuality:SetOnClick(function()
    self:OnBtnBlueQualityClick()
  end)
  self.textBlueQualityBtn = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 18)
  self.imgBlueQualityBtnSelectedIcon = self.viewSkin:AddComponent(self, UIImage, 19)
  self.btnPurpleQuality = self.viewSkin:AddComponent(self, UIButton, 20)
  self.btnPurpleQuality:SetOnClick(function()
    self:OnBtnPurpleQualityClick()
  end)
  self.textPurpleQualityBtn = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 21)
  self.imgPurpleQualitySelectedIcon = self.viewSkin:AddComponent(self, UIImage, 22)
  self.scrollRectRecycleItemsHolder = self.viewSkin:AddComponent(self, UIScrollRect, 23)
  self.textEmptyEquipContent:SetLocalText("No-Key-NoEquip")
  self.textGreenQualityBtn:SetLocalText(430722)
  self.textBlueQualityBtn:SetLocalText(430723)
  self.textPurpleQualityBtn:SetLocalText(430724)
  self.textRecycleTip:SetLocalText("No-Key-SelectNone")
  self.textBtnRecycleImidiatelyTxt:SetLocalText("No-Key-Recycle")
  self.imgRecycleResourceIcon:SetActive(false)
  self.textRecycleNum:SetActive(false)
  self.compQuickSelectMenu:SetActive(false)
  self.btnRecycleImidiately:SetActive(false)
  self.textBtn:SetLocalText(430721)
end

function RecycleItemsPanelComponent:ComponentDestroy()
  self:ClearItemCell()
  self.viewSkin = nil
  self.btnClose = nil
  self.imgRecycleResourceIcon = nil
  self.textRecycleNum = nil
  self.textRecycleTip = nil
  self.gridInfinityScrollViewItemsContent = nil
  self.btnRecycleImidiately = nil
  self.textBtnRecycleImidiatelyTxt = nil
  self.btnAutoSelect = nil
  self.textBtnAotoSelectTxt = nil
  self.textEmptyEquipContent = nil
  self.btnQuickSelectBar = nil
  self.textBtn = nil
  self.compQuickSelectMenu = nil
  self.btnGreenQuality = nil
  self.textGreenQualityBtn = nil
  self.imgGreenQualityBtnSelectedIcon = nil
  self.btnBlueQuality = nil
  self.textBlueQualityBtn = nil
  self.imgBlueQualityBtnSelectedIcon = nil
  self.btnPurpleQuality = nil
  self.textPurpleQualityBtn = nil
  self.imgPurpleQualitySelectedIcon = nil
  self.scrollRectRecycleItemsHolder = nil
end

function RecycleItemsPanelComponent:DataDefine()
  self.curDefaultSelectAllQuality = 3
  self.selectedEquips = {}
  self.equipItemList = {}
  self.listGO = {}
  self.haveHighQualityEquip = false
end

function RecycleItemsPanelComponent:DataDestroy()
  self.curDefaultSelectAllQuality = 3
  self.selectedEquips = nil
  self.equipItemList = nil
  self.listGO = nil
  self.cellItems = nil
  self.haveHighQualityEquip = false
end

function RecycleItemsPanelComponent:Init()
  self:ClearItemCell()
  local bindFunc1 = BindCallback(self, self.OnInitScroll)
  local bindFunc2 = BindCallback(self, self.OnUpdateScroll)
  local bindFunc3 = BindCallback(self, self.OnDestroyScrollItem)
  self.gridInfinityScrollViewItemsContent:Init(bindFunc1, bindFunc2, bindFunc3)
end

function RecycleItemsPanelComponent:OnEnable()
  base.OnEnable(self)
  self:RefreshList()
end

function RecycleItemsPanelComponent:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.SkyBattleEquipRecycled, self.RefreshList)
  self:AddUIListener(EventId.SkyBattleChapterGrowthBattleInfoInit, self.RefreshList)
  self:AddUIListener(EventId.SkyBattleChapterGrowthBattleSlotInfoRefresh, self.RefreshList)
  self:AddUIListener(EventId.SkyBattleChapterGrowthBattleEquipInfoRefresh, self.RefreshList)
end

function RecycleItemsPanelComponent:OnRemoveListener()
  self:RemoveUIListener(EventId.SkyBattleEquipRecycled, self.RefreshList)
  self:RemoveUIListener(EventId.SkyBattleChapterGrowthBattleInfoInit, self.RefreshList)
  self:RemoveUIListener(EventId.SkyBattleChapterGrowthBattleSlotInfoRefresh, self.RefreshList)
  self:RemoveUIListener(EventId.SkyBattleChapterGrowthBattleEquipInfoRefresh, self.RefreshList)
  base.OnRemoveListener(self)
end

function RecycleItemsPanelComponent:OnBtnCloseClick()
  self:SetActive(false)
end

function RecycleItemsPanelComponent:OnBtnRecycleImidiatelyClick()
  if self.haveHighQualityEquip then
    UIUtil.ShowMessage("NoKey-Warning", 1, "ok", "cancel", function()
      SFSNetwork.SendMessage(MsgDefines.UserSkyBattleEquipDecompose, self.selectedEquips)
    end)
  else
    SFSNetwork.SendMessage(MsgDefines.UserSkyBattleEquipDecompose, self.selectedEquips)
  end
end

function RecycleItemsPanelComponent:OnBtnAutoSelectClick()
end

function RecycleItemsPanelComponent:OnBtnQuickSelectBarClick()
  local isActive = self.compQuickSelectMenu:GetActive()
  self.compQuickSelectMenu:SetActive(not isActive)
end

function RecycleItemsPanelComponent:OnBtnGreenQualityClick()
  self:SelectAllWithQuality(3)
end

function RecycleItemsPanelComponent:OnBtnBlueQualityClick()
  self:SelectAllWithQuality(4)
end

function RecycleItemsPanelComponent:OnBtnPurpleQualityClick()
  self:SelectAllWithQuality(5)
end

function RecycleItemsPanelComponent:ClearItemCell()
  self.cellItems = {}
  self.scrollRectRecycleItemsHolder:RemoveComponents(UIEquipItemComponent)
  self.gridInfinityScrollViewItemsContent:DestroyChildNode()
end

function RecycleItemsPanelComponent:OnInitScroll(go, index)
  local item = self.scrollRectRecycleItemsHolder:AddComponent(UIEquipItemComponent, go)
  self.listGO[go] = item
end

function RecycleItemsPanelComponent:OnUpdateScroll(go, index)
  local cellItem = self.listGO[go]
  go.name = "equip_item_" .. index
  local realIndex = index + 1
  local equipData = self.equipItemList[realIndex]
  if equipData then
    cellItem:SetData(equipData, realIndex, true, function(trans, index)
      self:CellsCallBack(trans, index)
    end)
    cellItem:SetActive(true)
    local isSelected = table.indexof(self.selectedEquips, equipData.uuid) and true or false
    cellItem:ShowSelectMask(isSelected)
  else
    cellItem:SetActive(false)
  end
  self.cellItems[realIndex] = cellItem
end

function RecycleItemsPanelComponent:OnDestroyScrollItem(go, index)
  local realIndex = index + 1
  self.cellItems[realIndex] = nil
end

function RecycleItemsPanelComponent:CellsCallBack(trans, index)
  local equipCell = self.cellItems[index]
  if equipCell then
    local uuid = equipCell.equipData.uuid
    local inSelectIndex = table.indexof(self.selectedEquips, uuid)
    if inSelectIndex then
      table.remove(self.selectedEquips, inSelectIndex)
      equipCell:ShowSelectMask(false)
    else
      table.insert(self.selectedEquips, uuid)
      equipCell:ShowSelectMask(true)
    end
    self:CheckShowRecycleSumInfo()
  end
end

function RecycleItemsPanelComponent:RefreshList(moveScroll)
  local equipsAll = DataCenter.LWSkyBattleGrowthChapterManager.battleEquipInfo
  if not equipsAll then
    return
  end
  self.equipItemList = {}
  for i, equipInfo in ipairs(equipsAll) do
    if equipInfo and not equipInfo.wearing then
      table.insert(self.equipItemList, equipInfo)
    end
  end
  self.selectedEquips = {}
  local itemCount = #self.equipItemList
  self.scrollRectRecycleItemsHolder:SetActive(0 < itemCount)
  self.textEmptyEquipContent:SetActive(itemCount == 0)
  if 0 < itemCount then
    self.gridInfinityScrollViewItemsContent:SetItemCount(itemCount)
    if moveScroll then
      self.gridInfinityScrollViewItemsContent:MoveItemByIndex(0, 0)
    end
  end
  self.gridInfinityScrollViewItemsContent:ForceUpdate()
  self:SelectAllWithQuality(self.curDefaultSelectAllQuality)
end

function RecycleItemsPanelComponent:SelectAllWithQuality(quality)
  self.curDefaultSelectAllQuality = quality
  for i, cell in pairs(self.cellItems) do
    cell:ShowSelectMask(false)
  end
  self.selectedEquips = {}
  for i, equipData in ipairs(self.equipItemList) do
    if quality >= equipData.quality then
      table.insert(self.selectedEquips, equipData.uuid)
      if self.cellItems[i] then
        self.cellItems[i]:ShowSelectMask(true)
      end
    end
  end
  self.compQuickSelectMenu:SetActive(false)
  self.imgGreenQualityBtnSelectedIcon:SetActive(false)
  self.imgBlueQualityBtnSelectedIcon:SetActive(false)
  self.imgPurpleQualitySelectedIcon:SetActive(false)
  if quality == 5 then
    self.imgPurpleQualitySelectedIcon:SetActive(true)
  elseif quality == 4 then
    self.imgBlueQualityBtnSelectedIcon:SetActive(true)
  elseif quality == 3 then
    self.imgGreenQualityBtnSelectedIcon:SetActive(true)
  end
  self:CheckShowRecycleSumInfo()
end

local highQualityMin = 5

function RecycleItemsPanelComponent:CheckShowRecycleSumInfo()
  self.haveHighQualityEquip = false
  local hasSelectedEquip = #self.selectedEquips > 0
  self.btnRecycleImidiately:SetActive(hasSelectedEquip)
  self.imgRecycleResourceIcon:SetActive(hasSelectedEquip)
  self.textRecycleNum:SetActive(hasSelectedEquip)
  self.textRecycleTip:SetActive(not hasSelectedEquip)
  self.totalSelectedRecycleNum = 0
  for i, uuid in ipairs(self.selectedEquips) do
    local equipData = DataCenter.LWSkyBattleGrowthChapterManager:GetEquip(uuid)
    if equipData then
      self.totalSelectedRecycleNum = self.totalSelectedRecycleNum + equipData.chip
      if equipData.quality >= highQualityMin then
        self.haveHighQualityEquip = true
      end
    end
  end
  self.textRecycleNum:SetText(string.GetFormattedStr(self.totalSelectedRecycleNum))
end

return RecycleItemsPanelComponent
