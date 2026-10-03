local UIActBountyHunterRewardView = BaseClass("UIActBountyHunterRewardView", UIBaseView)
local UICommonTab = require("UI.UICommonTab.UICommonTab")
local base = UIBaseView
local Localization = CS.GameEntry.Localization
local sub_title_text_path = "Content/BattleLogArea/SubTitleText"
local bounty_hunter_boss_log_card_path = "Content/ItemRoot/BountyHunterBossLogCard"
local bounty_hunter_normal_log_card_path = "Content/ItemRoot/BountyHunterNormalLogCard"
local scroll_view_path = "Content/RewardInfoArea/Scroll View"
local reward_content_path = "Content/RewardInfoArea/Scroll View/Viewport/RewardContent"
local bat_log_scroll_view_path = "Content/BattleLogArea/BatLogScrollView"
local battle_log_content_path = "Content/BattleLogArea/BatLogScrollView/Viewport/BattleLogContent"
local cur_stored_reward_tab_path = "Content/RewardInfoArea/TableArea/CurStoredRewardTab"
local had_claim_reward_tab_path = "Content/RewardInfoArea/TableArea/HadClaimRewardTab"
local viewport_path = "Content/RewardInfoArea/Scroll View/Viewport"
local panel_path = "UICommonPopUpTitle/panel"
local close_btn_path = "UICommonPopUpTitle/Common_bg_orange/CloseBtn"
local table_area_path = "Content/RewardInfoArea/TableArea"
local claim_stash_reward_btn_path = "Content/ClaimStashRewardBtn"
local log_empty_tip_text_path = "Content/BattleLogArea/LogEmptyTipText"
local bottom_empty_tip_text_path = "Content/RewardInfoArea/BottomEmptyTipText"
local NormalCard = require("UI.LWUIActBountyHunter.LWUIActBountyHunterReward.Component.BountyHunterNormalLogCardComponent")
local TabType = {CurStoreReward = 1, AlreadyClaimReward = 2}
local ShowTabTextKey = {
  [TabType.CurStoreReward] = "activity_hunter_record_desc5",
  [TabType.AlreadyClaimReward] = "activity_hunter_record_desc6"
}

local function OnCreate(self)
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
  self.activityId = self:GetUserData()
  self:RefreshView()
  PostEventLog.Track(PostEventLog.Defines.BountyHunterOpenReward)
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
  self.batLogTitleText = self:AddComponent(UIText, sub_title_text_path)
  self.rewardContent = self:AddComponent(GridInfinityScrollView, reward_content_path)
  self.rewardViewportObj = self:AddComponent(UIBaseContainer, viewport_path)
  local bindFunc1 = BindCallback(self, self.OnInitScroll)
  local bindFunc2 = BindCallback(self, self.OnUpdateScroll)
  local bindFunc3 = BindCallback(self, self.OnDestroyScrollItem)
  self.rewardContent:Init(bindFunc1, bindFunc2, bindFunc3)
  self.closePanel = self:AddComponent(UIButton, panel_path)
  self.closePanel:SetOnClick(function()
    self.ctrl:CloseSelf()
  end)
  self.closeBtn = self:AddComponent(UIButton, close_btn_path)
  self.closeBtn:SetOnClick(function()
    self.ctrl:CloseSelf()
  end)
  self.tabList = {}
  for i = 1, table.count(TabType) do
    local tabName = string.format("UICommonTab%s", i)
    self.tabList[i] = self:AddComponent(UICommonTab, table_area_path .. "/" .. tabName)
    local param = {}
    param.tabId = i
    param.title = Localization:GetString(ShowTabTextKey[i])
    
    function param.clickHandler()
      self:OnTabClick(param.tabId)
    end
    
    self.tabList[i]:ReInit(param)
  end
  self.scrollViewObj = self:AddComponent(UIBaseContainer, scroll_view_path)
  self.claimStashRewardBtn = self:AddComponent(UIButton, claim_stash_reward_btn_path)
  self.claimStashRewardBtn:SetOnClick(function()
    self:ClickClaimStashRewardBtn()
  end)
  self._looplistview = self:AddComponent(UILoopListView2, bat_log_scroll_view_path)
  self._looplistview_content = self:AddComponent(UIBaseContainer, battle_log_content_path)
  self._looplistview:InitListView(0, function(listview, index)
    return self:GetScrollItem(listview, index)
  end)
  self.batLogEmptyText = self:AddComponent(UIText, log_empty_tip_text_path)
  self.bottomEmptyText = self:AddComponent(UIText, bottom_empty_tip_text_path)
end

local function ComponentDestroy(self)
  self:ClearItemCell()
  self._looplistview_content:RemoveComponents(NormalCard)
  self._looplistview:ClearAllItems()
end

local function DataDefine(self)
  self.curSelectTab = TabType.CurStoreReward
  self._cellList = {}
end

local function DataDestroy(self)
  self.curSelectTab = nil
  self.listGO = nil
  self._cellList = nil
end

local function OnAddListener(self)
  base.OnAddListener(self)
  self:AddUIListener(EventId.BountyHunterSuccessGetStashReward, self.OnSuccessGetStashReward)
  self:AddUIListener(EventId.BountyHunterReceiveBatLogData, self.OnReceiveBatLogData)
end

