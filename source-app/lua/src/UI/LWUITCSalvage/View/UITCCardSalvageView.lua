local UITCCardSalvageView = BaseClass("UITCCardSalvageView", UIBaseView)
local TCCommonDropDownComponent = require("UI.LWUITC.Component.TCCommonDropDownComponent")
local base = UIBaseView
local Localization = CS.GameEntry.Localization
local SALVAGE_QUALITY_FILTER_INDEX_SAVE_KEY = "TC_CARD_SALVAGE_QUALITY_FILTER_INDEX_SAVE"
local NORMAL_CARD_ITEM_PADDING = Vector2(40, 14)
local CORE_CARD_ITEM_PADDING = Vector2(24, 18)
local ITEM_COUNT_PRE_ROW = 4
local panel_path = "panel"
local close_btn_path = "PopUpTitle/CloseBtn"
local t_c_common_drop_down_path = "PopUpTitle/Content/TopArea/TCCommonDropDown"
local scroll_view_path = "PopUpTitle/Content/Scroll View"
local content_path = "PopUpTitle/Content/Scroll View/Viewport/Content"
local salvage_btn_path = "PopUpTitle/Content/btns/SalvageBtn"
local t_c_normal_card_item_path = "ItemRoot/TCNormalCardItem"
local t_c_core_card_item_path = "ItemRoot/TCCoreCardItem"
local salvage_preview_layout_path = "PopUpTitle/Content/SalvagePreviewLayout"
local u_i_common_res_item_path = "ItemRoot/UICommonResItem"
local empty_tip_text_path = "PopUpTitle/Content/EmptyTipText"
local quick_select_btn_path = "PopUpTitle/Content/btns/QuickSelectBtn"
local salvage_preview_icon_path = "PopUpTitle/Content/SalvagePreviewLayout/Icon"
local salvage_preview_rewardCntTxt_path = "PopUpTitle/Content/SalvagePreviewLayout/RewardCntTxt"
local QUALITY_FILTER_KEY = {
  [TacticalCardQualityFilter.GreenAndBelow] = "battle_card_filter_green",
  [TacticalCardQualityFilter.BlueAndBelow] = "battle_card_filter_blue",
  [TacticalCardQualityFilter.PurpleAndBelow] = "battle_card_filter_purple",
  [TacticalCardQualityFilter.OrangeAndBelow] = "battle_card_filter_orange"
}
local ALL_QUALITY_FILTER_LIST = {
  TacticalCardQualityFilter.GreenAndBelow,
  TacticalCardQualityFilter.BlueAndBelow,
  TacticalCardQualityFilter.PurpleAndBelow
}

local function OnCreate(self)
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
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
  if self.qualityFilterIndex then
    CommonUtil.PlayerPrefsSetInt(SALVAGE_QUALITY_FILTER_INDEX_SAVE_KEY, self.qualityFilterIndex)
  end
end

local function ComponentDefine(self)
  self.panelCloseBtn = self:AddComponent(UIButton, panel_path)
  self.panelCloseBtn:SetOnClick(function()
    self.ctrl:CloseSelf()
  end)
  self.closeBtn = self:AddComponent(UIButton, close_btn_path)
  self.closeBtn:SetOnClick(function()
    self.ctrl:CloseSelf()
  end)
  self.dropDownItem = self:AddComponent(TCCommonDropDownComponent, t_c_common_drop_down_path)
  for _, v in ipairs(ALL_QUALITY_FILTER_LIST) do
    self.dropDownItem:Add(CS.GameEntry.Localization:GetString(QUALITY_FILTER_KEY[v]))
  end
  self.dropDownItem:BindIndexChangeEvent(function(index)
    self:OnQualityFilterChange(index)
  end)
  self._looplistview = self:AddComponent(UILoopGridView, scroll_view_path)
  self._looplistview:InitGridView(0, function(listview, index)
    return self:GetScrollItem(listview, index)
  end)
  self._looplistview_content = self:AddComponent(UIBaseContainer, content_path)
  self.contentWidth, self.h = self._looplistview.rectTransform:Get_sizeDelta()
  self.salvageBtn = self:AddComponent(UIButton, salvage_btn_path)
  self.salvageBtn:SetOnClick(function()
    self:ClickSalvageBtn()
  end)
  local coreItem = self:AddComponent(UIBaseContainer, t_c_core_card_item_path)
  local normalItem = self:AddComponent(UIBaseContainer, t_c_normal_card_item_path)
  self.coreItemSizeX, self.coreItemSizeY = coreItem.rectTransform:Get_sizeDelta()
  self.normalItemSizeX, self.normalItemSizeY = normalItem.rectTransform:Get_sizeDelta()
  self.salvageMatRoot = self:AddComponent(UIBaseContainer, salvage_preview_layout_path)
  self.commonItemObj = self:AddComponent(UIBaseContainer, u_i_common_res_item_path).gameObject
  self.commonItemObj:GameObjectCreatePool()
  self.emptyTipTextObj = self:AddComponent(UIBaseContainer, empty_tip_text_path)
  self.quickSelectBtn = self:AddComponent(UIButton, quick_select_btn_path)
  self.quickSelectBtn:SetOnClick(function()
    self:OnQuickSelectBtnClick()
  end)
  self.salvagePreviewIcon = self:AddComponent(UIBaseContainer, salvage_preview_icon_path)
  self.salvagePreviewRewardCntTxt = self:AddComponent(UITextMeshProUGUIEx, salvage_preview_rewardCntTxt_path)
