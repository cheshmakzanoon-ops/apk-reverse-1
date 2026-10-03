local AllianceWarDataManager = BaseClass("AllianceWarDataManager")
local Localization = CS.GameEntry.Localization
local Setting = CS.GameEntry.Setting
local ResourceManager = CS.GameEntry.Resource

function AllianceWarDataManager:__init()
  self.AllianceWarList = {}
  self.alWarCount = 0
  self.hasNewWar = false
  self.ignoreList = {}
  self.warLoopState = false
  self.crossServer = {}
  self.alertNum = 0
  self.mainUIRallyTipNum = 0
  self.theOldestCanJoinRallyUuid = ""
  self.warRallyRewardIsLimit = {}
  self.warRallyRewardLimitTime = {}
  self.troopLineData = {}
  EventManager:GetInstance():AddListener(EventId.OnEnterWorld, self.OnEnterWorld)
  self.targetToAttackerPosMap = {}
  self.playerTargetUuidFlag = {}
  self.targetMineData = {}
end

function AllianceWarDataManager:__delete()
  self.AllianceWarList = nil
  self.alWarCount = nil
  self.hasNewWar = nil
  self.ignoreList = nil
  self.warLoopState = nil
  self.crossServer = nil
  self.alertNum = nil
  self.mainUIRallyTipNum = nil
  self.theOldestCanJoinRallyUuid = nil
  self.warRallyRewardIsLimit = nil
  self.warRallyRewardLimitTime = nil
  self.troopLineData = nil
  EventManager:GetInstance():RemoveListener(EventId.OnEnterWorld, self.OnEnterWorld)
  self.playerTargetUuidFlag = nil
  self.targetMineData = nil
  self.targetToAttackerPosMap = nil
end

function AllianceWarDataManager:ResetData()
  self.AllianceWarList = {}
  self.hasNewWar = false
  self.ignoreList = {}
  self.warLoopState = false
  self.crossServer = {}
  self.playerTargetUuidFlag = {}
  self.targetMineData = {}
  if self.troopLineData then
    for i, v in pairs(self.troopLineData) do
      v.loader:Destroy()
    end
  end
  self.troopLineData = {}
  self.targetToAttackerPosMap = {}
  self.warRallyRewardIsLimit = {}
  self.warRallyRewardLimitTime = {}
  if self.alertNum > 0 then
    self.alertNum = 0
    EventManager:GetInstance():Broadcast(EventId.UpdateAlertRedPoint)
  end
  if 0 < self.mainUIRallyTipNum then
    self.mainUIRallyTipNum = 0
    EventManager:GetInstance():BroadcastDeferred(EventId.UpdateMainUIRallyTipRedPoint)
  end
  self.theOldestCanJoinRallyUuid = ""
end

local function GetLastReadTimeS()
  local strKey = "lwalwarnts" .. LuaEntry.Player.uid .. LuaEntry.Player.allianceId
  return CS.GameEntry.Setting:GetInt(strKey, 0) * 1000
end

function AllianceWarDataManager:UpdateLastReadTimeS()
  if self.alertNum > 0 then
    self.alertNum = 0
    local strKey = "lwalwarrts" .. LuaEntry.Player.uid .. LuaEntry.Player.allianceId
    local curTime = UITimeManager:GetInstance():GetServerSeconds()
    CS.GameEntry.Setting:SetInt(strKey, curTime)
    EventManager:GetInstance():Broadcast(EventId.UpdateAlertRedPoint)
  end
end

function AllianceWarDataManager:CalculateAlertNum()
  local lastNum = self.alertNum
  self.alertNum = 0
  local lastRTS = GetLastReadTimeS()
  for _, v in pairs(self.AllianceWarList) do
    if v.targetAllianceId == LuaEntry.Player:GetAllianceUid() and lastRTS < v.createTime then
      self.alertNum = self.alertNum + 1
    end
  end
  if lastNum ~= self.alertNum then
    EventManager:GetInstance():Broadcast(EventId.UpdateAlertRedPoint)
  end
  self:CalculateMainUIRallyTipNum()
end

