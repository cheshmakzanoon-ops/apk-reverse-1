local UIWorldPointCtrl = BaseClass("UIWorldPointCtrl", UIBaseCtrl)
local Localization = CS.GameEntry.Localization
local WorldPointBtnType = _ENV.WorldPointBtnType
local WorldPointUIType = _ENV.WorldPointUIType
local table_insert = table.insert

local function CloseSelf(self, hidAnim)
  if hidAnim ~= nil and hidAnim == true then
    UIManager.Instance:DestroyWindow(UIWindowNames.UIWorldPoint, {
      anim = true,
      playEffect = false,
      UIMainAnim = UIMainAnimType.ChangeAllShow
    })
  else
    UIManager.Instance:DestroyWindow(UIWindowNames.UIWorldPoint)
  end
end

function UIWorldPointCtrl:RequestWorldPointDetail()
  local worldId = LuaEntry.Player:GetCurWorldId()
  local serverId = self.serverId or LuaEntry.Player:GetCurServerId()
  local info = CS.SceneManager.World:GetPointInfo(self.pointId)
  SFSNetwork.SendMessage(MsgDefines.WorldGetDetail, self.pointId, serverId, worldId, info and info.PointType or 0, self.ownerUid)
end

local function InitData(self, uuid, pointId, ownerUid, type, isAlliance, buildId, isArrow, desertId, flowerTrainIndex)
  local worldId = LuaEntry.Player:GetCurWorldId()
  local serverId = LuaEntry.Player:GetCurServerId()
  local seasonInfo = SeasonUtil.GetSeasonInfo(serverId)
  self.uuid = tonumber(uuid) or 0
  self.pointId = tonumber(pointId) or -1
  self.ownerUid = ownerUid
  self.type = tonumber(type)
  self.isAlliance = tonumber(isAlliance) == 1
  self.buildId = tonumber(buildId) or 0
  self.desertId = tonumber(desertId) or 0
  self.isArrow = isArrow
  self.byDetect = DataCenter.WorldPointWaitOpenManager.byDetect
  self.seasonInfo = seasonInfo
  self.seasonType = seasonInfo and seasonInfo:GetServerType(false) or SeasonMapType.Nothing
  self.flowerTrainIndex = flowerTrainIndex or 1
  DataCenter.WorldPointWaitOpenManager.byDetect = nil
  local info = CS.SceneManager.World:GetPointInfoByUuid(self.uuid)
  if info ~= nil then
    serverId = info.serverId
  else
    local marchInfo = CS.SceneManager.World:GetMarch(self.uuid)
    if marchInfo ~= nil and marchInfo.serverId ~= 0 then
      serverId = marchInfo.serverId
    elseif self.seasonType == SeasonMapType.NineNation and (self.uuid == nil or self.uuid == 0) then
      local touchPos = CS.SceneManager.World.curTouchPoint
      local xIndex = Mathf.Clamp(touchPos.x / TileSize, 0, 2999) // WORLD_TILE_COUNT_MAX
      local yIndex = Mathf.Clamp(touchPos.z / TileSize, 0, 2999) // WORLD_TILE_COUNT_MAX
      local bigZone = toInt(xIndex + 3 * yIndex + 1)
      serverId = seasonInfo:GetNinePalacesServer(bigZone)
    end
  end
  if 0 >= toInt(serverId) then
    serverId = LuaEntry.Player:GetCurServerId()
  end
  self.worldId = worldId
  self.serverId = serverId
  if self.type == WorldPointUIType.Road or self.type == WorldPointUIType.City or self.type == WorldPointUIType.Build or self.type == WorldPointUIType.CollectPoint or self.type == WorldPointUIType.CollectArmy or self.type == WorldPointUIType.AllianceCollectPoint or self.type == WorldPointUIType.Desert or self.type == WorldPointUIType.AllianceMine or self.type == WorldPointUIType.AllianceActMine or self.type == WorldPointUIType.AllianceBuild or self.type == WorldPointUIType.Ruin or self.type == WorldPointUIType.ZombieRush or self.type == WorldPointUIType.Ghostrecon or self.type == WorldPointUIType.ZoneMobilization or self.type == WorldPointUIType.WorldRuinDestroyBuilding or self.type == WorldPointUIType.MeteoriteResPoint or self.type == WorldPointUIType.MeteoriteResCollectArmy or self.type == WorldPointUIType.WinterEntity or self.type == WorldPointUIType.DragonBuild or self.type == WorldPointUIType.EpidemicBuild or self.type == WorldPointUIType.S0AllianceDrillBuilding or self.type == WorldPointUIType.S0AllianceDrillBoss then
    self:RequestWorldPointDetail()
    if self.type == WorldPointUIType.AllianceActMine and LuaEntry.Player:IsInAlliance() then
      SFSNetwork.SendMessage(MsgDefines.GetActMinePlunderRes)
    end
  elseif self.type == WorldPointUIType.ActBoss then
    WorldBossBloodTipManager:GetInstance():SetViewOpen(self.uuid)
  elseif self.type == WorldPointUIType.Train then
    self.trainData = DataCenter.LWTrainDataManager:GetOneTrainByMarchUuid(self.uuid)
    if self.trainData then
      local now = UITimeManager:GetInstance():GetServerTime()
      local pos = self.trainData:CalculateTransform(now)
      self.pointId = SceneUtils.WorldToTileIndex(pos)
      DataCenter.LWTrainDataManager:TryCheckTrainRefresh(self.trainData)
    end
  elseif self.type == WorldPointUIType.HSR then
    local pos = DataCenter.HSRDataManager:GetCurPosition()
    if pos then
      self.pointId = SceneUtils.WorldToTileIndex(pos, ForceChangeScene.World)
    end
    DataCenter.HSRDataManager:FetchActivityData()
  elseif self.type == WorldPointUIType.FlowerTrain then
    self.flowerTrainData = DataCenter.FlowerTrainDataManager:GetFlowerTrainGroupDataByMarchUuid(self.uuid)
  elseif self.type == WorldPointUIType.FlowerTrainReward then
    local info = CS.SceneManager.World:GetPointInfo(pointId)
    self.flowerTrainRewardData = FlowerTrainUtils.ParseFlowerTrainCheerReward(info)
  elseif self.type == WorldPointUIType.WorldAllianceResourceCollect then
    SFSNetwork.SendMessage(MsgDefines.WorldGetAllianceCollectResDetail, self.uuid, serverId, self.pointId)
  elseif self.type == WorldPointUIType.WorldSuppliesPoint or self.type == WorldPointUIType.ZoneMobilizationSuppliesPoint or self.type == WorldPointUIType.DarknessSuppliesPoint then
    SFSNetwork.SendMessage(MsgDefines.WorldGetSuppliesPointDetail, self.uuid, serverId, self.pointId)
    UIUtil.CheckEventTrigger(OpMode.ClickBtnWorldSupplies)
  elseif self.type == WorldPointUIType.BerserkBoss then
    DataCenter.LWBerserkBossManager:RequestBerserkBossDetailData(self.uuid)
  elseif self.type == WorldPointUIType.EpidemicBuild then
    local info = CS.SceneManager.World:GetPointInfo(pointId)
    local detail = info ~= nil and info.detail or nil
    if detail then
      local bTemp = BattleFieldUtil.GetBattlefieldBuildTemplate(detail.BuildId)
      if bTemp and bTemp:IsRes() then
        local info = CS.SceneManager.World:GetPointInfo(self.pointId)
        SFSNetwork.SendMessage(MsgDefines.WorldGetDetail, self.pointId, serverId, worldId, info and info.PointType or 0, self.ownerUid)
      end
    end
  end
end

local function ClearData(self)
  self.trainData = nil
end

local function GetTrainPosition(self)
  if not self.trainData then
    return
  end
  local train = DataCenter.LWTrainManager:GetTrain(self.trainData.uuid)
  if train then
    return train:GetPosition()
  end
  local now = UITimeManager:GetInstance():GetServerTime()
  local worldPos = self.trainData:CalculateTransform(now)
  return worldPos
end

local function GetIsArrow(self)
  return self.isArrow
end

local function SetIsArrow(self)
  self.isArrow = nil
end

local function GetMonsterData(self, uuid)
  local oneData = {}
  oneData.uuid = uuid
  oneData.canAttack = 0
  local troop = CS.SceneManager.World:GetTroop(uuid)
  local marchInfo = CS.SceneManager.World:GetMarch(uuid)
  if troop ~= nil then
    local point = SceneUtils.WorldToTileIndex(troop:GetPosition())
    oneData.point = point
  end
  if marchInfo ~= nil then
    oneData.srcServer = marchInfo.srcServer
    oneData.refreshTime = marchInfo.refreshTime
    oneData.createTime = marchInfo.createTime
    local monsterId = marchInfo.monsterId
    local monster = DataCenter.MonsterTemplateManager:GetMonsterTemplate(monsterId)
    if monster ~= nil then
      oneData.monsterTemplate = monster
      local attackMaxLv = 0
      local marchType = marchInfo:GetMarchType()
      if marchInfo:IsMonster() then
        self.type = WorldPointUIType.Monster
        if SeasonUtil.IsOpenAttackMonsterByLevel(monster.type, monster.special) then
          attackMaxLv = DataCenter.SeasonDataManager:GetMonsterMaxLevel(monster.type)
        else
          attackMaxLv = DataCenter.MonsterManager:GetCurCanAttackMaxLevel()
        end
      elseif marchType == NewMarchType.BOSS or marchInfo:IsOrdinaryBoss() then
        local m_type = WorldPointUIType.Boss
        attackMaxLv = DataCenter.MonsterManager:GetCurCanAttackBossMaxLevel()
        if monster.special == WorldMonsterSpecialType.InvasionBigBoss then
          m_type = WorldPointUIType.Aisilla
        elseif marchInfo:IsAlChallengeKirov() then
          attackMaxLv = math.maxinteger
          m_type = WorldPointUIType.KillZombieKirovBoss
        elseif monster.special == WorldMonsterSpecialType.ALLIANCE_BOSS_S0 then
          attackMaxLv = math.maxinteger
          m_type = WorldPointUIType.S0AllianceDrillBoss
        end
        self.type = m_type
      elseif marchType == NewMarchType.RUNNING_BOSS or marchType == NewMarchType.SANDFISH or marchType == NewMarchType.DARKNESS_MONSTER and (monster.type == LWWorldMonsterType.S4RunningBoss or monster.type == LWWorldMonsterType.FlowerCar) then
        attackMaxLv = math.maxinteger
        self.type = WorldPointUIType.Boss
        if monster.type == LWWorldMonsterType.FlowerCar then
          oneData.monsterHpRatio = marchInfo.monsterHpRatio
          oneData.monsterArmorRatio = marchInfo.darknessMonsterData.flowerCarMonsterData.armorRatio
          oneData.refreshTime = marchInfo.expireTime
        end
      elseif marchType == NewMarchType.CROCODILE then
        attackMaxLv = math.maxinteger
        self.type = WorldPointUIType.Boss
        oneData.refreshTime = marchInfo.expireTime
      elseif marchType == NewMarchType.RUNNING_MUMMY or marchType == NewMarchType.MUMMY then
        attackMaxLv = math.maxinteger
        self.type = WorldPointUIType.Boss
        oneData.endTime = marchInfo.endTime
        oneData.targetPos = marchInfo.targetPos
        oneData.refreshTime = marchInfo.expireTime
        oneData.serverId = marchInfo.serverId
      elseif marchType == NewMarchType.ACT_BERSERK_BOSS then
        attackMaxLv = math.maxinteger
        oneData.monsterHpRatio = marchInfo.monsterHpRatio
        oneData.berserkBossConfigId = marchInfo.berserkBossMetaId
        oneData.endTime = marchInfo.endTime
        oneData.curHp = marchInfo.curHp
        oneData.status = marchInfo:GetMarchStatus()
      elseif marchType == NewMarchType.BEHEMOTH_BOSS then
        attackMaxLv = math.maxinteger
        self.type = WorldPointUIType.Boss
        local attackTime = DataCenter.SeasonNuclearPowerPlantDataManager:GetDailyAttackOrBuildTime(uuid)
        local maxCount = DataCenter.SeasonNuclearPowerPlantDataManager:GetAttackBossMaxTime()
        local list = DataCenter.WorldMarchDataManager:GetOwnerMarches()
        local num = 0
        if list ~= nil then
          for k, v in pairs(list) do
            if v:GetMarchTargetType() == MarchTargetType.ATTACK_BEHEMOTH and v.targetUuid == uuid then
              num = num + 1
            end
          end
        end
        local count = maxCount - attackTime - num
        if count < 0 then
          count = 0
          Logger.LogError(string.format("BEHEMOTH_BOSS, error; attackTime: %s, maxCount: %s", attackTime, maxCount))
        end
        oneData.limitDes = Localization:GetString("season_s2_activity_1000047_description_18") .. count
        oneData.nextSkillTime = marchInfo.nextSkillTime
      elseif marchType == NewMarchType.ZONE_MOBILIZATION_BOSS then
        attackMaxLv = math.maxinteger
        self.type = WorldPointUIType.ZoneMobilizationBoss
        attackMaxLv = tonumber(monster.level)
      end
      if marchType == NewMarchType.DARKNESS_MONSTER then
        oneData.isMoving = marchInfo:IsWanderMonster()
        oneData.refreshTime = marchInfo.expireTime
      end
      local ownerName = marchInfo.ownerName
      local ownerUid = marchInfo.ownerUid
      local abbr = marchInfo.allianceAbbr
      oneData.ownerName = UIUtil.FormatAllianceAndName(abbr, ownerName, ownerUid)
      oneData.attackMaxLv = attackMaxLv
      oneData.ownerUid = ownerUid
      oneData.pic = marchInfo.pic
      oneData.picVer = marchInfo.picVer
      oneData.headSkinId = marchInfo.headSkinId
      oneData.headSkinET = marchInfo.headSkinET
      oneData.level = tonumber(monster.level)
      if attackMaxLv >= oneData.level then
        oneData.canAttack = 1
      end
      if not string.IsNullOrEmpty(marchInfo.eventId) then
        oneData.canAttack = 1
      end
      local configOpenState = LuaEntry.DataConfig:CheckSwitch("detect_monster")
      if configOpenState then
        oneData.canAttack = 1
      end
      oneData.restNum = DataCenter.MonsterManager:GetRestKillBossNum()
      oneData.name = monster.name
      if marchType == NewMarchType.ZONE_MOBILIZATION_BOSS then
        oneData.name = DataCenter.LWZoneMobilizationManager:GetWorldBossDetailNameTitle(marchInfo)
      end
      oneData.shareName = monster.name
      oneData.des = monster.desc
      oneData.special_info = monster.special_info
      oneData.recommend_power = ""
      oneData.limit = monster.limit
      oneData.monsterType = monster.type
      oneData.special = monster.special
      oneData.virusLayer = monster.virusLayer
      oneData.virusProbability = monster.virusProbability
      oneData.marchType = marchType
      local recommend_power = monster.recommend_power
      if 0 < recommend_power then
        oneData.recommend_power = Localization:GetString("300644", string.GetFormattedSeperatorNum(recommend_power))
      end
      local needArmy = monster.needArmy
      if 1 >= needArmy.level then
        oneData.needArmyDesc = Localization:GetString("400018", needArmy.count)
      elseif 1 < needArmy.level then
        oneData.needArmyDesc = Localization:GetString("400019", needArmy.level, needArmy.count)
      end
      oneData.exp = monster.exp
      local belongUid = marchInfo.belongUid
      oneData.belongSelf = belongUid == LuaEntry.Player.uid and oneData.special ~= WorldMonsterSpecialType.GoldenBeetleBoss
      oneData.belongUid = belongUid
      if oneData.special == WorldMonsterSpecialType.IndividualChallengeBoss or oneData.special == WorldMonsterSpecialType.AllyChallengeBoss or oneData.special == WorldMonsterSpecialType.MonsterInvasion or oneData.special == WorldMonsterSpecialType.MonsterInvasionBoss then
        oneData.canAttack = 1
      elseif oneData.special == WorldMonsterSpecialType.AllyDrill or oneData.special == WorldMonsterSpecialType.AllyDrillRoadHog then
        self.type = WorldPointUIType.DrillBase
        oneData.canAttack = false
        local isMine = marchInfo.allianceUid == LuaEntry.Player.allianceId
        if isMine then
          local bossInfo = marchInfo.allianceBoss
          local now = UITimeManager:GetInstance():GetServerTime()
          if bossInfo and 0 < bossInfo.battleStartTime and 0 < bossInfo.battleEndTime and now > bossInfo.battleStartTime and now < bossInfo.battleEndTime then
            oneData.canAttack = true
          end
          oneData.allyDrillStage = DataCenter.AllyDrillDataManager:GetCurStageAndCountDown()
          oneData.allyDrillBossIsAlive = true
          if oneData.special == WorldMonsterSpecialType.AllyDrillRoadHog then
            local data = DataCenter.AllyDrillDataManager.actInfo.data
            local difficulty = data and data.difficultyLevel or 1
            local cfgData = DataCenter.AllyDrillDataManager:GetAllyDrillRoadHogCfg(difficulty)
            oneData.level = cfgData and cfgData.level or 1
          end
        end
      elseif oneData.special == WorldMonsterSpecialType.AllyDrillHugeSandWorm then
        self.type = WorldPointUIType.AllyDrillHugeSandWorm
        oneData.canAttack = false
        local isMine = marchInfo.allianceUid == LuaEntry.Player.allianceId
        if isMine then
          local bossInfo = marchInfo.allianceBoss
          local newBossInfo = bossInfo.dataS3
          local bossIsAlive = newBossInfo.stage < 3 or newBossInfo.stage == 3 and 0 < newBossInfo.curHp
          local now = UITimeManager:GetInstance():GetServerTime()
          if bossInfo and bossIsAlive and 0 < bossInfo.battleStartTime and 0 < bossInfo.battleEndTime and now > bossInfo.battleStartTime and now < bossInfo.battleEndTime then
            oneData.canAttack = true
          end
          oneData.allyDrillStage = DataCenter.AllyDrillDataManager:GetCurStageAndCountDown()
          oneData.allyDrillBossIsAlive = bossIsAlive
          local data = DataCenter.AllyDrillDataManager.actInfo.data
          local difficulty = data and data.difficultyLevel or 1
          local cfgData = DataCenter.AllyDrillDataManager:GetAllyDrillSandwormCfg(difficulty)
          oneData.level = cfgData and cfgData.level or 1
        end
      elseif oneData.special == WorldMonsterSpecialType.CityStrongholdPVE or oneData.special == WorldMonsterSpecialType.CityStrongholdPVP or oneData.special == WorldMonsterSpecialType.CityStrongholdBOSS then
        oneData.canAttack = 1
        SFSNetwork.SendMessage(MsgDefines.GetSeasonMonsterDetail, self.uuid, marchInfo.serverId)
      elseif oneData.special == WorldMonsterSpecialType.BerserkBoss then
        if 0 < oneData.curHp and oneData.status == MarchStatus.ATTACKING then
          oneData.canAttack = 1
        else
          oneData.canAttack = 0
        end
      elseif oneData.special == WorldMonsterSpecialType.InvasionBigBoss then
        self.type = WorldPointUIType.Aisilla
        oneData.canAttack = false
        local isMine = marchInfo.allianceUid == LuaEntry.Player.allianceId
        if isMine then
          local bossInfo = marchInfo.invasionBossInfo
          local now = UITimeManager:GetInstance():GetServerTime()
          oneData.invasionBossInfo = bossInfo
          if bossInfo and 0 < bossInfo.battleStartTime and 0 < bossInfo.battleEndTime and now > bossInfo.battleStartTime and now < bossInfo.battleEndTime then
            oneData.canAttack = true
          end
        end
      elseif oneData.special == WorldMonsterSpecialType.CityGhostBoss then
        local pointInfo = CS.SceneManager.World:GetPointInfo(self.pointId)
        oneData.canAttack = false
        if pointInfo ~= nil then
          local myAlId = LuaEntry.Player.allianceId
          local extraInfo = SeasonUtil.TryParseAllianceCityPointInfo(pointInfo.PointType, pointInfo.extraInfo, pointInfo)
          if extraInfo ~= nil then
            oneData.ownerAllianceId = extraInfo.allianceId
            if (extraInfo.state == AllianceCityState.OCCUPIED or extraInfo.state == AllianceCityState.SERVER_OCCUPIED) and extraInfo.allianceId == myAlId then
              oneData.canAttack = true
            end
            oneData.cityExtraInfo = extraInfo
          end
          oneData.cityPointInfo = pointInfo
        end
        oneData.cityBossNum = toInt(marchInfo.cityBossNum)
        oneData.cityBossMax = toInt(marchInfo.cityBossMax)
        self.type = WorldPointUIType.Boss
        SFSNetwork.SendMessage(MsgDefines.GetSeasonMonsterDetail, uuid, marchInfo.serverId)
      elseif oneData.special == WorldMonsterSpecialType.AL_CHALLENGE_BOSS_KIROV then
        self.type = WorldPointUIType.KillZombieKirovBoss
        oneData.allianceChallengeId = marchInfo.allianceChallengeInfo.configId
        oneData.canAttack = false
        oneData.isPrepare = false
        local isMine = marchInfo.allianceUid == LuaEntry.Player.allianceId
        if isMine then
          local newAlData = DataCenter.ActivityKillZombieManager.newAlData
          if newAlData then
            if newAlData.stage > ChallengeZombieAlBossStage.Prepare then
              oneData.canAttack = true
            elseif newAlData.stage == ChallengeZombieAlBossStage.Prepare then
              oneData.isPrepare = true
            end
          end
        end
        local ok, result = pcall(function()
          local point = self.pointId or oneData.point or 0
          local allianceUid = marchInfo.allianceUid or ""
          local newAlData = DataCenter.ActivityKillZombieManager.newAlData
          local stage = newAlData and newAlData.stage or ""
          SFSNetwork.SendMessage(MsgDefines.AllianceChallengeNewMonsterFind, marchInfo.uuid, point, "canAttack = " .. tostring(oneData.canAttack) .. ", marchInfo.allianceUid = " .. allianceUid .. ", newAlData.stage = " .. stage)
        end)
        if not ok then
          Logger.LogError("KillZombie -- log alliance.challenge.new.monster.find error:", result)
        end
      elseif oneData.special == WorldMonsterSpecialType.S1RestCityDefendMonster then
        self.type = WorldPointUIType.S1RestCityDefendMonster
        oneData.curHp = marchInfo.curHp
        oneData.monsterHpRatio = marchInfo.monsterHpRatio
        oneData.effectList = {}
        if marchInfo.cityBattleS1MonsterInfo then
          table.insert(oneData.effectList, marchInfo.cityBattleS1MonsterInfo)
        end
      elseif oneData.special == WorldMonsterSpecialType.S1RestBloodyQueenMonster or oneData.special == WorldMonsterSpecialType.S1RestBloodyQueenGunner or oneData.special == WorldMonsterSpecialType.S1RestBloodyQueenButcher then
        self.type = WorldPointUIType.S1RestBloodyQueenMonster
        oneData.curHp = marchInfo.curHp
        oneData.monsterHpRatio = marchInfo.monsterHpRatio
      elseif oneData.special == WorldMonsterSpecialType.ALLIANCE_BOSS_S0 then
        self.type = WorldPointUIType.S0AllianceDrillBoss
        local s0AllianceBossInfo = marchInfo.s0AllianceBossInfo
        oneData.s0AllianceBossInfo = s0AllianceBossInfo
        oneData.canAttack = false
        oneData.canMove = 0
        local isMine = marchInfo.allianceUid == LuaEntry.Player.allianceId
        oneData.isMine = isMine
        if isMine and s0AllianceBossInfo then
          local battleEndTime = s0AllianceBossInfo.battleEndTime
          local curTs = UITimeManager:GetInstance():GetServerTime()
          if curTs - battleEndTime < 0 then
            oneData.canAttack = true
          else
            oneData.canMove = DataCenter.S0AllianceBossDataManager:CheckMoveCd()
          end
        end
      end
      if marchType == NewMarchType.ZONE_MOBILIZATION_BOSS then
        local canAttack = oneData.canAttack and 0 < oneData.canAttack
        canAttack = canAttack and marchInfo.serverId == LuaEntry.Player:GetSourceServerId()
        local stage = marchInfo.zMBossInfo and marchInfo.zMBossInfo.stage
        local stageType = DataCenter.LWZoneMobilizationManager:GetStageType(stage)
        oneData.canAttack = canAttack and stageType == ZoneMobilizationStageType.Battle
      end
      if not string.IsNullOrEmpty(marchInfo.allianceUid) then
        oneData.allianceAbbr = marchInfo.allianceAbbr
        oneData.allianceName = marchInfo.allianceName
        oneData.allianceUid = marchInfo.allianceUid
      end
      oneData.exp = DataCenter.HeroStationManager:CalcEffectedValue(oneData.exp, HeroStationEffectType.HeroExp)
      oneData.exp = Mathf.Round(oneData.exp)
      local fisrtRewardFlag = false
      if oneData.special == WorldMonsterSpecialType.GoldenBeetleBoss then
        fisrtRewardFlag = true
      elseif monster.first_reward_type == 1 then
        fisrtRewardFlag = not LuaEntry.Player:IsKillMonster(monsterId)
      elseif DataCenter.LWActivityLockhartManager:IsLockHartBoss(oneData.special) then
        local maxLockhartUnlockLevel = DataCenter.LWActivityLockhartManager:GetMaxLockHartUnlockLevel()
        if maxLockhartUnlockLevel < oneData.level then
          fisrtRewardFlag = true
        else
          fisrtRewardFlag = DataCenter.LWActivityLockhartManager:IsLockHartFirstKill(oneData.level)
        end
      else
        fisrtRewardFlag = oneData.level > LuaEntry.Player.pveLevel
      end
      if fisrtRewardFlag then
        local firstReward = monster:GetProcessedFirstRewardShow()
        if firstReward and 0 < #firstReward then
          oneData.firstRewardStr = firstReward
        end
      end
      oneData.restrictedRewardStr = monster:GetProcessedRestrictedRewardShow()
      oneData.rewardStr = monster:GetProcessedShowReward()
      oneData.possiRewardStr = monster:GetProcessedShowPossibleReward()
      if 0 < monster.monster_resistance then
        oneData.resistance = monster.monster_resistance + SeasonUtil.GetBloodyNightResistanceValueAdd()
      else
        oneData.resistance = 0
      end
      local resistance_type = toInt(monster.resistance_type)
      oneData.selfValue = SeasonUtil.GetSelfSeasonResistanceValue()
      oneData.selfPercent = SeasonUtil.GetSeasonResistanceSelf(oneData.selfValue, oneData.resistance, resistance_type) - 1
      oneData.otherPercent = SeasonUtil.GetSeasonResistanceOther(oneData.selfValue, oneData.resistance, resistance_type)
      local seasonInfo = SeasonUtil.GetCurServerConfig()
      local virusLayer = toInt(oneData.virusLayer)
      if seasonInfo ~= nil and virusLayer <= 0 and seasonInfo:ServerInReady() and seasonInfo:InNormalMode() and seasonInfo:GetServerType(false) == SeasonMapType.CityStronghold then
        if resistance_type == 2 then
          virusLayer = DataCenter.SeasonDataManager:GetDamagePoisonLayer2(oneData.resistance, oneData.selfValue)
        else
          virusLayer = DataCenter.SeasonDataManager:GetDamagePoisonLayer(oneData.selfValue / oneData.resistance)
        end
      end
      oneData.resistance_type = resistance_type
      oneData.virusLayer = virusLayer + DataCenter.SeasonWeatherManager:GetWeatherVirus()
    end
  end
  return oneData
