local WorldBuildUtil = {}
local Localization = CS.GameEntry.Localization

local function GetBuildAllianceId(pointId)
  local allianceId = ""
  local info = CS.SceneManager.World:GetPointInfo(pointId)
  if info ~= nil then
    local theCityPointInfo = SeasonUtil.TryParseAllianceCityPointInfo(info.PointType, info.extraInfo, info)
    if theCityPointInfo ~= nil then
      allianceId = theCityPointInfo.allianceId
    end
  end
  return allianceId
end

local function GetBuildName(info)
  if info == nil then
    return ""
  end
  local pointType = info.PointType
  if pointType == WorldPointType.WORLD_CITY_STRONGHOLD then
    local allianceCityPointInfo = PBController.ParsePbFromBytes(info.extraInfo, "protobuf.CityStrongholdPointInfo")
    if allianceCityPointInfo ~= nil then
      local cityId = allianceCityPointInfo.strongholdId
      local cityTemplate = DataCenter.AllianceCityTemplateManager:GetTemplate(cityId, info.serverId)
      if cityTemplate ~= nil then
        return cityTemplate:GetFullName()
      end
    end
  elseif pointType == WorldPointType.WORLD_CITY_TRADE then
    local tradePointInfo = PBController.ParsePbFromBytes(info.extraInfo, "protobuf.CityTradePointInfo")
    if tradePointInfo ~= nil then
      local cityId = tradePointInfo.tradeId
      local cityTemplate = DataCenter.AllianceCityTemplateManager:GetTemplate(cityId, info.serverId)
      if cityTemplate ~= nil then
        return cityTemplate:GetFullName()
      end
    end
  elseif pointType == WorldPointType.CITY_ALTAR then
    local cityAltarInfo = PBController.ParsePbFromBytes(info.extraInfo, "protobuf.CityAltarPointInfo")
    if cityAltarInfo ~= nil then
      local cityId = cityAltarInfo.cfgid
      if cityId ~= nil then
        local cityTemplate = DataCenter.AllianceCityTemplateManager:GetTemplate(cityId, LuaEntry.Player:GetCurServerId())
        if cityTemplate ~= nil then
          return cityTemplate:GetFullName()
        end
      end
    end
  elseif pointType == WorldPointType.GOLD_TREE then
    local treePointInfo = PBController.ParsePbFromBytes(info.extraInfo, "protobuf.GoldTreePointInfo")
    if treePointInfo then
      local cityId = treePointInfo.treeId
      local cityTemplate = DataCenter.AllianceCityTemplateManager:GetTemplate(cityId, info.serverId)
      if cityTemplate ~= nil then
        return cityTemplate:GetFullName()
      end
    end
  elseif pointType == WorldPointType.WORLD_ALLIANCE_CITY then
    local allianceCityPointInfo = SeasonUtil.TryParseAllianceCityPointInfo(info.PointType, info.extraInfo, info)
    if allianceCityPointInfo ~= nil then
      local cityId = allianceCityPointInfo.cityId
      local cityTemplate = DataCenter.AllianceCityTemplateManager:GetTemplate(cityId, info.serverId)
      if cityTemplate ~= nil then
        return cityTemplate:GetFullName()
      end
    end
  elseif pointType == WorldPointType.WORLD_CITY_OUTPOST or pointType == WorldPointType.WORLD_CITY_OUTPOST_TOWER then
    local cityId = info.CityId or info.cityId
    local cityTemplate = DataCenter.AllianceCityTemplateManager:GetTemplate(cityId, info.serverId)
    if cityTemplate ~= nil then
      return cityTemplate:GetFullName()
    end
  elseif pointType == WorldPointType.WORLD_ALLIANCE_BUILD then
    local detailInfo = PBController.ParsePbFromBytes(info.extraInfo, "protobuf.AllianceBuildingPointInfo")
    if detailInfo ~= nil then
      local cityTemplate = DataCenter.AllianceMineManager:GetAllianceMineTemplate(detailInfo.buildId)
      if cityTemplate ~= nil then
        if detailInfo.level then
          return Localization:GetString(310161, cityTemplate:GetName(), detailInfo.level)
        end
        return cityTemplate:GetFullName()
      end
    end
  elseif pointType == WorldPointType.WorldAllianceCollectResource then
    cast(info, typeof(CS.WorldAllianceCollectResource))
    if info then
      local cityTemplate = DataCenter.AllianceMineManager:GetAllianceMineTemplate(info.configId)
      if cityTemplate ~= nil then
        return cityTemplate:GetFullName()
      end
    end
  end
  return ""