function AllianceWarDataManager:CalculateMainUIRallyTipNum()
  local lastNum = self.mainUIRallyTipNum
  self.mainUIRallyTipNum = 0
  self.theOldestCanJoinRallyUuid = ""
  local waitTimeTmp = math.maxinteger
  for _, v in pairs(self.AllianceWarList) do
    local canJoin, isSelf = self:CheckJoinAllianceWarByWarData(v)
    if canJoin == true or isSelf == true then
      self.mainUIRallyTipNum = self.mainUIRallyTipNum + 1
      if waitTimeTmp > v.waitTime then
        waitTimeTmp = v.waitTime
        self.theOldestCanJoinRallyUuid = v.uuid
      end
    end
  end
  if lastNum ~= self.mainUIRallyTipNum then
    EventManager:GetInstance():BroadcastDeferred(EventId.UpdateMainUIRallyTipRedPoint)
  end
end

function AllianceWarDataManager:InitAllianceWarList(message)
  if not self.initManager then
    self.initManager = true
    BaseBuildingEffectManager:GetInstance():Startup()
    WorldTroopEffectManager:GetInstance():Startup()
  end
  if message.teams ~= nil then
    if LuaEntry.Player:IsInSelfServer() then
      self.AllianceWarList = {}
      self:DeleteAllTroopLine()
      EventManager:GetInstance():Broadcast(EventId.AllianceWarDataInit)
    else
      local list = {}
      local newlist = self.AllianceWarList
      for i, v in pairs(self.AllianceWarList) do
        if v.server == LuaEntry.Player:GetCurServerId() then
          table.insert(list, v)
        end
      end
      self.AllianceWarList = {}
      for i, v in pairs(newlist) do
        local isInsert = true
        for k = 1, #list do
          if v.uuid == list[k].uuid then
            isInsert = false
          end
        end
        if isInsert then
          self.AllianceWarList[v.uuid] = v
        end
      end
    end
    table.walk(message.teams, function(k, v)
      self:UpdateOneAllianceWarList(v)
    end)
    self:CalculateAlertNum()
  end
end

function AllianceWarDataManager:GetAllianceWarIdList()
  local ret = table.keys(self.AllianceWarList)
  table.sort(ret, function(uuidA, uuidB)
    local warA = self.AllianceWarList[uuidA]
    local warB = self.AllianceWarList[uuidB]
    return warA.createTime < warB.createTime
  end)
  return ret
end

function AllianceWarDataManager:GetAllianceData()
  return self.AllianceWarList
end

function AllianceWarDataManager:CleanDragonWar()
  local dirtyList = {}
  local dirtyCount = 0
  for k, v in pairs(self.AllianceWarList) do
    if v.worldId ~= nil and 0 < v.worldId then
      dirtyList[k] = k
      dirtyCount = dirtyCount + 1
    end
  end
  if 0 < dirtyCount then
    for k, v in pairs(dirtyList) do
      self:DeleteAllianceWarDataByUuid(k)
    end
    if self.alWarCount and dirtyCount < self.alWarCount then
      self.alWarCount = self.alWarCount - dirtyCount
    end
    self:CalculateMainUIRallyTipNum()
  end
end

function AllianceWarDataManager:RemoveCanNotJoinDragonWar()
  local dirtyList = {}
  local dirtyCount = 0
  for k, v in pairs(self.AllianceWarList) do
    if v.worldId ~= nil and 0 < v.worldId and self:IsDragonWarAndCanNotJoinIt(v) then
      dirtyList[k] = k
      dirtyCount = dirtyCount + 1
    end
  end
  if 0 < dirtyCount then
    for k, v in pairs(dirtyList) do
      self:DeleteAllianceWarDataByUuid(k)
    end
    if self.alWarCount and dirtyCount < self.alWarCount then
      self.alWarCount = self.alWarCount - dirtyCount
    end
    self:CalculateMainUIRallyTipNum()
  end
end

function AllianceWarDataManager:IsDragonWarAndCanNotJoinIt(info)
  if info == nil then
    return true
  end
  if info.worldId ~= nil and info.worldId > 0 then
    if DataCenter.BuildManager.MainLv < EnumActivity.ActDragon.needMainCityLevel then
      return true
    end
    if BattleFieldUtil.InBattleField() or 0 < LuaEntry.Player:GetBattleFieldPos() then
      return false
    end
    local userInfo = DataCenter.ActDragonManager:GetPlayerInfoByUID(LuaEntry.Player:GetUid())
    if userInfo ~= nil and userInfo.state == 0 then
      return true
    end
    local baseData = DataCenter.AllianceBaseDataManager:GetAllianceBaseData()
    if baseData ~= nil then
      local joinHour = LuaEntry.DataConfig:TryGetNum("dragon_battle_base", "k7", 24)
      if baseData.joinTime ~= nil and baseData.joinTime ~= 0 and baseData.joinTime < joinHour * 3600000 then
        return true
      end
    end
  end
  return false
