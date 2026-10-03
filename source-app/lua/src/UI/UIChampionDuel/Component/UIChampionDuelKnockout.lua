local UIChampionDuelKnockout = BaseClass("UIChampionDuelKnockout", UIBaseContainer)
local base = UIBaseContainer
local UICD_KnockoutDayTab = require("UI.UIChampionDuel.Component.Knockout.UICD_KnockoutDayTab")
local UICD_KnockoutCell = require("UI.UIChampionDuel.Component.Knockout.UICD_KnockoutCell")
local tab_day_path = "Days/DayScroll/Viewport/DayContent/tab"
local scroll_day_path = "Days/DayScroll"
local scroll_view_path = "ScrollView"
local content_path = "ScrollView/Viewport/Content"
local text_down_path = "DownText"
local MAX_DAY = 5

function UIChampionDuelKnockout:OnCreate()
  base.OnCreate(self)
  self.retryTime = 0
  local sTime, _ = DataCenter.ChampionDuelManager:GetStageTime(ChampionDuelState.KnockOut)
  self.sTime = sTime
  self.dayTime = 86400
  self.text_down = self:AddComponent(UIText, text_down_path)
  self.kCells = {}
  self.scrollView = self:AddComponent(UILoopListView2, scroll_view_path)
  self.scrollView:InitListView(0, function(listview, index)
    return self:TryGetScrollItem(listview, index)
  end)
  self.content = self:AddComponent(UIBaseContainer, content_path)
  self.scroll_day = self:AddComponent(UIScrollRect, scroll_day_path)
  self.dayTabs = {}
  self.curDay = 1
  local curSec = UITimeManager:GetInstance():GetServerSeconds()
  for i = 1, MAX_DAY do
    local path = tab_day_path .. i
    local cellItem = self:AddComponent(UICD_KnockoutDayTab, path)
    self.dayTabs[i] = cellItem
    local dayTime = self:GetDayTime(i)
    cellItem:ReInit(i, dayTime, BindCallback(self, self.OnTabClick))
    cellItem:SetActive(true)
    if curSec >= dayTime and curSec < dayTime + self.dayTime then
      self.curDay = i
    end
  end
end

function UIChampionDuelKnockout:OnDestroy()
  if self.timer then
    self.timer:Stop()
  end
  self.timer = nil
  self.retryTime = 0
  self.dayTabs = {}
  self.scroll_day = nil
  self.content:RemoveComponents(UICD_KnockoutCell)
  self.scrollView:ClearAllItems()
  self.kCells = {}
  self.content = nil
  self.scrollView = nil
  self.text_down = nil
  base.OnDestroy(self)
end

function UIChampionDuelKnockout:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.ChampionDuelFinalMatchListRefresh, self.RefreshList)
end

function UIChampionDuelKnockout:OnRemoveListener()
  self:RemoveUIListener(EventId.ChampionDuelFinalMatchListRefresh, self.RefreshList)
  base.OnRemoveListener(self)
end

function UIChampionDuelKnockout:Update1000MS()
end

function UIChampionDuelKnockout:ReInit()
  self.scrollView:SetListItemCount(0, false, false)
  self.scrollView:RefreshAllShownItem()
  DataCenter.ChampionDuelManager:ReqFinalMatchList()
  local tmpCurDay = DataCenter.ChampionDuelManager:GetFinalMatchMaxDay()
  if tmpCurDay > self.curDay then
    self.curDay = tmpCurDay
  end
  local curTab = self.dayTabs[self.curDay]
  if curTab then
    curTab:SetIsOn(true)
    self.scroll_day:SetHorizontalNormalizedPosition(self.curDay > 3 and 1 or 0)
  end
end

function UIChampionDuelKnockout:RefreshList()
  if self.curDay == MAX_DAY then
    local tmpList = {}
    for i = 1, 2 do
      local idx = self.curDay + 2 - i
      local groupList = DataCenter.ChampionDuelManager:GetFinalMatchListByGroup(idx) or {}
      table.insertto(tmpList, groupList)
    end
    self.list = tmpList
  else
    self.list = DataCenter.ChampionDuelManager:GetFinalMatchListByGroup(self.curDay) or {}
  end
  local cnt = #self.list
  self.scrollView:SetListItemCount(cnt, false, false)
  self.scrollView:RefreshAllShownItem()
  if cnt == 0 then
    if self.retryTime < 10 then
      local curTime = UITimeManager:GetInstance():GetServerTime()
      if self.timer then
        self.timer:Stop()
      end
      self.timer = TimerManager:GetInstance():DelayInvoke(function()
        if self.timer then
          self.timer:Stop()
        end
        self.timer = nil
        self.retryTime = self.retryTime + 1
        DataCenter.ChampionDuelManager:ReqFinalMatchList()
        self.lastGetInfoTime = curTime
      end, 3)
    end
  else
    self.retryTime = 0
  end
end

function UIChampionDuelKnockout:GetDayTime(index)
  local time = self.sTime + (index - 1) * self.dayTime
  return time
end

function UIChampionDuelKnockout:OnTabClick(index)
  local maxDay = DataCenter.ChampionDuelManager:GetFinalMatchMaxDay()
  if index > maxDay then
    local curTab = self.dayTabs[self.curDay]
    if curTab then
      curTab:SetIsOn(true)
    end
    UIUtil.ShowTipsId("champion_duel_tips1146")
    return
  end
  self.curDay = index
  self:RefreshList()
end

function UIChampionDuelKnockout:TryGetScrollItem(listview, index)
  local dataList = self.list
  if table.IsNullOrEmpty(dataList) then
    return nil
  end
  local len = #dataList
  local idx = index + 1
  if idx < 1 or len < idx then
    return nil
  end
  local csItem = listview:NewListViewItem("UICD_KnockoutCell")
  local item = self.kCells[csItem]
  if item == nil then
    local prefabIndex = self.prefabIndex or 0
    local nameStr = "Cell" .. prefabIndex
    self.prefabIndex = prefabIndex + 1
    csItem.gameObject.name = nameStr
    item = self.content:AddComponent(UICD_KnockoutCell, nameStr)
    self.kCells[csItem] = item
  end
  if item ~= nil then
    local group = dataList[idx]
    local spIndex = 0
    if self.curDay == MAX_DAY then
      spIndex = idx
    end
    item:ReInit(group, spIndex)
  end
  return csItem
end

return UIChampionDuelKnockout
