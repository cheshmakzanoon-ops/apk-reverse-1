local MineCaveManager = BaseClass("MineCaveManager")
local MineCaveData = require("DataCenter.ActivityListData.MineCaveData")
local MineCaveTemplate = require("DataCenter.ActivityListData.MineCaveTemplate")

local function __init(self)
  self.mineCaveInfo = nil
  self.mineCaveConf = nil
  self.refreshCost = nil
  self.attackMineIndex = nil
  self.dispatchFormationUid = nil
  self.plunderList = {}
  self.cachePveEnemyPower = 0
  self.toUnlockMinesInfo = nil
  self:AddListener()
end

local function __delete(self)
  self:RemoveListener()
  self.mineCaveInfo = nil
  self.mineCaveConf = nil
  self.refreshCost = nil
  self.attackMineIndex = nil
  self.dispatchFormationUid = nil
  self.plunderList = nil
  self.cachePveEnemyPower = nil
  self.toUnlockMinesInfo = nil
end

local function AddListener(self)
  EventManager:GetInstance():AddListener(EventId.OnPassDay, self.TryReqUpdateMineCaveInfo)
end

local function RemoveListener(self)
  EventManager:GetInstance():RemoveListener(EventId.OnPassDay, self.TryReqUpdateMineCaveInfo)
end

local function TryReqUpdateMineCaveInfo(self)
  SFSNetwork.SendMessage(MsgDefines.GetMineCaveInfo)
end

local function UpdateMineCaveInfo(self, message)
  if not self.mineCaveInfo then
    self.mineCaveInfo = MineCaveData.New()
  end
  self.mineCaveInfo:ParseData(message)
  self:UpdateToUnlockList()
  EventManager:GetInstance():Broadcast(EventId.UpdateMineCaveInfo)
  EventManager:GetInstance():BroadcastDeferred(EventId.RefreshActivityRedDot)
end

local function GetMineCaveInfo(self)
  return self.mineCaveInfo
end

local function GetPreviewList(self, tempScore)
  if not self.mineCaveConf then
    self:InitConf()
  end
  local retList = {}
  for i, v in ipairs(self.mineCaveConf) do
    if tempScore >= v.caveShow[1] and tempScore <= v.caveShow[2] then
      if v.func and v.func == 1 then
        local canPreview = LuaEntry.Effect:GetGameEffect(EffectDefine.MINE_CAVE_CAN_PREVIEW)
        if canPreview == 1 then
          table.insert(retList, v)
        end
      else
        table.insert(retList, v)
      end
    end
  end
  return retList
end

local function GetToUnlockMinesInfo(self)
  return self.toUnlockMinesInfo
end

local function UpdateToUnlockList(self, forceUpdate)
  if not self.mineCaveInfo then
    return
  end
  if self.toUnlockMinesInfo and not forceUpdate then
    return
  end
  self.toUnlockMinesInfo = {
    score = 0,
    minesConfList = {}
  }
  local toUnlockConf = LuaEntry.DataConfig:TryGetStr("mine_cave", "k7")
  local toUnlockArr = string.split(toUnlockConf, "|")
  local curToUnlockArr
  for i, v in ipairs(toUnlockArr) do
    local tempConf = string.split(v, ";")
    if 2 <= #tempConf then
      local showScore = tonumber(tempConf[1])
      if showScore > self.mineCaveInfo.curScore then
        curToUnlockArr = tempConf
        break
      end
    end
  end
  if curToUnlockArr then
    self.toUnlockMinesInfo.score = tonumber(curToUnlockArr[1])
    self.toUnlockMinesInfo.minesConfList = {}
    for i = 2, #curToUnlockArr do
      local mineConf = self:GetMineConf(tonumber(curToUnlockArr[i]))
      table.insert(self.toUnlockMinesInfo.minesConfList, mineConf)
    end
  end
end

local function GetMyScore(self)
  local retScore = 0
  if self.mineCaveInfo then
    retScore = self.mineCaveInfo.curScore
  end
  return retScore
end

local function GetMineConf(self, mineId)
  if not self.mineCaveConf then
    self:InitConf()
  end
  for i, v in ipairs(self.mineCaveConf) do
    if v.id == mineId then
      return v
    end
  end
