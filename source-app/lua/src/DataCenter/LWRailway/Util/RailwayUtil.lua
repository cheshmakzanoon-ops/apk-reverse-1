local RailwayUtil = {}
local Localization = CS.GameEntry.Localization
local ALLIANCE_MEMBER_LIMIT = 20
local rapidjson = require("rapidjson")

function RailwayUtil.OpenUITrainList(trainTab, trainUuid)
  DataCenter.LWTrainDataManager:TryGetTrainList()
  UIUtil.PlayCutSceneAnim(function()
    UIManager:GetInstance():OpenWindow(UIWindowNames.UILWTrainScene, {anim = true}, trainTab, trainUuid)
  end)
end

function RailwayUtil.CloseUITrainList()
  UIUtil.PlayCutSceneAnim(function()
    UIManager:GetInstance():DestroyWindow(UIWindowNames.UILWTrainScene)
  end)
end

function RailwayUtil.OpenUITrainPrepare(trainPrepare)
  local closed, closeEndTime = DataCenter.LWAllyStationDataManager:IsTrainClosed()
  if closed then
    local now = UITimeManager:GetInstance():GetServerTime()
    local str = UITimeManager:GetInstance():MilliSecondToFmtStringWithoutDay(closeEndTime - now)
    UIUtil.ShowTips(Localization:GetString("alliance_train_042", str))
    return
  end
  local trainData = DataCenter.LWAllyStationDataManager:GetTrainByPlatformId(1)
  if trainData then
    DataCenter.LWAllyStationDataManager:TryGetAllyStationData()
    local isNewTrainOn = DataCenter.LWAllyStationDataManager:IsNewTrainFunctionOn()
    if isNewTrainOn then
      UIUtil.PlayCutSceneAnim(function()
        DataCenter.LWTrainPrepareSceneManager:Enter(trainPrepare)
      end, function()
        return DataCenter.LWTrainPrepareSceneManager:CheckLoadingState()
      end)
    else
      UIUtil.PlayCutSceneAnim(function()
        UIManager:GetInstance():OpenWindow(UIWindowNames.UITrainPrepare, {anim = true}, trainPrepare)
      end)
    end
  end
end

function RailwayUtil.CloseUITrainPrepare()
  local isNewTrainOn = DataCenter.LWAllyStationDataManager:IsNewTrainFunctionOn()
  if isNewTrainOn then
    UIUtil.PlayCutSceneAnim(function()
      DataCenter.LWTrainPrepareSceneManager:Exit()
    end)
  else
    UIUtil.PlayCutSceneAnim(function()
      UIManager:GetInstance():DestroyWindow(UIWindowNames.UITrainPrepare)
    end)
  end
end

function RailwayUtil.OpenUIDriverInvite()
  UIManager:GetInstance():OpenWindow(UIWindowNames.UITrainDriverInvite, {anim = true})
end

function RailwayUtil.OpenUIBattleRecord(trainData)
  UIManager:GetInstance():OpenWindow(UIWindowNames.UITrainBattleRecord, {anim = true}, trainData)
end

function RailwayUtil.OpenUITruckDeparture(buildUuid)
  if not LuaEntry.DataConfig:CheckSwitch("train_cross_server") and not LuaEntry.Player:IsLoginSourceServer() then
    UIUtil.ShowTipsId(500020)
    return
  end
  UIManager:GetInstance():OpenWindow(UIWindowNames.UILWTrainDeparture, {anim = true}, buildUuid)
end

function RailwayUtil.ApplyArriveReward(trainData)
  if not LuaEntry.DataConfig:CheckSwitch("train_cross_server") and not LuaEntry.Player:IsLoginSourceServer() then
    UIUtil.ShowTipsId(500020)
    return
  end
  if not trainData then
    return
  end
  local state = DataCenter.LWMyStationDataManager:GetTruckStationStateByTrainData(trainData)
  if state == TruckStationState.Reward then
    DataCenter.LWMyStationDataManager:TryCollectReward(trainData.uuid)
  end
  UIManager:GetInstance():OpenWindow(UIWindowNames.UILWTrainDetail, {anim = false}, trainData)