end

function AllianceWarDataManager:UpdateOneAllianceWarList(message, isCreate)
  local info = AllianceWarInfo.New()
  info:ParseData(message)
  local oldWars = self:GetOldAllianceWars()
  if info.uuid ~= nil and info.uuid ~= "" then
    if self:IsDragonWarAndCanNotJoinIt(info) then
      return
    end
    if not table.hasvalue(oldWars, tostring(info.uuid)) then
      self.hasNewWar = true
    end
    EventManager:GetInstance():Broadcast(EventId.AllianceWarNewStatusChanged)
    if self:CheckPlayerInTeam(LuaEntry.Player.uid, info) then
      local preData = self.AllianceWarList[info.uuid]
      if preData and preData.leaderMarch.status ~= MarchStatus.MOVING and info.leaderMarch.status == MarchStatus.MOVING then
        UIUtil.ShowTips(Localization:GetString("match_assemble_tips01", info.leaderMarch.ownerName), nil, nil, nil, true)
      end
    end
    if info.leaderMarch.ownerUid == LuaEntry.Player.uid then
      self.playerTargetUuidFlag[info.targetUuid] = info.uuid
      if isCreate then
        self:CheckPlayPlot(info)
      end
    end
    local selfAllianceId = LuaEntry.Player.allianceId
    if info.targetUid == LuaEntry.Player.uid then
      self.targetMineData[info.uuid] = {
        point = info.targetPointId,
        server = info.server
      }
    end
    local targetUuid = info.targetUuid
    local refreshTroop = false
    local preData = self.targetToAttackerPosMap[targetUuid]
    if preData == nil or preData and not preData.isSelf then
      refreshTroop = true
      self.targetToAttackerPosMap[targetUuid] = {
        pointId = info.attackPointId,
        isSelf = info.leaderMarch.ownerUid == LuaEntry.Player.uid
      }
    end
    if refreshTroop and CS.SceneManager.World then
      local targetWorldTroop = CS.SceneManager.World:GetTroop(targetUuid)
      if targetWorldTroop then
        local targetMarchInfo = targetWorldTroop:GetMarchInfo()
        if targetMarchInfo and targetMarchInfo:IsWanderBoss() then
          targetWorldTroop:SetLookAt(SceneUtils.TileIndexToWorld(info.attackPointId), false)
        end
      end
    end
    self.AllianceWarList[info.uuid] = info
    EventManager:GetInstance():Broadcast(EventId.AllianceWarDataChange, {
      ownerUid = info.leaderMarch.ownerUid,
      pointId = info.attackPointId,
      targetUuid = info.targetUuid,
      targetMine = self:GetTargetMineCount() > 0,
      update = true
    })
    self:UpdateTroopLine(info.uuid)
  end
end

function AllianceWarDataManager:GetAllianceWarDataByUuid(Uuid)
  return self.AllianceWarList[Uuid]
end

function AllianceWarDataManager:GetAllianceWarDataByLeaderUid(uid)
  if self.AllianceWarList then
    local selfAllianceId = LuaEntry.Player.allianceId
    for i, v in pairs(self.AllianceWarList) do
      if v.leaderMarch.ownerUid == uid and selfAllianceId == v.attackAllianceId and v.leaderMarch.status ~= MarchStatus.MOVING then
        return v
      end
    end
  end
  return nil
end

function AllianceWarDataManager:TryJumpToCityGhost()
  local success = false
  if self.AllianceWarList then
    for i, v in pairs(self.AllianceWarList) do
      if v and v:IsTargetForCityGhost() then
        success = true
        v.clickBubbleTip = true
        v:TryJumpToTarget(true)
        break
      end
    end
  end
  return success
end

function AllianceWarDataManager:GetGhostTipNum()
  local num = 0
  if self.AllianceWarList then
    for i, v in pairs(self.AllianceWarList) do
      if v and v.clickBubbleTip ~= true and v:IsTargetForCityGhost() then
        num = num + 1
      end
    end
  end
  return num