end

local function GetBuildTile(pointId)
  local size = 1
  local info = CS.SceneManager.World:GetPointInfo(pointId)
  if info ~= nil then
    if info.PointType == WorldPointType.WORLD_ALLIANCE_CITY or info.PointType == WorldPointType.WORLD_CITY_STRONGHOLD or info.PointType == WorldPointType.WORLD_CITY_TRADE or info.PointType == WorldPointType.GOLD_TREE then
      local theCityPointInfo = SeasonUtil.TryParseAllianceCityPointInfo(info.PointType, info.extraInfo, info)
      if theCityPointInfo ~= nil then
        size = GetTableData(TableName.WorldCity, theCityPointInfo.cityId, "size")
      end
    elseif info.PointType == WorldPointType.WORLD_ALLIANCE_BUILD then
      local allianceBuildPointInfo = PBController.ParsePbFromBytes(info.extraInfo, "protobuf.AllianceBuildingPointInfo")
      if allianceBuildPointInfo ~= nil then
        local mineID = allianceBuildPointInfo.buildId
        local template = DataCenter.AllianceMineManager:GetAllianceMineTemplate(mineID)
        if template ~= nil then
          size = template.resSize
        end
      end
    elseif info.PointType == WorldPointType.NPC_CITY then
      local npcCityPointInfo = PBController.ParsePbFromBytes(info.extraInfo, "protobuf.NpcCityPointInfo")
      if npcCityPointInfo then
        local id = npcCityPointInfo.npcId
        local template = DataCenter.NpcCityManager:GetTemplate(id)
        if template then
          return template.size
        end
      end
    elseif info.PointType == WorldPointType.DRAGON_BUILDING then
      local detail = info.detail
      if detail then
        local id = detail.BuildId
        local template = DataCenter.DragonBuildTemplateManager:GetTemplate(id)
        if template then
          return template.size
        end
      end
    elseif info.PointType == WorldPointType.DRAGON_SCORE_POINT then
      return 1
    elseif info.PointType == WorldPointType.WINTER_ENTITY then
      local detail = info.detail
      if detail then
        local id = detail.BuildId
        local template = DataCenter.WinterStormTemplateManager:GetTemplate(id)
        if template then
          return template.size
        end
      end
    elseif info.PointType == WorldPointType.BATTLEFIELD_BUILD then
      local detail = info.detail
      if detail then
        local id = detail.BuildId
        local template = BattleFieldUtil.GetBattlefieldBuildTemplate(id)
        if template then
          return template.size
        end
      end
    elseif info.PointType == WorldPointType.CITY_ALTAR then
      local cityAltarInfo = PBController.ParsePbFromBytes(info.extraInfo, "protobuf.CityAltarPointInfo")
      if cityAltarInfo ~= nil then
        local cityId = cityAltarInfo.cfgid
        if cityId ~= nil then
          local cityTemplate = DataCenter.AllianceCityTemplateManager:GetTemplate(cityId, LuaEntry.Player:GetCurServerId())
          if cityTemplate ~= nil then
            return checknumber(cityTemplate.size)
          end
        end
      end
    end
  end
  return size
end

local function GetLLPreBuilding(cityTemplate)
  if DataCenter.LandlordMgr:IsCityWithBoom(cityTemplate.id) then
    return cityTemplate:IsThroneCity() and cityTemplate:getValue("half_boom_model") or cityTemplate:getValue("full_boom_model")
  end
end

