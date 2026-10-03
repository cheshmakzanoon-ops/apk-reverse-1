local UITCCardEquipCardPanel = BaseClass("UITCCardEquipCardPanel", UIBaseView)
local base = UIBaseView
local Localization = CS.GameEntry.Localization
local NORMAL_CARD_ITEM_PADDING = Vector2(37, 14)
local CORE_CARD_ITEM_PADDING = Vector2(18, 18)
local CARD_LEFT_DISTANCE = 40
local ITEM_COUNT_PRE_ROW = 4
local scroll_view_path = "PopUpTitle/Content/Scroll View"
local content_path = "PopUpTitle/Content/Scroll View/Viewport/Content"
local panel_path = "panel"
local close_btn_path = "PopUpTitle/CloseBtn"
local cur_slot_point_path = "PopUpTitle/Content/TopArea/CurSlotPoint"
local t_c_core_card_item_path = "ItemRoot/TCCoreCardItem"
local t_c_normal_card_item_path = "ItemRoot/TCNormalCardItem"
local un_equip_btn_path = "PopUpTitle/Content/TopArea/UnEquipBtn"
local get_more_btn_path = "PopUpTitle/Content/GetMoreBtn"
local equip_tip_text_path = "PopUpTitle/Content/TopArea/Layout/EquipTipText"
local un_equip_tip_text_path = "PopUpTitle/Content/TopArea/Layout/UnEquipTipText"
local power_layout_path = "PopUpTitle/Content/TopArea/Layout/PowerLayout"
local card_power_text_path = "PopUpTitle/Content/TopArea/Layout/PowerLayout/CardPowerText"
local empty_tip_text_path = "PopUpTitle/Content/EmptyTipText"

local function OnCreate(self)
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
  self.curSlotData = self:GetUserData()
  self:ReInit()
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
  base.OnDisable(self)
end

local function ComponentDefine(self)
  self._looplistview = self:AddComponent(UILoopGridView, scroll_view_path)
  self._looplistview:InitGridView(0, function(listview, index)
    return self:GetScrollItem(listview, index)
  end)
  self._looplistview_content = self:AddComponent(UIBaseContainer, content_path)
  self.contentWidth, self.h = self._looplistview.rectTransform:Get_sizeDelta()
  self.closePanel = self:AddComponent(UIButton, panel_path)
  self.closePanel:SetOnClick(function()
    self.ctrl:CloseSelf()
  end)
  self.closeBtn = self:AddComponent(UIButton, close_btn_path)
  self.closeBtn:SetOnClick(function()
    self.ctrl:CloseSelf()
  end)
  self.slotHangUpPoint = self:AddComponent(UIBaseContainer, cur_slot_point_path)
  local coreItem = self:AddComponent(UIBaseContainer, t_c_core_card_item_path)
  local normalItem = self:AddComponent(UIBaseContainer, t_c_normal_card_item_path)
  self.coreItemSizeX, self.coreItemSizeY = coreItem.rectTransform:Get_sizeDelta()
  self.normalItemSizeX, self.normalItemSizeY = normalItem.rectTransform:Get_sizeDelta()
  self.unEquipBtn = self:AddComponent(UIButton, un_equip_btn_path)
  self.unEquipBtn:SetOnClick(function()
    self:UnEquipBtnClick()
  end)
  self.getMoreBtn = self:AddComponent(UIButton, get_more_btn_path)
  self.getMoreBtn:SetOnClick(function()
    self:GetMoreBtnClick()
  end)
  self.equipTipTextObj = self:AddComponent(UIBaseContainer, equip_tip_text_path)
  self.unEquipTipTextObj = self:AddComponent(UIBaseContainer, un_equip_tip_text_path)
  self.cardPowerObj = self:AddComponent(UIBaseContainer, power_layout_path)
  self.cardPowerText = self:AddComponent(UIText, card_power_text_path)
  self.emptyTipTextObj = self:AddComponent(UIBaseContainer, empty_tip_text_path)
end

local function ComponentDestroy(self)
  if self.curSlotItemReq then
    self.curSlotItemReq:Destroy()
    self.curSlotItemReq = nil
  end
  self.curSlotItem = nil
end

local function DataDefine(self)
  self._cellList = {}
end

local function DataDestroy(self)
  self._cellList = nil
end

local function OnAddListener(self)
  base.OnAddListener(self)
  self:AddUIListener(EventId.TCCardEquipSuccess, self.OnEquipOrUnEquipSuccess)
  self:AddUIListener(EventId.TCCardUnEquipSuccess, self.OnEquipOrUnEquipSuccess)
