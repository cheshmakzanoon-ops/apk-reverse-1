local base = UIBaseView
local UILWCommonRecordLogView = BaseClass("UILWCommonRecordLogView", base)
local UILWCommonRecordLogItem = require("UI.UILWCommonRecordLog.Component.UILWCommonRecordLogItem")
local closeBtnN_path = "safeArea/BottomBar/BtnBack"
local titleN_path = "safeArea/TopBar/TextTitle"
local svTaskN_path = "safeArea/MiddleContentContainer/Scroll_View_mainView"
local no_log_txt_path = "safeArea/MiddleContentContainer/noLogTxt"
local scrollViewContent_path = "safeArea/MiddleContentContainer/Scroll_View_mainView/MainViewport/MainContent"

local function OnCreate(self)
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
  self.panelType = self:GetUserData()
  self.firstEnter = true
  if self.panelType == CommonRecordPanelType.SeasonRewardRecord then
    DataCenter.SeasonAllianceRankDataManager:RequestSeasonLootReward()
  end
  self:RefreshAll()
end

local function OnDestroy(self)
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

local function ComponentDefine(self)
  self.closeBtnN = self:AddComponent(UIButton, closeBtnN_path)
  self.titleN = self:AddComponent(UIText, titleN_path)
  self.svTaskN = self:AddComponent(UILoopListView2, svTaskN_path)
  self.no_log_txt = self:AddComponent(UIText, no_log_txt_path)
  self.scrollViewContent = self:AddComponent(UIBaseContainer, scrollViewContent_path)
  self.closeBtnN:SetOnClick(function()
    self.ctrl:CloseSelf()
  end)
  self.titleN:SetLocalText(456210)
  self.svTaskN:InitListViewParam2(0, function(listview, index)
    return self:OnGetItemByIndex(listview, index)
  end, nil, nil, function(loopListViewItem)
    self:OnRecycleItemFunc(loopListViewItem)
  end)
end

local function ComponentDestroy(self)
  self.scrollViewContent:RemoveComponents(UILWCommonRecordLogItem)
  self.closeBtnN = nil
  self.titleN = nil
  self.svTaskN = nil
  self.no_log_txt = nil
  self.scrollViewContent = nil
end

local function DataDefine(self)
  self._recordItemObjList = {}
end

local function DataDestroy(self)
  self.svTaskN:RecycleAllItem()
  self._recordItemObjList = nil
end

function UILWCommonRecordLogView:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.LWSeasonAllianceLootRewardInfoUpate, self.RefreshAll)
end

function UILWCommonRecordLogView:OnRemoveListener()
  self:RemoveUIListener(EventId.LWSeasonAllianceLootRewardInfoUpate, self.RefreshAll)
  base.OnRemoveListener(self)
end

function UILWCommonRecordLogView:RefreshAll()
  self.logList = {}
  if self.panelType == CommonRecordPanelType.SeasonRewardRecord then
    self.logList = DataCenter.SeasonAllianceRankDataManager:GetLootRewardLogList()
  end
  if self.logList and #self.logList > 0 then
    self.svTaskN:SetActive(true)
    self.no_log_txt:SetActive(false)
    self:RefreshScrollView()
  else
    if self.panelType == CommonRecordPanelType.SeasonRewardRecord then
      self.no_log_txt:SetLocalText("season_tips138")
    else
      self.no_log_txt:SetLocalText(456221)
    end
    self.no_log_txt:SetActive(true)
    self.svTaskN:SetActive(false)
  end
end

function UILWCommonRecordLogView:RefreshScrollView()
  self.svTaskN:SetListItemCount(self:GetItemCount(), self.firstEnter, false)
  self.svTaskN:RefreshAllShownItem()
  if self.firstEnter then
    self.svTaskN:MovePanelToItemIndex(0, 0)
  end
  self.firstEnter = not self.firstEnter
end

function UILWCommonRecordLogView:GetItemCount()
  if self.logList == nil then
    return 0
  end
  return table.length(self.logList)
end

function UILWCommonRecordLogView:OnGetItemByIndex(listView, index)
  if index < 0 or index > self:GetItemCount() + 1 then
    return nil
  end
  local item
  self.prefabIndex = self.prefabIndex or 0
  local prefabName = self:GetRecordItemPrefabName()
  item = listView:NewListViewItem(prefabName)
  if item == nil then
    return nil
  end
  if self._recordItemObjList[item] ~= nil then
    self._recordItemObjList[item]:SetActive(true)
    self._recordItemObjList[item]:SetItem(self.logList[index + 1], index + 1)
  else
    local recordItemScript = self:GetRecordItemScriptName()
    if recordItemScript == nil then
      Logger.LogError(">>>> recordItemScript prefab - " .. tostring(prefabName))
      return
    end
    local objectName = prefabName .. "_" .. tostring(self.prefabIndex) .. "_" .. tostring(index)
    item.gameObject.name = tostring(objectName)
    self.prefabIndex = self.prefabIndex + 1
    local temp = self.scrollViewContent:AddComponent(recordItemScript, item.gameObject)
    temp:SetActive(true)
    temp:SetItem(self.logList[index + 1], index + 1)
    self._recordItemObjList[item] = temp
  end
  return item
end

function UILWCommonRecordLogView:OnRecycleItemFunc(loopListViewItem)
  if loopListViewItem == nil then
    return
  end
  local script = self._recordItemObjList[loopListViewItem]
  if script ~= nil then
    script:SetActive(false)
  end
end

function UILWCommonRecordLogView:UpdateLoadingTip(loadItem)
  if loadItem == nil then
    return
  end
  loadItem.gameObject:SetActive(false)
end

function UILWCommonRecordLogView:GetRecordItemPrefabName()
  if self.panelType == CommonRecordPanelType.SeasonRewardRecord then
    return "UILWCommonRecordLogItem"
  end
end

function UILWCommonRecordLogView:GetRecordItemScriptName()
  if self.panelType == CommonRecordPanelType.SeasonRewardRecord then
    return UILWCommonRecordLogItem
  end
end

UILWCommonRecordLogView.OnCreate = OnCreate
UILWCommonRecordLogView.OnDestroy = OnDestroy
UILWCommonRecordLogView.ComponentDefine = ComponentDefine
UILWCommonRecordLogView.ComponentDestroy = ComponentDestroy
UILWCommonRecordLogView.DataDefine = DataDefine
UILWCommonRecordLogView.DataDestroy = DataDestroy
return UILWCommonRecordLogView
