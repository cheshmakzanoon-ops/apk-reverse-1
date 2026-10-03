local UILWQuestListView = BaseClass("UILWQuestListView", UIBaseView)
local base = UIBaseView
local UIGray = CS.UIGray
local Localization = CS.GameEntry.Localization
local QuestList = require("UI.UILWQuest.UILWQuestList.Component.UILWQuestList")
local MainSubTaskList = require("UI.UILWQuest.UILWQuestList.Component.UILWMainSubTaskList")
local dailyTaskList = require("UI.UILWQuest.UILWQuestList.Component.UILWDailyTaskList")
local UILWDailyTaskItem = require("UI.UILWQuest.UILWQuestList.Component.UILWDailyTaskItem")
local UILWMainSeasonSubTaskListNew = require("UI.UILWQuest.UILWQuestList.Component.UILWMainSeasonSubTaskListNew")
local title_text_path = "Root/TopBar/TextTitle"
local return_btn_path = "Root/BottomBar/BtnBack"
local tab_content_path = "Root/MiddleContentContainer/TabHolder/TabContent/"
local quest_list_content_path = "Root/MiddleContentContainer/MissonListHolder"
local main_sub_task_holder_path = "Root/MiddleContentContainer/MainSubTaskHolder"
local daily_task_holder_path = "Root/MiddleContentContainer/DailyTaskHolder"
local new_season_sub_task_holder_path = "Root/MiddleContentContainer/NewSeasonSubTaskHolder"
local REQUEST_TITLE_TXT = "100179"

function UILWQuestListView:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
  local isCompleteAllChapter = DataCenter.ChapterTaskManager:IsCompleteAllChapter()
  if isCompleteAllChapter then
    self.questListContent:SetActive(false)
    self.main_sub_task_holder:SetActive(true)
  else
    self.questListContent:SetActive(true)
    self.main_sub_task_holder:SetActive(false)
  end
  local gotoPage = self:GetUserData()
  if gotoPage == UIQuestTab.Season and not SeasonUtil.SeasonTaskShowCondition() then
    gotoPage = nil
  end
  if gotoPage then
    self:OnTabClick(gotoPage)
  elseif isCompleteAllChapter then
    self:OnTabClick(UIQuestTab.Main)
  else
    self:OnTabClick(UIQuestTab.Chapter)
  end
end

function UILWQuestListView:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UILWQuestListView:ComponentDefine()
  self.closeBtn = self:AddComponent(UIButton, return_btn_path)
  self.closeBtn:SetOnClick(function()
    self.ctrl:CloseSelf()
  end)
  self.titleText = self:AddComponent(UIText, title_text_path)
  self.tabSelectGo = {}
  self.tabTitleTxt = {}
  self.tabClickBtn = {}
  self.tabRedPointBg = {}
  self.tabRedPointNumText = {}
  for i = 1, #UIQuestShowTab do
    local tab_path = tab_content_path .. "TabItem" .. i
    self.tabSelectGo[i] = self:AddComponent(UIBaseContainer, tab_path .. "/Condition" .. i .. "Select")
    self.tabTitleTxt[i] = self:AddComponent(UIText, tab_path .. "/Condition" .. i .. "Txt")
    self.tabClickBtn[i] = self:AddComponent(UIButton, tab_path)
    self.tabClickBtn[i]:SetOnClick(function()
      self:OnTabClick(UIQuestShowTab[i])
    end)
    self.tabRedPointBg[i] = self:AddComponent(UIImage, string.format("%s/RedPointBg%d", tab_path, i))
    self.tabRedPointNumText[i] = self:AddComponent(UIText, string.format("%s/RedPointBg%d/RedPointText%d", tab_path, i, i))
  end
  self.questListContent = self:AddComponent(QuestList, quest_list_content_path)
  self.titleText:SetLocalText(REQUEST_TITLE_TXT)
  for i = 1, #UIQuestShowTab do
    self.tabTitleTxt[i]:SetLocalText(UIQuestTabTitle[UIQuestShowTab[i]])
  end
  if DataCenter.ChapterTaskManager:IsCompleteAllChapter() then
    self.tabClickBtn[UIQuestTab.Chapter]:SetActive(false)
    self.tabClickBtn[UIQuestTab.Main]:SetActive(true)
  else
    self.tabClickBtn[UIQuestTab.Chapter]:SetActive(true)
    self.tabClickBtn[UIQuestTab.Main]:SetActive(false)
  end
  self.tabClickBtn[UIQuestTab.Season]:SetActive(SeasonUtil.SeasonTaskShowCondition())
  self.main_sub_task_holder = self:AddComponent(MainSubTaskList, main_sub_task_holder_path)
  self.new_season_sub_task_holder = self:AddComponent(UILWMainSeasonSubTaskListNew, new_season_sub_task_holder_path)
  self.dailyTaskHolder = self:AddComponent(dailyTaskList, daily_task_holder_path)
  self.taskListTabs = {
    [UIQuestTab.Chapter] = self.questListContent,
    [UIQuestTab.Main] = self.main_sub_task_holder,
    [UIQuestTab.Season] = self.new_season_sub_task_holder,
    [UIQuestTab.Daily] = self.dailyTaskHolder
  }
