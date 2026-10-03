local UITCQuickEquipPanelV2View = BaseClass("UITCQuickEquipPanelV2View", UIBaseView)
local Localization = CS.GameEntry.Localization
local RowItemComponent = require("UI.LWUITC.UITCQuickEquipPanelV2.Component.RowItemComponent")
local base = UIBaseView
local Session = require("UI.LWUITC.UITCQuickEquipPanelV2.Component.UITCQuickEquipPanelV2Session")
local UICommonTabGroup = require("UI.UICommonTabGroup.UICommonTabGroup")
local CommonTabGoupItemTemplate = require("DataCenter.CommonTabGroup.CommonTabGoupItemTemplate")
local UILoopListView2 = require("Framework.UI.Component.UILoopListView2")
local u_i_common_tab_group_path = "Root/Content/UICommonTabGroup"
local item_root_path = "ItemRoot"
local apply_btn_path = "Root/Content/BottomBar/ApplyBtn"
local apply_btn_text_path = "Root/Content/BottomBar/ApplyBtn/ApplyBtnText"
local TAB_TYPE = {Custom = 1, Recommend = 2}
local TAB_TITLE_MAP = {
  [TAB_TYPE.Custom] = "battle_card_new_recommend_tag_2",
  [TAB_TYPE.Recommend] = "battle_card_new_recommend_tag_3"
}

local function _CloseSelfWindow()
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UITCQuickEquipPanelV2)
end

function UITCQuickEquipPanelV2View:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function UITCQuickEquipPanelV2View:OnEnable()
  base.OnEnable(self)
  if self._onPlanListChanged and self._planListCbOwner then
    Session.SetPlanListChangedCallback(self._onPlanListChanged, self._planListCbOwner)
  end
end

function UITCQuickEquipPanelV2View:OnDestroy()
  Session.SetPlanListChangedCallback(nil, self._planListCbOwner)
  self._onPlanListChanged = nil
  self._planListCbOwner = nil
  self:ClearAllRowCards()
  self:ComponentDestroy()
  self:DataDestroy()
  base.OnDestroy(self)
end

function UITCQuickEquipPanelV2View:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.TacticalCardDataChanged, self.RefreshView)
  self:AddUIListener(EventId.TacticalCardPresetDataUpdate, self.RefreshView)
end

function UITCQuickEquipPanelV2View:OnRemoveListener()
  self:RemoveUIListener(EventId.TacticalCardDataChanged, self.RefreshView)
  self:RemoveUIListener(EventId.TacticalCardPresetDataUpdate, self.RefreshView)
  base.OnRemoveListener(self)
end

function UITCQuickEquipPanelV2View:ComponentDefine()
  self.panel_btn = self:AddComponent(UIButton, "Panel")
  self.close_btn = self:AddComponent(UIButton, "Root/Content/TitleBar/CloseBtn")
  self.apply_btn = self:AddComponent(UIButton, apply_btn_path)
  self.applyBtnText = self:AddComponent(UIText, apply_btn_text_path)
  self.save_current_btn = self:AddComponent(UIButton, "Root/Content/BottomBar/SaveCurrentBtn")
  self.loop_list = self:AddComponent(UILoopListView2, "Root/Content/ListArea")
  self.rows_root = self:AddComponent(UIBaseContainer, "Root/Content/ListArea/Viewport/Rows")
  self.commonTabGroup = self:AddComponent(UICommonTabGroup, u_i_common_tab_group_path)
  self.commonTabGroup:SetTabItemStyle(CommonTabGroupItemStyle.Style1)
  self:InitTabGroup()
  self.itemRoot = self:AddComponent(UIBaseContainer, item_root_path)
  self.itemRoot:SetActive(false)
  if self.panel_btn then
    self.panel_btn:SetOnClick(function()
      _CloseSelfWindow()
    end)
  end
  if self.close_btn then
    self.close_btn:SetOnClick(function()
      _CloseSelfWindow()
    end)
  end
  self.apply_btn:SetOnClick(function()
    self:ApplyBtnClick()
  end)
  self.save_current_btn:SetOnClick(function()
    self:OnSaveCurrentClick()
  end)
  if self.loop_list then
    self.loop_list:InitListView(0, function(loopView, index)
      return self:OnGetRowItemByIndex(loopView, index)
    end)
  end
end

