local Localization = CS.GameEntry.Localization
local WorldBattleUtil = {}
local worldAssistanceSwitch

function WorldBattleUtil.EnableShowWorldAssistanceInfo()
  if worldAssistanceSwitch == nil then
    worldAssistanceSwitch = LuaEntry.DataConfig:CheckSwitch("garrison_beta")
  end
  return worldAssistanceSwitch
end

function WorldBattleUtil.EnableNewTroopLine()
  return LuaEntry.DataConfig:CheckSwitch("new_troop_line_enable")
end

function WorldBattleUtil.TrySendAssistanceMarch(data, canMultiAssistance)
  local uuid = data.uuid
  local playerUid = data.playerUid
  local pointId = data.pointId
  local asType = data.asType
  local isThroneCity = data.isThroneCity
  local isCrossServerThrone = data.isCrossServerThrone
  local focusInfo = DataCenter.FormationAssistanceDataManager:GetFocusedPointAssistanceInfo(pointId)
  if focusInfo then
    if focusInfo.my and not canMultiAssistance then
      UIUtil.ShowTipsId(121219)
      return
    elseif focusInfo.full then
      UIUtil.ShowTipsId(120738)
      return
    end
  end
  if asType == AssistanceType.MainCity then
    local marchTargetType = MarchTargetType.ASSISTANCE_CITY
    if BattleFieldUtil.InBattleField(BattleFieldType.WinterStorm) then
      marchTargetType = MarchTargetType.ASSISTANCE_WINTER_STORM_CITY
    elseif BattleFieldUtil.InBattleField(BattleFieldType.EpidemicZone) or BattleFieldUtil.InBattleField(BattleFieldType.DsbDuel) then
      marchTargetType = MarchTargetType.ASSISTANCE_EPIDEMIC_CITY
    end
    MarchUtil.OnClickStartMarch(marchTargetType, pointId, uuid)
  elseif asType == AssistanceType.Build then
    MarchUtil.OnClickStartMarch(MarchTargetType.ASSISTANCE_BUILD, pointId, uuid)
  elseif asType == AssistanceType.AllianceCity then
    local targetType = MarchTargetType.ASSISTANCE_ALLIANCE_CITY
    if isThroneCity then
      targetType = MarchTargetType.ASSISTANCE_THRONE
    end
    if isCrossServerThrone then
      if data.seasonType == SeasonMapType.NineNationRainforest then
        if data.cityId == 1103 then
          targetType = MarchTargetType.ASSISTANCE_CENTER_THRONE
        else
          targetType = MarchTargetType.RAINFOREST_THRONE_ASSISTANCE
        end
      elseif SeasonUtil.IsNineNationKingMember() then
        if not LuaEntry.Player:IsInSelfServer() then
          UIUtil.ShowTipsId("season_tips143")
          return
        end
        targetType = MarchTargetType.ASSISTANCE_CENTER_THRONE
      else
        targetType = MarchTargetType.ASSISTANCE_SERVER_THRONE_BUILDING
      end
    end
    MarchUtil.OnClickStartMarch(targetType, pointId, uuid)
  elseif asType == AssistanceType.CityStronghold then
    MarchUtil.OnClickStartMarch(MarchTargetType.ASSISTANCE_CITY_STRONGHOLD, pointId, uuid)
  elseif asType == AssistanceType.AllianceBuild then
    MarchUtil.OnClickStartMarch(MarchTargetType.ASSISTANCE_ALLIANCE_BUILDING, pointId, uuid)
  elseif asType == AssistanceType.Desert then
    MarchUtil.OnClickStartMarch(MarchTargetType.ASSISTANCE_DESERT, pointId, uuid)
  elseif asType == AssistanceType.DragonBuild then
    MarchUtil.OnClickStartMarch(MarchTargetType.ASSISTANCE_DRAGON_BUILDING, pointId, uuid)
  elseif asType == AssistanceType.WinterEntity then
    MarchUtil.OnClickStartMarch(MarchTargetType.ASSISTANCE_WINTER_ENTITY, pointId, uuid)
  elseif asType == AssistanceType.EpidemicBuild then
    MarchUtil.OnClickStartMarch(MarchTargetType.ASSISTANCE_EPIDEMIC_BUILDING, pointId, uuid)
  elseif asType == AssistanceType.TradeState then
    MarchUtil.OnClickStartMarch(MarchTargetType.ASSISTANCE_CITY_TRADE, pointId, uuid)
  elseif asType == AssistanceType.ASSISTANCE_ALTAR then
    MarchUtil.OnClickStartMarch(MarchTargetType.ASSISTANCE_CITY_ALTAR, pointId, uuid)
  end
end

local __requestCityCdDic = {}

