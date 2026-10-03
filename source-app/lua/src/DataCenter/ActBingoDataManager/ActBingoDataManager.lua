local ActBingoDataManager = BaseClass("ActBingoDataManager")
local Localization = CS.GameEntry.Localization
local ActBingoData = require("DataCenter.ActBingoDataManager.ActBingoData")

local function __init(self)
  self.dataDict = {}
end

local function __delete(self)
  self.dataDict = nil
end

local function RefreshActDetailData(self, message)
  local activityId = message.activityId
  if self.dataDict[activityId] == nil then
    self.dataDict[activityId] = ActBingoData.New()
  end
  self.dataDict[activityId]:ParseData(message)
end

local function GetActData(self, activityId)
  local data
  data = self.dataDict[activityId]
  return data
end

local function GetRedNum(self, actId)
  local num = 0
  if self.dataDict[actId] then
    num = self.dataDict[actId]:GetRedNum()
  end
  return num
end

local function UpdateActTasks(self, message)
  local activityId = message.aid
  if self.dataDict[activityId] == nil then
    return
  end
  self.dataDict[activityId]:UpdateActTasks(message)
end

local function GetOneTaskReward(self, message)
  local activityId = message.activity
  if self.dataDict[activityId] == nil then
    return
  end
  self.dataDict[activityId]:GetOneTaskReward(message)
end

local function GetOneBoxReward(self, message)
  local activityId = message.activityId
  if self.dataDict[activityId] == nil then
    return
  end
  self.dataDict[activityId]:GetOneBoxReward(message)
end

ActBingoDataManager.__init = __init
ActBingoDataManager.__delete = __delete
ActBingoDataManager.RefreshActDetailData = RefreshActDetailData
ActBingoDataManager.GetActData = GetActData
ActBingoDataManager.GetRedNum = GetRedNum
ActBingoDataManager.UpdateActTasks = UpdateActTasks
ActBingoDataManager.GetOneTaskReward = GetOneTaskReward
ActBingoDataManager.GetOneBoxReward = GetOneBoxReward
return ActBingoDataManager
