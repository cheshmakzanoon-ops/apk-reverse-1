local MarchUtil = {}
local Setting = CS.GameEntry.Setting
local Localization = CS.GameEntry.Localization

function MarchUtil.ShareOneMarch(uuid, key, level, name, ownerName)
  if not uuid then
    return
  end
  local marchData = DataCenter.WorldMarchDataManager:GetMarch(uuid)
  if not marchData then
    return
  end
  if string.IsNullOrEmpty(key) or string.IsNullOrEmpty(level) or string.IsNullOrEmpty(name) then
    local monsterId = marchData.monsterId
    local monster = DataCenter.MonsterTemplateManager:GetMonsterTemplate(monsterId)
    if monster then
      key = "science_condition"
      level = monster.level
      name = monster.name
    else
      key = "110148"
      level = UIUtil.FormatServerAllianceName(marchData.serverId, marchData.allianceAbbr, marchData.ownerName, marchData.ownerUid)
      name = ""
    end
  end
  local share_param = {}
  share_param.sid = marchData.serverId
  share_param.pos = marchData.targetPos
  share_param.oname = Localization:GetString(key, level, Localization:GetString(name, ownerName))
  share_param.key = key
  share_param.level = level
  share_param.name = name
  share_param.ownerName = ownerName
  share_param.postType = PostType.DefaultMarch
  share_param.marchUuid = uuid
  share_param.worldId = marchData.worldId
  share_param.serverId = marchData.serverId
  share_param.marchType = marchData:GetMarchType()
  UIManager:GetInstance():OpenWindow(UIWindowNames.UIPositionShare, {anim = true}, share_param)
end

function MarchUtil.JumpToMarchByUuid(marchUuid, serverId, worldId, marchType)
  GoToUtil.JumpToMarchByUuid(marchUuid, serverId, worldId, marchType)
end

local function IsAllianceCityOccupied(pointIndex, uuid)
  local targetInfo
  if uuid ~= nil then
    targetInfo = CS.SceneManager.World:GetPointInfoByUuid(uuid)
  end
  if pointIndex ~= nil and targetInfo == nil then
    targetInfo = CS.SceneManager.World:GetPointInfo(pointIndex)
  end
  if targetInfo then
    cast(targetInfo, typeof(CS.AllyCityPointInfo))
    if targetInfo and targetInfo.PointType == WorldPointType.WORLD_CITY_STRONGHOLD then
      local theExtraInfo = SeasonUtil.TryParseAllianceCityPointInfo(targetInfo.PointType, targetInfo.extraInfo, targetInfo)
      if theExtraInfo ~= nil then
        local attackInfo = theExtraInfo.buildPointInfo
        if (attackInfo == nil or string.IsNullOrEmpty(attackInfo.allianceId)) and targetInfo and string.IsNullOrEmpty(targetInfo:GetAllianceId()) then
          return false
        end
      end
    elseif targetInfo and string.IsNullOrEmpty(targetInfo:GetAllianceId()) then
      return false
    end
  end
  return true
end

local function CheckNeedNoticeMeteoriteBattle(targetType, pointIndex, uuid, index, backHome, rallyType, targetServerId, targetWorldId, monsterSpecialType)
  local needNotice = false
  if DataCenter.ActMeteoriteBattleManager:IsInMeteoriteBattleServerGroup() then
    return needNotice
  end
  if targetType == MarchTargetType.ATTACK_METEORITE then
    needNotice = true
  end
  if targetType == MarchTargetType.ATTACK_CITY or targetType == MarchTargetType.ATTACK_EPIDEMIC_CITY or targetType == MarchTargetType.RALLY_FOR_CITY or targetType == MarchTargetType.RALLY_EPIDEMIC_CITY then
    needNotice = true
  end
  if needNotice then
    local msg = Localization:GetString("yuntieBattle_tips_1001")
    UIUtil.TryShowConfirm(TodayNoSecondConfirmType.CrossAttackMeteoriteNotice, msg, 2, GameDialogDefine.CONFIRM, GameDialogDefine.CANCEL, function()
      MarchUtil.OnClickStartMarch(targetType, pointIndex, uuid, index, backHome, rallyType, targetServerId, targetWorldId, monsterSpecialType, true)
    end, function()
    end, nil, nil, false, nil, nil)
  end
  return needNotice
end

function MarchUtil.OnClickStartMarch(targetType, pointIndex, uuid, index, backHome, rallyType, targetServerId, targetWorldId, monsterSpecialType, ignoreNotice)
  if not DataCenter.BuildManager:HasBuilding(BuildingTypes.LW_BUILD_PARKINGLOT) then
    UIUtil.ShowTipsId(430764)
    GoToUtil.GotoCityByBuildId(BuildingTypes.LW_BUILD_PARKINGLOT)
    return
  end
  local isRallyMarch = MarchUtil.IsRallyMarch(targetType) or targetType == MarchTargetType.JOIN_RALLY
  if isRallyMarch and not DataCenter.BuildManager:HasBuilding(BuildingTypes.LW_BUILD_ALLIANCE_CENTER) then
    UIUtil.ShowTipsId(300645)
    GoToUtil.GotoCityByBuildId(BuildingTypes.LW_BUILD_ALLIANCE_CENTER)
    return
  end
  local theWorld = CS.SceneManager.World
  local serverId = LuaEntry.Player:GetCurServerId()
  if targetServerId ~= nil and targetServerId ~= 0 then
    serverId = targetServerId
  elseif theWorld ~= nil and uuid ~= nil and not BattleFieldUtil.InBattleField() and SeasonUtil.CurServerTypeInSeason() == SeasonMapType.NineNation then
    local dataInfo = theWorld:GetPointInfoByUuid(uuid)
    if dataInfo ~= nil then
      serverId = dataInfo.serverId
    else
      local marchInfo = theWorld:GetMarch(uuid)
      if marchInfo and marchInfo.srcServer == marchInfo.targetServer and marchInfo.targetServer ~= 0 then
        serverId = marchInfo.targetServer
      end
    end
  end
  if DataCenter.ActMeteoriteBattleManager:IsInMeteoriteBattle() and not ignoreNotice and CheckNeedNoticeMeteoriteBattle(targetType, pointIndex, uuid, index, backHome, rallyType, targetServerId, targetWorldId, monsterSpecialType) then
    return
  end
  local need_tip = false
  if targetType == MarchTargetType.ATTACK_DESERT or targetType == MarchTargetType.ATTACK_EMPTY_DESERT then
    local tempData = CS.SceneManager.World:GetDesertInfoByUuid(uuid)
    if tempData ~= nil and tempData.ownerUid ~= nil and tempData.ownerUid ~= "" and tempData.ownerUid ~= 0 then
      need_tip = true
    end
    uuid = pointIndex
  end
  if need_tip or targetType == MarchTargetType.ATTACK_ROAD or targetType == MarchTargetType.ATTACK_CITY or targetType == MarchTargetType.ATTACK_BUILDING or targetType == MarchTargetType.ATTACK_ARMY or targetType == MarchTargetType.ATTACK_ARMY_COLLECT or targetType == MarchTargetType.ATTACK_METEORITE or targetType == MarchTargetType.ATTACK_ALLIANCE_CITY and IsAllianceCityOccupied(pointIndex) or targetType == MarchTargetType.ATTACK_THRONE or targetType == MarchTargetType.ATTACK_SERVER_THRONE_BUILDING or targetType == MarchTargetType.ATTACK_CENTER_THRONE or targetType == MarchTargetType.RAINFOREST_THRONE_ATTACK or targetType == MarchTargetType.ATTACK_ALLIANCE_BUILDING or targetType == MarchTargetType.ATTACK_CITY_STRONGHOLD and IsAllianceCityOccupied(pointIndex, uuid) or targetType == MarchTargetType.RALLY_CITY_STRONGHOLD and IsAllianceCityOccupied(pointIndex, uuid) or targetType == MarchTargetType.RALLY_ALLIANCE_BUILDING or targetType == MarchTargetType.RALLY_FOR_ALLIANCE_CITY and IsAllianceCityOccupied(pointIndex) or targetType == MarchTargetType.RALLY_FOR_BUILDING or targetType == MarchTargetType.RALLY_FOR_CITY or targetType == MarchTargetType.RALLY_SERVER_THRONE_BUILDING or targetType == MarchTargetType.RALLY_CENTER_THRONE or targetType == MarchTargetType.RAINFOREST_THRONE_RALLY or targetType == MarchTargetType.RALLY_THRONE or targetType == MarchTargetType.FAKE_ATTACK or targetType == MarchTargetType.SCOUT_OUTPOST_BUILDING or targetType == MarchTargetType.ATTACK_OUTPOST_BUILDING or targetType == MarchTargetType.RALLY_OUTPOST_BUILDING or targetType == MarchTargetType.SCOUT_ZWL_BUILDING or targetType == MarchTargetType.ATTACK_ZWL_BUILDING or targetType == MarchTargetType.RALLY_ZWL_BUILDING then
    local needConfirm, status, title, content, needBreakProtect = DataCenter.StatusManager:ShowTipForWarFever()
    if needConfirm then
      if status ~= nil and title ~= nil then
        UIUtil.ShowSecondMessage(title, content, 2, "", "", function()
          UIUtil.OpenFormationSelectUI(1, targetType, pointIndex, uuid, index, backHome, rallyType, serverId, monsterSpecialType)
        end, function(needSellConfirm)
          DataCenter.StatusManager:SetWarFeverConfirmFlag(needSellConfirm)
        end)
        return
      end
    elseif needBreakProtect == true then
      local isFakePlayer = false
      if targetType == MarchTargetType.ATTACK_CITY or targetType == MarchTargetType.ATTACK_WINTER_STORM_CITY or targetType == MarchTargetType.ATTACK_EPIDEMIC_CITY then
        local targetInfo = CS.SceneManager.World:GetPointInfo(pointIndex)
        cast(targetInfo, typeof(CS.BuildPointInfo))
        if not targetInfo:IsNormalType() then
          isFakePlayer = true
        end
      end
      if not isFakePlayer then
        UIUtil.ShowShieldBreakTip(content, 2, GameDialogDefine.CANCEL, GameDialogDefine.CONFIRM, function()
        end, function()
          UIUtil.OpenFormationSelectUI(1, targetType, pointIndex, uuid, index, backHome, rallyType, serverId, monsterSpecialType)
        end, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, UIUtil.BtnColorSpriteName.Blue, UIUtil.BtnColorSpriteName.Red)
        return
      end
    end
  end
  if -1 < targetType and targetType ~= MarchTargetType.CROSS_SERVER_WORM and targetType ~= MarchTargetType.BACK_HOME then
    local GotoWorldPos = GoToUtil.GotoWorldPos
    if targetWorldId ~= nil and targetWorldId ~= 0 and 0 < targetWorldId or BattleFieldUtil.InBattleField() and serverId == LuaEntry.Player:GetCurServerId() then
      GotoWorldPos = GoToUtil.GotoDragonPos
    end
    local worldPos = SceneUtils.TileIndexToWorld(pointIndex, ForceChangeScene.World, serverId)
    local troop = CS.SceneManager.World:GetTroop(uuid)
    local track = false
    if troop then
      local marchInfo = troop:GetMarchInfo()
      if marchInfo and (marchInfo:IsWanderBoss() or marchInfo:GetMarchType() == NewMarchType.ZONE_MOBILIZATION_BOSS or marchInfo:IsWanderMonster()) then
        worldPos = troop:GetPosition()
        track = true
      elseif marchInfo and marchInfo.serverId ~= nil and marchInfo.serverId ~= 0 then
        serverId = marchInfo.serverId
        worldPos = SceneUtils.TileIndexToWorld(pointIndex, ForceChangeScene.World, serverId)
      end
    end
    GotoWorldPos(worldPos, -1, LookAtFocusTime, function()
      if targetType == MarchTargetType.ATTACK_MONSTER or targetType == MarchTargetType.RALLY_FOR_BOSS then
        local marchInfo = CS.SceneManager.World:GetMarch(uuid)
        local monsterId = marchInfo.monsterId
        local data = {}
        local resistance_type = 0
        local monster = DataCenter.MonsterTemplateManager:GetMonsterTemplate(monsterId)
        if monster ~= nil then
          resistance_type = toInt(monster.resistance_type)
          if 0 < monster.monster_resistance then
            data.resistance = monster.monster_resistance + SeasonUtil.GetBloodyNightResistanceValueAdd()
          else
            data.resistance = 0
          end
        end
        data.selfValue = SeasonUtil.GetSelfSeasonResistanceValue()
        data.selfPercent = SeasonUtil.GetSeasonResistanceSelf(data.selfValue, data.resistance, resistance_type) - 1
        data.otherPercent = SeasonUtil.GetSeasonResistanceOther(data.selfValue, data.resistance, resistance_type)
        if UIUtil.ShowResistanceWarning(data, true, function()
          UIUtil.OpenFormationSelectUI(1, targetType, pointIndex, uuid, index, backHome, rallyType, serverId, monsterSpecialType)
        end) then
          return
        end
      end
      if SeasonUtil.InSeasonBigMapMode() then
        local showTip = DataCenter.MakingCoffeeManager:ShouldShowCoffeeTipOnAttack(serverId, uuid, targetType)
        if showTip then
          DataCenter.MakingCoffeeManager:OpenDrinkCoffeeTip(function()
            UIUtil.OpenFormationSelectUI(1, targetType, pointIndex, uuid, index, backHome, rallyType, serverId, monsterSpecialType)
            if track then
              CS.SceneManager.World:TrackMarch(uuid)
            end
          end)
          return
        end
      end
      UIUtil.OpenFormationSelectUI(1, targetType, pointIndex, uuid, index, backHome, rallyType, serverId, monsterSpecialType)
      if track then
        CS.SceneManager.World:TrackMarch(uuid)
      end
    end, serverId, targetWorldId or 0)
  else
    UIUtil.OpenFormationSelectUI(1, targetType, pointIndex, uuid, index, backHome, rallyType, serverId, monsterSpecialType)
  end
end

function MarchUtil.IsAssistanceMarch(targetType)
  local go_type = LocalController:instance():getIntValue(TableName.LW_March_Target_Type, targetType, "go_type", 0)
  if go_type ~= 0 then
    return go_type == MarchGoType.Assistance
  end
  return targetType == MarchTargetType.ASSISTANCE_ALLIANCE_BUILDING or targetType == MarchTargetType.ASSISTANCE_ALLIANCE_CITY or targetType == MarchTargetType.ASSISTANCE_BUILD or targetType == MarchTargetType.ASSISTANCE_CITY or targetType == MarchTargetType.ASSISTANCE_WINTER_STORM_CITY or targetType == MarchTargetType.ASSISTANCE_DESERT or targetType == MarchTargetType.ASSISTANCE_DRAGON_BUILDING or targetType == MarchTargetType.ASSISTANCE_WINTER_ENTITY or targetType == MarchTargetType.ASSISTANCE_SERVER_THRONE_BUILDING or targetType == MarchTargetType.ASSISTANCE_CENTER_THRONE or targetType == MarchTargetType.RAINFOREST_THRONE_ASSISTANCE or targetType == MarchTargetType.ASSISTANCE_THRONE or targetType == MarchTargetType.ASSIST_TRAIN or targetType == MarchTargetType.ASSISTANCE_CITY_STRONGHOLD or targetType == MarchTargetType.ASSISTANCE_EPIDEMIC_BUILDING or targetType == MarchTargetType.ASSISTANCE_EPIDEMIC_CITY or targetType == MarchTargetType.ASSISTANCE_OUTPOST_BUILDING
end

function MarchUtil.IsRallyMarch(targetType)
  local go_type = LocalController:instance():getIntValue(TableName.LW_March_Target_Type, targetType, "go_type", 0)
  if go_type ~= 0 then
    return go_type == MarchGoType.RallyGo
  end
  return targetType == MarchTargetType.RALLY_ALLIANCE_BUILDING or targetType == MarchTargetType.RALLY_DRAGON_BUILDING or targetType == MarchTargetType.RALLY_FOR_ALLIANCE_CITY or targetType == MarchTargetType.RALLY_FOR_BOSS or targetType == MarchTargetType.RALLY_FOR_BUILDING or targetType == MarchTargetType.RALLY_FOR_CITY or targetType == MarchTargetType.RALLY_SERVER_THRONE_BUILDING or targetType == MarchTargetType.RALLY_CENTER_THRONE or targetType == MarchTargetType.RAINFOREST_THRONE_RALLY or targetType == MarchTargetType.RALLY_THRONE or targetType == MarchTargetType.RALLY_CITY_STRONGHOLD or targetType == MarchTargetType.RALLY_SANDWORM or targetType == MarchTargetType.RALLY_MUMMY or targetType == MarchTargetType.RALLY_EPIDEMIC_BUILDING or targetType == MarchTargetType.RALLY_EPIDEMIC_CITY or targetType == MarchTargetType.RALLY_OUTPOST_BUILDING
