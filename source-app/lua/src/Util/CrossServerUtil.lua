local CrossServerUtil = {}
local rapidjson = require("rapidjson")
local Localization = CS.GameEntry.Localization
local LastJumpToParam, LastMoverCityServerId

function CrossServerUtil.SyncDragonWorldData(serverId, worldId, worldType)
  BattleFieldUtil.UpdateBattleServerInfo(serverId, worldId, worldType)
  if not BattleFieldUtil.InBattleField() then
    SFSNetwork.SendMessage(MsgDefines.WorldFavoGet, serverId, worldId)
  end
  SFSNetwork.SendMessage(MsgDefines.GetAllianceWarList, serverId)
  DataCenter.WorldFavoDataManager:ClearAll()
  DataCenter.AllianceCityTipManager:RemoveAllAllianceCityTip()
  DataCenter.SurpriseBuildingTipManager:RemoveAllSurpriseBuildingTip()
  DataCenter.AllianceWarDataManager:CalculateMainUIRallyTipNum()
  BattleFieldUtil.CrossEnterReq(worldType)
  local world = CS.SceneManager.World
  if world then
    world:SetFirstViewRequestFlag(true)
    world.PointManager:SetBattleFieldFirst(true)
    world:UpdateViewRequest(true)
  end
  if worldId ~= nil and worldId ~= 0 then
    local mgr = CS.SeasonDataManager.Instance
    if mgr ~= nil then
      mgr:CleanNinePalacesData()
    end
    local skin = SeasonWorldSkinUtil.GetSkin(1)
    if skin then
      DataCenter.SeasonDataManager:SetViewServerSkinMeta(skin)
    end
  end
  EventManager:GetInstance():BroadcastDeferred(EventId.UpdateMainUIRallyTipRedPoint)
end

function CrossServerUtil.OnGotoDragonWorld(serverId, worldId, worldType, worldPos)
  if CrossServerUtil:GetIsCrossServer() then
    CS.WorldLeaveCrossServerMessage.Instance:SendRequest()
    CS.GameEntry.NetworkCross:RemoveConnect()
  else
    SFSNetwork.SendMessage(MsgDefines.LeaveWorld)
  end
  LuaEntry.Player:SetWorldType(worldType)
  LuaEntry.Player:SetWorldId(worldId)
  LuaEntry.Player:SetCrossServerId(serverId)
  local mapObj = BattleFieldUtil.GetMapObj(worldType)
  local world = CS.SceneManager.World
  if world and mapObj == nil then
    world:OnChangeServerRemove()
    if world.SetMapZoneActive ~= nil then
      world:SetMapZoneActive(false)
    end
    if world.RemoveBlackDesert ~= nil then
      world:RemoveBlackDesert()
    end
  end
  if world then
    local min, max, rotMin, rotMax, mapCfg = BattleFieldUtil.GetBattleFieldCameraParam(worldType)
    world:SetCameraMinHeight(min)
    world:SetCameraMaxHeight(max)
    world:SetCameraRotRange(true, Vector2.New(rotMin, rotMax))
    world:SetWorldSize(BattleFieldUtil.GetBattleFieldWorldSize(worldType))
    if mapCfg and mapCfg.troop_line_color then
      world:UpdateTroopLineColor(mapCfg.troop_line_color)
    else
      world:UpdateTroopLineColor("")
    end
  end
  if world and mapObj == nil and world.CreateDragonLandRange ~= nil then
    world:CreateDragonLandRange()
  end
  local mainUIView = UIManager:GetInstance():GetWindow(UIWindowNames.UIMain).View
  if mainUIView then
    mainUIView:SetActive(false)
  end
  local uiStr = BattleFieldUtil.GetMainUIName()
  if not string.IsNullOrEmpty(uiStr) and not UIManager:GetInstance():IsWindowOpen(uiStr) and worldPos ~= nil then
    UIManager:GetInstance():OpenWindow(uiStr, {
      anim = true,
      UIMainAnim = UIMainAnimType.AllHide
    }, function()
      SFSNetwork.SendMessage(MsgDefines.WorldGetMarchInfos, worldPos.x, worldPos.z)
    end)
  end
  EventManager:GetInstance():Broadcast(EventId.SetCityPeopleAndCarVisible, CityPeopleAndCarVisibleType.AllHide)
  EventManager:GetInstance():Broadcast(EventId.OnEnterCrossServer)
  EventManager:GetInstance():Broadcast(EventId.EnterDragonWorld)
  DataCenter.CityNpcManager:SetNpcVisible(false)
  CrossServerUtil.SyncDragonWorldData(serverId, worldId, worldType)
  CommonUtil.ClearGameBgMusicData()
  CommonUtil.PlayGameBgMusic()
