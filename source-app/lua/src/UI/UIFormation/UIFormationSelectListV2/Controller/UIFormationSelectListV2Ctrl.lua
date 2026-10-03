local UIFormationSelectListV2Ctrl = BaseClass("UIFormationSelectListV2Ctrl", UIBaseCtrl)
local Localization = CS.GameEntry.Localization
local WAIT_RALLY = MarchStatus.WAIT_RALLY
local IN_TEAM = MarchStatus.IN_TEAM

local function CloseSelf(self)
  self.closing = nil
  if self.delayTimer ~= nil then
    self.delayTimer:Stop()
    self.delayTimer = nil
  end
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UIFormationSelectListV2)
  local world = CS.SceneManager.World
  if world then
    world:StopCameraMove()
  end
end

local function Close(self)
  UIManager:GetInstance():DestroyWindowByLayer(UILayer.Normal)
end

local function InitData(self, formationType, marchTargetType, pointIndex, uuid, index, backHome, rallyType, targetServerId, monsterSpecialType, defaultMarchIndex)
  self.currentFormationUuid = 0
  self.formationType = tonumber(formationType) or 1
  self.targetType = tonumber(marchTargetType) or -1
  self.targetPoint = tonumber(pointIndex) or -1
  self.targetUuid = tonumber(uuid) or 0
  self.timeIndex = -1
  self.autoBackHome = tonumber(backHome) or MarchAutoBackType.Back
  self.directionWaitResult = false
  self.selectFormationUuid = 0
  self.targetServerId = tonumber(targetServerId) or -1
  self.monsterSpecialType = monsterSpecialType
  self.uuid = uuid
  self.defaultMarchIndex = defaultMarchIndex or -1
  self.rallyType = tonumber(rallyType) or nil
  self:InitRallyTime(nil)
  self:InitMarchSpeed()
  self.isTargetMoving = false
  local marchInfo = DataCenter.WorldMarchDataManager:GetMarch(self.targetUuid)
  if marchInfo then
    if marchInfo:IsWanderMonster() then
      self.isTargetMoving = true
    elseif marchInfo:GetMarchType() == NewMarchType.RUNNING_BOSS then
      local monsterMeta = DataCenter.MonsterTemplateManager:GetMonsterTemplate(marchInfo.monsterId)
      if monsterMeta and (monsterMeta.special == WorldMonsterSpecialType.GoldenBeetleBoss or monsterMeta.special == WorldMonsterSpecialType.AllyDrillCow) then
        self.isTargetMoving = true
      end
    end
  end
  if self.isTargetMoving then
    self.targetPoint = SceneUtils.WorldToTileIndex(marchInfo:GetMarchCurPos(), ForceChangeScene.World)
  end
end

function UIFormationSelectListV2Ctrl:RefreshTargetPoint()
  if self.isTargetMoving then
    local marchInfo = DataCenter.WorldMarchDataManager:GetMarch(self.targetUuid)
    if marchInfo then
      self.targetPoint = SceneUtils.WorldToTileIndex(marchInfo:GetMarchCurPos(), ForceChangeScene.World)
    end
  end
end

function UIFormationSelectListV2Ctrl:InitRallyTime(theSoldierType)
  self.RallyTimeList = {}
  self.ServerIndex2Time = {}
  local k = {
    [1] = LuaEntry.DataConfig:TryGetStr("world_rally", "k1", 5),
    [2] = LuaEntry.DataConfig:TryGetStr("world_rally", "k2", 10),
    [3] = LuaEntry.DataConfig:TryGetStr("world_rally", "k3", 30),
    [4] = LuaEntry.DataConfig:TryGetStr("world_rally", "k4", 60),
    [5] = LuaEntry.DataConfig:TryGetStr("world_rally", "k5", 1),
    [6] = LuaEntry.DataConfig:TryGetStr("world_rally", "k6", 15),
    [7] = LuaEntry.DataConfig:TryGetStr("world_rally", "k7", 3)
  }
  if theSoldierType == SoldierType.Mummy then
    self.ShowIndex2ServerIndex = {
      [1] = 5,
      [2] = 1,
      [3] = 2,
      [4] = 3
    }
  elseif self.targetType == MarchTargetType.RALLY_FOR_BOSS or self.targetType == MarchTargetType.RALLY_SANDWORM or self.targetType == MarchTargetType.RALLY_MUMMY then
    self.ShowIndex2ServerIndex = {
      [1] = 5,
      [2] = 1,
      [3] = 2,
      [4] = 3
    }
    local marchData = CS.SceneManager.World:GetMarch(self.uuid)
    if marchData and marchData.monsterId then
      local meta = DataCenter.MonsterTemplateManager:GetMonsterTemplate(marchData.monsterId)
      if meta.special == WorldMonsterSpecialType.AllyDrill then
        self.ShowIndex2ServerIndex = {
          [1] = 7
        }
        self.specialType = WorldMonsterSpecialType.AllyDrill
      elseif meta.special == WorldMonsterSpecialType.AllyDrillHugeSandWorm then
        self.ShowIndex2ServerIndex = {
          [1] = 7
        }
        self.specialType = WorldMonsterSpecialType.AllyDrillHugeSandWorm
      elseif meta.special == WorldMonsterSpecialType.AllyDrillRoadHog then
        self.ShowIndex2ServerIndex = {
          [1] = 7
        }
        self.specialType = WorldMonsterSpecialType.AllyDrillRoadHog
      elseif meta.special == WorldMonsterSpecialType.ZoneMobilizationBoss then
        self.ShowIndex2ServerIndex = {
          [1] = 5,
          [2] = 7
        }
        self.specialType = WorldMonsterSpecialType.ZoneMobilizationBoss
      elseif meta.special == WorldMonsterSpecialType.SuperRunningBoss then
        local times = LuaEntry.DataConfig:TryGetStr("running_boss", "k2", "k1")
        if string.IsNullOrEmpty(times) then
          times = "k1"
        end
        local delimiter = ","
        local tableResult = self:SplitStringToTable(times, delimiter)
        self.ShowIndex2ServerIndex = {}
        for i, v in ipairs(tableResult) do
          if v == "k1" then
            table.insert(self.ShowIndex2ServerIndex, 1)
          elseif v == "k2" then
            table.insert(self.ShowIndex2ServerIndex, 2)
          elseif v == "k3" then
            table.insert(self.ShowIndex2ServerIndex, 3)
          elseif v == "k4" then
            table.insert(self.ShowIndex2ServerIndex, 4)
          elseif v == "k5" then
            table.insert(self.ShowIndex2ServerIndex, 5)
          elseif v == "k6" then
            table.insert(self.ShowIndex2ServerIndex, 6)
          elseif v == "k7" then
            table.insert(self.ShowIndex2ServerIndex, 7)
          end
        end
        self.specialType = WorldMonsterSpecialType.SuperRunningBoss
      elseif meta.special == WorldMonsterSpecialType.AL_CHALLENGE_BOSS_KIROV then
        self.specialType = WorldMonsterSpecialType.AL_CHALLENGE_BOSS_KIROV
        local times = LuaEntry.DataConfig:TryGetStr("advanced_challenge", "k4", "k1")
        if string.IsNullOrEmpty(times) then
          times = "k1"
        end
        local delimiter = ","
        local tableResult = self:SplitStringToTable(times, delimiter)
        self.ShowIndex2ServerIndex = {}
        for i, v in ipairs(tableResult) do
          if v == "k1" then
            table.insert(self.ShowIndex2ServerIndex, 1)
          elseif v == "k2" then
            table.insert(self.ShowIndex2ServerIndex, 2)
          elseif v == "k3" then
            table.insert(self.ShowIndex2ServerIndex, 3)
          elseif v == "k4" then
            table.insert(self.ShowIndex2ServerIndex, 4)
          elseif v == "k5" then
            table.insert(self.ShowIndex2ServerIndex, 5)
          elseif v == "k6" then
            table.insert(self.ShowIndex2ServerIndex, 6)
          elseif v == "k7" then
            table.insert(self.ShowIndex2ServerIndex, 7)
          end
        end
      elseif meta.special == WorldMonsterSpecialType.ALLIANCE_BOSS_S0 then
        local time = LuaEntry.DataConfig:TryGetNum("s0_alliance_boss", "k21")
        self.ShowIndex2ServerIndex = {
          [1] = time
        }
        self.specialType = WorldMonsterSpecialType.ALLIANCE_BOSS_S0
      end
    end
  elseif self.targetType == MarchTargetType.JOIN_RALLY then
    self.ShowIndex2ServerIndex = {
      [1] = 1,
      [2] = 2,
      [3] = 3,
      [4] = 4
    }
    if self.monsterSpecialType == WorldMonsterSpecialType.AllyDrill then
      self.ShowIndex2ServerIndex = {
        [1] = 7
      }
      self.specialType = WorldMonsterSpecialType.AllyDrill
    elseif self.monsterSpecialType == WorldMonsterSpecialType.AllyDrillHugeSandWorm then
      self.ShowIndex2ServerIndex = {
        [1] = 7
      }
      self.specialType = WorldMonsterSpecialType.AllyDrillHugeSandWorm
    elseif self.monsterSpecialType == WorldMonsterSpecialType.AllyDrillRoadHog then
      self.ShowIndex2ServerIndex = {
        [1] = 7
      }
      self.specialType = WorldMonsterSpecialType.AllyDrillRoadHog
    elseif self.monsterSpecialType == WorldMonsterSpecialType.ALLIANCE_BOSS_S0 then
      local time = LuaEntry.DataConfig:TryGetNum("s0_alliance_boss", "k21")
      self.ShowIndex2ServerIndex = {
        [1] = time
      }
      self.specialType = WorldMonsterSpecialType.ALLIANCE_BOSS_S0
    end
  else
    self.ShowIndex2ServerIndex = {
      [1] = 1,
      [2] = 2,
      [3] = 3,
      [4] = 4
    }
  end
  for i = 1, #self.ShowIndex2ServerIndex do
    self.RallyTimeList[i] = k[self.ShowIndex2ServerIndex[i]]
    self.ServerIndex2Time[self.ShowIndex2ServerIndex[i]] = tonumber(self.RallyTimeList[i])
  end
end

local function SplitStringToTable(self, inputStr, delimiter)
  local result = {}
  for word in string.gmatch(inputStr, "([^" .. delimiter .. "]+)") do
    table.insert(result, word)
  end
  return result
end

local function InitMarchSpeed(self)
  self.NormalSpeed = LuaEntry.DataConfig:TryGetNum("lw_armyspeed", "k1", 0.5)
  self.RallySpeed = LuaEntry.DataConfig:TryGetNum("lw_armyspeed", "k2", 4)
  self.RadarSpeed = self.NormalSpeed * LuaEntry.DataConfig:TryGetNum("lw_armyspeed", "k3", 3)
  self.ScoutSpeed = LuaEntry.DataConfig:TryGetNum("lw_armyspeed", "k4", 3)
  self.ActivitySpeed = LuaEntry.DataConfig:TryGetNum("lw_armyspeed", "k5", 1)
  self.ResHelpSpeed = LuaEntry.DataConfig:TryGetNum("lw_armyspeed", "k6", 1)
  self.DigIceSpeed = LuaEntry.DataConfig:TryGetNum("lw_armyspeed", "k8", 3)
  self.MummyJoinRallySpeed = LuaEntry.DataConfig:TryGetNum("lw_armyspeed", "k9", 8)
  self.MummyRallySpeed = LuaEntry.DataConfig:TryGetNum("lw_armyspeed", "k10", 2)
  self.MummyRallyBackSpeed = LuaEntry.DataConfig:TryGetNum("lw_armyspeed", "k11", 2)
  self.AttackDesertSpeed = LuaEntry.DataConfig:TryGetNum("lw_season_armyspeed", "k1", 1)
  self.AssistanceDesertSpeed = LuaEntry.DataConfig:TryGetNum("lw_season_armyspeed", "k2", 3)
  self.TrainDesertSpeed = LuaEntry.DataConfig:TryGetNum("lw_season_armyspeed", "k4", 1)
  self.AttackAlliBuildSpeed = LuaEntry.DataConfig:TryGetNum("lw_season_armyspeed", "k5", 1)
  self.RallyAlliBuildSpeed = LuaEntry.DataConfig:TryGetNum("lw_season_armyspeed", "k6", 3)
  self.AssistanceAlliBuildSpeed = LuaEntry.DataConfig:TryGetNum("lw_season_armyspeed", "k8", 3)
  self.AssistanceAlliBuildSpeed = LuaEntry.DataConfig:TryGetNum("lw_season_armyspeed", "k8", 3)
  self.WhistleSpeedAdd = LuaEntry.DataConfig:TryGetNum("s4_whistle", "k1", 0.5)
end

local function InitScoutData(self)
end

local function GetAllScoutFormations(self)
  local formations = DataCenter.ArmyFormationDataManager:GetInvestigateFormationList()
  table.sort(formations, function(a, b)
    if a.index ~= b.index then
      return a.index < b.index
    else
      return false
    end
  end)
  return formations
end