end

function UILWQuestListView:TryStartGuide()
  local selectedTabIndex = self.ctrl:GetCurrentTab()
  if selectedTabIndex ~= UIQuestTab.Daily then
    return
  end
  if CommonUtil.PlayerPrefsGetInt("TryStartGuide_quest" .. selectedTabIndex, 0) == 1 then
    return
  end
  CommonUtil.PlayerPrefsSetInt("TryStartGuide_quest" .. selectedTabIndex, 1)
  EventManager:GetInstance():Broadcast(EventId.PlayPlotGroup, {plotGroupId = 2727, hideMainUI = false})
end

function UILWQuestListView:PlotGroupDone(plotId)
  if plotId == 2727 then
    self.plot2727 = true
    local param = {}
    local item = self.dailyTaskHolder.dailyTaskList:GetShownItemByItemIndex(0)
    item = self.dailyTaskHolder.dailyTaskListContent:GetComponent(item.gameObject.name, UILWDailyTaskItem)
    param.position = item.goBtn.transform.position + Vector3.New(0, -18, 0)
    param.textKey = "newbies_guide_task_tips3"
    param.scale = Vector3.New(1, 1, 1)
    UIManager:GetInstance():OpenWindow(UIWindowNames.UIArrowFinger_New, {anim = true}, param)
  end
end

function UILWQuestListView:CloseArrow(uiname)
  if not self.plot2727 then
    return
  end
  if uiname ~= UIWindowNames.UIArrowFinger_New then
    return
  end
  local selectedTabIndex = self.ctrl:GetCurrentTab()
  if selectedTabIndex == 3 then
    if CommonUtil.PlayerPrefsGetInt("TryStartGuide_plot2728", 0) == 1 then
      return
    end
    CommonUtil.PlayerPrefsSetInt("TryStartGuide_plot2728", 1)
    EventManager:GetInstance():Broadcast(EventId.PlayPlotGroup, {plotGroupId = 2728, hideMainUI = false})
  end
end

function UILWQuestListView:ComponentDestroy()
  self.closeBtn = nil
  self.titleText = nil
  for i = 1, #UIQuestShowTab do
    if self.tabSelectGo[i] then
      self.tabSelectGo[i] = nil
    end
    if self.tabTitleTxt[i] then
      self.tabTitleTxt[i] = nil
    end
    if self.tabClickBtn[i] then
      self.tabClickBtn[i] = nil
    end
  end
  self.tabSelectGo = nil
  self.tabTitleTxt = nil
  self.tabClickBtn = nil
  self.tabRedPointBg = nil
  self.tabRedPointNumText = nil
  self.questListContent = nil
  self.main_sub_task_holder = nil
  self.new_season_sub_task_holder = nil
  self.dailyTaskHolder = nil
  self.taskListTabs = nil