end

function RailwayUtil.BuyAllyTrain()
  local closed, closeEndTime = DataCenter.LWAllyStationDataManager:IsTrainClosed()
  if closed then
    local now = UITimeManager:GetInstance():GetServerTime()
    local str = UITimeManager:GetInstance():MilliSecondToFmtStringWithoutDay(closeEndTime - now)
    UIUtil.ShowTips(Localization:GetString("alliance_train_042", str))
    return
  end
  local cur, max = DataCenter.LWAllyStationDataManager:BuyCount()
  if cur < max then
    local isNewTrainOn = DataCenter.LWAllyStationDataManager:IsNewTrainFunctionOn()
    if isNewTrainOn then
      UIManager:GetInstance():OpenWindow(UIWindowNames.UITrainBuyUR, {anim = true})
    else
      UIManager:GetInstance():OpenWindow(UIWindowNames.UITrainBuy, {anim = true})
    end
  else
    UIUtil.ShowTipsId(458619)
    Logger.Log("cur/max:" .. cur .. "/" .. max)
  end
end

function RailwayUtil.CheckCanBuyTrain()
  if not LuaEntry.Player:IsInAlliance() then
    return false
  end
  local baseData = DataCenter.AllianceBaseDataManager:GetAllianceBaseData()
  if baseData == nil then
    return false
  end
  if baseData.curMember < ALLIANCE_MEMBER_LIMIT then
    return false
  end
  if baseData.joinTime == nil then
    return false
  end
  if not LuaEntry.Player:IsLoginSourceServer() and not LuaEntry.DataConfig:CheckSwitch("train_cross_server_alliance") then
    return false
  end
  local skipLimit = DataCenter.LWAllyStationDataManager.skipJoinAllianceCD
  if skipLimit then
    return true
  end
  local now = UITimeManager:GetInstance():GetServerTime()
  if now - baseData.joinTime > 86400000 then
    return true
  end
end

function RailwayUtil.GetTrainMaxRobCount(trainData)
  if not trainData then
    return 0
  end
  if trainData.type == TrainType.Truck then
    if trainData.isSpecialURQuality then
      return 1
    end
    return DataCenter.LWMyStationDataManager:GET_MAX_LOOT_PER_TRUCK()
  end
  return trainData.maxLootPerTrain or 0
end

