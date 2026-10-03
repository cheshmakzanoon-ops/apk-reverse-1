local SeasonWorldSkinUtil = {}

function SeasonWorldSkinUtil.GetSkin(skinId, skinCfg)
  if CS.SceneSkinMeta == nil then
    return nil
  end
  if not LocalController:instance():hasTable(TableName.World_Skin) then
    return nil
  end
  if skinId then
    local line = skinCfg or LocalController:instance():getLine(TableName.World_Skin, toInt(skinId))
    if line and line.id then
      do
        local meta = CS.SceneSkinMeta()
        meta.id = line.id
        meta.mapType = line.season_type or SeasonMapType.Nothing
        meta.loading_bg = line.loading_bg
        meta.loading_logo = line.logo
        meta.world_deco_byte = line.world_deco_byte
        meta.world_deco_asset = line.world_deco_asset
        meta.world_block = line.world_block
        meta.world_terrain = line.world_terrain
        meta.world_terrain_low = line.world_terrain_low
        meta.world_terrain_control = line.world_terrain_control
        meta.world_terrain_black = line.world_terrain_black
        meta.world_map = line.world_map
        meta.world_city_color = "worldcity_color"
        meta.splash_fill_mode = 1
        meta.world_zone_line = line.world_zone_line
        meta.city_deco = line.city_deco
        meta.city_terrain = line.city_terrain
        meta.city_fog = line.city_fog
        meta.radar_bg = line.radar_bg
        meta.world_city_table_name = "lw_worldcity"
        meta.world_terrain_mode = line.world_terrain_mode
        meta.world_terrain_mode_mat = line.world_terrain_mode_mat
        meta.troop_line_color = line.troopline_color or ""
        meta.camera_scaling = tonumber(line.camera_scaling) or 1
        meta.seasonType = line.season_type or SeasonMapType.Nothing
        meta.world_fog = line.world_fog
        meta.world_fog_bloody = line.world_fog_bloody
        meta.edge_performance = line.edge_performance
        meta.light_monster = line.light_monster
        meta.loading_bgm = line.loading_bgm
        meta.home_bgm = line.home_bgm
        meta.world_bgm = line.world_bgm
        meta.city_sound = line.city_sound
        meta.world_sound = line.world_sound
        meta.edge_world_fog = line.edge_world_fog
        if meta.mapType2 ~= nil then
          meta.mapType2 = 0
        end
        if meta.seasonNextType2 ~= nil then
          meta.seasonNextType2 = 0
        end
        local ok, err = pcall(function()
          meta.cityPostProcessVolume = line.cityPostProcessVolume
        end)
        if not ok then
          Logger.LogInfo("pcall cant get cityPostProcessVolume. C# ver is wrong. skip")
        end
        ok, err = pcall(function()
          meta.city_camp_count = line.city_camp_count
          meta.city_camp_terrain = line.city_camp_terrain
          meta.city_camp_deco = line.city_camp_deco
          meta.city_camp_fog = line.city_camp_fog
          meta.center_extra_fog = line.center_extra_fog
          meta.center_extra_fog_days = line.center_extra_fog_days
          meta.camp_congress_heitu = line.camp_congress_heitu
          meta.camp_city_huitu = line.camp_city_huitu
          meta.camp_city_wall_skin = line.camp_city_wall_skin
        end)
        if not ok then
          Logger.LogInfo("pcall cant get city_camp. C# ver is wrong. skip")
        end
        return meta
      end
    end
  end
  return nil
end

function SeasonWorldSkinUtil.DoChangeWorldSkin(seasonInfo)
  if seasonInfo ~= nil then
    DataCenter.BirthPointTemplateManager:InitAllBirthPoint(seasonInfo.serverId)
    seasonInfo:ActiveViewModeSkin()
  end
end

function SeasonWorldSkinUtil.ChangeWorldSkin(toServerId)
  local nServerId = toInt(toServerId)
  if nServerId <= 0 then
    return
  end
  DataCenter.AllianceCityTipManager:RemoveAllAllianceCityTip()
  DataCenter.SurpriseBuildingTipManager:RemoveAllSurpriseBuildingTip()
  if 9000 <= nServerId then
    return
  end
  local seasonInfo = SeasonUtil.GetSeasonInfo(nServerId)
  if seasonInfo ~= nil then
    DataCenter.BirthPointTemplateManager:InitAllBirthPoint(nServerId)
  end
  if seasonInfo == nil or seasonInfo:GetServerType(false) ~= SeasonMapType.Nothing then
    SFSNetwork.SendMessage(MsgDefines.GetStrongholdBattleState, nServerId)
    DataCenter.WorldAllianceCityDataManager:CleanStrongholdBattleState(nServerId)
  end
  if seasonInfo == nil or seasonInfo:GetServerType(false) == SeasonMapType.Darkness then
    DataCenter.BloodyNightDataManager:AddBloodyData(nServerId)
  end
  if seasonInfo == nil or seasonInfo:GetServerType(false) >= SeasonMapType.Mummy then
    DataCenter.WorldAllianceCityDataManager:ClearTradeStationState(nServerId)
    DataCenter.WorldAllianceCityDataManager:TryFetchTradeStationState(nServerId)
  end
  local thePresident = DataCenter.GovernmentManager:GetCurPresident(nServerId)
  if thePresident == nil then
    DataCenter.GovernmentManager:GetKingInfoByServerId(nServerId)
  end
  if seasonInfo == nil then
    SFSNetwork.SendMessage(MsgDefines.GetSpecialServerSeasonInfo, nServerId)
  else
    SeasonWorldSkinUtil.DoChangeWorldSkin(seasonInfo)
  end
end

return ConstClass("SeasonWorldSkinUtil", SeasonWorldSkinUtil)
