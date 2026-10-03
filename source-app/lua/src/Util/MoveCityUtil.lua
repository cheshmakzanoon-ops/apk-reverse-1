local MoveCityUtil = {}
local Localization = CS.GameEntry.Localization

local function MoveCityFromOtherToSource()
  local sourceServerId = LuaEntry.Player:GetSourceServerId()
  local crossType = SeasonUtil.InSeasonBigMapMode(sourceServerId) and MoveCrossServerType.BackToSrcServerBigMap or MoveCrossServerType.BackToSrcServer
  local free = LuaEntry.Player:CanFreeAllianceMove(MarkType.Alliance_rally)
  CrossServerUtil.SetLastJumpToParam({
    mode = JumpServerMode.CrossServerMoveCity,
    type = crossType,
    serverId = sourceServerId,
    cmd = MsgDefines.AllianceMoveCity,
    free = free
  })
  SFSNetwork.SendMessage(MsgDefines.MoveCrossServer, {
    serverId = sourceServerId,
    type = crossType,
    dstPoint = 0,
    useCrossItem = not free
  })
end

local function MoveCityFromOtherToRally()
  local otherData = DataCenter.AllianceRallyPointDataManager:GetMyAllianceRallyPoint(MarkType.Alliance_OtherServerRally)
  if not otherData then
    Logger.LogError("\229\164\150\230\156\141\232\191\129\229\159\142\229\164\177\232\180\165\239\188\129\229\164\150\230\156\141\233\155\134\231\187\147\231\130\185\228\184\141\229\173\152\229\156\168\239\188\129")
    return
  end
  local targetServerId = otherData.server
  local free = LuaEntry.Player:CanFreeAllianceMove(MarkType.Alliance_OtherServerRally)
  SFSNetwork.SendMessage(MsgDefines.MoveCrossServer, {
    serverId = targetServerId,
    type = MoveCrossServerType.OtherAllianceRallyPoint,
    dstPoint = 0,
    useCrossItem = not free
  })
end

function MoveCityUtil.TryAllianceMoveCity(costType, isInviteMove, pinMsgUUid)
  local otherData = DataCenter.AllianceRallyPointDataManager:GetMyAllianceRallyPoint(MarkType.Alliance_OtherServerRally)
  if otherData then
    local param = {
      costType = costType,
      isInviteMove = isInviteMove,
      pinMsgUUid = pinMsgUUid
    }
    UIManager:GetInstance():OpenWindow(UIWindowNames.UIChooseRallyPoint, {anim = true}, param)
  else
    MoveCityUtil.AllianceMoveCityToSourceRallyPoint(costType, isInviteMove, pinMsgUUid)
  end
end

function MoveCityUtil.AllianceMoveCityToSelectedRallyPoint(markType, costType, isInviteMove, pinMsgUUid)
  if markType == MarkType.Alliance_rally then
    MoveCityUtil.AllianceMoveCityToSourceRallyPoint(costType, isInviteMove, pinMsgUUid)
  elseif markType == MarkType.Alliance_OtherServerRally then
    MoveCityUtil.AllianceMoveCityToOtherRallyPoint(costType, isInviteMove, pinMsgUUid)
  end
end

function MoveCityUtil.AllianceMoveCityToRecommendRallyPoint(costType, isInviteMove, pinMsgUUid)
  local recommendType = DataCenter.AllianceRallyPointDataManager:GetRecommendType()
  MoveCityUtil.AllianceMoveCityToSelectedRallyPoint(recommendType, costType, isInviteMove, pinMsgUUid)
end