end

local function GetSandWormData(self)
  local oneData = {}
  oneData.uuid = self.uuid
  oneData.canAttack = 0
  oneData.point = self.pointId
  oneData.refreshTime = 0
  oneData.createTime = 0
  local sandWormData
  local marchInfo = CS.SceneManager.World:GetMarch(self.uuid)
  if marchInfo then
    sandWormData = marchInfo.sandWormData
  else
    local pi = CS.SceneManager.World:GetPointInfo(self.pointId)
    if not pi then
      return oneData
    end
    sandWormData = pi.sandWorm
  end
  if not sandWormData then
    return oneData
  end
  oneData.state = sandWormData.state
  oneData.stateEndTime = sandWormData.stateEndTime
  if string.IsNullOrEmpty(sandWormData.stateTriggerInfo) then
    oneData.stateTriggerInfo = ""
  else
    oneData.stateTriggerInfo = Localization:GetString("season_s3_sandworm_tips14", sandWormData.stateTriggerInfo .. " ")
  end
  oneData.expireTime = sandWormData.expireTime
  oneData.finderName = sandWormData.finderName
  oneData.finderUid = sandWormData.finderUid
  oneData.finderAbbr = sandWormData.finderAbbr
  oneData.finderServerId = sandWormData.finderServerId
  local monster = DataCenter.MonsterTemplateManager:GetMonsterTemplate(sandWormData.monsterId)
  if monster == nil then
    return oneData
  end
  oneData.monsterId = monster.id
  oneData.attackMaxLv = DataCenter.MonsterManager:GetCurCanAttackBossMaxLevel() or 0
  oneData.level = tonumber(monster.level)
  oneData.canAttack = 1
  oneData.restNum = DataCenter.MonsterManager:GetRestKillBossNum()
  oneData.name = monster.name
  oneData.icon = monster:GetIcon()
  oneData.shareName = monster.name
  oneData.des = monster.desc
  oneData.special_info = monster.special_info
  oneData.recommend_power = ""
  oneData.monsterType = monster.type
  oneData.special = monster.special
  if DataCenter.AllyDrillDataManager:IsMonsterBossSandWormCall(sandWormData.monsterId) then
    oneData.stamina = 0
  else
    oneData.stamina = monster.special == WorldMonsterSpecialType.SmallSandWorm and 10 or 20
  end
  oneData.virusLayer = monster.virusLayer
  oneData.marchType = NewMarchType.SANDWORM
  local recommend_power = monster.recommend_power
  if 0 < recommend_power then
    oneData.recommend_power = Localization:GetString("300644", string.GetFormattedSeperatorNum(recommend_power))
  end
  local needArmy = monster.needArmy
  if needArmy.level <= 1 then
    oneData.needArmyDesc = Localization:GetString("400018", needArmy.count)
  elseif needArmy.level > 1 then
    oneData.needArmyDesc = Localization:GetString("400019", needArmy.level, needArmy.count)
  end
  oneData.exp = monster.exp
  oneData.belongSelf = false
  oneData.exp = DataCenter.HeroStationManager:CalcEffectedValue(oneData.exp, HeroStationEffectType.HeroExp)
  oneData.exp = Mathf.Round(oneData.exp)
  oneData.discover_reward_show = monster:GetRewardList("discover_reward_show")
  oneData.world_treasure_show = monster:GetRewardList("world_treasure_show")
  local activityRewardList = monster:CheckActivityDrop(false)
  table.insertto(oneData.world_treasure_show, activityRewardList)
  local resistance_type = toInt(monster.resistance_type)
  if 0 < monster.monster_resistance then
    oneData.resistance = monster.monster_resistance + SeasonUtil.GetBloodyNightResistanceValueAdd()
  else
    oneData.resistance = 0
  end
  oneData.selfValue = SeasonUtil.GetSelfSeasonResistanceValue()
  oneData.selfPercent = SeasonUtil.GetSeasonResistanceSelf(oneData.selfValue, oneData.resistance, resistance_type) - 1
  oneData.otherPercent = SeasonUtil.GetSeasonResistanceOther(oneData.selfValue, oneData.resistance, resistance_type)
  return oneData
end

local function GetChallengeBossData(self, uuid)
  local oneData = {}
  oneData.uuid = uuid
  local troop = CS.SceneManager.World:GetTroop(uuid)
  local marchInfo = CS.SceneManager.World:GetMarch(uuid)
  if troop ~= nil then
    local point = SceneUtils.WorldToTileIndex(troop:GetPosition())
    oneData.point = point
  end
  if marchInfo ~= nil then
    oneData.refreshTime = marchInfo.refreshTime
    oneData.ownerName = marchInfo.ownerName
    oneData.bossOwnerUid = marchInfo.bossOwnerUid
    oneData.callHelp = marchInfo.callHelp
    oneData.allianceUid = marchInfo.allianceUid
    local monsterId = marchInfo.monsterId
    local monster = DataCenter.MonsterTemplateManager:GetMonsterTemplate(monsterId)
    if monster ~= nil then
      oneData.name = monster.name
      oneData.shareName = monster.name
      oneData.des = monster.desc
      oneData.size = monster.size
      oneData.level = monster.level
      oneData.rewardStr = {}
      local reward = monster:GetShowReward()
      table.walk(reward, function(k, v)
        local str = v
        if str ~= nil and str ~= "" then
          local strVec = string.split(str, ";")
          if 2 < #strVec then
            local id = tonumber(strVec[1])
            local rewardType = tonumber(strVec[2])
            local num = tonumber(strVec[3])
            if rewardType == RewardType.GOODS then
              local goods = DataCenter.ItemTemplateManager:GetItemTemplate(id)
              if goods ~= nil then
                local item = {}
                item.itemId = id
                item.iconName = string.format(LoadPath.ItemPath, goods.icon)
                item.count = num
                item.itemColor = DataCenter.ItemTemplateManager:GetToolBgByColor(goods.color)
                item.rewardType = rewardType
                item.itemName = DataCenter.ItemTemplateManager:GetName(id)
                item.itemDesc = DataCenter.ItemTemplateManager:GetDes(id)
                item.isLocal = true
                local itemType = goods.type
                if itemType == 2 then
                  if goods.para1 ~= nil and goods.para1 ~= "" then
                    local para1 = goods.para1
                    local temp = string.split(para1, ";")
                    if temp ~= nil and 1 < #temp then
                      item.itemFlag = temp[1] .. temp[2]
                    end
                  end
                elseif itemType == 3 then
                  local type2 = goods.type2
                  if type2 ~= 999 and goods.para ~= nil then
                    local res_num = tonumber(goods.para)
                    item.itemFlag = string.GetFormattedStr(res_num)
                  end
                end
                table.insert(oneData.rewardStr, item)
              end
            elseif rewardType == RewardType.RESOURCE_ITEM then
              local template = DataCenter.ResourceItemDataManager:GetResourceItemTemplate(id)
              if template ~= nil then
                local item = {}
                item.itemId = id
                item.iconName = template:GetIconPath()
                item.rewardType = rewardType
                item.itemColor = "Assets/Main/Sprites/ItemIcons/Common_img_quality_green"
                item.count = num
                item.itemName = template.name
                item.itemDesc = template.desc
                item.isLocal = false
                table.insert(oneData.rewardStr, item)
              end
            else
              local resourceType = RewardToResType[rewardType]
              if resourceType ~= nil then
                local item = {}
                item.itemId = id
                item.iconName = DataCenter.ResourceManager:GetResourceIconByType(resourceType)
                item.itemColor = "Assets/Main/Sprites/ItemIcons/Common_img_quality_green"
                item.rewardType = rewardType
                item.count = num
                item.itemName = ResourceTypeTxt[rewardType]
                item.isLocal = false
                table.insert(oneData.rewardStr, item)
              end
            end
          end
        end
      end)
    end
  end
  return oneData
end

local function GetPuzzleBossData(self, uuid)
  local oneData = {}
  oneData.uuid = uuid
  local troop = CS.SceneManager.World:GetTroop(uuid)
  local marchInfo = CS.SceneManager.World:GetMarch(uuid)
  if troop ~= nil then
    local point = SceneUtils.WorldToTileIndex(troop:GetPosition())
    oneData.point = point
  end
  if marchInfo ~= nil then
    oneData.startTime = marchInfo.actStartTime
    oneData.endTime = marchInfo.actEndTime
    oneData.curBlood = marchInfo:GetHP()
    oneData.maxBlood = marchInfo:GetMaxHP()
    oneData.icon = ""
    local monsterId = marchInfo.monsterId
    local monster = DataCenter.ActivityPuzzleMonsterTemplateManager:GetTemplateByMonsterId(monsterId)
    if monster ~= nil then
      oneData.name = monster.name
      oneData.shareName = monster.name
      oneData.des = "372250"
      oneData.isPuzzleMonster = true
    end
  end
  return oneData
end

local function GetActBossData(self, uuid)
  local oneData = {}
  oneData.uuid = uuid
  local troop = CS.SceneManager.World:GetTroop(uuid)
  local marchInfo = CS.SceneManager.World:GetMarch(uuid)
  if troop ~= nil then
    local point = SceneUtils.WorldToTileIndex(troop:GetPosition())
    oneData.point = point
  end
  if marchInfo ~= nil then
    oneData.startTime = marchInfo.actStartTime
    oneData.endTime = marchInfo.actEndTime
    oneData.curBlood = marchInfo:GetHP()
    oneData.maxBlood = marchInfo:GetMaxHP()
    oneData.icon = ""
    local monsterId = marchInfo.monsterId
    local monster = DataCenter.MonsterTemplateManager:GetMonsterTemplate(monsterId)
    if monster ~= nil then
      oneData.monsterId = monster.monsterId
      oneData.name = monster.name
      oneData.shareName = monster.name
      oneData.des = monster.desc
      oneData.size = monster.size
      oneData.attackLimitLv = monster.limit
    end
  end
  return oneData
end

local function GetMonsterDataInCity(self, uuid)
  local oneData = {}
  oneData.uuid = uuid
  local pointData = DataCenter.CityPointDataManager:GetPointDataByUuid(uuid)
  if pointData ~= nil then
    oneData.point = pointData.pointId
    oneData.canAttack = 0
    oneData.refreshTime = 0
    local monsterId = pointData.itemId
    local monster = DataCenter.MonsterTemplateManager:GetMonsterTemplate(monsterId)
    if monster ~= nil then
      oneData.level = monster.level
      if DataCenter.MonsterManager:GetCurCanAttackMaxLevel() >= oneData.level then
        oneData.canAttack = 1
      end
      oneData.shareName = monster.name
      oneData.name = monster.name
      oneData.des = monster.desc
      oneData.exp = monster.exp
      oneData.recommend_power = ""
      local recommend_power = monster.recommend_power
      if 0 < recommend_power then
        oneData.recommend_power = Localization:GetString("300644", string.GetFormattedSeperatorNum(recommend_power))
      end
      local needArmy = monster.needArmy
      if needArmy.level <= 1 then
        oneData.needArmyDesc = Localization:GetString("400018", needArmy.count)
      elseif needArmy.level > 1 then
        oneData.needArmyDesc = Localization:GetString("400019", needArmy.level, needArmy.count)
      end
      oneData.rewardStr = {}
      oneData.exp = DataCenter.HeroStationManager:CalcEffectedValue(oneData.exp, HeroStationEffectType.HeroExp)
      oneData.exp = Mathf.Round(oneData.exp)
      local reward = monster:GetShowReward()
      table.walk(reward, function(k, v)
        local str = v
        if str ~= nil and str ~= "" then
          local strVec = string.split(str, ";")
          if 2 < #strVec then
            local id = tonumber(strVec[1])
            local rewardType = tonumber(strVec[2])
            local num = tonumber(strVec[3])
            if rewardType == RewardType.GOODS then
              local goods = DataCenter.ItemTemplateManager:GetItemTemplate(id)
              if goods ~= nil then
                local item = {}
                item.itemId = id
                item.iconName = string.format(LoadPath.ItemPath, goods.icon)
                item.count = num
                item.itemColor = DataCenter.ItemTemplateManager:GetToolBgByColor(goods.color)
                item.rewardType = rewardType
                item.itemName = DataCenter.ItemTemplateManager:GetName(id)
                item.itemDesc = DataCenter.ItemTemplateManager:GetDes(id)
                item.isLocal = true
                local itemType = goods.type
                if itemType == 2 then
                  if goods.para1 ~= nil and goods.para1 ~= "" then
                    local para1 = goods.para1
                    local temp = string.split(para1, ";")
                    if temp ~= nil and 1 < #temp then
                      item.itemFlag = temp[1] .. temp[2]
                    end
                  end
                elseif itemType == 3 then
                  local type2 = goods.type2
                  if type2 ~= 999 and goods.para ~= nil then
                    local res_num = tonumber(goods.para)
                    item.itemFlag = string.GetFormattedStr(res_num)
                  end
                end
                table.insert(oneData.rewardStr, item)
              end
            elseif rewardType == RewardType.RESOURCE_ITEM then
              local template = DataCenter.ResourceItemDataManager:GetResourceItemTemplate(id)
              if template ~= nil then
                local item = {}
                item.itemId = id
                item.iconName = template:GetIconPath()
                item.rewardType = rewardType
                item.itemColor = "Assets/Main/Sprites/ItemIcons/Common_img_quality_green"
                item.count = num
                item.itemName = template.name
                item.itemDesc = template.desc
                item.isLocal = false
                table.insert(oneData.rewardStr, item)
              end
            else
              local resourceType = RewardToResType[rewardType]
              if resourceType ~= nil then
                local item = {}
                item.itemId = id
                item.iconName = DataCenter.ResourceManager:GetResourceIconByType(resourceType)
                item.itemColor = "Assets/Main/Sprites/ItemIcons/Common_img_quality_green"
                item.rewardType = rewardType
                item.count = num
                item.itemName = ResourceTypeTxt[rewardType]
                item.isLocal = false
                table.insert(oneData.rewardStr, item)
              end
            end
          end
        end
      end)
    end
  end
  return oneData
end

