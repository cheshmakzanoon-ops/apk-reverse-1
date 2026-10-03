local ChapterTaskManager = BaseClass("ChapterTaskManager")
local Localization = CS.GameEntry.Localization
local RewardUtil = require("Util.RewardUtil")

local function __init(self)
  self.chapterId = 0
  self.chapterSubTaskArray = {}
  self.rewardList = {}
  self.canReceiveList = {}
  self.isTaskCompleteNew = false
  self.rewardGetType = {}
  self.isChapterReward = false
  self.subTasks = {}
  self.taskState = ""
end

local function __delete(self)
  self.chapterId = nil
  self.chapterSubTaskArray = nil
  self.rewardList = nil
  self.canReceiveList = {}
  self.isTaskCompleteNew = nil
  self.rewardGetType = nil
  self.isChapterReward = nil
  self.subTasks = nil
  self.taskState = nil
  if self.delayTimer then
    self.delayTimer:Stop()
    self.delayTimer = nil
  end
end

local function InitData(self, message)
  if message.chapterTask ~= nil then
    self:UpdateChapterTask(message.chapterTask)
  end
end

local function UpdateChapterTask(self, message)
  if message ~= nil then
    local chapterTask = message.chapterTask
    self.rewardList = {}
    if chapterTask ~= nil then
      if chapterTask.chapterid ~= nil then
        self.chapterId = chapterTask.chapterid
      end
      if chapterTask.reward ~= nil then
        self.rewardList = DataCenter.RewardManager:ReturnRewardParamForView(chapterTask.reward)
      end
      if chapterTask.subTasks ~= nil then
        self.subTasks = string.split(chapterTask.subTasks, "|")
      end
      if chapterTask.state ~= nil then
        self.taskState = chapterTask.state
      end
    end
    self.chapterSubTaskArray = {}
    if message.chapterSubTaskArray ~= nil then
      for k, v in pairs(message.chapterSubTaskArray) do
        self:UpdateOneChapterSubTaskInfo(v)
      end
    end
  end
end

local function UpdateOneChapterSubTaskInfo(self, message)
  if message ~= nil then
    local id = message.id
    local one = self:FindTaskInfo(id)
    if one == nil then
      one = ChapterTaskInfo.New()
      one:UpdateInfo(message)
      self.chapterSubTaskArray[id] = one
    else
      one:UpdateInfo(message)
    end
  end
end

local function CheckIsSuccess(self, questId)
  local data = self:FindTaskInfo(tostring(questId))
  if data then
    if data.state == TaskState.NoComplete then
      return false
    else
      return true
    end
  else
    local chapterId = DataCenter.ChapterTemplateManager:GetQuestTemplate(questId)
    if chapterId then
      local curId = self:GetCurChapterId()
      if chapterId < curId then
        return true
      elseif chapterId > curId then
        return false
      end
    else
      return false
    end
  end
end

local function FindTaskInfo(self, id)
  return self.chapterSubTaskArray[id]
end

local function GetAllChapterTask(self)
  local result = {}
  for k, v in pairs(self.chapterSubTaskArray) do
    local template = DataCenter.QuestTemplateManager:GetQuestTemplate(k)
    if v.state ~= TaskState.Received and template ~= nil then
      table.insert(result, v)
    end
  end
  table.sort(result, self.SortTask)
  local chapter_task = {
    isChapter = true,
    state = self.taskState or "",
    rewardList = self.rewardList or {}
  }
  table.insert(result, chapter_task)
  return result
end

local function GetChapterTaskType(self, type)
  local data = self:GetAllChapterTask()
  for i = 1, #data do
    if type == data[i].listType then
      local template = DataCenter.QuestTemplateManager:GetQuestTemplate(data[i].id)
      if template and template.questPre ~= "" then
        local taskInfo = self:FindTaskInfo(template.questPre)
        if taskInfo and taskInfo.state == TaskState.Received then
          return data[i]
        end
      else
        return data[i]
      end
    end
  end
  return nil
end

local function GetCurChapterAllType(self)
  local data = self:GetAllChapterTask()
  local type = {}
  local list = {}
  for i = 1, #data do
    type[data[i].listType] = true
  end
  for i, v in pairs(type) do
    table.insert(list, i)
  end
  table.sort(list, function(a, b)
    if a < b then
      return true
    end
    return false
  end)
  if not next(list) then
    local allNum = self:GetAllNum()
    local completeNum = self:GetCompleteNum()
    local num = self:GetCurChapterId()
    if allNum <= completeNum and num ~= 0 then
      list = {1}
      return list
    end
  end
  return list
end