function MoveCityUtil.AllianceMoveCityToOtherRallyPoint(costType, isInviteMove, pinMsgUUid)
  if not LuaEntry.Player:IsInAlliance() then
    UIUtil.ShowTipsId("s5_allianceflag_tips05")
    return
  end
  local otherData = DataCenter.AllianceRallyPointDataManager:GetMyAllianceRallyPoint(MarkType.Alliance_OtherServerRally)
  if not otherData then
    Logger.LogError("\232\129\148\231\155\159\232\191\129\229\159\142\229\164\177\232\180\165\239\188\129\229\164\150\230\156\141\233\155\134\231\187\147\231\130\185\228\184\141\229\173\152\229\156\168\239\188\129")
    return
  end
  local rallyServerId = otherData.server
  local selfServerId = LuaEntry.Player:GetSelfServerId()
  if selfServerId ~= rallyServerId then
    if SceneUtils.GetIsInCity() then
      GoToUtil.CloseAllWindows()
      SceneUtils.ChangeToWorld(function()
        local bestPosIndex = otherData:GetPointIndex()
        if bestPosIndex <= 0 then
          bestPosIndex = LuaEntry.Player:GetMainWorldPos()
        end
        local v3 = SceneUtils.TileIndexToWorld(bestPosIndex, ForceChangeScene.World, rallyServerId)
        GoToUtil.GotoWorldPos(v3, MoveCityCameraHeight, nil, MoveCityFromOtherToRally, rallyServerId, 0, 0)
      end)
    else
      MoveCityFromOtherToRally()
    end
  else
    SFSNetwork.SendMessage(MsgDefines.AllianceMoveCity, costType, isInviteMove, pinMsgUUid)
    EventManager:GetInstance():Broadcast(EventId.SetMovingUI, UIMovingType.Open)
  end
end

function MoveCityUtil.AllianceMoveCityToSourceRallyPoint(costType, isInviteMove, pinMsgUUid)
  if not LuaEntry.Player:IsInAlliance() then
    UIUtil.ShowTipsId("s5_allianceflag_tips05")
    return
  end
  local sourceServerId = LuaEntry.Player:GetSourceServerId()
  local selfServerId = LuaEntry.Player:GetSelfServerId()
  if sourceServerId and 0 < sourceServerId and selfServerId and 0 < selfServerId and selfServerId ~= sourceServerId then
    if SceneUtils.GetIsInCity() then
      GoToUtil.CloseAllWindows()
      SceneUtils.ChangeToWorld(function()
        local bestPosIndex = LuaEntry.Player:GetMainWorldPos()
        local markInfo = DataCenter.AllianceRallyPointDataManager:GetMyAllianceRallyPoint()
        if markInfo and markInfo:GetPointIndex() ~= 0 then
          bestPosIndex = markInfo:GetPointIndex()
        end
        local v3 = SceneUtils.TileIndexToWorld(bestPosIndex, ForceChangeScene.World)
        GoToUtil.GotoWorldPos(v3, MoveCityCameraHeight, nil, MoveCityFromOtherToSource, sourceServerId, 0, 0)
      end)
    else
      MoveCityFromOtherToSource()
    end
  else
    SFSNetwork.SendMessage(MsgDefines.AllianceMoveCity, costType, isInviteMove, pinMsgUUid)
    EventManager:GetInstance():Broadcast(EventId.SetMovingUI, UIMovingType.Open)
  end
end

function MoveCityUtil.TryShowMoveCityModel(topType, targetServerId, targetPointIndex, force)
  if not force and CrossServerUtil:GetIsCrossServer() then
    UIUtil.ShowTipsId(500019)
    return false
  end
  local isDragonWorld = BattleFieldUtil.InBattleField()
  if SceneUtils.GetIsInWorld() then
    return MoveCityUtil.EnterMoveCityMode(targetPointIndex, isDragonWorld, targetServerId, nil, topType)
  else
    local theServerId = targetServerId
    local thePointIndex = targetPointIndex
    local theMoveType = topType
    local worldPos = SceneUtils.TileIndexToWorld(thePointIndex, ForceChangeScene.World)
    GoToUtil.GotoWorldPos(worldPos, CS.SceneManager.World.InitZoom, LookAtFocusTime, function()
      return MoveCityUtil.EnterMoveCityMode(thePointIndex, isDragonWorld, theServerId, nil, theMoveType)
    end, theServerId)
  end
  return true
end

function MoveCityUtil.CanMoveCity(theServerId)
  if BattleFieldUtil.InBattleField() then
    if BattleFieldUtil.BTestJump() then
      return true
    end
    if BattleFieldUtil.isObserve then
      return false
    end
    return true
  end
  local serverId = toInt(theServerId or LuaEntry.Player:GetCurServerId())
  local sourceServerId = LuaEntry.Player:GetSourceServerId()
  local selfServerId = LuaEntry.Player:GetSelfServerId()
  if serverId == sourceServerId or serverId == selfServerId then
    return true
  end
  if CrossServerUtil.GetCrossEnableReason(serverId) >= CanCrossServerReason.Global then
    return true
  end
  local isBigMapMode, curSameGroup, srcSameGroup, loginSameGroup = SeasonUtil.InSeasonBigMapMode(serverId)
  if isBigMapMode and (loginSameGroup or srcSameGroup) then
    return true
  end
  return false