end

function AllianceWarDataManager:GetAlertNum()
  return self.alertNum
end

function AllianceWarDataManager:GetMainUIRallyTipNum()
  return self.mainUIRallyTipNum
end

function AllianceWarDataManager:GetOldestCanJoinRallyUuid()
  return self.theOldestCanJoinRallyUuid
end

function AllianceWarDataManager:GetAllianceWarRed()
  local count = 0
  local list = self:GetAllianceWarIdList()
  for i = 1, #list do
    if self:CheckJoinAllianceWar(list[i]) then
      count = count + 1
    end
  end
  return count
end

function AllianceWarDataManager:CheckJoinAllianceWar(uuid)
  local data = self:GetAllianceWarDataByUuid(uuid)
  local canJoin, imLeader, inTeam, state = self:CheckJoinAllianceWarByWarData(data)
  return canJoin, imLeader, inTeam, state
end

function AllianceWarDataManager:CheckJoinAllianceWarByWarData(data)
  if data == nil then
    return false, false, false, 1
  end
  local self_uid = LuaEntry.Player.uid
  if data.leaderMarch.ownerUid == self_uid then
    return false, true, false, 2
  end
  local count = table.count(data.memberList) + 1
  if count >= data.assemblyMarchMax then
    return false, false, false, 3
  end
  if data.targetUid == self_uid then
    return false, false, true, 4
  end
  if BattleFieldUtil.InBattleField(BattleFieldType.EpidemicZone) then
    if BattleFieldUtil.IsBattleFieldEnemy(data.attackAllianceId, BattleFieldType.EpidemicZone) then
      return false, false, false, 5
    end
  elseif LuaEntry.Player.allianceId ~= data.attackAllianceId then
    return false, false, false, 6
  end
  local curTime = UITimeManager:GetInstance():GetServerTime()
  if not self:CheckAllianceWarData(data, curTime) then
    return false, false, false, 7
  end
  if not self:CheckRallyWaitStateTimeoutValid(data, curTime) then
    return false, false, false, 8
  end
  local inTeam = false
  table.walk(data.memberList, function(k, v)
    if v.ownerUid == self_uid then
      inTeam = true
    end
  end)
  return not inTeam, false, inTeam, 9
end

function AllianceWarDataManager:DeleteAllianceWarDataByUuid(Uuid)
  local preInfo = self.AllianceWarList[Uuid]
  self.AllianceWarList[Uuid] = nil
  self.targetMineData[Uuid] = nil
  self.targetToAttackerPosMap[preInfo.targetUuid] = nil
  self:DeleteTroopLine(Uuid)
  self.playerTargetUuidFlag[preInfo.targetUuid] = nil
  local oldWars = self:GetOldAllianceWars()
  local hasNewWar = false
  for i, v in pairs(self.AllianceWarList) do
    if not table.hasvalue(oldWars, tostring(i)) then
      hasNewWar = true
      break
    end
  end
  self.hasNewWar = hasNewWar
  self:CalculateAlertNum()
  EventManager:GetInstance():Broadcast(EventId.AllianceWarNewStatusChanged)
  if preInfo then
    EventManager:GetInstance():Broadcast(EventId.AllianceWarDataChange, {
      ownerUid = preInfo.leaderMarch.ownerUid,
      pointId = preInfo.attackPointId,
      targetUuid = preInfo.targetUuid,
      targetMine = self:CheckTargetMine(),
      update = false
    })
  end
end

function AllianceWarDataManager:GetShowListDataCount()
  local allWarList = self.AllianceWarList
  local count = 0
  local curTime = UITimeManager:GetInstance():GetServerTime()
  for key, warData in pairs(allWarList) do
    if DataCenter.AllianceWarDataManager:CheckAllianceWarData(warData, curTime) then
      count = count + 1
    end
  end
  return count
end

function AllianceWarDataManager:GetAllianceWarCount()
  return self.alWarCount
end

function AllianceWarDataManager:AddAllianceWarCount()
  if self.alWarCount then
    self.alWarCount = self.alWarCount + 1
  end
end

function AllianceWarDataManager:ReduceAllianceWarCount()
  if self.alWarCount then
    self.alWarCount = self.alWarCount - 1
  end
end

function AllianceWarDataManager:SetAllianceWarCount(count)
  if 0 < count then
    self.alWarCount = count
  else
    self.alWarCount = 0
  end