local function GetInvesFormationUnlockLv(self, formationIndex)
  local unlockLv = self.InvesFormationUnlockLvs[formationIndex]
  return unlockLv and unlockLv or 0
end

local function GetInvesFormationInfoByIndex(self, tempIndex)
  local retParam = {}
  local tempFormationInfo = DataCenter.ArmyFormationDataManager:GetInvestigateFormationInfoByIndex(tempIndex)
  retParam.FormationInfo = tempFormationInfo
  if tempFormationInfo and tempFormationInfo.state == 1 then
    local marchInfo = DataCenter.WorldMarchDataManager:GetOwnerFormationMarch(LuaEntry.Player.uid, tempFormationInfo.uuid, LuaEntry.Player.allianceId)
    retParam.MarchInfo = marchInfo
  else
    retParam.MarchInfo = nil
  end
  return retParam
end

local function GetAllMarch(self)
  local allMarch = {}
  local allianceId = LuaEntry.Player.allianceId
  local selfMarch = DataCenter.WorldMarchDataManager:GetOwnerMarches(LuaEntry.Player.uid, allianceId)
  if selfMarch ~= nil then
    table.walk(selfMarch, function(k, v)
      if v:GetMarchStatus() ~= MarchStatus.IN_TEAM then
        table.insert(allMarch, v)
      else
        local march = DataCenter.WorldMarchDataManager:GetAllianceMarchesInTeam(allianceId, v.teamUuid)
        if march ~= nil then
          table.insert(allMarch, march)
        end
      end
    end)
  end
  return allMarch
end

local function GetScoutSpeed(self, targetPointID, formationIndex, targetServerId)
  local formation = self:GetInvesFormationInfoByIndex(formationIndex)
  local uuid = formation.FormationInfo.uuid
  local extraSpeed = DataCenter.ArmyFormationDataManager:GetEffectResult(uuid, EffectDefine.DETECT_ARMY_SPEED)
  local curSpeed = self.ScoutSpeed * (1 + extraSpeed / 100)
  curSpeed = curSpeed * (1 + DataCenter.ArmyFormationDataManager:GetEffectResult(uuid, EffectDefine.LW_SCOUT_SPEED_30502))
  return curSpeed
end

local function GetInvesDistance(self, targetPointID, formationIndex, targetServerId)
  local startPointID = self:GetScoutStartPoint(formationIndex)
  local distance = Vector3.Distance(SceneUtils.TileIndexToWorld(startPointID, ForceChangeScene.World, LuaEntry.Player:GetSelfServerId()), SceneUtils.TileIndexToWorld(targetPointID, ForceChangeScene.World, targetServerId))
  distance = distance / CS.SceneManager.World.TileSize
  return distance
end

local function GetScoutStartPoint(self, formationIndex)
  local startPointID = 0
  if formationIndex then
    local tempFormationInfo = self:GetInvesFormationInfoByIndex(formationIndex)
    local formationUuid = tempFormationInfo.FormationInfo.uuid
    local march = DataCenter.WorldMarchDataManager:GetOwnerFormationMarch(LuaEntry.Player.uid, formationUuid, LuaEntry.Player.allianceId)
    if march ~= nil then
      local troop = CS.SceneManager.World:GetTroop(march.uuid)
      if troop ~= nil then
        startPointID = SceneUtils.WorldToTileIndex(troop:GetPosition())
      else
        startPointID = SceneUtils.WorldToTileIndex(march:GetMarchCurPos())
      end
    else
      startPointID = MarchUtil.GetFormationStartPos()
    end
  else
    startPointID = MarchUtil.GetFormationStartPos()
  end
  return startPointID
end

local function GetElecCost(self, targetPointID, formationIndex)
  local tempCost = LuaEntry.DataConfig:TryGetNum("car_action_stamina", "k11")
  return tempCost
end

local function StartInvestigate(self, scoutType, targetUuid, pointId, formationUuid, extraParam)
  local march = DataCenter.ArmyFormationDataManager.InvestigateFormationList[formationUuid]
  if not march or march.state ~= MarchStatus.STATION then
    UIUtil.ShowTipsId(129109)
    return
  end
  local realPoint = pointId
  if scoutType == MarchTargetType.SCOUT_BUILDING then
    local pointInfo = CS.SceneManager.World:GetPointInfoByUuid(targetUuid)
    if pointInfo.PointType == WorldPointType.PlayerBuilding then
      cast(pointInfo, typeof(CS.BuildPointInfo))
      if pointInfo then
        if pointInfo.itemId == BuildingTypes.FUN_BUILD_MAIN then
          scoutType = MarchTargetType.SCOUT_CITY
          if BattleFieldUtil.InBattleField(BattleFieldType.WinterStorm) then
            scoutType = MarchTargetType.SCOUT_WINTER_STORM_CITY
          elseif BattleFieldUtil.InBattleField(BattleFieldType.EpidemicZone) then
            scoutType = MarchTargetType.SCOUT_EPIDEMIC_CITY
          end
        else
          scoutType = MarchTargetType.SCOUT_BUILDING
        end
      end
    end
  elseif scoutType == MarchTargetType.SCOUT_ALLIANCE_CITY or scoutType == MarchTargetType.SCOUT_THRONE then
    local worldPos = SceneUtils.TileIndexToWorld(pointId)
    worldPos.x = worldPos.x
    worldPos.z = worldPos.z
    realPoint = SceneUtils.WorldToTileIndex(worldPos)
  end
  local sfsObj = SFSObject.New()
  sfsObj:PutLong("uuid", formationUuid)
  local formationArray = SFSArray.New()
  sfsObj:PutSFSArray("formations", formationArray)
  local heroArray = SFSArray.New()
  sfsObj:PutSFSArray("heroInfos", heroArray)
  local dataObj = sfsObj
  local pos = MarchUtil.GetFormationStartPos()
  local curServerId = LuaEntry.Player:GetCurServerId()
  MarchUtil.StartMarch(scoutType, realPoint, targetUuid, -1, 0, formationUuid, 1, dataObj, pos, curServerId, nil, extraParam)
  self:CloseSelf()
end

local function GetRallyTimeList(self)
  return self.RallyTimeList
end

local function GetFormationListData(self)
  local oneData = {}
  oneData.curMarchNum = DataCenter.ArmyFormationDataManager:GetAlreadySetCountInArmyFormation()
  oneData.maxNum = FormationMaxNum
  oneData.list = DataCenter.ArmyFormationDataManager:GetCurFormationSlotIndexList()
  return oneData
end

local function GetFormationItemData(self, uuid)
  local oneData = {}
  oneData.isMarch = 0
  oneData.startPos = 0
  local formation = DataCenter.ArmyFormationDataManager:GetOneArmyInfoByUuid(uuid)
  local Player = LuaEntry.Player
  if formation ~= nil then
    oneData.uuid = formation.uuid
    oneData.index = formation.index
    oneData.canMove = false
    oneData.stamina = DataCenter.ArmyFormationDataManager:GetCurStaminaByUuid(formation.uuid)
    local config = DataCenter.ArmyFormationDataManager:GetConfigData()
    if config ~= nil then
      oneData.maxStamina = config.FormationStaminaMax
    end
    local march = DataCenter.WorldMarchDataManager:GetOwnerFormationMarch(Player.uid, formation.uuid, Player.allianceId)
    oneData.power = 0
    oneData.targetUuid = 0
    oneData.isBattle = false
    oneData.useForm = false
    oneData.speed = 1
    oneData.startTime = 0
    oneData.endTime = 0
    oneData.serverId = -1
    if march ~= nil then
      oneData.pointInfo = march.StationPointInfo
      local fixedSoldierType = march.fixedSoldierType or SoldierType.Player
      oneData.armyInfo = march:GetArmyInfoIndexOne()
      oneData.power = self:GetFormationPowerByUuid(formation.uuid)
      oneData.isMarch = 1
      if march:GetMarchType() == NewMarchType.ASSEMBLY_MARCH or march:GetMarchType() == NewMarchType.EXPLORE or march:GetMarchStatus() == WAIT_RALLY or march:GetMarchType() == NewMarchType.DIRECT_MOVE_MARCH or march:UnContinuousMarch() then
        oneData.canMove = true
      end
      if march:GetMarchStatus() == IN_TEAM then
        local teamMarch = DataCenter.WorldMarchDataManager:GetAllianceMarchesInTeam(Player.allianceId, march.teamUuid)
        if teamMarch ~= nil then
          march = teamMarch
        end
      end
      oneData.marchUuid = march.uuid
      oneData.targetUuid = march.targetUuid
      oneData.isBattle = march.inBattle
      oneData.serverId = march.serverId
      oneData.marchTargetServer = march.targetServer
      oneData.marchSrcServer = march.srcServer
      oneData.speed = march.speed
      oneData.ownerLightUuid = march.ownerLightUuid
      oneData.catchZombieNum = march.catchZombieNum
      if march.isMummyMarch then
        oneData.fixedSoldierType = SoldierType.Mummy
      else
        oneData.fixedSoldierType = fixedSoldierType or SoldierType.Player
      end
      if march:GetMarchStatus() == MarchStatus.DESTROY_WAIT then
        oneData.isBattle = true
      end
      if march:GetMarchStatus() == MarchStatus.CHASING or march:GetMarchStatus() == MarchStatus.MOVING or march:GetMarchStatus() == MarchStatus.IN_WORM_HOLE or march:GetMarchStatus() == MarchStatus.COLLECTING or march:GetMarchStatus() == MarchStatus.CROSS_SERVER then
        oneData.startTime = march.startTime
        oneData.endTime = march.endTime
      end
      local troop = CS.SceneManager.World:GetTroop(march.uuid)
      local worldPos
      if troop ~= nil then
        worldPos = troop:GetPosition()
      else
        worldPos = march:GetMarchCurPos()
      end
      if worldPos then
        oneData.marchCurServer = DataCenter.SeasonDataManager:GetNinePalacesServerByWorldPos(worldPos)
        oneData.startPos = SceneUtils.WorldToTileIndex(worldPos)
      end
      oneData.stateImg = MarchUtil.GetMarchStateIconByType(march)
      oneData.maxhp = march:GetMaxHP()
      oneData.hp = march:GetHP()
      oneData.heroDataList = {}
      local heroData = formation.heroes
      if heroData ~= nil and 0 < table.count(heroData) then
        table.walksort(heroData, function(leftKey, rightKey)
          return heroData[leftKey] < heroData[rightKey]
        end, function(k, v)
          if k ~= nil then
            local heroOneData = {}
            heroOneData.heroUuid = k
            heroOneData.index = v
            table.insert(oneData.heroDataList, heroOneData)
          end
        end)
      end
      oneData.dominatorUuid = formation.dominatorUuid
    else
      oneData.serverId = LuaEntry.Player:GetSelfServerId()
      oneData.startPos = MarchUtil.GetFormationStartPos()
      local formationForm = DataCenter.ArmyFormationDataManager:GetOneArmyInfoByUuid(uuid)
      if formationForm ~= nil then
        local allHeroes = formationForm.heroes
        if 0 < table.count(allHeroes) then
          oneData.useForm = true
        end
      end
      if oneData.useForm == false and formation.state == ArmyFormationState.March then
        local allHeroes = formation.heroes
        if 0 < table.count(allHeroes) then
          oneData.useForm = true
        end
      end
      if oneData.useForm == true then
        oneData.power = self:GetFormationPowerByUuid(formation.uuid)
        oneData.heroDataList = {}
        local heroData = formation.heroes
        if heroData ~= nil and 0 < table.count(heroData) then
          table.walksort(heroData, function(leftKey, rightKey)
            return heroData[leftKey] < heroData[rightKey]
          end, function(k, v)
            if k ~= nil then
              local heroOneData = {}
              heroOneData.heroUuid = k
              heroOneData.index = v
              table.insert(oneData.heroDataList, heroOneData)
            end
          end)
        end
        oneData.dominatorUuid = formation.dominatorUuid
      end
    end
    if self.targetType == MarchTargetType.FAKE_ATTACK then
      oneData.startPos = MarchUtil.GetFormationStartPos()
    end
  end
  return oneData
end

local function OnEditClick(self, uuid, needAutoFix, destroyTimeIndex)
  UIManager:GetInstance():OpenWindow(UIWindowNames.UIHeroPVPFormation, {anim = true}, EnterHeroSquadPanelWay.ToMarch, uuid, function()
    DataCenter.LWSoundManager:PlaySound(SoundAssetId.Music_Effect_Start_March)
    self:OnCheckTime(uuid, destroyTimeIndex)
    UIManager:GetInstance():DestroyWindow(UIWindowNames.UIHeroPVPFormation)
  end)
end