local function GetMonsterRewardData(self, pointId)
  local oneData = {}
  oneData.point = pointId
  oneData.isInCity = false
  local info = CS.SceneManager.World:GetPointInfo(pointId)
  if info ~= nil then
    local collectRewardInfo = PBController.ParsePbFromBytes(info.extraInfo, "protobuf.CollectRewardInfo")
    if collectRewardInfo ~= nil then
      oneData.uuid = info.uuid
      oneData.refreshTime = collectRewardInfo.expireTime
      local monsterId = collectRewardInfo.contentId
      local monster = DataCenter.MonsterTemplateManager:GetMonsterTemplate(tonumber(monsterId))
      if monster ~= nil then
        oneData.monsterId = monsterId
        oneData.level = monster.level
        oneData.shareName = monster.name
        oneData.name = monster.name
        oneData.des = monster.desc
        oneData.exp = monster.exp
        oneData.recommend_power = ""
        local recommend_power = monster.recommend_power
        if 0 < recommend_power then
          oneData.recommend_power = Localization:GetString("300644", string.GetFormattedSeperatorNum(recommend_power))
        end
        local needArmy = monster.needArmy
        if needArmy.level <= 1 then
          oneData.needArmyDesc = Localization:GetString("400018", needArmy.count)
        elseif needArmy.level > 1 then
          oneData.needArmyDesc = Localization:GetString("400019", needArmy.level, needArmy.count)
        end
        oneData.rewardStr = {}
        oneData.exp = DataCenter.HeroStationManager:CalcEffectedValue(oneData.exp, HeroStationEffectType.HeroExp)
        oneData.exp = Mathf.Round(oneData.exp)
        local reward = monster:GetShowReward()
        table.walk(reward, function(k, v)
          local str = v
          if str ~= nil and str ~= "" then
            local strVec = string.split(str, ";")
            if 2 < #strVec then
              local id = tonumber(strVec[1])
              local rewardType = tonumber(strVec[2])
              local num = tonumber(strVec[3])
              if rewardType == RewardType.GOODS then
                local goods = DataCenter.ItemTemplateManager:GetItemTemplate(id)
                if goods ~= nil then
                  local item = {}
                  item.itemId = id
                  item.iconName = string.format(LoadPath.ItemPath, goods.icon)
                  item.count = num
                  item.itemColor = DataCenter.ItemTemplateManager:GetToolBgByColor(goods.color)
                  item.rewardType = rewardType
                  item.itemName = DataCenter.ItemTemplateManager:GetName(id)
                  item.itemDesc = DataCenter.ItemTemplateManager:GetDes(id)
                  item.isLocal = true
                  local itemType = goods.type
                  if itemType == 2 then
                    if goods.para1 ~= nil and goods.para1 ~= "" then
                      local para1 = goods.para1
                      local temp = string.split(para1, ";")
                      if temp ~= nil and 1 < #temp then
                        item.itemFlag = temp[1] .. temp[2]
                      end
                    end
                  elseif itemType == 3 then
                    local type2 = goods.type2
                    if type2 ~= 999 and goods.para ~= nil then
                      local res_num = tonumber(goods.para)
                      item.itemFlag = string.GetFormattedStr(res_num)
                    end
                  end
                  table.insert(oneData.rewardStr, item)
                end
              elseif rewardType == RewardType.RESOURCE_ITEM then
                local template = DataCenter.ResourceItemDataManager:GetResourceItemTemplate(id)
                if template ~= nil then
                  local item = {}
                  item.itemId = id
                  item.iconName = template:GetIconPath()
                  item.rewardType = rewardType
                  item.itemColor = "Assets/Main/Sprites/ItemIcons/Common_img_quality_green"
                  item.count = num
                  item.itemName = template.name
                  item.itemDesc = template.desc
                  item.isLocal = false
                  table.insert(oneData.rewardStr, item)
                end
              else
                local resourceType = RewardToResType[rewardType]
                if resourceType ~= nil then
                  local item = {}
                  item.itemId = id
                  item.iconName = DataCenter.ResourceManager:GetResourceIconByType(resourceType)
                  item.itemColor = "Assets/Main/Sprites/ItemIcons/Common_img_quality_green"
                  item.rewardType = rewardType
                  item.count = num
                  item.itemName = ResourceTypeTxt[rewardType]
                  item.isLocal = false
                  table.insert(oneData.rewardStr, item)
                end
              end
            end
          end
        end)
      end
    end
  end
  return oneData
end

local function GetMonsterRewardDataInCity(self, uuid)
  local oneData = {}
  oneData.uuid = uuid
  oneData.isInCity = true
  local pointData = DataCenter.CityPointDataManager:GetPointDataByUuid(uuid)
  if pointData ~= nil then
    oneData.point = pointData.pointId
    local arr = string.split(pointData.itemId, ";")
    if 0 < #arr then
      local monsterId = tonumber(arr[1])
      local monster = DataCenter.MonsterTemplateManager:GetMonsterTemplate(monsterId)
      if monster ~= nil then
        oneData.monsterId = monsterId
        oneData.level = monster.level
        oneData.shareName = monster.name
        oneData.name = monster.name
        oneData.des = monster.desc
        oneData.exp = monster.exp
        oneData.recommend_power = ""
        local recommend_power = monster.recommend_power
        if 0 < recommend_power then
          oneData.recommend_power = Localization:GetString("300644", string.GetFormattedSeperatorNum(recommend_power))
        end
        local needArmy = monster.needArmy
        if 1 >= needArmy.level then
          oneData.needArmyDesc = Localization:GetString("400018", needArmy.count)
        elseif 1 < needArmy.level then
          oneData.needArmyDesc = Localization:GetString("400019", needArmy.level, needArmy.count)
        end
        oneData.rewardStr = {}
        oneData.exp = DataCenter.HeroStationManager:CalcEffectedValue(oneData.exp, HeroStationEffectType.HeroExp)
        oneData.exp = Mathf.Round(oneData.exp)
        local reward = monster:GetShowReward()
        table.walk(reward, function(k, v)
          local str = v
          if str ~= nil and str ~= "" then
            local strVec = string.split(str, ";")
            if 2 < #strVec then
              local id = tonumber(strVec[1])
              local rewardType = tonumber(strVec[2])
              local num = tonumber(strVec[3])
              if rewardType == RewardType.GOODS then
                local goods = DataCenter.ItemTemplateManager:GetItemTemplate(id)
                if goods ~= nil then
                  local item = {}
                  item.itemId = id
                  item.iconName = string.format(LoadPath.ItemPath, goods.icon)
                  item.count = num
                  item.itemColor = DataCenter.ItemTemplateManager:GetToolBgByColor(goods.color)
                  item.rewardType = rewardType
                  item.itemName = DataCenter.ItemTemplateManager:GetName(id)
                  item.itemDesc = DataCenter.ItemTemplateManager:GetDes(id)
                  item.isLocal = true
                  local itemType = goods.type
                  if itemType == 2 then
                    if goods.para1 ~= nil and goods.para1 ~= "" then
                      local para1 = goods.para1
                      local temp = string.split(para1, ";")
                      if temp ~= nil and 1 < #temp then
                        item.itemFlag = temp[1] .. temp[2]
                      end
                    end
                  elseif itemType == 3 then
                    local type2 = goods.type2
                    if type2 ~= 999 and goods.para ~= nil then
                      local res_num = tonumber(goods.para)
                      item.itemFlag = string.GetFormattedStr(res_num)
                    end
                  end
                  table.insert(oneData.rewardStr, item)
                end
              elseif rewardType == RewardType.RESOURCE_ITEM then
                local template = DataCenter.ResourceItemDataManager:GetResourceItemTemplate(id)
                if template ~= nil then
                  local item = {}
                  item.itemId = id
                  item.iconName = template:GetIconPath()
                  item.rewardType = rewardType
                  item.itemColor = "Assets/Main/Sprites/ItemIcons/Common_img_quality_green"
                  item.count = num
                  item.itemName = template.name
                  item.itemDesc = template.desc
                  item.isLocal = false
                  table.insert(oneData.rewardStr, item)
                end
              else
                local resourceType = RewardToResType[rewardType]
                if resourceType ~= nil then
                  local item = {}
                  item.itemId = id
                  item.iconName = DataCenter.ResourceManager:GetResourceIconByType(resourceType)
                  item.itemColor = "Assets/Main/Sprites/ItemIcons/Common_img_quality_green"
                  item.rewardType = rewardType
                  item.count = num
                  item.itemName = ResourceTypeTxt[rewardType]
                  item.isLocal = false
                  table.insert(oneData.rewardStr, item)
                end
              end
            end
          end
        end)
      end
    end
  end
  return oneData
end

local function GetRewards(self, rewardList)
  local reward = {}
  if rewardList == nil then
    return reward
  end
  table.walk(rewardList, function(_, v)
    local item = {}
    item.count = v.count
    item.itemColor = DataCenter.ItemTemplateManager:GetToolBgByColor(ItemColor.WHITE)
    item.rewardType = v.rewardType
    item.itemId = v.itemId
    local desc = DataCenter.RewardManager:GetDescByType(v.rewardType, v.itemId)
    local name = DataCenter.RewardManager:GetNameByType(v.rewardType, v.itemId)
    item.itemName = name
    item.itemDesc = desc
    item.isLocal = true
    if v.rewardType == RewardType.GOODS then
      if v.itemId ~= nil then
        local goods = DataCenter.ItemTemplateManager:GetItemTemplate(v.itemId)
        if goods ~= nil then
          local join_method = -1
          local icon_join
          if goods.join_method ~= nil and goods.join_method > 0 and goods.icon_join ~= nil and goods.icon_join ~= "" then
            join_method = goods.join_method
            icon_join = goods.icon_join
          end
          if 0 < join_method and icon_join ~= nil and icon_join ~= "" then
            local tempJoin = string.split(icon_join, ";")
            if 1 < #tempJoin then
              item.itemColor = tempJoin[2]
            end
            if 2 < #tempJoin then
              item.iconName = tempJoin[3]
            end
          else
            item.itemColor = DataCenter.ItemTemplateManager:GetToolBgByColor(goods.color)
            local itemType = goods.type
            if itemType == 2 then
              if goods.para1 ~= nil and goods.para1 ~= "" then
                local para1 = goods.para1
                local temp = string.split(para1, ";")
                if temp ~= nil and 1 < #temp then
                  item.itemFlag = temp[1] .. temp[2]
                end
              end
            elseif itemType == 3 then
              local type2 = goods.type2
              if type2 ~= 999 and goods.para ~= nil and goods.para ~= "" then
                local res_num = tonumber(goods.para)
                item.itemFlag = string.GetFormattedStr(res_num)
              end
            end
            item.iconName = string.format(LoadPath.ItemPath, goods.icon)
          end
        end
      end
    elseif v.rewardType == RewardType.GOLD then
      item.iconName = DataCenter.ResourceManager:GetResourceIconByType(ResourceType.Gold)
      item.itemColor = DataCenter.ItemTemplateManager:GetToolBgByColor(ItemColor.PURPLE)
    elseif v.rewardType == RewardType.OIL or v.rewardType == RewardType.METAL or v.rewardType == RewardType.FORMATION_STAMINA or v.rewardType == RewardType.WATER or v.rewardType == RewardType.PVE_POINT or v.rewardType == RewardType.DETECT_EVENT or v.rewardType == RewardType.FOOD or v.rewardType == RewardType.ELECTRICITY or v.rewardType == RewardType.FLINT or v.rewardType == RewardType.OBSIDIAN then
      item.iconName = DataCenter.RewardManager:GetPicByType(v.rewardType)
      item.itemColor = DataCenter.ItemTemplateManager:GetToolBgByColor(ItemColor.PURPLE)
    elseif v.rewardType == RewardType.RESOURCE_ITEM then
      local template = DataCenter.ResourceItemDataManager:GetResourceItemTemplate(v.itemId)
      if template ~= nil then
        item.itemColor = DataCenter.ItemTemplateManager:GetToolBgByColor(ItemColor.PURPLE)
        item.iconName = template:GetIconPath()
      end
    end
    table.insert(reward, item)
  end)
  return reward
end

local function GetExploreData(self)
  local oneData = {}
  oneData.uuid = self.uuid
  oneData.canAttack = 1
  local data = DataCenter.RadarCenterDataManager:GetDetectEventInfo(self.uuid)
  if data == nil then
    return oneData
  end
  local template = DataCenter.DetectEventTemplateManager:GetDetectEventTemplate(data.eventId)
  if template == nil then
    return oneData
  end
  oneData.shareName = template.name
  oneData.name = template:GetRealName()
  oneData.isRawName = true
  oneData.des = template.description
  oneData.recommend_power = ""
  local recommend_power = template.recommend_power
  if 0 < recommend_power then
    oneData.recommend_power = Localization:GetString("300644", string.GetFormattedSeperatorNum(recommend_power))
  end
  if template.type == DetectEventType.HeroTrial then
    oneData.recommend_power = Localization:GetString("140078", template.para)
  end
  oneData.rewardStr = self:GetRewards(data.rewardList)
  return oneData
end

local function GetDetectEventPVEData(self)
  local oneData = {}
  oneData.uuid = self.uuid
  oneData.canAttack = 1
  local data = DataCenter.RadarCenterDataManager:GetDetectEventInfo(self.uuid)
  if data == nil then
    return oneData
  end
  local template = DataCenter.DetectEventTemplateManager:GetDetectEventTemplate(data.eventId)
  if template == nil then
    return oneData
  end
  oneData.shareName = template.name
  oneData.name = template:GetRealName()
  oneData.isRawName = true
  oneData.des = template.description
  oneData.recommend_power = ""
  local recommend_power = template.recommend_power
  if 0 < recommend_power then
    oneData.recommend_power = Localization:GetString("300644", string.GetFormattedSeperatorNum(recommend_power))
  end
  if template.type == DetectEventType.HeroTrial then
    oneData.recommend_power = Localization:GetString("140078", template.para)
  end
  oneData.rewardStr = self:GetRewards(data.rewardList)
  oneData.para = template.para
  return oneData
end

local function GetDetectEventFakePVPData(self)
  local oneData = {}
  oneData.uuid = self.uuid
  oneData.canAttack = 1
  local data = DataCenter.RadarCenterDataManager:GetDetectEventInfo(self.uuid)
  if data == nil then
    return oneData
  end
  local template = DataCenter.DetectEventTemplateManager:GetDetectEventTemplate(data.eventId)
  if template == nil then
    return oneData
  end
  oneData.shareName = template.name
  oneData.name = template:GetRealName()
  oneData.isRawName = true
  oneData.des = template.description
  oneData.recommend_power = ""
  oneData.rewardStr = self:GetRewards(data.rewardList)
  oneData.para = template.para
  local lwArmyTemplate = DataCenter.LWArmyTemplateManager:GetArmyTemplate(oneData.para)
  oneData.lwArmyTemplate = lwArmyTemplate
  local recommend_power = 0
  if lwArmyTemplate and lwArmyTemplate.pve_power and 0 < #lwArmyTemplate.pve_power then
    for i, v in ipairs(lwArmyTemplate.pve_power) do
      recommend_power = recommend_power + v
    end
  end
  if 0 < recommend_power then
    oneData.recommend_power = Localization:GetString("300644", string.GetFormattedSeperatorNum(recommend_power))
  end
  return oneData
end

local function GetTreasureData(self)
  local oneData = {}
  oneData.uuid = self.uuid
  local info = CS.SceneManager.World:GetPointInfo(self.pointId)
  if info == nil then
    return oneData
  end
  local template = DataCenter.DetectEventTemplateManager:GetDetectEventTemplate(info.eventId)
  if template == nil then
    local eventId = info.eventId
    Logger.LogError("GetTreasureData template is nil, eventId = " .. tostring(eventId))
    return oneData
  end
  oneData.eventId = template.id
  oneData.type = WorldPointUIType.Treasure
  oneData.shareName = template.name
  oneData.pointData = info
  if info.startTime > 0 then
    oneData.refreshTime = info.completionTime
  else
    oneData.refreshTime = info.expireTime
  end
  oneData.shareName = template.name
  oneData.name = template:GetRealName()
  if template:JudgeIsDroneTreasure() then
    oneData.des = "detect_event_desc_1901"
  else
    oneData.des = 801345
  end
  oneData.icon = LoadPath.GarbageIconsPath .. template.pic .. ".png"
  return oneData
end

local function GetSampleData(self)
  local oneData = {}
  oneData.uuid = self.uuid
  local data = DataCenter.RadarCenterDataManager:GetDetectEventInfo(self.uuid)
  if data == nil then
    return oneData
  end
  local template = DataCenter.DetectEventTemplateManager:GetDetectEventTemplate(data.eventId)
  if template == nil then
    return oneData
  end
  oneData.refreshTime = data.endTime
  oneData.shareName = template.name
  oneData.name = template:GetRealName()
  oneData.isRawName = true
  oneData.des = template.description
  local k10 = LuaEntry.DataConfig:TryGetNum("car_action_stamina", "k10")
  oneData.tip = Localization:GetString("140070")
  oneData.tip_1 = tostring(k10)
  oneData.belongSelf = true
  oneData.rewardStr = self:GetRewards(data.rewardList)
  oneData.icon = LoadPath.GarbageIconsPath .. template.pic .. ".png"
  return oneData
end

local function GetRescueData(self)
  local oneData = {}
  oneData.uuid = self.uuid
  local data = DataCenter.RadarCenterDataManager:GetDetectEventInfo(self.uuid)
  if data == nil then
    return oneData
  end
  local template = DataCenter.DetectEventTemplateManager:GetDetectEventTemplate(data.eventId)
  if template == nil then
    return oneData
  end
  oneData.refreshTime = data.endTime
  oneData.shareName = template.name
  oneData.name = template:GetRealName()
  oneData.isRawName = true
  oneData.des = template.description
  oneData.belongSelf = true
  oneData.rewardStr = self:GetRewards(data.rewardList)
  if template.type == DetectEventType.OFF_SEASON_COLLECT_TASK then
    oneData.icon = template.pic
  else
    oneData.icon = LoadPath.GarbageIconsPath .. template.pic .. ".png"
  end
  return oneData
end

function UIWorldPointCtrl:GetAttackCityS0DetectData()
  local oneData = {}
  oneData.uuid = self.uuid
  local data = DataCenter.AttackCityS0DataManager:GetOneEventDataByPointId(self.pointId)
  if data == nil then
    return oneData
  end
  local template = DataCenter.DetectEventTemplateManager:GetDetectEventTemplate(data.eventId)
  if template == nil then
    return oneData
  end
  oneData.refreshTime = data.endTime
  oneData.shareName = template.name
  oneData.name = template:GetRealName()
  oneData.isRawName = true
  oneData.des = template.description
  oneData.belongSelf = true
  oneData.configIdS0 = data.configIdS0
  local rewardId = GetTableData(LuaEntry.Player:GetABTestTableName(TableName.LW_Stage_Feature), oneData.configIdS0, "stage_reward")
  local rewardList = DataCenter.ChampionDuelManager:GetRewardsById(rewardId)
  oneData.rewardStr = self:GetRewards(rewardList)
  local nowLevel = DataCenter.AttackCityS0DataManager:GetActCityLevelAndStateTime()
  local goodsId, limitLevel = DataCenter.AttackCityS0ConfigManager:GetCityClueItemIdAndLevelLimit()
  limitLevel = tonumber(limitLevel)
  if limitLevel <= nowLevel + 1 then
    goodsId = tonumber(goodsId)
    local extraReward = {
      count = 1,
      itemId = goodsId,
      rewardType = RewardType.GOODS
    }
    oneData.possiRewardStr = self:GetRewards({extraReward})
  end
  return oneData
end

local function GetSingleMapGarbageData(self)
  local oneData = {}
  oneData.uuid = self.uuid
  local data = DataCenter.CityPointDataManager:GetPointDataByPointId(self.pointId)
  if data == nil then
    return oneData
  end
  local template = DataCenter.SingleMapJunkTemplateManager:GetTemplate(data.itemId)
  if template == nil then
    return oneData
  end
  oneData.name = template.name
  oneData.des = template.description
  oneData.icon = LoadPath.GarbageIconsPath .. template.pic .. ".png"
  SFSNetwork.SendMessage(MsgDefines.GarbageRewardInfo, self.uuid)
  return oneData
end

local function GetGarbageData(self)
  local oneData = {}
  oneData.uuid = self.uuid
  local data = CS.SceneManager.World:GetGarbagePointInfoByIndex(self.pointId)
  if data == nil then
    return oneData
  end
  local template = DataCenter.DetectEventTemplateManager:GetDetectEventTemplate(data.eventId)
  if template == nil then
    return oneData
  end
  oneData.shareName = template.name
  oneData.name = template:GetRealName()
  oneData.isRawName = true
  oneData.des = template.description
  oneData.refreshTime = data.endTime
  oneData.icon = LoadPath.GarbageIconsPath .. template.pic .. ".png"
  local k8 = LuaEntry.DataConfig:TryGetNum("car_action_stamina", "k8")
  oneData.tip = Localization:GetString("140070")
  oneData.tip_1 = tostring(k8)
  local detail = DataCenter.WorldPointDetailManager:GetDetailByPointId(self.pointId)
  if detail == nil then
    local info = CS.SceneManager.World:GetPointInfo(self.pointId)
    SFSNetwork.SendMessage(MsgDefines.WorldGetDetail, self.pointId, self.serverId, 0, info and info.PointType or 0, self.ownerUid)
    return oneData
  elseif detail.reward == nil or table.count(detail.reward) == 0 then
    local info = CS.SceneManager.World:GetPointInfo(self.pointId)
    SFSNetwork.SendMessage(MsgDefines.WorldGetDetail, self.pointId, self.serverId, 0, info and info.PointType or 0, self.ownerUid)
  else
    oneData.rewardStr = self:GetRewards(detail.reward)
  end
  return oneData
end

function UIWorldPointCtrl:GenDispatchTaskData(oneData)
  oneData.pointData = self:GetDispatchTaskData()
  oneData.btnList = {}
  local info = CS.SceneManager.World:GetPointInfo(self.pointId)
  if info ~= nil then
    local player = LuaEntry.Player
    if player:GetUid() == info.ownerUid then
      oneData.clickBySelf = true
      table.insert(oneData.btnList, WorldPointBtnType.DispatchTask)
    elseif player:IsInAlliance() and player.allianceId == info.allianceId then
      oneData.clickByAlliance = true
      table.insert(oneData.btnList, WorldPointBtnType.DispatchTaskHelp)
    else
      oneData.clickByOther = true
      local protectDispatchTask = false
      local cfgId = info.cfgId
      local completionTime = info.completionTime
      if cfgId then
        if completionTime and 0 < completionTime then
          local cfg = LocalController:instance():getLine(TableName.LwDispatchTask, cfgId)
          if cfg then
            local showTime = cfg.show_time or 0
            if 0 < showTime then
              local curTime = UITimeManager:GetInstance():GetServerTime()
              if curTime < completionTime - showTime * 1000 then
                protectDispatchTask = true
              end
            end
          end
        else
          protectDispatchTask = true
        end
      end
      oneData.protectDispatchTask = protectDispatchTask
      if not protectDispatchTask then
        table.insert(oneData.btnList, WorldPointBtnType.DispatchTaskSteal)
      end
    end
    local playerInfo = DataCenter.PlayerInfoDataManager:GetPlayerDataByUid(info.ownerUid)
    if playerInfo == nil then
      SFSNetwork.SendMessage(MsgDefines.GetNewUserInfo, info.ownerUid)
    end
  end