end

function MarchUtil.IsScoutMarch(targetType)
  local go_type = LocalController:instance():getIntValue(TableName.LW_March_Target_Type, targetType, "go_type", 0)
  if go_type ~= 0 then
    return go_type == MarchGoType.Scout
  end
  return targetType == MarchTargetType.SCOUT_CITY or targetType == MarchTargetType.SCOUT_WINTER_STORM_CITY or targetType == MarchTargetType.SCOUT_BUILDING or targetType == MarchTargetType.SCOUT_ARMY_COLLECT or targetType == MarchTargetType.SCOUT_TROOP or targetType == MarchTargetType.SCOUT_TREAT or targetType == MarchTargetType.POWER_WORK_HELPER_CHARGE or targetType == MarchTargetType.CHARGE_SUPPLIES or targetType == MarchTargetType.RESOURCE_HELP or targetType == MarchTargetType.SCOUT_DRAGON_SCORE or targetType == MarchTargetType.SCOUT_DRAGON_BUILDING or targetType == MarchTargetType.SCOUT_WINTER_ENTITY or targetType == MarchTargetType.SCOUT_SUPPLIES or targetType == MarchTargetType.SCOUT_THRONE or targetType == MarchTargetType.SCOUT_SERVER_THRONE_BUILDING or targetType == MarchTargetType.SCOUT_CENTER_THRONE or targetType == MarchTargetType.RAINFOREST_THRONE_SCOUT or targetType == MarchTargetType.SCOUT_ALLIANCE_BUILDING or targetType == MarchTargetType.SCOUT_ALLIANCE_CITY or targetType == MarchTargetType.SCOUT_CITY_STRONGHOLD or targetType == MarchTargetType.SCOUT_CITY_TRADE or targetType == MarchTargetType.SCOUT_ACT_ALLIANCE_MINE or targetType == MarchTargetType.SCOUT_DESERT or targetType == MarchTargetType.SCOUT_TRAIN or targetType == MarchTargetType.SEND_COAL or targetType == MarchTargetType.SKILL_SPREAD_VIRUS or targetType == MarchTargetType.SCOUT_METEORITE or targetType == MarchTargetType.SEASON_FARMER_SEND_RES or targetType == MarchTargetType.SEASON_MUMMY_CONVERT or targetType == MarchTargetType.LOTTO_RECEIVE_BASE_REWARD or targetType == MarchTargetType.VALENTINE_RECEIVE_BASE_REWARD or targetType == MarchTargetType.GREEN or targetType == MarchTargetType.SCOUT_ZONE_MOBILIZATION_DONATE or targetType == MarchTargetType.SCOUT_EPIDEMIC_BUILDING or targetType == MarchTargetType.SCOUT_EPIDEMIC_CITY or targetType == MarchTargetType.PIC_EPIDEMIC_SCORE or targetType == MarchTargetType.ALLIANCE_MONSTER_CHALLENGE_NEW_DONATE or targetType == MarchTargetType.CROSS_BANK_DEPOSIT or targetType == MarchTargetType.SCOUT_OUTPOST_BUILDING or targetType == MarchTargetType.CROSS_FORTIFY_CITY_CHARGE
end

function MarchUtil.OnChangeSingleMarch(marchUuid, targetMarchUuid, realPointId)
end

function MarchUtil.OnChangeSingleFormation(formationUuid, targetMarchUuid, realPointId)
end

function MarchUtil.OnAttackMonster(selfMarchUuid, targetMarchInfo, curStamina, isFormation, autoBackHome, isDirectionMarch)
  local targetMarchUuid = targetMarchInfo.uuid
  local monster = DataCenter.MonsterTemplateManager:GetMonsterTemplate(targetMarchInfo.monsterId)
  if monster ~= nil then
    local targetLevel = tonumber(monster.level)
    local targetSpecialType = tonumber(monster.special)
    local showGuide = isDirectionMarch or false
    local hasAttackMaxLevel = LuaEntry.Player.pveLevel
    local attackMaxLv = 0
    local marchType = targetMarchInfo:GetMarchType()
    if SeasonUtil.IsOpenAttackMonsterByLevel(monster.type, 0) then
      attackMaxLv = DataCenter.SeasonDataManager:GetMonsterMaxLevel(monster.type)
    else
      attackMaxLv = DataCenter.MonsterManager:GetCurCanAttackMaxLevel()
    end
    if targetSpecialType ~= WorldMonsterSpecialType.IndividualChallengeBoss and targetSpecialType ~= WorldMonsterSpecialType.AllyChallengeBoss and targetSpecialType ~= WorldMonsterSpecialType.CityStrongholdPVE and targetSpecialType ~= WorldMonsterSpecialType.CityStrongholdPVP and targetSpecialType ~= WorldMonsterSpecialType.CityStrongholdBOSS and targetSpecialType ~= WorldMonsterSpecialType.MonsterInvasion and targetSpecialType ~= WorldMonsterSpecialType.GoldenBeetleBoss and targetSpecialType ~= WorldMonsterSpecialType.AllyDrillCow and targetSpecialType ~= WorldMonsterSpecialType.S1RestCityDefendMonster and marchType ~= NewMarchType.CHALLENGE_BOSS and marchType ~= NewMarchType.PUZZLE_BOSS and targetLevel > attackMaxLv and string.IsNullOrEmpty(targetMarchInfo.eventId) then
      if showGuide == true then
        EventManager:GetInstance():Broadcast(EventId.StartAttackMonsterWithoutMsgTip, 0)
      else
        local msg = Localization:GetString("128008", attackMaxLv)
        UIUtil.ShowTips(msg)
      end
      return
    end
    local formationUuid = 0
    if isFormation == nil or isFormation == false then
      local marchInfo = CS.SceneManager.World:GetMarch(selfMarchUuid)
      if marchInfo ~= nil then
        formationUuid = marchInfo.ownerFormationUuid
      end
    end
    local staminaCost = MarchUtil.GetCostStaminaByTargetType(MarchTargetType.ATTACK_MONSTER, nil, formationUuid)
    if curStamina < staminaCost then
      if showGuide == true then
        EventManager:GetInstance():Broadcast(EventId.StartAttackMonsterWithoutMsgTip, 0)
      else
        LWResourceLackUtil:GotoSpecialResLack(ResLackContextType.Energy)
      end
      return
    end
    local troop = CS.SceneManager.World:GetTroop(targetMarchUuid)
    if troop ~= nil then
      local endPos = SceneUtils.WorldToTileIndex(troop:GetPosition())
      local backHome
      if autoBackHome == MarchAutoBackType.NoBack then
        backHome = autoBackHome
      else
        backHome = MarchUtil.GetAutoBackHomeState(MarchTargetType.ATTACK_MONSTER)
      end
      if isFormation ~= nil and isFormation == true then
        local formation = DataCenter.ArmyFormationDataManager:GetOneArmyInfoByUuid(selfMarchUuid)
        if formation ~= nil then
          if not MarchUtil.CheckFormation(selfMarchUuid, MarchTargetType.ATTACK_MONSTER, endPos, targetMarchUuid, backHome) then
            if showGuide == true then
              EventManager:GetInstance():Broadcast(EventId.StartAttackMonsterWithoutMsgTip, 0)
            end
            return
          end
          if showGuide == true then
            EventManager:GetInstance():Broadcast(EventId.StartAttackMonsterWithoutMsgTip, 1)
          end
          MarchUtil.SendCreateMarchMessage(selfMarchUuid, MarchTargetType.ATTACK_MONSTER, endPos, targetMarchUuid, -1, backHome, true)
        end
      else
        local marchInfo = CS.SceneManager.World:GetMarch(selfMarchUuid)
        if marchInfo ~= nil then
          local formation = DataCenter.ArmyFormationDataManager:GetOneArmyInfoByUuid(marchInfo.ownerFormationUuid)
          if formation ~= nil and formation.heroes ~= nil then
            if showGuide == true then
              EventManager:GetInstance():Broadcast(EventId.StartAttackMonsterWithoutMsgTip, 1)
            end
            MarchUtil.StartMarch(MarchTargetType.ATTACK_MONSTER, endPos, targetMarchUuid, -1, selfMarchUuid, 0, backHome)
          end
        end
      end
    end
  end
end

function MarchUtil.CheckFormation(selfMarchUuid, marchTargetType, endPos, targetMarchUuid, backHome)
  local formation = DataCenter.ArmyFormationDataManager:GetOneArmyInfoByUuid(selfMarchUuid)
  if formation ~= nil then
    local canAddNum = MarchUtil.GetCanAddHeroNum(formation.heroes, formation.index)
    if 0 < canAddNum then
      local show = Setting:GetPrivateInt("SHOW_ADD_HERO", 0)
      if show <= 0 then
        UIUtil.ShowSecondMessage(Localization:GetString("121006"), Localization:GetString("121007"), 1, 121008, "", function()
          local startPos = LuaEntry.Player:GetMainWorldPos()
          UIManager:GetInstance():OpenWindow(UIWindowNames.UIFormationTableNew, selfMarchUuid, marchTargetType, endPos, targetMarchUuid, -1, backHome, startPos, nil, false)
        end, function(needSellConfirm)
          if needSellConfirm == false then
            Setting:SetPrivateInt("SHOW_ADD_HERO", 1)
          else
            Setting:SetPrivateInt("SHOW_ADD_HERO", 0)
          end
        end)
        return false
      end
    end
    local k5 = LuaEntry.DataConfig:TryGetNum("res_lack", "k5")
    local heroUuid, targetHeroUuid = DataCenter.ArmyFormationDataManager:GetFormationHeroCanChangeHigherUuid(selfMarchUuid)
    if k5 >= DataCenter.BuildManager.MainLv and heroUuid ~= nil and heroUuid ~= 0 and targetHeroUuid ~= nil and targetHeroUuid ~= 0 then
      UIUtil.ShowMessage(Localization:GetString("104245"), 1, 121008, "", function()
        local startPos = LuaEntry.Player:GetMainWorldPos()
        UIManager:GetInstance():OpenWindow(UIWindowNames.UIFormationTableNew, selfMarchUuid, marchTargetType, endPos, targetMarchUuid, -1, backHome, startPos, nil, false)
      end)
      return false
    end
  end
  return true
end

function MarchUtil.TryStartMarch(selfMarchUuid, theMarchTargetType, curStamina, isFormation, targetUuid, pointId, backHome, needSoldier, destroyTimeIndex, targetServerId)
  if curStamina ~= nil then
    local staminaCost = MarchUtil.GetCostStaminaByTargetType(theMarchTargetType)
    if curStamina < staminaCost then
      LWResourceLackUtil:GotoSpecialResLack(ResLackContextType.Energy)
      return
    end
  end
  if isFormation == true then
    if targetUuid == 0 or MarchTargetType.COLLECT == theMarchTargetType or MarchTargetType.BUILD_WORM_HOLE == theMarchTargetType or MarchUtil.CheckFormation(selfMarchUuid, theMarchTargetType, pointId, targetUuid, backHome) then
      MarchUtil.SendCreateMarchMessage(selfMarchUuid, theMarchTargetType, pointId, targetUuid, -1, backHome, needSoldier, targetServerId, destroyTimeIndex)
    end
  else
    MarchUtil.StartMarch(theMarchTargetType, pointId, targetUuid, -1, selfMarchUuid, 0, backHome, nil, nil, targetServerId, destroyTimeIndex)
  end
end

function MarchUtil.OnAttackArmy(selfMarchUuid, targetMarchInfo, curStamina, isFormation)
  local targetMarchUuid = targetMarchInfo.uuid
  local staminaCost = MarchUtil.GetCostStaminaByTargetType(MarchTargetType.ATTACK_ARMY)
  if curStamina < staminaCost then
    LWResourceLackUtil:GotoSpecialResLack(ResLackContextType.Energy)
    return
  end
  local troop = CS.SceneManager.World:GetTroop(targetMarchUuid)
  if troop ~= nil then
    local endPos = SceneUtils.WorldToTileIndex(troop:GetPosition())
    local backHome = MarchUtil.GetAutoBackHomeState(MarchTargetType.ATTACK_ARMY)
    MarchUtil.TryStartMarch(selfMarchUuid, MarchTargetType.ATTACK_ARMY, nil, isFormation, targetMarchUuid, endPos, backHome, true)
  end
end

function MarchUtil.OnCollectSimple(selfMarchUuid, pointInfo, curStamina, isFormation)
  local k3 = LuaEntry.DataConfig:TryGetNum("Reconnaissance_power_consumption", "k3")
  local own = LuaEntry.Resource:GetCntByResType(ResourceType.Electricity)
  if k3 > own then
    local lackTab = {
      {
        type = ResLackType.Res,
        resType = ResourceType.Electricity,
        targetNum = k3
      }
    }
    GoToResLack.GoToItemResLackList(lackTab)
    UIUtil.ShowTipsId(129023)
    return
  end
  local backHome = MarchUtil.GetAutoBackHomeState(MarchTargetType.SAMPLE)
  MarchUtil.TryStartMarch(selfMarchUuid, MarchTargetType.SAMPLE, nil, isFormation, pointInfo.uuid, pointInfo.mainIndex, backHome, true)
end

function MarchUtil.OnCollectGarbage(selfMarchUuid, pointInfo, curStamina, isFormation)
  local k2 = LuaEntry.DataConfig:TryGetNum("Reconnaissance_power_consumption", "k3")
  local own = LuaEntry.Resource:GetCntByResType(ResourceType.Electricity)
  if k2 > own then
    local lackTab = {
      {
        type = ResLackType.Res,
        resType = ResourceType.Electricity,
        targetNum = k2
      }
    }
    GoToResLack.GoToItemResLackList(lackTab)
    UIUtil.ShowTipsId(129023)
    return
  end
  local backHome = MarchUtil.GetAutoBackHomeState(MarchTargetType.PICK_GARBAGE)
  MarchUtil.TryStartMarch(selfMarchUuid, MarchTargetType.PICK_GARBAGE, nil, isFormation, pointInfo.uuid, pointInfo.mainIndex, backHome, true)
end

function MarchUtil.OnExplore(selfMarchUuid, pointInfo, curStamina, isFormation)
  local backHome = MarchUtil.GetAutoBackHomeState(MarchTargetType.EXPLORE)
  MarchUtil.TryStartMarch(selfMarchUuid, MarchTargetType.EXPLORE, curStamina, isFormation, pointInfo.uuid, pointInfo.mainIndex, backHome, false)
end

function MarchUtil.OnAttackCollectBuild(selfMarchUuid, pointInfo, curStamina, isFormation)
  local staminaCost = MarchUtil.GetCostStaminaByTargetType(MarchTargetType.ATTACK_ARMY_COLLECT)
  if curStamina < staminaCost then
    LWResourceLackUtil:GotoSpecialResLack(ResLackContextType.Energy)
    return
  end
  if pointInfo == nil or pointInfo.gatherMarchUuid == nil or pointInfo.gatherMarchUuid == 0 then
    return
  end
  local march = CS.SceneManager.World:GetMarch(pointInfo.gatherMarchUuid)
  if march == nil then
    return
  end
  local backHome = MarchUtil.GetAutoBackHomeState(MarchTargetType.ATTACK_ARMY_COLLECT)
  local allianceUid = LuaEntry.Player.allianceId
  if allianceUid ~= nil and allianceUid ~= "" and march.allianceUid == allianceUid then
    return
  else
    MarchUtil.TryStartMarch(selfMarchUuid, MarchTargetType.ATTACK_ARMY_COLLECT, curStamina, isFormation, pointInfo.gatherMarchUuid, pointInfo.mainIndex, backHome, true)
  end
end

function MarchUtil.CallbackMyPowerWorker(selfMarchUuid, workerUuid)
  local marchInfo = CS.SceneManager.World:GetMarch(selfMarchUuid)
  local pointId
  if marchInfo == nil then
    marchInfo = DataCenter.WorldMarchDataManager:GetMarch(selfMarchUuid)
  end
  if marchInfo ~= nil then
    local marchType = marchInfo:GetMarchType()
    local marchTargetType = marchInfo:GetMarchTargetType()
    if marchTargetType == MarchTargetType.POWER_WORKER_BACK or marchTargetType == MarchTargetType.BACK_HOME then
      return
    end
    pointId = MarchUtil.GetFormationStartPos()
    if marchInfo.worldId == 0 then
      pointId = LuaEntry.Player.world_main_pos
    end
    if toInt(pointId) < 1 then
      SFSNetwork.SendMessage(MsgDefines.MoveCityToWorld)
      UIUtil.ShowTipsId("avatar_tips006")
      return
    end
    MarchUtil.StartMarch(MarchTargetType.BACK_HOME, pointId, 0, -1, selfMarchUuid, nil, false, nil, nil, marchInfo.serverId)
  end
end