local function PreDoCollect(self, targetType, targetPointId, uuid, cb)
  if targetType ~= MarchTargetType.COLLECT and targetType ~= MarchTargetType.COLLECT_METEORITE then
    if cb then
      cb()
    end
    return
  end
  local myUid = LuaEntry.Player.uid
  local marchGroupByUid = DataCenter.WorldMarchDataManager:GetMarchCountToTargetGroupByOwnerUid(targetPointId, myUid)
  if marchGroupByUid == nil or marchGroupByUid.Count == 0 then
    if cb then
      cb()
    end
    return
  end
  if marchGroupByUid.Count == 1 and marchGroupByUid:ContainsKey(myUid) then
    if cb then
      cb()
    end
    return
  end
  if targetType == MarchTargetType.COLLECT then
    UIUtil.TryShowConfirm(TodayNoSecondConfirmType.CollectTargetHaveMarch, Localization:GetString("world_tip10002"), 2, GameDialogDefine.CONFIRM, GameDialogDefine.CANCEL, cb, function()
    end, nil, nil, false, nil, nil)
    return
  elseif targetType == MarchTargetType.COLLECT_METEORITE then
    local marchAL, marchServer
    local allMarches = DataCenter.WorldMarchDataManager:GetAllMarches(targetPointId)
    local myAlUid = LuaEntry.Player:GetAllianceUid()
    local mySId = LuaEntry.Player:GetSourceServerId()
    local curTime = UITimeManager:GetInstance():GetServerTime()
    local timeSec = self:GetTimeFormCurPosToTarPos(uuid)
    local timeMill = timeSec * 1000
    for _, marchData in pairs(allMarches) do
      if marchData.targetPos == targetPointId then
        local leftTime = marchData.endTime - curTime
        if not string.IsNullOrEmpty(myAlUid) and marchData.allianceUid == myAlUid and timeMill > leftTime and (marchAL == nil or leftTime < marchAL.endTime - curTime) then
          marchAL = marchData
        end
        if marchAL == nil and marchData.ownerServer == mySId and timeMill > leftTime and (marchServer == nil or leftTime < marchServer.endTime - curTime) then
          marchServer = marchData
        end
      end
    end
    if marchAL ~= nil or marchServer ~= nil then
      local key, secLeft, ownerName
      if marchAL ~= nil then
        ownerName = marchAL.ownerName
        key = "yuntieBattle_tips_1044"
        secLeft = math.floor((marchAL.endTime - curTime) / 1000)
      elseif marchServer ~= nil then
        ownerName = marchServer.ownerName
        key = "yuntieBattle_tips_1045"
        secLeft = math.floor((marchServer.endTime - curTime) / 1000)
      end
      local secQuick = math.max(math.floor(timeSec) - secLeft, 1)
      if not string.IsNullOrEmpty(key) then
        local tipStr = Localization:GetString(key, ownerName, secLeft, secQuick)
        UIUtil.TryShowConfirm(TodayNoSecondConfirmType.CollectMeteoriteTargetHaveMarch, tipStr, 2, GameDialogDefine.CONFIRM, GameDialogDefine.CANCEL, cb, function()
        end, nil, nil, false, nil, nil)
        return
      end
    end
  end
  if cb then
    cb()
  end
end

local function OnAtkClick(self, uuid, attackTimesIndex)
  if self.targetType >= 0 then
    local march = DataCenter.WorldMarchDataManager:GetOwnerFormationMarch(LuaEntry.Player.uid, uuid, LuaEntry.Player.allianceId)
    if march ~= nil then
      if self.targetType == MarchTargetType.TRANSPORT_ACT_BOSS then
        local time = self:GetTimeFormCurPosToTarPos(uuid)
        local limitTime = DataCenter.ActBossDataManager.limitTime
        local showFlag = Setting:GetPrivateInt("SHOW_TRANS_WARN", 1)
        if time < limitTime and showFlag == 1 then
          UIUtil.ShowSecondMessage(Localization:GetString("100378"), Localization:GetString("302194"), 2, "", "", function()
            self:ChangeMarchByType(uuid)
          end, function()
            Setting:SetPrivateInt("SHOW_TRANS_WARN", 0)
          end)
        else
          self:ChangeMarchByType(uuid)
        end
      elseif self.targetType == MarchTargetType.JOIN_RALLY or self.rallyType == MarchTargetType.RALLY_FOR_BOSS then
        local time = self:GetTimeFormCurPosToTarPos(uuid)
        local timeLimit = LuaEntry.DataConfig:TryGetNum("assembly_monster_toplimit", "k3")
        if 0 < timeLimit and time > timeLimit * 60 then
          UIUtil.ShowMessage(Localization:GetString("110204", timeLimit), 2, GameDialogDefine.CANCEL, "400027", nil, function()
            self:ChangeMarchByType(uuid)
          end)
        else
          self:ChangeMarchByType(uuid)
        end
      elseif self.targetType == MarchTargetType.ATTACK_ALLIANCE_CITY then
        self:ChangeMarchByType(uuid, attackTimesIndex)
      elseif self.targetType == MarchTargetType.ATTACK_THRONE then
        self:ChangeMarchByType(uuid, attackTimesIndex)
      elseif self.targetType == MarchTargetType.ATTACK_CITY_STRONGHOLD then
        self:ChangeMarchByType(uuid, attackTimesIndex)
      else
        PreDoCollect(self, self.targetType, self.targetPoint, uuid, function()
          self:ChangeMarchByType(uuid)
        end)
      end
    end
  else
    UIUtil.ShowSingleTip(Localization:GetString("120090"))
  end
  self:CloseSelf()
end

local function OnCheckTime(self, uuid, destroyTimeIndex)
  local time = self:GetTimeFormCurPosToTarPos(uuid)
  if self.specialType == WorldMonsterSpecialType.AllyDrill or self.specialType == WorldMonsterSpecialType.AllyDrillHugeSandWorm or self.specialType == WorldMonsterSpecialType.AllyDrillRoadHog or self.specialType == WorldMonsterSpecialType.ALLIANCE_BOSS_S0 then
    local stage, endTimeStamp
    if self.specialType == WorldMonsterSpecialType.ALLIANCE_BOSS_S0 then
      endTimeStamp = DataCenter.S0AllianceBossDataManager:GetBattleEndTime()
    else
      stage, endTimeStamp = DataCenter.AllyDrillDataManager:GetCurStageAndCountDown()
    end
    if not endTimeStamp then
      UIUtil.ShowTipsId(2010333)
      return
    end
    local now = UITimeManager:GetInstance():GetServerTime()
    if endTimeStamp < now + time * 1000 + self.ServerIndex2Time[self.timeIndex] * 60000 then
      UIUtil.ShowMessage(Localization:GetString("2010351"), 2, GameDialogDefine.CONFIRM, GameDialogDefine.CANCEL, function()
        self:OnCreateClick(uuid)
      end)
    elseif 180 < time then
      local str = Localization:GetString("alliance_boss_002")
      if self.targetType == MarchTargetType.JOIN_RALLY then
        str = Localization:GetString("alliance_boss_001")
      end
      UIUtil.ShowMessage(str, 2, GameDialogDefine.CONFIRM, GameDialogDefine.CANCEL, function()
        self:OnCreateClick(uuid)
      end)
    else
      self:OnCreateClick(uuid)
    end
    return
  end
  if self.targetType == MarchTargetType.TRANSPORT_ACT_BOSS then
    local limitTime = DataCenter.ActBossDataManager.limitTime
    local showFlag = Setting:GetPrivateInt("SHOW_TRANS_WARN", 1)
    if time < limitTime and showFlag == 1 then
      UIUtil.ShowSecondMessage(Localization:GetString("100378"), Localization:GetString("302194"), 2, "", "", function()
        self:OnCreateClick(uuid)
      end, function()
        Setting:SetPrivateInt("SHOW_TRANS_WARN", 0)
      end)
    else
      self:OnCreateClick(uuid)
    end
  elseif self.targetType == MarchTargetType.DIRECT_ATTACK_ACT_BOSS then
    self:OnCreateClick(uuid)
  elseif self.targetType == MarchTargetType.DIRECT_ATTACK_ACT_BERSERK_BOSS then
    self:OnCreateClick(uuid, destroyTimeIndex)
  elseif self.monsterSpecialType == WorldMonsterSpecialType.S1RestCityDefendMonster or self.monsterSpecialType == WorldMonsterSpecialType.S1RestBloodyQueenGunner then
    self:OnCreateClick(uuid, destroyTimeIndex)
  elseif 1200 < time then
    local state = DataCenter.ArmyFormationDataManager:GetConfirmFlag()
    if state then
      UIUtil.ShowSecondMessage(Localization:GetString("100378"), Localization:GetString("120997"), 2, "", "", function()
        self:OnCreateClick(uuid, destroyTimeIndex)
      end, function()
        DataCenter.ArmyFormationDataManager:SetConfirmFlag(false)
      end)
    else
      self:OnCreateClick(uuid, destroyTimeIndex)
    end
  elseif self.targetType == MarchTargetType.JOIN_RALLY or self.rallyType == MarchTargetType.RALLY_FOR_BOSS then
    local timeLimit = LuaEntry.DataConfig:TryGetNum("assembly_monster_toplimit", "k3")
    if 0 < timeLimit and time > timeLimit * 60 then
      UIUtil.ShowMessage(Localization:GetString("110204", timeLimit), 2, GameDialogDefine.CANCEL, "400027", nil, function()
        self:OnCreateClick(uuid)
      end)
    else
      self:OnCreateClick(uuid)
    end
  else
    self:OnCreateClick(uuid, destroyTimeIndex)
  end
end

