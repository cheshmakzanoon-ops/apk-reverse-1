local UIBanquetFinRewardGetNewView = BaseClass("UIBanquetFinRewardGetNewView", UIBaseView)
local UICommonTab = require("UI.UICommonTab.UICommonTab")
local CommonActivityPopUpBgPart = require("UI.LWActivityCommonSecondPopUp.UIActivityDetailCommon.Component.CommonActivityPopUpBgPart")
local base = UIBaseView
local Localization = CS.GameEntry.Localization
local sub_title_text_path = "Content/BattleLogArea/SubTitleText"
local scroll_view_path = "Content/RewardInfoArea/ScrollView"
local reward_content_path = "Content/RewardInfoArea/ScrollView/Viewport/RewardContent"
local bat_log_scroll_view_path = "Content/BattleLogArea/BatLogScrollView"
local battle_log_content_path = "Content/BattleLogArea/BatLogScrollView/Viewport/BattleLogContent"
local viewport_path = "Content/RewardInfoArea/ScrollView/Viewport"
local panel_path = "UICommonPopUpTitle/panel"
local close_btn_path = "UICommonPopUpTitle/Common_bg_orange/CloseBtn"
local table_area_path = "Content/RewardInfoArea/TableArea"
local claim_stash_reward_btn_path = "Content/ClaimStashRewardBtn"
local activityThemPath = "Assets/Main/Sprites/UI/ActivityThemeSkin/%s"
local TabType = {CurStoreReward = 1, AlreadyClaimReward = 2}
local ShowTabTextKey = {
  [TabType.CurStoreReward] = "100354",
  [TabType.AlreadyClaimReward] = "2800100"
}

local function OnCreate(self)
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
  local userData = self:GetUserData()
  self.activityId = userData.activityId
  self.partyNewId = userData.partyNewId
  self:RefreshView()
  self.commonActivityPopUpBgPart:InitByActivityId(self.activityId)
  self:RefreshViewPacking()
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
  self.batLogTitleText:SetLocalText("activity_partynew_record_desc1")
  self.rewardContent = self:AddComponent(UIBaseContainer, reward_content_path)
  self.rewardViewportObj = self:AddComponent(UIBaseContainer, viewport_path)
  self.closePanel = self:AddComponent(UIButton, panel_path)
  self.closePanel:SetOnClick(function()
    self.ctrl:CloseSelf()
  end)
  self.closeBtn = self:AddComponent(UIButton, close_btn_path)
  self.closeBtn:SetOnClick(function()
    self.ctrl:CloseSelf()
  end)
  local titleKey = {
    "activity_partynew_record_desc4",
    "activity_partynew_record_desc5"
  }
  self.tabList = {}
  for i = 1, table.count(TabType) do
    local tabName = string.format("UICommonTab%s", i)
    self.tabList[i] = self:AddComponent(UICommonTab, table_area_path .. "/" .. tabName)
    local param = {}
    param.tabId = i
    param.title = Localization:GetString(titleKey[i])
    
    function param.clickHandler()
      self:OnTabClick(param.tabId)
    end
    
    self.tabList[i]:ReInit(param)
  end
  self.scrollViewObj = self:AddComponent(UILoopGridView, scroll_view_path)
  self.scrollViewObj:InitGridView(0, function(loopScroll, index, item)
    return self:OnGetItemByRowColumn(loopScroll, index)
  end)
  self.claimStashRewardBtn = self:AddComponent(UIButton, claim_stash_reward_btn_path)
  self.claimStashRewardBtn:SetOnClick(function()
    self:ClickClaimStashRewardBtn()
  end)
  self._looplistview = self:AddComponent(UILoopListView2, bat_log_scroll_view_path)
  self._looplistview_content = self:AddComponent(UIBaseContainer, battle_log_content_path)
  self._looplistview:InitListView(0, function(listview, index)
    return self:GetScrollItem(listview, index)
  end)
  self.noneRewardTips = self:AddComponent(UITextMeshProUGUIEx, "Content/RewardInfoArea/noneRewardTips")
  self.emptyText = self:AddComponent(UITextMeshProUGUIEx, "Content/BattleLogArea/EmptyText")
  self.emptyText:SetLocalText("avatar_tips004")
  self.table_area = self:AddComponent(UIImage, table_area_path)
  self.commonActivityPopUpBgPart = self:AddComponent(CommonActivityPopUpBgPart, "UICommonPopUpTitle/CommonActivityPopUpBgPart")