function UITCQuickEquipPanelV2View:ComponentDestroy()
  self.viewSkin = nil
  self.panel_btn = nil
  self.close_btn = nil
  self.save_current_btn = nil
  self.edit_plan_btn = nil
  self.loop_list = nil
  self.rows_root = nil
  self.rowViewMap = nil
  self.commonTabGroup = nil
  self.tabList = nil
end

function UITCQuickEquipPanelV2View:DataDefine()
  self.rowViewMap = {}
  self.rowItemSeq = 0
  self._needResetListToTop = true
  self._selectedTab = TAB_TYPE.Custom
  self._selectedIndex = 1
end

function UITCQuickEquipPanelV2View:DataDestroy()
  self.rowViewMap = nil
  self.rowItemSeq = nil
  self._needResetListToTop = nil
  self._selectedTab = nil
  self._selectedIndex = nil
end

function UITCQuickEquipPanelV2View:InitTabGroup()
  local groupList = self:GetTabGroupList()
  local bindFunc1 = BindCallback(self, self.OnGroupLoadFinsh)
  local bindFunc2 = BindCallback(self, self.OnClickTab)
  
  local function bindFunc3(index)
    return self:RefreshTabRedPoint(index)
  end
  
  self.commonTabGroup:RefreshGroup(groupList, bindFunc1, bindFunc2, bindFunc3)
end

function UITCQuickEquipPanelV2View:GetTabGroupList()
  self.tabList = {
    TAB_TYPE.Custom,
    TAB_TYPE.Recommend
  }
  local groupList = {}
  for index, tabType in ipairs(self.tabList) do
    local temp = CommonTabGoupItemTemplate.New()
    temp.title = Localization:GetString(TAB_TITLE_MAP[tabType])
    temp.unSelectBgPath = "Assets/Main/Sprites/UI/LWCommon/Sprite/cfm_tongyong_yeqian_erji_2.png"
    temp.selectBgPath = "Assets/Main/Sprites/UI/LWCommon/Sprite/cfm_tongyong_yeqian_erji_1.png"
    temp.arrowPath = false
    temp.minWidth = 367
    temp.minHeight = 80
    groupList[index] = temp
  end
  return groupList
end

function UITCQuickEquipPanelV2View:OnGroupLoadFinsh()
  self.commonTabGroup:SelectTab(self._selectedTab)
end

function UITCQuickEquipPanelV2View:OnClickTab(index)
  if not self.loop_list then
    return
  end
  local tab = self.tabList and self.tabList[index] or index
  self._selectedTab = tab
  local selectSaveKey = TAB_TITLE_MAP[self._selectedTab]
  self._selectedIndex = CS.GameEntry.Setting:GetInt(selectSaveKey, 1)
  self._needResetListToTop = true
  self:RefreshView()
end

function UITCQuickEquipPanelV2View:RefreshTabRedPoint(index)
  return false
end

function UITCQuickEquipPanelV2View:OnRowClick(index)
  if not self.loop_list then
    return
  end
  self._selectedIndex = index
  self:RefreshSelectState()
  self:RefreshBottomBtnState()
  local selectSaveKey = TAB_TITLE_MAP[self._selectedTab]
  CS.GameEntry.Setting:SetInt(selectSaveKey, self._selectedIndex)
end

function UITCQuickEquipPanelV2View:RefreshSelectState()
  local allRowItemList = self.rows_root:GetComponents(RowItemComponent)
  if not allRowItemList then
    return
  end
  for _, v in ipairs(allRowItemList) do
    v:RefreshSelectState(self._selectedIndex)
  end
end