local function SetCurTaskGuidShow(self)
  local taskData = self:GetChapterTaskType(1)
  if taskData then
    local questTemplate = DataCenter.QuestTemplateManager:GetQuestTemplate(taskData.id)
    if questTemplate then
      if self:GetCurChapterId() == 1 then
        if self:GetCompleteNum() ~= 0 then
          questTemplate:SetGuidShow()
        end
      else
        questTemplate:SetGuidShow()
      end
    end
  end
end

local function SortChapterByData(self, list)
  local result = {}
  local successtask = {}
  for i = 1, #list do
    local template = DataCenter.QuestTemplateManager:GetQuestTemplate(tonumber(list[i].id))
    if list[i].state ~= TaskState.Received then
      if template ~= nil then
        table.insert(result, list[i])
      end
    elseif template ~= nil then
      table.insert(successtask, list[i])
    end
  end
  table.sort(result, self.SortTask)
  if next(successtask) then
    table.sort(successtask, function(a, b)
      if tonumber(a.id) < tonumber(b.id) then
        return true
      end
      return false
    end)
    for i = 1, table.length(successtask) do
      table.insert(result, successtask[i])
    end
  end
  return result
end

local function SortTask(a, b)
  local task1 = DataCenter.QuestTemplateManager:GetQuestTemplate(a.id)
  local task2 = DataCenter.QuestTemplateManager:GetQuestTemplate(b.id)
  if task1 == nil then
    return false
  elseif task2 == nil then
    return true
  elseif a.state > b.state then
    return true
  elseif a.state < b.state then
    return false
  elseif task1.order < task2.order then
    return true
  end
  return false
end

local function PushTaskChapterTaskHandle(self, message)
  self:UpdateChapterTask(message)
  local isRefresh = true
  local list = DataCenter.ChapterTaskManager:GetCanReceivedList()
  if next(list) then
    self.isTaskCompleteNew = true
  end
  if isRefresh then
    EventManager:GetInstance():Broadcast(EventId.ChapterTask, 2)
  end
  if list ~= nil then
    for k, v in ipairs(list) do
      DataCenter.GuideManager:CheckDoTriggerGuide(GuideTriggerType.TaskFinish, tostring(v))
    end
  end
end

local function TaskRewardGetHandle(self, message)
  if message.errorCode ~= nil then
    local errorCode = message.errorCode
    if errorCode ~= SeverErrorCode then
      UIUtil.ShowTips(Localization:GetString(message.errorCode))
    end
  else
    if message.chapterTasks then
      for i = 1, #message.chapterTasks do
        self:UpdateOneChapterSubTaskInfo(message.chapterTasks[i])
      end
    end
    if self:ReceiveOneTask(message.taskId) then
      if message.reward ~= nil then
        DataCenter.RewardManager:AddRewardsAndRes(message)
      end
      self.isTaskCompleteNew = true
      EventManager:GetInstance():Broadcast(EventId.ChapterTask, 1)
      EventManager:GetInstance():Broadcast(EventId.QuestRewardSuccess, message.taskId)
      EventManager:GetInstance():Broadcast(EventId.GF_quest_rewarded, message.taskId)
    end
  end
end

local function GetCompleteNum(self)
  local result = 0
  if self.chapterSubTaskArray ~= nil then
    for k, v in pairs(self.chapterSubTaskArray) do
      if v.state == TaskState.Received then
        result = result + 1
      end
    end
  end
  return result
end

local function GetAllNum(self)
  local result = 0
  if self.subTasks ~= nil then
    result = table.count(self.subTasks)
  end
  return result
end

local function IsCompleteAllChapter(self)
  local haveCompleteNum = self:GetCompleteNum()
  local allNum = self:GetAllNum()
  local MaxChapterId = LuaEntry.DataConfig:TryGetNum("maxnum_mainquest", "k3")
  local ret = self:GetCurChapterId() == MaxChapterId and haveCompleteNum >= allNum and self.taskState ~= "0" or self.chapterId == 0 and allNum == 0
  if not ret then
    local lastCharpterT = self:GetFirstChapterTask()
    if lastCharpterT and lastCharpterT.isChapter then
      local taskState = lastCharpterT.state
      if haveCompleteNum >= allNum and taskState == "0" then
        ret = false
      else
        ret = true
      end
    end
  end
  return ret
end

local function ReceiveOneTask(self, id)
  local task = self:FindTaskInfo(id)
  if task ~= nil then
    task.state = TaskState.Received
    DataCenter.TaskManager:AddOneTaskWhenDelete(task)
    return true
  end
  return false
end

