local TaskManager = BaseClass("TaskManager")
local Localization = CS.GameEntry.Localization
local WarnList = 9999

local function __init(self)
  self.allTask = {}
  self.isTaskCompleteNew = false
  self.taskMsgIsShowType = false
  self.actViewTimeDic = nil
  self.curTaskIndex = 0
  self.pveTask = {}
  self.pveRewardGetType = {}
  self.completeValue = false
end

local function __delete(self)
  self.allTask = nil
  self.isTaskCompleteNew = nil
  self.taskMsgIsShowType = nil
  self.actViewTimeDic = nil
  self.curTaskIndex = nil
  self.pveTask = nil
  self.pveRewardGetType = nil
  self.completeValue = nil
end

local function InitData(self, message)
  local taskList = message.task
  if taskList ~= nil then
    self.allTask = {}
    for k, v in pairs(taskList) do
      self:UpdateOneTaskInfo(v, true)
    end
  end
  DataCenter.NpcTaskBubbleManager:StartUp()
  self:InitPVETask()
end

local function InitPVETask(self)
  self.pveTask = {}
  if self.allTask then
    local mgr = DataCenter.QuestTemplateManager
    for i, v in pairs(self.allTask) do
      local template = mgr:GetQuestTemplate(i)
      if template == nil then
      elseif template.type == QuestType.PVE then
        self.pveTask[i] = v
      end
    end
  end
end

local function GetBubbleTask(self)
  local result = {}
  if self.allTask then
    local mgr = DataCenter.QuestTemplateManager
    for i, v in pairs(self.allTask) do
      local template = mgr:GetQuestTemplate(i)
      if template == nil then
      elseif template.bubble == QuestBubbleType.World and v.state ~= TaskState.Received then
        table.insert(result, v)
      end
    end
  end
  table.sort(result, self.SortBubbleTask)
  return result
end

local function SortBubbleTask(a, b)
  local mgr = DataCenter.QuestTemplateManager
  local task1 = mgr:GetQuestTemplate(a.id)
  local task2 = mgr:GetQuestTemplate(b.id)
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

local function GetCurBubbleTaskType(self)
  local data = self:GetBubbleTask()
  local type = {}
  local list = {}
  local mgr = DataCenter.QuestTemplateManager
  for i = 1, #data do
    local task = mgr:GetQuestTemplate(data[i].id)
    type[task.list] = true
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
  return list
end

local function GetBubbleTaskByType(self, type)
  local data = self:GetBubbleTask()
  local mgr = DataCenter.QuestTemplateManager
  for i = 1, #data do
    local template = mgr:GetQuestTemplate(data[i].id)
    if type == tonumber(template.list) then
      if template.questPre ~= "" then
        local taskInfo = self:FindTaskInfo(template.questPre)
        if taskInfo then
          if taskInfo.state == TaskState.Received then
            return data[i]
          end
        else
          return data[i]
        end
      else
        return data[i]
      end
    end
  end
  return nil
end

local function UpdateOneTaskInfo(self, message, fromInit)
  if message ~= nil and message.id ~= nil then
    local mgr = DataCenter.QuestTemplateManager
    local id = message.id
    local one = self:FindTaskInfo(id)
    local template = mgr:GetQuestTemplate(id)
    local need_update_build = false
    local need_show_tips = false
    local numOld = 0
    local numNew = 0
    if one == nil then
      one = TaskInfo.New()
      one:UpdateInfo(message)
      self.allTask[id] = one
      if template == nil then
      else
        need_update_build = not fromInit
        need_show_tips = false
        if template.type == QuestType.PVE then
          self.pveTask[id] = one
        end
      end
    else
      numOld = one.num
      one:UpdateInfo(message)
      numNew = one.num
      need_update_build = numOld < numNew
      need_show_tips = not fromInit
    end
    if template ~= nil and template.type2 ~= nil and template.accept2 ~= nil then
      local listType = toInt(template.listType)
      local type2 = toInt(template.type2)
      if need_update_build and (type2 == 517 or type2 == 555 or type2 == 396 and listType == 3) then
        local seasonType = SeasonUtil.GetSeasonType()
        local buildId = toInt(template.accept2)
        if need_show_tips and one ~= nil then
          local need, max, meta = one:GetTaskProgress()
          if meta then
            local msg = string.format("%s (%s/%s)", Localization:GetString(meta.desc, ""), need, max)
            UIUtil.ShowTips(msg)
          end
        end
        if 0 < buildId then
          local buildData = DataCenter.BuildManager:GetFunbuildByItemID(buildId)
          if buildData ~= nil and buildData.uuid ~= nil then
            DataCenter.BuildBubbleManager:CheckShowBubble(buildData.uuid)
          end
        end
        if seasonType == SeasonMapType.Darkness then
          EventManager:GetInstance():Broadcast(EventId.PowerWorkerTaskUpdated, {
            taskId = id,
            num_old = numOld,
            num_new = numNew
          })
        elseif seasonType == SeasonMapType.NineNation and type2 == 396 and listType == 3 then
          for i = 1, 10 do
            local theId = 820000 + i * 1000
            local buildData = DataCenter.BuildManager:GetFunbuildByItemID(theId)
            if buildData ~= nil and buildData.uuid ~= nil then
              DataCenter.BuildBubbleManager:CheckShowBubble(buildData.uuid)
            end
          end
        end
      end
    end
  end
