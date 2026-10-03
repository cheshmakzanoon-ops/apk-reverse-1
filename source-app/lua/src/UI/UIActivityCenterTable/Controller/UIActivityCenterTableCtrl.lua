local UIActivityCenterTableCtrl = BaseClass("UIActivityCenterTableCtrl", UIBaseCtrl)
local Localization = CS.GameEntry.Localization

local function CloseSelf(self)
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UIActivityCenterTable)
end

local function Close(self)
  UIManager:GetInstance():DestroyWindowByLayer(UILayer.Normal)
end

local function InitData(self)
  self:SetCurrentActivityId("")
end

local function SetCurrentActivityId(self, id)
  self.activityId = id
end

local function GetCurrentActivityId(self)
  return self.activityId
end

local function GetActivityGroupList(self, goId)
  local retGroups = DataCenter.ActivityListDataManager:GetActivityCenterGroupList(goId)
  return retGroups
end

local function GetDefaultFocusActivity(self, groupList, goId)
  local targetActId
  local targetActivityDaily = 0
  if goId then
    targetActId = tostring(goId)
    if targetActId then
      local actInfo = DataCenter.ActivityListDataManager:GetActivityDataById(targetActId)
      if actInfo and not actInfo:IsValid() then
        targetActId = nil
      else
        local tempInfo = DataCenter.ActivityListDataManager:GetActivityDataById(tostring(goId))
        targetActivityDaily = tempInfo.activity_daily
      end
    end
  end
  if targetActId == nil then
    local firstActId
    for i, v in ipairs(groupList) do
      for m, n in ipairs(v.activityList) do
        if not firstActId and n.type ~= EnumActivity.ActCalendar.Type then
          firstActId = n.id
          break
        end
      end
    end
    if not targetActId then
      targetActId = DataCenter.ActivityListDataManager:GetLastVisitedActivityId(targetActivityDaily)
      local needSelectFrontBreakSunday = DataCenter.ActFrontBreakSundayDataManager:GetFrontBreakSundayNeedAutoSelect()
      if needSelectFrontBreakSunday then
        local activityInfoList = DataCenter.ActivityListDataManager:GetActivityDataByType(EnumActivity.FrontBreakSunday.Type)
        if activityInfoList and activityInfoList[1] then
          targetActId = activityInfoList[1].id
          DataCenter.ActFrontBreakSundayDataManager:SetFrontBreakSundayNeedAutoSelect(false)
        end
      end
      if targetActId then
        local actInfo = DataCenter.ActivityListDataManager:GetActivityDataById(targetActId)
        if actInfo and not actInfo:IsValid() then
          targetActId = nil
        end
      end
    end
    targetActId = targetActId or firstActId
  end
  for i, v in ipairs(groupList) do
    for m, n in ipairs(v.activityList) do
      if n.id == targetActId then
        return n.id, i, m
      end
    end
  end
end

local function GetActivityIdList(self)
  local showList = {}
  DataCenter.ActivityListDataManager:SortActivityArr()
  local list = DataCenter.ActivityListDataManager:GetNowActivityList(false)
  if list ~= nil then
    local isFirst = true
    local temp = {}
    for i, v in pairs(list) do
      table.insert(temp, v)
    end
    table.sort(temp, function(a, b)
      if a.order < b.order then
        return true
      elseif a.order == b.order then
        return false
      end
      return false
    end)
    for i = 1, #temp do
      if isFirst and (self:GetCurrentActivityId() == nil or self:GetCurrentActivityId() == "") then
        self:SetCurrentActivityId(temp[i].id)
      end
      table.insert(showList, temp[i].id)
    end
  end
  self:SetCurrentActivityId(showList[1])
  local seventDayinfo = DataCenter.ActivityListDataManager:GetSevenDayList()
  if next(seventDayinfo) then
    table.insert(showList, 1, EnumActivity.SevenDay.Type)
  end
  return showList
end