local function OnCreateClick(self, uuid, destroyTimeIndex)
  if self.targetType >= 0 then
    if self:CheckCanBattle(uuid) then
      local showGuide = self.directionWaitResult
      local targetMonsterLevel = 0
      if self.targetType ~= MarchTargetType.STATE and self.targetType ~= MarchTargetType.SCOUT_ALLIANCE_CITY and self.targetType ~= MarchTargetType.SCOUT_ARMY_COLLECT and self.targetType ~= MarchTargetType.SCOUT_BUILDING and self.targetType ~= MarchTargetType.SCOUT_CITY and self.targetType ~= MarchTargetType.SCOUT_WINTER_STORM_CITY and self.targetType ~= MarchTargetType.SCOUT_EPIDEMIC_CITY and self.targetType ~= MarchTargetType.SCOUT_THRONE and self.targetType ~= MarchTargetType.DETECT_TREASURE and self.targetType ~= MarchTargetType.SCOUT_TROOP then
        local formation = DataCenter.ArmyFormationDataManager:GetOneArmyInfoByUuid(uuid)
        if formation ~= nil then
          if self.targetType ~= MarchTargetType.ATTACK_MONSTER or showGuide == false then
            local canAddNum = MarchUtil.GetCanAddHeroNum(formation.heroes, formation.index)
            if 0 < canAddNum then
              local show = Setting:GetPrivateInt("SHOW_ADD_HERO", 0)
              if show <= 0 then
                UIUtil.ShowSecondMessage(Localization:GetString("121006"), Localization:GetString("121007"), 1, 121008, "", function()
                  self:OnEditClick(uuid, false)
                end, function(needSellConfirm)
                  if needSellConfirm == false then
                    Setting:SetPrivateInt("SHOW_ADD_HERO", 1)
                  else
                    Setting:SetPrivateInt("SHOW_ADD_HERO", 0)
                  end
                end)
                if showGuide == true then
                  EventManager:GetInstance():Broadcast(EventId.StartAttackMonsterWithoutMsgTip, 0)
                end
                return
              end
            end
            if self.targetType ~= MarchTargetType.COLLECT then
              local k5 = LuaEntry.DataConfig:TryGetNum("res_lack", "k5")
              local heroUuid, targetHeroUuid = DataCenter.ArmyFormationDataManager:GetFormationHeroCanChangeHigherUuid(uuid)
              if k5 >= DataCenter.BuildManager.MainLv and heroUuid ~= nil and heroUuid ~= 0 and targetHeroUuid ~= nil and targetHeroUuid ~= 0 then
                UIUtil.ShowMessage(Localization:GetString("104245"), 1, 121008, "", function()
                  self:OnEditClick(uuid, false)
                end)
                if showGuide == true then
                  EventManager:GetInstance():Broadcast(EventId.StartAttackMonsterWithoutMsgTip, 0)
                end
                return
              end
            end
          end
          if self.targetType == MarchTargetType.ATTACK_MONSTER then
            local needShow = Setting:GetPrivateInt("SHOW_ADD_SOLDIER", 0)
            if needShow <= 0 then
              local totalPower = 0
              local targetPower = 0
              local targetLevel = 0
              local marchInfo = CS.SceneManager.World:GetMarch(self.targetUuid)
              local isCheckPower = false
              if marchInfo ~= nil then
                if marchInfo:GetMarchType() == NewMarchType.CHALLENGE_BOSS or marchInfo:GetMarchType() == NewMarchType.PUZZLE_BOSS then
                  isCheckPower = false
                end
                local monster = DataCenter.MonsterTemplateManager:GetMonsterTemplate(marchInfo.monsterId)
                if monster ~= nil then
                  targetPower = tonumber(monster.recommend_power)
                  targetLevel = tonumber(monster.level)
                  targetMonsterLevel = targetLevel
                  if monster.power_tip == 1 then
                    targetPower = 0
                  end
                end
              end
              if isCheckPower then
                local percent = (totalPower - targetPower) / math.max(1, targetPower)
                if percent < 0 then
                  local k2 = LuaEntry.DataConfig:TryGetNum("res_lack", "k2")
                  local configOpenState = LuaEntry.DataConfig:CheckSwitch("detect_monster")
                  if configOpenState then
                    UIUtil.ShowMessage(Localization:GetString("121010"), 1, nil, nil, nil, nil, function(needSellConfirm)
                      if needSellConfirm == false then
                        Setting:SetPrivateInt("SHOW_ADD_SOLDIER", 1)
                      else
                        Setting:SetPrivateInt("SHOW_ADD_SOLDIER", 0)
                      end
                    end, 121009)
                  else
                    UIUtil.ShowSecondMessage(Localization:GetString("121009"), Localization:GetString("121010"), 1, 150122, "", function()
                      MarchUtil.SendCreateMarchMessage(uuid, self.targetType, self.targetPoint, self.targetUuid, self.timeIndex, self.autoBackHome, true, self.targetServerId)
                    end, function(needSellConfirm)
                      if needSellConfirm == false then
                        Setting:SetPrivateInt("SHOW_ADD_SOLDIER", 1)
                      else
                        Setting:SetPrivateInt("SHOW_ADD_SOLDIER", 0)
                      end
                    end)
                  end
                  if showGuide == true then
                    EventManager:GetInstance():Broadcast(EventId.StartAttackMonsterWithoutMsgTip, 0)
                  end
                  return
                end
              end
            end
          end
        end
      end
      if self.targetType == MarchTargetType.JOIN_RALLY and self.rallyType == MarchTargetType.RALLY_FOR_BOSS then
        local data = DataCenter.AllianceWarDataManager:GetAllianceWarDataByUuid(self.targetUuid)
        if data then
          local monster = DataCenter.MonsterTemplateManager:GetMonsterTemplate(data.targetUid)
          if monster ~= nil then
            local pow = monster.recommend_power / data.assemblyMarchMax * 0.5
            local selfPow = self:GetFormationPowerByUuid(uuid)
            if pow > selfPow then
              UIUtil.ShowMessage(Localization:GetString("141079"), 2, "", "", function()
                if self:NeedTakeArmy() == false then
                  MarchUtil.SendCreateMarchMessage(uuid, self.targetType, self.targetPoint, self.targetUuid, self.timeIndex, self.autoBackHome, false, self.targetServerId)
                else
                  MarchUtil.SendCreateMarchMessage(uuid, self.targetType, self.targetPoint, self.targetUuid, self.timeIndex, self.autoBackHome, true, self.targetServerId)
                end
                self:CloseSelf()
              end)
              return
            end
          end
        end
      end
      if self.targetType == MarchTargetType.COLLECT then
        local collectPoint = CS.SceneManager.World:GetResourcePointInfoByIndex(self.targetPoint)
        if collectPoint then
          local marchInfo = CS.SceneManager.World:GetMarch(collectPoint.gatherMarchUuid)
          if marchInfo then
            if collectPoint.gatherMarchUuid == 0 then
              Logger.LogError("[fuck] get march success but uuid is 0")
              return
            end
            UIUtil.ShowTipsId("world_tip10006")
            self:CloseSelf()
            return
          end
        end
      elseif self.targetType == MarchTargetType.COLLECT_METEORITE then
        local pointInfo = CS.SceneManager.World:GetPointInfo(self.targetPoint)
        if pointInfo and pointInfo.detail then
          local marchInfo = CS.SceneManager.World:GetMarch(pointInfo.detail.MarchUUID)
          if marchInfo then
            UIUtil.ShowTipsId("world_tip10006")
            self:CloseSelf()
            return
          end
        end
      elseif self.targetType == MarchTargetType.COLLECT_EPIDEMIC_RES then
        local pointInfo = CS.SceneManager.World:GetPointInfo(self.targetPoint)
        if pointInfo then
          local marchInfo = CS.SceneManager.World:GetMarch(pointInfo.gatherUUID)
          if marchInfo then
            UIUtil.ShowTipsId("world_tip10006")
            self:CloseSelf()
            return
          end
        end
      elseif self.targetType == MarchTargetType.RALLY_FOR_BOSS and self.targetUuid then
        local marchData = CS.SceneManager.World:GetMarch(self.targetUuid)
        if marchData then
          self.targetPoint = SceneUtils.WorldToTileIndex(marchData:GetMarchCurPos(), ForceChangeScene.World)
        else
          UIUtil.ShowTipsId("E100123")
          self:CloseSelf()
          return
        end
      end
      if self.targetType == MarchTargetType.JOIN_RALLY and self.monsterSpecialType == WorldMonsterSpecialType.ALLIANCE_BOSS_S0 then
        local showConfirm = DataCenter.S0AllianceBossDataManager:CheckAlliancePersonalDmgFull()
        if showConfirm then
          UIManager.Instance:DestroyWindow(UIWindowNames.UIWorldPoint, {
            anim = true,
            playEffect = false,
            UIMainAnim = UIMainAnimType.ChangeAllShow
          })
          local param = {
            contentText = CS.GameEntry.Localization:GetString("s0_alliance_boss_attack_check"),
            btnNum = 2,
            showToggle = true,
            confirmBtnParam = {
              action = function()
                if self:NeedTakeArmy() == false then
                  MarchUtil.SendCreateMarchMessage(uuid, self.targetType, self.targetPoint, self.targetUuid, self.timeIndex, self.autoBackHome, false, self.targetServerId)
                else
                  PreDoCollect(self, self.targetType, self.targetPoint, uuid, function()
                    if self.targetType == MarchTargetType.ATTACK_MONSTER and showGuide == true then
                      EventManager:GetInstance():Broadcast(EventId.StartAttackMonsterWithoutMsgTip, 1)
                    end
                    MarchUtil.SendCreateMarchMessage(uuid, self.targetType, self.targetPoint, self.targetUuid, self.timeIndex, self.autoBackHome, false, self.targetServerId, destroyTimeIndex)
                  end)
                  local costPoint = 0
                  if self.targetType ~= nil and 0 <= self.targetType then
                    costPoint = self:GetCostStaminaByTargetType(self.targetType)
                  end
                  self:CloseSelf()
                end
              end
            }
          }
          UIUtil.TryShowConfirmNew(TodayNoSecondConfirmType.S0AllianceBossWeaknessAttackRemind, param)
          return
        end
      end
      if self:NeedTakeArmy() == false then
        MarchUtil.SendCreateMarchMessage(uuid, self.targetType, self.targetPoint, self.targetUuid, self.timeIndex, self.autoBackHome, false, self.targetServerId)
      else
        PreDoCollect(self, self.targetType, self.targetPoint, uuid, function()
          if self.targetType == MarchTargetType.ATTACK_MONSTER and showGuide == true then
            EventManager:GetInstance():Broadcast(EventId.StartAttackMonsterWithoutMsgTip, 1)
          end
          MarchUtil.SendCreateMarchMessage(uuid, self.targetType, self.targetPoint, self.targetUuid, self.timeIndex, self.autoBackHome, false, self.targetServerId, destroyTimeIndex)
        end)
      end
    end
  else
    UIUtil.ShowTipsId(120090)
  end
  local costPoint = 0
  if self.targetType ~= nil and self.targetType >= 0 then
    costPoint = self:GetCostStaminaByTargetType(self.targetType)
  end
  self:CloseSelf()
end

local function NeedTakeArmy(self)
  return self.targetType ~= MarchTargetType.EXPLORE
end

local function ChangeMarchByType(self, formationUuid, attackTimesIndex)
  if self.targetType > -1 then
    local march = DataCenter.WorldMarchDataManager:GetOwnerFormationMarch(LuaEntry.Player.uid, formationUuid, LuaEntry.Player.allianceId)
    if march ~= nil then
      if march:GetIsBroken() == true then
        UIUtil.ShowTipsId(120003)
        return
      end
      local marchUuid = march.uuid
      if self.targetType == MarchTargetType.ATTACK_MONSTER then
        local curStamina = DataCenter.ArmyFormationDataManager:GetCurStaminaByUuid(formationUuid)
        local info = CS.SceneManager.World:GetMarch(self.targetUuid)
        if info ~= nil then
          MarchUtil.OnAttackMonster(marchUuid, info, curStamina, nil, self.autoBackHome, self.directionWaitResult)
        end
      elseif self.targetType == MarchTargetType.ATTACK_ARMY then
        local curStamina = DataCenter.ArmyFormationDataManager:GetCurStaminaByUuid(formationUuid)
        local info = CS.SceneManager.World:GetMarch(self.targetUuid)
        if info ~= nil then
          MarchUtil.OnAttackArmy(marchUuid, info, curStamina)
        end
      elseif self.targetType == MarchTargetType.SAMPLE then
        local curStamina = DataCenter.ArmyFormationDataManager:GetCurStaminaByUuid(formationUuid)
        local pointInfo = CS.SceneManager.World:GetPointInfo(self.targetPoint)
        if pointInfo ~= nil then
          cast(pointInfo, typeof(CS.SamplePointInfo))
          if pointInfo ~= nil then
            MarchUtil.OnCollectSimple(marchUuid, pointInfo, curStamina)
          end
        end
      elseif self.targetType == MarchTargetType.ATTACK_ARMY_COLLECT then
        local curStamina = DataCenter.ArmyFormationDataManager:GetCurStaminaByUuid(formationUuid)
        local pointInfo = CS.SceneManager.World:GetPointInfo(self.targetPoint)
        if pointInfo ~= nil then
          cast(pointInfo, typeof(CS.ResPointInfo))
          if pointInfo ~= nil then
            MarchUtil.OnAttackCollectBuild(marchUuid, pointInfo, curStamina)
          end
        end
      elseif self.targetType == MarchTargetType.ASSISTANCE_BUILD then
        local pointInfo = CS.SceneManager.World:GetPointInfo(self.targetPoint)
        cast(pointInfo, typeof(CS.BuildPointInfo))
        if pointInfo ~= nil then
          MarchUtil.OnAssistanceBuild(marchUuid, pointInfo)
        end
      elseif self.targetType == MarchTargetType.ASSISTANCE_CITY or self.targetType == MarchTargetType.ASSISTANCE_WINTER_STORM_CITY or self.targetType == MarchTargetType.ASSISTANCE_EPIDEMIC_CITY then
        local pointInfo = CS.SceneManager.World:GetPointInfo(self.targetPoint)
        cast(pointInfo, typeof(CS.BuildPointInfo))
        if pointInfo ~= nil then
          MarchUtil.OnAssistanceOtherCity(marchUuid, pointInfo)
        end
      elseif self.targetType == MarchTargetType.ASSISTANCE_DESERT then
        MarchUtil.OnAssistanceDesert(marchUuid, self.targetPoint, self.targetUuid, false)
      elseif self.targetType == MarchTargetType.ASSISTANCE_ALLIANCE_CITY or self.targetType == MarchTargetType.ASSISTANCE_THRONE then
        local pointInfo = CS.SceneManager.World:GetPointInfo(self.targetPoint)
        if pointInfo ~= nil then
          MarchUtil.OnAssistanceAllianceCity(marchUuid, pointInfo)
        end
      elseif self.targetType == MarchTargetType.ATTACK_ALLIANCE_CITY or self.targetType == MarchTargetType.ATTACK_THRONE or self.targetType == MarchTargetType.ATTACK_CITY_STRONGHOLD then
        local curStamina = DataCenter.ArmyFormationDataManager:GetCurStaminaByUuid(formationUuid)
        local pointInfo = CS.SceneManager.World:GetPointInfo(self.targetPoint)
        if pointInfo ~= nil then
          attackTimesIndex = attackTimesIndex or 1
          MarchUtil.OnAttackAllianceCity(marchUuid, pointInfo, curStamina, nil, attackTimesIndex)
        end
      elseif self.targetType == MarchTargetType.ATTACK_BUILDING then
        local curStamina = DataCenter.ArmyFormationDataManager:GetCurStaminaByUuid(formationUuid)
        local pointInfo = CS.SceneManager.World:GetPointInfo(self.targetPoint)
        cast(pointInfo, typeof(CS.BuildPointInfo))
        if pointInfo ~= nil then
          MarchUtil.OnAttackOtherBuild(marchUuid, pointInfo, curStamina)
        end
      elseif self.targetType == MarchTargetType.ATTACK_CITY or self.targetType == MarchTargetType.ATTACK_WINTER_STORM_CITY or self.targetType == MarchTargetType.ATTACK_EPIDEMIC_CITY then
        local curStamina = DataCenter.ArmyFormationDataManager:GetCurStaminaByUuid(formationUuid)
        local pointInfo = CS.SceneManager.World:GetPointInfo(self.targetPoint)
        cast(pointInfo, typeof(CS.BuildPointInfo))
        if pointInfo ~= nil then
          MarchUtil.OnAttackOtherCity(marchUuid, pointInfo, curStamina)
        end
      elseif self.targetType == MarchTargetType.ATTACK_ROAD then
        local curStamina = DataCenter.ArmyFormationDataManager:GetCurStaminaByUuid(formationUuid)
        local pointInfo = CS.SceneManager.World:GetPointInfo(self.targetPoint)
        cast(pointInfo, typeof(CS.BoardPointInfo))
        if pointInfo ~= nil then
          MarchUtil.OnAttackOtherRoad(marchUuid, pointInfo, curStamina)
        end
      elseif self.targetType == MarchTargetType.EXPLORE then
        local curStamina = DataCenter.ArmyFormationDataManager:GetCurStaminaByUuid(formationUuid)
        local pointInfo = CS.SceneManager.World:GetExplorePointInfoByIndex(self.targetPoint)
        if pointInfo ~= nil then
          MarchUtil.OnExplore(marchUuid, pointInfo, curStamina)
        end
      elseif self.targetType == MarchTargetType.PICK_GARBAGE then
        local curStamina = DataCenter.ArmyFormationDataManager:GetCurStaminaByUuid(formationUuid)
        local pointInfo = CS.SceneManager.World:GetGarbagePointInfoByIndex(self.targetPoint)
        if pointInfo ~= nil then
          MarchUtil.OnCollectGarbage(marchUuid, pointInfo, curStamina)
        end
      elseif self.targetType == MarchTargetType.GO_WORM_HOLE then
        UIUtil.ShowTipsId(143611)
      elseif self.targetType == MarchTargetType.CROSS_SERVER_WORM then
        MarchUtil.OnGotoCrossServerWormHole(marchUuid, false, self.targetServerId)
      elseif self.targetType == MarchTargetType.BUILD_WORM_HOLE then
        local pointInfo = CS.SceneManager.World:GetPointInfo(self.targetPoint)
        cast(pointInfo, typeof(CS.BuildPointInfo))
        if pointInfo ~= nil then
          MarchUtil.OnBuildWormHole(marchUuid, pointInfo)
        end
      elseif self.targetType == MarchTargetType.COLLECT then
        local collectPoint = CS.SceneManager.World:GetResourcePointInfoByIndex(self.targetPoint)
        if collectPoint ~= nil then
          local marchInfo = CS.SceneManager.World:GetMarch(collectPoint.gatherMarchUuid)
          if marchInfo then
            UIUtil.ShowTipsId("world_tip10006")
          else
            MarchUtil.OnGotoCollect(marchUuid, collectPoint, self.targetPoint, false)
          end
        end
      elseif self.targetType == MarchTargetType.ATTACK_DESERT or self.targetType == MarchTargetType.ATTACK_EMPTY_DESERT then
        MarchUtil.OnAttackDesert(marchUuid, self.targetPoint, false, self.targetType)
      elseif self.targetType == MarchTargetType.JOIN_RALLY then
        local curStamina = DataCenter.ArmyFormationDataManager:GetCurStaminaByUuid(formationUuid)
        MarchUtil.OnJoinRally(marchUuid, self.rallyType, self.targetUuid, self.targetPoint, curStamina)
      elseif self.targetType == MarchTargetType.STATE then
        MarchUtil.OnStation(marchUuid, self.targetPoint)
      else
        MarchUtil.StartMarch(self.targetType, self.targetPoint, self.targetUuid, self.timeIndex, 0, self.selectFormationUuid, self.autoBackHome, nil, 0, self.targetServerId)
      end
    end
  end
