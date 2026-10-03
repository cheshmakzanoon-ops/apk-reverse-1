local base = require("UI.UIActivityCenterTable.Component.ActivityContentBase")
local LeadingQuestMain = BaseClass("LeadingQuestMain", base)
local Localization = CS.GameEntry.Localization
local LeadingQuestItem = require("UI.UIActivityCenterTable.Component.LeadingTarget.LeadingQuestItem")
local title_path = "RightView/Top/title"
local subTitle_path = "RightView/Top/subTitle"
local activtyTime_path = "RightView/Top/actTime"
local remainTime_path = "RightView/Top/remainTime"
local svQuest_path = "RightView/Rect_Bottom/ScrollView"
local content_path = "RightView/Rect_Bottom/ScrollView/Viewport/Content"
local template_path = "templates(inactive)/LeadingQuestItem"
local bg1_path = "Bg1"
local bg2_path = "Bg1/Image (1)"
local activityDetailBtn_path = "RightView/Top/InfoBtn"

local function OnCreate(self)
  base.OnCreate(self)
  self:DataDefine()
  self:ComponentDefine()
end

local function OnDestroy(self)
  self:DelCountDownTimer()
  self:ComponentDestroy()
  self:DataDestroy()
  base.OnDestroy(self)
end

local function ComponentDefine(self)
  self.titleN = self:AddComponent(UIText, title_path)
  self.subTitleN = self:AddComponent(UIText, subTitle_path)
  self.activityTimeN = self:AddComponent(UIText, activtyTime_path)
  self.remainTimeN = self:AddComponent(UIText, remainTime_path)
  self.svQuestsN = self:AddComponent(UIScrollView, svQuest_path)
  self.svQuestsN:SetOnItemMoveIn(function(itemObj, index)
    self:OnQuestItemMoveIn(itemObj, index)
  end)
  self.svQuestsN:SetOnItemMoveOut(function(itemObj, index)
    self:OnQuestItemMoveOut(itemObj, index)
  end)
  self.contentN = self:AddComponent(UIBaseContainer, content_path)
  self.bg1N = self:AddComponent(UIImage, bg1_path)
  self.activityDetailBtn = self:AddComponent(UIButton, activityDetailBtn_path)
  self.activityDetailBtn:SetOnClick(function()
    local param = {}
    param.activityRulesStr = Localization:GetString(self.activityData.story)
    UIManager:GetInstance():OpenWindow(UIWindowNames.UIActivityDetail, {anim = true}, param)
  end)
end

local function ComponentDestroy(self)
  self.titleN = nil
  self.subTitleN = nil
  self.activityTimeN = nil
  self.remainTimeN = nil
  self.contentN = nil
  self.templateN = nil
  self.bg1N = nil
  self.activityDetailBtn = nil
end

local function DataDefine(self)
  self.activityId = nil
  self.activityData = nil
  self.CountDownTimerAction = nil
  self.countDownTimer = nil
end

local function DataDestroy(self)
  self.activityId = nil
  self.activityData = nil
  self.CountDownTimerAction = nil
  self.countDownTimer = nil
end

local function OnAddListener(self)
  base.OnAddListener(self)
  self:AddUIListener(EventId.OnClaimRewardEffFinish, self.ShowTasks)
end

local function OnRemoveListener(self)
  self:RemoveUIListener(EventId.OnClaimRewardEffFinish, self.ShowTasks)
  base.OnRemoveListener(self)
end

local function SetData(self, activityId)
  base.SetData(self, activityId)
  self.activityId = activityId
  if not self.activityId then
    return
  end
  self.activityData = DataCenter.ActivityListDataManager:GetActivityDataById(self.activityId)
  self:RefreshAll()
  CS.GameEntry.Setting:SetBool("OpenedLeadingQuestView_" .. LuaEntry.Player.uid, true)
  EventManager:GetInstance():BroadcastDeferred(EventId.RefreshActivityRedDot)
end

local function RefreshAll(self)
  self.titleN:SetText(Localization:GetString(self.activityData.name))
  self.subTitleN:SetText(Localization:GetString(self.activityData.desc_info))
  local startT = UITimeManager:GetInstance():TimeStampToDayForLocal(self.activityData.startTime)
  local endT = UITimeManager:GetInstance():TimeStampToDayForLocal(self.activityData.endTime)
  self.activityTimeN:SetText(startT .. "-" .. endT)
  self:AddCountDownTimer()
  self:RefreshRemainTime()
  self:ShowTasks()