end

function AllianceWarDataManager:CheckIfHasNewWar()
  return self.hasNewWar
end

function AllianceWarDataManager:OpenALWarMain(hideTop, ...)
  UIManager:GetInstance():OpenWindow(UIWindowNames.UIAllianceWarMainTable, {
    anim = true,
    UIMainAnim = UIMainAnimType.LeftRightBottomHide,
    hideTop = hideTop
  }, ...)
end

function AllianceWarDataManager:CloseALWarMain()
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UIAllianceWarMainTable, {
    anim = true,
    UIMainAnim = UIMainAnimType.AllShow
  })
end

function AllianceWarDataManager:SetAllAllianceWarOld()
  local oldWars = ""
  for i, v in pairs(self.AllianceWarList) do
    if oldWars == "" then
      oldWars = i
    else
      oldWars = oldWars .. "," .. i
    end
  end
  Setting:SetString(SettingKeys.ALLIANCE_WAR_OLD_DATA, oldWars)
  self.hasNewWar = false
  EventManager:GetInstance():Broadcast(EventId.AllianceWarNewStatusChanged)
end

function AllianceWarDataManager:GetOldAllianceWars()
  local strWars = Setting:GetString(SettingKeys.ALLIANCE_WAR_OLD_DATA, "")
  local oldWars = string.split(strWars, ",")
  return oldWars
end

function AllianceWarDataManager:SetIgnoreList(uuid, state)
  self.ignoreList[uuid] = state
end

function AllianceWarDataManager:GetIgnoreList(uuid)
  return self.ignoreList[uuid]
end

local function IsRadarRallyActivityAllianceWar(info, maxDistance)
  if info.type ~= AllianceTeamType.ATTACK_BOSS then
    return false
  end
  if table.count(info.memberList) + 1 >= info.assemblyMarchMax then
    return false
  end
  if info.attackUid == LuaEntry.Player.uid then
    return false
  end
  for _, member in pairs(info.memberList) do
    if member.ownerUid == LuaEntry.Player.uid then
      return false
    end
  end
  local curTime = UITimeManager:GetInstance():GetServerTime()
  if not DataCenter.AllianceWarDataManager:CheckAllianceWarData(info, curTime) then
    return false
  end
  local distance = SceneUtils.TileDistanceToMyHome(info.attackPointId)
  if maxDistance < distance then
    return false
  end
  return true
end

function AllianceWarDataManager:GetRadarRallyActivityAllianceWars(maxDistance)
  local list = {}
  for _, info in pairs(self.AllianceWarList) do
    if IsRadarRallyActivityAllianceWar(info, maxDistance) then
      table.insert(list, info)
    end
  end
  table.sort(list, function(infoA, infoB)
    local distanceA = SceneUtils.TileDistanceToMyHome(infoA.attackPointId)
    local distanceB = SceneUtils.TileDistanceToMyHome(infoB.attackPointId)
    return distanceA < distanceB
  end)
  return list
end

function AllianceWarDataManager:SetState(state)
  self.warLoopState = state
end

function AllianceWarDataManager:GetState()
  return self.warLoopState
end