function RailwayUtil.ClickAttackTrain(trainData, isTruckQuickRob)
  if not trainData then
    return
  end
  local cur, max = DataCenter.LWMyStationDataManager:GetRobCount()
  if max <= cur then
    UIUtil.ShowTipsId(457589)
    return
  end
  if not RailwayUtil.CheckTrainInMatchServer(trainData.serverId) then
    UIUtil.ShowTipsId(458632)
    return
  end
  if trainData.type == TrainType.Truck then
    if trainData.marchInfo.robTimes >= DataCenter.LWMyStationDataManager:GET_MAX_LOOT_PER_TRUCK() then
      UIUtil.ShowTipsId(457567)
      return
    end
    if trainData.isSpecialURQuality and trainData.marchInfo.robTimes > 0 then
      UIUtil.ShowTipsId("truck_tips10008")
      return
    end
    local effectValue = trainData:GetEffectValue(EffectDefine.LW_TRAIN_FAILURE_COUNT_LIMIT)
    if 0 < effectValue then
      local failureCount = trainData:GetFailureCountByUuid(LuaEntry.Player.uid)
      if effectValue <= failureCount then
        UIUtil.ShowTipsId("trade_person_tips1013")
        return
      end
    end
    DataCenter.ZombieBattleManager:Destroy()
    DataCenter.LWBattleManager:Destroy()
    local param = {}
    param.type = PVEType.FakePVP
    param.enterType = PVEEnterType.TruckRob
    param.sceneId = 51
    param.extraData = {}
    param.extraData.trainData = trainData
    param.extraData.isTruckQuickRob = isTruckQuickRob
    DataCenter.LWBattleManager:Enter(param)
    DataCenter.LWMyStationDataManager:TryGetEnemyWeaponInfo(trainData.ownerId, trainData.serverId)
  elseif trainData.marchInfo.robTimes >= trainData.maxLootPerTrain then
    UIUtil.ShowTips(Localization:GetString("alliance_train_vip034", trainData.maxLootPerTrain))
  elseif UITimeManager:GetInstance():GetServerTime() < trainData.marchInfo.protectTime then
    local now = UITimeManager:GetInstance():GetServerTime()
    local time = UITimeManager:GetInstance():MilliSecondToFmtStringWithoutDay(trainData.marchInfo.protectTime - now)
    UIUtil.ShowTips(Localization:GetString(458584, time))
  else
    local list = DataCenter.ArmyFormationDataManager:GetCurFormationList()
    if list == nil or table.count(list) < 1 then
      UIUtil.ShowTips(Localization:GetString("alliance_train_tips01"))
      return
    end
    SFSNetwork.SendMessage(MsgDefines.AllianceTrainFormation, 1)
    local isNewTrainOn = DataCenter.LWAllyStationDataManager:IsNewTrainFunctionOn()
    if isNewTrainOn then
      DataCenter.LWKOFBattleManager:SetType(TypeKOF.Train)
      DataCenter.LWKOFBattleManager:SetIsQuickRob(isTruckQuickRob)
    else
      DataCenter.LW3V3Manager:SetType(Type3v3.Train)
    end
    local opponentData = {}
    opponentData.teams = {}
    for i, v in pairs(trainData.teamList) do
      opponentData.teams[i] = RailwayUtil.ParseTeamInfo(v)
    end
    local playerInfo = {}
    if trainData.vipInfo and trainData.vipInfo.vipType == TrainVipType.isBigBro then
      playerInfo.power = trainData.vipInfo.power or 0
      playerInfo.uid = trainData.vipInfo.vipId or 0
      playerInfo.pic = trainData.vipInfo.headPic or 0
      playerInfo.picver = trainData.vipInfo.headPicVer or 0
      playerInfo.headSkinId = trainData.vipInfo.headSkinId or 0
      playerInfo.headSkinET = trainData.vipInfo.headSkinET or 0
      playerInfo.name = trainData.vipInfo.name or 0
      playerInfo.abbr = trainData.vipInfo.abbr or 0
      playerInfo.serverId = trainData.serverId or 0
    else
      playerInfo.power = trainData.ownerPower or 0
      playerInfo.uid = trainData.ownerId or 0
      playerInfo.pic = trainData.pic or 0
      playerInfo.picver = trainData.picVer or 0
      playerInfo.headSkinId = trainData.headSkinId or 0
      playerInfo.headSkinET = trainData.headSkinET or 0
      playerInfo.name = trainData.name or 0
      playerInfo.abbr = trainData.abbr or 0
      playerInfo.serverId = trainData.serverId or 0
    end
    opponentData.playerInfo = playerInfo
    opponentData.trainData = trainData
    opponentData.power = trainData.power or 0
    opponentData.isTruckQuickRob = isTruckQuickRob
    local isNewTrainOn = DataCenter.LWAllyStationDataManager:IsNewTrainFunctionOn()
    if isNewTrainOn then
      DataCenter.LWKOFBattleManager:SetOpponentData(opponentData)
    else
      DataCenter.LW3V3Manager:SetOpponentData(opponentData)
    end
  end
end

function RailwayUtil.ParseTeamInfo(teamInfo)
  local info = ArenaArmyFormationInfo.New()
  info:ParseData(teamInfo)
  info.equipPower = teamInfo.equipPower
  info.power = teamInfo.power
  return info
end