end

local function CheckCanBattle(self, uuid)
  local canBattle = false
  local formation = DataCenter.ArmyFormationDataManager:GetOneArmyInfoByUuid(uuid)
  if formation ~= nil then
    if self.targetType == MarchTargetType.COLLECT then
      local info = CS.SceneManager.World:GetResourcePointInfoByIndex(self.targetPoint)
      if info ~= nil then
        if false then
          local scienceId = GetTableData(TableName.GatherResource, info.id, "unlock_science")
          if scienceId ~= "" and not DataCenter.ScienceManager:HasScienceByIdAndLevel(tonumber(scienceId), 1) then
            local template = DataCenter.ScienceTemplateManager:GetScienceTemplate(scienceId, 1)
            UIUtil.ShowTips(Localization:GetString("129055", Localization:GetString(template.name), Localization:GetString(GetTableData(TableName.GatherResource, info.id, "name"))))
          end
        else
          canBattle = true
        end
      end
    elseif self.targetType == MarchTargetType.PICK_GARBAGE then
      local k2 = LuaEntry.DataConfig:TryGetNum("Reconnaissance_power_consumption", "k3")
      local own = LuaEntry.Resource:GetCntByResType(ResourceType.Electricity)
      if k2 > own then
        UIUtil.ShowTipsId(129023)
        local lackTab = {}
        local param = {}
        param.type = ResLackType.Res
        param.resType = ResourceType.Electricity
        param.targetNum = k2
        table.insert(lackTab, param)
        GoToResLack.GoToItemResLackList(lackTab)
      else
        canBattle = true
      end
    elseif self.targetType == MarchTargetType.SAMPLE then
      local k3 = LuaEntry.DataConfig:TryGetNum("Reconnaissance_power_consumption", "k3")
      local own = LuaEntry.Resource:GetCntByResType(ResourceType.Electricity)
      if k3 > own then
        UIUtil.ShowTipsId(129023)
        local lackTab = {}
        local param = {}
        param.type = ResLackType.Res
        param.resType = ResourceType.Electricity
        param.targetNum = k3
        table.insert(lackTab, param)
        GoToResLack.GoToItemResLackList(lackTab)
      else
        canBattle = true
      end
    elseif self.targetType == MarchTargetType.ATTACK_ALLIANCE_CITY or self.targetType == MarchTargetType.ATTACK_THRONE or self.targetType == MarchTargetType.ATTACK_CITY_STRONGHOLD or self.targetType == MarchTargetType.RALLY_CITY_STRONGHOLD or self.targetType == MarchTargetType.RALLY_THRONE then
      local protectTime = 0
      local openTime = 0
      local curTime = UITimeManager:GetInstance():GetServerSeconds()
      local info = CS.SceneManager.World:GetPointInfo(self.targetPoint)
      if info ~= nil and info ~= nil then
        local curServerId = LuaEntry.Player:GetCurServerId()
        local kingCityId, kingCityPosIndex = SeasonUtil.GetKingCityId(curServerId)
        local allianceCityPointInfo = SeasonUtil.TryParseAllianceCityPointInfo(info.PointType, info.extraInfo, info)
        if allianceCityPointInfo ~= nil then
          local cityId = allianceCityPointInfo.cityId
          local level = GetTableData(TableName.WorldCity, cityId, "level")
          if cityId ~= kingCityId then
            openTime = allianceCityPointInfo.openTime or 0
            if curTime < openTime or openTime == -1 then
              UIUtil.ShowTipsId(300708)
              return false
            end
            protectTime = allianceCityPointInfo.protectTime or 0
            if curTime < protectTime then
              if self.targetType == MarchTargetType.ATTACK_CITY_STRONGHOLD then
                UIUtil.ShowTipsId("season_tips240")
              else
                UIUtil.ShowTipsId(300709)
              end
              return false
            end
          end
          if cityId == kingCityId and SeasonUtil.IsInSeasonOrHalt(curServerId) then
            return true
          end
          if SeasonUtil.CanAttackCityStronghold(cityId) then
            return true
          elseif DataCenter.WorldAllianceCityDataManager:GetAllianceAlreadyHaveCity(LuaEntry.Player.allianceId) == true then
            if DataCenter.WorldAllianceCityDataManager:GetCityIsNearBySelfAlliance(LuaEntry.Player.allianceId, cityId) == false then
              UIUtil.ShowTipsId(300711)
              return false
            end
          elseif LuaEntry.Player:AtHomeNow() and 1 < level then
            if level < 7 then
              UIUtil.ShowTipsId(300710)
            else
              UIUtil.ShowTipsId(300711)
            end
            return false
          end
          local staminaCost = MarchUtil.GetCostStaminaByTargetType(MarchTargetType.ATTACK_ALLIANCE_CITY)
          local curStamina = DataCenter.ArmyFormationDataManager:GetCurStaminaByUuid(uuid)
          if staminaCost > curStamina then
            UIUtil.ShowTipsId(GameDialogDefine.STAMINA_IS_NOT_ENOUGH)
            return false
          end
          return true
        end
      end
    else
      if self.targetType == MarchTargetType.DIRECT_ATTACK_ACT_BOSS then
        return true
      end
      local cost = self:GetCostStaminaByTargetType(self.targetType)
      if 0 < cost then
        local curStamina = DataCenter.ArmyFormationDataManager:GetCurStaminaByUuid(uuid)
        if cost > curStamina then
          UIUtil.ShowTipsId(GameDialogDefine.STAMINA_IS_NOT_ENOUGH)
        else
          canBattle = true
        end
      else
        canBattle = true
      end
    end
  else
    UIUtil.ShowTipsId(300007)
  end
  return canBattle
end

local function SetSelectFormationUuid(self, uuid)
  self.selectFormationUuid = uuid
  if uuid and 0 < uuid then
    CommonUtil.PlayerPrefsSetString("FORMATION_SELECT_HISTORY", tostring(uuid))
  end
end

local function GetTimeFormCurPosToTarPos(self, uuid, fixedSoldierType, useLightWorkerMan)
  local data = self:GetFormationItemData(uuid)
  local serverId = data.marchCurServer or data.serverId
  local bInBattleField = BattleFieldUtil.InBattleField()
  if bInBattleField then
    serverId = LuaEntry.Player:GetCurServerId()
  end
  local startWorldPos = SceneUtils.TileIndexToWorld(data.startPos, ForceChangeScene.World, serverId)
  local endWorldPos = SceneUtils.TileIndexToWorld(self.targetPoint, ForceChangeScene.World, self.targetServerId)
  local startTilePos = Vector2.New(math.floor(startWorldPos.x / TileSize), math.floor(startWorldPos.z / TileSize))
  local endTilePos = Vector2.New(math.floor(endWorldPos.x / TileSize), math.floor(endWorldPos.z / TileSize))
  local distance = Vector2.Distance(startTilePos, endTilePos)
  local blackDistance = 0
  if not bInBattleField and self.targetType ~= MarchTargetType.DIRECT_ATTACK_ACT_BOSS and self.targetType ~= MarchTargetType.DIRECT_ATTACK_ACT_BERSERK_BOSS then
    local startTilePosLocal = SceneUtils.IndexToTilePos(data.startPos, ForceChangeScene.World)
    local endTilePosLocal = SceneUtils.IndexToTilePos(self.targetPoint, ForceChangeScene.World)
    blackDistance = SceneUtils.GetBlackLengthByStartEnd(startTilePosLocal, endTilePosLocal, serverId, self.targetServerId)
  end
  local whiteSpeed = self:GetMarchSpeed(uuid, fixedSoldierType, useLightWorkerMan)
  if blackDistance == 0 then
    local whiteTime = distance / whiteSpeed
    return whiteTime
  end
  local whiteDistance = distance - blackDistance
  local whiteTime = whiteDistance / whiteSpeed
  local blackSpeed = DataCenter.BirthPointTemplateManager:GetBlackLandRealSpeed(whiteSpeed)
  local blackTime = blackDistance / blackSpeed
  local time = whiteTime + blackTime
  return time
end

