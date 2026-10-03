local LWSeasonBossLoginTaskView = BaseClass("LWSeasonBossLoginTaskView", UIBaseView)
local base = UIBaseView
local UIGray = CS.UIGray
local Localization = CS.GameEntry.Localization
local LWSeasonBossLoginTaskItem = require("UI.LWSeason1.LWSeasonBossLoginTask.Component.LWSeasonBossLoginTaskItem")
local LWSeasonBossLoginRecordTabItemRender = require("UI.LWSeason1.LWSeasonBossLoginRecord.Component.LWSeasonBossLoginRecordTabItemRender")
local panel_path = "panel"
local dialog_title_text_path = "PopUpTitle/Common_img_title/titleText"
local close_btn_path = "PopUpTitle/CloseBtn"
local reward_item_path = "PopUpTitle/Common_bg_orange2/RewardItem"
local cell_path = "PopUpTitle/Common_bg_orange2/cell"
local content_path = "PopUpTitle/Common_bg_orange2/ScrollView/Viewport/Content"
local tab_scroll_view_path = "PopUpTitle/Common_bg_orange2/TopContent/TabScrollView"
local scroll_view_path = "PopUpTitle/Common_bg_orange2/ScrollView"

function LWSeasonBossLoginTaskView:OnCreate()
  base.OnCreate(self)
  local param = self:GetUserData()
  self.param = param
  self:ComponentDefine()
  self:DataDefine()
  self:ReInit()
end

function LWSeasonBossLoginTaskView:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function LWSeasonBossLoginTaskView:DataDefine()
  self.tabViewDataList = {}
  self.tabViewItemRenderDict = {}
end

function LWSeasonBossLoginTaskView:DataDestroy()
  self.curTabIndex = nil
  self.tabViewDataList = nil
  self.tabViewItemRenderDict = nil
end

function LWSeasonBossLoginTaskView:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.OnActBossRankRefresh, self.Refresh)
  self:AddUIListener(EventId.SeasonVirusBossReddot, self.RefreshReddot)
end

function LWSeasonBossLoginTaskView:OnRemoveListener()
  self:RemoveUIListener(EventId.OnActBossRankRefresh, self.Refresh)
  self:RemoveUIListener(EventId.SeasonVirusBossReddot, self.RefreshReddot)
  base.OnRemoveListener(self)
end

function LWSeasonBossLoginTaskView:ComponentDefine()
  self.dialog_title_text = self:AddComponent(UIText, dialog_title_text_path)
  self.close_btn = self:AddComponent(UIButton, close_btn_path)
  self.dialog_title_text:SetLocalText("456065")
  self.close_btn:SetOnClick(BindCallback(self.ctrl, self.ctrl.CloseSelf))
  self.close_btn1 = self:AddComponent(UIButton, panel_path)
  self.close_btn1:SetOnClick(BindCallback(self.ctrl, self.ctrl.CloseSelf))
  self.content = self:AddComponent(UIBaseContainer, content_path)
  self.scrollView = self:AddComponent(UIScrollView, scroll_view_path)
  self.tabScrollView = self:AddComponent(UIScrollView, tab_scroll_view_path)
  self.tabScrollView:SetOnItemMoveIn(function(itemObj, index)
    self:OnTabItemMoveIn(itemObj, index)
  end)
  self.tabScrollView:SetOnItemMoveOut(function(itemObj, index)
    self:OnTabItemMoveOut(itemObj, index)
  end)
  self.scrollCellPool = {}
  self.itemIndex = 1
  self.scrollView:SetOnItemMoveIn(function(itemObj, index)
    self:OnItemMoveIn(itemObj, index)
  end)
  self.scrollView:SetOnItemMoveOut(function(itemObj, index)
    self:OnItemMoveOut(itemObj, index)
  end)
end

function LWSeasonBossLoginTaskView:ComponentDestroy()
  self.param = nil
  self.fakeIndex = nil
  self.showDatalist = nil
  self:RemoveTabScroll()
  self.tabScrollView = nil
  self:ClearScroll()
  self.btn_back = nil
end

function LWSeasonBossLoginTaskView:ReInit()
  self:GetTabViewData()
  self:OnTabItemClick(self.curTabIndex or 1)
  self:ShowTabView()
end