function RailwayUtil.GetSoldierPowerByTeamInfo(teamInfo)
  local info = ArenaArmyFormationInfo.New()
  info:ParseData(teamInfo)
  return info:GetSoldiersCapacity()
end

function RailwayUtil.ClickTrainStation()
  if not LuaEntry.DataConfig:CheckSwitch("train_cross_server") and not LuaEntry.DataConfig:CheckSwitch("train_cross_server_alliance") and CrossServerUtil:NeedIntercept(500020) then
    return
  end
  local state, ts = DataCenter.LWMyStationDataManager:GetRailwayStationState()
  if state == RailwayStationState.Disable then
  elseif state == RailwayStationState.WarmUp then
    UIUtil.ShowMessage(Localization:GetString("457551"), 1, GameDialogDefine.CONFIRM, nil, nil, nil, nil, 457550, nil, nil, nil, nil, nil, ts, CS.UnityEngine.TextAnchor.UpperLeft)
  elseif state == RailwayStationState.Fog then
    UIUtil.ShowMessage(Localization:GetString("457553"), 1, GameDialogDefine.CONFIRM, nil, nil, nil, nil, 457552, nil, nil, nil, nil, nil, nil, CS.UnityEngine.TextAnchor.UpperLeft)
  elseif state == RailwayStationState.FirstReward then
    DataCenter.LWMyStationDataManager:TryCollectFirstReward()
  else
    RailwayUtil.OpenUITrainList(TrainTab.Enemy)
  end
end

function RailwayUtil.ClickCityTrain(page)
  local state, ts = DataCenter.LWMyStationDataManager:GetRailwayStationState()
  if state > RailwayStationState.FirstReward then
    if not LuaEntry.DataConfig:CheckSwitch("train_cross_server") and not LuaEntry.Player:IsLoginSourceServer() then
      UIUtil.ShowTipsId(500020)
      return
    end
    RailwayUtil.OpenUITrainPrepare(page)
  else
    RailwayUtil.ClickTrainStation()
  end
end

function RailwayUtil.ClickTruckStation(building)
  if not LuaEntry.DataConfig:CheckSwitch("train_cross_server") and CrossServerUtil:NeedIntercept(500020) then
    return
  end
  local state = DataCenter.LWMyStationDataManager:GetTruckStationState(building.uuid)
  if state == TruckStationState.Lock then
    local data = DataCenter.ActivityListDataManager:GetOneOpenActivityByType(EnumActivity.TruckActivity.Type)
    if data == nil then
      UIUtil.ShowTipsId("super_trucklaunch_tips10")
      return
    end
    local railwayState = DataCenter.LWMyStationDataManager:GetRailwayStationState()
    if railwayState > RailwayStationState.FirstReward then
      UIUtil.ShowTipsId(457563)
    end
  elseif state == TruckStationState.Ready then
    RailwayUtil.OpenUITruckDeparture(building.uuid)
  elseif state == TruckStationState.Travelling then
    RailwayUtil.OpenUITrainList(TrainTab.Mine, building.uuid)
  elseif state == TruckStationState.Reward then
    local trainData = DataCenter.LWMyStationDataManager:GetMyTrainByBuildUuid(building.uuid)
    RailwayUtil.ApplyArriveReward(trainData)
  end
end

function RailwayUtil.OpenTrainDefenceChangeUI(index)
  local trainData = DataCenter.LWAllyStationDataManager:GetTrainByPlatformId(1)
  if trainData:IAmBigBrotherVip() then
    RailwayUtil.OpenTrainQueue(index)
  else
    if trainData.vipInfo and trainData.vipInfo.vipType == TrainVipType.isBigBro and trainData.vipInfo.vipId ~= LuaEntry.Player.uid and trainData:IsMyTrain() then
      UIUtil.ShowTips(Localization:GetString("alliance_train_vip029"))
      return
    end
    if trainData:IsMyTrain() then
      RailwayUtil.OpenTrainQueue(index)
    end
  end
end

