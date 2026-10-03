local UITCCardBookView = BaseClass("UITCCardBookView", UIBaseView)
local base = UIBaseView
local Localization = CS.GameEntry.Localization
local UICommonTabGroup = require("UI.UICommonTabGroup.UICommonTabGroup")
local CommonTabGoupItemTemplate = require("DataCenter.CommonTabGroup.CommonTabGoupItemTemplate")
local TAB_ITEM_PATH = "Assets/Main/Prefabs/UI/UILWTC/Book/TCCardBookTabItem.prefab"
local TCBookItemComponent = require("UI.LWUITC.UITCCardBookPanel.Component.TCBookItemComponent")
local StageRewardItem = require("UI.LWUITC.UITCCardBookPanel.Component.StageRewardItem")
local RewardUtil = require("Util.RewardUtil")
local StageStateType = DataCenter.TacticalCardDataManager.StageStateType
local TAB_KEY_CONFIG = {
  [TacticalCardType.Core] = "battle_card_core",
  [TacticalCardType.Battle] = "battle_card_battle",
  [TacticalCardType.Economy] = "battle_card_economic"
}
local BAG_ITEM_NAME_CONFIG = {
  [TacticalCardType.Core] = "CoreCardItem",
  [TacticalCardType.Battle] = "NormalCardItem",
  [TacticalCardType.Economy] = "NormalCardItem"
}
local REWARD_STAGE_ITEM_PATH = "Assets/Main/Prefabs/UI/UILWTC/Book/Reward_Item.prefab"

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
  DataCenter.TacticalCardDataManager:TryRequestCardBookData()
  base.OnEnable(self)
end

local function OnDisable(self)
  base.OnDisable(self)
end

local function ComponentDefine(self)
  self.curSeason_icon = self:AddComponent(UIImage, "Root/TopBar/seasonIcon")
  self.cardGridContent = self:AddComponent(UIBaseContainer, "Root/Scroll View/Viewport/Content")
  self.cardGrid = self:AddComponent(UILoopGridView, "Root/Scroll View")
  self.stage_reward = self:AddComponent(UIBaseContainer, "Root/stage_reward")
  self.stage_txt = self:AddComponent(UITextMeshProUGUIEx, "Root/stage_reward/stageLayout/stage_txt")
  self.progress_bg = self:AddComponent(UIImage, "Root/stage_reward/progress/progressBar/background")
  self.progress_filled = self:AddComponent(UIImage, "Root/stage_reward/progress/progressBar/filled")
  self.back_btn = self:AddComponent(UIButton, "Root/BottomBar/BtnBack")
  self.back_btn:SetOnClick(function()
    self:OnBack_btnClick()
  end)
  self.progress_container = self:AddComponent(UIBaseContainer, "Root/stage_reward/progress")
  self.info_btn = self:AddComponent(UIButton, "Root/stage_reward/stageLayout/info_btn")
  self.info_btn:SetOnClick(function()
    self:OnInfo_btnClick()
  end)
  self.tabGroup = self:AddComponent(UICommonTabGroup, "Root/TabArea/UICommonTabGroup")
  self.tabGroup:SetCustomTabItemPath(TAB_ITEM_PATH)
  self.tabList = {}
  table.insert(self.tabList, TacticalCardType.Core)
  table.insert(self.tabList, TacticalCardType.Battle)
  table.insert(self.tabList, TacticalCardType.Economy)
  self:InitTabGroup()
  self.cardGrid:InitGridView(0, function(listview, index)
    return self:GetScrollItem(listview, index)
  end)
  self._cellList = {}
end

local function ComponentDestroy(self)
  self.curSeason_icon = nil
  self.cardGridContent = nil
  self.cardGrid = nil
  self.stage_reward = nil
  self.stage_txt = nil
  self.progress_bg = nil
  self.progress_filled = nil
  self.back_btn = nil
  self.progress_container = nil
  self.info_btn = nil