local function OnRemoveListener(self)
  self:RemoveUIListener(EventId.BountyHunterSuccessGetStashReward, self.OnSuccessGetStashReward)
  self:RemoveUIListener(EventId.BountyHunterReceiveBatLogData, self.OnReceiveBatLogData)
  base.OnRemoveListener(self)
end

function UIActBountyHunterRewardView:RefreshView()
  self:RefreshBattleLogView(true)
  self:ChangeSelectTab(TabType.CurStoreReward)
end

function UIActBountyHunterRewardView:RefreshBattleLogView(callByOpenView)
  self._looplistview:ClearAllItems()
  local dataCount = self.ctrl:GetBatLogDataCnt(self.activityId)
  local isEmptyLog = dataCount <= 0
  self.batLogEmptyText:SetActive(isEmptyLog)
  if isEmptyLog and callByOpenView then
    self.ctrl:ReqBatLogData(self.activityId)
    return
  end
  self._looplistview:SetListItemCount(dataCount, false, false)
end

function UIActBountyHunterRewardView:OnSuccessGetStashReward()
  self:ChangeSelectTab(TabType.CurStoreReward)
end

function UIActBountyHunterRewardView:OnReceiveBatLogData(activityId)
  if activityId ~= self.activityId then
    return
  end
  local dataCount = self.ctrl:GetBatLogDataCnt(self.activityId)
  if dataCount <= 0 then
    return
  end
  self:RefreshBattleLogView(false)
end

function UIActBountyHunterRewardView:ChangeSelectTab(tabType)
  self.rewardContent:SetItemCount(0)
  for i = 1, table.count(TabType) do
    self.tabList[i]:SetSelect(i == tabType)
  end
  self.claimStashRewardBtn:SetActive(tabType == TabType.CurStoreReward)
  local scrollViewHeight = 400
  if tabType == TabType.CurStoreReward then
    scrollViewHeight = 300
  end
  self.scrollViewObj:SetSizeDelta(Vector2.New(700, scrollViewHeight))
  self.curSelectTab = tabType
  local rewardDataList
  if type(self.ctrl.GetRewardDataByTabType) == "function" then
    rewardDataList = self.ctrl:GetRewardDataByTabType(self.activityId, self.curSelectTab)
  end
  if rewardDataList and 0 < #rewardDataList then
    self.rewardDataList = rewardDataList
    self.rewardContent:SetItemCount(#self.rewardDataList)
  end
  local isEmpty = #rewardDataList == 0
  self.bottomEmptyText:SetActive(isEmpty)
  if isEmpty then
    local key = tabType == TabType.CurStoreReward and "activity_hunter_record_desc7" or "activity_hunter_record_desc8"
    self.bottomEmptyText:SetLocalText(key)
  end
end

function UIActBountyHunterRewardView:OnTabClick(tabType)
  self:ChangeSelectTab(tabType)
end

function UIActBountyHunterRewardView:OnInitScroll(go, index)
  if not self.listGO then
    self.listGO = {}
  end
  local item = self.rewardViewportObj:AddComponent(UICommonResItem, go)
  self.listGO[go] = item
end

function UIActBountyHunterRewardView:OnUpdateScroll(go, index)
  local cellItem = self.listGO[go]
  go.name = "item_" .. index
  local rewardData = self.rewardDataList[index + 1]
  cellItem:ParseInfo(rewardData)
  cellItem:SetActive(true)
end

function UIActBountyHunterRewardView:OnDestroyScrollItem(go, index)
end

function UIActBountyHunterRewardView:ClearItemCell()
  self.rewardViewportObj:RemoveComponents(UICommonResItem)
  self.rewardContent:DestroyChildNode()
end

function UIActBountyHunterRewardView:ClickClaimStashRewardBtn()
  if self.ctrl.ReqClaimStashReward then
    self.ctrl:ReqClaimStashReward(self.activityId)
  end
end

function UIActBountyHunterRewardView:GetScrollItem(listview, index)
  index = index + 1
  if index < 1 or index > self.ctrl:GetBatLogDataCnt(self.activityId) then
    return nil
  end
  local item_data = self.ctrl:GetItemByIndex(self.activityId, index) or {}
  local prefabName, scriptName = self.ctrl:GetPrefabAndScriptName(item_data)
  local item = listview:NewListViewItem(prefabName)
  if self._cellList[item] == nil then
    NameCount = NameCount + 1
    local nameStr = tostring(NameCount)
    item.gameObject.name = nameStr
    local mailItem = self._looplistview_content:AddComponent(scriptName, nameStr)
    self._cellList[item] = mailItem
  else
    NameCount = NameCount + 1
    local nameStr = tostring(NameCount)
    item.gameObject.name = nameStr
  end
  self._cellList[item]:SetData(item_data)
  return item
end

UIActBountyHunterRewardView.OnCreate = OnCreate
UIActBountyHunterRewardView.OnDestroy = OnDestroy
UIActBountyHunterRewardView.OnEnable = OnEnable
UIActBountyHunterRewardView.OnDisable = OnDisable
UIActBountyHunterRewardView.ComponentDefine = ComponentDefine
UIActBountyHunterRewardView.ComponentDestroy = ComponentDestroy
UIActBountyHunterRewardView.DataDefine = DataDefine
UIActBountyHunterRewardView.DataDestroy = DataDestroy
UIActBountyHunterRewardView.OnAddListener = OnAddListener
UIActBountyHunterRewardView.OnRemoveListener = OnRemoveListener
return UIActBountyHunterRewardView