end

function CrossServerUtil.OnBackSelfServerFromDragonWorld(sceneType)
  BattleFieldUtil.OnBackSelfServerFromBattleField()
  CS.GameEntry.NetworkCross:RemoveConnect()
  local world = CS.SceneManager.World
  if world then
    world:OnChangeServerRemove()
    if world.RemoveDragonLandRange ~= nil then
      world:RemoveDragonLandRange()
    end
    world:ResetCameraMinHeight()
    world:ResetCameraMaxHeight()
    world:SetCameraRotRange(false, Vector2.zero)
    if SeasonUtil.CurInNinePalacesMode() then
      world:SetWorldSize(3000)
    else
      world:SetWorldSize(1000)
    end
    if world.SetMapZoneActive ~= nil then
      world:SetMapZoneActive(true)
    end
    if world.InitBlackBlock ~= nil then
      world:InitBlackBlock()
    end
    world:UpdateTroopLineColor("")
  end
  DataCenter.SeasonDataManager:SetViewServerSkinMeta(nil)
  local uiStr = BattleFieldUtil.GetMainUIName()
  if not string.IsNullOrEmpty(uiStr) then
    UIManager:GetInstance():DestroyWindow(uiStr, {
      anim = true,
      UIMainAnim = UIMainAnimType.AllShow
    })
  end
  SFSNetwork.SendMessage(MsgDefines.WorldFavoGet, LuaEntry.Player:GetSelfServerId(), 0)
  EventManager:GetInstance():Broadcast(EventId.SetCityPeopleAndCarVisible, CityPeopleAndCarVisibleType.AllShow)
  EventManager:GetInstance():Broadcast(EventId.QuitDragonWorld)
  EventManager:GetInstance():Broadcast(EventId.OnQuitCrossServer)
  local mainUIView = UIManager:GetInstance():GetWindow(UIWindowNames.UIMain).View
  if mainUIView then
    mainUIView:SetActive(true)
    mainUIView:PlayAnim(UIMainAnimType.AllShow, true)
  end
  if 0 > LuaEntry.Player.world_main_pos then
    SFSNetwork.SendMessage(MsgDefines.MoveCityToWorld)
  end
  if 0 < LuaEntry.Player.VirusLayer then
    DataCenter.SeasonDataManager:AddCheckVirusTimer()
  end
  DataCenter.WorldAllianceCityDataManager:InitAllCityDataRequest()
  DataCenter.AllianceWarDataManager:CalculateMainUIRallyTipNum()
  EventManager:GetInstance():BroadcastDeferred(EventId.UpdateMainUIRallyTipRedPoint)
  DataCenter.CityNpcManager:SetNpcVisible(true)
  if world and sceneType ~= SceneType.City then
    world:SetFirstViewRequestFlag(true)
    world:UpdateViewRequest(true)
  end
  CommonUtil.ClearGameBgMusicData()
  CommonUtil.PlayGameBgMusic()
end

function CrossServerUtil.OnCrossServer(serverId)
  local isBigMapMode, curSameGroup, srcSameGroup, loginSameGroup = SeasonUtil.InSeasonBigMapMode(serverId)
  local withoutLeaveAndClean
  if isBigMapMode and curSameGroup then
    withoutLeaveAndClean = true
  elseif CrossServerUtil:GetIsCrossServer() then
    CS.WorldLeaveCrossServerMessage.Instance:SendRequest()
    CS.GameEntry.NetworkCross:RemoveConnect()
  else
    SFSNetwork.SendMessage(MsgDefines.LeaveWorld)
  end
  LuaEntry.Player:SendGetOtherServerInfo(serverId)
  LuaEntry.Player:SetCrossServerId(serverId)
  EventManager:GetInstance():Broadcast(EventId.SetCityPeopleAndCarVisible, CityPeopleAndCarVisibleType.AllHide)
  EventManager:GetInstance():Broadcast(EventId.OnEnterCrossServer)
  DataCenter.CityNpcManager:SetNpcVisible(false)
  DataCenter.WorldAllianceCityDataManager:UpdateAllCityDataRequest(nil, serverId)
  if not withoutLeaveAndClean then
    DataCenter.GovernmentManager:GetKingInfoByServerId(serverId)
    DataCenter.ActMeteoriteBattleManager:RequestMeteoriteWorldInfo()
    if SceneUtils.GetIsInWorld() then
      CS.SceneManager.World:OnChangeServerRemove()
      CS.SceneManager.World:CleanAllianceCacheData()
    end
    EventManager:GetInstance():Broadcast(EventId.ShowCrossServerTip)
    if isBigMapMode then
      SFSNetwork.SendMessage(MsgDefines.FetchWorldOccupyInfo, serverId)
    end
  end
  if SceneUtils.GetIsInWorld() then
    CS.SceneManager.World:SetFirstViewRequestFlag(true)
    CS.SceneManager.World:UpdateViewRequest(true)
  end
