local base = UIBaseContainer
local RowItemComponent = BaseClass("RowItemComponent", UIBaseContainer)
local QuickEquipSlotComponent = require("UI.LWUITC.UITCQuickEquipPanelV2.Component.QuickEquipSlotComponent")
local Localization = CS.GameEntry.Localization
local ROW_SELECTED_SPRITE = "Assets/Main/Sprites/UI/LWCommon/Sprite/FX_common_diban_lv.png"
local ROW_UNSELECTED_SPRITE = "Assets/Main/Sprites/UI/LWCommon/Sprite/FX_common_diban_bai.png"
local ROW_BG_COLOR = Color.New(1, 1, 1, 1)
local ROW_LINE_SELECTED_COLOR = UIUtil.HexToColor("BBD78B")
local ROW_LINE_UNSELECTED_COLOR = UIUtil.HexToColor("DBCFCC")
local QUICK_EQUIP_SLOT_IDS = {
  1,
  2,
  4,
  5,
  6,
  7,
  10,
  11,
  12,
  13
}
local select_b_g_path = "SelectBG"

local function SyncMissingMaskLayout(slotView)
  if not (slotView and slotView.missing_mask) or not slotView.icon then
    return
  end
  slotView.missing_mask:SetAnchorMin(slotView.icon:GetAnchorMin())
  slotView.missing_mask:SetAnchorMax(slotView.icon:GetAnchorMax())
  slotView.missing_mask:SetPivotMiddle()
  slotView.missing_mask:SetAnchoredPosition(slotView.icon:GetAnchoredPosition())
  slotView.missing_mask:SetSizeDelta(slotView.icon:GetSizeDelta())
  slotView.missing_mask:SetLocalScale(slotView.icon:GetLocalScale())
end

function RowItemComponent:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function RowItemComponent:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function RowItemComponent:ComponentDefine()
  self._bg = self:AddComponent(UIImage, "bg")
  self._line = self:AddComponent(UIImage, "line")
  self._name_text = self:AddComponent(UITextMeshProUGUIEx, "NameText")
  self._empty_text = self:AddComponent(UITextMeshProUGUIEx, "EmptyText")
  self._install_mark = self:AddComponent(UIImage, "SelectBG/InstallMark")
  self._cards_root = self:AddComponent(UIBaseContainer, "CardsRoot")
  self._delete_btn = self:AddComponent(UIButton, "DeleteBtn")
  self._edit_btn = self:AddComponent(UIButton, "EditBtn")
  self._share_btn = self:AddComponent(UIButton, "ShareBtn")
  self._selectBtn = self:AddComponent(UIButton, "SelectCheckArea")
  self.selectBG = self:AddComponent(UIBaseComponent, select_b_g_path)
  self._delete_btn:SetOnClick(function()
    self:SelectDeleteBtnClick()
  end)
  self._edit_btn:SetOnClick(function()
    self:SelectEditBtnClick()
  end)
  self._share_btn:SetOnClick(function()
    self:SelectShareBtnClick()
  end)
  self._selectBtn:SetOnClick(function()
    self:SelectInstallBtnClick()
  end)
  self:BuildSlotViews()
end

function RowItemComponent:ComponentDestroy()
  self._bg = nil
  self._line = nil
  self._name_text = nil
  self._empty_text = nil
  self._install_mark = nil
  self._cards_root = nil
  self._row_btn = nil
  self._delete_btn = nil
  self._edit_btn = nil
  self._share_btn = nil
  self._install_btn = nil
end

function RowItemComponent:DataDefine()
  self._rowIndex = 0
  self._onRowClick = nil
  self._onDeleteClick = nil
  self._onEditClick = nil
  self._onShareClick = nil
  self._onCardClick = nil
end

function RowItemComponent:DataDestroy()
  self._rowIndex = nil
  self._onRowClick = nil
  self._onDeleteClick = nil
  self._onEditClick = nil
  self._onShareClick = nil
  self._onCardClick = nil
end

function RowItemComponent:OnAddListener()
  base.OnAddListener(self)
end

function RowItemComponent:OnRemoveListener()
  base.OnRemoveListener(self)
end

function RowItemComponent:InitCallbacks(onRowClick)
  self._onRowClick = onRowClick
end

function RowItemComponent:BuildSlotViews()
  self.allSlotItemDic = {}
  self.allSlotItemList = {}
  if not self._cards_root then
    return
  end
  for _, slotId in ipairs(QUICK_EQUIP_SLOT_IDS) do
    local slotName = string.format("Slot_%s", slotId)
    local slotCpt = self._cards_root:AddComponent(QuickEquipSlotComponent, slotName)
    slotCpt:InitSlot(slotId, function(cardData)
      self:OnSlotItemBeClick(cardData)
    end)
    self.allSlotItemDic[slotId] = slotCpt
    table.insert(self.allSlotItemList, slotCpt)
  end
end