function MarchUtil.OnBackHome(selfMarchUuid)
  local marchInfo = CS.SceneManager.World:GetMarch(selfMarchUuid)
  local pointId
  if marchInfo == nil then
    marchInfo = DataCenter.WorldMarchDataManager:GetMarch(selfMarchUuid)
  end
  if marchInfo ~= nil then
    local targetServer = marchInfo.serverId
    pointId = MarchUtil.GetFormationStartPos()
    if marchInfo.worldId == 0 then
      pointId = LuaEntry.Player.world_main_pos
      if SeasonUtil.InSeasonBigMapMode(targetServer) then
        targetServer = LuaEntry.Player:GetSelfServerId()
      end
    end
    MarchUtil.StartMarch(MarchTargetType.BACK_HOME, pointId, 0, -1, selfMarchUuid, nil, false, nil, nil, targetServer)
  end
end

function MarchUtil.OnAssistanceBuild(selfMarchUuid, pointInfo, isFormation)
  if not DataCenter.BuildManager:HasBuilding(BuildingTypes.FUND_BUILD_ALLIANCE_CENTER) then
    UIUtil.ShowTipsId(390805)
    return
  end
  MarchUtil.TryStartMarch(selfMarchUuid, MarchTargetType.ASSISTANCE_BUILD, nil, isFormation, pointInfo.uuid, pointInfo.mainIndex, 0, true)
end

function MarchUtil.OnAssistanceOtherCity(selfMarchUuid, pointInfo, isFormation)
  if not DataCenter.BuildManager:HasBuilding(BuildingTypes.FUND_BUILD_ALLIANCE_CENTER) then
    UIUtil.ShowTipsId(390805)
    GoToUtil.GotoCityByBuildId(BuildingTypes.FUND_BUILD_ALLIANCE_CENTER, WorldTileBtnType.City_Upgrade)
    return
  end
  local tmType = MarchTargetType.ASSISTANCE_CITY
  if BattleFieldUtil.InBattleField(BattleFieldType.WinterStorm) then
    tmType = MarchTargetType.ASSISTANCE_WINTER_STORM_CITY
  elseif BattleFieldUtil.InBattleField(BattleFieldType.EpidemicZone) or BattleFieldUtil.InBattleField(BattleFieldType.DsbDuel) then
    tmType = MarchTargetType.ASSISTANCE_EPIDEMIC_CITY
  end
  MarchUtil.TryStartMarch(selfMarchUuid, tmType, nil, isFormation, pointInfo.uuid, pointInfo.mainIndex, 0, true)
end

function MarchUtil.OnAssistanceAllianceCity(selfMarchUuid, pointInfo, isFormation)
  if not DataCenter.BuildManager:HasBuilding(BuildingTypes.FUND_BUILD_ALLIANCE_CENTER) then
    UIUtil.ShowTipsId(390805)
    return
  end
  local curServerId = LuaEntry.Player:GetCurServerId()
  local kingCityId, kingCityPosIndex = SeasonUtil.GetKingCityId(curServerId)
  local targetType = MarchTargetType.ASSISTANCE_ALLIANCE_CITY
  if pointInfo ~= nil and (pointInfo.cityId == kingCityId or pointInfo.CityId == kingCityId) then
    targetType = MarchTargetType.ASSISTANCE_THRONE
  elseif pointInfo ~= nil and pointInfo.pointType == WorldPointType.WORLD_CITY_STRONGHOLD then
    targetType = MarchTargetType.ASSISTANCE_CITY_STRONGHOLD
  end
  MarchUtil.TryStartMarch(selfMarchUuid, targetType, nil, isFormation, pointInfo.uuid, pointInfo.mainIndex, 0, true)
end

function MarchUtil.OnAssistanceDesert(selfMarchUuid, pointId, targetUuid, isFormation)
  if not DataCenter.BuildManager:HasBuilding(BuildingTypes.FUND_BUILD_ALLIANCE_CENTER) then
    UIUtil.ShowTipsId(390805)
    return
  end
  MarchUtil.TryStartMarch(selfMarchUuid, MarchTargetType.ASSISTANCE_DESERT, nil, isFormation, targetUuid, pointId, 0, true)
end

function MarchUtil.OnAttackOtherCity(selfMarchUuid, pointInfo, curStamina, isFormation)
  local protectTime = 0
  local curTime = UITimeManager:GetInstance():GetServerSeconds()
  local info = CS.SceneManager.World:GetPointInfo(pointInfo.mainIndex)
  if info ~= nil then
    cast(info, typeof(CS.BuildPointInfo))
    if info.itemId == BuildingTypes.FUN_BUILD_MAIN then
      protectTime = info.protectEndTime
    end
  end
  if curTime < protectTime then
    UIUtil.ShowTipsId(120190)
    return
  end
  local attackType = MarchTargetType.ATTACK_CITY
  if BattleFieldUtil.InBattleField(BattleFieldType.WinterStorm) then
    attackType = MarchTargetType.ATTACK_WINTER_STORM_CITY
  elseif BattleFieldUtil.InBattleField(BattleFieldType.EpidemicZone) then
    attackType = MarchTargetType.ATTACK_EPIDEMIC_CITY
  end
  local backHome = MarchUtil.GetAutoBackHomeState(attackType)
  MarchUtil.TryStartMarch(selfMarchUuid, attackType, curStamina, isFormation, pointInfo.uuid, pointInfo.mainIndex, backHome, true)
end

function MarchUtil.OnAttackAllianceCity(selfMarchUuid, pointInfo, curStamina, isFormation, destroyTimeIndex)
  local staminaCost = MarchUtil.GetCostStaminaByTargetType(MarchTargetType.ATTACK_ALLIANCE_CITY)
  if curStamina < staminaCost then
    LWResourceLackUtil:GotoSpecialResLack(ResLackContextType.Energy)
    return
  end
  local info = CS.SceneManager.World:GetPointInfo(pointInfo.mainIndex)
  if info ~= nil then
    local curServerId = LuaEntry.Player:GetCurServerId()
    local kingCityId, kingCityPosIndex = SeasonUtil.GetKingCityId(curServerId)
    local allianceCityPointInfo = SeasonUtil.TryParseAllianceCityPointInfo(info.PointType, info.extraInfo, info)
    if allianceCityPointInfo ~= nil then
      local cityId = allianceCityPointInfo.cityId
      local targetUuid = pointInfo.uuid
      local backHome = MarchUtil.GetAutoBackHomeState(MarchTargetType.ATTACK_ALLIANCE_CITY)
      local theMarchTargetType = MarchTargetType.ATTACK_ALLIANCE_CITY
      if allianceCityPointInfo.strongholdId == cityId then
        theMarchTargetType = MarchTargetType.ATTACK_CITY_STRONGHOLD
      elseif cityId == kingCityId then
        local isCrossServerThrone = allianceCityPointInfo.state == AllianceCityState.SERVER_NEUTRAL or allianceCityPointInfo.state == AllianceCityState.SERVER_OCCUPIED or allianceCityPointInfo.state == AllianceCityState.SERVER_BUILD_THRONE
        if isCrossServerThrone then
          local seasonType = SeasonUtil.GetSeasonType(false, true, ServerEnum.Login)
          if seasonType == SeasonMapType.NineNationRainforest then
            local _kingCenterId = SeasonUtil.GetCenterCityId(curServerId)
            if cityId == _kingCenterId then
              theMarchTargetType = MarchTargetType.ATTACK_CENTER_THRONE
            else
              theMarchTargetType = MarchTargetType.RAINFOREST_THRONE_ATTACK
            end
          elseif SeasonUtil.IsNineNationKingMember(pointInfo.serverId) then
            theMarchTargetType = MarchTargetType.ATTACK_CENTER_THRONE
          else
            theMarchTargetType = MarchTargetType.ATTACK_SERVER_THRONE_BUILDING
          end
        else
          theMarchTargetType = MarchTargetType.ATTACK_THRONE
        end
      else
        local curTime = UITimeManager:GetInstance():GetServerSeconds()
        local openTime = allianceCityPointInfo.openTime
        if openTime ~= nil and (curTime < openTime or openTime == -1) then
          UIUtil.ShowTipsId(300708)
          return
        end
        local protectTime = allianceCityPointInfo.protectTime
        if curTime < protectTime then
          UIUtil.ShowTipsId(300709)
          return
        end
      end
      MarchUtil.TryStartMarch(selfMarchUuid, theMarchTargetType, nil, isFormation, targetUuid, pointInfo.mainIndex, backHome, true, destroyTimeIndex)
    end
  end
end

function MarchUtil.OnAttackOtherBuild(selfMarchUuid, pointInfo, curStamina, isFormation)
  local backHome = MarchUtil.GetAutoBackHomeState(MarchTargetType.ATTACK_BUILDING)
  MarchUtil.TryStartMarch(selfMarchUuid, MarchTargetType.ATTACK_BUILDING, curStamina, isFormation, pointInfo.uuid, pointInfo.mainIndex, backHome, true)
end

function MarchUtil.OnAttackOtherRoad(selfMarchUuid, pointInfo, curStamina, isFormation)
  local backHome = MarchUtil.GetAutoBackHomeState(MarchTargetType.ATTACK_ROAD)
  MarchUtil.TryStartMarch(selfMarchUuid, MarchTargetType.ATTACK_ROAD, curStamina, isFormation, pointInfo.uuid, pointInfo.mainIndex, backHome, true)
end

function MarchUtil.OnAttackDesert(selfMarchUuid, pointId, isFormation, targetType)
  local backHome = MarchUtil.GetAutoBackHomeState(targetType)
  MarchUtil.TryStartMarch(selfMarchUuid, targetType, nil, isFormation, pointId, pointId, backHome, true)
end

function MarchUtil.OnBuildWormHole(selfMarchUuid, pointInfo, isFormation)
  MarchUtil.TryStartMarch(selfMarchUuid, MarchTargetType.BUILD_WORM_HOLE, nil, isFormation, pointInfo.uuid, pointInfo.mainIndex, 0, true)
end

function MarchUtil.OnGotoCollect(selfMarchUuid, pointInfo, targetPointId, isFormation)
  local resType = LocalController:instance():getIntValue(TableName.GatherResource, pointInfo.id, "resource_type")
  local itemId = GetTableData(TableName.GatherResource, pointInfo.id, "param")
  local state = MarchUtil.GetResourcePointUnlockStateByType(tonumber(resType), itemId)
  if state == 0 then
    local scienceId = GetTableData(TableName.GatherResource, pointInfo.id, "unlock_science")
    if scienceId ~= "" and not DataCenter.ScienceManager:HasScienceByIdAndLevel(tonumber(scienceId), 1) then
      local template = DataCenter.ScienceTemplateManager:GetScienceTemplate(scienceId, 1)
      UIUtil.ShowTips(Localization:GetString("129055", Localization:GetString(template.name), Localization:GetString(GetTableData(TableName.GatherResource, pointInfo.id, "name"))))
    end
    return
  end
  local backHome = MarchUtil.GetAutoBackHomeState(MarchTargetType.COLLECT)
  MarchUtil.TryStartMarch(selfMarchUuid, MarchTargetType.COLLECT, nil, isFormation, targetPointId, pointInfo.mainIndex, backHome, true)
end

function MarchUtil.OnJoinRally(selfMarchUuid, rallyType, targetUuid, targetPointId, curStamina)
  local staminaCost = MarchUtil.GetCostStaminaByTargetType(MarchTargetType.JOIN_RALLY, rallyType)
  if curStamina < staminaCost then
    LWResourceLackUtil:GotoSpecialResLack(ResLackContextType.Energy)
    return
  end
  MarchUtil.StartMarch(MarchTargetType.JOIN_RALLY, targetPointId, targetUuid, -1, selfMarchUuid)
end

function MarchUtil.OnStation(selfMarchUuid, pointId, isFormation)
  MarchUtil.TryStartMarch(selfMarchUuid, MarchTargetType.STATE, nil, isFormation, 0, pointId, 0, true)
end

function MarchUtil.OnGotoCrossServerWormHole(selfMarchUuid, isFormation, targetServerId)
  local crossBuildData = DataCenter.BuildManager:GetFunbuildByItemID(BuildingTypes.WORM_HOLE_CROSS)
  local mainBuildData = DataCenter.BuildManager:GetFunbuildByItemID(BuildingTypes.APS_BUILD_WORMHOLE_MAIN)
  if crossBuildData ~= nil and mainBuildData ~= nil then
    MarchUtil.TryStartMarch(selfMarchUuid, MarchTargetType.CROSS_SERVER_WORM, nil, isFormation, crossBuildData.uuid, mainBuildData.pointId, 0, true, nil, targetServerId)
  elseif crossBuildData == nil then
    UIUtil.ShowTipsId(140259)
  else
    UIUtil.ShowTipsId(140258)
  end
end

function MarchUtil.GetAutoBackHomeState(type)
  if type == MarchTargetType.ATTACK_CITY or type == MarchTargetType.ATTACK_WINTER_STORM_CITY or type == MarchTargetType.ATTACK_ROAD or type == MarchTargetType.ATTACK_BUILDING or type == MarchTargetType.ATTACK_ALLIANCE_CITY or type == MarchTargetType.ATTACK_THRONE or type == MarchTargetType.PICK_GARBAGE or type == MarchTargetType.ATTACK_DESERT or type == MarchTargetType.ATTACK_EMPTY_DESERT or type == MarchTargetType.ATTACK_DRAGON_BUILDING or type == MarchTargetType.ATTACK_WINTER_ENTITY or type == MarchTargetType.ATTACK_EPIDEMIC_CITY or type == MarchTargetType.ATTACK_EPIDEMIC_BUILDING then
    return 0
  end
  return 1
end

function MarchUtil.GetMaxHeroValueByFormationIndex(index)
  if index == 1 then
    return LuaEntry.Effect:GetGameEffect(EffectDefine.APS_FORMATION_FIRST_HERO_COUNT)
  elseif index == 2 then
    return LuaEntry.Effect:GetGameEffect(EffectDefine.APS_FORMATION_SECOND_HERO_COUNT)
  elseif index == 3 then
    return LuaEntry.Effect:GetGameEffect(EffectDefine.APS_FORMATION_THIRD_HERO_COUNT)
  elseif index == 4 then
    return LuaEntry.Effect:GetGameEffect(EffectDefine.APS_FORMATION_FORTH_HERO_COUNT)
  end
  return 0
end

function MarchUtil.GetMaxHeroValueByDefendFormationIndex(index)
  if index == 1 then
    return LuaEntry.Effect:GetGameEffect(EffectDefine.APS_DEFENCE_FORMATION_FIRST_HERO_COUNT)
  elseif index == 2 then
    return LuaEntry.Effect:GetGameEffect(EffectDefine.APS_DEFENCE_FORMATION_SECOND_HERO_COUNT)
  elseif index == 3 then
    return LuaEntry.Effect:GetGameEffect(EffectDefine.APS_DEFENCE_FORMATION_THIRD_HERO_COUNT)
  end
  return 0
end

function MarchUtil.GetFormationAtkAddNumByFormationIndex(index)
  if index == 1 then
    return LuaEntry.Effect:GetGameEffect(EffectDefine.APS_NORMAL_FORMATION_1_ATK)
  elseif index == 2 then
    return LuaEntry.Effect:GetGameEffect(EffectDefine.APS_NORMAL_FORMATION_2_ATK)
  elseif index == 3 then
    return LuaEntry.Effect:GetGameEffect(EffectDefine.APS_NORMAL_FORMATION_3_ATK)
  elseif index == 4 then
    return LuaEntry.Effect:GetGameEffect(EffectDefine.APS_NORMAL_FORMATION_4_ATK)
  end
  return 0
end

function MarchUtil.GetFormationDefAddNumByFormationIndex(index)
  if index == 1 then
    return LuaEntry.Effect:GetGameEffect(EffectDefine.APS_NORMAL_FORMATION_1_DEF)
  elseif index == 2 then
    return LuaEntry.Effect:GetGameEffect(EffectDefine.APS_NORMAL_FORMATION_2_DEF)
  elseif index == 3 then
    return LuaEntry.Effect:GetGameEffect(EffectDefine.APS_NORMAL_FORMATION_3_DEF)
  elseif index == 4 then
    return LuaEntry.Effect:GetGameEffect(EffectDefine.APS_NORMAL_FORMATION_4_DEF)
  end
  return 0
end

function MarchUtil.GetFormationAddWeightPercentByFormationIndex(index)
  if index == 1 then
    return LuaEntry.Effect:GetGameEffect(EffectDefine.APS_NORMAL_FORMATION_1_CARRY_WEIGHT_ADD_PERCENT)
  elseif index == 2 then
    return LuaEntry.Effect:GetGameEffect(EffectDefine.APS_NORMAL_FORMATION_2_CARRY_WEIGHT_ADD_PERCENT)
  elseif index == 3 then
    return LuaEntry.Effect:GetGameEffect(EffectDefine.APS_NORMAL_FORMATION_3_CARRY_WEIGHT_ADD_PERCENT)
  elseif index == 4 then
    return LuaEntry.Effect:GetGameEffect(EffectDefine.APS_NORMAL_FORMATION_4_CARRY_WEIGHT_ADD_PERCENT)
  end
  return 0