end

function UIWorldPointCtrl:GetDispatchTaskData()
  local oneData = {}
  oneData.uuid = self.uuid
  local data = CS.SceneManager.World:GetHeroDispatchTaskPointInfoByIndex(self.pointId)
  if data == nil then
    return oneData
  end
  oneData = data
  local cfgId = data.cfgId
  local cfg = LocalController:instance():getLine(TableName.LwDispatchTask, cfgId)
  if cfg == nil then
    return oneData
  end
  local detail = DataCenter.WorldPointDetailManager:GetDetailByPointId(self.pointId)
  if detail == nil then
    local info = CS.SceneManager.World:GetPointInfo(self.pointId)
    SFSNetwork.SendMessage(MsgDefines.WorldGetDetail, self.pointId, self.serverId, 0, info and info.PointType or 0, self.ownerUid)
    return oneData
  end
  return oneData
end

function UIWorldPointCtrl:GenGhostreconData(oneData)
  oneData.pointData = self:GetGhostreconData()
  oneData.btnList = {}
  local info = CS.SceneManager.World:GetPointInfo(self.pointId)
  if info ~= nil then
    local canGet = DataCenter.ActGhostreconManager:IsCanGetTheReward(info.ownerServer)
    local now = UITimeManager:GetInstance():GetServerTime()
    if canGet and info.completionTime > 0 and now >= info.completionTime - 600000 and not info:OwnIsAlly() and not info:OwnIsJoin() then
      table.insert(oneData.btnList, WorldPointBtnType.GhostreconTaskSteal)
    end
  end
end

function UIWorldPointCtrl:GetGhostreconData()
  local oneData = {}
  oneData.uuid = self.uuid
  local data = CS.SceneManager.World:GetGhostreconPointInfoByIndex(self.pointId)
  if data == nil then
    return oneData
  end
  oneData = data
  local cfgId = data.cfgId
  local cfg = LocalController:instance():getLine(TableName.LwGhostreconTask, cfgId)
  if cfg == nil then
    return oneData
  end
  local detail = DataCenter.WorldPointDetailManager:GetDetailByPointId(self.pointId)
  if detail == nil then
    local info = CS.SceneManager.World:GetPointInfo(self.pointId)
    SFSNetwork.SendMessage(MsgDefines.WorldGetDetail, self.pointId, self.serverId, 0, info and info.PointType or 0, self.ownerUid)
    return oneData
  end
  return oneData
end

local function GetPointData(self)
  local oneData = self:PreProcessPointData()
  self:PostProcessPointData(oneData)
  return oneData
end