local function GetWorldPointModelPath(info)
  local path = ""
  if info ~= nil then
    if info.PointType == WorldPointType.WORLD_CITY_STRONGHOLD then
      local allianceCityPointInfo = PBController.ParsePbFromBytes(info.extraInfo, "protobuf.CityStrongholdPointInfo")
      if allianceCityPointInfo ~= nil then
        local cityId = allianceCityPointInfo.strongholdId
        local alAbbr = allianceCityPointInfo.alAbbr
        local cityTemplate = DataCenter.AllianceCityTemplateManager:GetTemplate(cityId, LuaEntry.Player:GetCurServerId())
        if cityTemplate == nil then
          return ""
        end
        local model = cityTemplate.model
        if string.IsNullOrEmpty(alAbbr) then
          local tmpModel = cityTemplate.not_occupied_model
          if not string.IsNullOrEmpty(tmpModel) then
            model = tmpModel
          end
        end
        local llModel = GetLLPreBuilding(cityTemplate)
        model = string.IsNullOrEmpty(llModel) and model or llModel
        path = UIUtil.GetFullPath("Assets/Main/Prefabs/World/", model, ".prefab")
      end
    elseif info.PointType == WorldPointType.WORLD_CITY_TRADE then
      local tradePointInfo = PBController.ParsePbFromBytes(info.extraInfo, "protobuf.CityTradePointInfo")
      if tradePointInfo ~= nil then
        local cityId = tradePointInfo.tradeId
        local cityTemplate = DataCenter.AllianceCityTemplateManager:GetTemplate(cityId, LuaEntry.Player:GetCurServerId())
        local hasLorad = not string.IsNullOrEmpty(tradePointInfo.uid)
        local isShopEmpty = tradePointInfo.shopState == nil or tradePointInfo.shopState ~= 1
        if DataCenter.BloodyNightDataManager:IsBloodyNight() then
          isShopEmpty = tradePointInfo.nightShopState == nil or tradePointInfo.nightShopState ~= 1
        end
        local model = cityTemplate.model
        if not hasLorad or isShopEmpty then
          local tmpModel = cityTemplate.not_occupied_model
          if not string.IsNullOrEmpty(tmpModel) then
            model = tmpModel
          end
        else
        end
        if model then
          path = UIUtil.GetFullPath("Assets/Main/Prefabs/World/", model, ".prefab")
        end
      end
    elseif info.PointType == WorldPointType.CITY_ALTAR then
      local cityAltarInfo = PBController.ParsePbFromBytes(info.extraInfo, "protobuf.CityAltarPointInfo")
      if cityAltarInfo ~= nil then
        local cityId = cityAltarInfo.cfgid
        if cityId ~= nil then
          local cityTemplate = DataCenter.AllianceCityTemplateManager:GetTemplate(cityId, LuaEntry.Player:GetCurServerId())
          if cityTemplate ~= nil then
            local hasOwner = not string.IsNullOrEmpty(cityAltarInfo.owner)
            if hasOwner then
              return cityTemplate.model
            end
            return cityTemplate.not_occupied_model
          end
        end
      end
    elseif info.PointType == WorldPointType.GOLD_TREE then
      local treePointInfo = PBController.ParsePbFromBytes(info.extraInfo, "protobuf.GoldTreePointInfo")
      if treePointInfo then
        local cityId = treePointInfo.treeId
        local cityTemplate = DataCenter.AllianceCityTemplateManager:GetTemplate(cityId, LuaEntry.Player:GetCurServerId())
        if treePointInfo.finishTime and treePointInfo.finishTime > 0 then
          return cityTemplate.model
        else
          return cityTemplate.not_occupied_model
        end
      end
    elseif info.PointType == WorldPointType.WORLD_ALLIANCE_CITY then
      local allianceCityPointInfo = SeasonUtil.TryParseAllianceCityPointInfo(info.PointType, info.extraInfo, info)
      if allianceCityPointInfo ~= nil then
        local cityId = allianceCityPointInfo.cityId
        local alAbbr = allianceCityPointInfo.alAbbr
        local state = allianceCityPointInfo.state
        local config = DataCenter.AllianceCityTemplateManager:GetTemplate(cityId, info.serverId)
        if config == nil then
          return "Assets/Main/Prefabs/World/worldcity_1.prefab"
        end
        local cityType = toInt(config.type)
        local model = config.model
        if state == AllianceCityState.DESTROY then
          local city_ruins = config.city_ruins
          if city_ruins ~= nil and city_ruins ~= "" then
            model = city_ruins
          end
        elseif state == AllianceCityState.OCCUPIED or state == AllianceCityState.SERVER_OCCUPIED or state == AllianceCityState.BUILDING or state == AllianceCityState.SERVER_BUILD_THRONE then
        elseif config and config:IsThroneCity() then
          local curTime = UITimeManager:GetInstance():GetServerSeconds()
          local timeOpen = allianceCityPointInfo.openTime
          local timeEnd = allianceCityPointInfo.protectTime
          if curTime > timeOpen and curTime < timeEnd then
          else
            local data = SeasonUtil.GetSeasonInfo(LuaEntry.Player:GetCurServerId())
            if data and data:InHaltMode() then
            elseif string.IsNullOrEmpty(alAbbr) then
              model = config.not_occupied_model
            end
          end
        else
          local data = SeasonUtil.GetSeasonInfo(LuaEntry.Player:GetCurServerId())
          if data and data:InHaltMode() then
          elseif string.IsNullOrEmpty(alAbbr) then
            model = config.not_occupied_model
          end
        end
        local llModel = GetLLPreBuilding(config)
        model = string.IsNullOrEmpty(llModel) and model or llModel
        path = UIUtil.GetFullPath("Assets/Main/Prefabs/World/", model, ".prefab")
      end
    elseif info.PointType == WorldPointType.ZWL_BUILDING or info.PointType == WorldPointType.ZWL_BUILDING_BUFF or info.PointType == WorldPointType.ZWL_BUILDING_THRONE or info.PointType == WorldPointType.ZWL_BUILDING_TOWER then
      local llCityPointInfo = SeasonUtil.TryParseAllianceCityPointInfo(info.PointType, info.extraInfo, info)
      if llCityPointInfo ~= nil then
        local cityId = llCityPointInfo.cityId
        local progress = llCityPointInfo.progress
        local config = DataCenter.AllianceCityTemplateManager:GetTemplate(cityId, info.serverId)
        if config == nil then
          return "Assets/Main/Prefabs/World/worldcity_1.prefab"
        end
        local model = config.model
        local curClientState = llCityPointInfo.curClientState
        if curClientState == LLConst.LLBuildingState.Ruins then
          model = config.ruins_model
        elseif curClientState == LLConst.LLBuildingState.WillExplode or curClientState == LLConst.LLBuildingState.Exploding then
          model = config.full_boom_model
        elseif curClientState == LLConst.LLBuildingState.Rebuilding then
          model = config.building_model
        elseif curClientState == LLConst.LLBuildingState.Fighting then
          model = config.model
        elseif (curClientState == LLConst.LLBuildingState.NotOpen or curClientState == LLConst.LLBuildingState.OpenButShield) and (info.PointType == WorldPointType.ZWL_BUILDING or info.PointType == WorldPointType.ZWL_BUILDING_THRONE) then
          model = 0 < progress and config.half_boom_model or config.model
        elseif (curClientState == LLConst.LLBuildingState.NotOpen or curClientState == LLConst.LLBuildingState.OpenButShield) and (info.PointType == WorldPointType.ZWL_BUILDING_BUFF or info.PointType == WorldPointType.ZWL_BUILDING_TOWER) then
          model = config.model
        end
        path = UIUtil.GetFullPath("Assets/Main/Prefabs/World/", model, ".prefab")
      end
    elseif info.PointType == WorldPointType.MONSTER_REWARD then
      path = "Assets/Main/Prefabs/World/MonsterReward.prefab"
    elseif info.PointType == WorldPointType.DRAGON_BUILDING then
      local dragonBuildingPointInfo = info.detail
      if dragonBuildingPointInfo then
        local allianceId = dragonBuildingPointInfo.AllianceId
        local id = dragonBuildingPointInfo.BuildId
        local template = DataCenter.DragonBuildTemplateManager:GetTemplate(id)
        if template then
          path = template:GetModelPath()
        end
      end
    elseif info.PointType == WorldPointType.DRAGON_SCORE_POINT then
      local template = DataCenter.DragonBuildTemplateManager:GetTemplate(10110)
      if template then
        return template:GetModelPath()
      end
    elseif info.PointType == WorldPointType.WINTER_ENTITY then
      local dragonBuildingPointInfo = info.detail
      if dragonBuildingPointInfo then
        local id = dragonBuildingPointInfo.BuildId
        local template = DataCenter.WinterStormTemplateManager:GetTemplate(id)
        if template then
          path = template:GetModelPath()
        end
      end
    elseif info.PointType == WorldPointType.BATTLEFIELD_BUILD then
      local dragonBuildingPointInfo = info.detail
      if dragonBuildingPointInfo then
        local id = dragonBuildingPointInfo.BuildId
        local template = BattleFieldUtil.GetBattlefieldBuildTemplate(id)
        if template then
          path = template:GetModelPath()
        end
      end
    elseif info.PointType == WorldPointType.WORLD_CITY_OUTPOST or info.PointType == WorldPointType.WORLD_CITY_OUTPOST_TOWER then
      local seasonType = SeasonUtil.GetSeasonType(false, true, ServerEnum.View)
      local cityId = info.CityId or info.cityId
      local config = DataCenter.AllianceCityTemplateManager:GetTemplate(cityId, info.serverId)
      local default_path = "Assets/Main/SeasonRes/Shared/Prefabs/World/building_feixu_world_1.prefab"
      if info.PointType == WorldPointType.WORLD_CITY_OUTPOST_TOWER then
        if seasonType == SeasonMapType.NineNationRainforest then
          default_path = "Assets/Main/SeasonRes/S6/Prefabs/WorldCity/worldcity_S6_paodizuo.prefab"
        elseif seasonType == SeasonMapType.NineNation then
          default_path = "Assets/Main/SeasonRes/S5/Prefabs/WorldCity/worldcity_S5_paodizuo.prefab"
        end
      elseif info.PointType == WorldPointType.WORLD_CITY_OUTPOST then
        local cityInfo = info.cityInfo
        if seasonType == SeasonMapType.NineNationRainforest then
          default_path = "Assets/Main/SeasonRes/S6/Prefabs/WorldCity/worldcity_S6_qianshaozhan_po.prefab"
          if cityInfo and cityInfo.DestroyServerId ~= 0 and cityInfo.DestroyAllianceId ~= nil and cityInfo.DestroyAllianceId ~= "" then
            return default_path
          end
        elseif seasonType == SeasonMapType.NineNation then
          default_path = "Assets/Main/SeasonRes/S5/Prefabs/WorldCity/worldcity_S5_qianshaozhan_po.prefab"
        end
      end
      if config == nil then
        path = default_path
      else
        if seasonType == SeasonMapType.NineNationRainforest then
          local curServerId = LuaEntry.Player:GetCurServerId()
          local isBigMapMode, curSameGroup, srcSameGroup, loginSameGroup = SeasonUtil.InSeasonBigMapMode(curServerId)
          if isBigMapMode and srcSameGroup and loginSameGroup then
            if info.PointType == WorldPointType.WORLD_CITY_OUTPOST_TOWER then
              local putByServerId = DataCenter.SeasonOutpostManager:GetPutInfoByCityId(config.parent_output)
              if putByServerId == nil or putByServerId == 0 then
                return default_path
              end
            elseif info.PointType == WorldPointType.WORLD_CITY_OUTPOST then
              local putByServerId = DataCenter.SeasonOutpostManager:GetPutInfoByCityId(cityId)
              if putByServerId == nil or putByServerId == 0 then
                return "Assets/Main/SeasonRes/S6/Prefabs/WorldCity/outpost_feixu_world.prefab"
              end
            end
          elseif isBigMapMode and info.PointType == WorldPointType.WORLD_CITY_OUTPOST then
            local cityInfo = info.cityInfo
            if cityInfo ~= nil and cityInfo.LastRepairTime == 0 and cityInfo.BattleStartTime == 0 and cityInfo.ProtectTime == 0 and cityInfo.OwnerServerId == 0 then
              return "Assets/Main/SeasonRes/S6/Prefabs/WorldCity/outpost_feixu_world.prefab"
            end
          end
        end
        if info.buildState == 0 then
          path = config:getValue("city_ruins", default_path)
        elseif info.buildState == 1 then
          path = config:getValue("model", default_path)
        end
      end
      local llModel = GetLLPreBuilding(config)
      if not string.IsNullOrEmpty(llModel) then
        path = UIUtil.GetFullPath("Assets/Main/Prefabs/World/", llModel, ".prefab")
      end
      if string.IsNullOrEmpty(path) then
        return default_path
      end
    elseif info.PointType == WorldPointType.WORLD_ALLIANCE_BUILD then
      local detailInfo = PBController.ParsePbFromBytes(info.extraInfo, "protobuf.AllianceBuildingPointInfo")
      if detailInfo then
        local buildId = detailInfo.buildId
        local model = ""
        local extraStr = "_white"
        local state = detailInfo.state
        local template = DataCenter.AllianceMineManager:GetAllianceMineTemplate(detailInfo.buildId)
        if template ~= nil then
          if state == AllianceMineStatus.Ruin and template.type ~= AllianceBuildType.Attachment and WorldAllianceBuildUtil.IsAllianceActMineGroup(buildId) == false then
            model = "Assets/Main/Prefabs/AllianceBuilding/allianceBuilding_ruin"
          else
            model = template:GetModelPath()
          end
          if string.IsNullOrEmpty(model) then
            Logger.LogInfo("WORLD_ALLIANCE_BUILD , buildId = " .. (buildId or "nil"))
          end
          if buildId == BuildingTypes.LW_ALLIANCE_WAR_CAMP_2 then
            model = string.format("%s_S0%d", model, detailInfo.positionId)
          end
          if template.type == AllianceBuildType.Attachment or template.type == AllianceBuildType.SiegeCamp or template.type == AllianceBuildType.ZombieRush or template.type == AllianceBuildType.AresMissile or template.type == AllianceBuildType.GoddessMummy then
            extraStr = ""
          else
            local seasonType = SeasonUtil.GetSeasonType(false, true)
            if SeasonUtil.SeasonHasFactionWar(seasonType) then
              local mySeverId = LuaEntry.Player:GetSourceServerId()
              local theAllianceId = detailInfo.allianceId
              local myAllianceId = LuaEntry.Player.allianceId
              if not string.IsNullOrEmpty(myAllianceId) and theAllianceId == myAllianceId then
                extraStr = "_alliance"
              elseif mySeverId == info.srcServerId then
                extraStr = "_white"
              else
                local factionMgr = DataCenter.SeasonFactionWarDataManager
                local myCampId = factionMgr.myCampId
                local theCampId = factionMgr:GetCampIdByServerId(info.srcServerId)
                if myCampId == theCampId then
                  extraStr = "_white"
                elseif factionMgr.currStep == SeasonFactionDeclareWarStep.battle_before or factionMgr.currStep == SeasonFactionDeclareWarStep.battle or factionMgr.currStep == SeasonFactionDeclareWarStep.battle_after then
                  if factionMgr.theAttackerList[myAllianceId] and factionMgr.theDefenderList[theAllianceId] or factionMgr.theDefenderList[myAllianceId] and factionMgr.theAttackerList[theAllianceId] then
                    extraStr = "_other"
                  else
                    extraStr = "_yellow"
                  end
                else
                  extraStr = "_yellow"
                end
              end
            elseif template.type == AllianceBuildType.StoveCenter or template.type == AllianceBuildType.MilitaryCenter or template.type == AllianceBuildType.Carrier or WorldAllianceBuildUtil.IsAllianceCenterFlag(buildId) or WorldAllianceBuildUtil.IsAllianceCenterGroup(buildId) or WorldAllianceBuildUtil.IsAllianceFrontGroup(buildId) then
              local cityAllianceId = detailInfo.allianceId
              local allianceUid = LuaEntry.Player.allianceId
              local mySeverId = LuaEntry.Player:GetSourceServerId()
              if allianceUid ~= nil and allianceUid ~= "" then
                if cityAllianceId == allianceUid then
                  extraStr = "_alliance"
                elseif cityAllianceId ~= nil and cityAllianceId ~= "" then
                  if mySeverId ~= info.srcServerId and CrossServerUtil.GetIsInBattleServerGroup(info.srcServerId) then
                    extraStr = "_yellow"
                  else
                    local fightAllianceId = DataCenter.AllianceCompeteDataManager:GetFightAllianceId()
                    if fightAllianceId ~= nil and fightAllianceId ~= "" and fightAllianceId == cityAllianceId then
                      extraStr = "_yellow"
                    else
                      extraStr = "_white"
                    end
                  end
                else
                  extraStr = "_white"
                end
              elseif mySeverId ~= info.srcServerId and CrossServerUtil.GetIsInBattleServerGroup(info.srcServerId) then
                extraStr = "_yellow"
              else
                extraStr = "_white"
              end
            else
              extraStr = ""
            end
          end
        end
        if string.IsNullOrEmpty(model) then
          Logger.LogInfo(" alliance_res_build model is empty, buildId = " .. (buildId or "nil"))
        end
        path = model .. extraStr .. ".prefab"
      end
    elseif info.PointType == WorldPointType.WorldAllianceCollectResource then
      cast(info, typeof(CS.WorldAllianceCollectResource))
      if info then
        local template = DataCenter.AllianceMineManager:GetAllianceMineTemplate(info.configId)
        if template ~= nil then
          path = template:GetModelPath() .. ".prefab"
        end
      end
    elseif info.PointType == WorldPointType.RADAR_DOMINATOR_GUIDE then
      path = "Assets/Main/Prefabs/World/MonsterReward.prefab"
    elseif info.PointType == WorldPointType.RADAR_DOMINATOR__COCKATRICE_UNLOCK_1 or info.PointType == WorldPointType.RADAR_DOMINATOR__COCKATRICE_UNLOCK_2 then
      path = "Assets/Main/Prefabs/World/MonsterReward.prefab"
    elseif info.PointType == WorldPointType.SURPRISE_POINT then
      path = DataCenter.SurprisePointManager:GetPrefabPath(info)
    end
  end
  return path