end

local function OnRemoveListener(self)
  self:RemoveUIListener(EventId.TCCardEquipSuccess, self.OnEquipOrUnEquipSuccess)
  self:RemoveUIListener(EventId.TCCardUnEquipSuccess, self.OnEquipOrUnEquipSuccess)
  base.OnRemoveListener(self)
end

function UITCCardEquipCardPanel:ReInit()
  self.slotType = self.curSlotData.slotType
  local isEquipCard = self.curSlotData:IsEquipCard()
  self.curEquipCardData = nil
  if isEquipCard then
    self.curEquipCardData = self.curSlotData:GetCardData()
  end
  self.allBagCardDataList = self.ctrl:GetShowCardDataList(self.slotType, self.curEquipCardData)
  self:RefreshCurSelectCardInfo()
  self:ShowCardList()
  self.unEquipBtn:SetActive(isEquipCard)
  self.equipTipTextObj:SetActive(isEquipCard)
  self.unEquipTipTextObj:SetActive(not isEquipCard)
  self.cardPowerObj:SetActive(isEquipCard)
  if isEquipCard then
    self:ShowCurEquipCardPower()
  end
end

function UITCCardEquipCardPanel:ShowCurEquipCardPower()
  local cardPower = 0
  local equipCard = self.curSlotData:GetCardData()
  if equipCard then
    cardPower = equipCard:GetPower()
  end
  self.cardPowerText:SetText(string.GetFormattedSeperatorNum(cardPower))
end