end

local function DataDefine(self)
  self.needRefresh = false
end

local function DataDestroy(self)
  self.needRefresh = nil
end

local function OnAddListener(self)
  base.OnAddListener(self)
  self:AddUIListener(EventId.TacticalCardStageRewardChanged, self.OnTacticalCardStageRewardChanged)
  self:AddUIListener(EventId.TacticalCardBookDataChanged, self.OnTacticalCardBookDataChanged)
  self:AddUIListener(EventId.OnFinishHandleInitMsg, self.OnFinishHandleInitMsg)
end

local function OnRemoveListener(self)
  self:RemoveUIListener(EventId.TacticalCardStageRewardChanged, self.OnTacticalCardStageRewardChanged)
  self:RemoveUIListener(EventId.TacticalCardBookDataChanged, self.OnTacticalCardBookDataChanged)
  self:RemoveUIListener(EventId.OnFinishHandleInitMsg, self.OnFinishHandleInitMsg)
  base.OnRemoveListener(self)
end

local function OnBack_btnClick(self)
  self.ctrl:CloseSelf()
end

function UITCCardBookView:InitTabGroup()
  local groupList = self:GetTabGroupList()
  local bindFunc1 = BindCallback(self, self.OnGroupLoadFinsh)
  local bindFunc2 = BindCallback(self, self.OnClickTab)
  
  local function bindFunc3(index)
    local cardType = self.tabList[index]
    local hasCanReceiveBox = DataCenter.TacticalCardDataManager:HasCanReceiveBox(cardType)
    return hasCanReceiveBox
  end
  
  self.tabGroup:RefreshGroup(groupList, bindFunc1, bindFunc2, bindFunc3)
end

function UITCCardBookView:ReInit()
  self:SetSeasonIcon()
end

function UITCCardBookView:SetSeasonIcon()
  local curSeason = DataCenter.SeasonDataManager:GetSeason()
  local seasonIconFormat = LuaEntry.DataConfig:TryGetStr("battle_card_param", "k14")
  if not string.IsNullOrEmpty(seasonIconFormat) then
    local fullPath = string.format(seasonIconFormat, curSeason)
    self.curSeason_icon:LoadSpriteAsync(fullPath)
  end
end

function UITCCardBookView:GetTabGroupList()
  local groupList = {}
  for index, value in ipairs(self.tabList) do
    local temp = CommonTabGoupItemTemplate.New()
    local keyStr = TAB_KEY_CONFIG[value]
    temp.title = Localization:GetString(keyStr)
    temp.selectBgPath = "Assets/Main/Sprites/UI/UILWTCCardBook/FX_zhanshukapai_tujian_yeqian01.png"
    temp.eventId = EventId.TacticalCardStageRewardChanged
    groupList[index] = temp
  end
  return groupList
end

function UITCCardBookView:OnGroupLoadFinsh()
  local defaultSelectTab = TacticalCardType.Core
  if self.params and self.params.tabType then
    defaultSelectTab = self.params.tabType
  end
  self.tabGroup:SelectTab(defaultSelectTab)
end

function UITCCardBookView:RefreshProgress()
  self.cardCollection = DataCenter.TacticalCardDataManager:GetCardCollectionByType(self.curSelectTab)
  if not self.cardCollection then
    return
  end
  local activeCards = DataCenter.TacticalCardDataManager:GetActiveCardsByType(self.curSelectTab)
  self.activeCardCount = table.count(activeCards)
  if self.cardCollection then
    self:RefreshRewardItem(self.cardCollection.stageStateList, self.activeCardCount)
  else
    self.stage_txt:SetText({}, self.activeCardCount)
  end
end

