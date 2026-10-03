local TCCardBagView = BaseClass("TCCardBagView", UIBaseView)
local base = UIBaseView
local Localization = CS.GameEntry.Localization
local CommonTabGoupItemTemplate = require("DataCenter.CommonTabGroup.CommonTabGoupItemTemplate")
local UICommonTabGroup = require("UI.UICommonTabGroup.UICommonTabGroup")
local TCBagItemComponent = require("UI.LWUITCCardBag.Component.TCBagItemComponent")
local UIMainResourceProgress = require("UI.LWMainUI.Component.UIMainTop.UIMainResourceProgress")
local TAB_ITEM_PATH = "Assets/Main/Prefabs/UI/UICommonTabGroup/UICommonTabItem_TacticalCard.prefab"
local u_i_common_tab_group_path = "Root/TabArea/UICommonTabGroup"
local btn_back_path = "Root/BottomBar/BtnBack"
local scroll_view_path = "Root/center_content/Scroll View"
local content_path = "Root/center_content/Scroll View/Viewport/Content"
local salvage_btn_path = "Root/BottomBar/SalvageBtn"
local empty_tip_text_path = "Root/center_content/EmptyTipText"
local mastery_exp_count_text_path = "Root/TopBar/ResBarLayout/UIMainTopResourceCell_Exp/root/MasteryExpCountText"
local mastery_exp_icon_path = "Root/TopBar/ResBarLayout/UIMainTopResourceCell_Exp/root/MasteryExpIcon"
local mat_count_text_path = "Root/TopBar/ResBarLayout/UIMainTopResourceCell_Mat/root/MatCountText"
local mat_icon_path = "Root/TopBar/ResBarLayout/UIMainTopResourceCell_Mat/root/MatIcon"
local reset_btn_path = "Root/BottomBar/ResetBtn"
local expire_tip_path = "Root/center_content/expire_tip"
local expire_tip_text_path = "Root/center_content/expire_tip/tip_txt"
local expire_tip_btn_path = "Root/center_content/expire_tip/expire_tip_btn"
local center_content_path = "Root/center_content"
local TAB_KEY_CONFIG = {
  [TacticalCardType.Core] = "battle_card_core",
  [TacticalCardType.Battle] = "battle_card_battle",
  [TacticalCardType.Economy] = "battle_card_economic"
}
local BAG_ITEM_NAME_CONFIG = {
  [TacticalCardType.Core] = "TCBagItem_Core",
  [TacticalCardType.Battle] = "TCBagItem_Normal",
  [TacticalCardType.Economy] = "TCBagItem_Normal"
}

local function OnCreate(self)
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
  local guideData = self:GetUserData()
  if guideData then
    if guideData.goType then
      self.defaultSelectTab = guideData.goType
    end
    if guideData.onInitFinished then
      self.onInitFinished = guideData.onInitFinished
    end
  end
  self:ReInit()
end

local function OnDestroy(self)
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

local function OnEnable(self)
  base.OnEnable(self)
  self:RefreshTabRedDot()
  self:RefreshListItemsStatus()
end

local function OnDisable(self)
  base.OnDisable(self)
end

