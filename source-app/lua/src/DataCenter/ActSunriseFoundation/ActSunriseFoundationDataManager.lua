local ActSunriseFoundationDataManager = BaseClass("ActSunriseFoundationDataManager")
local Localization = CS.GameEntry.Localization
local ActSunriseFoundationData = require("DataCenter.ActSunriseFoundation.ActSunriseFoundationData")

local function __init(self)
  self.dataDict = {}
end

local function __delete(self)
  self.dataDict = nil
end

local function RefreshActDetailData(self, message)
  local activityId = message.activityId
  if self.dataDict[activityId] == nil then
    self.dataDict[activityId] = ActSunriseFoundationData.New()
  end
  self.dataDict[activityId]:ParseData(message)
end

local function GetActData(self, activityId)
  local data
  data = self.dataDict[activityId]
  return data
end

local function GetRedNum(self, activityId)
  local data = self.dataDict[activityId]
  if data then
    return data:GetRedNum()
  end
  return 0
end

ActSunriseFoundationDataManager.__init = __init
ActSunriseFoundationDataManager.__delete = __delete
ActSunriseFoundationDataManager.RefreshActDetailData = RefreshActDetailData
ActSunriseFoundationDataManager.GetActData = GetActData
ActSunriseFoundationDataManager.GetRedNum = GetRedNum
return ActSunriseFoundationDataManager
