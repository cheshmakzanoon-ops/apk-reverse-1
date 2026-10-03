local UITCCardResetPanelView = BaseClass("UITCCardResetPanelView", UIBaseView)
local base = UIBaseView
local Localization = CS.GameEntry.Localization
local CORE_CARD_ITEM_PADDING = Vector2(34, 5)
local ITEM_COUNT_PRE_ROW = 4

function UITCCardResetPanelView:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
  self:ReInit()
end

function UITCCardResetPanelView:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UITCCardResetPanelView:ComponentDefine()
  self.viewSkin = self:AddComponent(UIViewSkinBridge, "")
  self.panel_btn = self.viewSkin:AddComponent(self, UIButton, 1)
  self.panel_btn:SetOnClick(function()
    self:OnPanel_btnClick()
  end)
  self.close_btn = self.viewSkin:AddComponent(self, UIButton, 2)
  self.close_btn:SetOnClick(function()
    self:OnClose_btnClick()
  end)
  self.cardsGrid = self.viewSkin:AddComponent(self, UILoopGridView, 3)
  self.emptyTip_txt = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 4)
  self.resetRewardPreview = self.viewSkin:AddComponent(self, UIBaseContainer, 5)
  self.rewardItemCnt_txt = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 6)
  self.btnReset = self.viewSkin:AddComponent(self, UIButton, 7)
  self.btnReset:SetOnClick(function()
    self:OnBtnResetClick()
  end)
  self.costItem_icon = self.viewSkin:AddComponent(self, UIImage, 8)
  self.costItemCnt_txt = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 9)
  self.cardsGridContent = self.viewSkin:AddComponent(self, UIBaseContainer, 10)
  self.commonItemObj = self.viewSkin:AddComponent(self, UIBaseComponent, 11)
  self.rewardItem_icon = self.viewSkin:AddComponent(self, UIBaseContainer, 12)
  self.coreCardItem = self.viewSkin:AddComponent(self, UIBaseComponent, 13)
  self.cardsGrid:InitGridView(0, function(listview, index)
    return self:GetScrollItem(listview, index)
  end)
  self.contentWidth = self.cardsGrid:GetSizeDeltaXY()
  local itemWidth, itemHeight = self.coreCardItem:GetSizeDeltaXY()
  self.itemWidth = itemWidth or 0
  self.itemHeight = itemHeight or 0
  self.commonItemObj.gameObject:GameObjectCreatePool()
end

function UITCCardResetPanelView:ComponentDestroy()
  self.viewSkin = nil
  self.panel_btn = nil
  self.close_btn = nil
  self.cardsGrid = nil
  self.emptyTip_txt = nil
  self.resetRewardPreview = nil
  self.rewardItemCnt_txt = nil
  self.btnReset = nil
  self.costItem_icon = nil
  self.costItemCnt_txt = nil
  self.cardsGridContent = nil
  self.commonItemObj = nil
  self.rewardItem_icon = nil
  self.coreCardItem = nil
  if self.rewardItem_icon then
    self.rewardItem_icon:RemoveComponents(UICommonResItem)
  end
  if self.commonItemObj then
    self.commonItemObj.gameObject:GameObjectRecycleAll()
  end
end

function UITCCardResetPanelView:DataDefine()
  self._cellList = {}
  self.curSelectCardUuidDic = {}
end

function UITCCardResetPanelView:DataDestroy()
  self._cellList = nil
  self.curSelectCardUuidDic = nil
end

function UITCCardResetPanelView:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.TacticalCardReset, self.UpdateWhenResetSuccess)
  self:AddUIListener(EventId.RefreshItems, self.RefreshResetCost)
end

function UITCCardResetPanelView:OnRemoveListener()
  self:RemoveUIListener(EventId.TacticalCardReset, self.UpdateWhenResetSuccess)
  self:RemoveUIListener(EventId.RefreshItems, self.RefreshResetCost)
  base.OnRemoveListener(self)
end

function UITCCardResetPanelView:ReInit()
  self:ClearAllSelectCard()
  self:RefreshCoreCardList()
  self:RefreshResetPreviewMat()
  self:RefreshResetCost()
end

function UITCCardResetPanelView:GetScrollItem(listview, index)
  index = index + 1
  if index < 1 or index > #self.curShowCardDataList then
    return nil
  end
  local cardData = self.curShowCardDataList[index] or {}
  local prefabName, cls = self.ctrl:GetPrefabAndScriptName(cardData)
  local item = listview:NewListViewItem(prefabName)
  if self._cellList[item] == nil then
    NameCount = NameCount + 1
    local nameStr = tostring(NameCount)
    item.gameObject.name = nameStr
    local cardItem = self.cardsGridContent:AddComponent(require(cls), nameStr)
    self._cellList[item] = cardItem
    self._cellList[item]:SetClickFunc(function(cId, cUuid, cLevel, cStar, cData)
      self:OnItemBeClick(cardItem, cData)
    end)
    self._cellList[item]:SetLongPressFunc(function(cId, cUuid, cLevel, cStar, cData)
      self:OnItemBeLongPress(cardItem, cData)
    end)
  end
  local isBeSelect = self.curSelectCardUuidDic[cardData.uuid]
  self._cellList[item]:SetData(cardData)
  self._cellList[item]:SetSelectObjState(isBeSelect)
  return item