local function PreProcessPointData(self)
  local seasonType = SeasonUtil.GetSeasonType()
  local isDragonWorld = BattleFieldUtil.InBattleField()
  local oneData = {}
  oneData.pointId = self.pointId
  oneData.pointType = self.type
  oneData.pointUuid = self.uuid
  oneData.ownerUid = self.ownerUid
  oneData.buildId = self.buildId
  oneData.desertId = self.desertId
  oneData.pointData = {}
  oneData.btnList = {}
  oneData.byDetect = self.byDetect
  if self.type == WorldPointUIType.Ruin then
    oneData.pointData = self:GetRuinData(self.pointId)
    if self.ownerUid == LuaEntry.Player.uid or self.isAlliance == true then
      if self:GetIsCrossServer() == false then
        table.insert(oneData.btnList, WorldPointBtnType.DesertBuildList)
      end
      table.insert(oneData.btnList, WorldPointBtnType.AssistanceDesert)
    else
      table.insert(oneData.btnList, WorldPointBtnType.AttackDesert)
      table.insert(oneData.btnList, WorldPointBtnType.ScoutDesert)
    end
    oneData.btnList = table.reverse(oneData.btnList)
    oneData.skipBtnSort = true
  elseif self.type == WorldPointUIType.Desert then
    local info = CS.SceneManager.World:GetPointInfo(self.pointId)
    local canShowBuildList = false
    if info and info.PointType == WorldPointType.WorldRuinPoint then
      oneData.pointData = self:GetRuinData(self.pointId)
    else
      oneData.pointData = self:GetDesertData(self.pointId)
    end
    if self.ownerUid == LuaEntry.Player.uid then
      if canShowBuildList then
        table.insert(oneData.btnList, WorldPointBtnType.DesertBuildList)
      end
      table.insert(oneData.btnList, WorldPointBtnType.AssistanceDesert)
      if MoveCityUtil.CanMoveCity(self.serverId) then
        table.insert(oneData.btnList, WorldPointBtnType.MoveCity)
      end
    elseif self.isAlliance == true then
      if canShowBuildList then
        table.insert(oneData.btnList, WorldPointBtnType.DesertBuildList)
      end
      table.insert(oneData.btnList, WorldPointBtnType.AssistanceDesert)
      if MoveCityUtil.CanMoveCity(self.serverId) then
        table.insert(oneData.btnList, WorldPointBtnType.MoveCity)
      end
    else
      local curTime = UITimeManager:GetInstance():GetServerTime()
      local isProtect = oneData.protectEndTime and curTime < oneData.protectEndTime
      if LuaEntry.Player:IsInAlliance() then
        if oneData.pointData ~= nil and canShowBuildList then
          table.insert(oneData.btnList, WorldPointBtnType.DesertBuildList)
        end
        if not isProtect then
          table.insert(oneData.btnList, WorldPointBtnType.AttackDesert)
          table.insert(oneData.btnList, WorldPointBtnType.ScoutDesert)
        end
        if MoveCityUtil.CanMoveCity(self.serverId) then
          table.insert(oneData.btnList, WorldPointBtnType.MoveCity)
        end
      else
        if not isProtect then
          table.insert(oneData.btnList, WorldPointBtnType.AttackDesert)
          table.insert(oneData.btnList, WorldPointBtnType.ScoutDesert)
        end
        if MoveCityUtil.CanMoveCity(self.serverId) then
          table.insert(oneData.btnList, WorldPointBtnType.MoveCity)
        end
      end
    end
    if DataCenter.MasteryManager:IsShowWorldMasteryBtn() then
      table.insert(oneData.btnList, WorldPointBtnType.MasterySkill)
    end
    oneData.btnList = table.reverse(oneData.btnList)
    oneData.skipBtnSort = true
  elseif self.type == WorldPointUIType.GuideEventMonster then
    oneData.pointData = self:GetGuideEventMonsterData()
    table.insert(oneData.btnList, WorldPointBtnType.GuideEventMonster)
  elseif self.type == WorldPointUIType.AllianceBuild then
    local mainBuildId, carrierBuildId = SeasonUtil.GetSeasonMilitaryCenterId(seasonType)
    local pointData = self:GetAllianceBuildData(self.pointId)
    oneData.pointData = pointData
    if pointData ~= nil and pointData.state == AllianceMineStatus.Ruin then
      if LuaEntry.Player:IsInAlliance() and pointData.allianceId == LuaEntry.Player.allianceId then
        table.insert(oneData.btnList, WorldPointBtnType.ReBuildAllianceRuin)
      end
    else
      local factionMgr = DataCenter.SeasonFactionWarDataManager
      if LuaEntry.Player:IsInAlliance() and pointData.allianceId == LuaEntry.Player.allianceId then
        UIUtil.InsertAssistanceCityBtn(oneData.btnList, self.pointId, WorldPointBtnType.AssistanceAllianceBuild)
        if pointData.state ~= AllianceMineStatus.Ruin and pointData.state ~= AllianceMineStatus.Build then
          if SeasonUtil.IsSeasonMilitaryCenterOrPlugin(pointData.buildId, seasonType) then
            if seasonType == SeasonMapType.Snow then
              table.insert(oneData.btnList, WorldPointBtnType.SeasonStoveCenterInfo)
            elseif seasonType == SeasonMapType.Mummy then
              table.insert(oneData.btnList, WorldPointBtnType.SeasonMummyCenterInfo)
            elseif seasonType == SeasonMapType.Darkness then
              table.insert(oneData.btnList, WorldPointBtnType.SeasonMummyCenterInfo)
              local memberInfo = DataCenter.AllianceGovernmentSkillManager:GetMemberInfoByOfficialPos(LWAlMemberOffcialType.Al_Ambassadoe)
              if memberInfo ~= nil and memberInfo.uid == LuaEntry.Player.uid and (factionMgr.currStep == SeasonFactionDeclareWarStep.battle_before or factionMgr.currStep == SeasonFactionDeclareWarStep.battle) and factionMgr:CanJoinAttack(pointData.allianceId) then
                table.insert(oneData.btnList, WorldPointBtnType.GuardianTowerSkill)
              end
            end
          elseif SeasonUtil.IsSeasonMilitaryCenterCarrier(pointData.buildId, seasonType) then
            if seasonType == SeasonMapType.Snow then
              table.insert(oneData.btnList, WorldPointBtnType.SeasonStoveCenterMove)
            elseif seasonType == SeasonMapType.Mummy then
              table.insert(oneData.btnList, WorldPointBtnType.SeasonMummyCenterMove)
            elseif seasonType == SeasonMapType.Darkness then
              table.insert(oneData.btnList, WorldPointBtnType.SeasonMummyCenterMove)
            end
          end
        end
      elseif SeasonUtil.IsInSeasonSnowMode() then
        if pointData.buildId == BuildingTypes.SEASON_STOVE_CENTER_CARRIER then
          pointData.canAttackIt = true
          if pointData ~= nil and pointData.state ~= AllianceMineStatus.Ruin then
            table.insert(oneData.btnList, WorldPointBtnType.AttackAllianceBuild)
          end
        elseif factionMgr:CanAttackAllianceBuild(pointData.buildId, pointData.allianceId) then
          table.insert(oneData.btnList, WorldPointBtnType.ScoutAllianceBuild)
          if pointData.buildId == BuildingTypes.SEASON_STOVE_CENTER then
            if DataCenter.AllianceGovernmentSkillManager:ExistUsefulSkill() then
              local skillList = DataCenter.AllianceGovernmentSkillManager:GetUsableConfigsByOfficial(LWAlMemberOffcialType.Deputy_Al_Leader)
              if skillList then
                for _, v in ipairs(skillList) do
                  if v and v.skill_flag == AlOfficialSkillType.AresMissile then
                    table.insert(oneData.btnList, WorldPointBtnType.PutAresMissile)
                    break
                  end
                end
              end
            end
            table.insert(oneData.btnList, WorldPointBtnType.RallyAllianceBuild)
          end
          table.insert(oneData.btnList, WorldPointBtnType.AttackAllianceBuild)
        elseif factionMgr:CanAssistAllianceBuild(pointData.buildId, pointData.allianceId) then
          table.insert(oneData.btnList, WorldPointBtnType.AssistanceAllianceBuild)
        else
          table.insert(oneData.btnList, WorldPointBtnType.ScoutAllianceBuild)
          local currStep = factionMgr:GetCurrStep()
          if pointData.buildId == BuildingTypes.SEASON_STOVE_CENTER and (currStep == SeasonFactionDeclareWarStep.battle_before or currStep == SeasonFactionDeclareWarStep.battle) and DataCenter.AllianceGovernmentSkillManager:ExistUsefulSkill() then
            local skillList = DataCenter.AllianceGovernmentSkillManager:GetUsableConfigsByOfficial(LWAlMemberOffcialType.Deputy_Al_Leader)
            if skillList then
              for _, v in ipairs(skillList) do
                if v and v.skill_flag == AlOfficialSkillType.AresMissile then
                  table.insert(oneData.btnList, WorldPointBtnType.PutAresMissile)
                end
              end
            end
          end
        end
      elseif seasonType == SeasonMapType.Mummy or seasonType == SeasonMapType.Darkness then
        if pointData.buildId == carrierBuildId then
          pointData.canAttackIt = true
          if pointData ~= nil and pointData.state ~= AllianceMineStatus.Ruin then
            table.insert(oneData.btnList, WorldPointBtnType.AttackAllianceBuild)
          end
        elseif factionMgr:CanAttackAllianceBuild(pointData.buildId, pointData.allianceId) then
          table.insert(oneData.btnList, WorldPointBtnType.ScoutAllianceBuild)
          if pointData.buildId == mainBuildId then
            local skillType = DataCenter.AllianceGovernmentSkillManager:GetMyUsableOfficialSkillType()
            if skillType == AlOfficialSkillType.AresMissile then
              table.insert(oneData.btnList, WorldPointBtnType.PutAresMissile)
            elseif skillType == AlOfficialSkillType.GoddessMummy and seasonType == SeasonMapType.Mummy then
              table.insert(oneData.btnList, WorldPointBtnType.GoddessMummy)
            end
          end
          if SeasonUtil.IsSeasonMilitaryCenterOrPlugin(pointData.buildId, seasonType) then
            table.insert(oneData.btnList, WorldPointBtnType.RallyAllianceBuild)
          end
          table.insert(oneData.btnList, WorldPointBtnType.AttackAllianceBuild)
        elseif factionMgr:CanAssistAllianceBuild(pointData.buildId, pointData.allianceId) then
          table.insert(oneData.btnList, WorldPointBtnType.AssistanceAllianceBuild)
        else
          table.insert(oneData.btnList, WorldPointBtnType.ScoutAllianceBuild)
          local currStep = factionMgr:GetCurrStep()
          if pointData.buildId == mainBuildId and (currStep == SeasonFactionDeclareWarStep.battle_before or currStep == SeasonFactionDeclareWarStep.battle) then
            local skillType = DataCenter.AllianceGovernmentSkillManager:GetMyUsableOfficialSkillType()
            if skillType == AlOfficialSkillType.AresMissile then
              table.insert(oneData.btnList, WorldPointBtnType.PutAresMissile)
            elseif skillType == AlOfficialSkillType.GoddessMummy and seasonType == SeasonMapType.Mummy then
              table.insert(oneData.btnList, WorldPointBtnType.GoddessMummy)
            end
          end
        end
        if pointData.buildId == mainBuildId then
          UIUtil.CheckEventTrigger(OpMode.ClickBtnAllianceCenter)
        end
      elseif pointData.buildId ~= BuildingTypes.LW_ALLIANCE_WAR_CAMP_2 then
        table.insert(oneData.btnList, WorldPointBtnType.ScoutAllianceBuild)
        if pointData.buildId == mainBuildId then
          table.insert(oneData.btnList, WorldPointBtnType.RallyAllianceBuild)
        end
        table.insert(oneData.btnList, WorldPointBtnType.AttackAllianceBuild)
      end
      if DataCenter.AllianceBaseDataManager:CanSetAllianceCityRallyByAlliancePoint(pointData) then
        table.insert(oneData.btnList, 1, WorldPointBtnType.AllianceCityRally)
      end
    end
    oneData.skipBtnSort = true
  elseif self.type == WorldPointUIType.AllianceMine then
    oneData.pointData = self:GetAllianceMineData(self.pointId)
    if oneData.pointData.allianceId == LuaEntry.Player.allianceId then
      if oneData.pointData.marchInfo ~= nil then
        table.insert(oneData.btnList, WorldPointBtnType.AllianceMineCallback)
      elseif oneData.pointData.state == AllianceMineStatus.Normal then
        table.insert(oneData.btnList, WorldPointBtnType.AllianceMine_Collect)
      else
        table.insert(oneData.btnList, WorldPointBtnType.AllianceMine_Construct)
      end
      table.insert(oneData.btnList, WorldPointBtnType.AllianceMineDetail)
    end
  elseif self.type == WorldPointUIType.AllianceActMine then
    oneData.pointData = self:GetAllianceMineData(self.pointId)
    if oneData.pointData.allianceId == LuaEntry.Player.allianceId then
      if oneData.pointData.marchInfo ~= nil then
        table.insert(oneData.btnList, WorldPointBtnType.AllianceMineCallback)
      end
      table.insert(oneData.btnList, WorldPointBtnType.AllianceActMineDetail)
      table.insert(oneData.btnList, WorldPointBtnType.AllianceActMine_Collect)
    else
      table.insert(oneData.btnList, WorldPointBtnType.AttackAllianceActMine)
      if self:GetIsCrossServer() == false or LuaEntry.DataConfig:CheckSwitch("cross_alliance_rallly_open") then
        table.insert(oneData.btnList, WorldPointBtnType.RallyAllianceActMine)
      end
      table.insert(oneData.btnList, WorldPointBtnType.ScoutAllianceActMine)
    end
  elseif self.type == WorldPointUIType.SandWorm then
    oneData.pointData = self:GetSandWormData()
    if oneData.pointData.special == WorldMonsterSpecialType.SmallSandWorm then
      table.insert(oneData.btnList, WorldPointBtnType.AttackSandworm)
    else
      table.insert(oneData.btnList, WorldPointBtnType.RallySandworm)
    end
  elseif self.type == WorldPointUIType.Monster then
    if CS.SceneManager:IsInCity() then
      oneData.pointData = self:GetMonsterDataInCity(self.uuid)
    else
      oneData.pointData = self:GetMonsterData(self.uuid)
    end
    if oneData.pointData.special == WorldMonsterSpecialType.CityGhostBoss then
      table.insert(oneData.btnList, WorldPointBtnType.RallyBoss)
      oneData.skipBtnSort = true
    elseif oneData.pointData.special == WorldMonsterSpecialType.IndividualChallengeBoss then
      if oneData.pointData.belongSelf or oneData.pointData.ownerUid == LuaEntry.Player.uid then
        table.insert(oneData.btnList, WorldPointBtnType.AttackMonster)
        table.insert(oneData.btnList, WorldPointBtnType.RallyBoss)
      end
    elseif oneData.pointData.special == WorldMonsterSpecialType.AllyChallengeBoss then
      if oneData.pointData.allianceUid == LuaEntry.Player.allianceId then
        table.insert(oneData.btnList, WorldPointBtnType.RallyBoss)
      end
    elseif self.type == WorldPointUIType.Monster then
      if oneData.pointData.canAttack == 1 then
        table.insert(oneData.btnList, WorldPointBtnType.AttackMonster)
      else
        table.insert(oneData.btnList, WorldPointBtnType.Search)
      end
    elseif self.type == WorldPointUIType.Boss then
      if oneData.pointData.special == WorldMonsterSpecialType.CityStrongholdBOSS then
        local zoneId = SceneUtils.GetZoneIdByPosId(self.pointId, self.serverId)
        local canAttack = SeasonUtil.CanAttackCityStronghold(zoneId)
        if not canAttack then
          oneData.pointData.canAttack = 2
        end
        local marchData = CS.SceneManager.World:GetMarch(self.uuid)
        if marchData:IsFrozen() then
          oneData.pointData.wasFrozen = true
          table.insert(oneData.btnList, WorldPointBtnType.DigIceEnemy)
        else
          table.insert(oneData.btnList, WorldPointBtnType.RallyBoss)
        end
        UIUtil.CheckEventTrigger(OpMode.ClickBtnStrongholdMonster, 0, 0.5)
      elseif self:GetIsCrossServer() == false then
        local marchData = CS.SceneManager.World:GetMarch(self.uuid)
        local marchType = marchData:GetMarchType()
        local marchStatus = marchData:GetMarchStatus()
        if marchData:IsFrozen() then
          oneData.pointData.wasFrozen = true
          table.insert(oneData.btnList, WorldPointBtnType.DigIceEnemy)
        else
          local attack = false
          local rallyFlag = true
          if marchType == NewMarchType.BEHEMOTH_BOSS then
            rallyFlag = false
            local t = DataCenter.SeasonNuclearPowerPlantDataManager:BuildNuclearPowerBtnOpen()
            if t and marchStatus == MarchStatus.BEHEMOTH_ATTACK_CITY or marchStatus == MarchStatus.BEHEMOTH_ARRIVING then
              attack = true
            end
          elseif marchType == NewMarchType.SANDFISH or marchType == NewMarchType.MUMMY then
            rallyFlag = false
          elseif marchType == NewMarchType.RUNNING_MUMMY then
            rallyFlag = false
          elseif oneData.pointData.special == WorldMonsterSpecialType.GoldenBeetleBoss then
            attack = true
            rallyFlag = false
            UIUtil.CheckEventTrigger(OpMode.ClickBtnGoldenBeetleBoss)
          elseif oneData.pointData.special == WorldMonsterSpecialType.AllyDrillCow then
            attack = marchData.allianceUid == LuaEntry.Player.allianceId
            rallyFlag = false
          elseif oneData.pointData.monsterType == LWWorldMonsterType.S4RunningBoss then
            if DataCenter.StatusManager:CheckHasStatusByType2(StatusType2.Whistler) then
              table.insert(oneData.btnList, WorldPointBtnType.WhistleMonster)
            else
              table.insert(oneData.btnList, WorldPointBtnType.MasterySkill)
            end
            rallyFlag = false
          elseif oneData.pointData.monsterType == LWWorldMonsterType.FlowerCar and 0 < oneData.pointData.monsterArmorRatio then
            rallyFlag = false
          elseif DataCenter.LWActivityLockhartManager:IsLockHartBoss(oneData.pointData.special) then
            local maxLockhartUnlockLevel = DataCenter.LWActivityLockhartManager:GetMaxLockHartUnlockLevel()
            rallyFlag = maxLockhartUnlockLevel >= oneData.pointData.level
            if not rallyFlag then
              table.insert(oneData.btnList, WorldPointBtnType.Search)
            end
          end
          if attack then
            table.insert(oneData.btnList, WorldPointBtnType.AttackMonster)
          end
          if rallyFlag then
            table.insert(oneData.btnList, WorldPointBtnType.RallyBoss)
          end
        end
      end
    end
    if oneData.pointData.special == WorldMonsterSpecialType.CityStrongholdPVP then
      local zoneId = SceneUtils.GetZoneIdByPosId(self.pointId, self.serverId)
      if LuaEntry.Player:IsInAlliance() then
        local cityMeta = DataCenter.AllianceCityTemplateManager:GetTemplate(zoneId, self.serverId)
        if cityMeta and cityMeta.type == WorldAllianceCityType.Stronghold then
          local v3City = cityMeta:GetWorldPos()
          local v3Monster = SceneUtils.TileIndexToWorld(self.pointId, ForceChangeScene.World, self.serverId)
          if v3City and v3Monster and (math.abs(v3City.x - v3Monster.x) > 12 or 12 < math.abs(v3City.z - v3Monster.z)) then
            zoneId = nil
          end
        else
          zoneId = nil
        end
        if zoneId then
          local myAlCityInfo = DataCenter.WorldAllianceCityDataManager:GetMyAlCityInfo(zoneId)
          if myAlCityInfo ~= nil then
            oneData.pointData.belongSelf = true
          end
        end
      end
      if zoneId and not oneData.pointData.belongSelf then
        local canAttack = SeasonUtil.CanAttackCityStronghold(zoneId)
        if not canAttack then
          oneData.pointData.canAttack = 2
        end
      end
    end
  elseif self.type == WorldPointUIType.DrillBase or self.type == WorldPointUIType.AllyDrillHugeSandWorm or self.type == WorldPointUIType.AllyDrillRoadHog then
    oneData.pointData = self:GetMonsterData(self.uuid)
    if oneData.pointData.allyDrillStage then
      if oneData.pointData.allyDrillStage < AllyDrillStage.AttackStage then
        table.insert(oneData.btnList, WorldPointBtnType.AllyDrilReward)
        table.insert(oneData.btnList, WorldPointBtnType.AllyDrilStart)
        table.insert(oneData.btnList, WorldPointBtnType.AllyDrilDonatel)
        if DataCenter.AllianceBaseDataManager:IsR4orR5() then
          table.insert(oneData.btnList, WorldPointBtnType.AllyDrilMove)
        end
      elseif oneData.pointData.allyDrillStage == AllyDrillStage.AttackStage and oneData.pointData.allyDrillBossIsAlive then
        table.insert(oneData.btnList, WorldPointBtnType.AllyDrilReward)
        table.insert(oneData.btnList, WorldPointBtnType.RallyBoss)
        table.insert(oneData.btnList, WorldPointBtnType.AllyDrilDonatel)
      elseif oneData.pointData.allyDrillStage == AllyDrillStage.SettleStage then
        table.insert(oneData.btnList, WorldPointBtnType.AllyDrilReward)
        if DataCenter.AllyDrillDataManager:HasDigGame() then
          table.insert(oneData.btnList, WorldPointBtnType.AllyDrillDig)
        end
        table.insert(oneData.btnList, WorldPointBtnType.AllyDrilDonatel)
      elseif oneData.pointData.allyDrillStage == AllyDrillStage.End and DataCenter.AllyDrillDataManager:HasDigGame() then
        table.insert(oneData.btnList, WorldPointBtnType.AllyDrillDig)
      end
      oneData.skipBtnSort = true
    end
  elseif self.type == WorldPointUIType.ActBoss then
    oneData.pointData = self:GetActBossData(self.uuid)
    if oneData.pointData then
      local bossActData
      local dataList = DataCenter.ActivityListDataManager:GetActivityDataByType(EnumActivity.WorldBoss.Type)
      if 0 < #dataList then
        bossActData = dataList[1]
      end
      if LuaEntry.Player:AtHomeNow() or bossActData ~= nil then
        table.insert(oneData.btnList, WorldPointBtnType.AttackActBoss)
      end
      if bossActData ~= nil then
        local curTime = UITimeManager:GetInstance():GetServerTime()
        local endTime = bossActData.endTime
        if bossActData.endViewTime ~= nil and bossActData.endViewTime ~= 0 then
          endTime = bossActData.endViewTime
        end
        if curTime >= bossActData.startTime and curTime <= endTime then
          oneData.pointData.activityId = bossActData.id
          table.insert(oneData.btnList, WorldPointBtnType.CheckActBossRank)
        end
      end
    end
  elseif self.type == WorldPointUIType.Train then
    oneData.pointData = self.trainData
    if self.trainData and not self.trainData:IsMyOrAllyTrain() then
      table.insert(oneData.btnList, WorldPointBtnType.AttackTrain)
    end
  elseif self.type == WorldPointUIType.HSR then
    oneData.pointData = DataCenter.HSRDataManager:GetActivityData()
    table.insert(oneData.btnList, WorldPointBtnType.AttackHSR)
    table.insert(oneData.btnList, WorldPointBtnType.TradeHSR)
  elseif self.type == WorldPointUIType.FlowerTrain then
    oneData.pointData = self.flowerTrainData
    if self.flowerTrainData then
    end
  elseif self.type == WorldPointUIType.FlowerTrainReward then
    oneData.pointData = self.flowerTrainRewardData
    if self.flowerTrainRewardData and self.flowerTrainRewardData.isSelf then
      table.insert(oneData.btnList, WorldPointBtnType.FlowerTrainGetReward)
    end
  elseif self.type == WorldPointUIType.WorldTrigger then
    oneData.pointData = CS.SceneManager.World:GetWorldTriggerData(self.uuid)
  elseif self.type == WorldPointUIType.PuzzleBoss then
    oneData.pointData = self:GetPuzzleBossData(self.uuid)
    if self:GetIsCrossServer() == false then
      table.insert(oneData.btnList, WorldPointBtnType.AttackPuzzleBoss)
      table.insert(oneData.btnList, WorldPointBtnType.CheckPuzzleBossRank)
    end
  elseif self.type == WorldPointUIType.WorldRuinDestroyBuilding then
    local pointData = CS.SceneManager.World:GetPointInfo(self.pointId)
    oneData.pointData = pointData
    local name = string.format("#%s[%s]", pointData.playerSrcServerId, pointData.alAbbr)
    oneData.shareName = Localization:GetString("Teleport_Territory_title_1", name)
    if MoveCityUtil.CanMoveCity(self.serverId) and pointData and pointData.allianceId == LuaEntry.Player.allianceId then
      table.insert(oneData.btnList, WorldPointBtnType.MoveCity)
    end
  elseif self.type == WorldPointUIType.WolfShadow then
    local pointData = CS.SceneManager.World:GetPointInfo(self.pointId)
    oneData.pointData = pointData
  elseif self.type == WorldPointUIType.City then
    local info = CS.SceneManager.World:GetPointInfoByUuid(self.uuid)
    if info == nil then
      local tInfo = CS.SceneManager.World:GetPointInfo(self.pointId)
      if tInfo and tInfo.uuid then
        local tUuid = tonumber(self.uuid)
        if tUuid == tInfo.uuid then
          info = tInfo
          Logger.LogInfo("oneData.pointData is nil, fix with GetPointInfo ")
        end
      end
    end
    oneData.pointData = info
    if not info then
      return oneData
    end
    if info and info.ownerUid ~= LuaEntry.Player.uid then
      if info.itemId == BuildingTypes.WORM_HOLE_CROSS then
        if isDragonWorld and BattleFieldUtil.isObserve then
        elseif BattleFieldUtil.InBattleField() then
          local curWorldType = LuaEntry.Player:GetCurWorldType()
          if curWorldType == BattleFieldType.Desert and DataCenter.ActDragonManager:IsSelfCommander() then
            table.insert(oneData.btnList, WorldPointBtnType.DragonCommandOrder)
          elseif BattleFieldUtil.CanUsePingSign() then
            table.insert(oneData.btnList, WorldPointBtnType.BFCommandOrder)
          end
          local bEnemy = not self.isAlliance
          if curWorldType == BattleFieldType.WinterStorm then
            bEnemy = BattleFieldUtil.IsBattleFieldEnemy(info.ownerUid, BattleFieldType.WinterStorm)
          elseif curWorldType == BattleFieldType.EpidemicZone then
            bEnemy = BattleFieldUtil.IsBattleFieldEnemy(info.allianceId, BattleFieldType.EpidemicZone)
          end
          if bEnemy then
            table.insert(oneData.btnList, WorldPointBtnType.AttackCity)
            if curWorldType ~= BattleFieldType.WinterStorm then
              table.insert(oneData.btnList, WorldPointBtnType.RallyCity)
            end
            table.insert(oneData.btnList, WorldPointBtnType.ScoutCity)
          else
            UIUtil.InsertAssistanceCityBtn(oneData.btnList, self.pointId, WorldPointBtnType.AssistanceCity)
          end
        end
      elseif self.isAlliance == true then
        if info:GetAOSType() == AlOfficialSkillType.AresMissile then
          table.insert(oneData.btnList, WorldPointBtnType.HelperDetect)
        else
          local helpDetectData = DataCenter.RadarCenterDataManager:GetHelperEventDataByBuildUid(self.uuid)
          if helpDetectData ~= nil and helpDetectData.state == DetectEventState.DETECT_EVENT_STATE_NOT_FINISH then
            table.insert(oneData.btnList, WorldPointBtnType.HelperDetect)
          end
        end
        if self:GetIsCrossServer() == false then
          UIUtil.InsertAssistanceCityBtn(oneData.btnList, self.pointId, WorldPointBtnType.AssistanceCity)
        elseif self.seasonType == SeasonMapType.NineNation then
          local isBigMapMode, curSameGroup, srcSameGroup, loginSameGroup = SeasonUtil.InSeasonBigMapMode(self.serverId)
          if isBigMapMode and loginSameGroup then
            UIUtil.InsertAssistanceCityBtn(oneData.btnList, self.pointId, WorldPointBtnType.AssistanceCity)
          end
        end
        if LuaEntry.Player:IsInSelfServer() and self.seasonType == SeasonMapType.Snow then
          local config = SeasonUtil.GetCurServerConfig()
          if config and config.open and config.mode == 1 then
            table.insert(oneData.btnList, WorldPointBtnType.SendCoal)
          end
        end
        oneData.refuseTreadVirus = info.refuseTreadVirus
        oneData.refusePowerHelper = false
        if not isDragonWorld then
          local virusLayer = toInt(info.virusLayer or 0)
          if 0 < virusLayer then
            local virusEndTime = toInt(info.virusEndTime or 0)
            virusLayer, virusEndTime = SeasonUtil.CalcVirusLevel(virusLayer, virusEndTime)
            if 0 < virusLayer then
              table.insert(oneData.btnList, WorldPointBtnType.EliminateVirus)
            end
          end
          if info.uuid ~= nil then
            if 0 < toInt(virusLayer) then
              CityDomeProtectEffectManager:GetInstance():ShowVirusEffect(info)
            else
              CityDomeProtectEffectManager:GetInstance():RemoveVirusEffect(info.uuid)
            end
          end
          if SeasonUtil.IsInSeason(true) then
            if seasonType == SeasonMapType.Mummy then
              local mummyConvertCount = toInt(info.mummyConvertCount or 0)
              if 0 < mummyConvertCount then
                table.insert(oneData.btnList, WorldPointBtnType.MummyConvert)
              elseif info.uuid ~= nil then
                CityDomeProtectEffectManager:GetInstance():RemoveMummyEffect(info.uuid)
              end
            elseif seasonType == SeasonMapType.Darkness then
              if DataCenter.SeasonPowerWorkerManager:IsLightHouseActive() then
                table.insert(oneData.btnList, WorldPointBtnType.SendPowerHelper)
              end
            elseif seasonType == SeasonMapType.NineNation and info and info.wallBarInfo and info.wallBarInfo:IsValid() then
              table.insert(oneData.btnList, WorldPointBtnType.ReinforceWall)
              DataCenter.MasteryManager:ReqGetFortifyDailyCount(info.ownerUid)
            end
          end
        end
        local isFire = BuildFireEffectManager:GetInstance():GetBuildIsFire(self.uuid)
        if isFire and DataCenter.BuildHelpStopFireManager:IsOpen() then
          table.insert(oneData.btnList, WorldPointBtnType.Firefighting)
        end
        if info:IsFrozen() then
          table.insert(oneData.btnList, WorldPointBtnType.DigIceAlly)
        end
      else
        if info:IsFrozen() then
          table.insert(oneData.btnList, WorldPointBtnType.DigIceEnemy)
        else
          table.insert(oneData.btnList, WorldPointBtnType.AttackCity)
          if self:GetIsCrossServer() == false then
            table.insert(oneData.btnList, WorldPointBtnType.RallyCity)
          end
        end
        table.insert(oneData.btnList, WorldPointBtnType.ScoutCity)
      end
    elseif info then
      if info.itemId == BuildingTypes.WORM_HOLE_CROSS then
        if BattleFieldUtil.InBattleField(BattleFieldType.Desert) and DataCenter.ActDragonManager:IsSelfCommander() then
          table.insert(oneData.btnList, WorldPointBtnType.DragonCommandOrder)
        elseif BattleFieldUtil.CanUsePingSign() then
          table.insert(oneData.btnList, WorldPointBtnType.BFCommandOrder)
        end
        table.insert(oneData.btnList, WorldPointBtnType.Wall_Deployment)
      elseif info.specialType == CS.Protobuf.SpecialType.DetectEvent then
        table.insert(oneData.btnList, WorldPointBtnType.AttackCity)
      else
        local unlock, lockTips = DataCenter.LWFunctionUnlockManager:CheckCanShow(LWFunctionUnlockType.City_Shield)
        if unlock then
          table.insert(oneData.btnList, WorldPointBtnType.CityShield)
        end
        table.insert(oneData.btnList, WorldPointBtnType.Wall_Deployment)
        if DataCenter.DecorationDataManager:IsSystemOpen() then
          table.insert(oneData.btnList, WorldPointBtnType.Decoration)
        end
      end
    end
    if info then
      if info.ownerUid == LuaEntry.Player.uid and info:IsNormalType() then
        local IsShowWorldMasteryBtn = DataCenter.MasteryManager:IsShowWorldMasteryBtn()
        local IsCitySkinSkillShow = DataCenter.CitySkinSkillManager:IsHaveSkillShow()
        if not isDragonWorld and (IsShowWorldMasteryBtn or IsCitySkinSkillShow) or isDragonWorld and IsCitySkinSkillShow then
          table.insert(oneData.btnList, WorldPointBtnType.MasterySkill)
        end
      elseif DataCenter.MasteryManager:IsShowWorldMasteryBtn() then
        table.insert(oneData.btnList, WorldPointBtnType.MasterySkill)
      end
    end
  elseif self.type == WorldPointUIType.Build then
    if self.buildId == BuildingTypes.LW_CITY_RUIN or self.buildId == BuildingTypes.LW_CITY_RUIN_1 then
      if DataCenter.MasteryManager:IsShowWorldMasteryBtn() then
        table.insert(oneData.btnList, WorldPointBtnType.AttackPlayerRuinBuilding)
      end
    else
      local info = CS.SceneManager.World:GetPointInfoByUuid(self.uuid)
      if info ~= nil then
        cast(info, typeof(CS.BuildPointInfo))
        if info ~= nil and 0 >= info.destroyStartTime and info.ownerUid ~= LuaEntry.Player.uid then
          if self.isAlliance == true then
            table.insert(oneData.btnList, WorldPointBtnType.AssistanceBuild)
          else
            table.insert(oneData.btnList, WorldPointBtnType.AttackBuild)
            if self:GetIsCrossServer() == false then
              table.insert(oneData.btnList, WorldPointBtnType.RallyBuild)
            end
            table.insert(oneData.btnList, WorldPointBtnType.ScoutBuild)
          end
        end
      end
      if SeasonUtil.IsSeasonPlayerBuilding(info.itemId) then
        oneData.isSeasonPlayerBuilding = true
        oneData.recoverSpeed = info.recoverSpeed
        if DataCenter.MasteryManager:IsShowWorldMasteryBtn() then
          table.insert(oneData.btnList, WorldPointBtnType.MasterySkill)
        end
      end
      if self.buildId == BuildingTypes.FUN_BUILD_KONBINI and DataCenter.StorageShopManager:CheckIfIsActive() then
        table.insert(oneData.btnList, WorldPointBtnType.StorageShop)
      end
    end
  elseif self.type == WorldPointUIType.Road then
    if self.isAlliance == false then
      table.insert(oneData.btnList, WorldPointBtnType.AttackRoad)
    end
  elseif self.type == WorldPointUIType.CollectPoint then
    oneData.pointData = self:GetResourceData(self.pointId)
    if BattleFieldUtil.InBattleField(BattleFieldType.Desert) then
      if not BattleFieldUtil.isObserve then
        if DataCenter.ActDragonManager:IsSelfCommander() then
          table.insert(oneData.btnList, WorldPointBtnType.DragonCommandOrder)
        end
        table.insert(oneData.btnList, WorldPointBtnType.Collect)
      end
    else
      table.insert(oneData.btnList, WorldPointBtnType.Collect)
      if TacticalCardUtil.IsFunctionOpen() and TacticalCardUtil.IsEquipTargetCardSkillEffect(TCCardSkillEffectType.GetRemainResourceImmediate) then
        table.insert(oneData.btnList, WorldPointBtnType.TacticalCardSkill)
      end
    end
  elseif self.type == WorldPointUIType.MeteoriteResPoint then
    oneData.pointData = self:GetMeteoriteData(self.pointId)
    table.insert(oneData.btnList, WorldPointBtnType.CollectMeteorite)
  elseif self.type == WorldPointUIType.MeteoriteResCollectArmy then
    if self.ownerUid == LuaEntry.Player.uid then
      oneData.pointData = self:GetMeteoriteData(self.pointId, true)
      table.insert(oneData.btnList, WorldPointBtnType.CallBack)
    else
      oneData.pointData = self:GetMeteoriteData(self.pointId, true)
      if self.isAlliance == false then
        table.insert(oneData.btnList, WorldPointBtnType.ScoutArmyMeteoriteCollect)
        table.insert(oneData.btnList, WorldPointBtnType.AttackArmyMeteoriteCollect)
      end
    end
  elseif self.type == WorldPointUIType.CityResPoint then
    oneData.pointData = self:GetCityResourceData(self.pointId)
  elseif self.type == WorldPointUIType.AllianceCollectPoint then
    oneData.pointData = self:GetAllianceResourceData(self.pointId)
    if self:GetIsCrossServer() == false then
      table.insert(oneData.btnList, WorldPointBtnType.AllianceCollect)
    end
  elseif self.type == WorldPointUIType.CollectArmy then
    oneData.skipBtnSort = true
    local bAdd = true
    if BattleFieldUtil.InBattleField(BattleFieldType.Desert) then
      if BattleFieldUtil.isObserve then
        bAdd = false
      elseif DataCenter.ActDragonManager:IsSelfCommander() then
        table.insert(oneData.btnList, WorldPointBtnType.DragonCommandOrder)
      end
    end
    if bAdd then
      if TacticalCardUtil.IsFunctionOpen() and TacticalCardUtil.IsEquipTargetCardSkillEffect(TCCardSkillEffectType.GetRemainResourceImmediate) then
        table.insert(oneData.btnList, WorldPointBtnType.TacticalCardSkill)
      end
      if self.ownerUid == LuaEntry.Player.uid then
        oneData.pointData = self:GetCollectData(self.pointId, true)
        table.insert(oneData.btnList, WorldPointBtnType.CallBack)
        table.insert(oneData.btnList, WorldPointBtnType.Detail)
      else
        oneData.pointData = self:GetCollectData(self.pointId, true)
        if self.isAlliance == false then
          table.insert(oneData.btnList, WorldPointBtnType.ScoutArmyCollect)
          table.insert(oneData.btnList, WorldPointBtnType.AttackArmyCollect)
        end
      end
    end
  elseif self.type == WorldPointUIType.Explore then
    oneData.pointData = self:GetExploreData()
    table.insert(oneData.btnList, WorldPointBtnType.Explore)
  elseif self.type == WorldPointUIType.DetectEventPVE then
    oneData.pointData = self:GetDetectEventPVEData()
    table.insert(oneData.btnList, WorldPointBtnType.DetectEventPVE)
  elseif self.type == WorldPointUIType.DetectEventFakePVP then
    oneData.pointData = self:GetDetectEventFakePVPData()
    table.insert(oneData.btnList, WorldPointBtnType.DetectEventFakePVP)
  elseif self.type == WorldPointUIType.Treasure then
    oneData.pointData = self:GetTreasureData()
    local info = CS.SceneManager.World:GetPointInfoByUuid(self.uuid)
    if info ~= nil then
      if info:IsFrozen() then
        oneData.pointData.wasFrozen = true
        table.insert(oneData.btnList, WorldPointBtnType.DigIceAlly)
        return oneData
      end
      cast(info, typeof(CS.TreasurePointInfo))
      local isHaveWorking = info:IsHaveWorking(LuaEntry.Player.uid)
      if isHaveWorking then
        table.insert(oneData.btnList, WorldPointBtnType.CallBack)
      else
        table.insert(oneData.btnList, WorldPointBtnType.Treasure)
      end
    end
  elseif self.type == WorldPointUIType.Sample then
    oneData.pointData = self:GetSampleData()
    table.insert(oneData.btnList, WorldPointBtnType.Sample)
  elseif self.type == WorldPointUIType.Rescue then
    oneData.pointData = self:GetRescueData()
    table.insert(oneData.btnList, WorldPointBtnType.Rescue)
  elseif self.type == WorldPointUIType.PickGarbage then
    oneData.pointData = self:GetGarbageData()
    table.insert(oneData.btnList, WorldPointBtnType.PickGarbage)
  elseif self.type == WorldPointUIType.DispatchTask then
    self:GenDispatchTaskData(oneData)
  elseif self.type == WorldPointUIType.Ghostrecon then
    self:GenGhostreconData(oneData)
  elseif self.type == WorldPointUIType.SingleMapGarbage then
    oneData.pointData = self:GetSingleMapGarbageData()
  elseif self.type == WorldPointUIType.MonsterReward then
    if CS.SceneManager:IsInCity() then
      oneData.pointData = self:GetMonsterRewardDataInCity(self.uuid)
    else
      oneData.pointData = self:GetMonsterRewardData(self.pointId)
    end
    table.insert(oneData.btnList, WorldPointBtnType.GetReward)
  elseif self.type == WorldPointUIType.MonsterLock then
    oneData.pointData = self:GetMonsterLockData(self.pointId)
    table.insert(oneData.btnList, WorldPointBtnType.MonsterLockAttack)
  elseif self.type == WorldPointUIType.ChallengeBoss then
    oneData.pointData = self:GetChallengeBossData(self.uuid)
    if self:GetIsCrossServer() == false then
      table.insert(oneData.btnList, WorldPointBtnType.AttackActChallenge)
      table.insert(oneData.btnList, WorldPointBtnType.ChallengeHelp)
    end
  elseif self.type == WorldPointUIType.ZombieRush then
    oneData.pointData = self:GetZombieRushData(self.pointId)
  elseif self.type == WorldPointUIType.WorldAllianceResourceCollect then
    oneData.pointData = self:GetAllianceCollectData(self.pointId)
    oneData.btnList = {}
  elseif self.type == WorldPointUIType.WorldSuppliesPoint or self.type == WorldPointUIType.ZoneMobilizationSuppliesPoint or self.type == WorldPointUIType.DarknessSuppliesPoint then
    oneData.pointData = self:GetWorldSuppliesData(self.pointId)
    oneData.btnList = {}
  elseif self.type == WorldPointUIType.WorldDetectSurvivor then
    oneData.pointData = self:GetWorldDetectSurvivor(self.pointId)
    oneData.btnList = {}
    if oneData.pointData.isFronzen then
      table.insert(oneData.btnList, WorldPointBtnType.DigIceEnemy)
    else
      table.insert(oneData.btnList, WorldPointBtnType.WorldDetectSaveSurvivor)
    end
  elseif self.type == WorldPointUIType.WorldDetectCaveExploration then
    local data = {}
    data.pointId = self.pointId
    local info = CS.SceneManager.World:GetPointInfo(self.pointId)
    cast(info, typeof(CS.SamplePointInfo))
    if info ~= nil and info.eventId then
      data.eventId = info.eventId
      local template = DataCenter.DetectEventTemplateManager:GetDetectEventTemplate(info.eventId)
      if template then
        local name = template:GetRealName()
        local tip = Localization:GetString(template.description)
        data.name = name
        data.tip = tip
        data.uuid = self.uuid
        data.panel_image = template.panel_image
      end
    end
    oneData.pointData = data
    oneData.btnList = {}
    table.insert(oneData.btnList, WorldPointBtnType.DetectEventCaveExploration)
  elseif self.type == WorldPointUIType.DragonBuild or self.type == WorldPointUIType.WinterEntity or self.type == WorldPointUIType.EpidemicBuild then
    oneData.battlefieldType = BattleFieldUtil.GetCurBattleFieldType()
    local mgr = BattleFieldUtil.GetMgrActive()
    local pointData = mgr:GetBuildData(self.pointId)
    oneData.pointData = pointData
    if pointData.ownerUid then
      self.ownerUid = pointData.ownerUid
    end
    oneData.skipBtnSort = true
    mgr:FillBuildBtnList(pointData, oneData.btnList)
  elseif self.type == WorldPointUIType.BerserkBoss then
    oneData.pointData = self:GetMonsterData(self.uuid)
    oneData.btnList = {}
    if oneData.pointData.canAttack == 1 then
      local surplusAttackTimes = DataCenter.LWBerserkBossManager:GetBerserkBossSurplusAttackTimes(self.uuid)
      if 0 < surplusAttackTimes then
        table.insert(oneData.btnList, WorldPointBtnType.BerserkBossAttack)
      end
      table.insert(oneData.btnList, WorldPointBtnType.BerserkBossRank)
    end
  elseif self.type == WorldPointUIType.Aisilla then
    oneData.pointData = self:GetMonsterData(self.uuid)
    local isPlanFuncOpen = DataCenter.ActivityMonsterInvasionDataManager:GetPlanTimeFuncOpen()
    if isPlanFuncOpen and DataCenter.ActivityMonsterInvasionDataManager:CanChangePlanTime() then
      table_insert(oneData.btnList, WorldPointBtnType.AisillaPlanTime)
    elseif oneData.pointData.canAttack then
      table_insert(oneData.btnList, WorldPointBtnType.AttackAisilla)
    end
  elseif self.type == WorldPointUIType.CityAttachmentBuild then
    local myAllianceId = LuaEntry.Player.allianceId
    oneData.pointData = self:GetCityAttachmentBuildData(self.uuid, self.pointId)
    if oneData.pointData and DataCenter.AllianceBaseDataManager:IsR4orR5() and (oneData.pointData.allianceUid == myAllianceId or oneData.pointData.cityOwnerAllianceUid == myAllianceId) then
      table.insert(oneData.btnList, WorldPointBtnType.DestroyCityAttachment)
    end
    if LuaEntry.Player:AtHomeNow() and oneData.pointData and oneData.pointData.state == 0 and oneData.pointData.allianceUid == myAllianceId then
      table_insert(oneData.btnList, WorldPointBtnType.BuildCityAttachment)
    end
  elseif self.type == WorldPointUIType.DominatorGuide then
    oneData.pointData = self:GetDominatorGuidePointData(self.pointId)
    oneData.btnList = {}
    table.insert(oneData.btnList, WorldPointBtnType.DominatorGuide)
  elseif self.type == WorldPointUIType.ZoneMobilization then
    local pointData = DataCenter.LWZoneMobilizationManager:GetWorldPointData(self.uuid)
    oneData.pointData = pointData
    if pointData and pointData.canAttack then
      table_insert(oneData.btnList, WorldPointBtnType.ZoneMobilizationDonate)
    end
  elseif self.type == WorldPointUIType.ZoneMobilizationBoss then
    oneData.pointData = self:GetMonsterData(self.uuid)
    if oneData.pointData.canAttack then
      table_insert(oneData.btnList, WorldPointBtnType.RallyBoss)
    end
  elseif self.type == WorldPointUIType.DetectZombieBusTrain then
    local pointData = {}
    pointData.marchType = NewMarchType.DETECT_ZOMBIE_BUS_TRAIN
    oneData.pointData = pointData
    table.insert(oneData.btnList, WorldPointBtnType.AttackDetectZombieBusTrain)
  elseif self.type == WorldPointUIType.WorldActivityTreasure then
    table_insert(oneData.btnList, WorldPointBtnType.ClickWorldTreasure)
  elseif self.type == WorldPointUIType.KillZombieKirovBoss then
    oneData.pointData = self:GetMonsterData(self.uuid)
    if oneData.pointData.canAttack then
      table_insert(oneData.btnList, WorldPointBtnType.RallyBoss)
      table_insert(oneData.btnList, WorldPointBtnType.KirovBossRank)
    elseif oneData.pointData.isPrepare then
      local isPlanFuncOpen = DataCenter.ActivityKillZombieManager:GetIsPlanTimeFuncOpen()
      if isPlanFuncOpen then
        table_insert(oneData.btnList, WorldPointBtnType.KirovBossPlanTime)
      end
    end
  elseif self.type == WorldPointUIType.KillZombieKirovBox then
    local info = CS.SceneManager.World:GetPointInfo(self.pointId)
    if info and info.treasurePointInfo and info.treasurePointInfo.allianceId == LuaEntry.Player:GetAllianceUid() then
      oneData.pointData = DataCenter.ActivityKillZombieManager:GetBoxPointData(self.uuid)
      table_insert(oneData.btnList, WorldPointBtnType.KillZombieKirovBox)
    end
    table_insert(oneData.btnList, WorldPointBtnType.KirovBossRank)
  elseif self.type == WorldPointUIType.TreasureChest then
    oneData.pointData = self:GetTreasureChestBuildData(self.pointId)
    table_insert(oneData.btnList, WorldPointBtnType.TreasureChest)
  elseif self.type == WorldPointUIType.SkyBattle then
    oneData.pointData = self:GetDetectSkyBattlePointData(self.pointId)
    table_insert(oneData.btnList, WorldPointBtnType.SkyBattle)
  elseif self.type == WorldPointUIType.DetectRetryRescue then
    oneData.pointData = self:GetRescueData()
    table_insert(oneData.btnList, WorldPointBtnType.DetectRetryRescue)
  elseif self.type == WorldPointUIType.DetectRetryResource then
    oneData.pointData = self:GetRescueData()
    table_insert(oneData.btnList, WorldPointBtnType.DetectRetryResource)
  elseif self.type == WorldPointUIType.DetectAttackCityS0Monster then
    oneData.pointData = self:GetAttackCityS0DetectData()
    table_insert(oneData.btnList, WorldPointBtnType.DetectEventAttackCityS0BattleRadar)
  elseif self.type == WorldPointUIType.DetectEventDigGame then
    oneData.pointData = self:GetDetectDigGamePointData(self.pointId)
    oneData.btnList = {}
    table.insert(oneData.btnList, WorldPointBtnType.DetectEventDigGame)
  elseif self.type == WorldPointUIType.DetectEventLastStand then
    oneData.pointData = self:GetDetectLastStandPointData(self.pointId)
    oneData.btnList = {}
    table.insert(oneData.btnList, WorldPointBtnType.DetectEventLastStand)
  elseif self.type == WorldPointUIType.DetectEventSuppliesSearch then
    oneData.pointData = self:GetDetectSuppliesSearchPointData(self.pointId)
    oneData.btnList = {}
    table.insert(oneData.btnList, WorldPointBtnType.DetectEventSuppliesSearch)
  elseif self.type == WorldPointUIType.DominatorCockatriceUnlock_1 then
    oneData.pointData = self:GetDominatorGuidePointData(self.pointId)
    oneData.btnList = {}
    table.insert(oneData.btnList, WorldPointBtnType.DominatorCockatriceUnlock_1)
  elseif self.type == WorldPointUIType.DominatorCockatriceUnlock_2 then
    oneData.pointData = self:GetDominatorGuidePointData(self.pointId)
    oneData.btnList = {}
    table.insert(oneData.btnList, WorldPointBtnType.DominatorCockatriceUnlock_2)
  elseif self.type == WorldPointUIType.S1RestCityDefendMonster then
    oneData.pointData = self:GetMonsterData(self.uuid)
    if LuaEntry.Player:AtHomeNow() then
      table.insert(oneData.btnList, WorldPointBtnType.AttackMonster)
    end
  elseif self.type == WorldPointUIType.S1RestBloodyQueenMonster then
    oneData.pointData = self:GetMonsterData(self.uuid)
    if LuaEntry.Player:AtHomeNow() and oneData.pointData.special == WorldMonsterSpecialType.S1RestBloodyQueenGunner then
      table.insert(oneData.btnList, WorldPointBtnType.AttackMonster)
    end
  elseif self.type == WorldPointUIType.S0AllianceDrillBuilding then
    local pointData = DataCenter.S0AllianceBossDataManager:GetWorldPointData(self.uuid)
    oneData.pointData = pointData
    if oneData.pointData.isMine and pointData and pointData.canAttack then
      local isR4orR5 = DataCenter.AllianceBaseDataManager:IsR4orR5()
      if isR4orR5 then
        table_insert(oneData.btnList, WorldPointBtnType.S0AllianceBossBuildingMove)
      end
      table_insert(oneData.btnList, WorldPointBtnType.S0AllianceBossBuildingDonate)
      if isR4orR5 then
        table_insert(oneData.btnList, WorldPointBtnType.S0AllianceBossBuildingSetting)
      end
      table_insert(oneData.btnList, WorldPointBtnType.S0AllianceBossBuildingGift)
    end
  elseif self.type == WorldPointUIType.S0AllianceDrillBoss then
    oneData.pointData = self:GetMonsterData(self.uuid)
    if oneData.pointData.isMine then
      if oneData.pointData.canMove ~= 0 then
        local isR4orR5 = DataCenter.AllianceBaseDataManager:IsR4orR5()
        if isR4orR5 then
          table_insert(oneData.btnList, WorldPointBtnType.S0AllianceBossBossMove)
        end
      end
      table_insert(oneData.btnList, WorldPointBtnType.S0AllianceBossBuildingRank)
      if oneData.pointData.canAttack then
        table_insert(oneData.btnList, WorldPointBtnType.S0AllianceBossBuildingRally)
      end
      table_insert(oneData.btnList, WorldPointBtnType.S0AllianceBossBuildingGift)
    end
  end
  return oneData
