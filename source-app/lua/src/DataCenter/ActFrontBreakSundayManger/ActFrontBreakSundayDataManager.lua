local ActFrontBreakSundayDataManager = BaseClass("ActFrontBreakSundayDataManager")
local ActFrontBreakSundayData = require("DataCenter.ActFrontBreakSundayManger.ActFrontBreakSundayData")
local Localization = CS.GameEntry.Localization
local PrefKey = "ActFrontBreakSunday_"
local Setting = CS.GameEntry.Setting

local function __init(self)
  self.dataDict = {}
  self.nextStageId = -1
  self.firstActId = -1
end

local function __delete(self)
  self.dataDict = nil
  self.nextStageId = -1
  self.firstActId = -1
end

local function RefreshActDetailData(self, message)
  local activityId = tonumber(message.activityId)
  if self.firstActId == -1 then
    self.firstActId = activityId
  end
  self:EnsureData(activityId)
  self.dataDict[activityId]:ParseData(message)
end

local function EnsureData(self, activityId)
  if self.dataDict[activityId] == nil then
    self.dataDict[activityId] = ActFrontBreakSundayData.New(activityId)
  end
end

local function HandleTaskRewardMessage(self, message)
  local activityId = tonumber(message.activityId)
  self:EnsureData(activityId)
  self.dataDict[activityId]:HandleTaskRewardMessage(message)
end

local function RequestToEnterStage(self, stageId)
  if self.requestingEnterStage then
    return
  end
  local defaultActData
  if self.firstActId ~= -1 then
    defaultActData = self.dataDict[self.firstActId]
  end
  if defaultActData then
    self.requestingEnterStage = true
    defaultActData:RequestToEnterStage(stageId)
  end
end

local function HandleStartChallengeMessage(self, message)
  if not message then
    return
  end
  if not self.requestingEnterStage then
    return
  end
  self.requestingEnterStage = false
  if message.errorCode ~= nil then
    return
  end
  local defaultActData
  if self.firstActId ~= -1 then
    defaultActData = self.dataDict[self.firstActId]
  end
  if defaultActData then
    defaultActData:HandleStartChallengeMessage(message)
  end
end

local function HandleChallengeResultMessage(self, message)
  local defaultActData
  if self.firstActId ~= -1 then
    defaultActData = self.dataDict[self.firstActId]
  end
  if defaultActData then
    defaultActData:HandleChallengeResultMessage(message)
    if message.curStage and message.state and message.maxStage and message.maxLeft and message.totalLeft then
      local curStage = message.curStage
      local curStageState = message.state
      local stagesCount = table.count(defaultActData.stageIds)
      local curStageIndex = table.indexof(defaultActData.stageIds, curStage) or 0
      if curStageIndex and curStageIndex == stagesCount and curStageState == 2 then
        local historyMaxLeft = message.maxLeft
        local totalLeftCount = message.totalLeft
        local needUploadNum = math.max(historyMaxLeft, totalLeftCount)
        if 0 < needUploadNum and needUploadNum <= 9999 then
          CS.LastWarSocialBridge.SubmitScore(GameCenterUploadDataName.ActFrontBreakSunday, needUploadNum)
        end
      end
    end
  end
end

local function GetFirstActId(self)
  return self.firstActId
end

local function GetActData(self, activityId)
  local id = tonumber(activityId)
  self:EnsureData(id)
  local data = self.dataDict[id]
  return data
end

local function GetRedDotCount(self, activityId)
  return self.dataDict[activityId] and self.dataDict[activityId]:GetRedDotCount() or 0
end

local function GetStageIndex(self, activityId, stageId)
  return self.dataDict[activityId] and self.dataDict[activityId]:GetStageIndex(stageId) or false
end

local function GetNextStageId(self, activityId)
  return self.dataDict[activityId] and self.dataDict[activityId]:GetNextStageId() or -1
end

local function EnterNextStage(self, activityId)
  return self.dataDict[activityId] and self.dataDict[activityId]:EnterNextStage()
end

local function HasPlayed(self, activityId)
  return self.dataDict[activityId] and self.dataDict[activityId]:HasPlayed()
end

local function CanPlay(self, activityId)
  return self.dataDict[activityId] and self.dataDict[activityId]:CanPlay()
end

local function GetTopRankCriteriaStage(self, activityId)
  return self.dataDict[activityId] and self.dataDict[activityId]:GetTopRankCriteriaStage() or 0
end

local function GetTopRankCriteriaRemainSolider(self, activityId)
  return self.dataDict[activityId] and self.dataDict[activityId]:GetTopRankCriteriaRemainSolider() or 0
end

function ActFrontBreakSundayDataManager:GetFrontBreakSundayNeedAutoSelect()
  local activityInfoList = DataCenter.ActivityListDataManager:GetActivityDataByType(EnumActivity.FrontBreakSunday.Type)
  if not activityInfoList or not activityInfoList[1] then
    return false
  end
  local activityInfo = activityInfoList[1]
  local key = PrefKey .. tostring(activityInfo.id) .. "_" .. tostring(activityInfo:GetShowStartTime())
  return CS.GameEntry.Setting:GetPrivateBool(key, true)
end

