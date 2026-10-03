local MailBattleParseHelper = require("DataCenter.MailData.MailBattleParseHelper")
local MailScoutDetailHelper = {}

function MailScoutDetailHelper:HandleTargetInfo(data, targetType)
  local result = {
    location = nil,
    serverId = nil,
    headIcon = nil,
    headFramePath = nil,
    name = nil,
    uid = nil,
    pic = nil,
    picVer = nil,
    enableClickInfo = false,
    hideBg = false,
    hasReward = false,
    nameNeedLocal = true
  }
  if targetType == ScoutMailTargetType.ALLIANCE_CITY then
    local cityMeta = DataCenter.AllianceCityTemplateManager:GetTemplate(data.targetAllianceCity.city_id.value)
    result.location = Vector2.New(data.targetAllianceCity.point.x.value, data.targetAllianceCity.point.y.value)
    result.serverId = data.targetAllianceCity.point.server.value
    result.headIcon = cityMeta:GetIconPath(false)
    result.name = cityMeta.name
  elseif targetType == ScoutMailTargetType.DRAGON_BUILDING then
    local cityMeta = DataCenter.DragonBuildTemplateManager:GetTemplate(data.targetAllianceCity.city_id.value)
    result.location = Vector2.New(data.targetAllianceCity.point.x.value, data.targetAllianceCity.point.y.value)
    result.serverId = data.targetAllianceCity.point.server.value
    result.headIcon = cityMeta:GetDetailPath()
    result.name = cityMeta.name
  elseif targetType == ScoutMailTargetType.WINTER_STORM_BUILDING then
    local cityMeta = DataCenter.WinterStormTemplateManager:GetTemplate(data.winterStormBuild.buildId.value)
    result.location = Vector2.New(data.winterStormBuild.point.x.value, data.winterStormBuild.point.y.value)
    result.serverId = data.winterStormBuild.point.server.value
    result.headIcon = cityMeta:GetDetailPath()
    result.name = cityMeta.name
  elseif targetType == ScoutMailTargetType.EPIDEMIC_BUILDING then
    result.location = Vector2.New(data.quarantineBuilding.point.x.value, data.quarantineBuilding.point.y.value)
    result.serverId = data.quarantineBuilding.point.server.value
    local cityMeta = BattleFieldUtil.GetBuildTemplate(data.quarantineBuilding.buildId.value, data.quarantineBuilding.worldType)
    if cityMeta == nil then
      BattleFieldUtil.LogError("\230\159\165\231\156\139\233\130\174\228\187\182\229\164\177\232\180\165\239\188\140\230\137\190\228\184\141\229\136\176\229\187\186\231\173\145\233\133\141\231\189\174: worldType:%s, buildID:%s", data.quarantineBuilding.worldType, data.quarantineBuilding.buildId.value)
    else
      result.headIcon = cityMeta:GetRulesIconPath()
      result.name = cityMeta.name
    end
  elseif targetType == ScoutMailTargetType.BUILDING then
    local meta, posInfo
    if data.playerSeasonBuild == nil or string.IsNullOrEmpty(data.playerSeasonBuild.name) then
      local level = data.allianceCityWall.visible.value
      local buildId = data.userWall.buildingId
      meta = DataCenter.BuildTemplateManager:GetBuildingLevelTemplate(buildId, level)
      if meta == nil then
        meta = DataCenter.BuildTemplateManager:GetBuildingDesTemplate(buildId)
      end
      posInfo = data.targetUser.point
    else
      local buildId = data.playerSeasonBuild.buildId.value
      local level = data.playerSeasonBuild.level.value
      meta = DataCenter.BuildTemplateManager:GetBuildingLevelTemplate(buildId, level)
      if meta == nil then
        meta = DataCenter.BuildTemplateManager:GetBuildingDesTemplate(buildId)
      end
      posInfo = data.playerSeasonBuild.point
    end
    if posInfo then
      result.location = Vector2.New(posInfo.x.value, posInfo.y.value)
      result.serverId = posInfo.server.value
    end
    if meta then
      result.headIcon = meta:GetBuildIconOutCity()
      result.name = meta.name
      result.hideBg = true
    end
  elseif targetType == ScoutMailTargetType.ALLIANCE_BUILD then
    local buildId = data.targetAllianceBuild.buildId.value
    local level = data.targetAllianceBuild.level.value
    local meta = DataCenter.AllianceMineManager:GetAllianceMineTemplate(buildId)
    result.location = Vector2.New(data.targetAllianceBuild.point.x.value, data.targetAllianceBuild.point.y.value)
    result.serverId = data.targetAllianceBuild.point.server.value
    result.headIcon = meta:GetIconPath()
    result.name = meta.name
    result.hideBg = true
  elseif targetType == ScoutMailTargetType.CITY_STRONGHOLD and data.scoutCityStronghold then
    local cityMeta = DataCenter.AllianceCityTemplateManager:GetTemplate(data.scoutCityStronghold.strongholdId.value)
    result.location = Vector2.New(data.scoutCityStronghold.point.x.value, data.scoutCityStronghold.point.y.value)
    result.serverId = data.scoutCityStronghold.point.server.value
    result.headIcon = cityMeta:GetIconPath(false)
    result.name = cityMeta.name
    result.hideBg = true
  elseif targetType == ScoutMailTargetType.CITY_OUTPOST and data.scoutOutpost then
    local cityMeta = DataCenter.AllianceCityTemplateManager:GetTemplate(data.scoutOutpost.outpostId.value)
    result.location = Vector2.New(data.scoutOutpost.point.x.value, data.scoutOutpost.point.y.value)
    result.serverId = data.scoutOutpost.point.server.value
    result.headIcon = cityMeta:GetIconPath(false)
    result.name = cityMeta.name
    result.hideBg = true
  elseif targetType == ScoutMailTargetType.CITY_TRADE and data.scoutCityTrade then
    local cityMeta = DataCenter.AllianceCityTemplateManager:GetTemplate(data.scoutCityTrade.tradeId.value)
    result.location = Vector2.New(data.scoutCityTrade.point.x.value, data.scoutCityTrade.point.y.value)
    result.serverId = data.scoutCityTrade.point.server.value
    result.headIcon = cityMeta:GetIconPath(false)
    result.name = cityMeta.name
    result.hideBg = true
  elseif targetType == ScoutMailTargetType.DESERT then
    local meta = DataCenter.DesertTemplateManager:GetTemplate(data.targetDesert.des_id.value)
    result.location = Vector2.New(data.targetDesert.point.x.value, data.targetDesert.point.y.value)
    result.serverId = data.targetDesert.point.server.value
    result.headIcon = string.format(LoadPath.SeasonDesert, meta.icon)
    result.name = meta.name
    result.hideBg = true
  elseif targetType == ScoutMailTargetType.ZWL_BUILDING then
    local cityMeta = DataCenter.AllianceCityTemplateManager:GetTemplate(data.zwlBuilding.buildId.value)
    result.location = Vector2.New(data.zwlBuilding.point.x.value, data.zwlBuilding.point.y.value)
    result.serverId = data.zwlBuilding.point.server.value
    if cityMeta then
      result.headIcon = cityMeta:GetIconPath(false)
      result.name = cityMeta.name
    end
    result.hideBg = true
  else
    result.location = Vector2.New(data.targetUser.point.x.value, data.targetUser.point.y.value)
    result.serverId = data.targetUser.point.server.value
    result.headFramePath = DataCenter.DecorationDataManager:GetHeadFrame(data.targetUser.headSkinId, 0, false)
    result.hasReward = true
    if MailBattleParseHelper.IsWerewolf(data.targetUser) then
      result.name = GameDialogDefine.WEREWOLF
      result.isWerewolf = true
    else
      result.uid = data.targetUser.uid
      result.pic = data.targetUser.pic
      result.picVer = data.targetUser.picVer.value
      result.name = UIUtil.FormatServerAllianceName(data.targetUser.sourceServerId, data.targetUser.abbr, data.targetUser.name)
      result.nameNeedLocal = false
    end
    result.enableClickInfo = true
  end
  return result