function RailwayUtil.OpenTrainQueue(index)
  local isNewTrainOn = DataCenter.LWAllyStationDataManager:IsNewTrainFunctionOn()
  if isNewTrainOn then
    DataCenter.LWKOFBattleManager:SetType(TypeKOF.Train)
    UIManager:GetInstance():OpenWindow(UIWindowNames.UIHeroPVPFormation, {anim = true}, EnterHeroSquadPanelWay.KOFDefence, index)
  else
    DataCenter.LW3V3Manager:SetType(Type3v3.Train)
    UIManager:GetInstance():OpenWindow(UIWindowNames.UIHeroPVPFormation, {anim = true}, EnterHeroSquadPanelWay.Arena3V3Defence, index)
  end
end

function RailwayUtil.OpenTrainInfoUI(trainData)
  UIManager:GetInstance():OpenWindow(UIWindowNames.UITrainInfo, {anim = true}, trainData)
end

function RailwayUtil.JumpToTrainByMarchUuid(marchUuid, serverId, worldId)
  if not SceneUtils.CheckCanGotoWorld() then
    return
  end
  if marchUuid and type(marchUuid) == "number" and 0 < marchUuid then
    SFSNetwork.SendMessage(MsgDefines.GetMarchPos, serverId, worldId, marchUuid, NewMarchType.TRAIN)
  else
    UIUtil.ShowTipsId("not departed yet!")
  end
end

function RailwayUtil.GetTrainPosition(trainData)
  local train = DataCenter.LWTrainManager:GetTrain(trainData.uuid)
  if train then
    return train:GetPosition()
  end
  local now = UITimeManager:GetInstance():GetServerTime()
  local worldPos = trainData:CalculateTransform(now)
  return worldPos
end

function RailwayUtil.ShowTrainActivityConstruction()
  local isNewTrainOn = DataCenter.LWAllyStationDataManager:IsNewTrainFunctionOn()
  if isNewTrainOn then
    local title = Localization:GetString("alliance_train_rules_title")
    local rightsOpenState = LuaEntry.DataConfig:CheckSwitch("alliance_train_vip")
    local content = ""
    if rightsOpenState then
      content = Localization:GetString("alliance_train_vip_rules")
    else
      content = Localization:GetString("alliance_train_rules")
    end
    UIUtil.ShowInfoPop(title, content)
    return
  end
  local dataList = DataCenter.ActivityListDataManager:GetActivityDataByType(EnumActivity.TrainActivity.Type)
  if dataList and dataList[1] and dataList[1].story ~= nil then
    local param = {}
    param.activityId = dataList[1].id
    param.activityRulesStr = Localization:GetString(dataList[1].story)
    UIManager:GetInstance():OpenWindow(UIWindowNames.UIActivityDetailPopup, {anim = true}, param)
  end
end

function RailwayUtil.ShareTrainByTrainData(trainData)
  if not trainData or not trainData.uuid then
    return
  end
  local share_param = {}
  share_param.sid = trainData.serverId
  share_param.pos = SceneUtils.WorldToTileIndex(RailwayUtil.GetTrainPosition(trainData), ForceChangeScene.World)
  share_param.oname = 457592
  share_param.onameParam1 = trainData:GetAbbrAndRealName()
  share_param.onameParam2 = trainData:GetQualityString()
  share_param.postType = trainData.type == TrainType.Train and PostType.Train or PostType.March
  local marchUuid = trainData.marchUid
  local marchInfo = CS.SceneManager.World:GetMarch(marchUuid)
  local worldId = 0
  if marchInfo ~= nil then
    worldId = marchInfo.worldId
  end
  share_param.quality = trainData.quality
  share_param.marchUuid = marchUuid
  share_param.worldId = worldId
  share_param.serverId = trainData.serverId
  share_param.marchType = NewMarchType.TRAIN
  if trainData.type == TrainType.Truck and trainData.isSpecialURQuality then
    share_param.specialIconPath = trainData.meta.share_icon
  end
  if trainData.type == TrainType.Train then
    share_param.level = trainData.ownerLv
    share_param.uid = trainData.ownerId
    share_param.headPic = trainData.pic
    share_param.headPicVer = trainData.picVer
    share_param.headSkinId = trainData.headSkinId
    share_param.headSkinET = trainData.headSkinET
    share_param.abbr = trainData.abbr
    share_param.name = trainData.name
    share_param.completeness = trainData.completeness
    share_param.ownerPower = trainData.ownerPower
    share_param.isUR = trainData:IsUR()
  end
  UIManager:GetInstance():OpenWindow(UIWindowNames.UIPositionShare, {anim = true}, share_param)