end

local function ComponentDestroy(self)
  self.commonItemObj:GameObjectRecycleAll()
  self.salvagePreviewIcon:RemoveComponents(UICommonResItem)
end

local function DataDefine(self)
  self._cellList = {}
  self.curSelectCardUuidDic = {}
end

local function DataDestroy(self)
  self._cellList = nil
  self.curSelectCardUuidDic = nil
end

local function OnAddListener(self)
  base.OnAddListener(self)
  self:AddUIListener(EventId.TCCardSalvageSuccess, self.UpdateWhenSalvageSuccess)
end

local function OnRemoveListener(self)
  self:RemoveUIListener(EventId.TCCardSalvageSuccess, self.UpdateWhenSalvageSuccess)
  base.OnRemoveListener(self)
end

function UITCCardSalvageView:ReInit()
  self.qualityFilterIndex = CommonUtil.PlayerPrefsGetInt(SALVAGE_QUALITY_FILTER_INDEX_SAVE_KEY, 1)
  self:SetQualityFilterIndex(self.qualityFilterIndex)
  self.dropDownItem:SetSelectIndex(self.qualityFilterIndex)
  self:ClearAllSelectCard()
  self:RefreshCurSelectQualityCard()
  self:RefreshSalvagePreviewMat()
end

local CARD_DISPLAY_CONFIG = {showBg = true}

function UITCCardSalvageView:GetScrollItem(listview, index)
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
    local cardItem = self._looplistview_content:AddComponent(require(cls), nameStr)
    self._cellList[item] = cardItem
    self._cellList[item]:SetClickFunc(function(cId, cUuid, cLevel, cStar, cData)
      self:OnItemBeClick(cardItem, cData)
    end)
    self._cellList[item]:SetLongPressFunc(function(cId, cUuid, cLevel, cStar, cData)
      self:OnItemBeLongPress(cardItem, cData)
    end)
  end
  local isBeSelect = self.curSelectCardUuidDic[cardData.uuid]
  self._cellList[item]:SetData(cardData, CARD_DISPLAY_CONFIG)
  self._cellList[item]:SetSelectObjState(isBeSelect)
  return item
end

function UITCCardSalvageView:OnQualityFilterChange(index)
  self:ClearAllSelectCard()
  self:SetQualityFilterIndex(index)
  self:RefreshCurSelectQualityCard()
  self:RefreshSalvagePreviewMat()
end

function UITCCardSalvageView:SetQualityFilterIndex(index)
  self.qualityFilter = ALL_QUALITY_FILTER_LIST[index]
  self.qualityFilterIndex = index
end

function UITCCardSalvageView:ClearAllSelectCard()
  self.curSelectCardUuidDic = {}
end