end

local function ComponentDestroy(self)
  self:ClearItemCell()
  self._looplistview_content:RemoveAllComponentes()
  self._looplistview:ClearAllItems()
  self.emptyText = nil
  self.table_area = nil
  self.commonActivityPopUpBgPart = nil
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
  self:AddUIListener(EventId.BanquetReceiveBatLogData, self.OnReceiveBatLogData)
  self:AddUIListener(EventId.BanquetSuccessGetStashReward, self.OnSuccessGetStashReward)
end

local function OnRemoveListener(self)
  self:RemoveUIListener(EventId.BanquetReceiveBatLogData, self.OnReceiveBatLogData)
  self:RemoveUIListener(EventId.BanquetSuccessGetStashReward, self.OnSuccessGetStashReward)
  base.OnRemoveListener(self)
end

function UIBanquetFinRewardGetNewView:RefreshView()
  self:RefreshBattleLogView()
  self:ChangeSelectTab(TabType.CurStoreReward)
end

function UIBanquetFinRewardGetNewView:RefreshBattleLogView()
  local dataCount = self.ctrl:GetBatLogDataCnt(self.activityId)
  self.emptyText:SetActive(dataCount == 0)
  if dataCount <= 0 then
    self.ctrl:ReqBatLogData(self.activityId, self.partyNewId)
    return
  end
  self._looplistview:SetListItemCount(dataCount, false, false)
  self._looplistview:RefreshAllShownItem()
end

function UIBanquetFinRewardGetNewView:OnSuccessGetStashReward()
  self:ChangeSelectTab(self.curSelectTab)
end

function UIBanquetFinRewardGetNewView:OnReceiveBatLogData(activityId)
  if activityId ~= self.activityId then
    return
  end
  local dataCount = self.ctrl:GetBatLogDataCnt()
  if dataCount <= 0 then
    return
  end
  self:RefreshBattleLogView()
end