end

function RailwayUtil.CheckTrainInMatchServer(serverId)
  return DataCenter.LWMyStationDataManager:CheckTrainInMatchServer(serverId)
end

function RailwayUtil.UIMainBLBtnTrainCheckEnable()
  if DataCenter.LWAllyStationDataManager:IsTrainFunctionLock() then
    return false, false
  end
  local closed, closeEndTime = DataCenter.LWAllyStationDataManager:IsTrainClosed()
  if closed then
    return false, false
  end
  local trainData = DataCenter.LWAllyStationDataManager:GetTrainByPlatformId(1)
  if trainData then
    if string.IsNullOrEmpty(trainData.ownerId) then
      if DataCenter.AllianceBaseDataManager:IsR4orR5() then
        local key = "TRAIN_HAVE_SEEN_BUBBLE"
        local trainUuid = CommonUtil.PlayerPrefsGetLong(key, 0)
        local showBubble = trainUuid ~= trainData.uuid
        local bubbleMsg
        if showBubble then
          bubbleMsg = Localization:GetString("458509")
        end
        return true, showBubble, bubbleMsg
      end
    elseif trainData:IsMyTrain() then
      local key = "TRAIN_DRIVER_HAVE_SEEN_BUBBLE"
      local trainUuid = CommonUtil.PlayerPrefsGetLong(key, 0)
      if trainData.uuid ~= trainUuid and trainData.buyFlag == 0 then
        return true, false, nil, true
      end
    elseif trainData:IAmVip() then
      return false, false
    else
      local platformData = DataCenter.LWAllyStationDataManager:GetPlatform(1)
      if platformData.state == TrainPlatformState.TrainWithDriver and not platformData:MeInQueue() then
        local key = "TRAIN_PASSENGER_HAVE_SEEN_BUBBLE"
        local trainUuid = CommonUtil.PlayerPrefsGetLong(key, 0)
        local showBubble = trainUuid ~= trainData.uuid
        local bubbleMsg
        if showBubble then
          bubbleMsg = Localization:GetString("alliance_train_025", trainData.name or "")
        end
        return true, showBubble, bubbleMsg
      end
    end
  end
  return false, false
end

function RailwayUtil.TryHideUIMainBtnTrainBubble()
  if DataCenter.LWAllyStationDataManager:IsTrainFunctionLock() then
    return
  end
  local closed, _ = DataCenter.LWAllyStationDataManager:IsTrainClosed()
  if closed then
    return
  end
  local trainData = DataCenter.LWAllyStationDataManager:GetTrainByPlatformId(1)
  if trainData then
    if string.IsNullOrEmpty(trainData.ownerId) then
      if DataCenter.AllianceBaseDataManager:IsR4orR5() then
        local key = "TRAIN_HAVE_SEEN_BUBBLE"
        CommonUtil.PlayerPrefsSetLong(key, trainData.uuid)
      end
    elseif trainData:IsMyTrain() then
    else
      local platformData = DataCenter.LWAllyStationDataManager:GetPlatform(1)
      if platformData.state == TrainPlatformState.TrainWithDriver and not platformData:MeInQueue() then
        local key = "TRAIN_PASSENGER_HAVE_SEEN_BUBBLE"
        CommonUtil.PlayerPrefsSetLong(key, trainData.uuid)
      end
    end
  end
end