end

function UILWQuestListView:DataDefine()
  self.ctrl:InitData()
  self.dailyQuestUnlock = false
end

function UILWQuestListView:DataDestroy()
  self.ctrl:ClearData()
end

function UILWQuestListView:OnEnable()
  base.OnEnable(self)
  self.dailyQuestUnlock = DataCenter.LWFunctionUnlockManager:CheckCanShow(LWFunctionUnlockType.Daily_Quest)
  if self.dailyQuestUnlock then
    self.tabClickBtn[UIQuestTab.Daily]:SetActive(true)
  else
    self.tabClickBtn[UIQuestTab.Daily]:SetActive(false)
  end
  self:InitRedPoints()
end

function UILWQuestListView:OnDisable()
  base.OnDisable(self)
end

function UILWQuestListView:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.DailyQuestSuccess, self.RefreshDailyTaskRedPoint)
  self:AddUIListener(EventId.DailyQuestLs, self.RefreshDailyTaskRedPoint)
  self:AddUIListener(EventId.DailyQuestReward, self.RefreshDailyTaskRedPoint)
end

function UILWQuestListView:OnRemoveListener()
  base.OnRemoveListener(self)
  self:RemoveUIListener(EventId.DailyQuestSuccess, self.RefreshDailyTaskRedPoint)
  self:RemoveUIListener(EventId.DailyQuestLs, self.RefreshDailyTaskRedPoint)
  self:RemoveUIListener(EventId.DailyQuestReward, self.RefreshDailyTaskRedPoint)
end

function UILWQuestListView:ChapterTask()
  self.tabClickBtn[UIQuestTab.Chapter]:SetActive(false)
  self.tabClickBtn[UIQuestTab.Main]:SetActive(true)
  self:OnTabClick(UIQuestTab.Main)
end

function UILWQuestListView:OnTabClick(tab)
  self.ctrl:SetCurrentTab(tab)
  for i = 1, #UIQuestShowTab do
    self.tabSelectGo[i]:SetActive(i == tab)
    self.tabTitleTxt[i].transform:Set_localPosition(0, i == tab and 0 or -2, 0)
  end
  self:OpenQuestList()
end

function UILWQuestListView:OpenQuestList()
  local selectedTabIndex = self.ctrl:GetCurrentTab()
  for i = 1, table.count(UIQuestTab) do
    self.taskListTabs[i]:SetActive(false)
  end
  if selectedTabIndex and self.taskListTabs[selectedTabIndex] then
    self.taskListTabs[selectedTabIndex]:SetActive(true)
    self.taskListTabs[selectedTabIndex]:RefreshContent()
  end
end

function UILWQuestListView:MainSubTaskUpdate()
  if self.main_sub_task_holder:GetActive() then
    self.main_sub_task_holder:RefreshContent()
  end
  if self.new_season_sub_task_holder:GetActive() then
    self.new_season_sub_task_holder:RefreshContent()
  end
end

function UILWQuestListView:ContentTrans()
  if self.questListContent:GetActive() then
    self.questListContent:RefreshContent()
  end
end

function UILWQuestListView:RefreshDailyTaskRedPoint()
  local redNum = DataCenter.DailyTaskManager:GetRedNum()
  self.tabRedPointBg[UIQuestTab.Daily]:SetActive(0 < redNum)
  self.tabRedPointNumText[UIQuestTab.Daily]:SetText(redNum)
end

function UILWQuestListView:InitRedPoints()
  self:RefreshDailyTaskRedPoint()
end

function UILWQuestListView:GetDailyQuestPointIconPos()
  if self.dailyTaskHolder then
    return self.dailyTaskHolder:GetRewardPointIconPos()
  else
    return Vector3.zero
  end
end

return UILWQuestListView