end

local function FindTaskInfo(self, id)
  if id ~= nil and id ~= 0 and id ~= "" then
    return self.allTask[tostring(id)]
  end
  return nil
end

local function GetAllMainTask(self)
  local listTask = {}
  local canReceiveList = {}
  local noCompleteList = {}
  local template
  local mgr = DataCenter.QuestTemplateManager
  for k, v in pairs(self.allTask) do
    if v.state == TaskState.CanReceive then
      template = mgr:GetQuestTemplate(k)
      if template == nil then
      end
      if template ~= nil and template.order > 0 and template.type == QuestType.Main then
        local temp = {}
        temp.data = v
        temp.order = template.order
        temp.list = template.list
        table.insert(canReceiveList, temp)
      end
    elseif v.state == TaskState.NoComplete then
      template = mgr:GetQuestTemplate(k)
      if template == nil then
      end
      if template ~= nil and template.order > 0 and template.type == QuestType.Main then
        local temp = {}
        temp.data = v
        temp.order = template.order
        temp.list = template.list
        local keyName = template.list
        if keyName ~= nil and keyName ~= "" then
          if listTask[keyName] == nil then
            listTask[keyName] = temp
          elseif listTask[keyName].order > temp.order then
            listTask[keyName] = temp
          end
        else
          table.insert(noCompleteList, temp)
        end
      end
    end
  end
  for i, v in pairs(listTask) do
    table.insert(noCompleteList, v)
  end
  local result = {}
  table.sort(canReceiveList, self.GetAllSortTask)
  local canRecMaxNum = self:GetCanRecQuestShowMaxNum()
  local curCanRecNum = 0
  for k, v in ipairs(canReceiveList) do
    if canRecMaxNum > curCanRecNum then
      curCanRecNum = curCanRecNum + 1
      table.insert(result, v.data)
    else
      break
    end
  end
  table.sort(noCompleteList, self.GetAllSortTask)
  local curNoCompleteMaxNum = 0
  local noCompleteMaxNum = self:GetNoCompleteQuestShowMaxNum()
  for k, v in ipairs(noCompleteList) do
    if curNoCompleteMaxNum < noCompleteMaxNum then
      curNoCompleteMaxNum = curNoCompleteMaxNum + 1
      table.insert(result, v.data)
    else
      break
    end
  end
  local listMain = {}
  local listSide = {}
  for i = 1, #result do
    local templateQ = mgr:GetQuestTemplate(result[i].id)
    if templateQ.listType == 0 then
      table.insert(listMain, result[i])
    elseif templateQ.listType == 1 then
      table.insert(listSide, result[i])
    end
  end
  for i = 1, #listSide do
    table.insert(listMain, listSide[i])
  end
  return listMain
end

function TaskManager:GetSeasonVirusTask()
  local listTask = {}
  local canReceiveList = {}
  local noCompleteList = {}
  local template
  local mgr = DataCenter.QuestTemplateManager
  for k, v in pairs(self.allTask) do
    if v.state == TaskState.CanReceive then
      template = mgr:GetQuestTemplate(k)
      if template ~= nil and template.order > 0 and template.type == QuestType.Main and template.listType == 2 then
        local temp = {}
        temp.data = v
        temp.order = template.order
        temp.list = toInt(template.list)
        temp.meta = template
        table.insert(canReceiveList, temp)
      end
    elseif v.state == TaskState.NoComplete then
      template = mgr:GetQuestTemplate(k)
      if template ~= nil and template.order > 0 and template.type == QuestType.Main and template.listType == 2 then
        local temp = {}
        temp.data = v
        temp.order = template.order
        temp.list = toInt(template.list)
        temp.meta = template
        local keyName = template.list
        if keyName ~= nil and keyName ~= "" then
          if listTask[keyName] == nil then
            listTask[keyName] = temp
          elseif listTask[keyName].order > temp.order then
            listTask[keyName] = temp
          end
        else
          table.insert(noCompleteList, temp)
        end
      end
    end
  end
  for i, v in pairs(listTask) do
    table.insert(noCompleteList, v)
  end
  table.sort(canReceiveList, self.GetAllSortTask)
  table.sort(noCompleteList, self.GetAllSortTask)
  return table.mergeArray(canReceiveList, noCompleteList)