function UITCCardBookView:OnClickTab(index)
  self.selectIndex = index
  self.curSelectTab = self.tabList[index]
  self.curShowCardDataList = self.ctrl:GetShowData(self.curSelectTab)
  local startIndex = 0
  self.cardGrid:MovePanelToItemByIndex(0, 0)
  self.cardGrid:SetListItemCount(#self.curShowCardDataList, false, false)
  self.cardGridContent.rectTransform.localPosition = ResetPosition
  self.cardGrid:RefreshAllShownItem()
  self:RefreshProgress()
end

function UITCCardBookView:GetScrollItem(listview, index)
  index = index + 1
  if index < 1 or index > #self.curShowCardDataList then
    return nil
  end
  local cardId = self.curShowCardDataList[index] or {}
  local cardTemplate = DataCenter.TacticalCardDataManager:GetTemplateData(cardId)
  if not cardTemplate then
    return nil
  end
  local prefabName = BAG_ITEM_NAME_CONFIG[cardTemplate.type]
  prefabName = prefabName or BAG_ITEM_NAME_CONFIG[TacticalCardType.Core]
  local item = listview:NewListViewItem(prefabName)
  if self._cellList[item] == nil then
    NameCount = NameCount + 1
    local nameStr = tostring(NameCount)
    item.gameObject.name = nameStr
    local cardItem = self.cardGridContent:AddComponent(TCBookItemComponent, nameStr)
    self._cellList[item] = cardItem
    self._cellList[item]:SetClickFunc(function(cId, cUuid, cLevel, cStar, cData)
      self:OnItemBeClick(cId)
    end)
  end
  self._cellList[item]:SetConfigData(cardId, 1, 0, CARD_DISPLAY_CONFIG)
  self._cellList[item]:SetMaskState(not DataCenter.TacticalCardDataManager:IsCardActivated(self.curSelectTab, cardId))
  return item
end

function UITCCardBookView:OnItemBeClick(cId, cUuid, cLevel, cStar, cData)
  UIManager:GetInstance():OpenWindow(UIWindowNames.UITCCardViewPanel, {anim = true}, cId)
end

function UITCCardBookView:OnRewardItemClick(item, index)
  if not self.cardCollection then
    return
  end
  local stageData = self.cardCollection.stageStateList[index + 1]
  if stageData.state == StageStateType.available or stageData.state == StageStateType.unavailable and stageData.needCnt <= self.activeCardCount then
    SFSNetwork.SendMessage(MsgDefines.ClaimBattleCardStageReward, index, self.curSelectTab, self.cardCollection.cfgId)
  else
    local rewardList = {}
    if not stageData.rewardList then
      rewardList = RewardUtil.GetRewardItem(stageData.reward)
      stageData.rewardList = rewardList
    else
      rewardList = stageData.rewardList
    end
    if rewardList and 0 < #rewardList then
      UIManager:GetInstance():OpenWindow(UIWindowNames.UIRewardContentTip, {anim = true}, item, rewardList, 0, 20, true)
    end
  end
end

local BOX_LENGTH = 150

function UITCCardBookView:RefreshRewardItem(stageData, currentProgress)
  local stageCount = #stageData
  if not self.rewardItems or stageCount > #self.rewardItems then
    local rewardItemCount = 0
    if self.rewardItems then
      rewardItemCount = #self.rewardItems
    end
    local addCount = stageCount - rewardItemCount
    for i = 1, addCount do
      local rewardItem = self:LoadComponentAsync(StageRewardItem, REWARD_STAGE_ITEM_PATH, self.progress_container, function(view, go, item, param)
        item:SetOnClick(function(item, index)
          self:OnRewardItemClick(item, index)
        end)
      end, nil, nil)
      if not self.rewardItems then
        self.rewardItems = {}
      end
      table.insert(self.rewardItems, rewardItem)
    end
  elseif stageCount < #self.rewardItems then
    for i = stageCount + 1, #self.rewardItems do
      local rewardItem = self.rewardItems[i]
      rewardItem:SetActive(false)
    end
  end
  if 0 < stageCount then
    for i = 1, stageCount do
      local rewardItem = self.rewardItems[i]
      rewardItem:SetActive(true)
      rewardItem:SetData(stageData[i].index, stageData[i].needCnt, stageData[i].state, self.activeCardCount, self.curSelectTab)
      rewardItem:RefreshView()
    end
  end
  local stageCount = #stageData
  local totalNeedCnt = stageData[stageCount].needCnt
  local bgWidth = 0
  if 1 < stageCount then
    bgWidth = (stageCount - 1) * BOX_LENGTH
  end
  local bgRect = self.progress_bg.gameObject:GetComponent(typeof(CS.UnityEngine.RectTransform))
  local bgSizeDelta = bgRect.sizeDelta
  bgSizeDelta.x = bgWidth
  bgRect.sizeDelta = bgSizeDelta
  local filledWidth = 0
  if 1 < stageCount then
    if currentProgress <= stageData[1].needCnt then
      filledWidth = 0
    elseif currentProgress >= stageData[stageCount].needCnt then
      filledWidth = (stageCount - 1) * BOX_LENGTH
    else
      for i = 2, stageCount do
        local prevStageNeedCnt = stageData[i - 1].needCnt
        local currentStageNeedCnt = stageData[i].needCnt
        if currentProgress < currentStageNeedCnt then
          local progressInSegment = currentProgress - prevStageNeedCnt
          local totalNeedForSegment = currentStageNeedCnt - prevStageNeedCnt
          local segmentProgressPercent = 0
          if 0 < totalNeedForSegment then
            segmentProgressPercent = math.max(0, math.min(1, progressInSegment / totalNeedForSegment))
          end
          filledWidth = (i - 2) * BOX_LENGTH + segmentProgressPercent * BOX_LENGTH
          break
        end
      end
    end
  end
  filledWidth = math.max(0, filledWidth)
  local filledRect = self.progress_filled.gameObject:GetComponent(typeof(CS.UnityEngine.RectTransform))
  local filledSizeDelta = filledRect.sizeDelta
  filledSizeDelta.x = filledWidth
  filledRect.sizeDelta = filledSizeDelta
  self.stage_txt:SetLocalText("battle_card_collect", self.activeCardCount, #self.curShowCardDataList)
end

function UITCCardBookView:OnTacticalCardStageRewardChanged()
  self:RefreshProgress()
end

function UITCCardBookView:OnTacticalCardBookDataChanged()
  self.needRefresh = true
end

function UITCCardBookView:OnDataChangeRefresh()
  self.ctrl:ResetShowData()
  self.curShowCardDataList = self.ctrl:GetShowData(self.curSelectTab)
  self.cardGrid:RefreshAllShownItem()
  self:RefreshProgress()
end

function UITCCardBookView:Update1000MS()
  if self.needRefresh then
    self:OnDataChangeRefresh()
    self.needRefresh = false
  end
end

function UITCCardBookView:OnInfo_btnClick()
  UIUtil.ShowIntro("", "", Localization:GetString("battle_card_collect_info"), nil)
end

function UITCCardBookView:OnFinishHandleInitMsg()
  DataCenter.TacticalCardDataManager:TryRequestCardBookData()
end

UITCCardBookView.OnCreate = OnCreate
UITCCardBookView.OnDestroy = OnDestroy
UITCCardBookView.OnEnable = OnEnable
UITCCardBookView.OnDisable = OnDisable
UITCCardBookView.ComponentDefine = ComponentDefine
UITCCardBookView.ComponentDestroy = ComponentDestroy
UITCCardBookView.DataDefine = DataDefine
UITCCardBookView.DataDestroy = DataDestroy
UITCCardBookView.OnAddListener = OnAddListener
UITCCardBookView.OnRemoveListener = OnRemoveListener
UITCCardBookView.OnBack_btnClick = OnBack_btnClick
return UITCCardBookView