function AllianceWarDataManager:GetWarningType(march)
  local marchTargetType = march:GetMarchTargetType()
  local targetUuid = march.targetUuid
  if marchTargetType == MarchTargetType.RALLY_FOR_BUILDING or marchTargetType == MarchTargetType.ATTACK_BUILDING then
    if DataCenter.BuildManager:GetBuildingDataByUuid(targetUuid) ~= nil then
      return WarningType.Attack
    end
  elseif marchTargetType == MarchTargetType.ATTACK_CITY or marchTargetType == MarchTargetType.ATTACK_WINTER_STORM_CITY or marchTargetType == MarchTargetType.ATTACK_EPIDEMIC_CITY then
    local buildingData = DataCenter.BuildManager:GetBuildingDataByUuid(targetUuid)
    if buildingData ~= nil and buildingData.itemId == BuildingTypes.FUN_BUILD_MAIN then
      return WarningType.Attack
    end
  elseif marchTargetType == MarchTargetType.ATTACK_ARMY or marchTargetType == MarchTargetType.ATTACK_ARMY_COLLECT then
    return WarningType.Attack
  elseif marchTargetType == MarchTargetType.ATTACK_ROAD then
    if DataCenter.BoardManager:GetBoardData(targetUuid) ~= nil then
      return WarningType.Attack
    end
  elseif marchTargetType == MarchTargetType.SCOUT_BUILDING then
    if DataCenter.BuildManager:GetBuildingDataByUuid(targetUuid) ~= nil then
      return WarningType.Scout
    end
  elseif marchTargetType == MarchTargetType.SCOUT_CITY or marchTargetType == MarchTargetType.SCOUT_WINTER_STORM_CITY or marchTargetType == MarchTargetType.SCOUT_EPIDEMIC_CITY then
    local buildingData = DataCenter.BuildManager:GetBuildingDataByUuid(targetUuid)
    if buildingData ~= nil and buildingData.itemId == BuildingTypes.FUN_BUILD_MAIN then
      return WarningType.Scout
    end
  elseif marchTargetType == MarchTargetType.SCOUT_ARMY_COLLECT or marchTargetType == MarchTargetType.SCOUT_TROOP then
    return WarningType.Scout
  elseif marchTargetType == MarchTargetType.ASSISTANCE_BUILD then
    if DataCenter.BuildManager:GetBuildingDataByUuid(targetUuid) ~= nil then
      return WarningType.Assistance
    end
  elseif marchTargetType == MarchTargetType.ASSISTANCE_CITY or marchTargetType == MarchTargetType.ASSISTANCE_WINTER_STORM_CITY or marchTargetType == MarchTargetType.ASSISTANCE_EPIDEMIC_CITY then
    local buildingData = DataCenter.BuildManager:GetBuildingDataByUuid(targetUuid)
    if buildingData ~= nil and buildingData.itemId == BuildingTypes.FUN_BUILD_MAIN then
      return WarningType.Assistance
    end
  elseif marchTargetType == MarchTargetType.RESOURCE_HELP and DataCenter.BuildManager:GetBuildingDataByUuid(targetUuid) ~= nil then
    return WarningType.Assistance
  end
end

function AllianceWarDataManager:ParseServerId(message)
  local isInsert = true
  if self.crossServer then
    for i = 1, #self.crossServer do
      if self.crossServer[i] == message.server then
        isInsert = false
      end
    end
  end
  if isInsert then
    table.insert(self.crossServer, message.server)
  end
  if message.server == LuaEntry.Player:GetCurServerId() then
    SFSNetwork.SendMessage(MsgDefines.GetAllianceWarList, LuaEntry.Player:GetCurServerId())
  end
  EventManager:GetInstance():Broadcast(EventId.CrossServerWar, message.server)
end

function AllianceWarDataManager:AddCrossServer(serverId)
  local isInsert = true
  if self.crossServer then
    for i = 1, #self.crossServer do
      if self.crossServer[i] == serverId then
        isInsert = false
      end
    end
  end
  if isInsert then
    table.insert(self.crossServer, serverId)
  end
end

function AllianceWarDataManager:GetCrossServer()
  local list = self.crossServer
  for i = 1, #list do
    if list[i] == LuaEntry.Player:GetCurServerId() then
      table.remove(list, i)
      break
    end
  end
  return list
end

function AllianceWarDataManager:CheckAllianceWarData(data, curTime)
  return self:GetAllianceWarDurationSec(data, curTime) > 0
end

function AllianceWarDataManager:CheckRallyWaitStateTimeoutValid(data, curTime)
  if not data then
    return false
  end
  if not data.waitTime or data.waitTime < 9527 then
    return true
  end
  return curTime <= data.waitTime
end

function AllianceWarDataManager:GetAllianceWarDurationSec(data, curTime)
  if data.leaderMarch and data.leaderMarch.status ~= MarchStatus.STATION and data.leaderMarch.status ~= MarchStatus.WAIT_RALLY then
    return -1
  end
  local curTimeS = math.modf(curTime / 1000)
  local waitTimeS = math.modf(data.waitTime / 1000)
  local marchTimeS = math.modf(data.marchTime / 1000)
  if curTimeS < waitTimeS then
    return waitTimeS - curTimeS
  elseif curTimeS < marchTimeS then
    return marchTimeS - curTimeS
  else
    return -1
  end
end

