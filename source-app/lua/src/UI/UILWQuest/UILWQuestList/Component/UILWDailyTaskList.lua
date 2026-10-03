local UILWDailyTaskList = BaseClass("UILWDailyTaskList", UIBaseContainer)
local base = UIBaseContainer
local UIGray = CS.UIGray
local Localization = CS.GameEntry.Localization
local UILWDailyTaskGoalItem = require("UI.UILWQuest.UILWQuestList.Component.UILWDailyTaskGoalItem")
local UILWDailyTaskItem = require("UI.UILWQuest.UILWQuestList.Component.UILWDailyTaskItem")
local countDownTextPath = "ProgressGo/RefreshTime/CountDownText"
local progressSliderPath = "ProgressGo/Progress/Slider"
local goalsPath = "ProgressGo/Progress/Goals/GoalItem%d"
local dailyTaskListPath = "TaskListScroll"
local dailyTaskListContentPath = "TaskListScroll/Viewport/Content"
local progressPointIconPath = "ProgressGo/Progress/PointIcon"
local progressPointNumTextPath = "ProgressGo/Progress/PointCountText"

function UILWDailyTaskList:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function UILWDailyTaskList:OnDestroy()
  self:ClearScroll()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UILWDailyTaskList:AddTimer()
  if self.timer == nil then
    self.timer = TimerManager:GetInstance():GetTimer(1, self.timer_action, self, false, false, false)
  end
  self.timer:Start()
end

function UILWDailyTaskList:RemoveTimer()
  if self.timer ~= nil then
    self.timer:Stop()
    self.timer = nil
  end
end

function UILWDailyTaskList:RefreshTime()
  local remainTime = UITimeManager:GetInstance():GetResSecondsTo24()
  self.countDownText:SetLocalText(2000273, UITimeManager:GetInstance():MilliSecondToFmtString(remainTime * 1000))
end

local function OnGetItemByIndex(self, loopScroll, index)
  index = index + 1
  if index < 1 or index > #self.dailyTaskDataList then
    return nil
  end
  local dailyTaskInfo = self.dailyTaskDataList[index]
  local item = loopScroll:NewListViewItem("UILWDailyTaskItem")
  local script = self.dailyTaskListContent:GetComponent(item.gameObject.name, UILWDailyTaskItem)
  if script == nil then
    local objectName = tostring(self.itemIndex)
    self.itemIndex = self.itemIndex + 1
    item.gameObject.name = objectName
    if not item.IsInitHandlerCalled then
      item.IsInitHandlerCalled = true
    end
    script = self.dailyTaskListContent:AddComponent(UILWDailyTaskItem, objectName)
  end
  script:SetActive(true)
  script:SetData(dailyTaskInfo, self.onPointRewardAnimFinishCallBack)
  return item
end

function UILWDailyTaskList:ComponentDefine()
  self.countDownText = self:AddComponent(UIText, countDownTextPath)
  self.progressSlider = self:AddComponent(UISlider, progressSliderPath)
  self.goals = {}
  for i = 1, 5 do
    self.goals[i] = self:AddComponent(UILWDailyTaskGoalItem, string.format(goalsPath, i))
  end
  self.dailyTaskList = self:AddComponent(UILoopListView2, dailyTaskListPath)
  self.dailyTaskList:InitListView(0, function(loopView, index)
    return OnGetItemByIndex(self, loopView, index)
  end)
  self.dailyTaskListContent = self:AddComponent(UIBaseContainer, dailyTaskListContentPath)
  self.progressPointIcon = self:AddComponent(UIImage, progressPointIconPath)
  self.progressPointNumText = self:AddComponent(UIText, progressPointNumTextPath)
end

function UILWDailyTaskList:ComponentDestroy()
  self.countDownText = nil
  self.progressSlider = nil
  self.goals = nil
  self.dailyTaskList = nil
  self.dailyTaskListContent = nil
  self.progressPointIcon = nil
  self.progressPointNumText = nil
end

function UILWDailyTaskList:DataDefine()
  self.dailyTaskDataList = {}
  self.itemIndex = 0
  self.onPointRewardAnimFinishCallBack = BindCallback(self, self.OnPointRewardAnimFinish)
  self.timer_action = BindCallback(self, self.RefreshTime)
  self.hasInitBox = false
  self.curPoint = 0
end

function UILWDailyTaskList:DataDestroy()
  self.dailyTaskDataList = nil
  self.onPointRewardAnimFinishCallBack = nil
  self.timer_action = nil
  self.hasInitBox = nil
end

function UILWDailyTaskList:OnEnable()
  base.OnEnable(self)
  self:AddTimer()
end

function UILWDailyTaskList:OnDisable()
  base.OnDisable(self)
  if self.progressTween then
    self.progressTween:Kill()
    self.progressTween = nil
  end
  self:RemoveTimer()
end