end

function MarchUtil.GetFormationAddWeightNumByFormationIndex(index)
  if index == 1 then
    return LuaEntry.Effect:GetGameEffect(EffectDefine.APS_NORMAL_FORMATION_1_CARRY_WEIGHT_ADD_NUM)
  elseif index == 2 then
    return LuaEntry.Effect:GetGameEffect(EffectDefine.APS_NORMAL_FORMATION_2_CARRY_WEIGHT_ADD_NUM)
  elseif index == 3 then
    return LuaEntry.Effect:GetGameEffect(EffectDefine.APS_NORMAL_FORMATION_3_CARRY_WEIGHT_ADD_NUM)
  elseif index == 4 then
    return LuaEntry.Effect:GetGameEffect(EffectDefine.APS_NORMAL_FORMATION_4_CARRY_WEIGHT_ADD_NUM)
  end
  return 0
end

function MarchUtil.GetFormationMaxNumByFormationIndex(index)
  if index == 1 then
    return LuaEntry.Effect:GetGameEffect(EffectDefine.APS_NORMAL_FORMATION_1_FORMATION_COUNT)
  elseif index == 2 then
    return LuaEntry.Effect:GetGameEffect(EffectDefine.APS_NORMAL_FORMATION_2_FORMATION_COUNT)
  elseif index == 3 then
    return LuaEntry.Effect:GetGameEffect(EffectDefine.APS_NORMAL_FORMATION_3_FORMATION_COUNT)
  elseif index == 4 then
    return LuaEntry.Effect:GetGameEffect(EffectDefine.APS_NORMAL_FORMATION_4_FORMATION_COUNT)
  end
  return 0
end

function MarchUtil.GetFormationBuildNameByIndex(index)
  if index == 1 then
    return BuildingTypes.LW_BUILD_PARKINGLOT
  elseif index == 2 then
    return BuildingTypes.LW_BUILD_PARKINGLOT_TWO
  elseif index == 3 then
    return BuildingTypes.LW_BUILD_PARKINGLOT_THREE
  elseif index == 4 then
    return BuildingTypes.LW_BUILD_PARKINGLOT_FOUR
  end
  return 0
end

function MarchUtil.GetResourcePointUnlockStateByType(resourceType, itemId)
  if resourceType == ResourceType.Water then
    return LuaEntry.Effect:GetGameEffect(EffectDefine.UNLOCK_WATER_GET)
  elseif resourceType == ResourceType.Oil then
    return LuaEntry.Effect:GetGameEffect(EffectDefine.UNLOCK_GAS_GET)
  elseif resourceType == ResourceType.ResourceItem and itemId ~= nil then
    itemId = tonumber(itemId)
    if itemId == ResourceItem.Stone then
      return LuaEntry.Effect:GetGameEffect(EffectDefine.UNLOCK_METAL_GET)
    elseif itemId == ResourceItem.Wood then
      return LuaEntry.Effect:GetGameEffect(EffectDefine.UNLOCK_GAS_GET)
    end
  end
  return 1
end

function MarchUtil.GetFormationSpeedAddByIndex(index)
  if index == 1 then
    return LuaEntry.Effect:GetGameEffect(EffectDefine.APS_NORMAL_FORMATION_1_MARCH_SPEED_ADD_PERCENT)
  elseif index == 2 then
    return LuaEntry.Effect:GetGameEffect(EffectDefine.APS_NORMAL_FORMATION_2_MARCH_SPEED_ADD_PERCENT)
  elseif index == 3 then
    return LuaEntry.Effect:GetGameEffect(EffectDefine.APS_NORMAL_FORMATION_3_MARCH_SPEED_ADD_PERCENT)
  elseif index == 4 then
    return LuaEntry.Effect:GetGameEffect(EffectDefine.APS_NORMAL_FORMATION_4_MARCH_SPEED_ADD_PERCENT)
  end
  return 0
end

function MarchUtil.GetMaxCanAddSoldierNum(heroes, curIndex)
  local asPlayerMaxSoldiers = LuaEntry.DataConfig:TryGetNum("building_base", "k5")
  local baseSize = LuaEntry.Effect:GetGameEffect(EffectDefine.APS_FORMATION_SIZE)
  local sizeEnhance = LuaEntry.Effect:GetGameEffect(EffectDefine.APS_FORMATION_SIZE_ENHANCE)
  asPlayerMaxSoldiers = asPlayerMaxSoldiers + math.floor(baseSize + 0.5)
  local campAdd = 0
  local finalAddNumByIndex = MarchUtil.GetFormationMaxNumByFormationIndex(curIndex)
  asPlayerMaxSoldiers = asPlayerMaxSoldiers + finalAddNumByIndex + campAdd
  asPlayerMaxSoldiers = asPlayerMaxSoldiers * (1 + sizeEnhance / 100)
  return asPlayerMaxSoldiers
end

function MarchUtil.GetDefenceFormationMaxCanAddSoldierNum(heroes)
  return LongMaxValue
end

function MarchUtil.GetExploreFormationPower(heroes, exploreEventId, index, campAddParam)
  local heroAtk = 0
  local heroDef = 0
  local campAtkAdd = 0
  if campAddParam ~= nil then
    for k, v in pairs(campAddParam) do
      campAtkAdd = v.addEffectNum
    end
  end
  if heroes ~= nil then
    for k, v in pairs(heroes) do
      local heroData = DataCenter.HeroDataManager:GetHeroByUuid(k)
      heroAtk = heroAtk + heroData.atk
      heroDef = heroDef + heroData.def
    end
  end
  local k3 = LuaEntry.DataConfig:TryGetNum("new_battle_config", "k3")
  local k16 = LuaEntry.DataConfig:TryGetNum("new_battle_config", "k16")
  local k17 = LuaEntry.DataConfig:TryGetNum("new_battle_config", "k17")
  local totalBaseAdd = MarchUtil.GetEffectNumInFormation(heroes, EffectDefine.ATTACK_ADD_BASE_ALL_ARMY)
  local totalFormationAtkAdd = MarchUtil.GetEffectNumInFormation(heroes, EffectDefine.ATTACK_MONSTER)
  local totalFormationDefAdd = MarchUtil.GetEffectNumInFormation(heroes, EffectDefine.DEFENCE_MONSTER)
  local totalBaseDefenceAdd = MarchUtil.GetEffectNumInFormation(heroes, EffectDefine.DEFENCE_ADD_BASE_ALL_ARMY)
  local totalFormationHealthAdd = MarchUtil.GetEffectNumInFormation(heroes, EffectDefine.HEALTH_ADD_BASE_ALL_ARMY)
  local formationAtkAddNum = MarchUtil.GetFormationAtkAddNumByFormationIndex(index)
  local formationDefAddNum = MarchUtil.GetFormationDefAddNumByFormationIndex(index)
  local totalPower = Mathf.Pow(heroAtk, k3) * Mathf.Pow(heroDef, k3) * (1 + campAtkAdd / 100) * (1 + (heroAtk + heroDef) / math.max(1, k16)) * k17 * (1 + (formationAtkAddNum + totalBaseAdd + totalFormationAtkAdd) / 100) * (1 + (formationDefAddNum + totalBaseDefenceAdd + totalFormationDefAdd) / 100) * (1 + totalFormationHealthAdd / 100)
  return totalPower
end

function MarchUtil.GetFormationPower(heroes, soldiers, index, campAddParam, buffEffectDict)
  local soldierBasicAtk = 0
  local soldierBasicDef = 0
  local soldierBasicHealth = 0
  local heroAtk = 0
  local heroDef = 0
  local soldierTotalNum = 0
  local campAtkAdd = 0
  local sumSkillDamage = 0
  if campAddParam ~= nil then
    for k, v in pairs(campAddParam) do
      campAtkAdd = v.addEffectNum
    end
  end
  if soldiers ~= nil then
    local totalFormationAtkAdd = MarchUtil.GetEffectNumInFormation(heroes, EffectDefine.APS_BATTLE_TROOP_TOTAL_ATK_INCR_PERCENT, buffEffectDict)
    local totalFormationDefAdd = MarchUtil.GetEffectNumInFormation(heroes, EffectDefine.APS_BATTLE_TROOP_TOTAL_DEF_INCR_PERCENT, buffEffectDict)
    local formationAtkAddNum = MarchUtil.GetFormationAtkAddNumByFormationIndex(index)
    local formationDefAddNum = MarchUtil.GetFormationDefAddNumByFormationIndex(index)
    local baseAtkEffectNum = MarchUtil.GetEffectNumInFormation(heroes, GetTableData("effect", EffectCoupleType.BASE_ATTACK, "arm_all"), buffEffectDict)
    local baseDefEffectNum = MarchUtil.GetEffectNumInFormation(heroes, GetTableData("effect", EffectCoupleType.BASE_DEFEND, "arm_all"), buffEffectDict)
    local baseHealthEffectNum = MarchUtil.GetEffectNumInFormation(heroes, GetTableData("effect", EffectCoupleType.BASE_HEALTH_PERCENT, "arm_all"), buffEffectDict)
    for k, v in pairs(soldiers) do
      local template = DataCenter.ArmyTemplateManager:GetArmyTemplate(k)
      if template ~= nil then
        local atk = template.attack
        local def = template.defence
        local health = template.health
        local typeStr = template:GetAddValueEffectName()
        local typeAtkEffectNum = MarchUtil.GetEffectNumInFormation(heroes, GetTableData("effect", EffectCoupleType.BASE_ATTACK, typeStr), buffEffectDict)
        local typeDefEffectNum = MarchUtil.GetEffectNumInFormation(heroes, GetTableData("effect", EffectCoupleType.BASE_DEFEND, typeStr), buffEffectDict)
        local typeHealthEffectNum = MarchUtil.GetEffectNumInFormation(heroes, GetTableData("effect", EffectCoupleType.BASE_HEALTH_PERCENT, typeStr), buffEffectDict)
        soldierBasicAtk = soldierBasicAtk + atk * (1 + (totalFormationAtkAdd + formationAtkAddNum + baseAtkEffectNum + typeAtkEffectNum) / 100) * v
        soldierBasicDef = soldierBasicDef + def * (1 + (totalFormationDefAdd + formationDefAddNum + baseDefEffectNum + typeDefEffectNum) / 100) * v
        soldierBasicHealth = soldierBasicHealth + health * (1 + (baseHealthEffectNum + typeHealthEffectNum) / 100) * v
        soldierTotalNum = soldierTotalNum + v
      end
    end
  end
  if soldierTotalNum <= 0 then
    return 0, 0
  end
  if heroes ~= nil then
    for k, v in pairs(heroes) do
      local heroData = DataCenter.HeroDataManager:GetHeroByUuid(k) or DataCenter.BattleLevel:GetPveHeroData(k)
      heroAtk = heroAtk + heroData.atk
      heroDef = heroDef + heroData.def
      local firstSkillId = HeroUtils.GetHeroFirstSkillId(heroData.heroId)
      local skillLv = heroData:GetSkillLevel(firstSkillId)
      local damage = HeroUtils.GetHeroSkillDamage(firstSkillId, skillLv)
      sumSkillDamage = sumSkillDamage + damage
    end
  end
  local k1 = LuaEntry.DataConfig:TryGetNum("new_battle_config", "k1")
  local k2 = LuaEntry.DataConfig:TryGetNum("new_battle_config", "k2")
  local k3 = LuaEntry.DataConfig:TryGetNum("new_battle_config", "k3")
  local k15 = LuaEntry.DataConfig:TryGetNum("new_battle_config", "k15")
  local k18 = LuaEntry.DataConfig:TryGetNum("new_battle_config", "k18")
  local totalPower = Mathf.Pow(soldierTotalNum * k1, k2) * (soldierBasicAtk / soldierTotalNum) * (soldierBasicDef / soldierTotalNum) * (soldierBasicHealth / soldierTotalNum) * Mathf.Pow(heroAtk, k3) * Mathf.Pow(heroDef, k3) * (1 + campAtkAdd / 100) * (1 + sumSkillDamage / 10) * soldierTotalNum / math.max(1, k15)
  local finalPower = Mathf.Pow(totalPower, k18)
  return finalPower, soldierBasicHealth
end

function MarchUtil.GetEffectNumInFormation(heroes, effectId, buffEffectDict)
  if effectId ~= nil then
    local baseEffectNum = 0
    baseEffectNum = baseEffectNum + LuaEntry.Effect:GetGameEffect(effectId)
    if heroes ~= nil then
      table.walk(heroes, function(k, v)
        local heroData = DataCenter.HeroDataManager:GetHeroByUuid(k)
        if heroData ~= nil then
          local heroBaseNum = heroData:GetEffectNum(effectId)
          baseEffectNum = baseEffectNum + heroBaseNum
        end
      end)
    end
    if buffEffectDict ~= nil and buffEffectDict[effectId] ~= nil then
      baseEffectNum = baseEffectNum + buffEffectDict[effectId]
    end
    return baseEffectNum
  else
    return 0
  end
end

function MarchUtil.GetCampAddParam(heroes)
  local heroIdList = {}
  table.walk(heroes, function(k, v)
    local tempHeroData = DataCenter.HeroDataManager:GetHeroByUuid(k)
    if tempHeroData ~= nil then
      table.insert(heroIdList, tempHeroData.heroId)
    end
  end)
  return MarchUtil.GetCampParamByHeroIdList(heroIdList)
end

function MarchUtil.GetCampParamByHeroIdList(heroIdList)
  local campList = {}
  for k, v in pairs(heroIdList) do
    local camp = GetTableData(HeroUtils.GetHeroXmlName(), v, "camp")
    if type(camp) == "number" and 0 <= camp then
      if campList[camp] ~= nil then
        campList[camp] = campList[camp] + 1
      else
        campList[camp] = 1
      end
    end
  end
  local campArr = {}
  for k, v in pairs(campList) do
    local param = {}
    param.camp = k
    param.num = v
    table.insert(campArr, param)
  end
  table.sort(campArr, function(a, b)
    return a.num > b.num
  end)
  local addEffectList = {}
  for i = 1, #campArr do
    local data = campArr[i]
    if data.num >= 2 then
      local oneData = MarchUtil.GetAddEffectByCampAndNum(data.camp, data.num)
      if oneData ~= nil then
        table.insert(addEffectList, oneData)
      end
    end
  end
  return addEffectList
end

function MarchUtil.GetAddEffectByCampAndNum(camp, num)
  local dialogId = ""
  local k2 = 0
  local k3 = 0
  local k4 = 0
  local k5 = 0
  if camp == HeroCamp.NEW_HUMAN then
    k2 = LuaEntry.Effect:GetGameEffect(EffectDefine.ADD_FORMATION_DAMAGE_BY_CAMP_35212)
    k3 = LuaEntry.Effect:GetGameEffect(EffectDefine.ADD_FORMATION_DAMAGE_BY_CAMP_35213)
    k4 = LuaEntry.Effect:GetGameEffect(EffectDefine.ADD_FORMATION_DAMAGE_BY_CAMP_35214)
    k5 = LuaEntry.Effect:GetGameEffect(EffectDefine.ADD_FORMATION_DAMAGE_BY_CAMP_35215)
    dialogId = 133013
  elseif camp == HeroCamp.MAFIA then
    k2 = LuaEntry.Effect:GetGameEffect(EffectDefine.ADD_FORMATION_DAMAGE_BY_CAMP_35208)
    k3 = LuaEntry.Effect:GetGameEffect(EffectDefine.ADD_FORMATION_DAMAGE_BY_CAMP_35209)
    k4 = LuaEntry.Effect:GetGameEffect(EffectDefine.ADD_FORMATION_DAMAGE_BY_CAMP_35210)
    k5 = LuaEntry.Effect:GetGameEffect(EffectDefine.ADD_FORMATION_DAMAGE_BY_CAMP_35211)
    dialogId = 133012
  elseif camp == HeroCamp.ZELOT then
    k2 = LuaEntry.Effect:GetGameEffect(EffectDefine.ADD_FORMATION_DAMAGE_BY_CAMP_35204)
    k3 = LuaEntry.Effect:GetGameEffect(EffectDefine.ADD_FORMATION_DAMAGE_BY_CAMP_35205)
    k4 = LuaEntry.Effect:GetGameEffect(EffectDefine.ADD_FORMATION_DAMAGE_BY_CAMP_35206)
    k5 = LuaEntry.Effect:GetGameEffect(EffectDefine.ADD_FORMATION_DAMAGE_BY_CAMP_35207)
    dialogId = 133011
  elseif camp == HeroCamp.UNION then
    k2 = LuaEntry.Effect:GetGameEffect(EffectDefine.ADD_FORMATION_DAMAGE_BY_CAMP_35200)
    k3 = LuaEntry.Effect:GetGameEffect(EffectDefine.ADD_FORMATION_DAMAGE_BY_CAMP_35201)
    k4 = LuaEntry.Effect:GetGameEffect(EffectDefine.ADD_FORMATION_DAMAGE_BY_CAMP_35202)
    k5 = LuaEntry.Effect:GetGameEffect(EffectDefine.ADD_FORMATION_DAMAGE_BY_CAMP_35203)
    dialogId = 133010
  end
  local maxNum = 0
  local addEffectNum = 0
  if 0 < k5 then
    maxNum = 5
    addEffectNum = k5
  elseif 0 < k4 then
    maxNum = 4
    addEffectNum = k4
  elseif 0 < k3 then
    maxNum = 3
    addEffectNum = k3
  elseif 0 < k2 then
    maxNum = 2
    addEffectNum = k2
  end
  if 0 < addEffectNum and 1 < num then
    if num > maxNum then
      local oneData = {}
      oneData.addEffectNum = addEffectNum
      oneData.dialog = dialogId
      oneData.num = maxNum
      oneData.camp = camp
      return oneData
    else
      if num == 2 then
        addEffectNum = k2
      elseif num == 3 then
        addEffectNum = k3
      elseif num == 4 then
        addEffectNum = k4
      elseif num == 5 then
        addEffectNum = k5
      end
      local oneData = {}
      oneData.addEffectNum = addEffectNum
      oneData.dialog = dialogId
      oneData.num = num
      oneData.camp = camp
      return oneData
    end
  end