function AllianceWarDataManager:GetCrossServerNum()
  local count = 0
  if self.crossServer then
    for i = 1, #self.crossServer do
      if self.crossServer[i] ~= LuaEntry.Player:GetCurServerId() then
        count = count + 1
      end
    end
    return count
  end
  return 0
end

function AllianceWarDataManager:ClearCrossServer(serverId)
  for i = 1, #self.crossServer do
    if self.crossServer[i] == serverId then
      table.remove(self.crossServer, i)
      break
    end
  end
  EventManager:GetInstance():Broadcast(EventId.CrossServerWar)
end

function AllianceWarDataManager:GetSelfWarList()
  local list = {}
  local selfUid = LuaEntry.Player.uid
  if self.AllianceWarList then
    for _, info in pairs(self.AllianceWarList) do
      if info.leaderMarch.ownerUid == selfUid then
        table.insert(list, info)
      end
    end
  end
  return list
end

function AllianceWarDataManager:AddTroopLine(uuid, startPos, endPos, startServer, endServer)
  if self.troopLineData[uuid] then
    Logger.LogError("already contain, uuid: " .. uuid)
    return
  end
  local loader = ResourceManager:InstantiateAsync(CS.GameDefines.EntityAssets.TroopLineDrag)
  local data = {}
  self.troopLineData[uuid] = data
  data.uuid = uuid
  data.loader = loader
  loader:completed("+", function()
    if loader.isError then
      return
    end
    loader.gameObject:SetActive(true)
    loader.gameObject.transform:SetParent(CS.SceneManager.World.DynamicObjNode)
    self.simpleAnim = loader.gameObject:GetComponent(typeof(CS.SimpleAnimation))
    if self.simpleAnim then
      self.simpleAnim:Play("Default")
    end
    local troopLine = loader.gameObject:GetComponent(typeof(CS.WorldTroopLine))
    if troopLine ~= nil then
      troopLine:SetDragPath(SceneUtils.TileIndexToWorld(startPos, ForceChangeScene.World, startServer), SceneUtils.TileIndexToWorld(endPos, ForceChangeScene.World, endServer))
    end
  end)
end

function AllianceWarDataManager:UpdateTroopLine(uuid)
  if SceneUtils.GetIsInWorld() then
    local data = self.AllianceWarList[uuid]
    local selfUid = LuaEntry.Player.uid
    if data.leaderMarch.ownerUid == selfUid then
      local curTime = UITimeManager:GetInstance():GetServerTime()
      local curTimeS = math.modf(curTime / 1000)
      local marchTimeS = math.modf(data.marchTime / 1000)
      if curTimeS < marchTimeS then
        if not self.troopLineData[uuid] then
          local loginServerId = LuaEntry.Player:GetSelfServerId()
          self:AddTroopLine(data.uuid, data.attackPointId, data.targetPointId, loginServerId, loginServerId)
        else
          local loader = self.troopLineData[uuid].loader
          if loader and loader.gameObject then
            local troopLine = loader.gameObject:GetComponent(typeof(CS.WorldTroopLine))
            if troopLine ~= nil then
              troopLine:SetDragPath(SceneUtils.TileIndexToWorld(data.attackPointId), SceneUtils.TileIndexToWorld(data.targetPointId))
            end
          end
        end
      elseif self.troopLineData[uuid] then
        self:DeleteTroopLine(data.uuid)
      end
    end
  end
end

function AllianceWarDataManager:DeleteTroopLine(uuid)
  if not self.troopLineData[uuid] then
    return
  end
  local data = self.troopLineData[uuid]
  self.troopLineData[uuid] = nil
  data.loader:Destroy()
end

function AllianceWarDataManager:OnEnterWorld()
  local self = DataCenter.AllianceWarDataManager
  if self.troopLineData and table.count(self.troopLineData) > 0 then
    for i, v in pairs(self.troopLineData) do
      v.loader:Destroy()
    end
    self.troopLineData = {}
  end
  local list = self:GetSelfWarList()
  for i, v in pairs(list) do
    self:AddTroopLine(v.uuid, v.attackPointId, v.targetPointId)
  end
end

function AllianceWarDataManager:OnExitWorld()
  self:DeleteAllTroopLine()
end

function AllianceWarDataManager:DeleteAllTroopLine()
  if self.troopLineData then
    for i, v in pairs(self.troopLineData) do
      v.loader:Destroy()
    end
    self.troopLineData = {}
  end
end