function UILWDailyTaskList:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.DailyQuestSuccess, self.OnDailyQuestSuccess)
  self:AddUIListener(EventId.DailyQuestLs, self.RefreshContent)
  self:AddUIListener(EventId.DailyQuestReward, self.RefreshContent)
end

function UILWDailyTaskList:OnRemoveListener()
  self:RemoveUIListener(EventId.DailyQuestSuccess, self.OnDailyQuestSuccess)
  self:RemoveUIListener(EventId.DailyQuestLs, self.RefreshContent)
  self:RemoveUIListener(EventId.DailyQuestReward, self.RefreshContent)
  base.OnRemoveListener(self)
end

function UILWDailyTaskList:RefreshProgress(showAnim)
  if self.progressTween then
    self.progressTween:Kill()
    self.progressTween = nil
  end
  if showAnim then
    local newPoint = DataCenter.DailyTaskManager:GetCurValue()
    local curPoint = self.curPoint
    local pointMax = DataCenter.DailyTaskManager:GetDailyMaxValue()
    if newPoint ~= curPoint then
      do
        local function OnProGet()
          return self.curPoint
        end
        
        local function OnProSet(x)
          local num = math.floor(x)
          self.curPoint = num
          if self.progressPointNumText then
            self.progressPointNumText:SetText(self.curPoint)
          end
          if self.progressSlider then
            local progerss = self.curPoint / pointMax
            self.progressSlider:SetValue(progerss)
          end
        end
        
        local firstUnCompleteBoxIndex = 0
        if not table.IsNullOrEmpty(self.goals) then
          for i = 1, table.count(self.goals) do
            local boxState = DataCenter.DailyTaskManager:GetBoxState(i, self.curPoint)
            if boxState == TaskState.NoComplete then
              firstUnCompleteBoxIndex = i
              break
            end
          end
        end
        
        local function Complete()
          self.curPoint = DataCenter.DailyTaskManager:GetCurValue()
          if not table.IsNullOrEmpty(self.goals) then
            for i = 1, table.count(self.goals) do
              local boxState = DataCenter.DailyTaskManager:GetBoxState(i, self.curPoint)
              if self.goals[i] then
                self.goals[i]:SetState(boxState)
              end
            end
            local recordBoxState = DataCenter.DailyTaskManager:GetBoxState(firstUnCompleteBoxIndex, self.curPoint)
            if self.goals[firstUnCompleteBoxIndex] and recordBoxState == TaskState.CanReceive then
              DataCenter.LWSoundManager:PlaySound(62300, false)
            end
          end
        end
        
        self.progressTween = DOTween.To(OnProGet, OnProSet, newPoint, 0.5):OnComplete(Complete)
      end
    end
  else
    local progress = DataCenter.DailyTaskManager:GetDailyProgress()
    self.progressSlider:SetValue(progress)
    self.curPoint = DataCenter.DailyTaskManager:GetCurValue()
    for i = 1, table.count(self.goals) do
      local boxState = DataCenter.DailyTaskManager:GetBoxState(i, self.curPoint)
      self.goals[i]:SetState(boxState)
    end
    self.progressPointNumText:SetText(self.curPoint)
  end
  self.hasInitProgress = true
end

function UILWDailyTaskList:OnDailyQuestSuccess()
  self:Refresh(false)
end

function UILWDailyTaskList:OnPointRewardAnimFinish()
  self:RefreshProgress(true)
end

function UILWDailyTaskList:Refresh(forceRefreshProgress)
  if not self.hasInitBox then
    for i = 1, table.count(self.goals) do
      local boxNeedValue = DataCenter.DailyTaskManager:GetDailyCurValue(i)
      self.goals[i]:SetData(i, boxNeedValue)
    end
    self.hasInitBox = true
  end
  if not self.hasInitProgress or forceRefreshProgress then
    self:RefreshProgress(false)
  else
    self:RefreshProgress(true)
  end
  self.dailyTaskDataList = DataCenter.DailyTaskManager:GetSortDailyTask()
  if self.dailyTaskDataList == nil or #self.dailyTaskDataList == 0 then
    self.dailyTaskList:SetActive(false)
    return
  end
  self.dailyTaskList:SetActive(true)
  self.dailyTaskList:SetListItemCount(#self.dailyTaskDataList, false, false)
  self.dailyTaskList:RefreshAllShownItem()
end

function UILWDailyTaskList:RefreshContent()
  self:Refresh(true)
end

function UILWDailyTaskList:ClearScroll()
  self.dailyTaskListContent:RemoveComponents(UILWDailyTaskItem)
  self.dailyTaskList:ClearAllItems()
end

function UILWDailyTaskList:GetRewardPointIconPos()
  if self.progressPointIcon ~= nil then
    return self.progressPointIcon.transform.position
  else
    return Vector3.zero
  end
end

return UILWDailyTaskList