end

local function GetMyCaveInfo(self, uuid)
  if not self.mineCaveInfo then
    return
  end
  return self.mineCaveInfo:GetMyMineInfo(uuid)
end

local function GetMineInfo(self, index)
  if not self.mineCaveInfo then
    return
  end
  return self.mineCaveInfo:GetMineInfo(index)
end

local function InitConf(self)
  self.mineCaveConf = {}
  LocalController:instance():visitTable(TableName.MineCave, function(id, lineData)
    local item = MineCaveTemplate.New()
    item:InitData(lineData)
    table.insert(self.mineCaveConf, item)
  end)
end

local function CheckIfCanRefresh(self)
  local k4 = LuaEntry.DataConfig:TryGetNum("mine_cave", "k4")
  if self.mineCaveInfo and k4 > self.mineCaveInfo.refreshNum then
    return true
  else
    return false
  end
end

local function GetRefreshCost(self)
  if not self.refreshCost then
    self:InitRefreshCost()
  end
  local nextIndex = self.mineCaveInfo.refreshNum + 1
  for i, v in ipairs(self.refreshCost) do
    if nextIndex >= v[1] and nextIndex <= v[2] then
      return v[3], v[2]
    end
  end
  return self.refreshCost[#self.refreshCost][3]
end

local function InitRefreshCost(self)
  local k5 = LuaEntry.DataConfig:TryGetStr("mine_cave", "k5")
  if string.IsNullOrEmpty(k5) then
    k5 = "0;100;1"
  end
  local strCostArr = string.split(k5, "|")
  self.refreshCost = {}
  for i, v in ipairs(strCostArr) do
    local temp = string.split(v, ";")
    local cost = {}
    table.insert(cost, tonumber(temp[1]))
    table.insert(cost, tonumber(temp[2]))
    table.insert(cost, tonumber(temp[3]))
    table.insert(self.refreshCost, cost)
  end
end

local function ResetMineInfo(self, mineId)
  if not self.mineCaveInfo then
    return
  end
  self.mineCaveInfo:ResetMineInfo(mineId)
end

local function GetBattleParam(self)
  local formationUuid = self.dispatchFormationUid
  return self.attackMineIndex, formationUuid, self.attackMonsterId
end

local function SetAttackMineIndex(self, tempIndex, monsterId)
  self.attackMineIndex = tempIndex
  self.attackMonsterId = monsterId
end

local function SetDispatchFormation(self, formationUid)
  self.dispatchFormationUid = formationUid
end

local function CheckIfHeroIsBusy(self, heroId)
  if not self.mineCaveInfo or not self.mineCaveInfo.myMinesList then
    return false
  end
  for i, v in ipairs(self.mineCaveInfo.myMinesList) do
    for _, m in ipairs(v.heros) do
      if m.heroId == heroId then
        return true
      end
    end
  end
end

local function CheckIfCanAttack(self)
  if not self.mineCaveInfo then
    return false, 0
  end
  local curTime = UITimeManager:GetInstance():GetServerSeconds()
  local lastTime = self.mineCaveInfo.lastRefreshTime // 1000
  if not UITimeManager:GetInstance():IsSameDayForServer(lastTime, curTime) then
    local formationIds = DataCenter.ArmyFormationDataManager:GetArmyFormationIdList()
    return true, #formationIds
  end
  local tempTimes = self.mineCaveInfo.fightNum
  local addNum = LuaEntry.Effect:GetGameEffect(EffectDefine.REFRESH_MINE_CAVE_REFRESH_TIME_ADD)
  local maxTimes = LuaEntry.DataConfig:TryGetNum("mine_cave", "k3")
  if tempTimes >= maxTimes + addNum then
    return false, 0
  end
  local remainTimes = maxTimes + addNum - tempTimes
  local busyFormations = self.mineCaveInfo:GetBusyFormations()
  local formationIds = DataCenter.ArmyFormationDataManager:GetArmyFormationIdList()
  if #busyFormations >= #formationIds then
    return false, 0
  end
  local freeFormationCount = #formationIds - #busyFormations
  local freeNum = math.min(remainTimes, freeFormationCount)
  return true, freeNum
end

local function CheckIfHasReward(self)
  if not self.mineCaveInfo then
    return false, 0
  end
  local num = 0
  local serverT = UITimeManager:GetInstance():GetServerTime()
  for i, v in ipairs(self.mineCaveInfo.myMinesList) do
    if serverT >= v.endTime and not v.rewarded then
      num = num + 1
    end
  end
  return 0 < num, num
end

local function GetRedCount(self)
  local totalNum = 0
  local canAttack, redCount = self:CheckIfCanAttack()
  local canClaim, claimCount = self:CheckIfHasReward()
  local hasNewLog = self:CheckIfHasPlunderRed()
  if canAttack then
    totalNum = totalNum + redCount
  end
  if canClaim then
    totalNum = totalNum + claimCount
  end
  if hasNewLog then
    totalNum = totalNum + 1
  end
  return totalNum
end

local function CheckIfHasPlunderRed(self)
  local strKey = "GetPlunderLogTime_" .. LuaEntry.Player.uid
  local lastTime = CS.GameEntry.Setting:GetString(strKey, "0")
  local lastT = tonumber(lastTime)
  for i, v in pairs(self.plunderList) do
    if lastT < v.time and (v.plunderType == MineCavePlunderType.DefenseFail or v.plunderType == MineCavePlunderType.DefenseWin) then
      return true
    end
  end
end

local function ResetGetPlunderLogTime()
  local curTime = UITimeManager:GetInstance():GetServerTime()
  local strKey = "GetPlunderLogTime_" .. LuaEntry.Player.uid
  CS.GameEntry.Setting:SetString(strKey, tostring(curTime))
  EventManager:GetInstance():BroadcastDeferred(EventId.RefreshActivityRedDot)
end

local function UpdatePlunderList(self, msg)
  self.plunderList = {}
  if msg.records then
    for i, v in pairs(msg.records) do
      self:AddOneNewPlunderLog(v, false)
    end
    table.sort(self.plunderList, function(a, b)
      return a.time > b.time
    end)
    EventManager:GetInstance():Broadcast(EventId.OnRecvMineCavePlunderLog)
  end
end

local function OnRecvNewPlunderLog(self, msg)
  if msg.newRecord then
    self:AddOneNewPlunderLog(msg.newRecord)
  end
end

local function AddOneNewPlunderLog(self, tb, needBroadcast)
  needBroadcast = needBroadcast or true
  local newLog = {}
  newLog.uuid = tb.uuid
  newLog.playerUid = tb.playerUid
  newLog.playerName = tb.playerName
  newLog.playerAlAbbr = tb.playerAlAbbr
  newLog.plunderType = tb.type
  newLog.time = tb.time
  newLog.playerPic = tb.playerPic
  newLog.playerPicVer = tb.playerPicVer
  newLog.playerCareerType = tb.playerCareerType
  newLog.playerCareerLv = tb.playerCareerLv
  newLog.monthCardEndTime = tb.playerMonthCardEndTime
  
  function newLog:GetHeadBgImg()
    local headBgImg
    local serverTimeS = UITimeManager:GetInstance():GetServerSeconds()
    if self.monthCardEndTime and serverTimeS < self.monthCardEndTime then
      headBgImg = "Common_playerbg_golloes"
    end
    if headBgImg and headBgImg ~= "" then
      return string.format(LoadPath.CommonNewPath, headBgImg)
    end
  end
  
  if tb.type == 1 or tb.type == 3 then
    newLog.rewardType = tb.params.rewardType
    newLog.itemId = tb.params.itemId
    newLog.rewardNum = tb.params.plunderRewardNum
  end
  table.insert(self.plunderList, 1, newLog)
  if needBroadcast then
    EventManager:GetInstance():Broadcast(EventId.OnRecvMineCavePlunderLog)
  end
end

local function GetPlunderList(self)
  return self.plunderList
end

local function GetEnemyPlayerPower(self)
  return self.cachePveEnemyHeroPower
end

local function CheckIfEnemyIsPlayer(self)
  return self.cachePveEnemyHeroPower
end

local function SetEnemyPlayerPower(self, power)
  if string.IsNullOrEmpty(power) then
    self.cachePveEnemyHeroPower = nil
    return
  end
  self.cachePveEnemyHeroPower = {}
  if not string.IsNullOrEmpty(power) then
    local heroArr = string.split(power, "|")
    for i, v in ipairs(heroArr) do
      local powerArr = string.split(v, ";")
      if #powerArr == 2 then
        self.cachePveEnemyHeroPower[powerArr[1]] = tonumber(powerArr[2])
      end
    end
  end
end

local function CacheRewards(self, reward)
  self.cacheWinReward = reward
end

local function TryShowReward(self)
  if self.cacheWinReward then
    DataCenter.RewardManager:AddRewards(self.cacheWinReward)
    local msg = {}
    msg.reward = self.cacheWinReward
    DataCenter.RewardManager:ShowCommonReward(msg)
    self.cacheWinReward = nil
  end
end

local function CacheTargetMineInfo(self, mineInfo)
  self.cacheTargetMineInfo = mineInfo
end

local function CheckIfNeedPreloadEnemy(self)
  if not self.cacheTargetMineInfo or string.IsNullOrEmpty(self.cacheTargetMineInfo.ownerUid) then
    return true
  else
    return false
  end
end

MineCaveManager.__init = __init
MineCaveManager.__delete = __delete
MineCaveManager.UpdateMineCaveInfo = UpdateMineCaveInfo
MineCaveManager.GetMineCaveInfo = GetMineCaveInfo
MineCaveManager.GetPreviewList = GetPreviewList
MineCaveManager.InitConf = InitConf
MineCaveManager.CheckIfCanRefresh = CheckIfCanRefresh
MineCaveManager.GetRefreshCost = GetRefreshCost
MineCaveManager.InitRefreshCost = InitRefreshCost
MineCaveManager.GetMineConf = GetMineConf
MineCaveManager.GetMyCaveInfo = GetMyCaveInfo
MineCaveManager.GetMineInfo = GetMineInfo
MineCaveManager.ResetMineInfo = ResetMineInfo
MineCaveManager.GetBattleParam = GetBattleParam
MineCaveManager.SetAttackMineIndex = SetAttackMineIndex
MineCaveManager.CheckIfHeroIsBusy = CheckIfHeroIsBusy
MineCaveManager.CheckIfCanAttack = CheckIfCanAttack
MineCaveManager.GetRedCount = GetRedCount
MineCaveManager.CheckIfHasReward = CheckIfHasReward
MineCaveManager.UpdatePlunderList = UpdatePlunderList
MineCaveManager.OnRecvNewPlunderLog = OnRecvNewPlunderLog
MineCaveManager.AddOneNewPlunderLog = AddOneNewPlunderLog
MineCaveManager.GetPlunderList = GetPlunderList
MineCaveManager.GetEnemyPlayerPower = GetEnemyPlayerPower
MineCaveManager.SetEnemyPlayerPower = SetEnemyPlayerPower
MineCaveManager.CheckIfHasPlunderRed = CheckIfHasPlunderRed
MineCaveManager.ResetGetPlunderLogTime = ResetGetPlunderLogTime
MineCaveManager.CheckIfEnemyIsPlayer = CheckIfEnemyIsPlayer
MineCaveManager.CacheRewards = CacheRewards
MineCaveManager.TryShowReward = TryShowReward
MineCaveManager.AddListener = AddListener
MineCaveManager.RemoveListener = RemoveListener
MineCaveManager.TryReqUpdateMineCaveInfo = TryReqUpdateMineCaveInfo
MineCaveManager.SetDispatchFormation = SetDispatchFormation
MineCaveManager.CacheTargetMineInfo = CacheTargetMineInfo
MineCaveManager.CheckIfNeedPreloadEnemy = CheckIfNeedPreloadEnemy
MineCaveManager.GetToUnlockMinesInfo = GetToUnlockMinesInfo
MineCaveManager.UpdateToUnlockList = UpdateToUnlockList
MineCaveManager.GetMyScore = GetMyScore
return MineCaveManager