function AllianceWarDataManager:CheckPlayerInTeam(uid, data)
  if data.leaderMarch.ownerUid == uid then
    return true
  end
  if data.memberList then
    for i, v in pairs(data.memberList) do
      if v.ownerUid == uid then
        return true
      end
    end
  end
  return false
end

function AllianceWarDataManager:GetPlayerLeaderWar(targetUuid)
  return self.playerTargetUuidFlag[targetUuid]
end

function AllianceWarDataManager:CheckTargetMine()
  if not self.targetMineData then
    return false
  end
  local player = LuaEntry.Player
  if not player then
    return false
  end
  local playerPointId = player:GetMainWorldPos()
  local playerServer = player:GetServerId()
  for _, value in pairs(self.targetMineData) do
    local _point = value.point
    local _server = value.server
    if _point == playerPointId and _server == playerServer then
      return true
    end
  end
  return false
end

function AllianceWarDataManager:GetTargetMineCount()
  local ct = 0
  if not self.targetMineData then
    return ct
  end
  local player = LuaEntry.Player
  if not player then
    return 0
  end
  local playerPointId = player:GetMainWorldPos()
  local playerServer = player:GetServerId()
  for _, value in pairs(self.targetMineData) do
    local _point = value.point
    local _server = value.server
    if _point == playerPointId and _server == playerServer then
      ct = ct + 1
    end
  end
  return ct
end

function AllianceWarDataManager:CheckPlayPlot(info)
  if CS.SceneManager.World == nil then
    return
  end
  local uuid = info.targetUuid
  local troop = CS.SceneManager.World:GetTroop(uuid)
  if troop then
    local marchInfo = troop:GetMarchInfo()
    if marchInfo and marchInfo:IsWanderBoss() then
      local monsterId = marchInfo.monsterId
      local plotId = GetTableData(LuaEntry.Player:GetABTestTableName(TableName.Monster), monsterId, "attacked_plot")
      if plotId then
        local bubbleParams = {}
        bubbleParams.plotGroupId = plotId
        local targetPos = troop:GetPosition()
        bubbleParams.anchor = Vector3.New(targetPos.x, targetPos.y + 3.7, targetPos.z)
        bubbleParams.mode = "3D"
        EventManager:GetInstance():Broadcast(EventId.PlayPlotBubbleRandomly, bubbleParams)
      end
      Logger.Log("CheckPlayPlot : " .. plotId)
    end
  end
end

function AllianceWarDataManager:GetTroopTargetPointId(uuid)
  if self.targetToAttackerPosMap[uuid] then
    return self.targetToAttackerPosMap[uuid].pointId
  end
  return -1
end

function AllianceWarDataManager:CheckIsPopRewardLimitMonster(monsterId)
  local monster_cfg = DataCenter.MonsterTemplateManager:GetMonsterTemplate(monsterId)
  if monster_cfg then
    local special_type = monster_cfg.special
    if special_type == 0 then
      local type = monster_cfg.type
      if type == 3 or type == 17 or type == 21 then
        return true
      end
    elseif special_type == 6 then
      return true
    end
    return false
  else
    return false
  end
end

function AllianceWarDataManager:GetWarRallyRewardIsLimit(targetSpecialType, targetUid, targetUuid)
  local last_record_state = self.warRallyRewardIsLimit[targetSpecialType]
  local last_record_time = self.warRallyRewardLimitTime[targetSpecialType] or -1
  if 0 <= last_record_time and last_record_time < UITimeManager:GetInstance():GetTodayZero() then
    self:RequestWarRallyRewardIsLimit(targetUid, targetUuid)
    return true, nil
  elseif last_record_state == nil or last_record_state == false then
    self:RequestWarRallyRewardIsLimit(targetUid, targetUuid)
    return true, nil
  else
    return false, true
  end
end

function AllianceWarDataManager:RequestWarRallyRewardIsLimit(uid, uuid)
  SFSNetwork.SendMessage(MsgDefines.DailyAssistKillGainRemainCountInfo, uid, uuid)
end

function AllianceWarDataManager:UpdateWarRallyRewardLimit(targetSpecialType, isLimit)
  self.warRallyRewardIsLimit[targetSpecialType] = isLimit
  self.warRallyRewardLimitTime[targetSpecialType] = UITimeManager:GetInstance():GetServerTime()
end

return AllianceWarDataManager
