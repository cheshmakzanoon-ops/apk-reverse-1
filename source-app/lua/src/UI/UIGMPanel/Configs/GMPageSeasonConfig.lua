local GMPageStyle = require("UI.UIGMPanel.Configs.GMPageStyle")
local GMPageConfig = require("UI.UIGMPanel.Configs.GMPageConfig")
local config = GMPageConfig.New("SeasonDebug")
config.style = GMPageStyle.PageTemplate.Vertical
config.order = 2000
config.label = "\232\181\155\229\173\163"
config.icon = "Assets/Main/Sprites/UI/GMPanel/gmIconSeason.png"

local function _getBaseInfo()
  local sb = StringBuilder.New()
  sb:AppendLine(DataCenter.SeasonDataManager:Description())
  sb:AppendLine("======\231\142\139\229\186\167\228\191\161\230\129\175======")
  sb:AppendLineFormat("\233\187\145\229\156\159\230\152\175\229\144\166\231\148\159\230\149\136:%s, (IsBlackLandActive)", tostring(SceneUtils.IsBlackLandActive()))
  sb:AppendLine("")
  local seasonInfo = DataCenter.SeasonDataManager:GetUserSeasonInfo()
  local serverType = seasonInfo and seasonInfo:GetServerType(false) or 0
  local serverSubdivisionType = seasonInfo and seasonInfo:GetServerSubdivisionType(false) or 0
  local seasonTypeName = "\230\156\170\231\159\165"
  if serverSubdivisionType == SeasonMapType.NineNation then
    seasonTypeName = "S5(NineNation)"
  elseif serverSubdivisionType == SeasonMapType.NineNationRainforest then
    seasonTypeName = "S6(NineNationRainforest)"
  end
  sb:AppendLineFormat("\228\185\157\229\174\171\229\156\176\229\155\190\232\181\155\229\173\163\231\177\187\229\158\139:%s (%s)", serverSubdivisionType, seasonTypeName)
  sb:AppendLineFormat("\228\185\157\229\174\171\229\156\176\229\155\190\230\168\161\229\188\143:%s", tostring(SeasonUtil.IsInSeasonNineNationMode(true)))
  if SeasonUtil.IsInSeasonNineNationMode(true) then
    local loginServerId = LuaEntry.Player:GetSelfServerId()
    local mapIndex = DataCenter.SeasonDataManager:GetNinePalacesIndex(loginServerId)
    sb:AppendLineFormat("mapIndex:%s", mapIndex)
    if mapIndex == 5 then
      sb:AppendLineFormat("isFighting:%s", DataCenter.SeasonNineKingManager:IsFighting(loginServerId))
    end
  end
  sb:AppendLine("")
  sb:AppendLineFormat("\230\156\172\230\156\141\231\142\139\229\186\167\228\191\161\230\129\175:")
  sb:AppendLine(DataCenter.GovernmentManager:Description())
  sb:AppendLineFormat("\232\183\168\230\156\141\231\142\139\229\186\167\228\191\161\230\129\175:")
  sb:AppendLine(DataCenter.ZoneWarManager:Description())
  sb:AppendLine("")
  sb:AppendLine("======\233\152\181\232\144\165\230\136\152\228\186\137\228\191\161\230\129\175======")
  sb:AppendLine(DataCenter.SeasonFactionWarDataManager:Description())
  return sb:ToString()
end