local function GetMarchTimeDebugInfo(self, uuid, fixedSoldierType, useLightWorkerMan)
  local data = self:GetFormationItemData(uuid)
  local serverId = data.marchCurServer or data.serverId
  local bInBattleField = BattleFieldUtil.InBattleField()
  if bInBattleField then
    serverId = LuaEntry.Player:GetCurServerId()
  end
  local startWorldPos = SceneUtils.TileIndexToWorld(data.startPos, ForceChangeScene.World, serverId)
  local endWorldPos = SceneUtils.TileIndexToWorld(self.targetPoint, ForceChangeScene.World, self.targetServerId)
  local startTilePos = Vector2.New(math.floor(startWorldPos.x / TileSize), math.floor(startWorldPos.z / TileSize))
  local endTilePos = Vector2.New(math.floor(endWorldPos.x / TileSize), math.floor(endWorldPos.z / TileSize))
  local distance = Vector2.Distance(startTilePos, endTilePos)
  local blackDistance = 0
  local isBlackLand = false
  if not bInBattleField and self.targetType ~= MarchTargetType.DIRECT_ATTACK_ACT_BOSS and self.targetType ~= MarchTargetType.DIRECT_ATTACK_ACT_BERSERK_BOSS then
    local startTilePosLocal = SceneUtils.IndexToTilePos(data.startPos, ForceChangeScene.World)
    local endTilePosLocal = SceneUtils.IndexToTilePos(self.targetPoint, ForceChangeScene.World)
    blackDistance = SceneUtils.GetBlackLengthByStartEnd(startTilePosLocal, endTilePosLocal, serverId, self.targetServerId)
    isBlackLand = 0 < blackDistance
  end
  local whiteSpeed = self:GetMarchSpeed(uuid, fixedSoldierType, useLightWorkerMan)
  local info = {}
  info.distance = distance
  info.blackDistance = blackDistance
  info.whiteDistance = distance - blackDistance
  info.whiteSpeed = whiteSpeed
  info.targetType = self.targetType
  info.fixedSoldierType = fixedSoldierType
  info.useLightWorkerMan = useLightWorkerMan
  info.isBlackLand = isBlackLand
  info.baseSpeed = self.NormalSpeed or 0
  local addRatio = 0
  if self.targetType == MarchTargetType.MONSTER_INVASION_BOSS or self.targetType == MarchTargetType.ATTACK_SANDWORM then
    addRatio = DataCenter.ArmyFormationDataManager:GetEffectResult(uuid, EffectDefine.FINAL_MONSTER_SPEED_71051, useLightWorkerMan)
    info.addEffect = "FINAL_MONSTER_SPEED_71051"
  elseif self.targetType == MarchTargetType.ATTACK_MONSTER then
    addRatio = DataCenter.ArmyFormationDataManager:GetEffectResult(uuid, EffectDefine.FINAL_MONSTER_SPEED_71051, useLightWorkerMan)
    info.addEffect = "FINAL_MONSTER_SPEED_71051"
  elseif self.targetType == MarchTargetType.ATTACK_DRAGON_BUILDING or self.targetType == MarchTargetType.ATTACK_EPIDEMIC_BUILDING or self.targetType == MarchTargetType.ATTACK_WINTER_ENTITY or self.targetType == MarchTargetType.ATTACK_ARMY_COLLECT or self.targetType == MarchTargetType.ATTACK_ARMY or self.targetType == MarchTargetType.TRAIN_ATTACK or self.targetType == MarchTargetType.ATTACK_CITY or self.targetType == MarchTargetType.FAKE_ATTACK or self.targetType == MarchTargetType.ATTACK_WINTER_STORM_CITY or self.targetType == MarchTargetType.ATTACK_EPIDEMIC_CITY or self.targetType == MarchTargetType.ATTACK_BUILDING or self.targetType == MarchTargetType.ATTACK_PLAYER_RUIN_BUILDING or self.targetType == MarchTargetType.ATTACK_METEORITE then
    addRatio = DataCenter.ArmyFormationDataManager:GetEffectResult(uuid, EffectDefine.FINAL_PLAYER_SPEED_71052, useLightWorkerMan)
    local winterAdd = self:GetWinterSpeedAdd(self.targetType)
    info.addEffect = "FINAL_PLAYER_SPEED_71052"
    info.winterAdd = winterAdd
  elseif self.targetType == MarchTargetType.COLLECT_ALLIANCE_BUILD_RESOURCE or self.targetType == MarchTargetType.COLLECT or self.targetType == MarchTargetType.DETECT_TREASURE or self.targetType == MarchTargetType.ALLIANCE_RESOURCE_COLLECT or self.targetType == MarchTargetType.COLLECT_METEORITE or self.targetType == MarchTargetType.COLLECT_EPIDEMIC_RES then
    addRatio = DataCenter.ArmyFormationDataManager:GetEffectResult(uuid, EffectDefine.FINAL_GATHER_SPEED_71054, useLightWorkerMan)
    info.addEffect = "FINAL_GATHER_SPEED_71054"
    info.baseSpeed = self.ResHelpSpeed or 0
  elseif self.targetType == MarchTargetType.ATTACK_ALLIANCE_CITY or self.targetType == MarchTargetType.ATTACK_CITY_TRADE or self.targetType == MarchTargetType.ATTACK_CITY_ALTAR or self.targetType == MarchTargetType.ATTACK_OUTPOST_BUILDING or self.targetType == MarchTargetType.ATTACK_THRONE or self.targetType == MarchTargetType.ATTACK_CITY_STRONGHOLD or self.targetType == MarchTargetType.ATTACK_SERVER_THRONE_BUILDING or self.targetType == MarchTargetType.ATTACK_CENTER_THRONE or self.targetType == MarchTargetType.CROSS_BANK_ATTACK then
    addRatio = DataCenter.ArmyFormationDataManager:GetEffectResult(uuid, EffectDefine.FINAL_ALLIANCE_CITY_SPEED_71053, useLightWorkerMan)
    info.addEffect = "FINAL_ALLIANCE_CITY_SPEED_71053"
  elseif self.targetType == MarchTargetType.ASSISTANCE_CITY or self.targetType == MarchTargetType.ASSISTANCE_WINTER_STORM_CITY or self.targetType == MarchTargetType.ASSISTANCE_ALLIANCE_CITY or self.targetType == MarchTargetType.ASSISTANCE_OUTPOST_BUILDING or self.targetType == MarchTargetType.ASSISTANCE_CITY_STRONGHOLD or self.targetType == MarchTargetType.ASSISTANCE_CITY_TRADE or self.targetType == MarchTargetType.ASSISTANCE_CITY_ALTAR or self.targetType == MarchTargetType.ASSISTANCE_THRONE or self.targetType == MarchTargetType.ASSISTANCE_DRAGON_BUILDING or self.targetType == MarchTargetType.ASSISTANCE_WINTER_ENTITY or self.targetType == MarchTargetType.ASSISTANCE_EPIDEMIC_BUILDING or self.targetType == MarchTargetType.ASSISTANCE_SERVER_THRONE_BUILDING or self.targetType == MarchTargetType.ASSISTANCE_CENTER_THRONE or self.targetType == MarchTargetType.REPAIR_OUTPOST then
    addRatio = DataCenter.ArmyFormationDataManager:GetEffectResult(uuid, EffectDefine.FINAL_ASSIST_SPEED_71057, useLightWorkerMan)
    local winterAdd = self:GetWinterSpeedAdd(self.targetType)
    info.addEffect = "FINAL_ASSIST_SPEED_71057"
    info.winterAdd = winterAdd
  else
    info.addEffect = "\230\151\160"
  end
  info.addRatio = addRatio
  if isBlackLand then
    info.blackSpeed = DataCenter.BirthPointTemplateManager:GetBlackLandRealSpeed(whiteSpeed)
  else
    info.blackSpeed = 0
    blackDistance = 0
  end
  local whiteTime = (distance - blackDistance) / whiteSpeed
  local blackTime = 0
  if isBlackLand and 0 < info.blackSpeed then
    blackTime = blackDistance / info.blackSpeed
  end
  info.whiteTime = whiteTime
  info.blackTime = blackTime
  info.totalTime = whiteTime + blackTime
  return info
end

local function GetWinterSpeedAdd(self, targetType)
  local tmpNum = 0
  if not BattleFieldUtil.InBattleField(BattleFieldType.WinterStorm) then
    return tmpNum
  end
  if targetType ~= MarchTargetType.ATTACK_WINTER_ENTITY and targetType ~= MarchTargetType.ASSISTANCE_WINTER_ENTITY then
    return tmpNum
  end
  tmpNum = LuaEntry.DataConfig:TryGetNum("winter_battlefield", "k17", 0)
  local info = CS.SceneManager.World:GetPointInfoByUuid(self.targetUuid)
  if info ~= nil and info.detail ~= nil then
    local config = DataCenter.WinterStormTemplateManager:GetTemplate(info.detail.BuildId)
    if config ~= nil and config.type == DataCenter.WinterStormTemplateManager:GetCenterType() then
      tmpNum = tmpNum + LuaEntry.DataConfig:TryGetNum("winter_battlefield", "k18", 0)
    end
  end
  return tmpNum / 100
end