function RailwayUtil.GetAllianceTrainBattleRecord(trainData)
  if trainData.newAllianceTrain then
    SFSNetwork.SendMessage(MsgDefines.AllianceTrainKOFBattleRecord, trainData.uuid)
  else
    SFSNetwork.SendMessage(MsgDefines.AllianceTrainBattleRecord, trainData.uuid)
  end
end

function RailwayUtil.JumpToTrainByTrainData(trainData)
  if not trainData then
    return nil
  end
  local marchUuid = trainData.marchUid
  local now = UITimeManager:GetInstance():GetServerTime()
  local pos = trainData:CalculateTransform(now)
  UIManager:GetInstance():DestroyWindowByLayer(UILayer.Normal)
  UIManager:GetInstance():DestroyWindowByLayer(UILayer.Background)
  GoToUtil.GotoWorldPos(pos, nil, 0, function()
    TimerManager:GetInstance():DelayInvoke(function()
      UIUtil.OnClickWorldTroop(marchUuid)
    end, 0.5)
  end, trainData.serverId)
  return pos, now
end

function RailwayUtil.IsUR(cfgId)
  return cfgId == 152
end

local TradeStataionPointData = require("DataCenter.AllianceCityTip.Season.TradeStation.TradeStataionPointData")

function RailwayUtil.OnClickTradeStationBattleDetailBtn(pointId)
  local data = RailwayUtil.GetTradeStationPointData(pointId)
  if data and data:GetTimeState() == AllianceCityShowTimeState.TradeBattle then
    UIManager:GetInstance():OpenWindow(UIWindowNames.LWTradeStationBattleList, {anim = true}, data)
  end
end

function RailwayUtil.GetTradeStationPointData(pointId)
  local pointInfo = CS.SceneManager.World:GetPointInfo(pointId)
  if pointInfo then
    local extraInfo = SeasonUtil.TryParseAllianceCityPointInfo(pointInfo.PointType, pointInfo.extraInfo, pointInfo)
    local data = TradeStataionPointData.New()
    data:ParseData(extraInfo, pointInfo.serverId)
    return data
  end
end

function RailwayUtil.TryOpenHSRRob()
  UIManager:GetInstance():OpenWindow(UIWindowNames.UIHSRRob, {anim = true})
end

function RailwayUtil.ClickAttackHSR(victimData)
  local cur = DataCenter.HSRDataManager:GetRobCount()
  if cur <= 0 then
    UIUtil.ShowTipsId(457589)
    return
  end
  DataCenter.ZombieBattleManager:Destroy()
  DataCenter.LWBattleManager:Destroy()
  local param = {}
  param.type = PVEType.FakePVP
  param.enterType = PVEEnterType.HSRRob
  param.sceneId = 51
  param.victim = victimData
  DataCenter.LWBattleManager:Enter(param)
end

function RailwayUtil.TryOpenHSRMain()
  UIManager:GetInstance():OpenWindow(UIWindowNames.UIHSRMain, {anim = true})
end

function RailwayUtil.JumpToHSR()
  local activityData = DataCenter.HSRDataManager:GetActivityData()
  if not activityData then
    return
  end
  local uuid = activityData.uuid
  local worldPos = DataCenter.HSRDataManager:GetCurPosition()
  if not worldPos then
    return
  end
  UIManager:GetInstance():DestroyWindowByLayer(UILayer.Normal)
  UIManager:GetInstance():DestroyWindowByLayer(UILayer.Background)
  local serverId = DataCenter.SeasonDataManager:GetNinePalacesServerByWorldPos(worldPos, ServerEnum.Source)
  GoToUtil.GotoWorldPos(worldPos, nil, 0, function()
    TimerManager:GetInstance():DelayInvoke(function()
      UIUtil.OnClickWorldTroop(uuid)
    end, 0.5)
  end, serverId)
  return worldPos
end