function UITCQuickEquipPanelV2View:ApplyBtnClick()
  if TacticalCardUtil.IsAnyCardInCD() then
    UIUtil.ShowTipsId("battle_card_new_recommend_tips_15")
    return
  end
  local curSelectCardGroup = self:GetCurSelectCardGroupData()
  if curSelectCardGroup:IsEmptyCardGroup() then
    return
  end
  if DataCenter.ArmyFormationDataManager:IsAnyWorldFormationOutside() then
    UIUtil.ShowTips(Localization:GetString("battle_card_change_tips2"))
    return
  end
  local needPopTipParams = {}
  local popIndex = 1
  
  local function checkTipPopFunc()
    if needPopTipParams[popIndex] then
      local params = needPopTipParams[popIndex]
      UIUtil.ShowConfirmNew({
        title = Localization:GetString("100378"),
        contentText = Localization:GetString(params.contentText),
        showToggle = false,
        btnNum = 2,
        confirmBtnParam = {
          action = function()
            popIndex = popIndex + 1
            if popIndex > #needPopTipParams then
              self:DoInstallSelectCardGroup()
            end
          end
        }
      })
    else
      self:DoInstallSelectCardGroup()
    end
  end
  
  local isExistCardMissing = self:IsExistMissingCard()
  if isExistCardMissing then
    local params = {}
    params.contentText = self._selectedTab == TAB_TYPE.Custom and "battle_card_new_recommend_desc_12" or "battle_card_new_recommend_tips_16"
    table.insert(needPopTipParams, params)
  end
  if #needPopTipParams <= 0 then
    self:DoInstallSelectCardGroup()
    return
  end
  checkTipPopFunc()
end

function UITCQuickEquipPanelV2View:IsExistMissingCard()
  local cardDataList = self:GetCurSelectCardIdList()
  for _, v in ipairs(cardDataList) do
    if v.uuid and not DataCenter.TacticalCardDataManager:GetCardData(v.uuid) then
      return true
    end
    if v.cardId and not DataCenter.TacticalCardDataManager:HasCard(v.cardId) then
      return true
    end
  end
  return false
end

function UITCQuickEquipPanelV2View:DoInstallSelectCardGroup()
  if self._selectedTab == TAB_TYPE.Custom then
    DataCenter.TacticalCardDataManager:ReqApplyCustomPlan(self._selectedIndex)
  elseif self._selectedTab == TAB_TYPE.Recommend then
    self:EquipCurSelectRecommendCardGroup()
  end
  self.ctrl:CloseSelf()
end

function UITCQuickEquipPanelV2View:EquipCurSelectRecommendCardGroup()
  if self.cardGroupDataList then
    local allCardDataList = self:GetCurSelectCardIdList()
    local cardDataList = {}
    table.sort(allCardDataList, function(a, b)
      local isSlotUnlockA = TacticalCardUtil.CheckSlotLockState(a.slot) and 0 or 1
      local isSlotUnlockB = TacticalCardUtil.CheckSlotLockState(b.slot) and 0 or 1
      if isSlotUnlockA ~= isSlotUnlockB then
        return isSlotUnlockA > isSlotUnlockB
      end
      return a.slot > b.slot
    end)
    for _, v in ipairs(allCardDataList) do
      if not TacticalCardUtil.CheckSlotLockState(v.slot) then
        if v.uuid and DataCenter.TacticalCardDataManager:GetCardData(v.uuid) then
          table.insert(cardDataList, v)
        end
        if v.cardId and DataCenter.TacticalCardDataManager:HasCard(v.cardId) then
          table.insert(cardDataList, v)
        end
      end
    end
    local wantEquipCardIdDic = {}
    for _, v in ipairs(cardDataList) do
      wantEquipCardIdDic[v.slot] = v.cardId
    end
    local curCardGroup = self:GetCurSelectCardGroupData()
    local curQuickEquipCardList = TacticalCardUtil.GetCurQuickEquipCardList(curCardGroup.sort, wantEquipCardIdDic)
    if not curQuickEquipCardList or table.count(curQuickEquipCardList) == 0 then
      UIUtil.ShowTipsId("battle_card_recommend_ok")
      return true
    end
    local params = {}
    for slotId, v in pairs(curQuickEquipCardList) do
      table.insert(params, {
        uuid = v.uuid,
        slotId = slotId
      })
    end
    if 0 < #params then
      SFSNetwork.SendMessage(MsgDefines.BattleCardPutOn, params, true)
    end
  end
end

function UITCQuickEquipPanelV2View:GetCurSelectCardGroupData()
  return self.cardGroupDataList[self._selectedIndex]
end

function UITCQuickEquipPanelV2View:GetCurSelectCardIdList()
  local curSelectCardGroup = self:GetCurSelectCardGroupData()
  if not curSelectCardGroup then
    return {}
  end
  return curSelectCardGroup:GetCardDataList()
end

function UITCQuickEquipPanelV2View:OnSaveCurrentClick()
  if self._selectedTab ~= TAB_TYPE.Custom then
    return
  end
  local idx = self._selectedIndex
  DataCenter.TacticalCardDataManager:ReqSaveCustomPlan(idx)