end

local function GetAllianceCitySimpleDataByPointInfo(info)
  if info ~= nil then
    local theCityPointInfo = SeasonUtil.TryParseAllianceCityPointInfo(info.PointType, info.extraInfo, info)
    if theCityPointInfo ~= nil then
      local cityId = theCityPointInfo.cityId
      return DataCenter.WorldAllianceCityDataManager:GetAllianceCityDataByCityId(cityId)
    end
  end
  return nil
end

local function GetAllianceCityIdByPointInfo(info)
  if info ~= nil then
    local theCityPointInfo = SeasonUtil.TryParseAllianceCityPointInfo(info.PointType, info.extraInfo, info)
    if theCityPointInfo ~= nil then
      return theCityPointInfo.cityId
    end
  end
  return 0
end

local function IsCollectRangePoint(pointIndex)
  local rangeList = BuildingUtils.GetAllNeighborsPos(SceneUtils.IndexToTilePos(pointIndex), CS.SceneManager.World:GetCollectResourceBuildRange(), CS.SceneManager.World:GetCollectResourceBuildRange())
  for k, v in pairs(rangeList) do
    local tempIndex = SceneUtils.TilePosToIndex(v)
    if CS.SceneManager.World:IsCollectPoint(tempIndex) then
      return true
    end
  end
  return false