function RailwayUtil.HandleDepartureTrain(message)
  if message.errorCode ~= nil then
    if message.uuid then
      UIUtil.ShowTipsId("truck_tips10007")
      local trainData = DataCenter.LWMyStationDataManager:GetMyTruckByUuid(message.uuid)
      if trainData then
        trainData.squadNoClient = 0
      end
    else
      UIUtil.ShowTipsId(message.errorCode)
    end
    return
  end
  DataCenter.LWMyStationDataManager:OnMyTrainDeparture(message)
end

function RailwayUtil.HandleDepartureTrainList(message)
  EventManager:GetInstance():Broadcast(EventId.BatchDepartureTrainCallback)
  if message.errorCode ~= nil then
    local allTrucks = DataCenter.LWMyStationDataManager:GetMyTrains()
    for truckIndex, truckData in pairs(allTrucks) do
      if truckData then
        local truckState = truckData:GetTrainState()
        if truckState == TrainState.BeforeDeparture then
          truckData.squadNoClient = 0
        end
      end
    end
    UIUtil.ShowTipsId(message.errorCode)
  end
  if message.errorTrainList ~= nil then
    local errorTrainList = message.errorTrainList
    for _, errorInfo in pairs(errorTrainList) do
      if errorInfo.uuid then
        UIUtil.ShowTipsId("truck_tips10007")
        local trainData = DataCenter.LWMyStationDataManager:GetMyTruckByUuid(errorInfo.uuid)
        if trainData then
          trainData.squadNoClient = 0
        end
      elseif errorInfo.errorCode then
        UIUtil.ShowTipsId(errorInfo.errorCode)
      end
    end
  end
  DataCenter.LWMyStationDataManager:OnMyTrainDepartureList(message)
end

local HSR_MAIL_SEARCH_RANGE = 10

function RailwayUtil.JumpToHSRMailDetail(hsrUuid)
  DataCenter.MailDataManager:GetMailInfosByTypeInDB(MailType.ZONE_TRAIN_TRADE_SETTLE, HSR_MAIL_SEARCH_RANGE, function(mailInfos)
    if mailInfos then
      for _, v in pairs(mailInfos) do
        local contents = rapidjson.decode(v.contents)
        local param = contents.b.content.dialog.params[5]
        local uuid = param and param.text
        if uuid and tonumber(uuid) == hsrUuid then
          UIManager:GetInstance():OpenWindow(UIWindowNames.UILWMailMain, {anim = false}, UIMailOpenType.Detail, v.uid)
          return
        end
      end
    end
    UIUtil.ShowTipsId(310112)
  end)
end

function RailwayUtil.CheckHSRMailExistAndHasReward(hsrUuid, callback)
  if not hsrUuid or not callback then
    Logger.LogError("RailwayUtil.CheckHaveHSRMail hsrUuid or callback is nil")
    return
  end
  DataCenter.MailDataManager:GetMailInfosByTypeInDB(MailType.ZONE_TRAIN_TRADE_SETTLE, HSR_MAIL_SEARCH_RANGE, function(mailInfos)
    if mailInfos then
      for _, v in pairs(mailInfos) do
        if v.rewardStatus == 0 then
          local contents = rapidjson.decode(v.contents)
          local param = contents.b.content.dialog.params[5]
          local uuid = param and param.text
          if uuid and tonumber(uuid) == hsrUuid then
            callback(v.uid)
            return
          end
        end
      end
    end
    callback(false)
  end)
end

function RailwayUtil.IsOpenSuperTruckDeparture()
  local isFunctionOn = LuaEntry.DataConfig:CheckSwitch("super_truck_launch")
  local vipIsActive = false
  local vipData = DataCenter.VIPManager:GetVipData()
  if vipData then
    vipIsActive = vipData:IsVIPActive()
  end
  local effectValue = LuaEntry.Effect:GetGameEffect(EffectDefine.Truck_Super_Departure_50248) or 0
  if isFunctionOn and 0 < effectValue and vipIsActive then
    return true
  end
  return false
end

return ConstClass("RailwayUtil", RailwayUtil)