function UITCCardEquipCardPanel:ShowCardList()
  local targetSize, itemPadding
  if self.slotType == TacticalCardSlotType.Core then
    targetSize = Vector2(self.coreItemSizeX, self.coreItemSizeY)
    itemPadding = CORE_CARD_ITEM_PADDING
  else
    targetSize = Vector2(self.normalItemSizeX, self.normalItemSizeY)
    itemPadding = NORMAL_CARD_ITEM_PADDING
  end
  local cardInterval = (self.contentWidth - targetSize.x * ITEM_COUNT_PRE_ROW - CARD_LEFT_DISTANCE * 2) / (ITEM_COUNT_PRE_ROW - 1)
  self._looplistview.unity_loopgridview:SetItemPadding(Vector2(cardInterval, itemPadding.y))
  self._looplistview.unity_loopgridview:SetItemSize(targetSize)
  self._looplistview.unity_loopgridview.Padding.left = math.floor(CARD_LEFT_DISTANCE)
  self._looplistview.unity_loopgridview:UpdateStartEndPadding()
  local startIndex = 0
  self._looplistview:MovePanelToItemByIndex(startIndex, 0)
  self._looplistview:SetListItemCount(#self.allBagCardDataList, false, false)
  self._looplistview_content.rectTransform.localPosition = ResetPosition
  self._looplistview:RefreshAllShownItem()
  self.emptyTipTextObj:SetActive(0 >= #self.allBagCardDataList)
end

function UITCCardEquipCardPanel:GetScrollItem(listview, index)
  index = index + 1
  if index < 1 or index > #self.allBagCardDataList then
    return nil
  end
  local cardData = self.allBagCardDataList[index] or {}
  local prefabName, scriptName = self.ctrl:GetPrefabAndScriptName(cardData)
  local item = listview:NewListViewItem(prefabName)
  if self._cellList[item] == nil then
    NameCount = NameCount + 1
    local nameStr = tostring(NameCount)
    item.gameObject.name = nameStr
    local mailItem = self._looplistview_content:AddComponent(require(scriptName), nameStr)
    self._cellList[item] = mailItem
    self._cellList[item]:SetClickFunc(function(cId, cUuid, cLevel, cStar, cData)
      self:OnItemBeClick(cData)
    end)
  end
  local displayConfig = {}
  
  function displayConfig.showEquipCustomFunc(cData)
    return self:CheckIsNeedShowEquipFlag(cData)
  end
  
  displayConfig.showBg = true
  local itemIndex = index
  local isCanClick = true
  self._cellList[item]:SetData(cardData, displayConfig)
  local isBeSelect = itemIndex == self.curSelectIndex
  self._cellList[item]:SetSelectObjState(isBeSelect)
  return item
end

function UITCCardEquipCardPanel:CheckIsNeedShowEquipFlag(cardData)
  if not cardData then
    return false
  end
  local isExistSameCardId = TacticalCardUtil.IsEquippedSameCardId(cardData:GetCardId(), self.curSlotData.slotId)
  if isExistSameCardId then
    return true, "battle_card_same_using_now"
  end
  if self.curEquipCardData then
    local isSameCard = TacticalCardUtil.CheckIsSameCard(cardData, self.curEquipCardData)
    if isSameCard then
      return false
    end
  end
  local isExistSameCardInOtherSlot = TacticalCardUtil.IsEquippedSameCardIdOrGroup(cardData:GetCardId(), cardData.cardTypeGroup, self.curSlotData.slotId)
  if isExistSameCardInOtherSlot and not cardData:IsCoreCard() then
    return true, "battle_card_same_using_now"
  end
  return cardData:IsEquip(), "battle_card_using_now"
end

function UITCCardEquipCardPanel:OnItemBeClick(equipCardData)
  local function equipCardFunc()
    return self:ExecuteEquipCard(equipCardData)
  end
  
  local allCardList = {}
  if self.curSlotData and self.curSlotData:GetCardData() then
    table.insert(allCardList, self.curSlotData:GetCardData())
  end
  table.insert(allCardList, equipCardData)
  local params = {}
  params.cardDataList = allCardList
  params.equipCardFunc = equipCardFunc
  UIManager:GetInstance():OpenWindow(UIWindowNames.TCCardEquipConfirm, {anim = true}, params)
end

function UITCCardEquipCardPanel:ExecuteEquipCard(equipCardData)
  if not self.curSlotData then
    return false
  end
  local equipCardId = equipCardData:GetCardId()
  local excludeSlotId = self.curSlotData.slotId
  if TacticalCardUtil.IsEquippedSameCardId(equipCardId, excludeSlotId) then
    UIUtil.ShowTips(Localization:GetString("battle_card_same"))
    return false
  end
  local isExistCardTypeGroup, cardTypeGroup = equipCardData:GetCardTypeGroup()
  if isExistCardTypeGroup and TacticalCardUtil.IsEquippedSameCardTypeGroup(cardTypeGroup, excludeSlotId) then
    UIUtil.ShowTips(Localization:GetString("battle_card_same"))
    return false
  end
  local isshowTips = true
  local isCanEquip = self.curSlotData:IsCanEquipCard(isshowTips)
  if not isCanEquip then
    return false
  end
  local params = {}
  local data = {}
  table.insert(params, data)
  data.uuid = equipCardData.uuid
  data.slotId = self.curSlotData.slotId
  self.ctrl:SendEquipCardMessage(params)
  return true
end

function UITCCardEquipCardPanel:RefreshCurSelectCardInfo()
  self.curSlotItemReq = TacticalCardUtil.CreateOneSlotItem(self, self.slotType, self.slotHangUpPoint, function(slotItem)
    self.curSlotItem = slotItem
    self.curSlotItem:SetData(self.curSlotData)
    local cardScale = self.curSlotItem.slotType == TacticalCardSlotType.Core and 1 or 1.26
    self.curSlotItem:SetCardScale(cardScale)
  end)
end

function UITCCardEquipCardPanel:UnEquipBtnClick()
  if not self.curSlotData:IsEquipCard() then
    return
  end
  local isShowTips = true
  if not self.curSlotData:IsCanUnEquipCard(isShowTips) then
    return
  end
  local params = {}
  table.insert(params, self.curSlotData.slotId)
  self.ctrl:SendPutOffCardMessage(params)
end

function UITCCardEquipCardPanel:GetMoreBtnClick()
  UIManager:GetInstance():OpenWindow(UIWindowNames.UITCCardBoxPanel)
end

function UITCCardEquipCardPanel:OnEquipOrUnEquipSuccess()
  self.ctrl:CloseSelf()
end

UITCCardEquipCardPanel.OnCreate = OnCreate
UITCCardEquipCardPanel.OnDestroy = OnDestroy
UITCCardEquipCardPanel.OnEnable = OnEnable
UITCCardEquipCardPanel.OnDisable = OnDisable
UITCCardEquipCardPanel.ComponentDefine = ComponentDefine
UITCCardEquipCardPanel.ComponentDestroy = ComponentDestroy
UITCCardEquipCardPanel.DataDefine = DataDefine
UITCCardEquipCardPanel.DataDestroy = DataDestroy
UITCCardEquipCardPanel.OnAddListener = OnAddListener
UITCCardEquipCardPanel.OnRemoveListener = OnRemoveListener
return UITCCardEquipCardPanel