local function GetMarchSpeed(self, uuid, fixedSoldierType, useLightWorkerMan)
  local isConfigModeOpen = LuaEntry.DataConfig:CheckSwitch("lw_speed")
  local targetType = self.targetType
  local ret = 0
  if not isConfigModeOpen and (targetType == MarchTargetType.BUILD_ALLIANCE_BUILDING or targetType == MarchTargetType.RALLY_FOR_BOSS or targetType == MarchTargetType.RALLY_SANDWORM or targetType == MarchTargetType.JOIN_RALLY) and (self.specialType == WorldMonsterSpecialType.AllyDrill or self.monsterSpecialType == WorldMonsterSpecialType.AllyDrill or self.specialType == WorldMonsterSpecialType.AllyDrillHugeSandWorm or self.monsterSpecialType == WorldMonsterSpecialType.AllyDrillHugeSandWorm or self.specialType == WorldMonsterSpecialType.AllyDrillRoadHog or self.monsterSpecialType == WorldMonsterSpecialType.AllyDrillRoadHog or self.specialType == WorldMonsterSpecialType.ALLIANCE_BOSS_S0 or self.monsterSpecialType == WorldMonsterSpecialType.ALLIANCE_BOSS_S0) then
    return self.NormalSpeed
  end
  if targetType == MarchTargetType.ATTACK_MONSTER and (self.specialType == WorldMonsterSpecialType.AllyDrillCow or self.monsterSpecialType == WorldMonsterSpecialType.AllyDrillCow) then
    return self.RallySpeed
  end
  if fixedSoldierType == SoldierType.Mummy then
    local addRatio = DataCenter.ArmyFormationDataManager:GetEffectResult(uuid, EffectDefine.JOIN_RALLY_SPEED_UP_94038, useLightWorkerMan)
    if targetType == MarchTargetType.JOIN_RALLY then
      return self.MummyJoinRallySpeed * (1 + addRatio)
    elseif MarchUtil.IsRallyMarch(targetType) then
      return self.MummyRallySpeed
    end
  end
  if isConfigModeOpen then
    ret = MarchUtil.CalcMarchSpeedByConfig(targetType, uuid, fixedSoldierType, useLightWorkerMan)
    if ret == nil or ret == 0 then
      ret = 0
    else
      return ret
    end
  end
  if targetType == MarchTargetType.MONSTER_INVASION_BOSS or targetType == MarchTargetType.ATTACK_SANDWORM then
    ret = self.NormalSpeed * (1 + DataCenter.ArmyFormationDataManager:GetEffectResult(uuid, EffectDefine.FINAL_MONSTER_SPEED_71051, useLightWorkerMan))
  elseif targetType == MarchTargetType.ATTACK_MONSTER then
    if self.specialType == WorldMonsterSpecialType.AllyDrillCow or self.monsterSpecialType == WorldMonsterSpecialType.AllyDrillCow then
      ret = self.RallySpeed
    else
      ret = self.NormalSpeed * (1 + DataCenter.ArmyFormationDataManager:GetEffectResult(uuid, EffectDefine.FINAL_MONSTER_SPEED_71051, useLightWorkerMan))
    end
  elseif targetType == MarchTargetType.ATTACK_DRAGON_BUILDING or targetType == MarchTargetType.ATTACK_EPIDEMIC_BUILDING or targetType == MarchTargetType.ATTACK_WINTER_ENTITY or targetType == MarchTargetType.ATTACK_ARMY_COLLECT or targetType == MarchTargetType.ATTACK_ARMY or targetType == MarchTargetType.TRAIN_ATTACK or targetType == MarchTargetType.ATTACK_CITY or targetType == MarchTargetType.FAKE_ATTACK or targetType == MarchTargetType.ATTACK_WINTER_STORM_CITY or targetType == MarchTargetType.ATTACK_EPIDEMIC_CITY or targetType == MarchTargetType.ATTACK_BUILDING or targetType == MarchTargetType.ATTACK_PLAYER_RUIN_BUILDING or targetType == MarchTargetType.ATTACK_METEORITE then
    local tmpNum = self:GetWinterSpeedAdd(targetType)
    ret = self.NormalSpeed * (1 + DataCenter.ArmyFormationDataManager:GetEffectResult(uuid, EffectDefine.FINAL_PLAYER_SPEED_71052, useLightWorkerMan) + tmpNum)
  elseif targetType == MarchTargetType.COLLECT_ALLIANCE_BUILD_RESOURCE or targetType == MarchTargetType.COLLECT or targetType == MarchTargetType.DETECT_TREASURE or targetType == MarchTargetType.ALLIANCE_RESOURCE_COLLECT or targetType == MarchTargetType.COLLECT_METEORITE or targetType == MarchTargetType.COLLECT_EPIDEMIC_RES then
    local addRatio = DataCenter.ArmyFormationDataManager:GetEffectResult(uuid, EffectDefine.FINAL_GATHER_SPEED_71054, useLightWorkerMan)
    ret = self.ResHelpSpeed * (1 + addRatio)
    if GMUtils.GetBool(GMConst.ShowParkEffectNumberLog, false) then
      Logger.LogCustom(string.format("\233\135\135\233\155\134\232\161\140\229\134\155\233\128\159\229\186\166%.2f = \233\187\152\232\174\164\229\128\188%.2f * ( 1 + addRatio%.2f )", ret, self.ResHelpSpeed, addRatio))
    end
  elseif targetType == MarchTargetType.BUILD_ALLIANCE_BUILDING or targetType == MarchTargetType.RALLY_FOR_BOSS or targetType == MarchTargetType.RALLY_SANDWORM or targetType == MarchTargetType.RALLY_MUMMY_PATROL then
    if self.specialType == WorldMonsterSpecialType.AllyDrill or self.monsterSpecialType == WorldMonsterSpecialType.AllyDrill or self.specialType == WorldMonsterSpecialType.AllyDrillHugeSandWorm or self.monsterSpecialType == WorldMonsterSpecialType.AllyDrillHugeSandWorm or self.specialType == WorldMonsterSpecialType.AllyDrillRoadHog or self.monsterSpecialType == WorldMonsterSpecialType.AllyDrillRoadHog or self.specialType == WorldMonsterSpecialType.ALLIANCE_BOSS_S0 or self.monsterSpecialType == WorldMonsterSpecialType.ALLIANCE_BOSS_S0 then
      ret = self.NormalSpeed
    else
      ret = fixedSoldierType == SoldierType.Mummy and self.MummyRallySpeed or self.RallySpeed
    end
  elseif targetType == MarchTargetType.JOIN_RALLY then
    if self.specialType == WorldMonsterSpecialType.AllyDrill or self.monsterSpecialType == WorldMonsterSpecialType.AllyDrill or self.specialType == WorldMonsterSpecialType.AllyDrillHugeSandWorm or self.monsterSpecialType == WorldMonsterSpecialType.AllyDrillHugeSandWorm or self.specialType == WorldMonsterSpecialType.AllyDrillRoadHog or self.monsterSpecialType == WorldMonsterSpecialType.AllyDrillRoadHog or self.specialType == WorldMonsterSpecialType.ALLIANCE_BOSS_S0 or self.monsterSpecialType == WorldMonsterSpecialType.ALLIANCE_BOSS_S0 then
      ret = self.NormalSpeed
    else
      ret = fixedSoldierType == SoldierType.Mummy and self.MummyJoinRallySpeed or self.RallySpeed
      local addRatio = DataCenter.ArmyFormationDataManager:GetEffectResult(uuid, EffectDefine.JOIN_RALLY_SPEED_UP_94038, useLightWorkerMan)
      ret = ret * (1 + addRatio)
    end
  elseif targetType == MarchTargetType.ATTACK_ALLIANCE_CITY or targetType == MarchTargetType.ATTACK_CITY_TRADE or targetType == MarchTargetType.ATTACK_CITY_ALTAR or targetType == MarchTargetType.ATTACK_OUTPOST_BUILDING or targetType == MarchTargetType.ATTACK_THRONE or targetType == MarchTargetType.ATTACK_CITY_STRONGHOLD or targetType == MarchTargetType.ATTACK_SERVER_THRONE_BUILDING or targetType == MarchTargetType.ATTACK_CENTER_THRONE or targetType == MarchTargetType.RAINFOREST_THRONE_ATTACK or targetType == MarchTargetType.CROSS_BANK_ATTACK then
    ret = self.NormalSpeed * (1 + DataCenter.ArmyFormationDataManager:GetEffectResult(uuid, EffectDefine.FINAL_ALLIANCE_CITY_SPEED_71053, useLightWorkerMan))
  elseif targetType == MarchTargetType.DIRECT_ATTACK_ACT_BOSS or targetType == MarchTargetType.DIRECT_ATTACK_ACT_BERSERK_BOSS then
    ret = self.ActivitySpeed
  elseif targetType == MarchTargetType.ASSISTANCE_CITY or targetType == MarchTargetType.ASSISTANCE_WINTER_STORM_CITY or targetType == MarchTargetType.ASSISTANCE_ALLIANCE_CITY or targetType == MarchTargetType.ASSISTANCE_OUTPOST_BUILDING or targetType == MarchTargetType.ASSISTANCE_CITY_STRONGHOLD or targetType == MarchTargetType.ASSISTANCE_CITY_TRADE or targetType == MarchTargetType.ASSISTANCE_CITY_ALTAR or targetType == MarchTargetType.ASSISTANCE_THRONE or targetType == MarchTargetType.ASSISTANCE_DRAGON_BUILDING or targetType == MarchTargetType.ASSISTANCE_WINTER_ENTITY or targetType == MarchTargetType.ASSISTANCE_EPIDEMIC_BUILDING or targetType == MarchTargetType.ASSISTANCE_SERVER_THRONE_BUILDING or targetType == MarchTargetType.ASSISTANCE_CENTER_THRONE or targetType == MarchTargetType.RAINFOREST_THRONE_ASSISTANCE or targetType == MarchTargetType.REPAIR_OUTPOST then
    local tmpNum = self:GetWinterSpeedAdd(targetType)
    ret = self.NormalSpeed * (1 + DataCenter.ArmyFormationDataManager:GetEffectResult(uuid, EffectDefine.FINAL_ASSIST_SPEED_71057, useLightWorkerMan) + tmpNum)
  elseif targetType == MarchTargetType.ATTACK_DESERT or targetType == MarchTargetType.ATTACK_EMPTY_DESERT then
    ret = self.AttackDesertSpeed * (1 + DataCenter.ArmyFormationDataManager:GetEffectResult(uuid, EffectDefine.FINAL_NORMAL_SPEED_71050) + DataCenter.ArmyFormationDataManager:GetEffectResult(uuid, EffectDefine.LW_SEASON_EFFECT_94024, useLightWorkerMan))
  elseif targetType == MarchTargetType.ASSISTANCE_DESERT then
    ret = self.AssistanceDesertSpeed * (1 + DataCenter.ArmyFormationDataManager:GetEffectResult(uuid, EffectDefine.FINAL_ASSIST_SPEED_71057) + DataCenter.ArmyFormationDataManager:GetEffectResult(uuid, EffectDefine.LW_SEASON_EFFECT_94024, useLightWorkerMan))
  elseif targetType == MarchTargetType.TRAIN_DESERT then
    ret = self.TrainDesertSpeed * (1 + DataCenter.ArmyFormationDataManager:GetEffectResult(uuid, EffectDefine.LW_SEASON_EFFECT_94024, useLightWorkerMan))
  elseif targetType == MarchTargetType.ATTACK_ALLIANCE_BUILDING then
    ret = self.AttackAlliBuildSpeed * (1 + DataCenter.ArmyFormationDataManager:GetEffectResult(uuid, EffectDefine.FINAL_ALLIANCE_CITY_SPEED_71053, useLightWorkerMan))
  elseif targetType == MarchTargetType.ASSISTANCE_ALLIANCE_BUILDING then
    ret = self.AssistanceAlliBuildSpeed * (1 + DataCenter.ArmyFormationDataManager:GetEffectResult(uuid, EffectDefine.FINAL_ASSIST_SPEED_71057, useLightWorkerMan) + DataCenter.ArmyFormationDataManager:GetEffectResult(uuid, EffectDefine.LW_SEASON_EFFECT_94024, useLightWorkerMan))
  elseif targetType == MarchTargetType.RALLY_ALLIANCE_BUILDING then
    ret = fixedSoldierType == SoldierType.Mummy and self.MummyRallySpeed or self.RallyAlliBuildSpeed
  elseif targetType == MarchTargetType.DIG_ICE_ALLY or targetType == MarchTargetType.DIG_ICE_ENEMY or targetType == MarchTargetType.ATTACK_BEHEMOTH then
    ret = self.DigIceSpeed
  elseif targetType == MarchTargetType.WHISTLE_MONSTER then
    ret = self.NormalSpeed * (1 + self.WhistleSpeedAdd)
  else
    ret = fixedSoldierType == SoldierType.Mummy and self.MummyRallySpeed or self.NormalSpeed
  end
  return 0 < ret and ret or 0.5
end

local function SetTargetPoint(self, pos)
  self.targetPoint = pos
end

local function GetTargetType(self)
  return self.targetType
end

local function GetRallyType(self)
  return self.rallyType
end

local function GetCostStaminaByTargetType(self, type)
  if BattleFieldUtil.InBattleField() then
    return 0
  end
  if type == MarchTargetType.RALLY_FOR_BOSS and (self.specialType == WorldMonsterSpecialType.AllyDrill or self.specialType == WorldMonsterSpecialType.AllyDrillHugeSandWorm or self.specialType == WorldMonsterSpecialType.AllyDrillRoadHog or self.specialType == WorldMonsterSpecialType.ALLIANCE_BOSS_S0) then
    return 0
  end
  if type == MarchTargetType.ATTACK_SANDWORM then
    local sandWormData
    local pi = CS.SceneManager.World:GetPointInfo(self.targetPoint)
    if pi then
      sandWormData = pi.sandWorm
    end
    if sandWormData and DataCenter.AllyDrillDataManager:IsMonsterBossSandWormCall(sandWormData.monsterId) then
      return 0
    end
  end
  if self.specialType == WorldMonsterSpecialType.ZoneMobilizationBoss then
    return LuaEntry.DataConfig:TryGetNum("zone_mobilization", "k19", 0)
  end
  if string.IsNullOrEmpty(self.specialType) then
    self.specialType = self.monsterSpecialType
  end
  if self.specialType == WorldMonsterSpecialType.SuperRunningBoss then
    return LuaEntry.DataConfig:TryGetNum("running_boss", "k13", 0)
  end
  if self.specialType == WorldMonsterSpecialType.AL_CHALLENGE_BOSS_KIROV then
    return LuaEntry.DataConfig:TryGetNum("advanced_challenge", "k5", 0)
  end
  if self.specialType == WorldMonsterSpecialType.S1RestCityDefendMonster or self.specialType == WorldMonsterSpecialType.S1RestBloodyQueenGunner then
    return 0
  end
  return MarchUtil.GetCostStaminaByTargetType(type, self.rallyType, self.selectFormationUuid, self.destroyTimes)
end

local function GetFormationPowerByUuid(self, formationUuid)
  local totalPower = 0
  local formation = DataCenter.ArmyFormationDataManager:GetOneArmyInfoByUuid(formationUuid)
  if formation ~= nil then
    totalPower = formation:GetTotalCapacity()
  end
  return totalPower
end

local function GetExploreFormationPowerByUuidAndEventId(self, formationUuid, eventId)
  local totalPower = 0
  local formation = DataCenter.ArmyFormationDataManager:GetOneArmyInfoByUuid(formationUuid)
  if formation ~= nil then
    totalPower = MarchUtil.GetExploreFormationPower(formation.heroes, eventId, formation.index, MarchUtil.GetCampAddParam(formation.heroes))
  end
  return totalPower
end

local function GetMaxCanAddSoldierNum(self, formationUuid)
  local totalNum = 0
  local formation = DataCenter.ArmyFormationDataManager:GetOneArmyInfoByUuid(formationUuid)
  if formation ~= nil then
    totalNum = MarchUtil.GetMaxCanAddSoldierNum(formation.heroes, formation.index)
  end
  return totalNum
end

local function GetFormationFormMaxNum(self, formationUuid)
  local maxNum = 0
  local formationForm = DataCenter.ArmyFormationDataManager:GetOneArmyInfoByUuid(formationUuid)
  if formationForm ~= nil then
    maxNum = formationForm.maxNum
  end
  return maxNum
end

local function GetCurSoldierNum(self, formationUuid)
  local totalNum = 0
  local formation = DataCenter.ArmyFormationDataManager:GetOneArmyInfoByUuid(formationUuid)
  if formation ~= nil then
    table.walk(formation.soldiers, function(k, v)
      if 0 < v then
        totalNum = totalNum + v
      end
    end)
  end
  return totalNum
end

local function GetFormationBuildNameByIndex(self, index)
  local name = ""
  local buildId = MarchUtil.GetFormationBuildNameByIndex(index)
  local buildTemplate = DataCenter.BuildTemplateManager:GetBuildingDesTemplate(buildId)
  if buildTemplate ~= nil then
    name = Localization:GetString(buildTemplate.name)
  end
  return name
end

local function ShowCost(self, marchTargetType)
  return marchTargetType ~= MarchTargetType.EXPLORE
end

local function ShowExplorePower(self, marchTargetType)
  return marchTargetType == MarchTargetType.EXPLORE
end