function LWSeasonBossLoginTaskView:Refresh()
  self:RefreshTaskData()
  if self.showDatalist and #self.showDatalist > 0 then
    self.scrollView:SetActive(true)
    self.scrollView:SetTotalCount(#self.showDatalist)
    self.scrollView:RefillCells()
  else
    self.scrollView:SetActive(false)
  end
  self:RefreshReddot()
end

function LWSeasonBossLoginTaskView:OnItemMoveIn(itemObj, index)
  local item = self.scrollCellPool[itemObj.name]
  if not item then
    local name = tostring(self.itemIndex)
    itemObj.name = name
    item = self.scrollView:AddComponent(LWSeasonBossLoginTaskItem, itemObj)
    self.scrollCellPool[name] = item
    self.itemIndex = self.itemIndex + 1
  end
  local data = self.showDatalist[index]
  if self.fakeIndex and self.fakeIndex == index then
    item:ReInit(self.curTabIndex, self.param, data.id, data, true)
  else
    item:ReInit(self.curTabIndex, self.param, data.id, data, false)
  end
end

function LWSeasonBossLoginTaskView:OnItemMoveOut(itemObj, index)
end

function LWSeasonBossLoginTaskView:ClearScroll()
  self.scrollView:ClearCells()
  self.scrollView:RemoveComponents(LWSeasonBossLoginTaskItem)
  self.scrollCellPool = {}
  self.itemIndex = 1
  self.showDatalist = {}
end

function LWSeasonBossLoginTaskView:RefreshTaskData()
  if self.curTabIndex == 1 then
    self.showDatalist = DataCenter.LWSeasonBossLoginDataManager:GetAttackInfoRewards()
    return
  end
  local taskList, showHighDamage
  if self.curTabIndex == 2 then
    taskList = DataCenter.ActBossDataManager.AchievementTaskData
    showHighDamage = DataCenter.ActBossDataManager:GetMaxDamageShow()
  elseif self.curTabIndex == 3 then
    taskList = DataCenter.LWSeasonBossLoginDataManager.AchievementTaskData
    showHighDamage = DataCenter.LWSeasonBossLoginDataManager:GetMaxDamageShow()
  end
  if taskList == nil then
    return
  end
  local sortTask = {}
  local fakeTaskInfo
  for _, v in ipairs(taskList) do
    if v.reward and (showHighDamage == 0 or showHighDamage >= v.damage) then
      if self.curTabIndex == 2 then
        if DataCenter.ActBossDataManager:JudgeAchievementTaskIsValid(v.id) then
          table.insert(sortTask, v)
        elseif fakeTaskInfo == nil or v.damageShowTime < fakeTaskInfo.damageShowTime then
          fakeTaskInfo = v
        end
      elseif DataCenter.LWSeasonBossLoginDataManager:JudgeAchievementTaskIsValid(v.id) then
        table.insert(sortTask, v)
      elseif fakeTaskInfo == nil or v.damageShowTime < fakeTaskInfo.damageShowTime then
        fakeTaskInfo = v
      end
    end
  end
  local order = {
    [TaskState.CanReceive] = 1,
    [TaskState.NoComplete] = 2,
    [TaskState.Received] = 3
  }
  table.sort(sortTask, function(a, b)
    if a.state == nil or b.state == nil then
      return false
    end
    if a.state ~= b.state then
      return (order[a.state] or 5) < (order[b.state] or 5)
    else
      return a.damage < b.damage
    end
  end)
  if fakeTaskInfo then
    local insertIndex = 1
    for i, v in ipairs(sortTask) do
      if v.state == TaskState.Received then
        insertIndex = i
        break
      end
    end
    table.insert(sortTask, insertIndex, fakeTaskInfo)
    self.fakeIndex = insertIndex
  else
    self.fakeIndex = nil
  end
  self.showDatalist = sortTask
end

function LWSeasonBossLoginTaskView:GetTabViewData()
  if table.count(self.tabViewDataList) == 0 then
    local actBoss, seasonBoss = DataCenter.LWSeasonBossLoginDataManager:GetBossData()
    table.insert(self.tabViewDataList, {
      id = 1,
      title = "activity_s1pre_boss_reward_tab_limit_4"
    })
    if actBoss ~= nil then
      local bossName = GetTableData(LuaEntry.Player:GetABTestTableName(TableName.Monster), actBoss.monsterId, "name")
      table.insert(self.tabViewDataList, {
        id = 2,
        title = bossName,
        bossData = actBoss
      })
    end
    if seasonBoss ~= nil then
      local bossName = GetTableData(LuaEntry.Player:GetABTestTableName(TableName.Monster), seasonBoss.monsterId, "name")
      table.insert(self.tabViewDataList, {
        id = 3,
        title = bossName,
        bossData = seasonBoss
      })
    end
  end
end

function LWSeasonBossLoginTaskView:ShowTabView()
  self:RemoveTabScroll()
  local tabCount = table.count(self.tabViewDataList)
  if 0 < tabCount then
    self.tabScrollView:SetTotalCount(tabCount)
    self.tabScrollView:RefillCells()
  end
end

function LWSeasonBossLoginTaskView:OnTabItemClick(index)
  if self.curTabIndex == index then
    return
  end
  self.curTabIndex = index
  self:ClearScroll()
  self:Refresh()
end

function LWSeasonBossLoginTaskView:RemoveTabScroll()
  self.tabScrollView:ClearCells()
  self.tabScrollView:RemoveComponents(LWSeasonBossLoginRecordTabItemRender)
end

function LWSeasonBossLoginTaskView:OnTabItemMoveIn(itemObj, index)
  itemObj.name = tostring(index)
  local itemRender = self.tabScrollView:AddComponent(LWSeasonBossLoginRecordTabItemRender, itemObj)
  if itemRender ~= nil then
    itemRender:InitData(index, self.tabViewDataList[index], self.curTabIndex)
    local id = self.tabViewDataList[index].id
    self.tabViewItemRenderDict[id] = itemRender
    if id == 1 then
      itemRender:SetReddot(DataCenter.LWSeasonBossLoginDataManager:GetShowRankReddot())
    elseif id == 2 then
      itemRender:SetReddot(DataCenter.ActBossDataManager:CanShowTaskReddot())
    elseif id == 3 then
      itemRender:SetReddot(DataCenter.LWSeasonBossLoginDataManager:CanShowTaskReddot())
    end
  end
end

function LWSeasonBossLoginTaskView:OnTabItemMoveOut(itemObj, index)
  self.tabScrollView:RemoveComponent(itemObj.name, LWSeasonBossLoginRecordTabItemRender)
end

function LWSeasonBossLoginTaskView:RefreshReddot()
  if self.tabViewItemRenderDict == nil then
    return
  end
  for id, v in pairs(self.tabViewItemRenderDict) do
    if id == 1 then
      v:SetReddot(DataCenter.LWSeasonBossLoginDataManager:GetShowRankReddot())
    elseif id == 2 then
      v:SetReddot(DataCenter.ActBossDataManager:CanShowTaskReddot())
    elseif id == 3 then
      v:SetReddot(DataCenter.LWSeasonBossLoginDataManager:CanShowTaskReddot())
    end
  end
end

return LWSeasonBossLoginTaskView