end

local function GetCollectRangePoint(pointIndex, resourceType)
  local rangeList = BuildingUtils.GetAllNeighborsPos(SceneUtils.IndexToTilePos(pointIndex), CS.SceneManager.World:GetCollectResourceBuildRange(), CS.SceneManager.World:GetCollectResourceBuildRange())
  for k, v in pairs(rangeList) do
    local tempIndex = SceneUtils.TilePosToIndex(v)
    if CS.SceneManager.World:IsCollectPoint(tempIndex) then
      local template = CS.SceneManager.World:GetCollectInfoByIndex(tempIndex)
      if resourceType ~= nil then
        if template:GetResourceType() == resourceType then
          return template
        end
      else
        return template
      end
    end
  end
end

local function GetBornPointXY(param)
  local diff = LuaEntry.DataConfig:TryGetNum("gen_born_point_param", "k1")
  local space = LuaEntry.DataConfig:TryGetNum("gen_born_point_param", "k3")
  local bornAreaBornParam1 = space / 2 + diff
  local bornAreaBornParam2 = space
  local bornAreaBornParam3 = diff
  if param - bornAreaBornParam1 <= 0 then
    return bornAreaBornParam3
  else
    local pos = math.ceil((param - bornAreaBornParam1) / bornAreaBornParam2) * bornAreaBornParam2 + bornAreaBornParam3
    return math.floor(pos)
  end