end

function CrossServerUtil.OnBackSelfServer()
  local loginServerId = LuaEntry.Player:GetSelfServerId()
  local serverId = LuaEntry.Player:GetCurServerId()
  if loginServerId ~= serverId then
    SFSNetwork.SendMessage(MsgDefines.LeaveWorld)
  end
  EventManager:GetInstance():Broadcast(EventId.CloseCrossDisconnectView)
  LuaEntry.Player:SetCrossServerId(-1)
  CS.GameEntry.NetworkCross:RemoveConnect()
  DataCenter.SeasonDataManager:SetViewServerSkinMeta(nil)
  CS.SceneManager.World:OnChangeServerRemove()
  EventManager:GetInstance():Broadcast(EventId.SetCityPeopleAndCarVisible, CityPeopleAndCarVisibleType.AllShow)
  EventManager:GetInstance():Broadcast(EventId.OnQuitCrossServer)
  DataCenter.WorldAllianceCityDataManager:InitAllCityDataRequest()
  DataCenter.CityNpcManager:SetNpcVisible(true)
  CS.SceneManager.World:SetFirstViewRequestFlag(true)
  CS.SceneManager.World:UpdateViewRequest(true)
  EventManager:GetInstance():Broadcast(EventId.ShowCrossServerTip)
  DataCenter.ActMeteoriteBattleManager:RequestMeteoriteWorldInfo()
  if SceneUtils.GetIsInWorld() then
    CS.SceneManager.World:CleanAllianceCacheData()
  end
end

function CrossServerUtil.OnEnterPve()
  if CrossServerUtil:GetIsCrossServer() then
    LuaEntry.Player:SetCrossServerId(-1)
    CS.GameEntry.NetworkCross:RemoveConnect()
  end
end

function CrossServerUtil:GetCanShowCrossSubway()
  if LuaEntry.Player:IsInAlliance() then
    local allianceActInfo = DataCenter.ActivityListDataManager:GetActivityDataById(EnumActivity.AllianceCompete.ActId)
    if allianceActInfo ~= nil then
      local eventInfo = allianceActInfo:GetEventInfo()
      if eventInfo ~= nil and eventInfo.isCrossFight and eventInfo.targetServerId ~= LuaEntry.Player:GetSelfServerId() then
        local curTime = UITimeManager:GetInstance():GetServerTime()
        local endTime = eventInfo.endTime
        if curTime < endTime then
          return true
        end
      end
    end
  end
  return false
end

function CrossServerUtil:IsInDragonServer()
  return BattleFieldUtil.InBattleField()
end

function CrossServerUtil:GetIsCrossServer(serverId)
  if serverId ~= nil and serverId ~= 0 then
    local loginServerId = LuaEntry.Player:GetSelfServerId()
    return loginServerId ~= serverId
  end
  return LuaEntry.Player:IsInSelfServer() == false
end

function CrossServerUtil:GetIsCrossServerNotDragonWorld()
  return not LuaEntry.Player:IsInSelfServer() and not BattleFieldUtil.InBattleField()
end

function CrossServerUtil:IsInOtherServer()
  return not LuaEntry.Player:IsInSourceServer()
end

function CrossServerUtil.SetLastJumpToParam(value)
  LastJumpToParam = value
end

function CrossServerUtil.GetLastJumpToParam()
  return LastJumpToParam
end

function CrossServerUtil.UpdateLastMoveCityServer(curServerId)
  LastMoverCityServerId = curServerId or LuaEntry.Player:GetCurServerId()
end

function CrossServerUtil.GetLastMoveCityServer()
  return LastMoverCityServerId
end

function CrossServerUtil.IsJumpToServerMode()
  if LuaEntry.Player:IsInSelfServer() or BattleFieldUtil.InBattleField() then
    LastJumpToParam = nil
    return false
  end
  local serverId = LuaEntry.Player:GetCurServerId()
  if LastJumpToParam and LastJumpToParam.type and LastJumpToParam.mode and LastJumpToParam.serverId == serverId then
    return true
  end
  return false