local function GetActivityDataById(self, id)
  local oneData = {}
  oneData.id = id
  local data = DataCenter.ActivityListDataManager:GetActivityDataById(id)
  if data ~= nil then
    oneData.name = Localization:GetString(data.name)
    oneData.type = data.type
    oneData.canGet = DataCenter.ActivityListDataManager:GetRewardNumByTypeAndId(data.type, data.id)
    oneData.activityId = data.activityId == "" and data.id or data.activityId
    oneData.list_icon = self:GetListIcon(data)
    oneData.tabGroup = data.tabGroup
    oneData.tabGroupOrder = data.tabGroupOrder
    oneData.subViewType = data.subViewType
    oneData.bannerTittle = Localization:GetString(data.bannerTittle)
  end
  return oneData
end

local function GetListIcon(self, data)
  if data.type == ActivityEnum.ActivityType.AllyBase then
    local bossType = DataCenter.AllyDrillDataManager:GetBossType()
    if bossType == AllyDrillBoss.HugeSandWorm then
      return "lrb_shachongjunyan_yeqian"
    else
      return data.list_icon
    end
  else
    return data.list_icon
  end
end

local function GetFakeActivityDataById(self, actId)
  if string.endswith(tostring(actId), "fake") then
    local list = DataCenter.ActivityListDataManager:CheckNonActivityView(true)
    for k, v in pairs(list) do
      if v.id == actId then
        return v
      end
    end
  end
end

local function GetCurrentActivity(self)
  local actId = self:GetCurrentActivityId()
  local fakeData = self:GetFakeActivityDataById(actId)
  if fakeData then
    return fakeData
  end
  local data = self:GetActivityDataById(actId)
  return data
end

local function RewardItemList(self, list)
  return DataCenter.RewardManager:RewardItemList(list)
end

local function GetSevenDayTaskReward(self, taskId)
  SFSNetwork.SendMessage(MsgDefines.TaskRewardGet, {id = taskId})
end

local function GetSevenDayBoxReward(self, index)
  SFSNetwork.SendMessage(MsgDefines.UserDayActReward, index)
end

local function GetScoreData(self, activityId)
  local scoreData = DataCenter.ActPersonalArmsInfo:GetScoreMeth(activityId)
  return scoreData
end

local function SendActivityGetRewardCommand(self, actId, stage, type)
  DataCenter.ActivityController:SendActivityGetRewardCommand(actId, stage, type)
end

local function GetBarterItemsList(self, strConf, isNeed)
  local retList = {}
  local strList = string.split(strConf, "|")
  for i, v in ipairs(strList) do
    local paramList = string.split(v, ";")
    local oneItem = {}
    if #paramList == 2 then
      oneItem.rewardType = tonumber(paramList[1])
      if isNeed then
        local resType = RewardToResType[tonumber(paramList[1])]
        local tempCount = 0
        if resType == ResourceType.Gold then
          tempCount = LuaEntry.Player.gold
        else
          tempCount = LuaEntry.Resource:GetCntByResType(resType)
        end
        oneItem.count = tempCount
        oneItem.cost = tonumber(paramList[2])
      else
        oneItem.count = tonumber(paramList[2])
      end
      table.insert(retList, oneItem)
    elseif #paramList == 3 then
      oneItem.rewardType = tonumber(paramList[1])
      oneItem.itemId = paramList[2]
      if isNeed then
        local costItem = DataCenter.ItemData:GetItemById(paramList[2])
        local ownNum = costItem and costItem.count or 0
        oneItem.count = ownNum
        oneItem.cost = tonumber(paramList[3])
      else
        oneItem.count = tonumber(paramList[3])
      end
      table.insert(retList, oneItem)
    end
  end
  return retList
end