end

function UIWorldPointCtrl:PostProcessPointData(oneData)
  if oneData.btnList and #oneData.btnList < 5 and UIUtil.CanPutAllianceRallyPoint(self.pointId, self.serverId) and SeasonUtil.IsInSeasonDesertMode() then
    table.insert(oneData.btnList, WorldPointBtnType.PutAlliancePoint)
  end
  if oneData.pointData == nil then
    if self.type == WorldPointUIType.City or self.type == WorldPointUIType.WorldTrigger then
      self:CloseSelf()
      return
    end
    local uuid = self.uuid and self.uuid or -1
    Logger.LogError("oneData.pointData is nil, self.type:" .. self.type .. ", ,self.pointId: " .. self.pointId .. ", uuid: " .. uuid)
  end
end

function UIWorldPointCtrl:GetCityAttachmentBuildData(uuid, pointId)
  local serverId = self.serverId
  local oneData = {}
  oneData.uuid = uuid
  oneData.pointId = pointId
  oneData.canAttack = 0
  oneData.serverId = serverId
  local info = CS.SceneManager.World:GetPointInfo(pointId)
  if info ~= nil then
    cast(info, typeof(CS.CityAttachmentBuildPointInfo))
    local mBuildData = info.mBuildData
    if mBuildData then
      local buildData = DataCenter.SeasonFarmerTemplateManager:GetBuildTemplateById(mBuildData.BuildId)
      oneData.shareName = buildData.name
      oneData.buildId = mBuildData.BuildId
      oneData.state = mBuildData.State
      oneData.curExp = mBuildData.CurExp
      oneData.alAbbr = mBuildData.AlAbbr
      oneData.allianceUid = mBuildData.AllianceId
      oneData.rewardNum = mBuildData.RewardNum
      oneData.alName = mBuildData.AlName
      oneData.serverId = mBuildData.ServerId
      oneData.isFirst = mBuildData.IsFirst or false
      oneData.name = Localization:GetString(buildData.name)
      oneData.desc = buildData:GetDesc()
    end
  end
  local cityId = SceneUtils.GetZoneIdByPosId(pointId, serverId)
  local cityData = DataCenter.WorldAllianceCityDataManager:GetAllianceCityDataByCityId(cityId, serverId)
  if cityData then
    oneData.cityOwnerAllianceUid = cityData.allianceId
  end
  oneData.cityId = cityId
  return oneData
end

function UIWorldPointCtrl:GetDesertData(pointId)
  local zoneId = SceneUtils.GetZoneIdByPosId(pointId, self.serverId)
  local oneData = {}
  oneData.pointId = pointId
  oneData.level = 0
  oneData.name = "110245"
  oneData.shareName = "110245"
  oneData.resSpeed = {}
  oneData.zoneId = zoneId
  oneData.recommend_power = 0
  oneData.giveUpEndTime = 0
  oneData.protectEndTime = 0
  oneData.force = 0
  oneData.serverId = LuaEntry.Player:GetSelfServerId()
  oneData.canPlaceBuild = true
  oneData.canPlaceAllianceCenter = false
  oneData.season_mastery = 0
  if self.desertId == 0 then
    local id = DataCenter.WorldDesertRefreshTemplateManager:GetEmptyDesertIdByCityId(zoneId)
    if id ~= nil then
      self.desertId = id
    else
      self.desertId = 100
    end
  end
  oneData.desertId = self.desertId
  if self.desertId ~= 0 then
    local configLine = LocalController:instance():getLine(TableName.Desert, self.desertId)
    oneData.pic = string.format(LoadPath.SeasonDesert, configLine.icon)
    oneData.level = configLine.desert_level
    oneData.name = configLine.desert_name
    oneData.desert_desc = configLine.desert_desc
    oneData.canShare = toInt(configLine.is_gift) == 1
    oneData.shareName = oneData.name
    oneData.recommend_power = tonumber(configLine.desert_power) or 0
    oneData.resistance = toInt(configLine.desert_buff or 0)
    oneData.season_mastery = configLine.season_mastery
    local force = configLine.force
    oneData.force = tonumber(force)
    local forceScore = tonumber(configLine.forceScore)
    local score = 0
    if forceScore ~= nil then
      score = forceScore * 3
    end
    oneData.score = math.floor(score + 0.5)
    oneData.resSpeed = {}
    local strArr = string.split(configLine.desert_res, "|")
    if 0 < #strArr then
      for i = 1, #strArr do
        local arr = string.split(strArr[i], ";")
        if 2 <= #arr then
          local resType = tonumber(arr[1])
          local speed = tonumber(arr[2])
          if speed ~= nil then
            oneData.resSpeed[resType] = speed * 60
          end
        end
      end
    end
    oneData.selfValue = SeasonUtil.GetSelfSeasonResistanceValue()
    oneData.selfPercent = SeasonUtil.GetSeasonResistanceSelf(oneData.selfValue, oneData.resistance, 0) - 1
    oneData.otherPercent = SeasonUtil.GetSeasonResistanceOther(oneData.selfValue, oneData.resistance, 0)
    oneData.exp = 0
    if self.ownerUid == LuaEntry.Player.uid or self.isAlliance then
      oneData.firstRewardStr = false
      oneData.showRewardStr = false
    else
      oneData.firstRewardStr = configLine.first_showreward
      oneData.showRewardStr = configLine.showreward
    end
  end
  if self.uuid ~= 0 then
    local desertData = DataCenter.DesertDataManager:GetSelfDesertDataByUuid(self.uuid)
    if desertData == nil and self.ownerUid == LuaEntry.Player.uid then
      desertData = DataCenter.DesertDataManager:GetSelfEmptyDesertDataByUuid(self.uuid)
    end
    if desertData ~= nil then
      oneData.giveUpEndTime = desertData.giveUpTime
      oneData.protectEndTime = desertData.protectTime
      oneData.giveUpTime = desertData.giveUpTime
      oneData.protectTime = desertData.protectTime
      oneData.serverId = desertData.serverId
    end
    if oneData.level > 0 then
      oneData.canPlaceAllianceCenter = true
    end
    local tempData = CS.SceneManager.World:GetDesertInfoByUuid(self.uuid)
    if tempData ~= nil then
      local playerType = tempData:GetPlayerType()
      if self.isAlliance == false and playerType == CS.PlayerType.PlayerOther then
        oneData.canPlaceBuild = false
        oneData.canPlaceAllianceCenter = false
      end
      local oriDesertId = tempData.oriDesertId
      if oriDesertId ~= nil and 0 < oriDesertId and oriDesertId ~= oneData.level then
        oneData.targetLevel = oneData.level
        oneData.level = GetTableData(TableName.Desert, oriDesertId, "desert_level")
      end
      oneData.oriDesertId = tempData.oriDesertId
      oneData.hasOwner = playerType ~= CS.PlayerType.PlayerNone
      if oneData.oriDesertId ~= nil and oneData.oriDesertId ~= 0 and oneData.oriDesertId ~= oneData.desertId then
        local is_gift = GetTableData(TableName.Desert, toInt(oneData.oriDesertId), "is_gift")
        if toInt(is_gift) ~= 1 then
          oneData.canShare = false
        end
      end
    end
  end
  return oneData
end