end

local function GetBornPointByRealPoint(pointId)
  local xy = SceneUtils.IndexToTilePos(pointId)
  local bornX = WorldBuildUtil.GetBornPointXY(xy.x)
  local bornY = WorldBuildUtil.GetBornPointXY(xy.y)
  local item = {}
  item.x = bornX
  item.y = bornY
  local realPointId = SceneUtils.TilePosToIndex(item)
  return realPointId
end

local function CheckIsInBasementRange(pointId)
  local isIn = false
  local cityPoint = WorldBuildUtil.GetBornPointByRealPoint(pointId)
  local city = CS.SceneManager.World:GetPointInfo(cityPoint)
  if city ~= nil and city.PointType == WorldPointType.PlayerBuilding then
    cast(city, typeof(CS.BuildPointInfo))
    if city ~= nil and city.itemId == BuildingTypes.FUN_BUILD_MAIN then
      local levelTemplate = DataCenter.BuildTemplateManager:GetBuildingLevelTemplate(city.itemId, city.level)
      local template = DataCenter.BuildTemplateManager:GetBuildingDesTemplate(city.itemId)
      if levelTemplate ~= nil and template ~= nil then
        if template.tileX == nil or template.tileY == nil then
          Logger.LogError("city item id crood wrong :" .. city.itemId .. " _ " .. city.level)
        end
        if BuildingUtils.IsInRangeBySquare(cityPoint, pointId, levelTemplate.offer_range, levelTemplate.offer_range, template.tileX, template.tileY) == true then
          isIn = true
        end
      end
    end
  end
  if isIn == true then
    return cityPoint
  else
    return 0
  end