end

function MoveCityUtil.TryGetMoveCityType(theServerId)
  local nServerId = toInt(theServerId)
  if LuaEntry.Player:GetSelfServerId() == nServerId or BattleFieldUtil.InBattleField() then
    return nil
  end
  if BattleFieldUtil.InMap(BattleFieldType.WinterStorm) then
    return nil
  end
  if LuaEntry.Player:GetSourceServerId() == nServerId then
    return MoveCrossServerType.BackToSrcServer
  end
  local reason = CrossServerUtil.GetCrossEnableReason(nServerId)
  if reason >= CanCrossServerReason.Global then
    if reason == CanCrossServerReason.Global then
      return MoveCrossServerType.BackToSrcServer
    end
    if reason == CanCrossServerReason.AllianceDuel then
      return MoveCrossServerType.AllianceDuel
    end
    if reason == CanCrossServerReason.CrossThrone then
      return MoveCrossServerType.CrossServerKingBattle
    end
    if reason == CanCrossServerReason.CrossInvasion then
      return MoveCrossServerType.SeasonBattleDesert
    end
    if reason == CanCrossServerReason.METEORITE then
      return MoveCrossServerType.MeteoriteBattleServer
    end
    if reason == CanCrossServerReason.LocalCross then
      return MoveCrossServerType.BigMap3000
    end
    if reason == CanCrossServerReason.CrossInvasionByAllianceRallyMark then
      return MoveCrossServerType.SeasonBattleDesert
    end
    if reason == CanCrossServerReason.ZWL_BATTLE then
      return MoveCrossServerType.LandlordToCenterServer
    end
  end
  return nil
end