end

function UITCQuickEquipPanelV2View:ClearAllRowCards()
  if not self.rowViewMap then
    return
  end
  for _, rowCpt in pairs(self.rowViewMap) do
    rowCpt:ClearSlots()
  end
end

function UITCQuickEquipPanelV2View:RefreshView()
  self.cardGroupDataList = nil
  local presetData
  if self._selectedTab == TAB_TYPE.Custom then
    presetData = DataCenter.TacticalCardDataManager:GetCustomPresetData()
    self.cardGroupDataList = presetData:GetAllCardGroupDataList()
    if not self.alreadyReqCustomData then
      self.ctrl:ReqCustomData()
      self.alreadyReqCustomData = true
    end
  elseif self._selectedTab == TAB_TYPE.Recommend then
    presetData = DataCenter.TacticalCardDataManager:GetRecommendPresetData()
    self.cardGroupDataList = presetData:GetAllCardGroupDataList() or {}
  else
    self.cardGroupDataList = {}
  end
  local rowCount = #self.cardGroupDataList
  if not self.loop_list then
    return
  end
  local selectedIndex = self._selectedIndex
  if #self.cardGroupDataList > 0 and selectedIndex > #self.cardGroupDataList then
    selectedIndex = #self.cardGroupDataList
    self._selectedIndex = selectedIndex
  end
  if self.save_current_btn then
    self.save_current_btn:SetActive(self._selectedTab == TAB_TYPE.Custom)
  end
  if rowCount <= 0 then
    self.loop_list:SetListItemCount(0, false, false)
    self:ClearAllRowCards()
    CS.UIGray.SetGray(self.apply_btn.transform, true, false)
    return
  end
  self.loop_list:ClearItemPosCache()
  self.loop_list:SetListItemCount_Mod(rowCount, false, false, true)
  self.loop_list:ForceUpdate()
  if self._needResetListToTop and self.loop_list.unity_looplistview2 and self.loop_list.unity_looplistview2.ScrollRect then
    self.loop_list.unity_looplistview2.ScrollRect.verticalNormalizedPosition = 1
    self._needResetListToTop = false
  end
  self:RefreshBottomBtnState()
end

function UITCQuickEquipPanelV2View:RefreshBottomBtnState()
  local isCustom = self._selectedTab == TAB_TYPE.Custom
  self.apply_btn:SetActive(true)
  self.applyBtnText:SetLocalText(isCustom and "battle_card_new_recommend_btn_7" or "battle_card_new_recommend_btn_8")
  self.save_current_btn:SetActive(isCustom)
  local isSelectEmptyCardGroup = false
  if isCustom then
    local curSelectCardGroup = self:GetCurSelectCardGroupData()
    if curSelectCardGroup then
      local allExistCardList = curSelectCardGroup:GetExistCardDataList()
      if not allExistCardList or #allExistCardList <= 0 then
        isSelectEmptyCardGroup = true
      end
    end
  end
  CS.UIGray.SetGray(self.apply_btn.transform, isSelectEmptyCardGroup, not isSelectEmptyCardGroup)
end

function UITCQuickEquipPanelV2View:OnGetRowItemByIndex(listview, index)
  local tab = self._selectedTab
  local rowIndex = index + 1
  local rowCount = self.cardGroupDataList and #self.cardGroupDataList or 0
  if rowIndex < 1 or rowIndex > rowCount then
    return nil
  end
  local item = listview:NewListViewItem("RowItem")
  local rowCpt = self.rows_root:GetComponent(item.gameObject.name, RowItemComponent)
  if not rowCpt then
    local name = tostring(NameCount)
    NameCount = NameCount + 1
    item.gameObject.name = name
    rowCpt = self.rows_root:AddComponent(RowItemComponent, name)
  end
  rowCpt:InitCallbacks(function(rowIndex)
    self:OnRowClick(rowIndex)
  end)
  local cardGroupData = self.cardGroupDataList and self.cardGroupDataList[rowIndex] or nil
  local params = {}
  params.index = rowIndex
  params.cardGroupData = cardGroupData
  params.isCustom = self._selectedTab == TAB_TYPE.Custom
  params.curSelectIndex = self._selectedIndex
  params.isEditorMode = self.isEditorMode
  rowCpt:SetData(params)
  return item
end

return UITCQuickEquipPanelV2View