end

function TaskManager:GetSeasonVirusTaskFinishCount()
  local count = 0
  local mgr = DataCenter.QuestTemplateManager
  for k, v in pairs(self.allTask) do
    if v.state == TaskState.CanReceive then
      local template = mgr:GetQuestTemplate(k)
      if template ~= nil and 0 < template.order and template.type == QuestType.Main and template.listType == 2 then
        count = count + 1
      end
    end
  end
  return count
end

local function GetAllMainTaskForView(self, seasonCondition)
  local canReceiveList = {}
  local noCompleteList = {}
  local canReceiveListSub = {}
  local noCompleteListSub = {}
  local template
  local mgr = DataCenter.QuestTemplateManager
  local season = SeasonUtil.GetSeason()
  for k, v in pairs(self.allTask) do
    template = mgr:GetQuestTemplate(k)
    local flag = true
    if template ~= nil then
      if seasonCondition then
        if template.seasonTask then
          if not template:CheckSeason(season) then
            flag = false
          end
        else
          flag = false
        end
      else
        flag = not template.seasonTask
      end
    end
    if flag then
      if v.state == TaskState.CanReceive then
        if template == nil then
        end
        if template ~= nil and template.order > 0 and template.type == QuestType.Main then
          local temp = {}
          temp.data = v
          temp.order = template.order
          temp.list = template.list
          if template.listType == 0 then
            table.insert(canReceiveList, temp)
          elseif template.listType == 1 then
            table.insert(canReceiveListSub, temp)
          end
        end
      else
        if template == nil then
        end
        if v.state == TaskState.NoComplete and template ~= nil and template.order > 0 and template.type == QuestType.Main then
          local temp = {}
          temp.data = v
          temp.order = template.order
          temp.list = template.list
          if template.listType == 0 then
            table.insert(noCompleteList, temp)
          elseif template.listType == 1 then
            table.insert(noCompleteListSub, temp)
          end
        end
      end
    end
  end
  local retMainTask
  if 0 < #canReceiveList then
    table.sort(canReceiveList, self.GetAllSortTaskByOrderId)
    retMainTask = canReceiveList[1].data
  elseif 0 < #noCompleteList then
    table.sort(noCompleteList, self.GetAllSortTaskByOrderId)
    retMainTask = noCompleteList[1].data
  end
  local result = {}
  table.sort(canReceiveListSub, self.GetAllSortTaskByOrderId)
  local canRecMaxNum = self:GetCanRecQuestShowMaxNum()
  if seasonCondition and CS.CommonUtils.IsDebug() then
    canRecMaxNum = 999
  end
  local curCanRecNum = 0
  for k, v in ipairs(canReceiveListSub) do
    if canRecMaxNum > curCanRecNum then
      curCanRecNum = curCanRecNum + 1
      table.insert(result, v.data)
    else
      break
    end
  end
  table.sort(noCompleteListSub, self.GetAllSortTaskByOrderId)
  local curNoCompleteMaxNum = 0
  local noCompleteMaxNum = self:GetNoCompleteQuestShowMaxNum()
  if seasonCondition and CS.CommonUtils.IsDebug() then
    noCompleteMaxNum = 999
  end
  for k, v in ipairs(noCompleteListSub) do
    if curNoCompleteMaxNum < noCompleteMaxNum then
      curNoCompleteMaxNum = curNoCompleteMaxNum + 1
      table.insert(result, v.data)
    else
      break
    end
  end
  Logger.Log(string.format("canRecMaxNum: %d, noCompleteMaxNum: %d, canReceiveListSubCount: %d, noCompleteListSubCount: %d", canRecMaxNum, noCompleteMaxNum, #canReceiveListSub, #noCompleteListSub))
  return retMainTask, result
end

local function GetMainCountTaskForView(self, mainCount, seasonCondition)
  local canReceiveList = {}
  local noCompleteList = {}
  local canReceiveListSub = {}
  local noCompleteListSub = {}
  local template
  local mgr = DataCenter.QuestTemplateManager
  local season = SeasonUtil.GetSeason()
  for k, v in pairs(self.allTask) do
    template = mgr:GetQuestTemplate(k)
    local flag = true
    if seasonCondition then
      if template and template.seasonTask then
        if not template:CheckSeason(season) then
          flag = false
        end
      else
        flag = false
      end
    elseif template then
      flag = not template.seasonTask
    end
    if flag then
      if v.state == TaskState.CanReceive then
        if template == nil then
        end
        if template ~= nil and template.order > 0 and template.type == QuestType.Main then
          local temp = {}
          temp.data = v
          temp.order = template.order
          temp.list = template.list
          if template.listType == 0 then
            table.insert(canReceiveList, temp)
          elseif template.listType == 1 then
            table.insert(canReceiveListSub, temp)
          end
        end
      else
        if template == nil then
        end
        if v.state == TaskState.NoComplete and template ~= nil and template.order > 0 and template.type == QuestType.Main then
          local temp = {}
          temp.data = v
          temp.order = template.order
          temp.list = template.list
          if template.listType == 0 then
            table.insert(noCompleteList, temp)
          elseif template.listType == 1 then
            table.insert(noCompleteListSub, temp)
          end
        end
      end
    end
  end
  local mainResult = {}
  local mainTaskCount = 0
  table.sort(canReceiveList, self.GetAllSortTaskByOrderId)
  for k, v in ipairs(canReceiveList) do
    if mainCount > mainTaskCount then
      mainTaskCount = mainTaskCount + 1
      table.insert(mainResult, v.data)
    else
      break
    end
  end
  if mainCount > mainTaskCount then
    table.sort(noCompleteList, self.GetAllSortTaskByOrderId)
    for k, v in ipairs(noCompleteList) do
      if mainCount > mainTaskCount then
        mainTaskCount = mainTaskCount + 1
        table.insert(mainResult, v.data)
      else
        break
      end
    end
  end
  local result = {}
  table.sort(canReceiveListSub, self.GetAllSortTaskByOrderId)
  local canRecMaxNum = self:GetCanRecQuestShowMaxNum()
  if seasonCondition and CS.CommonUtils.IsDebug() then
    canRecMaxNum = 999
  end
  local curCanRecNum = 0
  for k, v in ipairs(canReceiveListSub) do
    if canRecMaxNum > curCanRecNum then
      curCanRecNum = curCanRecNum + 1
      table.insert(result, v.data)
    else
      break
    end
  end
  table.sort(noCompleteListSub, self.GetAllSortTaskByOrderId)
  local curNoCompleteMaxNum = 0
  local noCompleteMaxNum = self:GetNoCompleteQuestShowMaxNum()
  if seasonCondition and CS.CommonUtils.IsDebug() then
    noCompleteMaxNum = 999
  end
  for k, v in ipairs(noCompleteListSub) do
    if curNoCompleteMaxNum < noCompleteMaxNum then
      curNoCompleteMaxNum = curNoCompleteMaxNum + 1
      table.insert(result, v.data)
    else
      break
    end
  end
  Logger.Log(string.format("canRecMaxNum: %d, noCompleteMaxNum: %d, canReceiveListSubCount: %d, noCompleteListSubCount: %d", canRecMaxNum, noCompleteMaxNum, #canReceiveListSub, #noCompleteListSub))
  return mainResult, result
end

local function GetOneMainTaskForMainUI(self)
  local canReceiveList = {}
  local noCompleteList = {}
  local template
  local curSeasonId = SeasonUtil.GetSeason()
  local mgr = DataCenter.QuestTemplateManager
  local isInSeason = SeasonUtil.SeasonTaskShowCondition()
  for k, v in pairs(self.allTask) do
    if v.state == TaskState.CanReceive then
      template = mgr:GetQuestTemplate(k)
      if template == nil then
      end
      if template then
        local flag = true
        if isInSeason then
          flag = template:CheckSeason(curSeasonId)
        else
          flag = not template.seasonTask
        end
        if flag and template ~= nil and template.order > 0 and template.type == QuestType.Main and template.listType ~= 3 then
          local temp = {}
          temp.data = v
          temp.order = template.order
          temp.list = template.list
          temp.seasonTask = template.seasonTask
          table.insert(canReceiveList, temp)
        end
      end
    elseif v.state == TaskState.NoComplete then
      template = mgr:GetQuestTemplate(k)
      if template then
        local flag = true
        if isInSeason then
          flag = template:CheckSeason(SeasonUtil.GetSeason())
        else
          flag = not template.seasonTask
        end
        if flag and template ~= nil and template.order > 0 and template.type == QuestType.Main and template.listType ~= 3 then
          local temp = {}
          temp.data = v
          temp.order = template.order
          temp.list = template.list
          temp.seasonTask = template.seasonTask
          table.insert(noCompleteList, temp)
        end
      end
    end
  end
  local result = {}
  if isInSeason then
    table.sort(canReceiveList, self.GetAllSortTaskByOrderIdWithSeason)
  else
    table.sort(canReceiveList, self.GetAllSortTaskByOrderId)
  end
  if 0 < #canReceiveList then
    return canReceiveList[1].data
  end
  if isInSeason then
    table.sort(noCompleteList, self.GetAllSortTaskByOrderIdWithSeason)
  else
    table.sort(noCompleteList, self.GetAllSortTaskByOrderId)
  end
  local curNoCompleteMaxNum = 0
  local noCompleteMaxNum = 1
  for k, v in ipairs(noCompleteList) do
    if curNoCompleteMaxNum < noCompleteMaxNum then
      curNoCompleteMaxNum = curNoCompleteMaxNum + 1
      table.insert(result, v.data)
    else
      break
    end
  end
  local listMain = {}
  local listSide = {}
  for i = 1, #result do
    local templateQ = mgr:GetQuestTemplate(result[i].id)
    if templateQ.listType == 0 then
      table.insert(listMain, result[i])
    elseif templateQ.listType == 1 then
      table.insert(listSide, result[i])
    end
  end
  for i = 1, #listSide do
    table.insert(listMain, listSide[i])
  end
  if 0 < #listMain then
    return listMain[1]
  end
  return nil
end

function TaskManager:CheckIsSeasonTaskCanReceive()
  if SeasonUtil.SeasonTaskShowCondition() then
    local mgr = DataCenter.QuestTemplateManager
    local curSeasonId = SeasonUtil.GetSeason()
    for k, v in pairs(self.allTask) do
      if v.state == TaskState.CanReceive then
        local template = mgr:GetQuestTemplate(k)
        if template ~= nil and template.order > 0 and template.type == QuestType.Main and template.seasonTask and template:CheckSeason(curSeasonId) then
          return true
        end
      end
    end
  end
  return false
end

function TaskManager:IsInS1AndHasSeasonMainTaskNotReceive()
  if SeasonUtil.GetSeasonType() == SeasonMapType.CityStronghold then
    local checkSeason = 1
    local mgr = DataCenter.QuestTemplateManager
    for k, v in pairs(self.allTask) do
      if TaskState.NoComplete <= v.state and v.state < TaskState.Received then
        local template = mgr:GetQuestTemplate(k)
        if template ~= nil and template.order > 0 and template.type == QuestType.Main and template.seasonTask and template:CheckSeason(checkSeason) then
          return true
        end
      end
    end
  end
  return false
end

local function SetMainTaskState(self, id)
  self.allTask[id].state = TaskState.Received
end

local function GetSpecialTask(self)
  local allResult = {}
  local mgr = DataCenter.QuestTemplateManager
  for k, v in pairs(self.allTask) do
    if v.state ~= TaskState.Received then
      local template = mgr:GetQuestTemplate(k)
      if template ~= nil and template.order > 0 and template.type == QuestType.Main and template.position == "2" then
        table.insert(allResult, v)
      end
    end
  end
  if 0 < #allResult then
    table.sort(allResult, self.SpecialSortTask)
    return allResult[1]
  end
end

local function GetSurvivalActTask(self)
  local result = {}
  local mgr = DataCenter.QuestTemplateManager
  for k, v in pairs(self.allTask) do
    local template = mgr:GetQuestTemplate(k)
    if template ~= nil and (template.type == 49 or template.type == 50) then
      result[template.id] = template
    end
  end
  return result
end

local function SpecialSortTask(a, b)
  local mgr = DataCenter.QuestTemplateManager
  local task1 = mgr:GetQuestTemplate(a.id)
  local task2 = mgr:GetQuestTemplate(b.id)
  if task1 == nil then
    return false
  elseif task2 == nil then
    return true
  elseif task1.order > task2.order then
    return false
  elseif task1.order < task2.order then
    return true
  end
  return false
end

local function GetAllSortTask(a, b)
  if a.list > b.list then
    return false
  elseif a.list < b.list then
    return true
  end
  return false
end

local function GetAllSortTaskByOrderId(a, b)
  if a.order ~= b.order then
    return a.order < b.order
  else
    return a.data.id < b.data.id
  end
end

local function GetAllSortTaskByOrderIdWithSeason(a, b)
  if a.seasonTask == b.seasonTask then
    if a.order ~= b.order then
      return a.order < b.order
    else
      return a.data.id < b.data.id
    end
  elseif a.seasonTask then
    return true
  else
    return false
  end
end

local function PushUpdateTaskHandle(self, message)
  if message.task ~= nil then
    for k, v in pairs(message.task) do
      self:UpdateOneTaskInfo(v, false)
    end
  end
  local list = self:GetCanReceivedMainList()
  if next(list) then
    self.isTaskCompleteNew = true
  end
  EventManager:GetInstance():Broadcast(EventId.MainTaskUpdate, message)
end

local function TaskRewardGetHandle(self, message)
  if message.errorCode ~= nil then
    local errorCode = message.errorCode
    if errorCode ~= SeverErrorCode then
      UIUtil.ShowTips(Localization:GetString(message.errorCode))
    end
  else
    if message.accPoint ~= nil then
      DataCenter.AllianceBaseDataManager:UpdateAccPoint(message.accPoint)
    end
    if message.tasks then
      for i = 1, #message.tasks do
        self:UpdateOneTaskInfo(message.tasks[i], false)
      end
    end
    local taskId = message.taskId
    if taskId then
      SeasonUtil.TryUpdateSeasonBuild(taskId)
    end
    if self:ReceiveOneTask(taskId) then
      if message.reward ~= nil then
        if taskId == FiveStarTaskId then
          local scaleFactor = UIManager:GetInstance():GetScaleFactor()
          local position = Vector3.New(799, 165, 0) * scaleFactor
          local resourceType = ResourceType.Gold
          local pic = DataCenter.ResourceManager:GetResourceIconByType(resourceType)
          local flyPos = Vector3.New(0, 0, 0)
          UIUtil.DoFly(tonumber(resourceType), 3, pic, position, flyPos)
          TimerManager:GetInstance():DelayInvoke(function()
            DataCenter.RewardManager:AddRewardsAndRes(message)
          end, 1.5)
        else
          DataCenter.RewardManager:AddRewardsAndRes(message)
        end
      elseif message.resource ~= nil then
        LuaEntry.Resource:UpdateResource(message.resource)
      end
      self.isTaskCompleteNew = true
      EventManager:GetInstance():Broadcast(EventId.MainTaskUpdate)
      EventManager:GetInstance():Broadcast(EventId.MainTaskSuccess, message.taskId)
      EventManager:GetInstance():Broadcast(EventId.QuestRewardSuccess, message.taskId)
      EventManager:GetInstance():Broadcast(EventId.ReceiveQuestReward, message)
    end
  end
end

local function ReceiveOneTask(self, id)
  local task = self:FindTaskInfo(id)
  if task ~= nil then
    task.state = TaskState.Received
    return true
  end
  return false
end

local function IsShowMainTask(self)
  return false
end

local function GetCanRecQuestShowMaxNum(self)
  return LuaEntry.DataConfig:TryGetNum("maxnum_mainquest", "k2")
end

local function GetNoCompleteQuestShowMaxNum(self)
  return LuaEntry.DataConfig:TryGetNum("maxnum_mainquest", "k1")
end

local function GetCanReceivedList(self)
  local result = {}
  if self.allTask ~= nil then
    for k, v in pairs(self.allTask) do
      if v.state == TaskState.CanReceive then
        table.insert(result, v.id)
      end
    end
  end
  return result
end

local function GetCanReceivedMainList(self)
  local result = {}
  if self.allTask ~= nil then
    local mgr = DataCenter.QuestTemplateManager
    for k, v in pairs(self.allTask) do
      if v.state == TaskState.CanReceive then
        local template = mgr:GetQuestTemplate(k)
        if template ~= nil and template.order > 0 and template.type == QuestType.Main then
          table.insert(result, v.id)
        end
      end
    end
  end
  return result
end

local function IsHaveMainTask(self)
  if self.allTask ~= nil then
    local mgr = DataCenter.QuestTemplateManager
    for k, v in pairs(self.allTask) do
      local template = mgr:GetQuestTemplate(k)
      if template ~= nil and template.order > 0 and template.type == QuestType.Main then
        return true
      end
    end
  end
  return false
end

local function SetCompleteNew(self)
  self.isTaskCompleteNew = false
end

local function SetCompleteValue(self, state)
  self.completeValue = state
end

local function GetCompleteValue(self)
  return self.completeValue
end

local function SetTaskMsg(self, state)
  self.taskMsgIsShowType = state
end

local function GetTaskMsg(self)
  return self.taskMsgIsShowType
end

local function SetCurTaskViewIndex(self, index)
  self.curTaskIndex = index
end

local function GetCurTaskViewIndex(self)
  return self.curTaskIndex
end

local function GetPVETaskById(self, pveID)
  local pveTemplate = DataCenter.PveLevelTemplateManager:GetTemplate(pveID)
  local task = {}
  if self.pveTask and next(self.pveTask) and pveTemplate.task and next(pveTemplate.task) then
    local taskId = pveTemplate.task
    for i = 1, #taskId do
      if self.pveTask[tostring(taskId[i])] and self.pveTask[tostring(taskId[i])].state ~= TaskState.Received then
        table.insert(task, self.pveTask[tostring(taskId[i])])
      end
    end
  end
  local actId = DataCenter.PveActManager:GetActIdByPve(pveID)
  if actId then
    local data = DataCenter.PveActManager:GetData(actId)
    if data then
      local mgr = DataCenter.QuestTemplateManager
      for _, taskData in ipairs(data.tasks) do
        if taskData.state == TaskState.NoComplete then
          local questTemplate = mgr:GetQuestTemplate(taskData.id)
          if questTemplate and questTemplate.bubble == QuestBubbleType.Pve and tonumber(questTemplate.para3) == pveID then
            table.insert(task, taskData)
          end
        end
      end
    end
  end
  if next(task) then
    table.sort(task, self.SortPveTask)
  end
  return task
end

local function GetPveTaskList(self, pveID)
  local data = self:GetPVETaskById(pveID)
  local mgr = DataCenter.QuestTemplateManager
  local type = {}
  local list = {}
  for i = 1, #data do
    local task = mgr:GetQuestTemplate(data[i].id)
    type[task.list] = true
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
  table.insert(list, WarnList)
  return list
end

local function GetPveTaskByList(self, list, pveID)
  local mgr = DataCenter.QuestTemplateManager
  local data = self:GetPVETaskById(pveID)
  for i = 1, #data do
    local template = mgr:GetQuestTemplate(data[i].id)
    if list == tonumber(template.list) and template:UnpackPveShow() then
      return data[i]
    end
  end
  return nil
end

local function SortPveTask(a, b)
  local mgr = DataCenter.QuestTemplateManager
  local task1 = mgr:GetQuestTemplate(a.id)
  local task2 = mgr:GetQuestTemplate(b.id)
  if task1 == nil then
    return false
  elseif task2 == nil then
    return true
  elseif task1.order < task2.order then
    return true
  else
    return false
  end
  return false
end

local function SetPveRewardType(self, type, state)
  self.pveRewardGetType[type] = state
end

local function GetPveRewardType(self, type)
  if self.pveRewardGetType[type] then
    return self.pveRewardGetType[type]
  else
    return nil
  end
end

local function EnterPveCheckPveTask(self, levelId)
  self.felledTab = {}
  self.pveRewardGetType = {}
  if levelId then
    local mgr = DataCenter.QuestTemplateManager
    local list = self:GetPVETaskById(levelId)
    if next(list) then
      for i = 1, #list do
        local template = mgr:GetQuestTemplate(list[i].id)
        if tonumber(template.gotype2) == QuestGoType.GoFelledTree then
          local param = {}
          param.num = list[i].num
          param.id = list[i].id
          param.targetNum = template.para2
          param.resType = tonumber(template.para1)
          param.isSyncPve = false
          table.insert(self.felledTab, param)
        end
      end
      for i = 1, #self.felledTab do
        if self.felledTab[i].num >= self.felledTab[i].targetNum then
          DataCenter.BattleLevel:TaskSyncPveResource()
        end
      end
    end
  end
end

local function ClearFelledTree(self)
  self.pveRewardGetType = {}
  self.felledTab = {}
end

local function FelledTreeHandle(self, resourceType, realNum)
  if self.felledTab and not next(self.felledTab) then
    return
  end
  for i = 1, #self.felledTab do
    if self.felledTab[i].resType == resourceType then
      self.felledTab[i].num = self.felledTab[i].num + realNum
      if self.felledTab[i].num >= self.felledTab[i].targetNum and not self.felledTab[i].isSyncPve then
        self.felledTab[i].isSyncPve = true
        DataCenter.BattleLevel:TaskSyncPveResource()
      end
    end
  end
end

local function GetFelledTree(self, id)
  if self.felledTab then
    for i = 1, #self.felledTab do
      if self.felledTab[i].id == id then
        return self.felledTab[i].num
      end
    end
  end
  return 0
end

local function IsFinishTask(self, taskId)
  local task = self:FindTaskInfo(taskId)
  if task == nil then
    local taskInfo = DataCenter.ChapterTaskManager:FindTaskInfo(taskId)
    if taskInfo ~= nil and taskInfo.state ~= TaskState.NoComplete then
      return true
    end
  elseif task ~= nil and task.state ~= TaskState.NoComplete then
    return true
  end
  return false
end

local function AddOneTaskWhenDelete(self, task)
  if task ~= nil then
    local mainTask = self:FindTaskInfo(task.id)
    if mainTask == nil then
      self.allTask[task.id] = task
    end
  end
end

TaskManager.__init = __init
TaskManager.__delete = __delete
TaskManager.InitData = InitData
TaskManager.PushUpdateTaskHandle = PushUpdateTaskHandle
TaskManager.UpdateOneTaskInfo = UpdateOneTaskInfo
TaskManager.FindTaskInfo = FindTaskInfo
TaskManager.GetAllMainTask = GetAllMainTask
TaskManager.GetSurvivalActTask = GetSurvivalActTask
TaskManager.TaskRewardGetHandle = TaskRewardGetHandle
TaskManager.ReceiveOneTask = ReceiveOneTask
TaskManager.IsShowMainTask = IsShowMainTask
TaskManager.GetCanRecQuestShowMaxNum = GetCanRecQuestShowMaxNum
TaskManager.GetNoCompleteQuestShowMaxNum = GetNoCompleteQuestShowMaxNum
TaskManager.GetSpecialTask = GetSpecialTask
TaskManager.SpecialSortTask = SpecialSortTask
TaskManager.GetCanReceivedList = GetCanReceivedList
TaskManager.GetAllSortTask = GetAllSortTask
TaskManager.GetCanReceivedMainList = GetCanReceivedMainList
TaskManager.IsHaveMainTask = IsHaveMainTask
TaskManager.SetCompleteNew = SetCompleteNew
TaskManager.SetCompleteValue = SetCompleteValue
TaskManager.GetCompleteValue = GetCompleteValue
TaskManager.SetTaskMsg = SetTaskMsg
TaskManager.GetTaskMsg = GetTaskMsg
TaskManager.SetMainTaskState = SetMainTaskState
TaskManager.SetCurTaskViewIndex = SetCurTaskViewIndex
TaskManager.GetCurTaskViewIndex = GetCurTaskViewIndex
TaskManager.InitPVETask = InitPVETask
TaskManager.GetBubbleTask = GetBubbleTask
TaskManager.SortBubbleTask = SortBubbleTask
TaskManager.GetCurBubbleTaskType = GetCurBubbleTaskType
TaskManager.GetBubbleTaskByType = GetBubbleTaskByType
TaskManager.GetPVETaskById = GetPVETaskById
TaskManager.SortPveTask = SortPveTask
TaskManager.GetPveTaskList = GetPveTaskList
TaskManager.GetPveTaskByList = GetPveTaskByList
TaskManager.EnterPveCheckPveTask = EnterPveCheckPveTask
TaskManager.ClearFelledTree = ClearFelledTree
TaskManager.FelledTreeHandle = FelledTreeHandle
TaskManager.GetFelledTree = GetFelledTree
TaskManager.IsFinishTask = IsFinishTask
TaskManager.SetPveRewardType = SetPveRewardType
TaskManager.GetPveRewardType = GetPveRewardType
TaskManager.AddOneTaskWhenDelete = AddOneTaskWhenDelete
TaskManager.GetAllMainTaskForView = GetAllMainTaskForView
TaskManager.GetMainCountTaskForView = GetMainCountTaskForView
TaskManager.GetOneMainTaskForMainUI = GetOneMainTaskForMainUI
TaskManager.GetAllSortTaskByOrderId = GetAllSortTaskByOrderId
TaskManager.GetAllSortTaskByOrderIdWithSeason = GetAllSortTaskByOrderIdWithSeason
return TaskManager