end

function CrossServerUtil.IsJumpToMeteoriteBattle()
  local meteoriteBattleServerID = DataCenter.ActMeteoriteBattleManager:GetMeteoriteServerId()
  if not meteoriteBattleServerID or meteoriteBattleServerID <= 0 then
    return false
  end
  if not LuaEntry.Player:IsInSelfServer() and LuaEntry.Player:GetCurServerId() == meteoriteBattleServerID then
    return true
  end
  return false
end

function CrossServerUtil.ShowMoveCityModel(bestPosIndex, jumpToParam, serverId)
  local isDragonWorld = BattleFieldUtil.InBattleField()
  if MoveCityUtil.EnterMoveCityMode(bestPosIndex, isDragonWorld, serverId, jumpToParam, PlaceBuildType.MoveCity) then
    LastJumpToParam = jumpToParam
    if CS.GameEntry.Data.Player.SetCrossFightSrcServerId ~= nil then
      CS.GameEntry.Data.Player:SetCrossFightSrcServerId(LuaEntry.Player:GetSourceServerId())
    end
  end
end

function CrossServerUtil.JumpToKingdomAround(serverId, type)
  if LuaEntry.Player:GetCurServerId() == serverId then
    GoToUtil.CloseAllWindows()
    local kingCityId, kingCityPosIndex = SeasonUtil.GetKingCityId(serverId)
    local v3 = SceneUtils.TileIndexToWorld(kingCityPosIndex, ForceChangeScene.World)
    GoToUtil.GotoWorldPos(v3, CS.SceneManager.World.InitZoom, nil, nil, serverId)
  else
    math.randomseed(SafeLocalOsTime())
    local x = math.random() > 0.5 and math.random(470, 490) or math.random(510, 530)
    local y = math.random() > 0.5 and math.random(470, 490) or math.random(510, 530)
    local pointId = SceneUtils.TileXYToIndex(x, y, ForceChangeScene.World)
    CrossServerUtil.JumpToServerByServerId(serverId, type, pointId)
  end
end

function CrossServerUtil.IsCrossMoveCD(needTip, _tryMoveTo)
  if BattleFieldUtil.InBattleField() then
    return false
  end
  local tryMoveTo = toInt(_tryMoveTo)
  if tryMoveTo == LuaEntry.Player:GetSourceServerId() or tryMoveTo == LuaEntry.Player:GetSelfServerId() then
    return false
  end
  if DataCenter.SeasonHunterManager:IsInBattle() and DataCenter.SeasonHunterManager:IsWarnServer(LuaEntry.Player:GetSelfServerId()) and not DataCenter.SeasonHunterManager:IsWarnServer(tryMoveTo) then
    return false
  end
  local now = UITimeManager:GetInstance():GetServerTime()
  local crossMoveCDEnd = DataCenter.LeagueMatchManager:GetCrossMoveCDEnd()
  if crossMoveCDEnd and now < crossMoveCDEnd then
    if needTip then
      local remainTime = crossMoveCDEnd - now
      UIUtil.ShowTips(Localization:GetString("world_tips_1001"))
    end
    return true
  end
  return false
end

function CrossServerUtil.GetCrossMoveCD()
  if BattleFieldUtil.InBattleField() then
    return -1
  end
  local now = UITimeManager:GetInstance():GetServerTime()
  local crossMoveCDEnd = DataCenter.LeagueMatchManager:GetCrossMoveCDEnd()
  if crossMoveCDEnd and now < crossMoveCDEnd then
    return crossMoveCDEnd - now, 300000
  end
  return -1
end

local function TryShowMoveCityModel(serverId, pointIndex, theCameraHeight, bestPosIndex, jumpToParam)
  local worldPos = SceneUtils.TileIndexToWorld(pointIndex, ForceChangeScene.World)
  GoToUtil.GotoWorldPos(worldPos, theCameraHeight, 0, function()
    CrossServerUtil.ShowMoveCityModel(bestPosIndex, jumpToParam, serverId)
  end, serverId)
end