end

local _WorldAsyncObjDict = {}

function WorldBuildUtil.UpdateWorldAsyncObj(AsyncObj, DelayTimer)
  if AsyncObj then
    if _WorldAsyncObjDict == nil then
      _WorldAsyncObjDict = {}
    end
    _WorldAsyncObjDict[AsyncObj] = DelayTimer
  end
end

function WorldBuildUtil.RemoveWorldAsyncObj(AsyncObj)
  if _WorldAsyncObjDict then
    _WorldAsyncObjDict[AsyncObj] = nil
  end
end

function WorldBuildUtil.CleanWorldAsyncObj()
  if _WorldAsyncObjDict then
    for req, timer in pairs(_WorldAsyncObjDict) do
      if timer ~= nil then
        pcall(timer.Stop, timer)
      end
      if req ~= nil then
        pcall(req.Destroy, req)
      end
    end
    _WorldAsyncObjDict = {}
  end
end

function WorldBuildUtil.HasShield(pointId, lang)
  local info = CS.SceneManager.World:GetPointInfo(pointId)
  if info ~= nil then
    if info.PointType ~= WorldPointType.PlayerBuilding then
      return false
    end
    cast(info, typeof(CS.BuildPointInfo))
    if info.itemId == BuildingTypes.FUN_BUILD_MAIN and info.protectEndTime then
      local protectTime = info.protectEndTime
      local curTime = UITimeManager:GetInstance():GetServerSeconds()
      if protectTime > curTime then
        if lang then
          UIUtil.ShowTipsId(lang)
        end
        return true
      end
    end
  end
  return false
end

WorldBuildUtil.GetBuildAllianceId = GetBuildAllianceId
WorldBuildUtil.GetBuildName = GetBuildName
WorldBuildUtil.GetBuildTile = GetBuildTile
WorldBuildUtil.GetWorldPointModelPath = GetWorldPointModelPath
WorldBuildUtil.GetAllianceCitySimpleDataByPointInfo = GetAllianceCitySimpleDataByPointInfo
WorldBuildUtil.GetAllianceCityIdByPointInfo = GetAllianceCityIdByPointInfo
WorldBuildUtil.IsCollectRangePoint = IsCollectRangePoint
WorldBuildUtil.GetCollectRangePoint = GetCollectRangePoint
WorldBuildUtil.GetBornPointXY = GetBornPointXY
WorldBuildUtil.GetBornPointByRealPoint = GetBornPointByRealPoint
WorldBuildUtil.CheckIsInBasementRange = CheckIsInBasementRange
return ConstClass("WorldBuildUtil", WorldBuildUtil)