function MoveCityUtil.OnClickMoveCity(serverId, pointId)
  local tryMoveToServerId = serverId
  local isDragonWorld = BattleFieldUtil.InBattleField()
  if isDragonWorld then
    return MoveCityUtil.TryMoveCity(pointId, nil, tryMoveToServerId)
  end
  local mySourceServerId = LuaEntry.Player:GetSourceServerId()
  local loginServerId = LuaEntry.Player:GetSelfServerId()
  local seasonInfo = SeasonUtil.GetSeasonInfo(tryMoveToServerId)
  local isInSeason = false
  local seasonType = SeasonMapType.Nothing
  if seasonInfo ~= nil then
    isInSeason = seasonInfo:ServerInReady() and seasonInfo:InNormalMode()
    seasonType = seasonInfo:GetServerType(false)
  end
  if isInSeason and seasonType == SeasonMapType.Darkness and DataCenter.SeasonHunterManager:IsInBattle() and not DataCenter.SeasonHunterManager:IsBattleServer(tryMoveToServerId) then
    UIUtil.ShowTipsId("season_s4_activity_1200011_tips08")
    return
  end
  if isInSeason and seasonType == SeasonMapType.Snow and DataCenter.TemperatureManager:IsMyBaseFrozen() then
    UIUtil.ShowTipsId("temperature_tips_1")
    return
  end
  if seasonType == SeasonMapType.NineNation then
    local isBigMapMode, curSameGroup, srcSameGroup, loginSameGroup = SeasonUtil.InSeasonBigMapMode(tryMoveToServerId)
    if isBigMapMode and (curSameGroup or srcSameGroup or loginSameGroup) then
      local theCrossServerReason = CrossServerUtil.GetCrossEnableReason(tryMoveToServerId)
      if (srcSameGroup or loginSameGroup) and seasonInfo ~= nil and tryMoveToServerId ~= loginServerId and tryMoveToServerId ~= mySourceServerId and theCrossServerReason < CanCrossServerReason.Global then
        local curTime = UITimeManager:GetInstance():GetServerTime()
        local mapIndex = seasonInfo:GetNinePalacesIndex(tryMoveToServerId)
        local YES, timeOpen = seasonInfo:CanMoveCityTo(mapIndex)
        if not YES and timeOpen ~= nil and timeOpen ~= 0 and curTime < timeOpen then
          local timeStr = UITimeManager:GetInstance():MilliSecondToFmtString(timeOpen - curTime)
          UIUtil.ShowTips(Localization:GetString("s5_cross_tips01", timeStr))
          return
        end
      end
      if tryMoveToServerId == loginServerId then
        return MoveCityUtil.EnterMoveCityMode(pointId, isDragonWorld, tryMoveToServerId)
      end
      return MoveCityUtil.CrossServerMoveCity(tryMoveToServerId, pointId, MoveCrossServerType.BigMap3000)
    else
      if CrossServerUtil.IsCrossMoveCD(true, tryMoveToServerId) then
      end
      return MoveCityUtil.CrossServerMoveCity(tryMoveToServerId, pointId, MoveCrossServerType.SeasonBattleDesert)
    end
  end
  if CrossServerUtil:GetIsCrossServer() then
    local SourceServerId = LuaEntry.Player:GetSourceServerId()
    local CurServerId = tryMoveToServerId or LuaEntry.Player:GetCurServerId()
    if CurServerId == SourceServerId or CrossServerUtil.IsCrossMoveCD(true, CurServerId) then
    end
    if CurServerId ~= SourceServerId and not SeasonUtil.IsInSeasonOrNotInSeasonResult() and UITimeManager:GetInstance():GetNowWeekdayIndex() == 6 then
      local serverTime = UITimeManager:GetInstance():GetServerTime()
      local data = UITimeManager:GetInstance():TimeStampToServerDate(serverTime)
      if data.hour == 0 and 0 <= data.min and data.min <= 4 then
        UIUtil.ShowTips(Localization:GetString("world_tip10008", 300 - data.min * 60 - data.sec))
        return
      end
    end
    local moveType = MoveCityUtil.TryGetMoveCityType(CurServerId)
    if moveType then
      if moveType == MoveCrossServerType.MeteoriteBattleServer then
        local _noti = DataCenter.ActMeteoriteBattleManager:CanCrossServer(CurServerId)
        if _noti then
          UIUtil.ShowTips(_noti)
          return
        end
      end
      if moveType == MoveCrossServerType.SeasonBattleDesert and DataCenter.SeasonHunterManager:IsInBattle() and not DataCenter.SeasonHunterManager:IsBattleServer(CurServerId) then
        UIUtil.ShowTipsId("season_s4_activity_1200011_tips08")
        return
      end
      MoveCityUtil.CrossServerMoveCity(CurServerId, pointId, moveType)
    elseif SeasonUtil.CurServerIsInSeason() then
      UIUtil.ShowTipsId("season_tips169")
    else
      UIUtil.ShowTipsId("104274")
    end
    return
  end
  return MoveCityUtil.TryMoveCity(pointId, nil, tryMoveToServerId)
end

function MoveCityUtil.CrossServerMoveCity(serverId, pointId, moveType)
  if MoveCityUtil.TryMoveCity(pointId, moveType, serverId) then
    CrossServerUtil.SetLastJumpToParam({
      mode = JumpServerMode.CrossServerMoveCity,
      type = moveType,
      serverId = serverId
    })
  end
end