end

function MarchUtil.GetMarchStateIconByType(marchInfo)
  local strImg = "Assets/Main/Sprites/UI/LWCommon/Sprite/Common_icon_march_station"
  if marchInfo ~= nil then
    local marchType = marchInfo:GetMarchType()
    local marchTargetType = marchInfo:GetMarchTargetType()
    if marchType == NewMarchType.SCOUT or marchType == NewMarchType.TREAT_VIRUS or marchType == NewMarchType.LOTTO_RECEIVE or marchType == NewMarchType.ZONE_MOBILIZATION_DONATE or marchType == NewMarchType.MONSTER_CHALLENGE_DONATE then
      if MarchUtil.IsScoutMarch(marchTargetType) then
        strImg = "Assets/Main/Sprites/UI/LWCommon/Sprite/Common_icon_march_scout"
      else
        strImg = "Assets/Main/Sprites/UI/LWCommon/Sprite/zyf_chuzheng_fanhui"
      end
    else
      local currentStatus = marchInfo:GetMarchStatus()
      if marchInfo.inBattle == true then
        strImg = "Assets/Main/Sprites/UI/LWCommon/Sprite/zyf_chuzheng_battle"
      elseif marchInfo:GetIsBroken() == true then
        strImg = "Assets/Main/Sprites/UI/LWCommon/Sprite/Common_icon_march_fail"
      elseif marchTargetType == MarchTargetType.BACK_HOME then
        strImg = "Assets/Main/Sprites/UI/LWCommon/Sprite/zyf_chuzheng_fanhui"
      elseif currentStatus == MarchStatus.DESTROY_WAIT then
        strImg = "Assets/Main/Sprites/UI/LWCommon/Sprite/zyf_chuzheng_battle"
      elseif currentStatus == MarchStatus.CHASING then
        strImg = "Assets/Main/Sprites/UI/LWCommon/Sprite/zyf_chuzheng_battle"
      elseif currentStatus == MarchStatus.MOVING then
        local go_type = LocalController:instance():getIntValue(TableName.LW_March_Target_Type, marchTargetType, "go_type", 0)
        if marchTargetType == MarchTargetType.STATE or go_type == MarchGoType.Monster or go_type == MarchGoType.Player or go_type == MarchGoType.City or go_type == MarchGoType.RallyGo then
          strImg = "Assets/Main/Sprites/UI/LWCommon/Sprite/zyf_chuzheng_battle"
        elseif marchTargetType == MarchTargetType.STATE or marchTargetType == MarchTargetType.ATTACK_MONSTER or marchTargetType == MarchTargetType.ATTACK_ARMY or marchTargetType == MarchTargetType.ATTACK_CITY or marchTargetType == MarchTargetType.ATTACK_WINTER_STORM_CITY or marchTargetType == MarchTargetType.ATTACK_EPIDEMIC_CITY or marchTargetType == MarchTargetType.RALLY_FOR_CITY or marchTargetType == MarchTargetType.RALLY_EPIDEMIC_CITY or marchTargetType == MarchTargetType.ATTACK_WINTER_STORM_CITY or marchTargetType == MarchTargetType.ATTACK_ALLIANCE_CITY or marchTargetType == MarchTargetType.RALLY_FOR_ALLIANCE_CITY or marchTargetType == MarchTargetType.RALLY_SERVER_THRONE_BUILDING or marchTargetType == MarchTargetType.RALLY_CENTER_THRONE or marchTargetType == MarchTargetType.RAINFOREST_THRONE_RALLY or marchTargetType == MarchTargetType.DIRECT_ATTACK_ACT_BOSS or marchTargetType == MarchTargetType.RALLY_FOR_BOSS or marchTargetType == MarchTargetType.DIRECT_ATTACK_ACT_BERSERK_BOSS then
          strImg = "Assets/Main/Sprites/UI/LWCommon/Sprite/zyf_chuzheng_battle"
        else
          strImg = "Assets/Main/Sprites/UI/LWCommon/Sprite/zyf_chuzheng_xingjun"
        end
      elseif currentStatus == MarchStatus.WAIT_RALLY or currentStatus == MarchStatus.IN_TEAM then
        strImg = "Assets/Main/Sprites/UI/LWCommon/Sprite/zyf_chuzheng_jijie"
      elseif marchTargetType == MarchTargetType.SEASON_FARMER_SEND_RES then
        strImg = "Assets/Main/Sprites/UI/UISeason/Sprites/zyf_lianmengjianshezhe_tongmengrukou_icon.png"
      elseif currentStatus == MarchStatus.COLLECTING then
        strImg = "Assets/Main/Sprites/UI/LWCommon/Sprite/zyf_chuzheng_collect"
      elseif currentStatus == MarchStatus.TREASURE_DIGGING then
        strImg = "Assets/Main/Sprites/UI/LWCommon/Sprite/zyf_chuzheng_collect"
      elseif currentStatus == MarchStatus.BACK_HOME then
        strImg = "Assets/Main/Sprites/UI/LWCommon/Sprite/zyf_chuzheng_fanhui"
      elseif currentStatus == MarchStatus.ASSISTANCE then
        strImg = "Assets/Main/Sprites/UI/LWCommon/Sprite/zyf_chuzheng_zhushou"
      elseif currentStatus == MarchStatus.CROSS_SERVER then
        strImg = "Assets/Main/Sprites/UI/LWCommon/Sprite/Common_icon_march_transfer"
      elseif currentStatus == MarchStatus.SAMPLING or currentStatus == MarchStatus.PICKING then
        strImg = "Assets/Main/Sprites/UI/LWCommon/Sprite/Common_icon_march_dig"
      else
        local uuid = marchInfo.uuid
        Logger.LogError("MarchUtil :: Error March state :" .. uuid .. " status:" .. currentStatus)
        strImg = "Assets/Main/Sprites/UI/LWCommon/Sprite/Common_icon_march_station"
      end
    end
  end
  return strImg
end

function MarchUtil.GetMarchStateTextByType(marchInfo)
  local str = ""
  if CS.SceneManager.IsInCity() then
    return
  end
  if marchInfo ~= nil then
    local marchType = marchInfo:GetMarchType()
    local marchTargetType = marchInfo:GetMarchTargetType()
    if marchType == NewMarchType.SCOUT or marchType == NewMarchType.TREAT_VIRUS or marchType == NewMarchType.LOTTO_RECEIVE or marchType == NewMarchType.ZONE_MOBILIZATION_DONATE or marchType == NewMarchType.MONSTER_CHALLENGE_DONATE then
      if MarchUtil.IsScoutMarch(marchTargetType) then
        local endPos = SceneUtils.IndexToTilePos(marchInfo.targetPos)
        local bigMode = SeasonUtil.InSeasonBigMapMode(marchInfo.serverId)
        if bigMode or marchInfo.targetServer ~= marchInfo.srcServer then
          str = Localization:GetString("458156") .. string.format("#%s(%s,%s)", marchInfo.targetServer, endPos.x, endPos.y)
        else
          str = Localization:GetString("458156") .. " " .. Localization:GetString("310137", endPos.x, endPos.y)
        end
      else
        str = Localization:GetString("458157")
      end
    else
      local currentStatus = marchInfo:GetMarchStatus()
      if marchInfo.inBattle == true then
      elseif marchInfo:GetIsBroken() == true then
        str = Localization:GetString("458157")
      elseif marchTargetType == MarchTargetType.BACK_HOME then
        str = Localization:GetString("458157")
      elseif marchTargetType == MarchTargetType.POWER_WORKER_BACK then
        str = Localization:GetString("458157")
      elseif marchTargetType == MarchTargetType.CHARGE_SUPPLIES then
        str = Localization:GetString("458157")
      elseif currentStatus == MarchStatus.DESTROY_WAIT then
      elseif currentStatus == MarchStatus.MOVING or currentStatus == MarchStatus.CROSS_SERVER or currentStatus == MarchStatus.CHASING then
        local endPos = SceneUtils.IndexToTilePos(marchInfo.targetPos)
        local bigMode = SeasonUtil.InSeasonBigMapMode(marchInfo.serverId)
        if bigMode or marchInfo.targetServer ~= marchInfo.srcServer then
          str = Localization:GetString("458156") .. string.format("#%s(%s,%s)", marchInfo.targetServer, endPos.x, endPos.y)
        else
          str = Localization:GetString("458156") .. " " .. Localization:GetString("310137", endPos.x, endPos.y)
        end
      elseif currentStatus == MarchStatus.WAIT_RALLY or currentStatus == MarchStatus.IN_TEAM then
        str = Localization:GetString("458158")
      elseif currentStatus == MarchStatus.COLLECTING then
        str = Localization:GetString("458160")
      elseif currentStatus == MarchStatus.BACK_HOME then
        str = Localization:GetString("458157")
      elseif currentStatus == MarchStatus.ASSISTANCE then
        str = Localization:GetString("458159")
        if (marchInfo.worldId > 1 or BattleFieldUtil.InBattleField()) and (marchTargetType == MarchTargetType.ASSISTANCE_DRAGON_BUILDING or marchTargetType == MarchTargetType.ASSISTANCE_WINTER_ENTITY or marchTargetType == MarchTargetType.ASSISTANCE_EPIDEMIC_BUILDING) then
          local strKey = "458223"
          if marchTargetType == MarchTargetType.ASSISTANCE_WINTER_ENTITY then
            local world = CS.SceneManager.World
            local info = world ~= nil and world:GetPointInfoByUuid(marchInfo.targetUuid) or nil
            if info ~= nil and info.detail ~= nil then
              local config = DataCenter.WinterStormTemplateManager:GetTemplate(info.detail.BuildId)
              if config ~= nil and not config:IsBuild() then
                strKey = "winter_battlefield_interface_tips1061"
              end
            end
          end
          str = Localization:GetString(strKey)
        end
      elseif currentStatus == MarchStatus.CROSS_SERVER then
      elseif currentStatus == MarchStatus.SAMPLING or currentStatus == MarchStatus.PICKING then
      else
        if currentStatus == MarchStatus.TREASURE_DIGGING then
          str = Localization:GetString("458160")
        else
        end
      end
    end
  end
  return str
end

function MarchUtil.GetMarchBtnImgByType(marchInfo)
  local strImg
  if marchInfo ~= nil then
    local marchType = marchInfo:GetMarchType()
    if marchType == NewMarchType.SCOUT or marchType == NewMarchType.TREAT_VIRUS or marchType == NewMarchType.LOTTO_RECEIVE or marchType == NewMarchType.ZONE_MOBILIZATION_DONATE or marchType == NewMarchType.MONSTER_CHALLENGE_DONATE then
      strImg = "Assets/Main/Sprites/UI/UIMain/LWMainUI/cfm_zhujiemian_anniu_fanhui.png"
    else
      local currentStatus = marchInfo:GetMarchStatus()
      if marchInfo.inBattle == true then
      elseif marchInfo:GetIsBroken() == true then
      elseif marchInfo:GetMarchTargetType() == MarchTargetType.BACK_HOME then
        strImg = "Assets/Main/Sprites/UI/UIMain/LWMainUI/cfm_zhujiemian_anniu_jiasu.png"
      elseif currentStatus == MarchStatus.DESTROY_WAIT then
      elseif currentStatus == MarchStatus.MOVING or currentStatus == MarchStatus.CHASING then
        strImg = "Assets/Main/Sprites/UI/UIMain/LWMainUI/cfm_zhujiemian_anniu_jiasu.png"
      elseif currentStatus == MarchStatus.WAIT_RALLY or currentStatus == MarchStatus.IN_TEAM then
        strImg = "Assets/Main/Sprites/UI/UIMain/LWMainUI/cfm_zhujiemian_anniu_zhencha.png"
      elseif currentStatus == MarchStatus.COLLECTING then
        strImg = "Assets/Main/Sprites/UI/UIMain/LWMainUI/cfm_zhujiemian_anniu_fanhui.png"
      elseif currentStatus == MarchStatus.BACK_HOME then
        strImg = "Assets/Main/Sprites/UI/UIMain/LWMainUI/cfm_zhujiemian_anniu_jiasu.png"
      elseif currentStatus == MarchStatus.ASSISTANCE then
        strImg = "Assets/Main/Sprites/UI/UIMain/LWMainUI/cfm_zhujiemian_anniu_fanhui.png"
      elseif currentStatus == MarchStatus.CROSS_SERVER then
        strImg = "Assets/Main/Sprites/UI/UIMain/LWMainUI/cfm_zhujiemian_anniu_fanhui.png"
      end
    end
  end
  return strImg
end

local ReturnBtnImgPath = "Assets/Main/Sprites/UI/UIMain/LWMainUI/zxl_biandui_fanhui.png"
local CancelBtnImgPath = "Assets/Main/Sprites/UI/UIMain/LWMainUI/lrb_DLD_qvxiao_btn.png"

function MarchUtil.CheckShowSecondBtnStatus(marchInfo)
  if marchInfo ~= nil then
    local marchType = marchInfo:GetMarchType()
    local currentStatus = marchInfo:GetMarchStatus()
    local marchTargetType = marchInfo:GetMarchTargetType()
    if marchType == NewMarchType.ASSEMBLY_MARCH then
      if currentStatus == MarchStatus.WAIT_RALLY then
        local _, imLeader
        _, imLeader = DataCenter.AllianceWarDataManager:CheckJoinAllianceWar(marchInfo.teamUuid)
        if imLeader then
          return true, nil, CancelBtnImgPath, function()
            MarchUtil.CancelRallyByLeader(marchInfo.teamUuid)
          end
        else
          return true, nil, ReturnBtnImgPath, function()
            MarchUtil.CancelRallyByMember(marchInfo.teamUuid, marchInfo.uuid)
          end
        end
      elseif currentStatus == MarchStatus.MOVING then
        return false, Localization:GetString("world_tip10018")
      end
    elseif marchType == NewMarchType.DIRECT_MOVE_MARCH then
      return false, Localization:GetString("world_tip10016")
    elseif marchTargetType == MarchTargetType.JOIN_RALLY then
      return true, nil, ReturnBtnImgPath, function()
        MarchUtil.CancelRallyByMember(marchInfo.teamUuid, marchInfo.uuid)
      end
    elseif currentStatus == MarchStatus.COLLECTING then
      return false, Localization:GetString("world_tip10019")
    elseif currentStatus == MarchStatus.ASSISTANCE then
      return false, Localization:GetString("world_tip10019")
    elseif marchTargetType == MarchTargetType.BACK_HOME then
      return false, Localization:GetString("world_tip10017")
    end
    return true, nil, ReturnBtnImgPath, function()
      WorldMarchTileUIManager:GetInstance():OnBtnClick(WorldMarchTileBtnType.March_Callback, marchInfo.uuid)
    end
  end
  return false
end