function CrossServerUtil.JumpToServerByServerId(serverId, type, bestPosIndex, CameraHeight, openMoveCityUI)
  LuaEntry.Player:SendGetOtherServerInfo(serverId)
  local theCameraHeight = CameraHeight
  if theCameraHeight == nil then
    theCameraHeight = MoveCityCameraHeight
  end
  local loginServerId = LuaEntry.Player:GetSelfServerId()
  local isBigMapMode, curSameGroup, srcSameGroup, loginSameGroup = SeasonUtil.InSeasonBigMapMode(serverId)
  if loginServerId == serverId or isBigMapMode and loginSameGroup then
    GoToUtil.CloseAllWindows()
    local MainWorldPos = bestPosIndex or LuaEntry.Player:GetMainWorldPos()
    local onCompleteFunc
    if openMoveCityUI then
      function onCompleteFunc()
        if loginServerId == serverId then
          MoveCityUtil.TryMoveCity(MainWorldPos, nil, serverId)
        else
          MoveCityUtil.CrossServerMoveCity(serverId, MainWorldPos, type)
        end
      end
    end
    if 0 < MainWorldPos then
      local v3 = SceneUtils.TileIndexToWorld(MainWorldPos, ForceChangeScene.World)
      GoToUtil.GotoWorldPos(v3, theCameraHeight, nil, onCompleteFunc, serverId)
    else
      SceneUtils.ChangeToWorld(function()
        local pos = bestPosIndex or LuaEntry.Player:GetMainWorldPos()
        local v3 = SceneUtils.TileIndexToWorld(pos, ForceChangeScene.World)
        GoToUtil.GotoWorldPos(v3, theCameraHeight, nil, onCompleteFunc, serverId)
      end)
    end
  else
    if serverId == LuaEntry.Player:GetSourceServerId() or CrossServerUtil.IsCrossMoveCD(true, serverId) then
    end
    GoToUtil.CloseAllWindows()
    local jumpToParam = {
      serverId = serverId,
      type = type,
      mode = JumpServerMode.CrossServerMoveCity
    }
    local MainWorldPos = bestPosIndex or LuaEntry.Player:GetMainWorldPos()
    if MainWorldPos and 0 < MainWorldPos then
      TryShowMoveCityModel(serverId, MainWorldPos, theCameraHeight, bestPosIndex, jumpToParam)
    else
      do
        local curServerId = LuaEntry.Player:GetCurServerId()
        local kingCityId, kingCityPosIndex = SeasonUtil.GetKingCityId(curServerId)
        local v3 = SceneUtils.TileIndexToWorld(kingCityPosIndex, ForceChangeScene.World)
        GoToUtil.GotoWorldPos(v3, theCameraHeight, 0, function()
          TryShowMoveCityModel(serverId, LuaEntry.Player:GetMainWorldPos(), theCameraHeight, bestPosIndex, jumpToParam)
        end, curServerId)
      end
    end
  end
end

function CrossServerUtil:NeedIntercept(langId, serverId, isShowCommonMessageBar)
  if serverId and 0 < serverId then
    if LuaEntry.Player:GetCurServerId() == serverId then
      return false
    elseif langId then
      if isShowCommonMessageBar then
        UIUtil.ShowTipsId(langId)
      else
        EventManager:GetInstance():Broadcast(EventId.ShowCrossServerBubbleTips, langId)
      end
      return true
    else
      return true
    end
  elseif LuaEntry.Player:IsInSourceServer() then
    return false
  elseif langId then
    if isShowCommonMessageBar then
      UIUtil.ShowTipsId(langId)
    else
      EventManager:GetInstance():Broadcast(EventId.ShowCrossServerBubbleTips, langId)
    end
    return true
  else
    return true
  end
end

function CrossServerUtil:Prohibit(crossType, langKey)
end

function CrossServerUtil.BackToSrcServer(targetPointId, openMoveCityUI)
  EventManager:GetInstance():Broadcast(EventId.CloseCrossDisconnectView)
  if LuaEntry.Player:IsInSourceServer() and LuaEntry.Player:IsLoginSourceServer() then
    local pointId = targetPointId or LuaEntry.Player:GetMainWorldPos()
    local position = SceneUtils.TileIndexToWorld(pointId, ForceChangeScene.World)
    GoToUtil.GotoWorldPos(position, MoveCityCameraHeight, nil, function()
      GoToUtil.CloseAllWindows()
      CrossServerUtil.SetLastJumpToParam(nil)
      if openMoveCityUI then
        MoveCityUtil.TryMoveCity(pointId)
      end
    end, LuaEntry.Player:GetSourceServerId())
    return
  end
  local gotoPointIndex = targetPointId
  if targetPointId == nil or targetPointId == 0 then
    local markInfo = DataCenter.AllianceRallyPointDataManager:GetMyAllianceRallyPoint()
    if markInfo then
      gotoPointIndex = markInfo:GetPointIndex()
      if gotoPointIndex == 0 then
        gotoPointIndex = LuaEntry.Player:GetMainWorldPos()
        if gotoPointIndex == 0 then
          gotoPointIndex = nil
        end
      end
    end
  end
  CrossServerUtil.JumpToServerByServerId(LuaEntry.Player:GetSourceServerId(), MoveCrossServerType.BackToSrcServer, gotoPointIndex, nil, openMoveCityUI)
