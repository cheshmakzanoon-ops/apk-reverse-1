local UIThemeActivityTableCtrl = BaseClass("UIThemeActivityTableCtrl", UIBaseCtrl)
local Localization = CS.GameEntry.Localization

local function CloseSelf(self)
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UIThemeActivityTable)
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
  local dailyType = 0
  if goId then
    local goActInfo = DataCenter.ActivityListDataManager:GetActivityDataById(tostring(goId))
    dailyType = goActInfo.activity_daily
  end
  local retGroups = {}
  DataCenter.ActivityListDataManager:SortActivityArr()
  local list = DataCenter.ActivityListDataManager:GetNowActivityList(false)
  if list ~= nil then
    local tempDic = {}
    for i, v in pairs(list) do
      if (not dailyType or dailyType == v.activity_daily) and v.tabGroup ~= nil and v.type ~= EnumActivity.KingActivity.Type and v.hideInActivityPanel and v.is_package == ActivityEntranceType.ThemeActivity then
        if not tempDic[v.tabGroup] then
          local newGroup = {}
          newGroup.tabGroup = v.tabGroup
          newGroup.tabGroupOrder = v.tabGroupOrder
          newGroup.activityList = {}
          tempDic[v.tabGroup] = newGroup
        end
        table.insert(tempDic[v.tabGroup].activityList, v)
      end
    end
    retGroups = table.values(tempDic)
    table.sort(retGroups, function(a, b)
      if a.tabGroupOrder ~= b.tabGroupOrder then
        return a.tabGroupOrder < b.tabGroupOrder
      else
        return false
      end
    end)
    for i, v in ipairs(retGroups) do
      table.sort(v.activityList, function(a, b)
        if a.order ~= b.order then
          return a.order < b.order
        else
          return false
        end
      end)
    end
  end
  return retGroups
end

local function GetDefaultFocusActivity(self, groupList, goId)
  local targetActId
  local targetActivityDaily = 0
  if goId then
    targetActId = tostring(goId)
    local tempInfo = DataCenter.ActivityListDataManager:GetActivityDataById(tostring(goId))
    targetActivityDaily = tempInfo.activity_daily
  else
    local firstActId
    for i, v in ipairs(groupList) do
      if targetActId then
        break
      end
      for m, n in ipairs(v.activityList) do
        if not firstActId then
          firstActId = n.id
          break
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
    oneData.list_icon = data.list_icon
    oneData.tabGroup = data.tabGroup
    oneData.tabGroupOrder = data.tabGroupOrder
    oneData.subViewType = data.subViewType
  end
  return oneData
end

local function GetCurrentActivity(self)
  local data = self:GetActivityDataById(self:GetCurrentActivityId())
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

UIThemeActivityTableCtrl.CloseSelf = CloseSelf
UIThemeActivityTableCtrl.Close = Close
UIThemeActivityTableCtrl.InitData = InitData
UIThemeActivityTableCtrl.SetCurrentActivityId = SetCurrentActivityId
UIThemeActivityTableCtrl.GetCurrentActivityId = GetCurrentActivityId
UIThemeActivityTableCtrl.GetActivityIdList = GetActivityIdList
UIThemeActivityTableCtrl.GetActivityDataById = GetActivityDataById
UIThemeActivityTableCtrl.GetCurrentActivity = GetCurrentActivity
UIThemeActivityTableCtrl.RewardItemList = RewardItemList
UIThemeActivityTableCtrl.GetSevenDayTaskReward = GetSevenDayTaskReward
UIThemeActivityTableCtrl.GetSevenDayBoxReward = GetSevenDayBoxReward
UIThemeActivityTableCtrl.GetScoreData = GetScoreData
UIThemeActivityTableCtrl.SendActivityGetRewardCommand = SendActivityGetRewardCommand
UIThemeActivityTableCtrl.GetBarterItemsList = GetBarterItemsList
UIThemeActivityTableCtrl.GetPuzzleData = GetPuzzleData
UIThemeActivityTableCtrl.GetActivityGroupList = GetActivityGroupList
UIThemeActivityTableCtrl.GetDefaultFocusActivity = GetDefaultFocusActivity
return UIThemeActivityTableCtrl
