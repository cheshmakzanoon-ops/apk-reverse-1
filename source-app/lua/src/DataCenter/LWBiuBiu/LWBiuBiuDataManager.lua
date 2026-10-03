local LWBiuBiuDataManager = BaseClass("LWBiuBiuDataManager")
local ResGroupManager = CS.DownloadResGroupCommonManager.Instance
local LWBiuBiuRoom = require("DataCenter.LWBiuBiu.LWBiuBiuRoom")

function LWBiuBiuDataManager:__init()
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
end

function LWBiuBiuDataManager:__delete()
  self.data = nil
  self.rankData = nil
  self.reward = nil
  self.resourceLoaded = nil
  self.loader = nil
  self.activityId = nil
end

function LWBiuBiuDataManager:UpdateInfo(t)
  self.data = t
end

function LWBiuBiuDataManager:UpdateRank(t)
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
  EventManager:GetInstance():Broadcast(EventId.SeasonGetBiuBiuRankInfo, parseData)
end

function LWBiuBiuDataManager:UpdateData(data)
  self.activityId = toInt(data.id)
  SFSNetwork.SendMessage(MsgDefines.BiuBiuGetInfo)
end

function LWBiuBiuDataManager:ValidationMessage(t)
  if t.code == 0 then
    self.data.passMaxLevel = self.data.passMaxLevel + 1
    EventManager:GetInstance():Broadcast(EventId.SeasonGetBiuBiuInfo)
  else
    local codeMd5 = ""
    local FuncVersion = CS.MiniGame.Biubiu.Client.FuncVersion
    if FuncVersion then
      codeMd5 = FuncVersion.CSharpCodeMD5
    end
    if t.log then
      Logger.LogError("[LWBiuBiu]: PVE Validation Fair bid is " .. self.data.bid .. "player uid is " .. LuaEntry.Player.uid .. " code is " .. t.code .. "version is Release" .. self:GetVersion() .. "log is " .. t.log .. "md5 is " .. codeMd5)
    else
      Logger.LogError("[LWBiuBiu]: PVE Validation Fair bid is " .. self.data.bid .. "player uid is " .. LuaEntry.Player.uid .. " code is " .. t.code .. "version is Release" .. self:GetVersion() .. "md5 is " .. codeMd5)
    end
  end
end

function LWBiuBiuDataManager:HandleSandWormFishingRewardList(msg, rewardType)
  self.reward[rewardType] = msg
  EventManager:GetInstance():Broadcast(EventId.SeasonGetBiuBiuRankReward)
end

function LWBiuBiuDataManager:GetActivityData()
  return DataCenter.ActivityListDataManager:GetActivityDataById(self.activityId)
end

function LWBiuBiuDataManager:GetBetData()
  local tabData = LocalController:instance():getLine(TableName.Activity, EnumActivity.BiuBiu.ActId)
  local data = string.split(tabData.para_5, "|")
  return {
    id = toInt(data[1]),
    count = toInt(data[2])
  }
end

function LWBiuBiuDataManager:GetCurrentLevel()
  if not self:IsVail() then
    return 0
  end
  return self.data.passMaxLevel + 1
end

function LWBiuBiuDataManager:GetStageCfgId()
  if not self:IsVail() then
    return 0
  end
  return self.data.stageCfgId
end

function LWBiuBiuDataManager:GetBid()
  if not self:IsVail() then
    return 0
  end
  return self.data.bid
end

function LWBiuBiuDataManager:GetCurrentLevelConfigID()
  if not self:IsVail() then
    return 0
  end
  return 1000 + self:GetCurrentLevel()
end

function LWBiuBiuDataManager:GetUIShowLevelConfigID()
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

function LWBiuBiuDataManager:GetChallengeMaxLevel()
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

function LWBiuBiuDataManager:IsPvpOpen()
  local actData = DataCenter.LWBiuBiuDataManager:GetActivityData()
  if actData == nil then
    return false
  end
  local waitTime = GetTableData(TableName.DataConfig, "season_shoot_game_pvp", "k1")
  waitTime = (tonumber(waitTime) - 1) * 86400000
  local startTime = DataCenter.LWBiuBiuDataManager:GetActivityData().startTime
  local serverTime = UITimeManager:GetInstance():GetServerTime()
  local open = waitTime <= serverTime - startTime
  if open then
    return open
  end
  return open, startTime + waitTime - serverTime
end

function LWBiuBiuDataManager:IsVail()
  local actData = self:GetActivityData()
  if actData == nil then
    return false
  end
  if self.data == nil then
    return false
  end
  return true
end

function LWBiuBiuDataManager:IsEnd()
  if not self:IsVail() then
    return true
  end
  local actData = self:GetActivityData()
  local curTime = UITimeManager:GetInstance():GetServerTime()
  return actData.endTime and curTime > actData.endTime
end

function LWBiuBiuDataManager:IsPass()
  if not self:IsVail() then
    return false
  end
  local actData = self:GetActivityData()
  return self.data.passMaxLevel >= toInt(actData.para_9)
end

function LWBiuBiuDataManager:IsDayPass()
  return self:GetCurrentLevel() > self:GetChallengeMaxLevel()
end

function LWBiuBiuDataManager:CanChallenge()
  if not self:IsVail() then
    return false
  end
  if self:IsPass() then
    return false
  end
  return self:GetCurrentLevel() <= self:GetChallengeMaxLevel()
end

function LWBiuBiuDataManager:GetRankConfigId()
  if self:IsVail() then
    local actData = self:GetActivityData()
    return actData.rankRewardParam[1]
  end
end

function LWBiuBiuDataManager:GetRankData(type)
  if self.rankData == nil then
    return nil
  end
  return self.rankData[type] or nil
end

function LWBiuBiuDataManager:GetRewardList(rewardType)
  return self.reward[rewardType] or {}
end

function LWBiuBiuDataManager:GetPackageID()
  return 5001
end

function LWBiuBiuDataManager:GetResourceLoaded()
  if self.resourceLoaded == nil then
    self.resourceLoaded = ResGroupManager:IsDownload(self:GetPackageID())
  end
  return self.resourceLoaded
end

function LWBiuBiuDataManager:ToLoadRes(completeAction)
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

function LWBiuBiuDataManager:GetRoom()
  if self.room == nil then
    self.room = LWBiuBiuRoom.New()
  end
  return self.room
end

function LWBiuBiuDataManager:GetPvpNotifyStrLength()
  return 120
end

function LWBiuBiuDataManager:GetVersion()
  local version = 1
  LocalController:instance():visitTable(TableName.SEASON_BULLET_SHOOT_GAME, function(id, lineData)
    version = lineData:getIntValue("version", 1) or 1
    return true
  end)
  return tostring(version)
end

function LWBiuBiuDataManager:GetTimeOut()
  return 14
end

function LWBiuBiuDataManager:GetBiuBiuRed(defaultValue)
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

return LWBiuBiuDataManager