end

function CrossServerUtil.BackToRecommendRallyPoint()
  local markInfo = DataCenter.AllianceRallyPointDataManager:GetRecommendRallyPoint()
  if not markInfo then
    return
  end
  local targetServerId = markInfo.server
  local targetPointId = markInfo:GetPointIndex() or LuaEntry.Player:GetMainWorldPos()
  EventManager:GetInstance():Broadcast(EventId.CloseCrossDisconnectView)
  CrossServerUtil.JumpToServerByServerId(targetServerId, MoveCrossServerType.BackToSrcServer, targetPointId, nil, true)
end

function CrossServerUtil.CheckCrossServerWithWatchAndJoinType()
  local isInCrossServer = false
  local player = LuaEntry.Player
  if not player:IsInSourceServer() or player:GetCurServerId() ~= player:GetSelfServerId() then
    isInCrossServer = true
  end
  return isInCrossServer
end

function CrossServerUtil.GetCrossServerIsInSameSeason()
  return true
end

function CrossServerUtil.GetIsInBattleServerGroup(serverId)
  if LuaEntry.Player:IsInAlliance() then
    return DataCenter.SeasonDataManager:IsInBattleServerGroup(serverId)
  end
  return false
end

function CrossServerUtil.CheckCanUseInDeclareWarTarget()
  return false, "season_tips143"
end

local CrossServerEnableList
local CrossServerEnableListLastRequestTime = 0

function CrossServerUtil.SetCrossEnableList(dataList)
  CrossServerEnableList = dataList
  TileBubbleManager:GetInstance():OnCrossDataUpdate()
  EventManager:GetInstance():Broadcast(EventId.UPDATE_POINTS_DATA)
end

function CrossServerUtil.GetCrossEnableReason(serverId)
  local loginServerId = LuaEntry.Player:GetSelfServerId()
  local mySourceServerId = LuaEntry.Player:GetSourceServerId()
  if serverId == loginServerId or serverId == mySourceServerId then
    return CanCrossServerReason.Global
  end
  local theReason = CanCrossServerReason.Disable
  if CrossServerEnableList ~= nil then
    for reason, serverList in pairs(CrossServerEnableList) do
      if serverList then
        for _, s in ipairs(serverList) do
          if s == serverId then
            theReason = math.max(toInt(reason), theReason)
          end
        end
      end
    end
  end
  return theReason
end

function CrossServerUtil.TryGetCrossEnableServerList(fuckCD)
  local now = UITimeManager:GetInstance():GetServerTime()
  if fuckCD then
    CrossServerEnableListLastRequestTime = 0
  end
  if CrossServerEnableList == nil or 15000 < now - CrossServerEnableListLastRequestTime then
    SFSNetwork.SendMessage(MsgDefines.FetchCrossServerList)
    CrossServerEnableListLastRequestTime = now
  end
end

function CrossServerUtil.CleanCrossEnableList()
  CrossServerEnableList = nil
  CrossServerEnableListLastRequestTime = 0
end

function CrossServerUtil.LogCrossEnableList()
  if CrossServerEnableList == nil then
    Logger.LogInfo("CrossEnable is nil")
  else
    pcall(function()
      local json = rapidjson.encode(CrossServerEnableList)
      if json then
        Logger.LogInfo("CrossEnable is " .. json)
      else
        Logger.LogInfo("CrossEnable is empty")
      end
    end)
  end
end

function CrossServerUtil.BackToSrcServerAndDoSomething(targetPointId, callback)
  local serverId = LuaEntry.Player:GetSourceServerId()
  local worldPos = SceneUtils.TileIndexToWorld(targetPointId, ForceChangeScene.World, serverId)
  GoToUtil.GotoWorldPos(worldPos, CS.SceneManager.World.InitZoom, LookAtFocusTime, function()
    if callback then
      callback()
    end
  end, serverId)
end

return ConstClass("CrossServerUtil", CrossServerUtil)