local function ChapterTaskHandle(self, message)
  if message.errorCode ~= nil then
    local errorCode = message.errorCode
    if errorCode ~= SeverErrorCode then
      UIUtil.ShowTips(Localization:GetString(message.errorCode))
    end
  elseif message.result then
    DataCenter.RewardManager:AddRewardsAndRes(message)
    self:UpdateChapterTask(message)
    DataCenter.RewardManager:ShowCommonReward(message)
    self.isTaskCompleteNew = true
    local chapterId = self:GetCurChapterId()
    if chapterId ~= nil then
      if message.hasNextChapter then
        EventManager:GetInstance():Broadcast(EventId.ChapterTaskGetReward, chapterId - 1)
      else
        EventManager:GetInstance():Broadcast(EventId.ChapterTaskGetReward, chapterId)
      end
    end
    EventManager:GetInstance():Broadcast(EventId.ChapterTask, 3)
  end
end

local function GetChapterReward(self)
  return self.rewardList
end

local function GetRedDotNum(self)
  local result = 0
  if self.chapterSubTaskArray ~= nil then
    for k, v in pairs(self.chapterSubTaskArray) do
      if v.state == TaskState.CanReceive then
        result = result + 1
      end
    end
  end
  if self:GetCompleteNum() >= self:GetAllNum() then
    result = result + 1
  end
  return result
end

local function GetCurChapterId(self)
  return tonumber(self.chapterId)
end

local function GetCanReceivedList(self)
  local result = {}
  if self.chapterSubTaskArray ~= nil then
    for k, v in pairs(self.chapterSubTaskArray) do
      if v.state == TaskState.CanReceive then
        table.insert(result, v.id)
        if not self.canReceiveList[v.id] then
          local param = {}
          param.id = v.id
          param.isSend = false
          self.canReceiveList[v.id] = param
        end
      end
    end
  end
  return result
end

local function SetCompleteNew(self)
  self.isTaskCompleteNew = false
end

local function SetRewardGetType(self, type, isMain)
  if isMain then
    if type - 100 < 1000 then
      self.rewardGetType[type] = type
    else
      self.rewardGetType[type - 100] = type
    end
  elseif type - 100 < 0 then
    self.rewardGetType[type] = type
  else
    self.rewardGetType[type - 100] = type
  end
end

local function GetRewardGetType(self, type)
  if self.rewardGetType[type] then
    return self.rewardGetType[type]
  else
    return nil
  end
end

local function SetCurQuestState(self, type)
  self.isChapterReward = type
end

local function GetCurQuestState(self)
  return self.isChapterReward
end

local function GetFirstChapterTask(self)
  local all_sort_chapters = self:GetAllChapterTask()
  return all_sort_chapters[1]
end

local function QuestGoto(self, taskData)
  local template = DataCenter.QuestTemplateManager:GetQuestTemplate(taskData.id)
  if template then
    GoToUtil.CloseAllWindows()
    GoToUtil.GoToByQuestId(template)
  end
end

local function QuestGetReward(self, taskData, rewardPos)
  if taskData.rewardList ~= nil then
    for i, v in ipairs(taskData.rewardList) do
      local rewardType = v.rewardType
      local itemId = v.itemId
      local pic = RewardUtil.GetPic(rewardType, itemId)
      if pic ~= "" then
        local resourceType = RewardToResType[rewardType]
        local flyEndPos
        if resourceType ~= nil then
          flyEndPos = UIUtil.GetResourcePos(resourceType)
        end
        if flyEndPos == nil then
          flyEndPos = Vector3.New(0, 0, 0)
        end
        UIUtil.DoFly(tonumber(rewardType), 3, pic, rewardPos, flyEndPos, nil, nil, nil, nil, 1)
      end
    end
  end
  local params = {
    id = taskData.id
  }
  SFSNetwork.SendMessage(MsgDefines.TaskRewardGet, params)
end

local function ChapterGetReward(self)
  local param = {
    chapterId = tostring(DataCenter.ChapterTaskManager.chapterId)
  }
  SFSNetwork.SendMessage(MsgDefines.ChapterTask, param)
end

local function GetTaskState(self)
  return self.taskState
end

local function GetTaskInfos(self, infos)
  local strIcon = "Assets/Main/Sprites/UI/UIMain/LWMainUINew/cfm_zhujiemian_tubiao_renwu.png"
  local strDesc = ""
  local template = DataCenter.QuestTemplateManager:GetQuestTemplate(infos.id)
  if template then
    strIcon = template:GetIconPath()
    strDesc = strDesc .. (template:GetDesc() or "")
    local strProgress = ""
    if tonumber(template.progressshow) == 1 then
      local num = math.min(infos.num, template.para2)
      strProgress = string.format(" (%d/%d)", num, template.para2)
    end
    strDesc = strDesc .. strProgress
  end
  local is_finish = infos.state == TaskState.CanReceive
  local rewardList = infos.rewardList
  local taskInfos = {
    strIcon = strIcon,
    strDesc = strDesc,
    is_finish = is_finish,
    rewardList = rewardList
  }
  return taskInfos