config:Add({
  name = "\230\159\165\231\156\139\232\181\155\229\173\163\228\191\161\230\129\175",
  icon = "Assets/Main/Sprites/UI/LWCommon/Sprite/cfm_common_anniu_jilu.png",
  style = GMPageStyle.ItemTemplate.ButtonRenderer,
  tips = function()
    local str = _getBaseInfo()
    UIUtil.ShowDetail(str, nil, nil, true, true)
  end,
  onClicked = function()
    UIUtil.ShowTips("\229\183\178\229\164\141\229\136\182\229\136\176\229\137\170\232\180\180\230\157\191")
    CommonUtil.CopyTextToClipboard(_getBaseInfo())
  end,
  btnName = "\229\164\141\229\136\182"
})
config:Add({
  name = "s6\233\152\181\232\144\165\229\174\163\230\136\152",
  icon = "Assets/Main/Sprites/UI/LWCommon/Sprite/zyf_zhanbao_duikangicon.png",
  style = GMPageStyle.ItemTemplate.ButtonRenderer,
  tips = function()
    local str = DataCenter.SeasonCampDestroyManager:Description()
    UIUtil.ShowDetail(str, nil, nil, true, true)
  end,
  onClicked = function()
    UIUtil.ShowTips("\229\183\178\229\164\141\229\136\182\229\136\176\229\137\170\232\180\180\230\157\191")
    CommonUtil.CopyTextToClipboard(DataCenter.SeasonCampDestroyManager:Description())
  end,
  btnName = "\229\164\141\229\136\182"
})
config:Add({
  name = "\233\152\181\232\144\165\229\159\142\229\184\130\231\187\159\232\174\161",
  icon = "Assets/Main/Sprites/UI/GMPanel/gmIconSeason.png",
  style = GMPageStyle.ItemTemplate.ButtonRenderer,
  tips = function()
    local str = DataCenter.WorldAllianceCityDataManager:Description()
    UIUtil.ShowDetail(str, nil, nil, true, true)
    return str
  end,
  onClicked = function()
    local str = DataCenter.WorldAllianceCityDataManager:Description()
    UIUtil.ShowTips("\229\183\178\229\164\141\229\136\182\229\136\176\229\137\170\232\180\180\230\157\191")
    CommonUtil.CopyTextToClipboard(str)
  end,
  btnName = "\229\164\141\229\136\182"
})
config:Add({
  name = "\230\152\190\231\164\186\230\178\153\233\177\188\232\161\140\229\134\155\231\186\191",
  icon = "Assets/Main/Sprites/HeroIconsBig/mjc_S3_touxiang_jushachong.png",
  style = GMPageStyle.ItemTemplate.ToggleRenderer,
  get = function()
    return GMUtils.GetBool(GMConst.DebugSandFishTroopLineEnable, false)
  end,
  set = function(val)
    GMUtils.SetBool(GMConst.DebugSandFishTroopLineEnable, val)
    UIUtil.ShowTips(val and "\230\178\153\233\177\188\232\161\140\229\134\155\231\186\191\229\188\128\229\144\175" or "\230\178\153\233\177\188\232\161\140\229\134\155\231\186\191\229\133\179\233\151\173")
  end
})
config:Add({
  name = "\230\137\147\229\188\128\230\140\135\229\174\154\232\129\148\231\155\159\231\155\184\229\134\140",
  icon = "Assets/Main/Sprites/ItemIcons/icon_kelongxinpian_1.png",
  style = GMPageStyle.ItemTemplate.InputRenderer,
  tips = function()
    local sb = StringBuilder.New()
    sb:AppendLine("[\230\137\147\229\188\128\232\181\155\229\173\163\231\155\184\229\134\140]")
    sb:AppendLine("\194\183\232\190\147\229\133\165\232\181\155\229\173\163id\229\146\140\232\129\148\231\155\159id\229\143\175\228\187\165\230\159\165\231\156\139\230\137\128\229\156\168\229\185\179\229\143\176\229\133\168\230\156\141\231\154\132\228\187\187\230\132\143\231\155\184\229\134\140")
    sb:AppendLine("\194\183\232\190\147\229\133\165\230\160\188\229\188\143\239\188\154\232\181\155\229\173\163\229\186\143\229\143\183(1,2,3,4,5...);\232\129\148\231\155\159\229\148\175\228\184\128id(\228\184\128\229\160\134\229\173\151\231\172\166\228\184\178)")
    sb:AppendLine("\194\183\229\166\130\239\188\1543;a4ffb117903a4875bdb2d7687b1d34bc")
    sb:AppendLine("\194\183\229\166\130\228\189\149\229\143\141\229\164\141\230\137\147\229\188\128\231\155\184\229\134\140\239\188\154\231\130\185\229\135\187\232\190\147\229\133\165\230\161\134\239\188\140\229\134\141\231\130\185\229\135\187\229\133\182\228\187\150\229\156\176\230\150\185\229\143\150\230\182\136\232\190\147\229\133\165\230\161\134\233\128\137\228\184\173\228\184\186\228\184\128\230\172\161\231\161\174\232\174\164\230\147\141\228\189\156")
    UIUtil.ShowDetail(sb:ToString(), nil, nil, true, true)
  end,
  get = function()
    return DataCenter.SeasonPhotoManager.GMParam or "3;a4ffb117903a4875bdb2d7687b1d34bc"
  end,
  set = function(val)
    DataCenter.SeasonPhotoManager.GMParam = val
    if string.IsNullOrEmpty(val) then
      return
    end
    local params = string.split(val, ";")
    local season = params[1] and tonumber(params[1])
    local allianceId = params[2]
    if season and allianceId then
      UIManager:GetInstance():DestroyWindow(UIWindowNames.UIGMPanel)
      UIManager:GetInstance():OpenWindow(UIWindowNames.SeasonPhotoCanvaShare, {anim = true}, season, allianceId)
    else
      UIUtil.ShowTips("\231\155\184\229\134\140\232\190\147\229\133\165\230\160\188\229\188\143\233\148\153\232\175\175\239\188\140\232\175\183\230\159\165\231\156\139\229\184\174\229\138\169\230\143\144\231\164\186")
    end
  end,
  contentType = 0
})
config:Add({
  name = "\232\129\148\231\155\159\231\155\184\229\134\140\230\152\190\231\164\186\231\189\145\230\160\188\230\140\137\233\146\174",
  icon = "Assets/Main/Sprites/ItemIcons/icon_kelongxinpian_2.png",
  style = GMPageStyle.ItemTemplate.ToggleRenderer,
  tips = function()
    local sb = StringBuilder.New()
    sb:AppendLine("[\232\181\155\229\173\163\231\155\184\229\134\140\231\189\145\230\160\188\230\140\137\233\146\174]")
    sb:AppendLine("\229\139\190\233\128\137\229\144\142\239\188\140\232\181\155\229\173\163\231\155\184\229\134\140\229\143\179\228\184\139\232\167\146\230\152\190\231\164\186\231\189\145\230\160\188\230\140\137\233\146\174\239\188\140\231\130\185\229\135\187\229\143\175\228\187\165\230\152\190\231\164\186\231\172\155\229\141\161\229\176\148\229\157\144\230\160\135\229\146\140\231\189\145\230\160\188\230\150\185\228\190\191\232\175\134\229\136\171\229\157\144\230\160\135\228\189\141\231\189\174")
    UIUtil.ShowDetail(sb:ToString(), nil, nil, true, true)
  end,
  get = function()
    return Setting:GetPrivateBool("GM_PHOTO_SHOW_GRID_BTN", false)
  end,
  set = function(val)
    Setting:SetPrivateBool("GM_PHOTO_SHOW_GRID_BTN", val)
    UIUtil.ShowTips(val and "\230\152\190\231\164\186\231\155\184\229\134\140\231\189\145\230\160\188\230\140\137\233\146\174" or "\233\154\144\232\151\143\231\155\184\229\134\140\231\189\145\230\160\188\230\140\137\233\146\174")
  end
})
local delayTimer
config:Add({
  name = "S1\229\164\169\230\176\148\233\154\143\230\156\186\229\136\135\230\141\162\229\129\135\230\149\176\230\141\174",
  icon = "Assets/Main/Sprites/UI/UISeason/UISeason1/Weather/mjc_S1YH_tianqi_icon_yu.png",
  style = GMPageStyle.ItemTemplate.ButtonRenderer,
  onClicked = function()
    local GetSeasonWeatherInfoMessage = require("Net.Msgs.Season.GetSeasonWeatherInfoMessage")
    local t = GetSeasonWeatherInfoMessage:GetTestData()
    local weatherId = t.curWeather.weatherId
    local info = weatherId and DataCenter.SeasonWeatherManager:GetWeatherTypeInfo(weatherId)
    if info then
      UIUtil.ShowTips(string.format("5\231\167\146\229\144\142\229\136\135\230\141\162\229\136\176\229\164\169\230\176\148\239\188\154%s", CS.GameEntry.Localization:GetString(info.name)))
      if delayTimer ~= nil then
        delayTimer:Stop()
      end
      delayTimer = TimerManager:GetInstance():DelayInvoke(function()
        if GetSeasonWeatherInfoMessage then
          GetSeasonWeatherInfoMessage:HandleMessage(t)
        end
      end, 5)
    end
  end,
  btnName = "\229\136\135\230\141\162\229\164\169\230\176\148"
})
config:Add({
  name = "S1\229\164\169\230\176\148\231\166\129\231\148\168",
  style = GMPageStyle.ItemTemplate.ToggleRenderer,
  icon = "Assets/Main/Sprites/UI/UISeason/UISeason1_Remote/Weather/zxl_s1_tianqi_yu.png",
  get = function()
    return GMUtils.GetBool(GMConst.DisableSeasonWeather)
  end,
  set = function(val)
    GMUtils.SetBool(GMConst.DisableSeasonWeather, val)
    DataCenter.GMManager:DisableSeasonWeather(val)
  end
})
config:Add({
  name = "\230\137\147\229\188\128\230\159\165\232\175\162\230\156\141\229\138\161\229\153\168world\233\152\187\230\140\161",
  icon = "Assets/Main/Sprites/HeroIconsBig/mjc_S3_touxiang_jushachong.png",
  style = GMPageStyle.ItemTemplate.ButtonRenderer,
  onClicked = function()
    local gmWindow = UIManager:GetInstance():GetWindow(UIWindowNames.UIGMBar)
    if gmWindow then
      gmWindow.View:StartDebugWorldBlockInfo()
    end
    UIUtil.ShowTips("\230\137\147\229\188\128")
    UIManager:GetInstance():DestroyWindow(UIWindowNames.UIGMPanel)
  end,
  btnName = "\229\188\128\229\167\139\229\143\145\233\128\129\230\181\139\232\175\149\230\182\136\230\129\175"
})
config:Add({
  name = "S1\233\162\132\231\131\173\230\156\159\232\128\129\228\184\150\231\149\140boss\232\153\154\229\188\177\231\138\182\230\128\129",
  style = GMPageStyle.ItemTemplate.ToggleRenderer,
  icon = "Assets/Main/Sprites/ItemIcons/Common_icon_war_fever.png",
  get = function()
    local actBoss = DataCenter.LWSeasonBossLoginDataManager:GetBossData()
    if actBoss then
      return actBoss.monsterJson.state == 1
    end
    return false
  end,
  set = function(val)
    local actBoss = DataCenter.LWSeasonBossLoginDataManager:GetBossData()
    if actBoss then
      actBoss.monsterJson.state = val and 1 or 0
      local troop = CS.SceneManager.World:GetTroop(actBoss.uuid)
      if troop then
        troop:GetMarchInfo().actBossState = val and 1 or 0
      end
    end
  end
})
config:Add({
  name = "S1\233\162\132\231\131\173\230\156\159\232\181\155\229\173\163\228\184\150\231\149\140boss\232\153\154\229\188\177\231\138\182\230\128\129",
  style = GMPageStyle.ItemTemplate.ToggleRenderer,
  icon = "Assets/Main/Sprites/ItemIcons/Common_icon_war_fever.png",
  get = function()
    local _, seasonBoss = DataCenter.LWSeasonBossLoginDataManager:GetBossData()
    if seasonBoss then
      return seasonBoss.monsterJson.state == 1
    end
    return false
  end,
  set = function(val)
    local _, seasonBoss = DataCenter.LWSeasonBossLoginDataManager:GetBossData()
    if seasonBoss then
      seasonBoss.monsterJson.state = val and 1 or 0
      local troop = CS.SceneManager.World:GetTroop(seasonBoss.uuid)
      if troop then
        troop:GetMarchInfo().actBossState = val and 1 or 0
      end
    end
  end
})
config:Add({
  name = "S5 \230\153\182\233\135\145\229\149\134\229\186\151\228\184\141\233\156\128\232\166\129\229\187\186\231\173\145",
  style = GMPageStyle.ItemTemplate.ToggleRenderer,
  icon = "Assets/Main/Sprites/ItemIcons/LXY_s5_jinjiejing_icon.png",
  get = function()
    return GMUtils.GetBool(GMConst.S5BountyShopDontCheckBuilding)
  end,
  set = function(val)
    GMUtils.SetBool(GMConst.S5BountyShopDontCheckBuilding, val)
  end
})
config:Add({
  name = "\230\181\139\232\175\149\229\189\147\229\137\141\229\134\133\229\164\150\229\159\142\230\152\175\229\144\166\229\140\133\229\144\171APS_Old\232\181\132\230\186\144",
  style = GMPageStyle.ItemTemplate.ButtonRenderer,
  icon = "Assets/Main/Sprites/HeroIconsBig/mjc_S3_touxiang_jushachong.png",
  onClicked = function()
    local line = LocalController:instance():visitTable(TableName.World_Skin, function(id, lineData)
      local city_deco_bytePath = lineData:getValue("city_deco")
      if not string.IsNullOrEmpty(city_deco_bytePath) then
        local mapTools = CS.GameKit.Editor.ArtTools.Command.TerrainMapGenerateCommand
        mapTools.HasAPS_OldRes_CityDecoByte(city_deco_bytePath)
      end
      return false
    end)
  end,
  btnName = "\229\188\128\229\167\139\230\181\139\232\175\149"
})
config:Add({
  name = "\229\173\144\229\188\185\229\176\132\229\135\187PVP\229\188\186\229\136\182\229\133\179\229\141\161",
  style = GMPageStyle.ItemTemplate.InputRenderer,
  icon = "Assets/Main/MiniGameRes/BiuBiu/Sprites/UI/zxl_miaozhun_zidan.png",
  get = function()
    return DataCenter.LWBiuBiuDataManager.GMParam or ""
  end,
  set = function(val)
    DataCenter.LWBiuBiuDataManager.GMParam = val
  end
})
config:Add({
  name = "\228\184\139100\229\177\130PVP\229\188\186\229\136\182\229\133\179\229\141\161",
  style = GMPageStyle.ItemTemplate.InputButtonRenderer,
  icon = "Assets/Main/MiniGameRes/GGGo/Textures/plat_bounce.png",
  tips = function()
    local sb = StringBuilder.New()
    sb:AppendLine("[\228\184\139100\229\177\130PVP\229\188\186\229\136\182\229\133\179\229\141\161]")
    sb:AppendLine("\232\190\147\229\133\165 season_game_cave_exploration\233\133\141\231\189\174id \229\143\175\230\140\135\229\174\154\229\136\155\229\187\186PVP\230\136\191\233\151\180\230\151\182\228\189\191\231\148\168\231\154\132\229\133\179\229\141\161\233\133\141\231\189\174id,\228\184\128\232\136\172\232\190\147\229\133\1653000")
    sb:AppendLine("\230\184\133\231\169\186\232\190\147\229\133\165\230\161\134\230\129\162\229\164\141\233\187\152\232\174\164\229\133\179\229\141\161\229\140\185\233\133\141")
    UIUtil.ShowDetail(sb:ToString(), nil, nil, true, true)
  end,
  get = function()
    return DataCenter.LWGGGoDataManager.GMParam or ""
  end,
  set = function(val)
    DataCenter.LWGGGoDataManager.GMParam = val
  end,
  onClicked = function(val)
    DataCenter.LWGGGoDataManager.GMParam = val
    DataCenter.LWGGGoDataManager:OpenActitiy()
    UIManager:GetInstance():DestroyWindow(UIWindowNames.UIGMPanel)
  end,
  btnName = "\230\137\147\229\188\128\230\180\187\229\138\168"
})
config:Add({
  name = "\229\144\140\231\155\159\230\138\128\232\131\189-\230\136\152\228\186\137\233\163\158\229\188\185",
  style = GMPageStyle.ItemTemplate.InputButtonRenderer,
  icon = "Assets/Main/MiniGameRes/BiuBiu/Sprites/UI/zxl_miaozhun_zidan.png",
  tips = nil,
  get = function()
    return ""
  end,
  set = function(val)
  end,
  onClicked = function(val)
    local skill = DataCenter.AllianceGovernmentCommonSkillManager:GetSkillBySkillFlag(AlOfficialSkillType.AresMissile)
    skill.logic:PreUse()
    GMUtils.Close()
  end,
  btnName = "\233\135\138\230\148\190"
})
config:Add({
  name = "\229\144\140\231\155\159\230\138\128\232\131\189-\231\163\129\230\154\180\231\186\191\229\156\136",
  style = GMPageStyle.ItemTemplate.InputButtonRenderer,
  icon = "Assets/Main/MiniGameRes/BiuBiu/Sprites/UI/zxl_miaozhun_zidan.png",
  tips = nil,
  get = function()
    return ""
  end,
  set = function(val)
  end,
  onClicked = function(val)
    local skill = DataCenter.AllianceGovernmentCommonSkillManager:GetSkillBySkillFlag(AlOfficialSkillType.TeslaCoil)
    skill.logic:PreUse()
    GMUtils.Close()
  end,
  btnName = "\233\135\138\230\148\190"
})
config:Add({
  name = "\229\144\140\231\155\159\230\138\128\232\131\189-\229\138\160\229\155\186\233\135\138\230\148\190",
  style = GMPageStyle.ItemTemplate.InputButtonRenderer,
  icon = "Assets/Main/MiniGameRes/BiuBiu/Sprites/UI/zxl_miaozhun_zidan.png",
  tips = nil,
  get = function()
    return ""
  end,
  set = function(val)
  end,
  onClicked = function(val)
    local skill = DataCenter.AllianceGovernmentCommonSkillManager:GetSkillBySkillFlag(AlOfficialSkillType.Reinforcement)
    skill.logic:PreUse()
    GMUtils.Close()
  end,
  btnName = "\233\135\138\230\148\190"
})
config:Add({
  name = "\229\144\140\231\155\159\230\138\128\232\131\189-\230\156\168\228\185\131\228\188\138\229\143\172\229\148\164",
  style = GMPageStyle.ItemTemplate.InputButtonRenderer,
  icon = "Assets/Main/MiniGameRes/BiuBiu/Sprites/UI/zxl_miaozhun_zidan.png",
  tips = nil,
  get = function()
    return ""
  end,
  set = function(val)
  end,
  onClicked = function(val)
    local skill = DataCenter.AllianceGovernmentCommonSkillManager:GetSkillBySkillFlag(AlOfficialSkillType.GoddessMummy)
    skill.logic:PreUse()
    GMUtils.Close()
  end,
  btnName = "\233\135\138\230\148\190"
})
config:Add({
  name = "\229\144\140\231\155\159\230\138\128\232\131\189-\229\136\183\230\150\176\231\144\131",
  style = GMPageStyle.ItemTemplate.InputButtonRenderer,
  icon = "Assets/Main/MiniGameRes/BiuBiu/Sprites/UI/zxl_miaozhun_zidan.png",
  tips = nil,
  get = function()
    return ""
  end,
  set = function(val)
  end,
  onClicked = function(val)
    local skill = DataCenter.AllianceGovernmentCommonSkillManager:GetSkillBySkillFlag(AlOfficialSkillType.RefreshBall)
    skill.logic:PreUse()
    GMUtils.Close()
  end,
  btnName = "\233\135\138\230\148\190"
})
config:Add({
  name = "\229\144\140\231\155\159\230\138\128\232\131\189-\228\186\148\232\176\183\228\184\176\231\153\187",
  style = GMPageStyle.ItemTemplate.InputButtonRenderer,
  icon = "Assets/Main/MiniGameRes/BiuBiu/Sprites/UI/zxl_miaozhun_zidan.png",
  tips = nil,
  get = function()
    return ""
  end,
  set = function(val)
  end,
  onClicked = function(val)
    local skill = DataCenter.AllianceGovernmentCommonSkillManager:GetSkillBySkillFlag(AlOfficialSkillType.AbundantHarvest)
    skill.logic:PreUse()
    GMUtils.Close()
  end,
  btnName = "\233\135\138\230\148\190"
})
config:Add({
  name = "S6 \230\137\147\229\188\128\229\134\155\232\161\148\229\141\135\231\186\167\233\161\181\233\157\162",
  style = GMPageStyle.ItemTemplate.InputButtonRenderer,
  icon = "Assets/Main/SeasonRes/S6/Sprites/Military/ljq_s6junxian_01_banner.png",
  get = function()
    return 1
  end,
  set = function(val)
  end,
  onClicked = function(val)
    local level = checknumber(val)
    local cell = DataCenter.SeasonMilitaryManager:GetLevelCellTmp(level)
    if cell ~= nil then
      UIManager:GetInstance():DestroyWindow(UIWindowNames.UIGMPanel)
      local param = {}
      param.Level = level
      UIManager:GetInstance():OpenWindow(UIWindowNames.S6MilitaryLevelUp, {anim = true}, param)
    else
      local maxLevel = DataCenter.SeasonMilitaryManager:GetMaxLevel()
      UIUtil.ShowTips(string.format("\228\188\188\228\185\142\230\178\161\230\156\137\232\191\153\228\184\170\231\173\137\231\186\167\231\154\132\229\134\155\232\161\148\229\145\162, level: [1, %s]", maxLevel))
    end
  end,
  contentType = 2,
  btnName = "\229\129\135\232\163\133\229\141\135\231\186\167"
})
config:Add({
  name = "S6 \229\134\155\229\138\159\229\149\134\229\186\151\229\129\135\229\134\155\232\161\148",
  style = GMPageStyle.ItemTemplate.InputButtonRenderer,
  icon = "Assets/Main/SeasonRes/S6/Sprites/Military/ljq_s6junxian_icon_jungong.png",
  get = function()
    return GMUtils.GetInt(GMConst.MilitaryFakeLevel, -1)
  end,
  set = function(val)
    GMUtils.SetInt(GMConst.MilitaryFakeLevel, checknumber(val))
    UIUtil.ShowTips("\232\174\190\231\189\174\229\129\135\229\134\155\232\161\148 " .. val)
  end,
  tips = function()
    local sb = StringBuilder.New()
    sb:AppendLine("\229\143\170\229\189\177\229\147\141\229\134\155\229\138\159\229\149\134\229\186\151\231\154\132\232\167\163\233\148\129\229\136\164\230\150\173")
    sb:AppendLine("\232\190\147\229\133\165\229\164\167\228\186\142 0 \231\154\132\230\149\176\229\173\151\239\188\140\229\176\134\228\188\154\229\156\168\229\149\134\229\147\129\232\167\163\233\148\129\229\136\164\230\150\173\230\151\182\232\166\134\231\155\150\231\156\159\229\174\158\229\134\155\232\161\148")
    sb:AppendLine("\232\190\147\229\133\165 \229\176\143\228\186\142\231\173\137\228\186\142 0 \233\135\141\231\189\174")
    sb:AppendLine("\230\150\135\230\156\172\230\161\134\229\164\177\229\142\187\231\132\166\231\130\185\229\141\179\228\191\157\229\173\152\230\136\144\229\138\159")
    sb:AppendLine()
    sb:AppendLine("\231\130\185\229\135\187\230\140\137\233\146\174\230\184\133\233\153\164\229\134\155\229\138\159\229\149\134\229\186\151\230\150\176\233\129\147\229\133\183\229\188\185\231\170\151\229\137\141\231\171\175\230\160\135\232\174\176")
    UIUtil.ShowDetail(sb:ToString(), nil, nil, true, true)
  end,
  onClicked = function(val)
    CommonUtil.PlayerPrefsSetString("bounty_shop_valid_shop_cache_key", "")
    UIUtil.ShowTips("\230\184\133\233\153\164\229\134\155\229\138\159\229\149\134\229\186\151\230\150\176\233\129\147\229\133\183\229\188\185\231\170\151\229\137\141\231\171\175\230\160\135\232\174\176")
  end,
  contentType = 2,
  btnName = "\230\184\133\233\153\164\230\160\135\232\174\176"
})
config:Add({
  name = "S6 \229\134\155\232\161\148\232\180\184\230\152\147\230\136\152\229\136\134\233\133\141\230\160\135\232\174\176",
  style = GMPageStyle.ItemTemplate.ButtonRenderer,
  icon = "Assets/Main/SeasonRes/S6/Sprites/Military/ljq_s6junxian_rukou.png",
  onClicked = function(val)
    CommonUtil.PlayerPrefsSetBool(SettingKeys.S6_MILITARY_TREND_POPUP_SHOWN, false)
    UIManager:GetInstance():DestroyWindow(UIWindowNames.UIGMPanel)
  end,
  btnName = "\230\184\133\233\153\164\230\160\135\232\174\176"
})
return config