function WorldBattleUtil.TryRequestCityInfo(cityId, serverId)
  serverId = serverId or LuaEntry.Player:GetCurServerId()
  local hash = cityId * 100000 + serverId
  local curTime = UITimeManager:GetInstance():GetServerTime()
  local lastTime = __requestCityCdDic[hash]
  if lastTime and curTime - lastTime < 2000 then
    return
  end
  local cityTemplate = DataCenter.AllianceCityTemplateManager:GetTemplate(cityId, serverId)
  if not cityTemplate then
    return
  end
  __requestCityCdDic[hash] = curTime
  if cityTemplate.type == WorldAllianceCityType.Stronghold then
    SFSNetwork.SendMessage(MsgDefines.WorldGetCityStrongholdDetail, cityId, serverId)
    return
  end
  if cityTemplate.type == WorldAllianceCityType.TradingStation then
    DataCenter.SeasonTradeShopDataManager:ReqTradeDetail(cityId, serverId)
    return
  end
  if cityTemplate.type == WorldAllianceCityType.Altar then
    return
  end
  if cityTemplate.type == WorldAllianceCityType.LLNormalCity or cityTemplate.type == WorldAllianceCityType.LLThroneCity or cityTemplate.type == WorldAllianceCityType.LLCanon or cityTemplate.type == WorldAllianceCityType.LLBuffCity then
    DataCenter.LandlordMgr:SendDetailMessage(cityId, serverId)
    return
  end
  SFSNetwork.SendMessage(MsgDefines.WorldGetAllianceCityDetail, cityId, serverId)
end

function WorldBattleUtil.TryGetAllianceCityInfo(cityId, pointId)
  local oneData = {}
  oneData.cityId = cityId
  oneData.pointId = pointId
  local cityTemplate = DataCenter.AllianceCityTemplateManager:GetTemplate(cityId, LuaEntry.Player:GetCurServerId())
  if cityTemplate ~= nil then
    oneData.type = cityTemplate.type
  end
  local pointInfo = CS.SceneManager.World:GetPointInfo(pointId)
  if pointInfo ~= nil then
    oneData.uuid = pointInfo.uuid
    local allianceCityPointInfo = SeasonUtil.TryParseAllianceCityPointInfo(pointInfo.PointType, pointInfo.extraInfo, pointInfo)
    if allianceCityPointInfo ~= nil then
      oneData.state = allianceCityPointInfo.state
    end
  end
  oneData.isCrossServerThrone = (oneData.type == WorldAllianceCityType.Canon or oneData.type == WorldAllianceCityType.MissileFactory or oneData.type == WorldAllianceCityType.King) and (oneData.state == AllianceCityState.SERVER_NEUTRAL or oneData.state == AllianceCityState.SERVER_OCCUPIED or oneData.state == AllianceCityState.SERVER_BUILD_THRONE)
  return oneData
end

WorldBattleUtil.recordPosList = {}
WorldBattleUtil.recordMinMagDistance = -1

function WorldBattleUtil.StartRecordPointInfo(minMagDistance)
  WorldBattleUtil.recordPosList = {}
  WorldBattleUtil.recordMinMagDistance = minMagDistance
end

function WorldBattleUtil.RecordPos(worldPos)
  if not worldPos then
    return
  end
  local find = false
  for k, v in ipairs(WorldBattleUtil.recordPosList) do
    local _minX = v.minX
    local _maxX = v.maxX
    local _minY = v.minY
    local _maxY = v.maxY
    local _centerX = (_minX + _maxX) * 0.5
    local _centerY = (_minY + _maxY) * 0.5
    local _gapX = worldPos.x - _centerX
    local _gapY = worldPos.y - _centerY
    local magDis = _gapX * _gapX + _gapY * _gapY
    if magDis <= WorldBattleUtil.recordMinMagDistance then
      find = true
      WorldBattleUtil.recordPosList[k].minX = Mathf.Min(_minX, worldPos.x)
      WorldBattleUtil.recordPosList[k].maxX = Mathf.Max(_maxX, worldPos.x)
      WorldBattleUtil.recordPosList[k].minY = Mathf.Min(_minY, worldPos.y)
      WorldBattleUtil.recordPosList[k].maxY = Mathf.Max(_maxY, worldPos.y)
      break
    end
  end
  if not find then
    table.insert(WorldBattleUtil.recordPosList, {
      minX = worldPos.x,
      maxX = worldPos.x,
      minY = worldPos.y,
      maxY = worldPos.y
    })
  end
end

function WorldBattleUtil.GetRecordPosList(output)
  if not output then
    WorldBattleUtil.recordPosList = {}
    WorldBattleUtil.recordMinMagDistance = -1
    return
  end
  if not WorldBattleUtil.recordPosList then
    Logger.LogError("[WorldBattleUtil] FFFFFuck ! _recordPosList is null ")
    return
  end
  if #WorldBattleUtil.recordPosList > 0 then
    for k, v in ipairs(WorldBattleUtil.recordPosList) do
      table.insert(output, {
        x = Mathf.Ceil((v.minX + v.maxX) * 0.5),
        y = Mathf.Ceil((v.minY + v.maxY) * 0.5)
      })
    end
  end
  WorldBattleUtil.recordPosList = {}
  WorldBattleUtil.recordMinMagDistance = -1
end

return WorldBattleUtil