function UITCCardSalvageView:RefreshCurSelectQualityCard()
  local targetSize, itemPadding
  targetSize = Vector2(self.normalItemSizeX, self.normalItemSizeY)
  itemPadding = NORMAL_CARD_ITEM_PADDING
  local paddingLeft = (self.contentWidth - targetSize.x * ITEM_COUNT_PRE_ROW - itemPadding.x * (ITEM_COUNT_PRE_ROW - 1)) / 2
  self._looplistview.unity_loopgridview:SetItemPadding(itemPadding)
  self._looplistview.unity_loopgridview:SetItemSize(targetSize)
  self._looplistview.unity_loopgridview.Padding.left = math.floor(paddingLeft)
  self._looplistview.unity_loopgridview:UpdateStartEndPadding()
  self.curShowCardDataList = self.ctrl:GetAllCanSalvageCardDataList(self.qualityFilter)
  local startIndex = 0
  self._looplistview:MovePanelToItemByIndex(startIndex, 0, 0)
  self._looplistview:SetListItemCount(#self.curShowCardDataList, false, false)
  self._looplistview_content.rectTransform.localPosition = ResetPosition
  self._looplistview:RefreshAllShownItem()
  self.emptyTipTextObj:SetActive(#self.curShowCardDataList <= 0)
end

function UITCCardSalvageView:OnItemBeClick(cardItem, clickCardData)
  local isCurSelectState = self.curSelectCardUuidDic[clickCardData.uuid]
  if isCurSelectState then
    self.curSelectCardUuidDic[clickCardData.uuid] = nil
  else
    self.curSelectCardUuidDic[clickCardData.uuid] = true
  end
  cardItem:SetSelectObjState(self.curSelectCardUuidDic[clickCardData.uuid])
  self:RefreshSalvagePreviewMat()
end

function UITCCardSalvageView:OnItemBeLongPress(cardItem, longPressCardData)
  if not longPressCardData then
    return
  end
  TacticalCardUtil:OpenViewCard(longPressCardData.cardId, longPressCardData.level, longPressCardData.star, longPressCardData.randomAttr)
end

function UITCCardSalvageView:ClickSalvageBtn()
  if not self.curSelectCardUuidDic or table.count(self.curSelectCardUuidDic) <= 0 then
    UIUtil.ShowTipsId("battle_card_break_none")
    return
  end
  local params = {}
  for uuid, v in pairs(self.curSelectCardUuidDic) do
    table.insert(params, uuid)
  end
  self.ctrl:SendSalvageMessage(params)
end

function UITCCardSalvageView:RefreshSalvagePreviewMat()
  self.commonItemObj:GameObjectRecycleAll()
  self.salvagePreviewIcon:RemoveComponents(UICommonResItem)
  if not self.curSelectCardUuidDic or table.count(self.curSelectCardUuidDic) <= 0 then
    self.salvageMatRoot:SetActive(false)
    return
  end
  self.salvageMatRoot:SetActive(true)
  local itemDic = self.ctrl:GetSalvageMatInfo(self.curSelectCardUuidDic)
  if not itemDic then
    return
  end
  local cnt = 0
  for itemId, count in pairs(itemDic) do
    local reward = {}
    reward.rewardType = RewardType.RESOURCE_ITEM
    reward.itemId = itemId
    local itemObj = self.commonItemObj:GameObjectSpawn(self.salvagePreviewIcon.transform)
    local name = tostring(NameCount)
    NameCount = NameCount + 1
    itemObj.name = name
    local itemCpt = self.salvagePreviewIcon:AddComponent(UICommonResItem, name)
    itemCpt:ReInit(reward)
    itemCpt:SetImgQuailtyShow(false)
    cnt = count
  end
  self.salvagePreviewRewardCntTxt:SetText(cnt)
end

function UITCCardSalvageView:UpdateWhenSalvageSuccess()
  self:ClearAllSelectCard()
  self:RefreshCurSelectQualityCard()
  self:RefreshSalvagePreviewMat()
end

function UITCCardSalvageView:OnQuickSelectBtnClick()
  local canQuickSelectCardDataList = self.ctrl:GetCanQuickSelectCardDataList(self.curShowCardDataList, self.curSelectCardUuidDic)
  if table.IsEmpty(canQuickSelectCardDataList) then
    UIUtil.ShowTipsId("battle_card_select_none")
    return
  end
  for _, v in ipairs(canQuickSelectCardDataList) do
    self.curSelectCardUuidDic[v.uuid] = true
  end
  self._looplistview:RefreshAllShownItem()
  self:RefreshSalvagePreviewMat()
end

UITCCardSalvageView.OnCreate = OnCreate
UITCCardSalvageView.OnDestroy = OnDestroy
UITCCardSalvageView.OnEnable = OnEnable
UITCCardSalvageView.OnDisable = OnDisable
UITCCardSalvageView.ComponentDefine = ComponentDefine
UITCCardSalvageView.ComponentDestroy = ComponentDestroy
UITCCardSalvageView.DataDefine = DataDefine
UITCCardSalvageView.DataDestroy = DataDestroy
UITCCardSalvageView.OnAddListener = OnAddListener
UITCCardSalvageView.OnRemoveListener = OnRemoveListener
return UITCCardSalvageView