function RowItemComponent:OnSlotItemBeClick(cData)
  if not cData then
    return
  end
  if cData.uuid then
    local _cardData = DataCenter.TacticalCardDataManager:GetCardData(cData.uuid)
    if _cardData then
      UIManager:GetInstance():OpenWindow(UIWindowNames.UITCCardDetailPanel, {anim = true}, _cardData, true)
      return
    end
  end
  if cData.cardId then
    UIManager:GetInstance():OpenWindow(UIWindowNames.UITCCardViewPanel, {anim = true}, cData.cardId, true)
  end
end

function RowItemComponent:SetData(params)
  self._rowIndex = params.index
  self.cardGroupData = params.cardGroupData or {}
  self.isCustom = params.isCustom
  local curSelectIndex = params.curSelectIndex
  self.hasCards = self.cardGroupData and not self.cardGroupData:IsEmptyCardGroup()
  self:RefreshView(curSelectIndex)
end

function RowItemComponent:RefreshView(curSelectIndex)
  if not self.cardGroupData then
    return
  end
  local isEmptyCardGroup = self.cardGroupData:IsEmptyCardGroup()
  self._name_text:SetText(self.cardGroupData:GetCardGroupName())
  self._empty_text:SetActive(not self.hasCards)
  self._cards_root:SetActive(self.hasCards)
  if self._share_btn then
    self._share_btn:SetActive(self.isCustom and not isEmptyCardGroup)
  end
  if self._install_btn then
    self._install_btn:SetActive(self.hasCards)
  end
  self:RefreshSlots()
  self:RefreshSelectState(nil)
  self:RefreshSelectState(curSelectIndex)
end

function RowItemComponent:RefreshSlots()
  local cardDataList = self.cardGroupData:GetCardDataList() or {}
  local cardDataDic = {}
  for _, v in ipairs(cardDataList) do
    if v.slot then
      cardDataDic[v.slot] = v
    end
  end
  for index, slotItem in ipairs(self.allSlotItemList) do
    local cardData = cardDataDic[slotItem.slotId]
    slotItem:SetCardData(cardData)
  end
end

function RowItemComponent:ClearSlots()
end

function RowItemComponent:SelectInstallBtnClick()
  if self._onRowClick then
    self._onRowClick(self._rowIndex)
  end
end

function RowItemComponent:SelectShareBtnClick()
  if not self.isCustom then
    UIUtil.ShowTipsId("email_bind_fail_title")
    return
  end
  local shareParam = {}
  shareParam.postType = PostType.TacticalCard_EquipPlan
  shareParam.post = PostType.TacticalCard_EquipPlan
  shareParam.planIndex = self._rowIndex
  shareParam.param = {
    planIndex = self._rowIndex
  }
  UIManager:GetInstance():OpenWindow(UIWindowNames.UIPositionShare, {anim = true}, shareParam)
end

function RowItemComponent:SelectDeleteBtnClick()
  UIUtil.ShowConfirmNew({
    contentText = Localization:GetString("battle_card_new_recommend_desc_11"),
    btnNum = 2,
    confirmBtnParam = {
      action = function()
        DataCenter.TacticalCardDataManager:ReqDeleteCustomPlan(self._rowIndex)
      end
    },
    cancelBtnParam = {
      action = function()
      end
    },
    showToggle = false
  })
end

function RowItemComponent:SelectEditBtnClick()
  local params = {}
  params.titleKey = "battle_card_new_recommend_title_9"
  params.curNameTitleKey = "battle_card_preset_name_now"
  params.curNameStr = self.cardGroupData:GetCardGroupName()
  
  function params.confirmCallback(newName)
    if not string.IsNullOrEmpty(newName) then
      DataCenter.TacticalCardDataManager:ReqRenameCustomPlan(self._rowIndex, newName)
    end
  end
  
  UIManager:GetInstance():OpenWindow(UIWindowNames.UILWCommonRenameView, {anim = true}, params)
end

function RowItemComponent:RefreshSelectState(curSelectIndex)
  local isBeSelect = self._rowIndex == curSelectIndex
  self._selectBtn:SetActive(not isBeSelect)
  if self._bg then
    self._bg:LoadSprite(isBeSelect and ROW_SELECTED_SPRITE or ROW_UNSELECTED_SPRITE)
    self._bg:SetColor(ROW_BG_COLOR)
  end
  if self._line then
    self._line:SetColor(isBeSelect and ROW_LINE_SELECTED_COLOR or ROW_LINE_UNSELECTED_COLOR)
  end
  local isEmptyCardGroup = self.cardGroupData:IsEmptyCardGroup()
  local showCustomOps = self.isCustom and isBeSelect and not isEmptyCardGroup
  if self._delete_btn then
    self._delete_btn:SetActive(showCustomOps)
  end
  if self._edit_btn then
    self._edit_btn:SetActive(showCustomOps)
  end
  self._install_mark:SetActive(isBeSelect)
end

return RowItemComponent