function ActFrontBreakSundayDataManager:SetFrontBreakSundayNeedAutoSelect(value)
  local activityInfoList = DataCenter.ActivityListDataManager:GetActivityDataByType(EnumActivity.FrontBreakSunday.Type)
  if not activityInfoList or not activityInfoList[1] then
    return
  end
  local activityInfo = activityInfoList[1]
  local key = PrefKey .. tostring(activityInfo.id) .. "_" .. tostring(activityInfo:GetShowStartTime())
  CS.GameEntry.Setting:SetPrivateBool(key, value)
end

function ActFrontBreakSundayDataManager:IsOpen()
  local activityData = DataCenter.ActivityListDataManager:GetOneOpenActivityByType(EnumActivity.FrontBreakSunday.Type)
  return activityData ~= nil
end

function ActFrontBreakSundayDataManager:CheckIsNeedPop()
  if not self:IsOpen() then
    return
  end
  local isShown = Setting:GetPrivateBool("IsFrontBreakSundayShow", false)
  if isShown then
    return
  end
  local isInRange = false
  if CS.CommonUtils.IsDebug() then
    isInRange = self:IsInServerRange("k1")
  else
    isInRange = self:IsInServerRange("k2")
  end
  if not isInRange then
    return
  end
  Setting:SetPrivateBool("IsFrontBreakSundayShow", true)
  DataCenter.UIPopWindowManager:Push(UIWindowNames.FrontBreakOutSundayPatFace)
end

function ActFrontBreakSundayDataManager:IsInServerRange(configKey)
  local serverArray = LuaEntry.DataConfig:TryGetStr("frontline_weekend_poster_server", configKey)
  if string.IsNullOrEmpty(serverArray) then
    return false
  end
  local server = LuaEntry.Player:GetSourceServerId()
  local array = string.split(serverArray, "|")
  for _, arr in ipairs(array) do
    local list = string.split(arr, "-")
    if #list == 2 then
      local startServer = tonumber(list[1])
      local endServer = tonumber(list[2])
      if startServer <= endServer and server >= startServer and server <= endServer then
        return true
      end
    elseif #list == 1 then
      local se = tonumber(list[1]) or 0
      if 0 < se and se == server then
        return true
      end
    end
  end
  return false
end

function ActFrontBreakSundayDataManager:NeedChangeEntryIcon()
  if not self:IsOpen() then
    return false
  end
  local activityData = DataCenter.ActivityListDataManager:GetOneOpenActivityByType(EnumActivity.FrontBreakSunday.Type)
  if not activityData then
    return false
  end
  local id = activityData.id
  if not self.needChangeEntryIconActIds then
    local actIdStr = LuaEntry.DataConfig:TryGetStr("frontline_weekend_icon_activity", "k1")
    self.needChangeEntryIconActIds = string.split(actIdStr, "|")
  end
  for _, actId in ipairs(self.needChangeEntryIconActIds) do
    if actId == id then
      return true
    end
  end
  return false
end

function ActFrontBreakSundayDataManager:HandleSaveSoliderRewardMessage(message)
  local activityId = tonumber(message.activityId)
  self:EnsureData(activityId)
  self.dataDict[activityId]:HandleSaveSoliderRewardMessage(message)
end

function ActFrontBreakSundayDataManager:IsSaveSoliderOpen()
  return LuaEntry.DataConfig:CheckSwitch("frontline_weekend_save_soldier")
end

function ActFrontBreakSundayDataManager:SetNeedPlaySoliderFlyAnim(bool)
  if not self:IsSaveSoliderOpen() then
    self.isNeedPlaySoliderFlyAnim = false
    return
  end
  self.isNeedPlaySoliderFlyAnim = bool
end

function ActFrontBreakSundayDataManager:GetNeedPlaySoliderFlyAnim()
  if not self:IsSaveSoliderOpen() then
    return false
  end
  return self.isNeedPlaySoliderFlyAnim
end

ActFrontBreakSundayDataManager.__init = __init
ActFrontBreakSundayDataManager.__delete = __delete
ActFrontBreakSundayDataManager.RefreshActDetailData = RefreshActDetailData
ActFrontBreakSundayDataManager.GetActData = GetActData
ActFrontBreakSundayDataManager.GetRedDotCount = GetRedDotCount
ActFrontBreakSundayDataManager.GetNextStageId = GetNextStageId
ActFrontBreakSundayDataManager.HandleTaskRewardMessage = HandleTaskRewardMessage
ActFrontBreakSundayDataManager.EnsureData = EnsureData
ActFrontBreakSundayDataManager.GetStageIndex = GetStageIndex
ActFrontBreakSundayDataManager.HandleStartChallengeMessage = HandleStartChallengeMessage
ActFrontBreakSundayDataManager.HandleChallengeResultMessage = HandleChallengeResultMessage
ActFrontBreakSundayDataManager.EnterNextStage = EnterNextStage
ActFrontBreakSundayDataManager.GetFirstActId = GetFirstActId
ActFrontBreakSundayDataManager.HasPlayed = HasPlayed
ActFrontBreakSundayDataManager.CanPlay = CanPlay
ActFrontBreakSundayDataManager.RequestToEnterStage = RequestToEnterStage
ActFrontBreakSundayDataManager.GetTopRankCriteriaStage = GetTopRankCriteriaStage
ActFrontBreakSundayDataManager.GetTopRankCriteriaRemainSolider = GetTopRankCriteriaRemainSolider
return ActFrontBreakSundayDataManager