function UIWorldPointCtrl:GetDesertData_old(pointId)
  local oneData = {}
  oneData.pointId = pointId
  oneData.level = 0
  oneData.name = "110245"
  oneData.resSpeed = {}
  local zoneId = SceneUtils.GetZoneIdByPosId(pointId, self.serverId)
  oneData.zoneId = zoneId
  oneData.recommend_power = 0
  oneData.giveUpEndTime = 0
  if self.desertId == 0 then
    local id = DataCenter.WorldDesertRefreshTemplateManager:GetEmptyDesertIdByCityId(zoneId)
    if id ~= nil then
      self.desertId = id
    end
  end
  if self.desertId ~= 0 then
    oneData.level = GetTableData(TableName.Desert, self.desertId, "desert_level")
    oneData.name = GetTableData(TableName.Desert, self.desertId, "desert_name")
    local resStr = GetTableData(TableName.Desert, self.desertId, "desert_res")
    local power = GetTableData(TableName.Desert, self.desertId, "desert_power")
    oneData.recommend_power = tonumber(power)
    oneData.resSpeed = {}
    local strArr = string.split(resStr, "|")
    if 0 < #strArr then
      for i = 1, #strArr do
        local arr = string.split(strArr[i], ";")
        if 2 <= #arr then
          local resType = tonumber(arr[1])
          local speed = tonumber(arr[2])
          if speed ~= nil then
            oneData.resSpeed[resType] = speed * 60
          end
        end
      end
    end
  end
  if self.uuid ~= 0 then
    local desertData = DataCenter.DesertDataManager:GetSelfDesertDataByUuid(self.uuid)
    if desertData ~= nil then
      oneData.giveUpEndTime = desertData.giveUpTime
    end
  end
  return oneData
end

local function GetMonsterLockData(self, pointId)
  local oneData = {}
  oneData.pointId = pointId
  oneData.canAttack = 1
  local data = DataCenter.MonsterLockDataManager:GetMonsterDataByPointIndex(pointId)
  if data == nil then
    return oneData
  end
  local template = DataCenter.MonsterLockTemplateManager:GetTemplate(data.monsterId)
  if template == nil then
    return oneData
  end
  oneData.refreshTime = nil
  if data.expireTime ~= nil and data.expireTime > 0 then
    oneData.refreshTime = data.expireTime
  end
  oneData.name = template:GetName()
  oneData.isRawName = true
  oneData.des = "121281"
  oneData.needArmyDesc = Localization:GetString("400019", template.needArmyLevel, template.needArmyCount)
  oneData.recommend_power = ""
  local recommend_power = template.recommend_power
  if 0 < recommend_power then
    oneData.recommend_power = Localization:GetString("300644", string.GetFormattedSeperatorNum(recommend_power))
  end
  oneData.rewardStr = self:GetRewards(data.rewardInfo)
  return oneData
end

local function GetPlayerData(self, pointId)
  local data = {}
  data.playerData = DataCenter.WorldPointDetailManager:GetDetailByPointId(pointId)
  data.name = ""
  data.curHp = 0
  data.maxHp = 0
  data.endTime = 0
  data.shareName = ""
  if self.type == WorldPointUIType.CollectPoint or self.type == WorldPointUIType.AllianceCollectPoint then
  else
    local info = CS.SceneManager.World:GetPointInfo(pointId)
    if info ~= nil then
      if self.type == WorldPointUIType.Road then
        if info ~= nil then
          cast(info, typeof(CS.BoardPointInfo))
          if info ~= nil then
            data.curHp = info.curHp
            local buildTemplate = DataCenter.BuildTemplateManager:GetBuildingDesTemplate(BuildingTypes.FUN_BUILD_ROAD)
            if buildTemplate ~= nil then
              data.shareName = buildTemplate.name
              data.name = buildTemplate.name
            end
            local buildLevelTemplate = DataCenter.BuildTemplateManager:GetBuildingLevelTemplate(BuildingTypes.FUN_BUILD_ROAD, 1)
            if buildLevelTemplate ~= nil then
              data.maxHp = buildLevelTemplate.max_hp
            end
          end
        end
      elseif self.type == WorldPointUIType.Build then
        cast(info, typeof(CS.BuildPointInfo))
        if info ~= nil then
          data.curHp = info.curHp
          data.lastHpTime = info.lastHpTime
          local buildTemplate = DataCenter.BuildTemplateManager:GetBuildingDesTemplate(info.itemId)
          if buildTemplate ~= nil then
            data.shareName = buildTemplate.name
            data.name = buildTemplate.name
          end
          if self.buildId == BuildingTypes.LW_CITY_RUIN or self.buildId == BuildingTypes.LW_CITY_RUIN_1 then
            data.endTime = info.destroyEndTime
          else
            local buildLevelTemplate = DataCenter.BuildTemplateManager:GetBuildingLevelTemplate(info.itemId, info.level)
            if buildLevelTemplate ~= nil then
              data.maxHp = buildLevelTemplate.max_hp
            end
          end
        end
      elseif self.type == WorldPointUIType.WorldRuinDestroyBuilding then
        cast(info, typeof(CS.WorldRuinDestroyBuildingPointInfo))
        if info ~= nil then
          data.curHp = info.curHp
          data.lastHpTime = info.lastHpTime
          data.name = info.userName or ""
          data.endTime = info.destroyEndTime or 0
          data.serverId = info.playerSrcServerId or 0
          data.alAbbr = info.alAbbr or ""
          local name = string.format("#%s[%s]", data.serverId, data.alAbbr)
          data.shareName = Localization:GetString("Teleport_Territory_title_1", name)
        end
      end
    end
  end
  return data
end

local function GetMeteoriteData(self, pointId, isSelf)
  local oneData = {}
  oneData.pointId = pointId
  oneData.isSelf = isSelf
  local info = CS.SceneManager.World:GetPointInfo(pointId)
  if info ~= nil then
    local config = DataCenter.ActMeteoriteBattleManager:GetEntityConfigById(info.buildId)
    if config then
      local showName = Localization:GetString(config.name)
      oneData.name = showName
      oneData.shareName = showName
      local desKey = info.buildId == 100 and "yuntieBattle_interface_1019" or "yuntieBattle_interface_1042"
      oneData.desc = Localization:GetString(desKey)
      oneData.openTime = info.openTime
      oneData.expireTime = info.expireTime
      oneData.remainTime = info.remainTime
      oneData.collectEndTime = info.collectEndTime
      oneData.gatherUUID = info.gatherUUID
      oneData.gatherUid = info.gatherUid
      oneData.gatherAllianceId = info.gatherAllianceId
      oneData.gatherSpeed = config.point_produce_per_second
      oneData.lastRes = config.point_last
      oneData.occupyTime = config.occupy_time
      oneData.config = config
    end
  end
  return oneData
end

local function GetResourceData(self, pointId)
  local oneData = {}
  oneData.pointId = pointId
  local info = CS.SceneManager.World:GetResourcePointInfoByIndex(pointId)
  if info ~= nil then
    local type = GetTableData(TableName.GatherResource, info.id, "resource_type")
    local lv = GetTableData(TableName.GatherResource, info.id, "level")
    local special = GetTableData(TableName.GatherResource, info.id, "special")
    type = tonumber(type)
    lv = tonumber(lv)
    if type == ResourceType.ResourceItem then
      local param = GetTableData(TableName.GatherResource, info.id, "param")
      local icon_full_path = GetTableData(TableName.Aps_Resource_Item, tonumber(param), "pic_new")
      if string.IsNullOrEmpty(icon_full_path) then
        local icon = GetTableData(TableName.Aps_Resource_Item, tonumber(param), "pic")
        oneData.icon = string.format(LoadPath.ItemPath, icon)
      else
        oneData.icon = icon_full_path
      end
      oneData.itemId = param
    elseif type == ResourceType.DragonItem then
      local template = DataCenter.ResourceItemDataManager:GetResourceItemTemplate(type)
      if template ~= nil then
        oneData.icon = template:GetIconPath()
      end
    else
      oneData.icon = DataCenter.ResourceManager:GetResourceIconByType(type)
    end
    local name = GetTableData(TableName.GatherResource, info.id, "name")
    oneData.name = Localization:GetString("104290", lv, Localization:GetString(name))
    oneData.shareName = GetTableData(TableName.GatherResource, info.id, "name")
    oneData.level = lv
    oneData.resourceType = type
    oneData.id = info.id
    oneData.ownerUid = info.ownerUid
    oneData.special = toInt(special)
    if oneData.special == 3 then
      oneData.ownerServerId = toInt(info.ownerUid or 0)
    elseif oneData.special == 4 then
      oneData.ownerAllianceId = info.ownerUid
    elseif oneData.special == 6 then
      oneData.ownerServerId = toInt(info.ownerUid or 0)
      oneData.ownerCampId = DataCenter.SeasonFactionWarDataManager:GetCampIdByServerId(oneData.ownerServerId)
    end
  end
  return oneData
end

local function GetCityResourceData(self, pointId)
  local oneData = {}
  oneData.pointId = pointId
  local info = DataCenter.CollectResourceManager:GetResourcePointInfoByIndex(pointId)
  if info ~= nil then
    local resourceType = info.resourceType
    if resourceType == ResourceType.ResourceItem then
      local itemId = tonumber(info.para)
      local template = DataCenter.ResourceItemDataManager:GetResourceItemTemplate(itemId)
      if template ~= nil then
        oneData.icon = template:GetIconPath()
        oneData.name = Localization:GetString(template.name)
        oneData.desc = template.desc
      end
      oneData.resourceType = resourceType
    else
      oneData.desc = GetTableData(TableName.ResourcesCollect, resourceType, "desc")
      oneData.icon = DataCenter.ResourceManager:GetResourceIconByType(resourceType)
      oneData.name = DataCenter.ResourceManager:GetResourceNameByType(resourceType)
      oneData.resourceType = resourceType
    end
  end
  return oneData
end

local function GetAllianceResourceData(self, pointId)
  local oneData = {}
  oneData.pointId = pointId
  local info = CS.SceneManager.World:GetCollectInfoByIndex(pointId)
  if info ~= nil then
    local type = info:GetResourceType()
    local cityId = info.attachId
    oneData.cityId = cityId
    local level = GetTableData(TableName.WorldCity, cityId, "level")
    local resGatherShowStr = ""
    if type == ResourceType.Gold then
      resGatherShowStr = "gold_gathering_show"
    else
      resGatherShowStr = "metal_gathering_show"
    end
    oneData.collectSpeedDes = GetTableData(TableName.AllianceResource, level, resGatherShowStr)
    oneData.desc = GetTableData(TableName.AllianceResource, level, "des")
    oneData.icon = CS.ResourceUtils.GetResourceImagePath(info.resourceType)
    if type == ResourceType.Oil then
      oneData.shareName = 100014
    elseif type == ResourceType.Metal then
      oneData.shareName = 100013
    elseif type == ResourceType.Water then
      oneData.shareName = 100546
    elseif type == ResourceType.Food then
      oneData.shareName = 100000
    elseif type == ResourceType.Electricity then
      oneData.shareName = 100002
    elseif type == ResourceType.Gold then
      oneData.shareName = 100183
    end
    oneData.name = CommonUtil.GetResourceNameByType(type)
    oneData.level = info.level
    oneData.resourceType = type
  end
  return oneData
end

local function GetCollectData(self, pointId, isSelf)
  local oneData = {}
  oneData.isSelf = 0
  local info = CS.SceneManager.World:GetResourcePointInfoByIndex(pointId)
  if info ~= nil then
    local type = LocalController:instance():getStrValue(TableName.GatherResource, info.id, "resource_type")
    local lv = GetTableData(TableName.GatherResource, info.id, "level")
    type = tonumber(type)
    local name = GetTableData(TableName.GatherResource, info.id, "name")
    if type == ResourceType.ResourceItem then
      local param = GetTableData(TableName.GatherResource, info.id, "param")
      local icon_full_path = GetTableData(TableName.Aps_Resource_Item, tonumber(param), "pic_new")
      if string.IsNullOrEmpty(icon_full_path) then
        local icon = GetTableData(TableName.Aps_Resource_Item, tonumber(param), "pic")
        oneData.icon = string.format(LoadPath.ItemPath, icon)
      else
        oneData.icon = icon_full_path
      end
      oneData.resourceName = Localization:GetString(name)
    elseif type == 11001 then
      local template = DataCenter.ResourceItemDataManager:GetResourceItemTemplate(type)
      if template ~= nil then
        oneData.icon = template:GetIconPath()
      end
    else
      oneData.icon = DataCenter.ResourceManager:GetResourceIconByType(type)
    end
    oneData.level = info.level
    if info.gatherMarchUuid ~= 0 then
      local marchInfo = CS.SceneManager.World:GetMarch(info.gatherMarchUuid)
      if marchInfo ~= nil then
        oneData.gatherMarchUuid = info.gatherMarchUuid
        oneData.formationUuid = marchInfo.ownerFormationUuid
        oneData.ownerUid = marchInfo.ownerUid
        oneData.name = name
        oneData.level = lv
        local ownerName = DataCenter.PlayerInfoDataManager:GetRemarkOrRealName(marchInfo.ownerUid, marchInfo.ownerName)
        if marchInfo.allianceAbbr and marchInfo.allianceAbbr ~= "" then
          ownerName = "[" .. marchInfo.allianceAbbr .. "]" .. ownerName
        end
        oneData.resourceName = Localization:GetString("104291", ownerName)
        oneData.shareName = oneData.name
        if isSelf == true then
          oneData.isSelf = 1
          oneData.plunderRes = 0
          if marchInfo.plunderRes then
            local num = 0
            local stringNum = string.split(marchInfo.plunderRes, ";")
            table.walk(stringNum, function(k, v)
              local pos = string.find(v, ",")
              if pos ~= nil then
                num = tonumber(string.sub(v, pos + 1, -1)) + num
              end
            end)
            oneData.plunderRes = num
          end
          oneData.armyWeight = marchInfo.armyWeight - oneData.plunderRes
          oneData.collectSpd = marchInfo.collectSpd
          oneData.startTime = marchInfo.startTime
          oneData.endTime = marchInfo.endTime
          oneData.collectAddition = math.floor(3600 * (marchInfo.collectSpd - GetTableData(TableName.GatherResource, info.id, "gathering")))
          oneData.baseCollectSpd = math.floor(3600 * GetTableData(TableName.GatherResource, info.id, "gathering")) .. "/h"
        end
        oneData.pointId = pointId
      end
    end
  end
  return oneData
end

local function OnMarkClick(self, server, point, oname, olv, panelType, uid)
  local share_param = {}
  share_param.sid = server
  share_param.pos = point
  share_param.oname = oname
  share_param.olv = olv
  share_param.uid = uid
  share_param.posType = self.type
  panelType = panelType or MarkGroup.Personal
  share_param.panelType = panelType
  UIManager:GetInstance():OpenWindow(UIWindowNames.UIPositionAdd, {anim = true}, share_param)
  self:CloseSelf()
end

function UIWorldPointCtrl:ShareTreasure(oneData)
  local share_param = {}
  share_param.sid = self.serverId
  share_param.pos = self.pointId
  share_param.oname = oneData.pointData.shareName
  share_param.postType = PostType.Text_PointShare_Alliance
  share_param.treasureId = oneData.pointData.eventId
  share_param.shareType = oneData.pointData.type
  share_param.uuid = oneData.pointData.uuid
  UIManager:GetInstance():OpenWindow(UIWindowNames.UIPositionShare, {anim = true}, share_param)
  self:CloseSelf()
end

local function OnShareClick(self, server, point, oname, uname, olv, postType, uid, uuid, srcServer)
  if self.type == WorldPointUIType.Train then
    RailwayUtil.ShareTrainByTrainData(self.trainData)
    self:CloseSelf()
    return
  end
  local share_param = {}
  share_param.sid = server
  share_param.pos = point
  share_param.oname = oname
  share_param.uname = uname
  share_param.olv = olv
  share_param.postType = postType
  share_param.uid = uid
  share_param.posType = self.type
  share_param.srcServer = srcServer
  if uuid then
    share_param.uuid = uuid
  end
  if self.type == WorldPointUIType.DispatchTask then
    local info = CS.SceneManager.World:GetPointInfo(self.pointId)
    if info ~= nil then
      share_param.dispatch = 1
      share_param.cfgId = info.cfgId
      if string.IsNullOrEmpty(uname) then
        local playerInfo = DataCenter.PlayerInfoDataManager:GetPlayerDataByUid(info.ownerUid, true)
        if playerInfo ~= nil then
          share_param.abbr = playerInfo.alAbbr
          share_param.uname = playerInfo.name
        end
      end
    end
  elseif self.type == WorldPointUIType.Ghostrecon then
    local info = CS.SceneManager.World:GetPointInfo(self.pointId)
    if info ~= nil then
      share_param.ghostrecon = 1
      share_param.cfgId = info.cfgId
    end
    share_param.onameParam1 = share_param.oname
    share_param.oname = "ghostrecon_035"
  elseif self.type == WorldPointUIType.WorldSuppliesPoint or self.type == WorldPointUIType.ZoneMobilizationSuppliesPoint or self.type == WorldPointUIType.DarknessSuppliesPoint then
    local data = self:GetWorldSuppliesData(self.pointId)
    share_param.oname = 104290
    share_param.onameParam1 = data.level
    share_param.onameParamKey2 = data.shareName
    local info = CS.SceneManager.World:GetPointInfo(point)
    cast(info, typeof(CS.WorldSuppliesPoint))
    if info then
      share_param.uuid = info.uuid
    else
      return
    end
  elseif self.type == WorldPointUIType.WorldTrigger then
    share_param.onameParam1 = uname
    share_param.uname = nil
  elseif self.type == WorldPointUIType.WorldAllianceResourceCollect then
    local data = self:GetAllianceCollectData(self.pointId)
    share_param.oname = 104290
    share_param.onameParam1 = data.level
    share_param.onameParamKey2 = data.shareName
  elseif self.type == WorldPointUIType.City then
    local info = CS.SceneManager.World:GetPointInfoByUuid(self.uuid)
    if info then
      if info.IsWerewolf then
        share_param.oname = "season_s4_activity_1200011_desc39"
      end
      local virusLayer = toInt(info.virusLayer or 0)
      local virusEndTime = toInt(info.virusEndTime or 0)
      virusLayer, virusEndTime = SeasonUtil.CalcVirusLevel(virusLayer, virusEndTime)
      if 0 < virusLayer then
        share_param.statusLayer = virusLayer
        share_param.statusIcon = string.format(LoadPath.LodIcon, "Mjc_saiji2_bingdu_icon.png")
      end
    end
  end
  UIManager:GetInstance():OpenWindow(UIWindowNames.UIPositionShare, {anim = true}, share_param)
  self:CloseSelf()
end

function UIWorldPointCtrl:OnShareMovingMarchClick(key, level, name, ownerName)
  if not self.uuid or string.IsNullOrEmpty(key) or string.IsNullOrEmpty(level) or string.IsNullOrEmpty(name) then
    return
  end
  local marchData = DataCenter.WorldMarchDataManager:GetMarch(self.uuid)
  if not marchData then
    return
  end
  MarchUtil.ShareOneMarch(self.uuid, key, level, name, ownerName)
  self:CloseSelf()
end

local function CheckResourceItemIsFull(self, rewardList)
  if rewardList == nil then
    return false
  end
  local totalResourceItemNum = 0
  for _, v in pairs(rewardList) do
    if v.rewardType == RewardType.RESOURCE_ITEM then
      totalResourceItemNum = totalResourceItemNum + v.count
    end
  end
  local storageMax = DataCenter.ResourceItemDataManager:GetFreezerStorageMax()
  local curNum = DataCenter.ResourceItemDataManager:GetResourceItemTotalNumByType(UICapacityTableTab.Farming)
  return storageMax < curNum + totalResourceItemNum
end

local function GetPointBtnEnumName(self, btnValue)
  for k, v in pairs(WorldPointBtnType) do
    if v == btnValue then
      return k
    end
  end
end

local function GetTrainShareNameAndPos(self)
  return Localization:GetString("457592", self.trainData:GetAbbrAndName(), self.trainData:GetQualityString()), SceneUtils.WorldToTileIndex(self:GetTrainPosition(), ForceChangeScene.World)
end

local function GetFlowerTrainShareNameAndPos(self)
  local abbrName = UIUtil.FormatAllianceAndName(self.flowerTrainRewardData.abbr, self.flowerTrainRewardData.ownerName)
  local name = Localization:GetString("treasure_world_specialgift_name", abbrName)
  local pointId = self.flowerTrainRewardData.pointId
  return name, pointId
end

local function GetFlowerTrainMarkNameAndPos(self)
  local name = Localization:GetString("treasure_world_specialgift_name", self.flowerTrainRewardData.ownerName)
  local pointId = self.flowerTrainRewardData.pointId
  return name, pointId
end

