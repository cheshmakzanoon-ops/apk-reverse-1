local LWGGGoDataManager = BaseClass("LWGGGoDataManager")
local ResGroupManager = CS.DownloadResGroupCommonManager.Instance
local LWGGGoRoom = require("DataCenter.LWGGGo.LWGGGoRoom")

function LWGGGoDataManager:__init()
  self.data = nil
  self.rankData = {
    [1] = {},
    [2] = {}
  }
  self.reward = {}
  self.resourceLoaded = nil
  self.room = nil
  self.loader = nil
  self.activityId = nil
  self.version = nil
  self._bgmOwnerKey = nil
  self.isReplayMode = false
end

function LWGGGoDataManager:__delete()
  self.data = nil
  self.rankData = nil
  self.reward = nil
  self.resourceLoaded = nil
  self.loader = nil
  self.activityId = nil
  self._bgmOwnerKey = nil
  self.isReplayMode = false
end

function LWGGGoDataManager:SetReplayMode(val)
  self.isReplayMode = val == true
end

function LWGGGoDataManager:IsReplayMode()
  return self.isReplayMode == true
end

function LWGGGoDataManager:UpdateInfo(t)
  if not t.passMaxLevel then
    t.passMaxLevel = self.data and self.data.passMaxLevel or 0
  end
  if not t.bid then
    t.bid = self.data and self.data.bid or 0
  end
  self.data = t
end

function LWGGGoDataManager:UpdateRank(t)
  local rankList = {}
  for k, v in pairs(t.rankArr) do
    local oneData = PlayerRankData.New()
    oneData:ParseData(v)
    oneData:SetRank(v.rank, t.type)
    table.insert(rankList, oneData)
  end
  local parseData = {
    rankArr = rankList,
    owner = t.owner,
    opType = t.type
  }
  self.rankData[t.type] = parseData
  EventManager:GetInstance():Broadcast(EventId.SeasonGetGGGoRankInfo, parseData)
end

function LWGGGoDataManager:UpdateData(data)
  self.activityId = toInt(data.id)
  SFSNetwork.SendMessage(MsgDefines.ActivityLittleGamePveInfo, self:GetActivityType() or EnumActivity.GGGo.Type)
end

function LWGGGoDataManager:ValidationMessage(t)
  if t.code == 0 then
    if not self:IsReplayMode() then
      self.data.passMaxLevel = self.data.passMaxLevel + 1
    end
    EventManager:GetInstance():Broadcast(EventId.SeasonGetGGGoInfo)
  else
    local codeMd5 = ""
    local FuncVersion = CS.MiniGame.GGGo.Client.FuncVersion
    if FuncVersion then
      codeMd5 = FuncVersion.CSharpCodeMD5
    end
    if t.log then
      Logger.LogError("[LWGGGo]: PVE Validation Fair bid is " .. self.data.bid .. "; player uid is " .. LuaEntry.Player.uid .. "; code is " .. t.code .. "; version is " .. self:GetVersion() .. "; log is " .. t.log .. "; md5 is " .. codeMd5)
    else
      Logger.LogError("[LWGGGo]: PVE Validation Fair bid is " .. self.data.bid .. "; player uid is " .. LuaEntry.Player.uid .. "; code is " .. t.code .. "; version is " .. self:GetVersion() .. "; md5 is " .. codeMd5)
    end
  end
  DataCenter.LWGGGoDataManager:SetReplayMode(false)
end

function LWGGGoDataManager:HandleSandWormFishingRewardList(msg, rewardType)
  self.reward[rewardType] = msg
  EventManager:GetInstance():Broadcast(EventId.SeasonGetGGGoRankReward)
end

function LWGGGoDataManager:GetActivityData()
  return DataCenter.ActivityListDataManager:GetActivityDataById(self.activityId)
end

function LWGGGoDataManager:GetActivityType()
  local actData = self:GetActivityData()
  return actData and actData.type or 0