end

function UITCCardResetPanelView:RefreshCoreCardList()
  local paddingLeft = (self.contentWidth - self.itemWidth * ITEM_COUNT_PRE_ROW - CORE_CARD_ITEM_PADDING.x * (ITEM_COUNT_PRE_ROW - 1)) / 2
  self.cardsGrid.unity_loopgridview:SetItemPadding(CORE_CARD_ITEM_PADDING)
  self.cardsGrid.unity_loopgridview:SetItemSize(Vector2(self.itemWidth, self.itemHeight))
  self.cardsGrid.unity_loopgridview.Padding.left = math.floor(paddingLeft)
  self.cardsGrid.unity_loopgridview:UpdateStartEndPadding()
  local ResetPosition = Vector3(0, 0, 0)
  self.curShowCardDataList = self.ctrl:GetAllCanResetCoreCardList()
  local startIndex = 0
  self.cardsGrid:MovePanelToItemByIndex(startIndex, 0, 0)
  self.cardsGrid:SetListItemCount(#self.curShowCardDataList, false, false)
  self.cardsGridContent.rectTransform.localPosition = ResetPosition
  self.cardsGrid:RefreshAllShownItem()
  self.emptyTip_txt:SetActive(0 >= #self.curShowCardDataList)
end

function UITCCardResetPanelView:OnItemBeClick(cardItem, clickCardData)
  if self.curSelectCardUuidDic[clickCardData.uuid] then
    self.curSelectCardUuidDic = {}
    cardItem:SetSelectObjState(false)
  else
    self:ClearAllSelectCard()
    self.curSelectCardUuidDic[clickCardData.uuid] = true
    self.cardsGrid:RefreshAllShownItem()
  end
  self:RefreshResetPreviewMat()
end

function UITCCardResetPanelView:OnItemBeLongPress(cardItem, longPressCardData)
  if not longPressCardData then
    return
  end
  TacticalCardUtil:OpenViewCard(longPressCardData.cardId, longPressCardData.level, longPressCardData.star, longPressCardData.randomAttr)
end

function UITCCardResetPanelView:ClearAllSelectCard()
  self.curSelectCardUuidDic = {}
end

function UITCCardResetPanelView:RefreshResetPreviewMat()
  if not self.curSelectCardUuidDic or table.count(self.curSelectCardUuidDic) <= 0 then
    self.resetRewardPreview:SetActive(false)
    return
  end
  self.resetRewardPreview:SetActive(true)
  self.rewardItem_icon:RemoveComponents(UICommonResItem)
  self.commonItemObj.gameObject:GameObjectRecycleAll()
  local cardUuid = next(self.curSelectCardUuidDic)
  local cardData = DataCenter.TacticalCardDataManager:GetCardData(cardUuid)
  local itemId, count = TacticalCardUtil.GetCardConsumeExp(cardData)
  if not itemId or itemId < 0 then
    return
  end
  local cnt = 0
  local reward = {}
  reward.rewardType = RewardType.RESOURCE_ITEM
  reward.itemId = itemId
  local itemObj = self.commonItemObj.gameObject:GameObjectSpawn(self.rewardItem_icon.transform)
  local name = tostring(NameCount)
  NameCount = NameCount + 1
  itemObj.name = name
  local itemCpt = self.rewardItem_icon:AddComponent(UICommonResItem, name)
  itemCpt:ReInit(reward)
  itemCpt:SetImgQuailtyShow(false)
  cnt = count
  self.rewardItemCnt_txt:SetText(cnt)
end

function UITCCardResetPanelView:RefreshResetCost()
  local costInfo = self.ctrl:GetResetCostInfo()
  if costInfo then
    local iconPath = DataCenter.ItemTemplateManager:GetIconPath(costInfo.itemId)
    self.costItem_icon:LoadSprite(iconPath)
    local ownCount = DataCenter.ItemData:GetItemCount(costInfo.itemId)
    local colorStr = ownCount >= costInfo.count and "<color=#FFFFFF>" or "<color=#f97077>"
    self.costItemCnt_txt:SetText(string.format("%s%d</color>", colorStr, costInfo.count))
  end
end

function UITCCardResetPanelView:UpdateWhenResetSuccess()
  self:ClearAllSelectCard()
  self:RefreshCoreCardList()
  self:RefreshResetPreviewMat()
  self:RefreshResetCost()
end

function UITCCardResetPanelView:OnPanel_btnClick()
  self.ctrl:CloseSelf()
end

function UITCCardResetPanelView:OnClose_btnClick()
  self.ctrl:CloseSelf()
end

function UITCCardResetPanelView:OnBtnResetClick()
  if not self.curSelectCardUuidDic or table.count(self.curSelectCardUuidDic) <= 0 then
    UIUtil.ShowTipsId("battle_card_reset_none_tips")
    return
  end
  local curUuid
  for uuid, v in pairs(self.curSelectCardUuidDic) do
    curUuid = uuid
    break
  end
  self.ctrl:SendResetMessage(curUuid)
end

return UITCCardResetPanelView