function MarchUtil.SendCreateMarchMessage(formationUuid, targetType, targetPoint, targetUuid, timeIndex, autoBackHome, needSoldier, targetServerId, destroyTimeIndex)
  local hasHero = false
  local hasSolider = false
  local curSoldiers = {}
  local curHeroes = {}
  local pos = MarchUtil.GetFormationStartPos()
  local targetServer = LuaEntry.Player:GetCurServerId()
  if targetServerId ~= nil then
    targetServer = targetServerId
  end
  local formation = DataCenter.ArmyFormationDataManager:GetOneArmyInfoByUuid(formationUuid)
  if formation ~= nil then
    curSoldiers = formation.soldiers
    curHeroes = formation.heroes
    if needSoldier ~= nil and needSoldier == false then
      curSoldiers = {}
    end
    local tempFormationTable = {}
    tempFormationTable.uuid = formation.uuid
    tempFormationTable.index = formation.index
    tempFormationTable.soldiers = curSoldiers
    tempFormationTable.ownerUid = LuaEntry.Player.uid
    tempFormationTable.heroes = curHeroes
    table.walk(curSoldiers, function(k, v)
      if toInt(v.supply) > 0 then
        hasSolider = true
      end
    end)
    table.walk(curHeroes, function(k, v)
      if k ~= 0 then
        hasHero = true
      end
    end)
    if hasHero and (hasSolider or needSoldier ~= nil and needSoldier == false) then
      if targetType ~= MarchTargetType.COLLECT or targetType ~= MarchTargetType.COLLECT_METEORITE or targetType ~= MarchTargetType.COLLECT_EPIDEMIC_RES then
        DataCenter.ArmyFormationDataManager:RefreshFormationModelToJson(tempFormationTable)
      end
      local sfsObj = SFSObject.New()
      sfsObj:PutLong("uuid", formationUuid)
      local armyArray = SFSArray.New()
      for posIndex, tab in pairs(curSoldiers) do
        if not table.IsNullOrEmpty(tab) then
          local soldierIdNumArr = SFSArray.New()
          for soldierId, soldierNum in pairs(tab) do
            if type(soldierId) == "number" then
              local obj = SFSObject.New()
              obj:PutInt("soldierId", soldierId)
              obj:PutInt("soldierNum", soldierNum)
              soldierIdNumArr:AddSFSObject(obj)
            end
          end
          local army = SFSObject.New()
          army:PutInt("posIndex", posIndex)
          army:PutSFSArray("soldierIdNumArr", soldierIdNumArr)
          armyArray:AddSFSObject(army)
        end
      end
      sfsObj:PutSFSArray("formations", armyArray)
      local heroInfo = formation:GenerateServerHeroArray()
      sfsObj:PutSFSArray("heroInfos", heroInfo)
      MarchUtil.StartMarch(targetType, targetPoint, targetUuid, timeIndex, 0, formationUuid, autoBackHome, sfsObj, pos, targetServer, destroyTimeIndex)
    else
      UIUtil.ShowTipsId(GameDialogDefine.ADD_SOLDIER)
    end
  end
end

function MarchUtil.OnLaunchMarchSuccess(marchTargetType, targetUuid, targetPos)
  if not MarchUtil.IsScoutMarch(marchTargetType) then
    return
  end
  if marchTargetType == MarchTargetType.SCOUT_WINTER_STORM_CITY or marchTargetType == MarchTargetType.SCOUT_CITY then
    DataCenter.ArmyFormationDataManager:SetScoutCD(targetUuid)
  end
  if marchTargetType == MarchTargetType.SEASON_FARMER_SEND_RES then
    UIUtil.ShowTipsId("season_builders_alliance_tips_43")
  elseif marchTargetType == MarchTargetType.SCOUT_TREAT or marchTargetType == MarchTargetType.SEASON_MUMMY_CONVERT then
    UIUtil.ShowTipsId("season_s1_march_tips01")
  elseif marchTargetType == MarchTargetType.LOTTO_RECEIVE_BASE_REWARD or marchTargetType == MarchTargetType.VALENTINE_RECEIVE_BASE_REWARD then
    UIUtil.ShowTipsId("thxgiv_MapGiftGetGO")
  elseif marchTargetType == MarchTargetType.GREEN then
    UIUtil.ShowTipsId("season_oasis_tips_5")
  elseif marchTargetType == MarchTargetType.CROSS_FORTIFY_CITY_CHARGE then
    UIUtil.ShowTipsId("season_s6_government_skill_desc83")
  elseif marchTargetType == MarchTargetType.SCOUT_ZONE_MOBILIZATION_DONATE then
    UIUtil.ShowTipsId("zone_mobilization_donate_march_2")
  elseif marchTargetType == MarchTargetType.ALLIANCE_MONSTER_CHALLENGE_NEW_DONATE then
    UIUtil.ShowTipsId("challenge_zombie_transmitted_march_2")
  elseif marchTargetType == MarchTargetType.POWER_WORK_HELPER_CHARGE then
    local v3 = SceneUtils.TileIndexToWorld(targetPos, ForceChangeScene.World)
    GoToUtil.CloseAllWindows()
    GoToUtil.GotoWorldPos(v3)
  else
    UIUtil.ShowTipsId("scouting_departure_tips")
  end
end

function MarchUtil.LaunchScout(marchTargetType, pointId, targetUuid, extraParam, serverId)
  local formation = DataCenter.ArmyFormationDataManager:GetFreeScoutFormation()
  if not formation then
    if marchTargetType == MarchTargetType.SEASON_FARMER_SEND_RES then
      UIUtil.ShowTipsId("season_builders_alliance_tips_44")
    elseif marchTargetType == MarchTargetType.SCOUT_TREAT or marchTargetType == MarchTargetType.SEASON_MUMMY_CONVERT then
      UIUtil.ShowTipsId("season_s1_march_tips02")
    elseif marchTargetType == MarchTargetType.LOTTO_RECEIVE_BASE_REWARD or marchTargetType == MarchTargetType.VALENTINE_RECEIVE_BASE_REWARD then
      UIUtil.ShowTipsId("thxgiv_MapGiftGetNO")
    elseif marchTargetType == MarchTargetType.SCOUT_ZONE_MOBILIZATION_DONATE then
      UIUtil.ShowTipsId("zone_mobilization_donate_march_1")
    elseif marchTargetType == MarchTargetType.ALLIANCE_MONSTER_CHALLENGE_NEW_DONATE then
      UIUtil.ShowTipsId("challenge_zombie_transmitted_march_1")
    elseif marchTargetType == MarchTargetType.CROSS_FORTIFY_CITY_CHARGE then
      UIUtil.ShowTipsId("season_s6_government_skill_desc82")
    else
      UIUtil.ShowTipsId("300607")
    end
    return
  end
  local formationUuid = formation.uuid
  local realPoint = pointId
  local pointInfo
  local curServerId = LuaEntry.Player:GetCurServerId()
  if marchTargetType == MarchTargetType.SCOUT_BUILDING then
    if pointInfo == nil then
      pointInfo = CS.SceneManager.World:GetPointInfoByUuid(targetUuid)
    end
    if pointInfo and pointInfo.PointType == WorldPointType.PlayerBuilding then
      cast(pointInfo, typeof(CS.BuildPointInfo))
      if pointInfo then
        if pointInfo.itemId == BuildingTypes.FUN_BUILD_MAIN then
          marchTargetType = MarchTargetType.SCOUT_CITY
          if BattleFieldUtil.InBattleField(BattleFieldType.WinterStorm) then
            marchTargetType = MarchTargetType.SCOUT_WINTER_STORM_CITY
          elseif BattleFieldUtil.InBattleField(BattleFieldType.EpidemicZone) then
            marchTargetType = MarchTargetType.SCOUT_EPIDEMIC_CITY
          end
        else
          marchTargetType = MarchTargetType.SCOUT_BUILDING
        end
      end
    end
  elseif marchTargetType == MarchTargetType.SCOUT_ALLIANCE_CITY or marchTargetType == MarchTargetType.SCOUT_THRONE then
    local worldPos = SceneUtils.TileIndexToWorld(pointId)
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
  MarchUtil.StartMarch(marchTargetType, realPoint, targetUuid, -1, 0, formationUuid, 1, dataObj, pos, curServerId, nil, extraParam)
end

function MarchUtil.LaunchPowerHelp(marchTargetType, pointId, targetUuid, extraParam)
  local formation = DataCenter.SeasonPowerWorkerManager:GetFreeFormation()
  if not formation then
    if marchTargetType == MarchTargetType.CHARGE_SUPPLIES then
      UIUtil.ShowTipsId("season_s4_power_worker_tips_1")
    else
      UIUtil.ShowTipsId("season_s4_power_worker_tips_7")
    end
    return
  end
  local formationUuid = formation.uuid
  local realPoint = pointId
  local sfsObj = SFSObject.New()
  sfsObj:PutLong("uuid", formationUuid)
  local formationArray = SFSArray.New()
  sfsObj:PutSFSArray("formations", formationArray)
  local heroArray = SFSArray.New()
  sfsObj:PutSFSArray("heroInfos", heroArray)
  local dataObj = sfsObj
  local pos = MarchUtil.GetFormationStartPos()
  local curServerId = LuaEntry.Player:GetCurServerId()
  if extraParam == nil then
    extraParam = SFSObject.New()
    extraParam:PutBool("userPowerWorker", true)
  end
  MarchUtil.StartMarch(marchTargetType, realPoint, targetUuid, -1, 0, formationUuid, 1, dataObj, pos, curServerId, nil, extraParam)
end

function MarchUtil.StartMarch(targetType, targetPoint, targetUuid, timeIndex, mUuid, fUuid, autoBackHome, dataObj, pos, targetServer, desTimeIndex, extraParam)
  local world = CS.SceneManager.World
  local formationUuid = fUuid or 0
  local marchUuid = mUuid or 0
  local backHome = autoBackHome or 1
  local startPos = pos or 0
  local targetServerId = targetServer or LuaEntry.Player:GetCurServerId()
  local destroyTimeIndex = desTimeIndex or -1
  local effectPath, pointInfo
  if SeasonUtil.InSeasonBigMapMode(targetServerId) then
    if targetUuid then
      pointInfo = world:GetPointInfoByUuid(targetUuid)
      if pointInfo == nil then
        local marchInfo = world:GetMarch(targetUuid)
        if marchInfo and marchInfo.serverId ~= 0 then
          targetServerId = marchInfo.serverId
        end
      end
    elseif targetPoint then
      pointInfo = world:GetPointInfo(targetPoint)
    end
    if pointInfo then
      targetServerId = pointInfo.serverId
    end
  end
  local go_type = LocalController:instance():getIntValue(TableName.LW_March_Target_Type, targetType, "go_type", 0)
  if targetType == MarchTargetType.COLLECT then
    EventManager:GetInstance():Broadcast(EventId.UIMAIN_VISIBLE, true)
    GoToUtil.GotoPos(world.CurTarget, world.InitZoom, LookAtFocusTime, nil, targetServerId)
  elseif targetType == MarchTargetType.STATE or go_type == MarchGoType.Assistance or targetType == MarchTargetType.ASSISTANCE_BUILD or targetType == MarchTargetType.ASSISTANCE_CITY or targetType == MarchTargetType.ASSISTANCE_WINTER_STORM_CITY or targetType == MarchTargetType.ASSISTANCE_EPIDEMIC_CITY or targetType == MarchTargetType.ASSIST_TRAIN or targetType == MarchTargetType.ASSISTANCE_ALLIANCE_CITY or targetType == MarchTargetType.ASSISTANCE_CITY_STRONGHOLD or targetType == MarchTargetType.ASSISTANCE_THRONE or targetType == MarchTargetType.ASSISTANCE_DRAGON_BUILDING or targetType == MarchTargetType.ASSISTANCE_WINTER_ENTITY or targetType == MarchTargetType.ASSISTANCE_EPIDEMIC_BUILDING or targetType == MarchTargetType.ASSISTANCE_SERVER_THRONE_BUILDING or targetType == MarchTargetType.ASSISTANCE_CENTER_THRONE or targetType == MarchTargetType.RAINFOREST_THRONE_ASSISTANCE or targetType == MarchTargetType.ASSISTANCE_DESERT then
    effectPath = "Assets/Main/Prefabs/Effect/World/Eff_daditu_xingjun_jiantou_lan.prefab"
  elseif go_type == MarchGoType.Player or go_type == MarchGoType.City or go_type == MarchGoType.Monster or targetType == MarchTargetType.DIRECT_ATTACK_ACT_BOSS or targetType == MarchTargetType.ATTACK_MONSTER or targetType == MarchTargetType.ATTACK_BUILDING or targetType == MarchTargetType.ATTACK_ARMY or targetType == MarchTargetType.ATTACK_ARMY_COLLECT or targetType == MarchTargetType.ATTACK_CITY or targetType == MarchTargetType.ATTACK_WINTER_STORM_CITY or targetType == MarchTargetType.ATTACK_EPIDEMIC_CITY or targetType == MarchTargetType.ATTACK_ROAD or targetType == MarchTargetType.ATTACK_ALLIANCE_CITY or targetType == MarchTargetType.ATTACK_TRAIN or targetType == MarchTargetType.ATTACK_THRONE or targetType == MarchTargetType.ATTACK_DRAGON_BUILDING or targetType == MarchTargetType.ATTACK_WINTER_ENTITY or targetType == MarchTargetType.ATTACK_EPIDEMIC_BUILDING or targetType == MarchTargetType.ATTACK_SERVER_THRONE_BUILDING or targetType == MarchTargetType.ATTACK_CENTER_THRONE or targetType == MarchTargetType.RAINFOREST_THRONE_ATTACK or targetType == MarchTargetType.ATTACK_DESERT or targetType == MarchTargetType.ATTACK_EMPTY_DESERT or targetType == MarchTargetType.ATTACK_PLAYER_RUIN_BUILDING then
    effectPath = "Assets/Main/Prefabs/Effect/World/Eff_daditu_xingjun_jiantou_hong.prefab"
  end
  if 0 >= toInt(targetServerId) then
    targetServerId = LuaEntry.Player:GetCurServerId()
  end
  if effectPath then
    local worldPos = SceneUtils.TileIndexToWorld(targetPoint, ForceChangeScene.World, targetServerId)
    EventManager:GetInstance():Broadcast(EventId.StartMarch, {effectPath = effectPath, worldPos = worldPos})
  end
  if formationUuid ~= 0 then
    local march = DataCenter.WorldMarchDataManager:GetOwnerFormationMarch(LuaEntry.Player.uid, formationUuid, LuaEntry.Player.allianceId)
    if march ~= nil then
      MarchUtil.SendChangeMarchToServer(march.uuid, targetType, targetPoint, targetUuid, backHome == 1, targetServerId, destroyTimeIndex)
    else
      MarchUtil.SendCreateMarchToServer(formationUuid, targetType, targetPoint, targetUuid, timeIndex, dataObj, startPos, backHome == 1, targetServerId, destroyTimeIndex, extraParam)
    end
  elseif marchUuid ~= 0 then
    MarchUtil.SendChangeMarchToServer(marchUuid, targetType, targetPoint, targetUuid, backHome == 1, targetServerId, destroyTimeIndex)
  end
end

function MarchUtil.SendCreateMarchToServer(formationUuid, targetType, targetPoint, targetUuid, timeIndex, formationData, startPos, backHome, targetServerId, destroyTimeIndex, extraParam)
  local posStart = startPos
  if startPos <= 0 then
    posStart = MarchUtil.GetFormationStartPos()
  end
  local posStartV2 = SceneUtils.IndexToTilePos(posStart, ForceChangeScene.World)
  local endPos = SceneUtils.IndexToTilePos(targetPoint, ForceChangeScene.World)
  if targetType == MarchTargetType.ATTACK_ARMY or targetType == MarchTargetType.ATTACK_MONSTER or targetType == MarchTargetType.ATTACK_BUILDING or targetType == MarchTargetType.EXPLORE or targetType == MarchTargetType.SAMPLE or targetType == MarchTargetType.PICK_GARBAGE or targetType == MarchTargetType.ATTACK_PLAYER_RUIN_BUILDING then
    endPos = MarchUtil.GetAttackPos(posStartV2, endPos, 3)
  elseif targetType == MarchTargetType.RALLY_FOR_BOSS then
    endPos = MarchUtil.GetAttackPos(posStartV2, endPos, 3)
  elseif targetType == MarchTargetType.RALLY_MUMMY then
    local marchData = DataCenter.WorldMarchDataManager:GetMarch(targetUuid)
    if marchData and marchData.position then
      endPos = SceneUtils.WorldToTile(marchData.position, ForceChangeScene.World)
    end
  elseif targetType == MarchTargetType.ATTACK_ALLIANCE_CITY or targetType == MarchTargetType.ATTACK_THRONE or targetType == MarchTargetType.RALLY_THRONE or targetType == MarchTargetType.RALLY_DRAGON_BUILDING or targetType == MarchTargetType.RALLY_EPIDEMIC_BUILDING or targetType == MarchTargetType.RALLY_SERVER_THRONE_BUILDING or targetType == MarchTargetType.RALLY_CENTER_THRONE or targetType == MarchTargetType.RAINFOREST_THRONE_RALLY or targetType == MarchTargetType.RALLY_FOR_ALLIANCE_CITY then
    endPos = MarchUtil.GetAttackPos(posStartV2, {
      x = endPos.x,
      y = endPos.y
    }, 5)
  end
  local startPointId = SceneUtils.TilePosToIndex(posStartV2, ForceChangeScene.World)
  local endPointId = SceneUtils.TilePosToIndex(endPos, ForceChangeScene.World)
  if startPointId == 0 or startPointId == 1 then
    local worldId = LuaEntry.Player:GetCurWorldId()
    local world_main_pos = toInt(LuaEntry.Player.world_main_pos)
    local dragon_main_pos = toInt(LuaEntry.Player.dragon_main_pos)
    Logger.LogError(string.format("[ERR] CreateMarch startPos=(%s) targetPoint=(%s) world_main_pos=(%s) dragon_main_pos=(%s) worldId=(%s)", startPos, targetPoint, world_main_pos, dragon_main_pos, worldId))
    if 1 < dragon_main_pos then
      startPointId = dragon_main_pos
    elseif 1 < world_main_pos then
      startPointId = world_main_pos
    else
      SFSNetwork.SendMessage(MsgDefines.MoveCityToWorld)
    end
  end
  local path = startPointId .. ";" .. endPointId
  local formation = DataCenter.ArmyFormationDataManager:GetOneArmyInfoByUuid(formationUuid)
  local serverSoldiers
  if formation then
    serverSoldiers = formation.serverSoldiers
  end
  local cardSkillUseInfoList = DataCenter.TacticalCardDataManager:PopFormationViewCardSkillUseCache()
  SFSNetwork.SendMessage(MsgDefines.WorldMarchFormationNew, formationUuid, targetType, targetUuid, path, timeIndex, backHome, formationData, targetServerId, destroyTimeIndex, serverSoldiers, extraParam, cardSkillUseInfoList)