local function GetCanGatherResourceNum(self, formationUuid, resourceType, itemId)
  local totalNum = 0
  local Player = LuaEntry.Player
  local partNum = 0.001
  if tonumber(resourceType) >= ResourceType.ResourceItem then
    local num = GetTableData(TableName.Aps_Resource_Item, tonumber(itemId), "weight")
    partNum = tonumber(num)
  else
    local strK = "k" .. resourceType + 1
    local basePartNum = LuaEntry.DataConfig:TryGetNum("res_weight", strK)
    local minPartNum = LuaEntry.DataConfig:TryGetNum("res_weight_min", strK)
    local percent = 1
    if resourceType == ResourceType.Food then
      percent = LuaEntry.Effect:GetGameEffect(EffectDefine.APS_MONEY_WEIGHT_PERCENT)
    end
    local realNum = basePartNum * (1 - percent / 100)
    partNum = math.max(minPartNum, realNum)
  end
  if partNum == nil or partNum <= 0 then
    Logger.LogError("can not get weight")
    partNum = 1
  end
  local march = DataCenter.WorldMarchDataManager:GetOwnerFormationMarch(Player.uid, formationUuid, Player.allianceId)
  if march ~= nil then
    local weight = march.armyWeight
    local curNum = march:GetCurArmyWeight()
    local value = math.max(weight - curNum, 0)
    totalNum = math.max(value / partNum, 0)
  else
    local formation = DataCenter.ArmyFormationDataManager:GetOneArmyInfoByUuid(formationUuid)
    if formation ~= nil then
      local value = 0
      local soldiers = formation.soldiers
      local heroes = formation.heroes
      local totalSoliderLoadNum = 0
      local index = formation.index
      if soldiers then
        for k, v in pairs(soldiers) do
          local template = DataCenter.ArmyTemplateManager:GetArmyTemplate(k)
          if template ~= nil then
            local load = template.load
            totalSoliderLoadNum = totalSoliderLoadNum + load * v
          end
        end
      end
      local effectNum = LuaEntry.Effect:GetGameEffect(EffectDefine.ARMY_CARRY_WEIGHT_ADD_PERCENT)
      for k, v in pairs(heroes) do
        local heroData = DataCenter.HeroDataManager:GetHeroByUuid(k)
        if heroData ~= nil then
          effectNum = effectNum + heroData:GetEffectNum(EffectDefine.ARMY_CARRY_WEIGHT_ADD_PERCENT)
        end
      end
      local addValue = MarchUtil.GetFormationAddWeightPercentByFormationIndex(index)
      local careerValue = LuaEntry.Effect:GetGameEffect(EffectDefine.CAREER_COLLECT_ADD_PERCENT)
      local addNum = MarchUtil.GetFormationAddWeightNumByFormationIndex(index)
      value = totalSoliderLoadNum * (careerValue / 100 + effectNum / 100 + addValue / 100 + 1) + addNum
      totalNum = math.max(value / partNum, 0)
    end
  end
  return totalNum
end

local function SetTimeIndex(self, showIndex)
  self.timeIndex = self.ShowIndex2ServerIndex[showIndex]
end

local function OnCreateMarchInGuide(self, uuid, needAutoFix)
  local needFix = 0
  if needAutoFix == true then
    needFix = 1
  end
  local data = self:GetFormationItemData(uuid)
  if data ~= nil then
    self:CloseSelf()
    UIManager:GetInstance():OpenWindow(UIWindowNames.UIFormationTableNew, uuid, self.targetType, self.targetPoint, self.targetUuid, self.timeIndex, self.autoBackHome, data.startPos, self.rallyType, needFix)
  end
end

local function OnChangeMarchInGuide(self, uuid)
end

local function SetAttackTimes(self, tempTimes)
  self.destroyTimes = tempTimes
end

local function GetLower(a, b)
  local powerA = a.formation:GetTotalCapacity()
  local powerB = b.formation:GetTotalCapacity()
  if powerA ~= powerB then
    return powerA < powerB
  end
  return a.index % 4 < a.index % 4
end

local function GetHigher(a, b)
  local powerA = a.formation:GetTotalCapacity()
  local powerB = b.formation:GetTotalCapacity()
  if powerA ~= powerB then
    return powerA > powerB
  end
  return a.index % 4 < a.index % 4
end

local function GetQuicker(self, a, b)
  local timeA = self:GetTimeFormCurPosToTarPos(a.formation.uuid)
  local timeB = self:GetTimeFormCurPosToTarPos(b.formation.uuid)
  if timeA ~= timeB then
    return timeA < timeB
  end
  local powerA = a.formation:GetTotalCapacity()
  local powerB = b.formation:GetTotalCapacity()
  if powerA ~= powerB then
    return powerA > powerB
  end
  return a.index % 4 < a.index % 4
end

local function BestSelect(self)
  local inBattleWorld = BattleFieldUtil.InBattleField()
  local Player = LuaEntry.Player
  local list = DataCenter.ArmyFormationDataManager:GetCurFormationSlotIndexList()
  local targetType = self.targetType
  if targetType == MarchTargetType.ATTACK_DESERT or targetType == MarchTargetType.ATTACK_EMPTY_DESERT then
    local isInSeason = SeasonUtil.IsInSeasonDesertMode()
    if isInSeason then
      local endTilePos = SceneUtils.IndexToTilePos(self.targetPoint, ForceChangeScene.World)
      local startTilePos
      local minDist = 99999999
      local minDistIndex
      local isAtHome = false
      for index, uuid in pairs(list) do
        local formation = DataCenter.ArmyFormationDataManager:GetOneArmyInfoByUuid(uuid)
        local march = DataCenter.WorldMarchDataManager:GetOwnerFormationMarch(Player.uid, formation.uuid, Player.allianceId)
        startTilePos = nil
        if march then
          local startPos = LuaEntry.Player:GetMainWorldPos()
          local troop = CS.SceneManager.World:GetTroop(march.uuid)
          if troop ~= nil then
            startPos = SceneUtils.WorldToTileIndex(troop:GetPosition())
          else
            startPos = SceneUtils.WorldToTileIndex(march:GetMarchCurPos())
          end
          startTilePos = SceneUtils.IndexToTilePos(startPos, ForceChangeScene.World)
        elseif formation:HasHero() then
          startTilePos = SceneUtils.IndexToTilePos(LuaEntry.Player:GetMainWorldPos(), ForceChangeScene.World)
        else
          startTilePos = nil
        end
        if startTilePos then
          local distance = Vector2.Distance(startTilePos, endTilePos)
          if minDist > distance or distance == minDist and not isAtHome and march == nil then
            minDist = distance
            minDistIndex = index
            isAtHome = march == nil
          end
        end
      end
      if minDistIndex then
        return minDistIndex
      end
    end
  end
  local targetNeedUseMummy = false
  if targetType == MarchTargetType.JOIN_RALLY and not inBattleWorld then
    local allianceWarData = DataCenter.AllianceWarDataManager:GetAllianceWarDataByUuid(self.targetUuid)
    if allianceWarData ~= nil and allianceWarData.fixedSoldierType == SoldierType.Mummy then
      targetNeedUseMummy = true
    end
  end
  self.targetNeedUseMummy = targetNeedUseMummy
  local allFormation = {}
  local candidates = {}
  local emptyFormation = {}
  for index, uuid in pairs(list) do
    local candidate = {}
    candidate.index = index
    candidate.formation = DataCenter.ArmyFormationDataManager:GetOneArmyInfoByUuid(uuid)
    candidate.march = DataCenter.WorldMarchDataManager:GetOwnerFormationMarch(Player.uid, candidate.formation.uuid, Player.allianceId)
    table.insert(allFormation, candidate)
    if candidate.march then
      if targetNeedUseMummy then
      elseif candidate.march:GetMarchTargetType() == MarchTargetType.BACK_HOME and not candidate.march.isMummyMarch and not candidate.march:GetIsBroken() and not DataCenter.SeasonHunterManager:IsInBattle() and not BattleFieldUtil.InBattleField() and not IsStartRally[self.targetType] then
        table.insert(candidates, candidate)
      end
    elseif candidate.formation:HasHero() then
      table.insert(candidates, candidate)
    else
      table.insert(emptyFormation, candidate)
    end
  end
  if table.count(candidates) > 0 then
    local useQuickest = false
    local marchData = CS.SceneManager.World:GetMarch(self.targetUuid)
    if not IsNull(marchData) and marchData.monsterId and 0 < marchData.monsterId then
      local meta = DataCenter.MonsterTemplateManager:GetMonsterTemplate(marchData.monsterId)
      useQuickest = meta and meta.recommendType == 1
    end
    for _, candidate in pairs(candidates) do
      if candidate.formation then
        candidate.formation:ConscriptSoldier()
      end
    end
    if useQuickest then
      table.sort(candidates, function(a, b)
        return GetQuicker(self, a, b)
      end)
    else
      table.sort(candidates, GetHigher)
    end
    return candidates[1].index
  elseif table.count(emptyFormation) > 0 then
    return emptyFormation[1].index
  else
    UIUtil.ShowTipsId(GameDialogDefine.NO_AVAILABLE_FORMATION)
    return nil
  end
end

local function TargetSpDeal(self, bShow)
  local theWorld = CS.SceneManager.World
  if theWorld == nil then
    return
  end
  local pointInfo = theWorld:GetPointInfo(self.targetPoint)
  if pointInfo == nil then
    return
  end
  if pointInfo.PointType == WorldPointType.METEORITE_POINT then
    local pointObj = theWorld:GetObjectByPoint(self.targetPoint)
    if pointObj == nil then
      return
    end
    cast(pointObj, typeof(CS.WorldMeteoritePointObject))
    if pointObj ~= nil then
      pointObj:SetCountDownShow(bShow)
    end
  end
end

UIFormationSelectListV2Ctrl.CloseSelf = CloseSelf
UIFormationSelectListV2Ctrl.Close = Close
UIFormationSelectListV2Ctrl.InitData = InitData
UIFormationSelectListV2Ctrl.InitMarchSpeed = InitMarchSpeed
UIFormationSelectListV2Ctrl.SetSelectFormationUuid = SetSelectFormationUuid
UIFormationSelectListV2Ctrl.GetFormationListData = GetFormationListData
UIFormationSelectListV2Ctrl.GetFormationItemData = GetFormationItemData
UIFormationSelectListV2Ctrl.OnAtkClick = OnAtkClick
UIFormationSelectListV2Ctrl.CheckCanBattle = CheckCanBattle
UIFormationSelectListV2Ctrl.GetTimeFormCurPosToTarPos = GetTimeFormCurPosToTarPos
UIFormationSelectListV2Ctrl.GetWinterSpeedAdd = GetWinterSpeedAdd
UIFormationSelectListV2Ctrl.GetMarchSpeed = GetMarchSpeed
UIFormationSelectListV2Ctrl.GetMarchTimeDebugInfo = GetMarchTimeDebugInfo
UIFormationSelectListV2Ctrl.SetTargetPoint = SetTargetPoint
UIFormationSelectListV2Ctrl.GetTargetType = GetTargetType
UIFormationSelectListV2Ctrl.GetRallyType = GetRallyType
UIFormationSelectListV2Ctrl.GetCostStaminaByTargetType = GetCostStaminaByTargetType
UIFormationSelectListV2Ctrl.GetFormationPowerByUuid = GetFormationPowerByUuid
UIFormationSelectListV2Ctrl.ChangeMarchByType = ChangeMarchByType
UIFormationSelectListV2Ctrl.GetFormationBuildNameByIndex = GetFormationBuildNameByIndex
UIFormationSelectListV2Ctrl.NeedTakeArmy = NeedTakeArmy
UIFormationSelectListV2Ctrl.OnCheckTime = OnCheckTime
UIFormationSelectListV2Ctrl.OnCreateClick = OnCreateClick
UIFormationSelectListV2Ctrl.OnEditClick = OnEditClick
UIFormationSelectListV2Ctrl.GetCurSoldierNum = GetCurSoldierNum
UIFormationSelectListV2Ctrl.GetMaxCanAddSoldierNum = GetMaxCanAddSoldierNum
UIFormationSelectListV2Ctrl.ShowCost = ShowCost
UIFormationSelectListV2Ctrl.ShowExplorePower = ShowExplorePower
UIFormationSelectListV2Ctrl.GetExploreFormationPowerByUuidAndEventId = GetExploreFormationPowerByUuidAndEventId
UIFormationSelectListV2Ctrl.SetTimeIndex = SetTimeIndex
UIFormationSelectListV2Ctrl.GetRallyTimeList = GetRallyTimeList
UIFormationSelectListV2Ctrl.OnChangeMarchInGuide = OnChangeMarchInGuide
UIFormationSelectListV2Ctrl.OnCreateMarchInGuide = OnCreateMarchInGuide
UIFormationSelectListV2Ctrl.GetCanGatherResourceNum = GetCanGatherResourceNum
UIFormationSelectListV2Ctrl.InitScoutData = InitScoutData
UIFormationSelectListV2Ctrl.GetAllScoutFormations = GetAllScoutFormations
UIFormationSelectListV2Ctrl.GetInvesFormationUnlockLv = GetInvesFormationUnlockLv
UIFormationSelectListV2Ctrl.GetInvesFormationInfoByIndex = GetInvesFormationInfoByIndex
UIFormationSelectListV2Ctrl.GetScoutSpeed = GetScoutSpeed
UIFormationSelectListV2Ctrl.GetInvesDistance = GetInvesDistance
UIFormationSelectListV2Ctrl.GetScoutStartPoint = GetScoutStartPoint
UIFormationSelectListV2Ctrl.GetElecCost = GetElecCost
UIFormationSelectListV2Ctrl.StartInvestigate = StartInvestigate
UIFormationSelectListV2Ctrl.GetAllMarch = GetAllMarch
UIFormationSelectListV2Ctrl.GetFormationFormMaxNum = GetFormationFormMaxNum
UIFormationSelectListV2Ctrl.SetAttackTimes = SetAttackTimes
UIFormationSelectListV2Ctrl.BestSelect = BestSelect
UIFormationSelectListV2Ctrl.SplitStringToTable = SplitStringToTable
UIFormationSelectListV2Ctrl.TargetSpDeal = TargetSpDeal
return UIFormationSelectListV2Ctrl