local function ComponentDefine(self)
  self.tabGroup = self:AddComponent(UICommonTabGroup, u_i_common_tab_group_path)
  self.tabGroup:SetCustomTabItemPath(TAB_ITEM_PATH)
  self._looplistview_content = self:AddComponent(UIBaseContainer, content_path)
  self.tabList = {}
  table.insert(self.tabList, TacticalCardType.Core)
  table.insert(self.tabList, TacticalCardType.Battle)
  table.insert(self.tabList, TacticalCardType.Economy)
  self:InitTabGroup()
  self.backBtn = self:AddComponent(UIButton, btn_back_path)
  self.backBtn:SetOnClick(function()
    self.ctrl:CloseSelf()
  end)
  self._looplistview = self:AddComponent(UILoopGridView, scroll_view_path)
  self._looplistview:InitGridView(0, function(listview, index)
    return self:GetScrollItem(listview, index)
  end)
  self.salvageBtn = self:AddComponent(UIButton, salvage_btn_path)
  self.salvageBtn:SetOnClick(function()
    self:OpenSalvagePanel()
  end)
  self.emptyTipTextObj = self:AddComponent(UIBaseContainer, empty_tip_text_path)
  self.masteryExpCountText = self:AddComponent(UIText, mastery_exp_count_text_path)
  self.masteryExpIcon = self:AddComponent(UIImage, mastery_exp_icon_path)
  self.matCountText = self:AddComponent(UIText, mat_count_text_path)
  self.matIcon = self:AddComponent(UIImage, mat_icon_path)
  self.expireTipText = self:AddComponent(UIText, expire_tip_text_path)
  self.expireTipObj = self:AddComponent(UIButton, expire_tip_path)
  self.expireTipObj:SetOnClick(function()
    self:OpenExpireTipPanel()
  end)
  self.centerContent = self:AddComponent(UIHorizontalOrVerticalLayoutGroup, center_content_path)
  self.resetBtn = self:AddComponent(UIButton, reset_btn_path)
  self.resetBtn:SetOnClick(function()
    self:OpenResetPanel()
  end)
end

local function ComponentDestroy(self)
end

local function DataDefine(self)
  self.curShowCardDataList = {}
  self._cellList = {}
end

local function DataDestroy(self)
  self.curShowCardDataList = nil
  self._cellList = nil
  self.defaultSelectTab = nil
  self.onInitFinished = nil
end

local function OnAddListener(self)
  base.OnAddListener(self)
  self:AddUIListener(EventId.TacticalCardLvUpgrade, self.UpdateWhenCardDataChange)
  self:AddUIListener(EventId.TacticalCardStarUpgrade, self.UpdateWhenCardDataChange)
  self:AddUIListener(EventId.TCCardEquipSuccess, self.UpdateWhenCardDataChange)
  self:AddUIListener(EventId.TCCardUnEquipSuccess, self.UpdateWhenCardDataChange)
  self:AddUIListener(EventId.TCCardSalvageSuccess, self.UpdateWhenCardDataChange)
  self:AddUIListener(EventId.OnPassDay, self.OnPassDay)
  self:AddUIListener(EventId.TacticalCardReset, self.UpdateWhenCardDataChange)
end

local function OnRemoveListener(self)
  self:RemoveUIListener(EventId.TacticalCardLvUpgrade, self.UpdateWhenCardDataChange)
  self:RemoveUIListener(EventId.TacticalCardStarUpgrade, self.UpdateWhenCardDataChange)
  self:RemoveUIListener(EventId.TCCardEquipSuccess, self.UpdateWhenCardDataChange)
  self:RemoveUIListener(EventId.TCCardUnEquipSuccess, self.UpdateWhenCardDataChange)
  self:RemoveUIListener(EventId.TCCardSalvageSuccess, self.UpdateWhenCardDataChange)
  self:RemoveUIListener(EventId.OnPassDay, self.OnPassDay)
  self:RemoveUIListener(EventId.TacticalCardReset, self.UpdateWhenCardDataChange)
  base.OnRemoveListener(self)
end

function TCCardBagView:InitTabGroup()
  local groupList = self:GetTabGroupList()
  local bindFunc1 = BindCallback(self, self.OnGroupLoadFinsh)
  local bindFunc2 = BindCallback(self, self.OnClickTab)
  
  local function bindFunc3(index)
    if index == TacticalCardType.Core then
      return DataCenter.TacticalCardDataManager:CheckAllCoreStarUpgrade(), 0
    end
    return false
  end
  
  self.tabGroup:RefreshGroup(groupList, bindFunc1, bindFunc2, bindFunc3)
end