function MoveCityUtil.TryMoveCity(pointId, moveType, tryMoveToServerId)
  local isBackHome = false
  local isDragonWorld = BattleFieldUtil.InBattleField()
  local isFreeMoveCity = false
  local isFreeMoveCityToMeteorite = false
  local needItemCount = 1
  if moveType ~= nil then
    isFreeMoveCity = true
  else
    if isDragonWorld then
      isFreeMoveCity = true
      needItemCount = 0
      local battleStart = true
      if BattleFieldUtil.BTestJump() then
        battleStart = true
      else
        local mgr = BattleFieldUtil.GetMgrActive()
        if mgr then
          battleStart = mgr:CheckBattleStart()
        end
      end
      if not battleStart then
        UIUtil.ShowTipsId(458254)
        return false
      end
      local data = BattleFieldUtil.CoolData()
      if not table.IsNullOrEmpty(data) then
        isFreeMoveCity = data.costCount == 0 or data.coolTime <= UITimeManager:GetInstance():GetServerTime()
        needItemCount = data.costCount or 1
      end
      if not isFreeMoveCity then
        UIUtil.ShowTipsId(458289)
        return false
      end
    end
    if DataCenter.ActMeteoriteBattleManager:TriggerFreeMoveCity(pointId) then
      isFreeMoveCityToMeteorite = true
    end
    if not LuaEntry.Player:AtHomeNow() then
      local curServerId = LuaEntry.Player:GetCurServerId()
      local sourceServerId = LuaEntry.Player:GetSourceServerId()
      if curServerId == sourceServerId then
        isBackHome = true
      end
    end
  end
  if isBackHome or isFreeMoveCity or isFreeMoveCityToMeteorite then
    return MoveCityUtil.EnterMoveCityMode(pointId, isDragonWorld, tryMoveToServerId)
  end
  if DataCenter.SeasonHunterManager:IsInBattle() then
    local isLearned = DataCenter.MasteryManager:GetUnlockedSkillTemplateByType(MasterySkill.WerewolfMoveCity)
    if isLearned then
      local cur, _, ts = DataCenter.MasteryManager:GetStorageSkillCount(isLearned.id)
      if 0 < cur then
        return MoveCityUtil.EnterMoveCityMode(pointId, isDragonWorld, tryMoveToServerId)
      else
        local now = UITimeManager:GetInstance():GetServerTime()
        local countdown = 0
        if ts then
          countdown = math.max(0, math.ceil((ts - now) / 1000))
        end
        UIUtil.ShowTips(Localization:GetString("season_mastery_s4_tips_16", countdown))
        return false
      end
    else
      UIUtil.ShowTipsId("season_mastery_s4_tips_11")
      return false
    end
  end
  local item = DataCenter.ItemData:GetItemById(SpecialItemId.ITEM_MOVE_CITY)
  if isFreeMoveCityToMeteorite or item and needItemCount <= item.count then
    return MoveCityUtil.EnterMoveCityMode(pointId, isDragonWorld, tryMoveToServerId)
  end
  if SceneUtils.IsInBlackOrYellowLand(pointId) then
    local haveBlackLandMCSkill = 0 < DataCenter.MasteryManager:GetStorageSkillCountByType(MasterySkill.BlackLandMoveCity)
    if haveBlackLandMCSkill then
      return MoveCityUtil.EnterMoveCityMode(pointId, isDragonWorld, tryMoveToServerId)
    end
  end
  local haveFreeMCSkill = 0 < DataCenter.MasteryManager:GetStorageSkillCountByType(MasterySkill.FreeMoveCity) or 0 < DataCenter.MasteryManager:GetStorageSkillCountByType(MasterySkill.SeniorFreeMoveCity)
  if haveFreeMCSkill then
    return MoveCityUtil.EnterMoveCityMode(pointId, isDragonWorld, tryMoveToServerId)
  end
  local haveGoods = item and needItemCount <= item.count
  if haveGoods then
    return MoveCityUtil.EnterMoveCityMode(pointId, isDragonWorld, tryMoveToServerId)
  end
  LWResourceLackUtil:GotoGoodsItemLack(SpecialItemId.ITEM_MOVE_CITY, needItemCount)
  return false
end

function MoveCityUtil.EnterMoveCityMode(pointId, isDragonWorld, tryMoveToServerId, jumpToParam, topType)
  local mainBuild
  if isDragonWorld then
    mainBuild = DataCenter.BuildManager:GetFunbuildByItemID(BuildingTypes.WORM_HOLE_CROSS)
  end
  if mainBuild == nil or mainBuild.uuid == nil then
    mainBuild = DataCenter.BuildManager:GetFunbuildByItemID(BuildingTypes.FUN_BUILD_MAIN)
  end
  if mainBuild ~= nil then
    local city = CS.SceneManager.World:GetWorldBuildingByUuid(mainBuild.uuid)
    if city ~= nil then
      city:SetMoveState(true)
    end
    local bestPosIndex = pointId or LuaEntry.Player:GetMainWorldPos()
    if jumpToParam == nil then
      jumpToParam = {
        mode = JumpServerMode.NormalMoveCity,
        serverId = tryMoveToServerId
      }
    end
    if topType == nil then
      topType = PlaceBuildType.MoveCity
    end
    local mainBuildModelPath = BuildingUtils.GetWorldBuildingModelName(BuildingTypes.FUN_BUILD_MAIN, DataCenter.BuildManager.MainLv)
    CS.SceneManager.World:UICreateBuildingModelPath(BuildingTypes.FUN_BUILD_MAIN, mainBuild.uuid, bestPosIndex, topType, mainBuildModelPath, nil, jumpToParam)
    return true
  end
  return false
end

return ConstClass("MoveCityUtil", MoveCityUtil)