end

local function GetTaskListSorted(self)
  if not self.activityData then
    return {}
  end
  local tasks = {}
  local taskGroups = self.activityData:GetTaskGroups()
  for i, taskList in ipairs(taskGroups) do
    for m, taskId in ipairs(taskList) do
      local taskInfo = DataCenter.TaskManager:FindTaskInfo(taskId)
      if not taskInfo or taskInfo.state == 1 or taskInfo.state == 0 or m == #taskList then
        table.insert(tasks, taskId)
        break
      end
    end
  end
  table.sort(tasks, function(a, b)
    local taskValueA = DataCenter.TaskManager:FindTaskInfo(a)
    local taskValueB = DataCenter.TaskManager:FindTaskInfo(b)
    if not taskValueA then
      return false
    elseif not taskValueB then
      return true
    elseif taskValueA.state ~= taskValueB.state then
      if taskValueA.state == 1 then
        return true
      elseif taskValueB.state == 1 then
        return false
      elseif taskValueA.state == 2 then
        return false
      elseif taskValueB.state == 2 then
        return true
      end
    else
      return tonumber(a) < tonumber(b)
    end
  end)
  return tasks
end

local function ShowTasks(self)
  self.taskList = self:GetTaskListSorted()
  if #self.taskList > 0 then
    self.svQuestsN:SetTotalCount(#self.taskList)
    self.svQuestsN:RefillCells()
  end
end

local function AddCountDownTimer(self)
  function self.CountDownTimerAction()
    self:RefreshRemainTime()
  end
  
  if self.countDownTimer == nil then
    self.countDownTimer = TimerManager:GetInstance():GetTimer(1, self.CountDownTimerAction, self, false, false, false)
  end
  self.countDownTimer:Start()
end

local function RefreshRemainTime(self)
  local curTime = UITimeManager:GetInstance():GetServerTime()
  local remainTime = self.activityData.endTime - curTime
  if 0 < remainTime then
    self.remainTimeN:SetText(UITimeManager:GetInstance():MilliSecondToFmtString(remainTime))
  else
    self.remainTimeN:SetText("")
    self:DelCountDownTimer()
  end
end

local function DelCountDownTimer(self)
  if self.countDownTimer ~= nil then
    self.countDownTimer:Stop()
    self.countDownTimer = nil
  end
end

local function OnQuestItemMoveIn(self, itemObj, index)
  itemObj.name = tostring(index)
  local cellItem = self.svQuestsN:AddComponent(LeadingQuestItem, itemObj)
  cellItem:SetItem(self.taskList[index], nil)
end

local function OnQuestItemMoveOut(self, itemObj, index)
  self.svQuestsN:RemoveComponent(itemObj.name, LeadingQuestItem)
end

local function ClearScroll(self)
  self.svQuestsN:ClearCells()
  self.svQuestsN:RemoveComponents(LeadingQuestItem)
end

LeadingQuestMain.OnCreate = OnCreate
LeadingQuestMain.OnDestroy = OnDestroy
LeadingQuestMain.ComponentDefine = ComponentDefine
LeadingQuestMain.ComponentDestroy = ComponentDestroy
LeadingQuestMain.DataDefine = DataDefine
LeadingQuestMain.DataDestroy = DataDestroy
LeadingQuestMain.OnAddListener = OnAddListener
LeadingQuestMain.OnRemoveListener = OnRemoveListener
LeadingQuestMain.SetData = SetData
LeadingQuestMain.RefreshAll = RefreshAll
LeadingQuestMain.ShowTasks = ShowTasks
LeadingQuestMain.AddCountDownTimer = AddCountDownTimer
LeadingQuestMain.RefreshRemainTime = RefreshRemainTime
LeadingQuestMain.DelCountDownTimer = DelCountDownTimer
LeadingQuestMain.GetTaskListSorted = GetTaskListSorted
LeadingQuestMain.OnQuestItemMoveIn = OnQuestItemMoveIn
LeadingQuestMain.OnQuestItemMoveOut = OnQuestItemMoveOut
LeadingQuestMain.ClearScroll = ClearScroll
return LeadingQuestMain