end

function LWGGGoDataManager:GetBetData()
  local tabData = LocalController:instance():getLine(TableName.Activity, EnumActivity.GGGo.ActId)
  local data = string.split(tabData.para_5, "|")
  return {
    id = toInt(data[1]),
    count = toInt(data[2])
  }
end

function LWGGGoDataManager:GetCurrentLevel()
  if not self:IsVail() then
    return 0
  end
  if self:IsReplayMode() then
    return self.data.passMaxLevel
  end
  return self.data.passMaxLevel + 1
end

function LWGGGoDataManager:GetStageCfgId()
  if not self:IsVail() then
    return 0
  end
  return self.data.stageCfgId
end

function LWGGGoDataManager:GetBid()
  if not self:IsVail() then
    return 0
  end
  return self.data.bid or 0
end

function LWGGGoDataManager:GetCurrentLevelConfigID()
  if not self:IsVail() then
    return 0
  end
  return 1000 + self:GetCurrentLevel()
end

function LWGGGoDataManager:GetUIShowLevelConfigID()
  if not self:IsVail() then
    return 0
  end
  local dayPass = self:IsDayPass()
  local pass = self:IsPass()
  local curLevel = self:GetCurrentLevel()
  local maxLevel = self:GetChallengeMaxLevel()
  local isNotLevel = pass or dayPass
  if isNotLevel then
    curLevel = maxLevel
  end
  return 1000 + curLevel
end

function LWGGGoDataManager:GetChallengeMaxLevel()
  if not self:IsVail() then
    return 0
  end
  local actData = self:GetActivityData()
  local serverTime = UITimeManager:GetInstance():GetServerSeconds()
  local opLevel = math.ceil((serverTime - actData.startTime / 1000) / 86400)
  local actData = self:GetActivityData()
  local configMax = toInt(actData.para_9)
  return math.min(configMax, opLevel * toInt(actData.para))
end

function LWGGGoDataManager:IsPvpOpen()
  local actData = DataCenter.LWGGGoDataManager:GetActivityData()
  if actData == nil then
    return false
  end
  local waitTime = GetTableData(TableName.DataConfig, "season_game_pvp_s6", "k1")
  waitTime = (tonumber(waitTime) - 1) * 86400000
  local startTime = DataCenter.LWGGGoDataManager:GetActivityData().startTime
  local serverTime = UITimeManager:GetInstance():GetServerTime()
  local open = waitTime <= serverTime - startTime
  if open then
    return open
  end
  return open, startTime + waitTime - serverTime
end

function LWGGGoDataManager:IsVail()
  local actData = self:GetActivityData()
  if actData == nil then
    return false
  end
  if self.data == nil then
    return false
  end
  return true
end

function LWGGGoDataManager:IsEnd()
  if not self:IsVail() then
    return true
  end
  local actData = self:GetActivityData()
  local curTime = UITimeManager:GetInstance():GetServerTime()
  return actData.endTime and curTime > actData.endTime
end

function LWGGGoDataManager:IsPass()
  if not self:IsVail() then
    return false
  end
  local actData = self:GetActivityData()
  return self.data.passMaxLevel >= toInt(actData.para_9)
end

function LWGGGoDataManager:IsDayPass()
  return self:GetCurrentLevel() > self:GetChallengeMaxLevel()
end

function LWGGGoDataManager:CanChallenge()
  if not self:IsVail() then
    return false
  end
  if self:IsPass() then
    return false
  end
  return self:GetCurrentLevel() <= self:GetChallengeMaxLevel()
end

function LWGGGoDataManager:GetRankConfigId()
  if self:IsVail() then
    local actData = self:GetActivityData()
    return actData.rankRewardParam[1]
  end
end

function LWGGGoDataManager:GetRankData(type)
  if self.rankData == nil then
    return nil
  end
  return self.rankData[type] or nil
end