end

function MarchUtil.SendChangeMarchToServer(marchUuid, targetType, targetPoint, targetUuid, backHome, targetServerId, destroyTimeIndex)
  local marchInfo = CS.SceneManager.World:GetMarch(marchUuid)
  if marchInfo == nil then
    marchInfo = DataCenter.WorldMarchDataManager:GetMarch(marchUuid)
  end
  if marchInfo == nil then
    return
  end
  local posStart = 0
  local status = marchInfo:GetMarchStatus()
  if status == MarchStatus.COLLECTING or status == MarchStatus.ASSISTANCE or status == MarchStatus.TREASURE_DIGGING then
    posStart = marchInfo.targetPos
    if status == MarchStatus.COLLECTING or status == MarchStatus.TREASURE_DIGGING then
      CS.SceneManager.World:DestroyArmyAnimalObject(marchUuid)
    end
  else
    posStart = SceneUtils.WorldToTileIndex(marchInfo:GetMarchCurPos())
  end
  local startPos = SceneUtils.IndexToTilePos(posStart)
  local endPos = SceneUtils.IndexToTilePos(targetPoint)
  if targetType == MarchTargetType.ATTACK_ARMY or targetType == MarchTargetType.ATTACK_MONSTER or targetType == MarchTargetType.ATTACK_BUILDING or targetType == MarchTargetType.EXPLORE or targetType == MarchTargetType.SAMPLE or targetType == MarchTargetType.PICK_GARBAGE then
    endPos = MarchUtil.GetAttackPos(startPos, endPos, 3)
  elseif targetType == MarchTargetType.RALLY_FOR_BOSS then
    endPos = MarchUtil.GetAttackPos(startPos, endPos, 3)
  elseif targetType == MarchTargetType.ATTACK_ALLIANCE_CITY or targetType == MarchTargetType.ATTACK_THRONE or targetType == MarchTargetType.ASSISTANCE_CITY_STRONGHOLD or targetType == MarchTargetType.RALLY_THRONE or targetType == MarchTargetType.RALLY_DRAGON_BUILDING or targetType == MarchTargetType.RALLY_EPIDEMIC_BUILDING or targetType == MarchTargetType.RALLY_SERVER_THRONE_BUILDING or targetType == MarchTargetType.RALLY_CENTER_THRONE or targetType == MarchTargetType.RAINFOREST_THRONE_RALLY or targetType == MarchTargetType.RALLY_CITY_STRONGHOLD or targetType == MarchTargetType.RALLY_FOR_ALLIANCE_CITY then
    endPos = MarchUtil.GetAttackPos(startPos, endPos, 5)
  end
  local startPointId = SceneUtils.TilePosToIndex(startPos)
  local endPointId = SceneUtils.TilePosToIndex(endPos)
  local path = startPointId .. ";" .. endPointId
  local curWorldId = LuaEntry.Player:GetCurWorldId()
  if targetServerId == LuaEntry.Player:GetSelfServerId() then
    curWorldId = 0
  end
  local cardSkillUseInfoList = DataCenter.TacticalCardDataManager:PopFormationViewCardSkillUseCache()
  SFSNetwork.SendMessage(MsgDefines.WorldMarchChange, marchUuid, targetType, targetUuid, path, curWorldId, backHome, targetServerId, destroyTimeIndex, cardSkillUseInfoList)
end

function MarchUtil.GetAttackPos(startPos, endPos, attackOffsetRange)
  return endPos
end

function MarchUtil.GetCostStaminaByTargetType(type, rallyType, formationUuid, destroyTimes, isEmptyDesert)
  local cost = 0
  local isInDragon = BattleFieldUtil.InBattleField()
  if type == MarchTargetType.JOIN_RALLY then
    return 0
  end
  if isInDragon then
    return 0
  end
  local add = LuaEntry.Effect:GetGameEffect(EffectDefine.STAMINA_COST_ADD)
  if type == MarchTargetType.DIG_ICE_ENEMY or type == MarchTargetType.DIG_ICE_ALLY then
    return LuaEntry.DataConfig:TryGetNum("car_action_stamina", "k16", 5)
  elseif type == MarchTargetType.ATTACK_SANDWORM then
    return 10
  elseif type == MarchTargetType.RALLY_SANDWORM then
    return 20
  elseif type == MarchTargetType.RALLY_FOR_CITY or type == MarchTargetType.RALLY_EPIDEMIC_CITY or type == MarchTargetType.ATTACK_CITY or type == MarchTargetType.ATTACK_WINTER_STORM_CITY or type == MarchTargetType.ATTACK_EPIDEMIC_CITY then
    return LuaEntry.DataConfig:TryGetNum("car_action_stamina", "k1")
  elseif type == MarchTargetType.RALLY_FOR_BUILDING or type == MarchTargetType.ATTACK_BUILDING then
    return LuaEntry.DataConfig:TryGetNum("car_action_stamina", "k2")
  elseif type == MarchTargetType.ATTACK_MONSTER then
    local effect = LuaEntry.Effect:GetGameEffect(EffectDefine.STAMINA_COST_DEC)
    local base = LuaEntry.DataConfig:TryGetNum("car_action_stamina", "k4")
    local effect2 = 0
    if formationUuid ~= nil and formationUuid ~= 0 and type == MarchTargetType.ATTACK_MONSTER then
      local march = DataCenter.WorldMarchDataManager:GetOwnerFormationMarch(LuaEntry.Player.uid, formationUuid, LuaEntry.Player.allianceId)
      if march ~= nil and march.HasFightMonster ~= nil then
        local hasBuff = march:HasFightMonster()
        if hasBuff then
          effect2 = LuaEntry.Effect:GetGameEffect(EffectDefine.GAME_EFFECT_30224)
        end
      end
    end
    local realNum = math.floor(base * (1 - (effect + effect2 / 100)) + 0.5)
    return realNum
  elseif type == MarchTargetType.RALLY_FOR_BOSS then
    return LuaEntry.DataConfig:TryGetNum("car_action_stamina", "k5")
  elseif type == MarchTargetType.ATTACK_ROAD then
    return LuaEntry.DataConfig:TryGetNum("car_action_stamina", "k3")
  elseif type == MarchTargetType.EXPLORE then
    return LuaEntry.DataConfig:TryGetNum("car_action_stamina", "k7")
  elseif type == MarchTargetType.ATTACK_DESERT or type == MarchTargetType.ATTACK_EMPTY_DESERT then
    cost = math.floor(LuaEntry.DataConfig:TryGetNum("lw_season_energy_cost", "k1", 10) * (1 + add / 100) + 0.5)
    if isEmptyDesert or type == MarchTargetType.ATTACK_EMPTY_DESERT then
      local effect94035 = LuaEntry.Effect:GetGameEffect(EffectDefine.LW_SEASON_EFFECT_94035)
      if 0 < effect94035 then
        cost = math.max(0, cost - effect94035)
      end
    end
  elseif type == MarchTargetType.TRAIN_DESERT then
    cost = math.floor(LuaEntry.DataConfig:TryGetNum("lw_season_energy_cost", "k4", 10) * (1 + add / 100) + 0.5)
  elseif type == MarchTargetType.ASSISTANCE_DESERT then
    cost = math.floor(LuaEntry.DataConfig:TryGetNum("lw_season_energy_cost", "k2", 10) * (1 + add / 100) + 0.5)
  elseif type == MarchTargetType.SCOUT_DESERT then
    cost = math.floor(LuaEntry.DataConfig:TryGetNum("lw_season_energy_cost", "k3", 10) * (1 + add / 100) + 0.5)
  elseif type == MarchTargetType.ATTACK_ALLIANCE_BUILDING or type == MarchTargetType.ATTACK_CITY_STRONGHOLD then
    cost = math.floor(LuaEntry.DataConfig:TryGetNum("lw_season_energy_cost", "k5", 10) * (1 + add / 100) + 0.5)
  elseif type == MarchTargetType.RALLY_ALLIANCE_BUILDING or type == MarchTargetType.RALLY_CITY_STRONGHOLD then
    cost = math.floor(LuaEntry.DataConfig:TryGetNum("lw_season_energy_cost", "k6", 10) * (1 + add / 100) + 0.5)
  elseif type == MarchTargetType.SCOUT_ALLIANCE_BUILDING or type == MarchTargetType.SCOUT_CITY_STRONGHOLD then
    cost = math.floor(LuaEntry.DataConfig:TryGetNum("lw_season_energy_cost", "k7", 10) * (1 + add / 100) + 0.5)
  elseif type == MarchTargetType.ASSISTANCE_ALLIANCE_BUILDING or type == MarchTargetType.ASSISTANCE_CITY_STRONGHOLD then
    cost = math.floor(LuaEntry.DataConfig:TryGetNum("lw_season_energy_cost", "k8", 10) * (1 + add / 100) + 0.5)
  elseif type == MarchTargetType.ATTACK_ALLIANCE_CITY or type == MarchTargetType.ATTACK_THRONE then
    local perCost = LuaEntry.DataConfig:TryGetNum("car_action_stamina", "k6")
    if destroyTimes then
      if destroyTimes <= 1000 then
        return perCost * destroyTimes
      else
        return -1
      end
    else
      return perCost
    end
  elseif rallyType ~= nil and type == MarchTargetType.JOIN_RALLY and (rallyType == MarchTargetType.RALLY_FOR_CITY or rallyType == MarchTargetType.RALLY_EPIDEMIC_CITY) then
    return LuaEntry.DataConfig:TryGetNum("car_action_stamina", "k1")
  elseif rallyType ~= nil and type == MarchTargetType.JOIN_RALLY and rallyType == MarchTargetType.RALLY_FOR_BUILDING then
    return LuaEntry.DataConfig:TryGetNum("car_action_stamina", "k2")
  elseif rallyType ~= nil and type == MarchTargetType.JOIN_RALLY and rallyType == MarchTargetType.RALLY_FOR_ALLIANCE_CITY then
    return LuaEntry.DataConfig:TryGetNum("car_action_stamina", "k6")
  elseif rallyType ~= nil and type == MarchTargetType.JOIN_RALLY and rallyType == MarchTargetType.RALLY_CITY_STRONGHOLD then
    return LuaEntry.DataConfig:TryGetNum("car_action_stamina", "k6")
  elseif rallyType ~= nil and type == MarchTargetType.JOIN_RALLY and rallyType == MarchTargetType.RALLY_SERVER_THRONE_BUILDING then
    return LuaEntry.DataConfig:TryGetNum("car_action_stamina", "k6")
  elseif rallyType ~= nil and type == MarchTargetType.JOIN_RALLY and rallyType == MarchTargetType.RALLY_CENTER_THRONE then
    return LuaEntry.DataConfig:TryGetNum("car_action_stamina", "k6")
  elseif rallyType ~= nil and type == MarchTargetType.JOIN_RALLY and rallyType == MarchTargetType.RAINFOREST_THRONE_RALLY then
    return LuaEntry.DataConfig:TryGetNum("car_action_stamina", "k6")
  elseif type == MarchTargetType.RALLY_FOR_ALLIANCE_CITY then
    return LuaEntry.DataConfig:TryGetNum("car_action_stamina", "k6")
  elseif type == MarchTargetType.RALLY_THRONE or type == MarchTargetType.RAINFOREST_THRONE_RALLY then
    return LuaEntry.DataConfig:TryGetNum("car_action_stamina", "k6")
  elseif type == MarchTargetType.RALLY_SERVER_THRONE_BUILDING then
    return LuaEntry.DataConfig:TryGetNum("car_action_stamina", "k6")
  elseif type == MarchTargetType.RALLY_CENTER_THRONE then
    return LuaEntry.DataConfig:TryGetNum("car_action_stamina", "k6")
  elseif type == MarchTargetType.ATTACK_BEHEMOTH then
    return LuaEntry.DataConfig:TryGetNum("congress_config", "k5")
  elseif type == MarchTargetType.BuildingNuclearPowerPlant then
    return LuaEntry.DataConfig:TryGetNum("congress_config", "k3")
  elseif type == MarchTargetType.MONSTER_INVASION_BOSS then
    return LuaEntry.DataConfig:TryGetNum("car_action_stamina", "k17")
  elseif type == MarchTargetType.GREEN then
    return DataCenter.SeasonGreenManager.staminaCost
  elseif type == MarchTargetType.ATTACK_PLAYER_RUIN_BUILDING then
    return LuaEntry.DataConfig:TryGetNum("ruin_destruction", "k2")
  elseif type == MarchTargetType.ATTACK_CITY_TRADE then
    return LuaEntry.DataConfig:TryGetNum("car_action_stamina", "k6")
  elseif type == MarchTargetType.ATTACK_CITY_ALTAR then
    return LuaEntry.DataConfig:TryGetNum("car_action_stamina", "k6")
  elseif type == MarchTargetType.CROSS_BANK_ATTACK then
    return LuaEntry.DataConfig:TryGetNum("car_action_stamina", "k1")
  end
  return cost
end

function MarchUtil.GetCanAddHeroNum(curHeroList, formationIndex)
  local canAddNum = 0
  local maxNum = MarchUtil.GetMaxHeroValueByFormationIndex(formationIndex)
  local curHeroNum = table.count(curHeroList)
  if maxNum > curHeroNum then
    local allHeroes = DataCenter.HeroDataManager:GetAllHeroBySort()
    for k, v in pairs(allHeroes) do
      if curHeroList[v.uuid] == nil and v.state == ArmyFormationState.Free then
        canAddNum = canAddNum + 1
        return canAddNum
      end
    end
  end
  return canAddNum
end

function MarchUtil.GetFormationCollectSpeedAdd(heroList, resourceType)
  local value = 0
  local effectId = 0
  if resourceType == ResourceType.Oil then
    effectId = EffectDefine.GAS_COLLECT_SPEED_PERCENT
  elseif resourceType == ResourceType.Water then
    effectId = EffectDefine.WATER_COLLECT_SPEED_PERCENT
  elseif resourceType == ResourceType.Metal then
    effectId = EffectDefine.CRYSTAL_COLLECT_SPEED_PERCENT
  elseif resourceType == ResourceType.Food then
    effectId = EffectDefine.MONEY_COLLECT_SPEED_PERCENT
  end
  if effectId ~= 0 then
    value = LuaEntry.Effect:GetGameEffect(effectId)
    if heroList ~= nil then
      local mgr = DataCenter.HeroDataManager
      for k, v in pairs(heroList) do
        local heroData = mgr:GetHeroByUuid(k)
        if heroData ~= nil then
          value = value + heroData:GetEffectNum(effectId)
        end
      end
    end
  end
  return value
end

function MarchUtil.GetRestraintCampAndValue(heroIdList)
  local campList = {}
  local tbl_name = HeroUtils.GetHeroXmlName()
  for k, v in pairs(heroIdList) do
    local camp = GetTableData(tbl_name, v, "camp")
    if 0 <= camp then
      if campList[camp] ~= nil then
        campList[camp] = campList[camp] + 1
      else
        campList[camp] = 1
      end
    end
  end
  local campArr = {}
  for k, v in pairs(campList) do
    local param = {}
    param.camp = k
    param.num = v
    table.insert(campArr, param)
  end
  table.sort(campArr, function(a, b)
    return a.num > b.num
  end)
  local data = campArr[1]
  if data ~= nil and data.num >= 3 then
    data.addValue = 0
    local heroRestraintValue = LuaEntry.DataConfig:TryGetStr("battle_config", "k19")
    local arr = string.split(heroRestraintValue, ";")
    local index = data.num - 2
    if index <= #arr then
      data.addValue = tonumber(arr[index])
    end
    return data
  end