local function GetPuzzleData(self)
  local data = DataCenter.ActivityPuzzleDataManager:GetPuzzleData()
  if data == nil then
    return nil
  end
  local result = {}
  result.IsOver = false
  local complete = {}
  table.walk(data.puzzleInfo.blockArr, function(_, v)
    complete[v] = true
  end)
  result.complete = complete
  result.canCreatePuzzleMonster = data:CanCreatePuzzleBoss()
  result.createPuzzleMonsterNum = data:GetUnCreatePuzzleMonsterNum()
  result.puzzleNumPerStage = MaxPuzzlePerStage
  result.currentStateCompletePuzzle = table.count(complete)
  result.canGetStageReward = result.currentStateCompletePuzzle >= result.puzzleNumPerStage
  local puzzleInfo = {}
  puzzleInfo.taskId = data.currentTask.taskId
  puzzleInfo.num = data.currentTask.num
  puzzleInfo.state = data.currentTask.state
  puzzleInfo.hasNext = result.hasNext
  puzzleInfo.needNum = 1
  puzzleInfo.canGetStageReward = result.canGetStageReward
  local template = DataCenter.QuestTemplateManager:GetQuestTemplate(puzzleInfo.taskId)
  if template then
    puzzleInfo.needNum = template.para2
  end
  puzzleInfo.num = math.min(puzzleInfo.num, puzzleInfo.needNum)
  puzzleInfo.blockNum = data.currentTask.blockNum
  puzzleInfo.nextPuzzleTime = data.lastRecoverTime
  result.puzzleInfo = puzzleInfo
  local rewardList = DataCenter.RewardManager:ReturnRewardParamForView(data.puzzleInfo.reward)
  result.rewardList = rewardList
  return result
end

local function CheckNonActivityView(self, isShowInActCenter)
  local ret = DataCenter.ActivityListDataManager:CheckNonActivityView(isShowInActCenter)
  return ret
end

local function GetActivityDataByType(self, targetType)
  local activityList = DataCenter.ActivityListDataManager:GetActivityList()
  local oneData = {}
  local data
  for _, value in pairs(activityList) do
    if value.type == targetType then
      data = value
      if data ~= nil then
        oneData.id = data.id
        oneData.name = Localization:GetString(data.name)
        oneData.type = data.type
        oneData.canGet = DataCenter.ActivityListDataManager:GetRewardNumByTypeAndId(data.type, data.id)
        oneData.activityId = data.activityId == "" and data.id or data.activityId
        oneData.list_icon = self:GetListIcon(data)
        oneData.tabGroup = data.tabGroup
        oneData.tabGroupOrder = data.tabGroupOrder
        oneData.subViewType = data.subViewType
      end
      return oneData
    end
  end
  return nil
end

local function DelEndActivity(self, actList)
  local curTime = UITimeManager:GetInstance():GetServerTime()
  local newList = {}
  for _, act in ipairs(actList) do
    if act.type == EnumActivity.SurfingBattleAct.Type and act.endTime and curTime <= act.endTime then
      table.insert(newList, act)
    else
      table.insert(newList, act)
    end
  end
  return newList
end

UIActivityCenterTableCtrl.CloseSelf = CloseSelf
UIActivityCenterTableCtrl.Close = Close
UIActivityCenterTableCtrl.InitData = InitData
UIActivityCenterTableCtrl.SetCurrentActivityId = SetCurrentActivityId
UIActivityCenterTableCtrl.GetCurrentActivityId = GetCurrentActivityId
UIActivityCenterTableCtrl.GetActivityIdList = GetActivityIdList
UIActivityCenterTableCtrl.GetActivityDataById = GetActivityDataById
UIActivityCenterTableCtrl.GetCurrentActivity = GetCurrentActivity
UIActivityCenterTableCtrl.RewardItemList = RewardItemList
UIActivityCenterTableCtrl.GetSevenDayTaskReward = GetSevenDayTaskReward
UIActivityCenterTableCtrl.GetSevenDayBoxReward = GetSevenDayBoxReward
UIActivityCenterTableCtrl.GetScoreData = GetScoreData
UIActivityCenterTableCtrl.SendActivityGetRewardCommand = SendActivityGetRewardCommand
UIActivityCenterTableCtrl.GetBarterItemsList = GetBarterItemsList
UIActivityCenterTableCtrl.GetPuzzleData = GetPuzzleData
UIActivityCenterTableCtrl.GetActivityGroupList = GetActivityGroupList
UIActivityCenterTableCtrl.GetDefaultFocusActivity = GetDefaultFocusActivity
UIActivityCenterTableCtrl.CheckNonActivityView = CheckNonActivityView
UIActivityCenterTableCtrl.GetFakeActivityDataById = GetFakeActivityDataById
UIActivityCenterTableCtrl.GetListIcon = GetListIcon
UIActivityCenterTableCtrl.GetActivityDataByType = GetActivityDataByType
UIActivityCenterTableCtrl.DelEndActivity = DelEndActivity
return UIActivityCenterTableCtrl