function UIBanquetFinRewardGetNewView:ChangeSelectTab(tabType)
  for i = 1, table.count(TabType) do
    self.tabList[i]:SetSelect(i == tabType)
  end
  local scrollViewHeight = 400
  if tabType == TabType.CurStoreReward then
    scrollViewHeight = 300
  end
  self.scrollViewObj:SetSizeDelta(Vector2.New(700, scrollViewHeight))
  self.curSelectTab = tabType
  local rewardDataList
  if type(self.ctrl.GetRewardDataByTabType) == "function" then
    rewardDataList = self.ctrl:GetRewardDataByTabType(self.curSelectTab)
  end
  local haveData = rewardDataList and 0 < #rewardDataList
  if haveData then
    self.rewardDataList = rewardDataList
    self.scrollViewObj:SetListItemCount(#rewardDataList)
    self.scrollViewObj:RefreshAllShownItem()
  end
  self.scrollViewObj:SetActive(haveData)
  self.noneRewardTips:SetActive(not haveData)
  self.claimStashRewardBtn:SetActive(tabType == TabType.CurStoreReward and haveData)
  self.noneRewardTips:SetLocalText(self.ctrl:GetRewardNoneTipsKey(self.curSelectTab))
end

function UIBanquetFinRewardGetNewView:OnTabClick(tabType)
  self:ChangeSelectTab(tabType)
end

function UIBanquetFinRewardGetNewView:OnInitScroll(go, index)
  if not self.listGO then
    self.listGO = {}
  end
  local item = self.rewardViewportObj:AddComponent(UICommonResItem, go)
  self.listGO[go] = item
end

function UIBanquetFinRewardGetNewView:OnUpdateScroll(go, index)
  local cellItem = self.listGO[go]
  go.name = "item_" .. index
  local rewardData = self.rewardDataList[index + 1]
  cellItem:ParseInfo(rewardData)
  cellItem:SetActive(true)
end

function UIBanquetFinRewardGetNewView:OnDestroyScrollItem(go, index)
end

function UIBanquetFinRewardGetNewView:ClearItemCell()
  self.rewardContent:RemoveComponents(UICommonResItem)
  self.scrollViewObj:ClearAllItems()
end

function UIBanquetFinRewardGetNewView:ClickClaimStashRewardBtn()
  if self.ctrl.ReqClaimStashReward then
    self.ctrl:ReqClaimStashReward(self.activityId)
  end
end

function UIBanquetFinRewardGetNewView:GetScrollItem(listview, index)
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

function UIBanquetFinRewardGetNewView:OnGetItemByRowColumn(loopScroll, index)
  if self.rewardDataList ~= nil then
    local count = #self.rewardDataList
    index = index + 1
    if index < 1 or count < index then
      return nil
    end
    local item = loopScroll:NewListViewItem("UICommonResItem")
    local script = self.rewardContent:GetComponent(item.gameObject.name, UICommonResItem)
    if script == nil then
      local name = "item_" .. index
      item.name = name
      script = self.rewardContent:AddComponent(UICommonResItem, name)
    end
    local rewardData = self.rewardDataList[index]
    script:ParseInfo(rewardData)
    script:SetActive(true)
    return item
  end
end

function UIBanquetFinRewardGetNewView:RefreshViewPacking()
  if self.activityId then
    local lineData = LocalController:instance():getLine(TableName.Activity, self.activityId)
    if lineData == nil then
      Logger.LogError("Activity GetTemplate lineData is nil id:" .. self.activityId)
      return nil
    end
    if string.IsNullOrEmpty(lineData.festival_interface_config) then
      self.commonActivityPopUpBgPart:SetDefaultPacking()
      return
    end
    self:ModifyPanelPacking(tonumber(lineData.festival_interface_config))
  else
    self.commonActivityPopUpBgPart:SetDefaultPacking()
  end
end

function UIBanquetFinRewardGetNewView:ModifyPanelPacking(festivalInterfaceCfgId)
  local lineData = LocalController:instance():getLine(TableName.Festival_Interface_Config, festivalInterfaceCfgId)
  if lineData == nil then
    Logger.LogError("Festival_Interface_Config GetTemplate lineData is nil id:" .. festivalInterfaceCfgId)
    return
  end
  local boardPageArr2 = string.split(lineData.board_page2, "|")
  if table.length(boardPageArr2) == 4 then
    local selectSpritePath = string.format(activityThemPath, boardPageArr2[1])
    local unSelectSpritePath = string.format(activityThemPath, boardPageArr2[2])
    self.table_area:LoadSprite(unSelectSpritePath)
    local selectWorldColorArr = string.split(boardPageArr2[3], ",")
    local unSelectWorldColorArr = string.split(boardPageArr2[4], ",")
    for i = 1, table.count(TabType) do
      local selectColor = Color.New(tonumber(selectWorldColorArr[1]) / 255, tonumber(selectWorldColorArr[2]) / 255, tonumber(selectWorldColorArr[3]) / 255, tonumber(selectWorldColorArr[4] / 255))
      local unSelectColor = Color.New(tonumber(unSelectWorldColorArr[1]) / 255, tonumber(unSelectWorldColorArr[2]) / 255, tonumber(unSelectWorldColorArr[3]) / 255, tonumber(unSelectWorldColorArr[4] / 255))
      self.tabList[i]:SetPacking(selectSpritePath, nil, selectColor, unSelectColor)
    end
  end
end

UIBanquetFinRewardGetNewView.OnCreate = OnCreate
UIBanquetFinRewardGetNewView.OnDestroy = OnDestroy
UIBanquetFinRewardGetNewView.OnEnable = OnEnable
UIBanquetFinRewardGetNewView.OnDisable = OnDisable
UIBanquetFinRewardGetNewView.ComponentDefine = ComponentDefine
UIBanquetFinRewardGetNewView.ComponentDestroy = ComponentDestroy
UIBanquetFinRewardGetNewView.DataDefine = DataDefine
UIBanquetFinRewardGetNewView.DataDestroy = DataDestroy
UIBanquetFinRewardGetNewView.OnAddListener = OnAddListener
UIBanquetFinRewardGetNewView.OnRemoveListener = OnRemoveListener
return UIBanquetFinRewardGetNewView