end

function MarchUtil.GetBaseHeroRestraintValue(leftHeroIdList, rightHeroIdList, leftEffectList, rightEffectList)
  local leftCampRestraintData = MarchUtil.GetRestraintCampAndValue(leftHeroIdList)
  local rightCampRestraintData = MarchUtil.GetRestraintCampAndValue(rightHeroIdList)
  if leftCampRestraintData ~= nil and rightCampRestraintData ~= nil then
    local leftRestraintCamp = HeroUtils.GetHeroRestraintType(leftCampRestraintData.camp)
    local rightRestraintCamp = HeroUtils.GetHeroRestraintType(rightCampRestraintData.camp)
    if leftRestraintCamp == rightCampRestraintData.camp then
      local oneData = {}
      oneData.isLeft = true
      oneData.leftCampRestraintData = leftCampRestraintData
      oneData.rightCampRestraintData = rightCampRestraintData
      local base = leftCampRestraintData.addValue
      local campEffectId = HeroUtils.GetHeroRestraintEffectType(leftCampRestraintData.camp)
      local campEffectNum = 0
      local playerEffectNum = 0
      if leftEffectList[campEffectId] ~= nil then
        campEffectNum = leftEffectList[campEffectId]
      end
      if leftEffectList[EffectDefine.APS_HERO_CAMP_COUNTER_INCR_PERCENT] ~= nil then
        playerEffectNum = leftEffectList[EffectDefine.APS_HERO_CAMP_COUNTER_INCR_PERCENT]
      end
      local realValue = base * (1 + (campEffectNum + playerEffectNum) / 100)
      oneData.value = realValue
      return oneData
    elseif rightRestraintCamp == leftCampRestraintData.camp then
      local oneData = {}
      oneData.isLeft = false
      oneData.leftCampRestraintData = leftCampRestraintData
      oneData.rightCampRestraintData = rightCampRestraintData
      local base = rightCampRestraintData.addValue
      local campEffectId = HeroUtils.GetHeroRestraintEffectType(rightCampRestraintData.camp)
      local campEffectNum = 0
      local playerEffectNum = 0
      if rightEffectList[campEffectId] ~= nil then
        campEffectNum = rightEffectList[campEffectId]
      end
      if rightEffectList[EffectDefine.APS_HERO_CAMP_COUNTER_INCR_PERCENT] ~= nil then
        playerEffectNum = rightEffectList[EffectDefine.APS_HERO_CAMP_COUNTER_INCR_PERCENT]
      end
      local realValue = base * (1 + (campEffectNum + playerEffectNum) / 100)
      oneData.value = realValue
      return oneData
    end
  end
end

function MarchUtil.GetFormationStartPos()
  return LuaEntry.Player:GetMainWorldPos()
end

function MarchUtil.OnAttackDragonBuild(selfMarchUuid, pointInfo, curStamina, isFormation)
  if LuaEntry.Player:GetCurWorldId() > 0 then
    local dragonInfo = DataCenter.ActDragonManager:GetCurGroup()
    local curTime = UITimeManager:GetInstance():GetServerTime()
    local canShow = false
    if dragonInfo ~= nil and dragonInfo.timeInfo ~= nil and dragonInfo.matchResult == 1 and dragonInfo.timeInfo.battleOpenTime ~= nil and curTime > dragonInfo.timeInfo.battleOpenTime and dragonInfo.timeInfo.endTime ~= nil and curTime < dragonInfo.timeInfo.endTime then
      canShow = true
    end
    if canShow == false then
      UIUtil.ShowTipsId(376128)
      return
    end
  end
  local backHome = MarchUtil.GetAutoBackHomeState(MarchTargetType.ATTACK_DRAGON_BUILDING)
  MarchUtil.TryStartMarch(selfMarchUuid, MarchTargetType.ATTACK_DRAGON_BUILDING, curStamina, isFormation, pointInfo.uuid, pointInfo.mainIndex, backHome, true)
end

function MarchUtil.OnAssistanceDragonBuild(selfMarchUuid, pointInfo, isFormation)
  if not DataCenter.BuildManager:HasBuilding(BuildingTypes.FUND_BUILD_ALLIANCE_CENTER) then
    UIUtil.ShowTipsId(390805)
    return
  end
  MarchUtil.TryStartMarch(selfMarchUuid, MarchTargetType.ASSISTANCE_DRAGON_BUILDING, nil, isFormation, pointInfo.uuid, pointInfo.mainIndex, 0, true)
end

function MarchUtil.OnAttackWinterEntity(selfMarchUuid, pointInfo, curStamina, isFormation)
  if LuaEntry.Player:GetCurWorldId() > 0 then
    local mr = DataCenter.ActWinterStormManager:GetMarchResult()
    local curTime = UITimeManager:GetInstance():GetServerSeconds()
    local canShow = false
    if mr ~= nil and mr.battleBeginTime ~= nil and curTime > mr.battleBeginTime and mr.battleEndTime ~= nil and curTime < mr.battleEndTime then
      canShow = true
    end
    if canShow == false then
      UIUtil.ShowTipsId(376128)
      return
    end
  end
  local backHome = MarchUtil.GetAutoBackHomeState(MarchTargetType.ATTACK_WINTER_ENTITY)
  MarchUtil.TryStartMarch(selfMarchUuid, MarchTargetType.ATTACK_WINTER_ENTITY, curStamina, isFormation, pointInfo.uuid, pointInfo.mainIndex, backHome, true)
end

function MarchUtil.OnAssistanceWinterEntity(selfMarchUuid, pointInfo, isFormation)
  if not DataCenter.BuildManager:HasBuilding(BuildingTypes.FUND_BUILD_ALLIANCE_CENTER) then
    UIUtil.ShowTipsId(390805)
    return
  end
  MarchUtil.TryStartMarch(selfMarchUuid, MarchTargetType.ASSISTANCE_WINTER_ENTITY, nil, isFormation, pointInfo.uuid, pointInfo.mainIndex, 0, true)
end

function MarchUtil.OnAttackBattleFieldBuild(selfMarchUuid, pointInfo, curStamina, isFormation, targetType)
  if LuaEntry.Player:GetCurWorldId() > 0 then
    local canShow = false
    if targetType == MarchTargetType.ATTACK_DRAGON_BUILDING then
      local dragonInfo = DataCenter.ActDragonManager:GetCurGroup()
      local curTime = UITimeManager:GetInstance():GetServerTime()
      if dragonInfo ~= nil and dragonInfo.timeInfo ~= nil and dragonInfo.matchResult == 1 and dragonInfo.timeInfo.battleOpenTime ~= nil and curTime > dragonInfo.timeInfo.battleOpenTime and dragonInfo.timeInfo.endTime ~= nil and curTime < dragonInfo.timeInfo.endTime then
        canShow = true
      end
    elseif targetType == MarchTargetType.ATTACK_WINTER_ENTITY then
      local mr = DataCenter.ActWinterStormManager:GetMarchResult()
      local curTime = UITimeManager:GetInstance():GetServerSeconds()
      if mr ~= nil and mr.battleBeginTime ~= nil and curTime > mr.battleBeginTime and mr.battleEndTime ~= nil and curTime < mr.battleEndTime then
        canShow = true
      end
    elseif targetType == MarchTargetType.ATTACK_EPIDEMIC_CITY and DataCenter.ActEpidemicZoneManager:BattleStartCheck() then
      canShow = true
    end
    if canShow == false then
      UIUtil.ShowTipsId(376128)
      return
    end
  end
  local staminaCost = MarchUtil.GetCostStaminaByTargetType(targetType)
  if curStamina < staminaCost then
    LWResourceLackUtil:GotoSpecialResLack(ResLackContextType.Energy)
    return
  end
  local targetUuid = pointInfo.uuid
  local backHome = MarchUtil.GetAutoBackHomeState(targetType)
  if isFormation ~= nil and isFormation == true then
    local formation = DataCenter.ArmyFormationDataManager:GetOneArmyInfoByUuid(selfMarchUuid)
    if formation ~= nil then
      local canAddNum = MarchUtil.GetCanAddHeroNum(formation:GetCurHeroes(), formation.index)
      if 0 < canAddNum then
        local show = Setting:GetPrivateInt("SHOW_ADD_HERO", 0)
        if show <= 0 then
          UIUtil.ShowSecondMessage(Localization:GetString("121006"), Localization:GetString("121007"), 1, 121008, "", function()
            local startPos = MarchUtil.GetFormationStartPos()
            UIManager:GetInstance():OpenWindow(UIWindowNames.UIFormationTableNew, selfMarchUuid, targetType, pointInfo.mainIndex, targetUuid, -1, backHome, startPos, nil, false)
          end, function(needSellConfirm)
            if needSellConfirm == false then
              Setting:SetPrivateInt("SHOW_ADD_HERO", 1)
            else
              Setting:SetPrivateInt("SHOW_ADD_HERO", 0)
            end
          end)
          return
        end
      end
      local k5 = LuaEntry.DataConfig:TryGetNum("res_lack", "k5")
      local heroUuid, targetHeroUuid = DataCenter.ArmyFormationDataManager:GetFormationHeroCanChangeHigherUuid(selfMarchUuid)
      if k5 >= DataCenter.BuildManager.MainLv and heroUuid ~= nil and heroUuid ~= 0 and targetHeroUuid ~= nil and targetHeroUuid ~= 0 then
        UIUtil.ShowMessage(Localization:GetString("104245"), 1, 121008, "", function()
          local startPos = MarchUtil.GetFormationStartPos()
          UIManager:GetInstance():OpenWindow(UIWindowNames.UIFormationTableNew, selfMarchUuid, targetType, pointInfo.mainIndex, targetUuid, -1, backHome, startPos, nil, false)
        end)
        return
      end
    end
    MarchUtil.SendCreateMarchMessage(selfMarchUuid, targetType, pointInfo.mainIndex, targetUuid, -1, backHome, true)
  else
    MarchUtil.StartMarch(targetType, pointInfo.mainIndex, targetUuid, -1, selfMarchUuid, 0, backHome)
  end
end

function MarchUtil.OnAssistanceBattleFieldBuild(selfMarchUuid, pointInfo, isFormation, targetType)
  if not DataCenter.BuildManager:HasBuilding(BuildingTypes.FUND_BUILD_ALLIANCE_CENTER) then
    UIUtil.ShowTipsId(390805)
    return
  end
  if isFormation ~= nil and isFormation == true then
    local formation = DataCenter.ArmyFormationDataManager:GetOneArmyInfoByUuid(selfMarchUuid)
    if formation ~= nil then
      local canAddNum = MarchUtil.GetCanAddHeroNum(formation:GetCurHeroes(), formation.index)
      if 0 < canAddNum then
        local show = Setting:GetPrivateInt("SHOW_ADD_HERO", 0)
        if show <= 0 then
          UIUtil.ShowSecondMessage(Localization:GetString("121006"), Localization:GetString("121007"), 1, 121008, "", function()
            local startPos = MarchUtil.GetFormationStartPos()
            UIManager:GetInstance():OpenWindow(UIWindowNames.UIFormationTableNew, selfMarchUuid, targetType, pointInfo.mainIndex, pointInfo.uuid, -1, 0, startPos, nil, false)
          end, function(needSellConfirm)
            if needSellConfirm == false then
              Setting:SetPrivateInt("SHOW_ADD_HERO", 1)
            else
              Setting:SetPrivateInt("SHOW_ADD_HERO", 0)
            end
          end)
          return
        end
      end
      local k5 = LuaEntry.DataConfig:TryGetNum("res_lack", "k5")
      local heroUuid, targetHeroUuid = DataCenter.ArmyFormationDataManager:GetFormationHeroCanChangeHigherUuid(selfMarchUuid)
      if k5 >= DataCenter.BuildManager.MainLv and heroUuid ~= nil and heroUuid ~= 0 and targetHeroUuid ~= nil and targetHeroUuid ~= 0 then
        UIUtil.ShowMessage(Localization:GetString("104245"), 1, 121008, "", function()
          local startPos = MarchUtil.GetFormationStartPos()
          UIManager:GetInstance():OpenWindow(UIWindowNames.UIFormationTableNew, selfMarchUuid, targetType, pointInfo.mainIndex, pointInfo.uuid, -1, 0, startPos, nil, false)
        end)
        return
      end
    end
    MarchUtil.SendCreateMarchMessage(selfMarchUuid, targetType, pointInfo.mainIndex, pointInfo.uuid, -1, 0, true)
  else
    MarchUtil.StartMarch(targetType, pointInfo.mainIndex, pointInfo.uuid, -1, selfMarchUuid)
  end
end

local function IsShow(uid, strList)
  for j = 1, #strList do
    if uid == tonumber(strList[j]) then
      return true
    end
  end
end

function MarchUtil.GetaLlarmList()
  local list = DataCenter.WorldMarchDataManager:GetTargetMinAlarm(false)
  local strList = string.split(CommonUtil.PlayerPrefsGetString("maskAlarmUids", ""), "|")
  local ret = {}
  for i = 1, #list do
    ret[i] = {
      march = list[i],
      isMask = IsShow(list[i].uuid, strList)
    }
  end
  return ret
end

function MarchUtil.GetDesertBattleAlarmList()
  local list = DeepCopy(DataCenter.WorldMarchDataManager:GetTargetMinAlarm(true))
  local strList = string.split(CommonUtil.PlayerPrefsGetString(SettingKeys.DESERT_BATTLE_MASK_ALARM_UID, ""), "|")
  local ret = {}
  for i = 1, #list do
    ret[i] = {
      march = list[i],
      isMask = IsShow(list[i].uuid, strList)
    }
  end
  return ret
end

function MarchUtil.IsWerewolf(marchInfo)
  return marchInfo and marchInfo.pic == WerewolfHead
end

function MarchUtil.GetSoldierData(armyInfo)
  if not armyInfo then
    return
  end
  local mgr = DataCenter.SoldierDataManager
  local soldiers = armyInfo.Soldiers
  local curNum = 0
  local soldierLv = {}
  local numByPos = {}
  local curPower = 0
  for k, v in pairs(soldiers) do
    local index = tonumber(v.armsId)
    local remainNum = v.total - v.lost
    curNum = curNum + remainNum
    local template = mgr:GetTemplate(v.type)
    local lv = template.lv
    local soldierPower = mgr:CalcSoldierPower(template, remainNum)
    curPower = curPower + soldierPower
    if soldierLv[lv] then
      soldierLv[lv].count = soldierLv[lv].count + remainNum
    else
      soldierLv[lv] = {
        lv = lv,
        count = remainNum,
        id = v.type
      }
    end
    if numByPos[index] then
      numByPos[index] = numByPos[index] + remainNum
    else
      numByPos[index] = remainNum
    end
  end
  return curNum, soldierLv, numByPos, curPower
end

function MarchUtil.CancelRallyByLeader(teamUuid)
  UIUtil.ShowMessage(Localization:GetString("110151"), 2, nil, nil, function()
    SFSNetwork.SendMessage(MsgDefines.AllianceWarCancel, teamUuid)
  end, nil, nil)
end

function MarchUtil.CancelRallyByMember(teamUuid, marchUuid)
  UIUtil.ShowMessage(Localization:GetString("Rally_kickout"), 2, nil, nil, function()
    if marchUuid ~= 0 and teamUuid ~= 0 then
      SFSNetwork.SendMessage(MsgDefines.AllianceWarRetreat, teamUuid, marchUuid)
    end
  end, nil, nil)
end

function MarchUtil.CalcMarchSpeedByConfig(targetType, uuid, fixedSoldierType, useLightWorkerMan)
  local ret = 0
  local configMgr = LocalController:instance()
  if configMgr:hasTable(TableName.LW_March_Type) and configMgr:hasTable(TableName.LW_March_Target_Type) then
    local base_speed = configMgr:getIntValue(TableName.LW_March_Target_Type, targetType, "base_speed", 0)
    local go_type = configMgr:getIntValue(TableName.LW_March_Target_Type, targetType, "go_type", 0)
    if go_type ~= nil and go_type ~= 0 then
      local config = LocalController:instance():tryGetLine(TableName.LW_March_Type, go_type)
      if config then
        if base_speed == 0 then
          base_speed = tonumber(config.base_speed)
        end
        local effect_number = tonumber(config.effect_number)
        if effect_number == nil or effect_number == 0 then
          ret = base_speed
        elseif base_speed ~= nil and effect_number ~= nil then
          ret = base_speed * (1 + DataCenter.ArmyFormationDataManager:GetEffectResult(uuid, effect_number, useLightWorkerMan))
        end
      else
        ret = base_speed
      end
    else
      ret = base_speed
    end
  end
  return ret
end

return ConstClass("MarchUtil", MarchUtil)