end

local function GetAllChapterRewardsByRes(self, resType)
  if resType == nil then
    return
  end
  local total = 0
  local all_sort_chapters = self:GetAllChapterTask()
  table.walk(all_sort_chapters, function(_, infos)
    total = total + self:GetChapterRewardsByRes(resType, infos)
  end)
  return total
end

local function GetChapterRewardsByRes(self, resType, infos)
  if infos then
    local isChapter = infos.isChapter
    if isChapter then
      local taskState = infos.state
      local allNum = DataCenter.ChapterTaskManager:GetAllNum()
      local completeNum = DataCenter.ChapterTaskManager:GetCompleteNum()
      if allNum <= completeNum and taskState == "0" then
        return self:GetChapterRewardByRes(resType, infos)
      end
    else
      local taskinfos = DataCenter.ChapterTaskManager:GetTaskInfos(infos)
      if taskinfos.is_finish then
        return self:GetChapterRewardByRes(resType, infos)
      else
        return 0
      end
    end
  end
  return 0
end

local function GetChapterRewardByRes(self, resType, infos)
  local rewardList = infos.rewardList
  local value = 0
  table.walk(rewardList, function(_, reward)
    if reward.rewardType == RewardType.METAL and resType == ResourceType.Metal or reward.rewardType == RewardType.WOOD and resType == ResourceType.Wood or reward.rewardType == RewardType.FOOD and resType == ResourceType.Food or reward.rewardType == RewardType.FLINT and resType == ResourceType.FLINT or reward.rewardType == RewardType.OBSIDIAN and resType == ResourceType.OBSIDIAN then
      value = reward.count
    end
  end)
  return value
end

ChapterTaskManager.__init = __init
ChapterTaskManager.__delete = __delete
ChapterTaskManager.InitData = InitData
ChapterTaskManager.PushTaskChapterTaskHandle = PushTaskChapterTaskHandle
ChapterTaskManager.UpdateChapterTask = UpdateChapterTask
ChapterTaskManager.FindTaskInfo = FindTaskInfo
ChapterTaskManager.GetAllChapterTask = GetAllChapterTask
ChapterTaskManager.SortChapterByData = SortChapterByData
ChapterTaskManager.SortTask = SortTask
ChapterTaskManager.TaskRewardGetHandle = TaskRewardGetHandle
ChapterTaskManager.UpdateOneChapterSubTaskInfo = UpdateOneChapterSubTaskInfo
ChapterTaskManager.CheckIsSuccess = CheckIsSuccess
ChapterTaskManager.IsCompleteAllChapter = IsCompleteAllChapter
ChapterTaskManager.GetCompleteNum = GetCompleteNum
ChapterTaskManager.GetAllNum = GetAllNum
ChapterTaskManager.ReceiveOneTask = ReceiveOneTask
ChapterTaskManager.ChapterTaskHandle = ChapterTaskHandle
ChapterTaskManager.GetChapterReward = GetChapterReward
ChapterTaskManager.GetRedDotNum = GetRedDotNum
ChapterTaskManager.GetCurChapterId = GetCurChapterId
ChapterTaskManager.GetCanReceivedList = GetCanReceivedList
ChapterTaskManager.SetCompleteNew = SetCompleteNew
ChapterTaskManager.GetChapterTaskType = GetChapterTaskType
ChapterTaskManager.GetCurChapterAllType = GetCurChapterAllType
ChapterTaskManager.SetRewardGetType = SetRewardGetType
ChapterTaskManager.GetRewardGetType = GetRewardGetType
ChapterTaskManager.SetCurTaskGuidShow = SetCurTaskGuidShow
ChapterTaskManager.SetCurQuestState = SetCurQuestState
ChapterTaskManager.GetCurQuestState = GetCurQuestState
ChapterTaskManager.GetFirstChapterTask = GetFirstChapterTask
ChapterTaskManager.QuestGoto = QuestGoto
ChapterTaskManager.QuestGetReward = QuestGetReward
ChapterTaskManager.ChapterGetReward = ChapterGetReward
ChapterTaskManager.GetTaskState = GetTaskState
ChapterTaskManager.GetTaskInfos = GetTaskInfos
ChapterTaskManager.GetAllChapterRewardsByRes = GetAllChapterRewardsByRes
ChapterTaskManager.GetChapterRewardsByRes = GetChapterRewardsByRes
ChapterTaskManager.GetChapterRewardByRes = GetChapterRewardByRes
return ChapterTaskManager