end

function MailScoutDetailHelper:GetWorldId(extData)
  local worldId = 0
  if not extData or not extData.targetType then
    return worldId
  end
  local point
  if extData.targetType == ScoutMailTargetType.ALLIANCE_CITY then
    point = extData.targetAllianceCity and extData.targetAllianceCity.point
  elseif extData.targetType == ScoutMailTargetType.DRAGON_BUILDING then
    point = extData.targetAllianceCity and extData.targetAllianceCity.point
  elseif extData.targetType == ScoutMailTargetType.WINTER_STORM_BUILDING then
    point = extData.winterStormBuild and extData.winterStormBuild.point
  elseif extData.targetType == ScoutMailTargetType.EPIDEMIC_BUILDING then
    point = extData.quarantineBuilding and extData.quarantineBuilding.point
  elseif extData.targetType == ScoutMailTargetType.BUILDING then
    if extData.playerSeasonBuild == nil or string.IsNullOrEmpty(extData.playerSeasonBuild.name) then
      point = extData.targetUser and extData.targetUser.point
    else
      point = extData.playerSeasonBuild and extData.playerSeasonBuild.point
    end
  elseif extData.targetType == ScoutMailTargetType.ALLIANCE_BUILD then
    point = extData.targetAllianceBuild and extData.targetAllianceBuild.point
  elseif extData.targetType == ScoutMailTargetType.CITY_STRONGHOLD and extData.scoutCityStronghold then
    point = extData.scoutCityStronghold and extData.scoutCityStronghold.point
  elseif extData.targetType == ScoutMailTargetType.CITY_OUTPOST and extData.scoutOutpost then
    point = extData.scoutOutpost and extData.scoutOutpost.point
  elseif extData.targetType == ScoutMailTargetType.CITY_TRADE and extData.scoutCityTrade then
    point = extData.scoutCityTrade and extData.scoutCityTrade.point
  elseif extData.targetType == ScoutMailTargetType.DESERT then
    point = extData.targetDesert and extData.targetDesert.point
  elseif extData.targetType == ScoutMailTargetType.ZWL_BUILDING then
    point = extData.zwlBuilding and extData.zwlBuilding.point
  else
    point = extData.targetUser and extData.targetUser.point
  end
  if point and point.worldId then
    worldId = point.worldId.value
  end
  return worldId
end

return MailScoutDetailHelper