local function GetAllianceBuildData(self, pointId)
  local data = {}
  data.name = ""
  data.curHp = 0
  data.maxHp = 0
  data.endTime = 0
  data.shareName = ""
  data.coverSpeed = 0
  data.allianceId = ""
  data.buildId = 0
  data.size = 3
  data.lastHpTime = 0
  data.pointId = pointId
  data.serverId = self.serverId
  local info = CS.SceneManager.World:GetPointInfo(pointId)
  if info ~= nil then
    local detailInfo = PBController.ParsePbFromBytes(info.extraInfo, "protobuf.AllianceBuildingPointInfo")
    if detailInfo then
      local templateId = detailInfo.buildId
      local level = toInt(detailInfo.level)
      if detailInfo.buildId ~= BuildingTypes.LW_ALLIANCE_WAR_CAMP_2 then
        templateId = templateId + level
      end
      local template = DataCenter.AllianceMineManager:GetAllianceMineTemplate(templateId)
      if template == nil then
        local tmp = DataCenter.AllianceMineManager:GetAlCenterByPointIndex(pointId)
        if tmp then
          template = DataCenter.AllianceMineManager:GetAllianceMineTemplate(tmp.buildId)
        end
      end
      if template ~= nil then
        local nameStr = Localization:GetString(template.name)
        if info.srcServerId and info.srcServerId ~= 0 then
          if detailInfo.alAbbr and detailInfo.alAbbr ~= "" then
            data.shareName = string.format("#%s [%s] %s", info.srcServerId, detailInfo.alAbbr, nameStr)
          else
            data.shareName = template.name
          end
        else
          data.shareName = template.name
        end
        data.name = template.name
        data.maxHp = template.resDurable
        data.size = template.resSize
        data.type = template.type
      end
      data.allianceFurnaceInfo = detailInfo.allianceFurnaceInfo
      data.curHp = detailInfo.durability or 0
      data.lastHpTime = detailInfo.lastDurabilityTime or 0
      data.buildId = detailInfo.buildId
      data.level = detailInfo.level
      data.allianceId = detailInfo.allianceId
      data.state = detailInfo.state or 0
      data.coverSpeed = detailInfo.durabilitySpeed or 0
      if data.state == AllianceMineStatus.Ruin then
        data.coverSpeed = 0
      end
      if self.seasonType == SeasonMapType.Darkness then
        local shieldSkillInfo = info.shieldSkillInfo
        local mgrSkill = DataCenter.AllianceGovernmentSkillManager
        local now = UITimeManager:GetInstance():GetServerTime()
        if shieldSkillInfo ~= nil and now < shieldSkillInfo.OverTime then
          local skill_cfg = mgrSkill:GetTemplatesById(shieldSkillInfo.SkillId)
          if skill_cfg ~= nil and skill_cfg.skill_flag == AlOfficialSkillType.GuardianTower then
            data.isGuardianTower = true
            data.shieldSkillInfo = shieldSkillInfo
          end
        end
      end
    else
      local tmp_data = DataCenter.AllianceMineManager:GetAlCenterByPointIndex(pointId)
      if tmp_data then
        local template = DataCenter.AllianceMineManager:GetAllianceMineTemplate(tmp_data.buildId)
        if template ~= nil then
          data.shareName = template.name
          data.name = template.name
          data.maxHp = template.resDurable
          data.size = template.resSize
        end
      end
    end
    data.pointId = info.mainIndex
    data.uuid = info.uuid
    data.serverId = info.serverId
    data.fightState = info.fightState
  end
  return data
end

function UIWorldPointCtrl:GetGuideEventMonsterData()
  local oneData = {}
  oneData.uuid = self.uuid
  oneData.canAttack = 1
  local guideEventData = DataCenter.GuideDetectEventManager:GetGuideEventByUuid(self.uuid)
  if guideEventData == nil then
    return oneData
  end
  oneData.eventId = guideEventData.eventId
  local template = DataCenter.DetectEventTemplateManager:GetDetectEventTemplate(oneData.eventId)
  if template == nil then
    return oneData
  end
  oneData.shareName = template.name
  oneData.name = template:GetRealName()
  oneData.isRawName = true
  oneData.des = template.description
  oneData.recommend_power = ""
  local recommend_power = template.recommend_power
  if 0 < recommend_power then
    oneData.recommend_power = Localization:GetString("300644", string.GetFormattedSeperatorNum(recommend_power))
  end
  if template.type == DetectEventType.HeroTrial then
    oneData.recommend_power = Localization:GetString("140078", template.para)
  end
  oneData.rewardStr = self:GetRewards(guideEventData.reward)
  return oneData
end

function UIWorldPointCtrl:GetRuinData(pointId)
  local result = self:GetDesertData(pointId)
  if DataCenter.MissileManager:IsRuinPoint(pointId) then
    result.isRuin = true
    local endTime = 0
    local info = CS.SceneManager.World:GetPointInfo(pointId)
    if info then
      local extraInfo = PBController.ParsePbFromBytes(info.extraInfo, "protobuf.WorldRuinPointInfo")
      endTime = extraInfo.endTime * 1000
    end
    result.endTime = endTime
  end
  return result
end

function UIWorldPointCtrl:GetAllianceMineData(self, pointId)
  local oneData = {}
  oneData.name = ""
  oneData.pointId = pointId
  oneData.marchInfo = nil
  local info = CS.SceneManager.World:GetPointInfo(pointId)
  if info then
    oneData.uuid = info.uuid
    local alMinePointInfo = PBController.ParsePbFromBytes(info.extraInfo, "protobuf.AllianceBuildingPointInfo")
    if alMinePointInfo then
      oneData.allianceId = alMinePointInfo.allianceId
      oneData.curHp = alMinePointInfo.durability or 0
      oneData.lastHpTime = alMinePointInfo.lastDurabilityTime or 0
      oneData.state = alMinePointInfo.state or 0
      oneData.coverSpeed = alMinePointInfo.durabilitySpeed or 0
      local hasMarch, marchInfo = DataCenter.AllianceMineManager:CheckIfHasMarch(pointId)
      if hasMarch == true and marchInfo ~= nil then
        oneData.marchInfo = marchInfo
      end
      local template = DataCenter.AllianceMineManager:GetAllianceMineTemplate(alMinePointInfo.buildId)
      if template ~= nil then
        oneData.name = Localization:GetString(template.name)
        oneData.shareName = template.name
        oneData.buildId = alMinePointInfo.buildId
        oneData.size = template.resSize
        oneData.maxHp = template.resDurable
      end
    end
  end
  return oneData
end

function UIWorldPointCtrl:GetZombieRushData(pointId)
  local oneData = {}
  oneData.name = ""
  oneData.shareName = ""
  oneData.pointId = pointId
  local info = CS.SceneManager.World:GetPointInfo(pointId)
  if info then
    oneData.uuid = info.uuid
    local detailInfo = PBController.ParsePbFromBytes(info.extraInfo, "protobuf.AllianceBuildingPointInfo")
    if detailInfo and detailInfo.zombieRushInfo then
      local zombieRushInfo = detailInfo.zombieRushInfo
      oneData.templateId = zombieRushInfo.zombieRush
      oneData.round = zombieRushInfo.round
      oneData.state = zombieRushInfo.state
      oneData.stateEndTime = zombieRushInfo.stateEndTime
      local template = DataCenter.AllianceMineManager:GetAllianceMineTemplate(detailInfo.buildId)
      if template == nil then
        local tmp = DataCenter.AllianceMineManager:GetAlCenterByPointIndex(pointId)
        if tmp then
          template = DataCenter.AllianceMineManager:GetAllianceMineTemplate(tmp.buildId)
        end
      end
      if template ~= nil then
        local nameStr = Localization:GetString(template.name, template.level)
        oneData.name = nameStr
        if info.srcServerId and info.srcServerId ~= 0 then
          if detailInfo.alAbbr and detailInfo.alAbbr ~= "" then
            oneData.shareName = string.format("#%s [%s] %s", info.srcServerId, detailInfo.alAbbr, nameStr)
          else
            oneData.shareName = template.name
          end
        else
          oneData.shareName = nameStr
        end
      end
    end
  end
  return oneData
end

function UIWorldPointCtrl:GetAllianceCollectData(pointId)
  local oneData = {}
  oneData.pointId = pointId
  local info = CS.SceneManager.World:GetPointInfo(pointId)
  local configId, config
  cast(info, typeof(CS.WorldAllianceCollectResource))
  if info ~= nil and info.configId then
    configId = info.configId
    config = LocalController:instance():getLine(TableName.AllianceMine, configId)
    if config then
      local type = config.resource_type
      local lv = config.city_level
      type = tonumber(type)
      lv = tonumber(lv)
      oneData.icon = DataCenter.ResourceManager:GetResourceIconByType(type)
      local name = config.name
      oneData.name = Localization:GetString("104290", lv, Localization:GetString(name))
      oneData.shareName = config.name
      oneData.oname = "104290"
      oneData.level = lv
      oneData.maxValue = tonumber(config.reserve)
      if oneData.maxValue == nil then
        oneData.maxValue = IntMaxValue
        local msg = configId and configId or "errorId"
        Logger.LogError("alliance collect data is error, configId : " .. msg)
      end
      oneData.resourceType = type
      oneData.id = config.id
      oneData.showSpeed = config.speed_show
      oneData.detailInfo = Localization:GetString(config.desc)
    end
  end
  return oneData
end

function UIWorldPointCtrl:GetAllianceCollectDetailData(pointId)
  local info = CS.SceneManager.World:GetPointInfo(pointId)
  cast(info, typeof(CS.WorldAllianceCollectResource))
  if not info or not info.configId then
    return nil
  end
  local detailData = DataCenter.WorldPointDetailManager:GetAllianceResourceData(info.uuid)
  if detailData == nil then
    return nil
  end
  local configId = info.configId
  local config = LocalController:instance():getLine(TableName.AllianceMine, configId)
  local maxNum = config.guard_num
  local data = {}
  data.detailData = detailData
  data.btnList = {}
  data.allianceId = info.allianceId
  local isContainSelf = false
  for key, value in pairs(data.detailData.playerInfoLiset) do
    if value.uid == LuaEntry.Player.uid then
      isContainSelf = true
      break
    end
  end
  local selfAllianceId = LuaEntry.Player.allianceId
  local allianceFlag = info.allianceId == selfAllianceId
  if allianceFlag then
    if isContainSelf then
      table.insert(data.btnList, WorldPointBtnType.CallBack)
    else
      table.insert(data.btnList, WorldPointBtnType.WorldAllianceResourceCollect)
    end
    if TacticalCardUtil.IsFunctionOpen() then
      table.insert(data.btnList, WorldPointBtnType.TacticalCardSkill)
    end
  end
  return data
end

function UIWorldPointCtrl:GetWorldSuppliesData(pointId)
  local oneData = {}
  oneData.pointId = pointId
  local info = CS.SceneManager.World:GetPointInfo(pointId)
  local configId, config
  cast(info, typeof(CS.WorldSuppliesPoint))
  if info ~= nil and info.configId then
    configId = info.configId
    config = LocalController:instance():getLine(TableName.LWIceSupplies, configId)
    if config then
      local type = tonumber(config.type)
      local lv = tonumber(config.level)
      local name = config.name
      oneData.name = Localization:GetString("104290", lv, Localization:GetString(name))
      oneData.shareName = name
      oneData.level = lv
      oneData.id = config.id
      oneData.detailInfo = Localization:GetString(config.desc)
    end
  end
  return oneData
end

function UIWorldPointCtrl:GetWorldSuppliesPointDetailData(pointId)
  local info = CS.SceneManager.World:GetPointInfo(pointId)
  cast(info, typeof(CS.WorldSuppliesPoint))
  if not info or not info.configId then
    return nil
  end
  local detailData = DataCenter.WorldPointDetailManager:GetWorldSuppliesPointDetailData(info.uuid)
  if detailData == nil then
    return nil
  end
  local configId = info.configId
  local config = LocalController:instance():getLine(TableName.LWIceSupplies, configId)
  local data = {}
  data.detailData = detailData
  data.btnList = {}
  if info:IsFrozen() and detailData.expireTime <= 0 then
    data.wasFrozen = true
    table.insert(data.btnList, WorldPointBtnType.DigIceEnemy)
  elseif config.type == WorldSuppliesType.IceSeasonType or config.type == WorldSuppliesType.DesertSeasonType then
    table.insert(data.btnList, WorldPointBtnType.WorldSupplies)
  elseif config.type == WorldSuppliesType.DarknessSeasonType then
    local percent = detailData and detailData.chargeData and detailData.chargeData:GetPercent()
    if percent and percent < 1 then
      if detailData:HasPlayer() then
        table.insert(data.btnList, WorldPointBtnType.ChargeBack)
      else
        table.insert(data.btnList, WorldPointBtnType.Charge)
      end
    else
      table.insert(data.btnList, WorldPointBtnType.WorldSupplies)
    end
  elseif config.type == WorldSuppliesType.DarknessSeasonSmallType then
    local percent = detailData and detailData.chargeData and detailData.chargeData:GetPercent()
    if percent and percent < 1 then
      if detailData:HasPlayer() then
        table.insert(data.btnList, WorldPointBtnType.ChargeBack)
      elseif detailData:HasDiscoverer() then
        table.insert(data.btnList, WorldPointBtnType.Charge)
      end
    end
  elseif config.type == WorldSuppliesType.ZoneMobilizationType or config.type == WorldSuppliesType.ZoneMobilizationSmallType then
    table.insert(data.btnList, WorldPointBtnType.ZoneMobilizationDonateSupplies)
  end
  return data
end

function UIWorldPointCtrl:GetWorldDetectSurvivor(pointId)
  local oneData = {}
  oneData.pointId = pointId
  local info = CS.SceneManager.World:GetPointInfo(pointId)
  local configId, config
  cast(info, typeof(CS.ExplorePointInfo))
  if info ~= nil and info.eventId then
    configId = info.eventId
    local template = DataCenter.DetectEventTemplateManager:GetDetectEventTemplate(configId)
    if template then
      local name = template:GetRealName()
      oneData.name = name
      oneData.shareName = oneData.name
      oneData.id = template.id
      oneData.detectUuid = info.uuid
      oneData.detailInfo = Localization:GetString(template.description)
      oneData.isFronzen = info:IsFrozen()
      oneData.plotId = template.para
    end
  end
  return oneData
end

function UIWorldPointCtrl:GetDominatorGuidePointData(pointId)
  local oneData = {}
  oneData.pointId = pointId
  local info = CS.SceneManager.World:GetPointInfo(pointId)
  local configId, config
  cast(info, typeof(CS.SamplePointInfo))
  if info ~= nil and info.eventId then
    configId = info.eventId
    local template = DataCenter.DetectEventTemplateManager:GetDetectEventTemplate(configId)
    if template then
      local name = template:GetRealName()
      oneData.name = name
      oneData.shareName = oneData.name
      oneData.id = template.id
      oneData.detectUuid = info.uuid
      oneData.detailInfo = Localization:GetString(template.description)
      oneData.plotId = template.para
    end
  end
  return oneData
end

function UIWorldPointCtrl:GetTreasureChestBuildData(pointId)
  local data = {}
  data.name = ""
  data.des = ""
  data.icon = "Assets/Main/Sprites/UI/LWTreasureChest/wxy_heishibaoxiang_guan.png"
  data.pointId = pointId
  data.treasureChestId = 0
  data.extendInfo = ""
  data.eventId = 0
  data.eventUuid = 0
  data.onlyIcon = true
  data.ownerUid = 0
  local info = CS.SceneManager.World:GetSamplePointInfoByIndex(pointId)
  if info ~= nil then
    data.eventId = info.eventId
    data.eventUuid = string.format("%d", info.uuid)
    data.ownerUid = info.ownerUid
    local detailInfo = PBController.ParsePbFromBytes(info.extraInfo, "protobuf.DetectPickOneInfo")
    if detailInfo then
      data.treasureChestId = detailInfo.configId
      data.extendInfo = detailInfo.extendString
      local template = DataCenter.DetectEventTemplateManager:GetDetectEventTemplate(data.eventId)
      if template then
        data.name = template.name
        data.des = template.description
      end
    end
  end
  return data
end

function UIWorldPointCtrl:GetDetectDigGamePointData(pointId)
  local oneData = {}
  oneData.pointId = pointId
  local info = CS.SceneManager.World:GetPointInfo(pointId)
  local configId, config
  cast(info, typeof(CS.SamplePointInfo))
  if info ~= nil and info.eventId then
    configId = info.eventId
    local template = DataCenter.DetectEventTemplateManager:GetDetectEventTemplate(configId)
    if template then
      local name = template:GetRealName()
      oneData.name = name
      oneData.shareName = oneData.name
      oneData.id = template.id
      oneData.detectUuid = info.uuid
      oneData.tip = Localization:GetString(template.description)
      oneData.plotId = template.para
    end
  end
  return oneData
end

function UIWorldPointCtrl:GetDetectSkyBattlePointData(pointId)
  local oneData = {}
  oneData.pointId = pointId
  local info = CS.SceneManager.World:GetPointInfo(pointId)
  local configId
  cast(info, typeof(CS.SamplePointInfo))
  if info ~= nil and info.eventId and info.uuid then
    oneData.uuid = info.uuid
    local data = DataCenter.RadarCenterDataManager:GetDetectEventInfo(info.uuid)
    configId = info.eventId
    local template = DataCenter.DetectEventTemplateManager:GetDetectEventTemplate(configId)
    if template then
      oneData.name = template:GetRealName()
      oneData.ownerUid = info.ownerUid
      oneData.refreshTime = data and data.endTime or 0
      oneData.shareName = oneData.name
      oneData.isRawName = true
      oneData.belongSelf = true
      oneData.des = template.description
      oneData.rewardStr = data and self:GetRewards(data.rewardList) or {}
      oneData.icon = LoadPath.GarbageIconsPath .. template.pic .. ".png"
    end
  end
  return oneData
end

function UIWorldPointCtrl:GetDetectLastStandPointData(pointId)
  local oneData = {}
  oneData.pointId = pointId
  local info = CS.SceneManager.World:GetPointInfo(pointId)
  local configId, config
  cast(info, typeof(CS.SamplePointInfo))
  if info ~= nil and info.eventId then
    configId = info.eventId
    local template = DataCenter.DetectEventTemplateManager:GetDetectEventTemplate(configId)
    if template then
      local name = template:GetRealName()
      oneData.name = name
      oneData.shareName = oneData.name
      oneData.id = template.id
      oneData.detectUuid = info.uuid
      oneData.tip = Localization:GetString(template.description)
      oneData.plotId = template.para
    end
  end
  return oneData
end

function UIWorldPointCtrl:GetDetectSuppliesSearchPointData(pointId)
  local oneData = {}
  oneData.pointId = pointId
  local info = CS.SceneManager.World:GetPointInfo(pointId)
  local configId, config
  cast(info, typeof(CS.SamplePointInfo))
  if info ~= nil and info.eventId then
    configId = info.eventId
    local template = DataCenter.DetectEventTemplateManager:GetDetectEventTemplate(configId)
    if template then
      local name = template:GetRealName()
      oneData.name = name
      oneData.shareName = oneData.name
      oneData.id = template.id
      oneData.detectUuid = info.uuid
      oneData.des = template.description
      oneData.plotId = template.para
      oneData.icon = LoadPath.GarbageIconsPath .. template.pic .. ".png"
      oneData.isRawName = true
    end
  end
  return oneData
end

function UIWorldPointCtrl:GetIsCrossServer()
  local loginServerId = LuaEntry.Player:GetSelfServerId()
  return loginServerId ~= self.serverId
end

UIWorldPointCtrl.GetAllianceBuildData = GetAllianceBuildData
UIWorldPointCtrl.GetTrainShareNameAndPos = GetTrainShareNameAndPos
UIWorldPointCtrl.GetTrainPosition = GetTrainPosition
UIWorldPointCtrl.GetFlowerTrainShareNameAndPos = GetFlowerTrainShareNameAndPos
UIWorldPointCtrl.GetFlowerTrainMarkNameAndPos = GetFlowerTrainMarkNameAndPos
UIWorldPointCtrl.CloseSelf = CloseSelf
UIWorldPointCtrl.GetIsArrow = GetIsArrow
UIWorldPointCtrl.SetIsArrow = SetIsArrow
UIWorldPointCtrl.GetSandWormData = GetSandWormData
UIWorldPointCtrl.GetMonsterData = GetMonsterData
UIWorldPointCtrl.GetCollectData = GetCollectData
UIWorldPointCtrl.GetResourceData = GetResourceData
UIWorldPointCtrl.GetMeteoriteData = GetMeteoriteData
UIWorldPointCtrl.GetPlayerData = GetPlayerData
UIWorldPointCtrl.GetPointData = GetPointData
UIWorldPointCtrl.PreProcessPointData = PreProcessPointData
UIWorldPointCtrl.GetMonsterDataInCity = GetMonsterDataInCity
UIWorldPointCtrl.InitData = InitData
UIWorldPointCtrl.ClearData = ClearData
UIWorldPointCtrl.OnMarkClick = OnMarkClick
UIWorldPointCtrl.OnShareClick = OnShareClick
UIWorldPointCtrl.GetExploreData = GetExploreData
UIWorldPointCtrl.GetDetectEventPVEData = GetDetectEventPVEData
UIWorldPointCtrl.GetDetectEventFakePVPData = GetDetectEventFakePVPData
UIWorldPointCtrl.GetTreasureData = GetTreasureData
UIWorldPointCtrl.GetMonsterRewardData = GetMonsterRewardData
UIWorldPointCtrl.GetMonsterRewardDataInCity = GetMonsterRewardDataInCity
UIWorldPointCtrl.GetRewards = GetRewards
UIWorldPointCtrl.GetSampleData = GetSampleData
UIWorldPointCtrl.GetRescueData = GetRescueData
UIWorldPointCtrl.GetGarbageData = GetGarbageData
UIWorldPointCtrl.GetSingleMapGarbageData = GetSingleMapGarbageData
UIWorldPointCtrl.CheckResourceItemIsFull = CheckResourceItemIsFull
UIWorldPointCtrl.GetPointBtnEnumName = GetPointBtnEnumName
UIWorldPointCtrl.GetAllianceResourceData = GetAllianceResourceData
UIWorldPointCtrl.GetActBossData = GetActBossData
UIWorldPointCtrl.GetPuzzleBossData = GetPuzzleBossData
UIWorldPointCtrl.GetMonsterLockData = GetMonsterLockData
UIWorldPointCtrl.GetChallengeBossData = GetChallengeBossData
UIWorldPointCtrl.GetCityResourceData = GetCityResourceData
return UIWorldPointCtrl