function TCCardBagView:GetTabGroupList()
  local groupList = {}
  for index, value in ipairs(self.tabList) do
    local temp = CommonTabGoupItemTemplate.New()
    local keyStr = TAB_KEY_CONFIG[value]
    temp.title = Localization:GetString(keyStr)
    temp.eventId = EventId.TacticalCardStarUpgrade
    groupList[index] = temp
  end
  return groupList
end

function TCCardBagView:RefreshTabRedDot()
  if self.tabGroup then
    self.tabGroup:RefreshAllRedDot()
  end
end

function TCCardBagView:RefreshListItemsStatus()
  if self.selectIndex and self.curShowCardDataList and self._looplistview then
    self._looplistview:RefreshAllShownItem()
  end
end

function TCCardBagView:OnGroupLoadFinsh()
  local defaultSelectTab = TacticalCardType.Core
  if self.defaultSelectTab then
    defaultSelectTab = self.defaultSelectTab
    self.defaultSelectTab = nil
  end
  if self.params and self.params.tabType then
    defaultSelectTab = self.params.tabType
  end
  self.tabGroup:SelectTab(defaultSelectTab)
  if self.onInitFinished then
    self.onInitFinished()
    self.onInitFinished = nil
  end
end

function TCCardBagView:OnClickTab(index)
  self.selectIndex = index
  self.curSelectTab = self.tabList[index]
  self.curShowCardDataList = self.ctrl:GetCardDataListByCardType(self.curSelectTab)
  local startIndex = 0
  self._looplistview:MovePanelToItemByIndex(startIndex, 0, 0)
  self._looplistview:SetListItemCount(#self.curShowCardDataList, false, fasle)
  self._looplistview_content.rectTransform.localPosition = ResetPosition
  self._looplistview:RefreshAllShownItem()
  self.salvageBtn:SetActive(self.curSelectTab ~= TacticalCardType.Core)
  self.resetBtn:SetActive(self.curSelectTab == TacticalCardType.Core)
  local isEmpty = #self.curShowCardDataList <= 0
  self.emptyTipTextObj:SetActive(isEmpty)
  self:CheckExpireTip()
end

function TCCardBagView:GetScrollItem(listview, index)
  index = index + 1
  if index < 1 or index > #self.curShowCardDataList then
    return nil
  end
  local cardData = self.curShowCardDataList[index] or {}
  local prefabName = BAG_ITEM_NAME_CONFIG[cardData:GetCardType()]
  prefabName = prefabName or BAG_ITEM_NAME_CONFIG[TacticalCardType.Core]
  local item = listview:NewListViewItem(prefabName)
  if self._cellList[item] == nil then
    NameCount = NameCount + 1
    local nameStr = tostring(NameCount)
    item.gameObject.name = nameStr
    local mailItem = self._looplistview_content:AddComponent(TCBagItemComponent, nameStr)
    self._cellList[item] = mailItem
    self._cellList[item]:SetClickFunc(function(cData)
      self:OnItemBeClick(cData)
    end)
  end
  self._cellList[item]:SetData(cardData)
  return item
end

function TCCardBagView:OnItemBeClick(cData)
  UIManager:GetInstance():OpenWindow(UIWindowNames.UITCCardDetailPanel, {anim = true}, cData)
end

function TCCardBagView:OpenSalvagePanel()
  local curPageCardType = self.curSelectTab
  UIManager:GetInstance():OpenWindow(UIWindowNames.TCCardSalvage, {anim = true}, curPageCardType)
end

function TCCardBagView:OpenResetPanel()
  UIManager:GetInstance():OpenWindow(UIWindowNames.UITCCardResetPanel, {anim = true})
end

function TCCardBagView:UpdateWhenCardDataChange()
  self.curShowCardDataList = self.ctrl:GetCardDataListByCardType(self.curSelectTab)
  self._looplistview:RefreshAllShownItem()
  local isEmpty = #self.curShowCardDataList <= 0
  self.emptyTipTextObj:SetActive(isEmpty)
  self:UpdateTopBarNumInfo()
end

function TCCardBagView:ReInit()
  local resShowInfo = LuaEntry.DataConfig:TryGetStr("battle_card_param", "k9")
  local resShowInfoList = string.split(resShowInfo, "|")
  self.masteryExpItemId = tonumber(resShowInfoList[1])
  self.upgradeMatItemId = tonumber(resShowInfoList[2])
  local expIconPath = DataCenter.ResourceItemDataManager:GetIconPath(self.masteryExpItemId)
  self.masteryExpIcon:LoadSprite(expIconPath)
  local matIconPath = DataCenter.ResourceItemDataManager:GetIconPath(self.upgradeMatItemId)
  self.matIcon:LoadSprite(matIconPath)
  self:UpdateTopBarNumInfo()
  self:CheckExpireTip()
end

function TCCardBagView:UpdateTopBarNumInfo()
  local masteryExpCount = DataCenter.ResourceItemDataManager:GetCountByItemId(self.masteryExpItemId)
  self.masteryExpCountText:SetText(string.GetFormattedStr(masteryExpCount))
  local upgradeMatCount = DataCenter.ResourceItemDataManager:GetCountByItemId(self.upgradeMatItemId)
  self.matCountText:SetText(string.GetFormattedStr(upgradeMatCount))
end

function TCCardBagView:CheckExpireTip()
  local showExpireTip = true
  if self.curSelectTab == TacticalCardType.Core then
    showExpireTip = false
  end
  local isInSeasonNormal = DataCenter.SeasonDataManager:InNormalMode()
  if not isInSeasonNormal then
    showExpireTip = false
  end
  local expireDays = DataCenter.TacticalCardDataManager:GetCardRecycleDays()
  local expireTime = SeasonUtil.GetSeasonEndTime()
  local curTime = UITimeManager:GetInstance():GetServerTime()
  self.seasonEndTime = expireTime
  local countDownTime = expireTime - curTime
  if countDownTime <= 0 or countDownTime >= expireDays * 24 * 60 * 60 * 1000 then
    showExpireTip = false
  end
  if showExpireTip then
    self.expireTipObj:SetActive(true)
    self.needUpdateExpireTip = true
    self:UpdateExpireTip()
    self.centerContent:SetPaddingTop(12)
  else
    self.expireTipObj:SetActive(false)
    self.needUpdateExpireTip = false
    self.centerContent:SetPaddingTop(25)
  end
end

function TCCardBagView:UpdateExpireTip()
  if not self.needUpdateExpireTip then
    return
  end
  local curTime = UITimeManager:GetInstance():GetServerTime()
  local countDownTime = self.seasonEndTime - curTime
  if countDownTime <= 0 then
    self.expireTipObj:SetActive(false)
    self.needUpdateExpireTip = false
    return
  end
  local countDownStr = UITimeManager:GetInstance():MilliSecondToFmtString(countDownTime)
  self.expireTipText:SetText(Localization:GetString("battle_card_recycle_tips", countDownStr))
end

function TCCardBagView:Update1000MS()
  self:UpdateExpireTip()
end

function TCCardBagView:OnPassDay()
  self:CheckExpireTip()
end

function TCCardBagView:OpenExpireTipPanel()
  local param = {}
  param.activityRulesStr = Localization:GetString("battle_card_recycle_info")
  UIManager:GetInstance():OpenWindow(UIWindowNames.UIActivityDetailPopup, {anim = true}, param)
end

TCCardBagView.OnCreate = OnCreate
TCCardBagView.OnDestroy = OnDestroy
TCCardBagView.OnEnable = OnEnable
TCCardBagView.OnDisable = OnDisable
TCCardBagView.ComponentDefine = ComponentDefine
TCCardBagView.ComponentDestroy = ComponentDestroy
TCCardBagView.DataDefine = DataDefine
TCCardBagView.DataDestroy = DataDestroy
TCCardBagView.OnAddListener = OnAddListener
TCCardBagView.OnRemoveListener = OnRemoveListener
return TCCardBagView