function LWGGGoDataManager:GetRewardList(rewardType)
  return self.reward[rewardType] or {}
end

function LWGGGoDataManager:GetPackageID()
  return 5002
end

function LWGGGoDataManager:GetResourceLoaded()
  if self.resourceLoaded == nil then
    self.resourceLoaded = ResGroupManager:IsDownload(self:GetPackageID())
  end
  return self.resourceLoaded
end

function LWGGGoDataManager:ToLoadRes(completeAction)
  local packageID = self:GetPackageID()
  if self.loader == nil then
    self.loader = ResGroupManager:StartDownload(packageID)
  end
  if self.loader ~= nil then
    self.loader:completed("+", function(loaderReq)
      if not ResGroupManager:IsDownload(packageID) then
        Logger.LogError("pack\228\184\139\232\189\189\229\174\140\228\185\139\229\144\142\230\156\172\229\156\176\230\178\161\230\137\190\229\136\176\239\188\159\239\188\159 packConfigId: " .. packageID)
        return
      end
      self.resourceLoaded = ResGroupManager:IsDownload(self:GetPackageID())
      if completeAction ~= nil then
        completeAction()
      end
    end)
  end
end

function LWGGGoDataManager:GetRoom(activityType_)
  if self.room == nil then
    self.room = LWGGGoRoom.New()
  end
  if activityType_ then
    self.room:SetActivityType(activityType_)
  end
  return self.room
end

function LWGGGoDataManager:GetPvpNotifyStrLength()
  return 120
end

function LWGGGoDataManager:GetVersion(stageCfgId)
  if stageCfgId then
    local version = GetTableData(TableName.SEASON_CAVE_EXPLORATION, stageCfgId, "version") or "1"
    return tostring(version)
  end
  if self.version then
    return self.version
  end
  local version = 1
  LocalController:instance():visitTable(TableName.SEASON_CAVE_EXPLORATION, function(id, lineData)
    version = lineData:getValue("version", "1") or "1"
    return true
  end)
  self.version = tostring(version)
  return self.version
end

function LWGGGoDataManager:GetTimeOut()
  return 14
end

function LWGGGoDataManager:GetGGGoRed(defaultValue)
  if not self:IsVail() then
    return defaultValue or false
  end
  local red = not self:IsDayPass() or false
  if not red and self:IsPvpOpen() then
    local room = self:GetRoom()
    red = room:GetBetMaxCount() - room:GetBetCount() > 0
  end
  return red
end

function LWGGGoDataManager:OpenActitiy()
  local actId = self.activityId or EnumActivity.GGGo.ActId
  local actData = DataCenter.ActivityListDataManager:GetActivityDataById(actId)
  if actData == nil then
    UIUtil.ShowTipsId("458822")
    return
  end
  UIManager:GetInstance():OpenWindow(UIWindowNames.UILWSingleActivityContainer, {
    anim = true,
    UIMainAnim = UIMainAnimType.AllHide
  }, actId)
end

function LWGGGoDataManager:PlaySeasonActivityBGM()
  local act = self:GetActivityData()
  if not act then
    return
  end
  local idKey = tostring(self.activityId or act.id)
  self._bgmOwnerKey = idKey
  if act.season_activity_bgm and act.season_activity_bgm > 0 then
    DataCenter.LWUIBGMManager:PlayActivityBGM(idKey, act.season_activity_bgm)
  end
  if act.season_activity_amb and 0 < act.season_activity_amb then
    DataCenter.LWUIBGMManager:PlayActivityAmb(idKey, act.season_activity_amb)
  end
end

function LWGGGoDataManager:StopSeasonActivityBGM()
  local idKey = self._bgmOwnerKey
  if not idKey then
    return
  end
  self._bgmOwnerKey = nil
  DataCenter.LWUIBGMManager:StopActivityBGM(idKey)
  DataCenter.LWUIBGMManager:StopActivityAmb(idKey)
end

return LWGGGoDataManager
