local MailParseHelper = {}
local base64 = require("Framework.Common.base64")
local MailBattleReport = require("DataCenter.MailData.DataExtModule.MailBattleReport")
local MailChampionBattleReport = require("DataCenter.MailData.DataExtModule.MailChampionBattleReport")
local MailScoutReport = require("DataCenter.MailData.DataExtModule.MailScoutReport")
local MailLandmineReport = require("DataCenter.MailData.DataExtModule.MailLandmineReport")
local MailDisguiseReport = require("DataCenter.MailData.DataExtModule.MailDisguiseReport")
local MailPickGarbage = require("DataCenter.MailData.DataExtModule.MailPickGarbage")
local MailExplore = require("DataCenter.MailData.DataExtModule.MailExplore")
local MailDestroyBuild = require("DataCenter.MailData.DataExtModule.MailDestroyBuild")
local MailDestroyRankList = require("DataCenter.MailData.DataExtModule.MailDestroyRankList")
local MailTranslationRating = require("DataCenter.MailData.DataExtModule.MailTranslationRating")
local MailZombieRush = require("DataCenter.MailData.DataExtModule.MailZombieRush")
local MailBreakIceReport = require("DataCenter.MailData.DataExtModule.MailBreakIceReport")
local MailWeatherReport = require("DataCenter.MailData.DataExtModule.MailWeatherReport")
local MailSurfingBattle = require("DataCenter.MailData.DataExtModule.MailSurfingBattle")
local MailBankReport = require("DataCenter.MailData.DataExtModule.MailBankReport")
local Localization = CS.GameEntry.Localization
local rapidjson = require("rapidjson")

function MailParseHelper.ParseContent(mailData)
  if BattleReportMailType[mailData.type] then
    local ext = MailBattleReport.New()
    ext:ParseContent(mailData:GetMailSFSObj(), mailData.type)
    return ext
  elseif mailData.type == MailType.MAIL_BOSS_REWARD then
  elseif IsMailScoutType(mailData.type) or mailData.type == MailType.LW_SEASON_SCOUT_MAIL then
    local ext = MailScoutReport.New()
    ext:ParseContent(mailData:GetMailSFSObj())
    return ext
  elseif mailData.type == MailType.MAIL_PICK_GARBAGE then
    local ext = MailPickGarbage.New()
    ext:ParseContent(mailData:GetMailSFSObj())
    return ext
  elseif mailData.type == MailType.MAIL_EXPLORE then
    local ext = MailExplore.New()
    ext:ParseContent(mailData:GetMailSFSObj())
    return ext
  elseif mailData.type == MailType.MARCH_DESTROY_MAIL then
    local ext = MailDestroyBuild.New()
    ext:ParseContent(mailData:GetMailSFSObj())
    return ext
  elseif mailData.type == MailType.ALLIANCE_CITY_RANK then
    local ext = MailDestroyRankList.New()
    ext:ParseContent(mailData:GetMailSFSObj())
    return ext
  elseif mailData.type == MailType.MAIL_ALCOMPETE_WEEK_REPORT then
  elseif mailData.type == MailType.RESOURCE_HELP_FROM or mailData.type == MailType.RESOURCE_HELP_TO or mailData.type == MailType.RESOURCE_HELP_FAIL then
  elseif mailData.type == MailType.MAIL_ALLIANCE_MARK_ADD then
  elseif mailData.type == MailType.ELITE_FIGHT_MAIL then
    local ext = MailChampionBattleReport.New()
    ext:ParseContent(mailData:GetMailSFSObj())
    return ext
  elseif mailData.type == MailType.Automatic_TranslationRating or mailData.type == MailType.TranslationRating then
    local ext = MailTranslationRating.New()
    ext:ParseContent(mailData:GetMailHeader())
    return ext
  elseif mailData.type == MailType.LW_ZOMBIE_RUSH_ALLIANCE_MAIL then
    local ext = MailZombieRush.New()
    ext:ParseContent(mailData:GetMailSFSObj())
    return ext
  elseif mailData.type == MailType.LANDMINE then
    local ext = MailLandmineReport.New()
    ext:ParseContent(mailData:GetMailSFSObj())
    return ext
  elseif mailData.type == MailType.DISGUISE_ATTACK then
    local ext = MailDisguiseReport.New()
    ext:ParseContent(mailData:GetMailSFSObj())
    return ext
  elseif mailData.type == MailType.LW_SEASON_BREAK_ICE_MAIL then
    local ext = MailBreakIceReport.New()
    ext:ParseContent(mailData:GetMailSFSObj())
    return ext
  elseif mailData.type == MailType.LW_SEASON_WEATHER_MAIL then
    local ext = MailWeatherReport.New()
    ext:ParseContent(mailData:GetMailSFSObj())
    return ext
  elseif mailData.type == MailType.SURFING_BATTLE_REWARD then
    local ext = MailSurfingBattle.New()
    ext:ParseContent(mailData:GetMailSFSObj())
    return ext
  elseif mailData.type == MailType.SEASON_BANK then
    local ext = MailBankReport.New()
    ext:ParseContent(mailData:GetMailSFSObj())
    return ext
  else
    return nil
  end
end

local function GetParam(self, message, index)
  if message == nil then
    return nil
  end
  if message.dialog and message.dialog.params and message.dialog.params[index] then
    return message.dialog.params[index].text
  end
  return nil
end

local function GetMailParamTable(self, message, index)
  if message == nil then
    return nil
  end
  if message.dialog and message.dialog.params and message.dialog.params[index] then
    return message.dialog.params[index]
  end
  return nil
end

local function DecodeMessage(self, message, extra)
  if message == nil then
    return ""
  end
  local decode = ""
  if message.text ~= nil then
    decode = self:DecodeText(message.text)
  elseif message.dialog ~= nil then
    decode = self:DecodeDialog(message.dialog, extra)
  elseif message.worldAllianceCity ~= nil then
    decode = self:DecodeAllianceCity(message.worldAllianceCity)
  elseif message.worldAllianceBuild ~= nil then
    decode = self:DecodeAllianceBuild(message.worldAllianceBuild)
  elseif message.point ~= nil then
    decode = self:DecodePoint(message.point)
  elseif message.url ~= nil then
    decode = self:DecodeUrl(message.url)
  elseif message.user ~= nil then
    decode = self:DecodeUser(message.user)
  elseif message.alliance ~= nil then
    decode = self:DecodeAlliance(message.alliance)
  elseif message.monster ~= nil then
    decode = self:DecodeMonster(message.monster)
  elseif message.percent ~= nil then
    decode = self:DecodePercent(message.percent)
  elseif message.scout ~= nil then
    decode = self:DecodeScout(message.scout)
  elseif message.dateTime ~= nil then
    decode = self:DecodeDateTime(message.dateTime)
  elseif message.textWithParams ~= nil then
    decode = self:DecodeTextWithParams(message.textWithParams)
  elseif message.integerWithSpearated ~= nil then
    decode = self:DecodeIntegerWithSpearated(message.integerWithSpearated)
  elseif message.minePlunderInfo then
    decode = self:DecodeMinePlunderInfo(message.minePlunderInfo)
  elseif message.worldDesert then
    decode = self:DecodeWorldDesert(message.worldDesert)
  elseif message.worldCityStronghold then
    decode = self:DecodeWorldCityStronghold(message.worldCityStronghold)
  elseif message.worldCityAttachment then
    decode = self:DecodeWorldCityAttachment(message.worldCityAttachment)
  elseif message.effect then
    decode = self:DecodeEffect(message.effect)
  elseif message.dragonBuilding then
    decode = self:DecodeBattleField(message.dragonBuilding, BattleFieldType.Desert)
  elseif message.winterStormBuilding then
    decode = self:DecodeBattleField(message.winterStormBuilding, BattleFieldType.WinterStorm)
  elseif message.quarantineBuilding then
    decode = self:DecodeBattleField(message.quarantineBuilding)
  elseif message.worldCityOutpost then
    decode = self:DecodeWorldCityOutpost(message.worldCityOutpost)
  else
    return ""
  end
  local color = ""
  if message.color ~= nil then
    if message.color == "RED" then
      color = "red"
    elseif message.color == "GREEN" then
      color = "#63AE46"
    end
  end
  if string.IsNullOrEmpty(color) then
    return decode
  else
    return "<color=" .. color .. ">" .. decode .. "</color>"
  end
end

local function DecodeText(self, text)
  if string.startswith(text, "YiBianJinQu_") then
    return Localization:GetString(text)
  end
  return text
end

local function DecodeEffect(self, data)
  local text = ""
  local effectStr = data.effectStr
  local index = 1
  for item in string.gmatch(effectStr, "([^|]+)|?") do
    local effectId, effectValue = string.match(item, "([^;]+);([^;]+)")
    if effectId ~= nil and effectValue ~= nil then
      local buffAddNum, effectName = UIUtil.GetEffectStr(nil, effectValue, effectId)
      if not string.IsNullOrEmpty(effectName) and not string.IsNullOrEmpty(buffAddNum) then
        local name = Localization:GetString(effectName)
        local indentText = CommonUtil.IsArabic() and ".<indent=-5%>" or ".<indent=3%>"
        text = text .. "<align=\"left\">" .. index .. indentText .. name .. "</align><b>" .. buffAddNum .. "</b></indent>\n"
        index = index + 1
      end
    end
  end
  return text
end

local function DecodeIntegerWithSpearated(self, data)
  local num = data.value
  return string.GetFormattedSeperatorNum(num)
end

local function DecodeMinePlunderInfo(self, data)
  local userName = data.userName
  local rewardType = data.rewardType
  local itemId = data.itemId
  local plunderRewardNum = data.plunderRewardNum
  local resName = DataCenter.RewardManager:GetNameByType(rewardType, itemId)
  return Localization:GetString("302228", userName, plunderRewardNum, resName)
end

local function DecodeTextWithParams(self, data)
  local text = data.text
  if string.IsNullOrEmpty(text) then
    return ""
  end
  if not table.IsNullOrEmpty(data.params) then
    for k, v in pairs(data.params) do
      local param = self:DecodeMessage(v)
      if not string.IsNullOrEmpty(param) then
        text = string.gsub(text, "{" .. k - 1 .. "}", param)
      end
    end
  end
  return text
end

function MailParseHelper:DecodeAllianceBuild(info)
  local buildId = info.id or 41000
  local level = info.level or 1
  local meta = DataCenter.AllianceMineManager:GetAllianceMineTemplate(buildId)
  if meta then
    return Localization:GetString(meta.name)
  end
  return ""
end

local function DecodeAllianceCity(self, info)
  local id = info.id or 0
  local name = info.cityName or ""
  if name == nil or name == "" then
    local buildId = toInt(id)
    if 10000 <= buildId then
      local template = DataCenter.DragonBuildTemplateManager:GetTemplate(buildId)
      if template then
        return Localization:GetString(template.name)
      end
    end
    name = GetTableData(TableName.WorldCity, buildId, "name")
    name = Localization:GetString(name)
  end
  return name
end

local function DecodeDialog(self, dialog, extra)
  local dialogId = dialog.id
  if string.IsNullOrEmpty(dialogId) then
    return ""
  end
  local params = {}
  if not table.IsNullOrEmpty(dialog.params) then
    for _, v in pairs(dialog.params) do
      local param = self:DecodeMessage(v)
      if not string.IsNullOrEmpty(param) then
        table.insert(params, param)
      else
        table.insert(params, "")
      end
    end
  end
  self:UseRemarkNameByExtra(dialogId, params, extra)
  self:TryChangeChallengeZombieAllianceMailDesc(dialogId, params)
  if not table.IsNullOrEmpty(params) then
    return Localization:GetString(dialogId, SafeUnpack(params))
  else
    return Localization:GetString(dialogId)
  end
end

local function UseRemarkNameByExtra(self, dialogId, params, extra)
  if extra == nil then
    return
  end
  if dialogId == "311021" then
    local arr = string.split(extra, ",")
    if #arr ~= 2 then
      return
    end
    local showName = DataCenter.PlayerInfoDataManager:GetRemarkOrRealName(arr[1], params[1])
    params[1] = showName
    showName = DataCenter.PlayerInfoDataManager:GetRemarkOrRealName(arr[2], params[2])
    params[2] = showName
    params[3] = showName
  end
end

local function TryChangeChallengeZombieAllianceMailDesc(self, dialogId, params)
  if dialogId == "challenge_zombie_alliance_mail_desc" and not table.IsNullOrEmpty(params) and table.count(params) >= 5 then
    local newValue = string.GetFormattedStr2(tonumber(params[1]))
    params[1] = newValue
    local newValue2 = string.GetFormattedStr2(tonumber(params[3]))
    params[3] = newValue2
  end
end

local function DecodePoint(self, point)
  local server = point.server
  local x = point.x
  local y = point.y
  local text = ""
  if server == LuaEntry.Player:GetSelfServerId() then
    text = Localization:GetString("310137", x, y)
  else
    text = Localization:GetString("128005", server, x, y)
  end
  local link = {
    action = "Jump",
    server = server,
    x = x,
    y = y
  }
  local json = rapidjson.encode(link)
  json = base64.encode(json)
  local ret = "<link=" .. json .. "><u>(" .. text .. ")</u></link>"
  return ret
end

local function DecodeUrl(self, url)
  local href = url.href or ""
  local text = url.text or href
  local link = {action = "Url", url = href}
  local json = rapidjson.encode(link)
  json = base64.encode(json)
  local ret = "<link=" .. json .. "><u>" .. text .. "</u></link>"
  return ret
end

local function DecodeUser(self, user)
  local abbr = user.abbr or ""
  local name = user.name or ""
  if string.IsNullOrEmpty(abbr) then
    return name
  end
  return "[" .. abbr .. "] " .. name
end

local function DecodeAlliance(self, alliance)
  local abbr = alliance.abbr or ""
  local name = alliance.name or ""
  if string.IsNullOrEmpty(abbr) and string.IsNullOrEmpty(name) then
    return Localization:GetString(240523)
  end
  return "[" .. abbr .. "] " .. name
end

local function DecodeMonster(self, monster)
  local id = monster.id or 0
  local level = GetTableData(LuaEntry.Player:GetABTestTableName(TableName.Monster), id, "level")
  local name = GetTableData(LuaEntry.Player:GetABTestTableName(TableName.Monster), id, "name")
  local special = GetTableData(LuaEntry.Player:GetABTestTableName(TableName.Monster), id, "special")
  if tonumber(special) == 2 then
    return Localization:GetString(name)
  end
  return Localization:GetString("310128", level, Localization:GetString(name))
end

local function DecodePercent(self, percent)
  if percent.intValue ~= nil then
    return percent.intValue .. "%"
  end
  if percent.doubleValue ~= nil then
    return string.format("%.2f", percent.doubleValue) .. "%"
  end
  return ""
end

local function DecodeScout(self, scout)
  if scout.target == "BASE" then
    return Localization:GetString("100618")
  elseif scout.target == "BUILDING" then
    local template = DataCenter.BuildTemplateManager:GetBuildingDesTemplate(scout.targetId)
    if template ~= nil then
      return Localization:GetString(template.name)
    end
    return ""
  elseif scout.target == "ARMY" then
    return Localization:GetString("300637")
  elseif scout.target == "ALLIANCE_CITY" then
    local name = scout.cityName or ""
    if name == nil or name == "" then
      name = GetTableData(TableName.WorldCity, scout.targetId, "name")
      name = Localization:GetString(name)
    end
    return name
  elseif scout.target == "DESERT" then
    local name = scout.targetId or ""
    if not string.IsNullOrEmpty(name) then
      local nameId = GetTableData(TableName.Desert, scout.targetId, "desert_name")
      name = Localization:GetString(nameId)
      local level = GetTableData(TableName.Desert, scout.targetId, "desert_level")
      if level and 0 < level then
        name = Localization:GetString("science_condition", level, name)
      else
        name = Localization:GetString("110245")
      end
    end
    return name
  end
  return ""
end

local function DecodeDateTime(self, time)
  if time.milliseconds ~= nil then
    return UITimeManager:GetInstance():TimeStampToTimeForLocal(time.milliseconds)
  end
  if time.seconds ~= nil then
    return UITimeManager:GetInstance():TimeStampToTimeForLocal(time.seconds)
  end
  if time.utcMilliseconds ~= nil then
    return UITimeManager:GetInstance():TimeStampToTimeForServer(time.utcMilliseconds)
  end
  if time.localMilliseconds ~= nil then
    return UITimeManager:GetInstance():ConvertServerTimeToLocalTime(time.localMilliseconds)
  end
  return ""
end

local function DecodeWorldDesert(self, desert)
  local desertId = desert.id
  local nameId = GetTableData(TableName.Desert, desertId, "desert_name")
  local name = Localization:GetString(nameId)
  local level = GetTableData(TableName.Desert, desertId, "desert_level")
  if level and 0 < level then
    name = Localization:GetString("science_condition", level, name)
  else
    name = Localization:GetString("110245")
  end
  return name
end

local function DecodeWorldCityOutpost(self, info)
  local cityId = toInt(info.id)
  local cityMeta = DataCenter.AllianceCityTemplateManager:GetTemplate(cityId)
  if cityMeta then
    return Localization:GetString(cityMeta.name)
  else
    Logger.LogError("\230\137\190\228\184\141\229\136\176\229\137\141\229\147\168\239\188\154" .. (cityId or "nil"))
  end
  return info.cityName or ""
end

local function DecodeWorldCityStronghold(self, info)
  local cityId = info.id
  local cityMeta = DataCenter.AllianceCityTemplateManager:GetTemplate(cityId)
  if cityMeta then
    return Localization:GetString(cityMeta.name)
  else
    Logger.LogError("\230\137\190\228\184\141\229\136\176\230\141\174\231\130\185\239\188\154" .. (cityId or "nil"))
  end
  return info.cityName or ""
end

local function DecodeWorldCityAttachment(self, info)
  local buildId = toInt(info.id)
  local buildData = DataCenter.SeasonFarmerTemplateManager:GetBuildTemplateById(buildId)
  if buildData then
    return Localization:GetString(buildData.name)
  else
    Logger.LogError("\230\137\190\228\184\141\229\136\176CityAttachment\239\188\154" .. (buildId or "nil"))
  end
  return "???"
end

local function DecodeBattleField(self, info, bfType)
  if bfType == nil then
    local battleSeasonConfig = toInt(info.battleConfigId)
    if battleSeasonConfig then
      bfType = BattleFieldUtil.GetSeasonConfigVal(battleSeasonConfig, BattleFieldTableKey.BATTLEFIELD_TYPE)
    end
  end
  if bfType then
    local buildId = toInt(info.id)
    local template = BattleFieldUtil.GetBuildTemplate(buildId, bfType)
    if template then
      return Localization:GetString(template.name)
    end
  end
  Logger.LogError("\230\137\190\228\184\141\229\136\176BattleFieldBuild-BuildId\239\188\154" .. (info.id or "nil") .. ",bfType\239\188\154" .. (bfType or "nil"))
  return "???"
end

local function CheckMailBattleReportIntegrity(mailUid, download)
  local mailInfo = DataCenter.MailDataManager:GetMailInfoById(mailUid)
  if mailInfo == nil then
    return false
  end
  local reportIntegrity = mailInfo:IsBattleReportIntegrity()
  if not reportIntegrity and download then
    mailInfo:DownloadBattleReport()
  end
  return reportIntegrity
end

MailParseHelper.DecodeAllianceCity = DecodeAllianceCity
MailParseHelper.DecodeMessage = DecodeMessage
MailParseHelper.DecodeText = DecodeText
MailParseHelper.DecodeEffect = DecodeEffect
MailParseHelper.DecodeTextWithParams = DecodeTextWithParams
MailParseHelper.DecodeMinePlunderInfo = DecodeMinePlunderInfo
MailParseHelper.DecodeDialog = DecodeDialog
MailParseHelper.UseRemarkNameByExtra = UseRemarkNameByExtra
MailParseHelper.DecodePoint = DecodePoint
MailParseHelper.DecodeUrl = DecodeUrl
MailParseHelper.DecodeUser = DecodeUser
MailParseHelper.DecodeAlliance = DecodeAlliance
MailParseHelper.DecodeMonster = DecodeMonster
MailParseHelper.DecodePercent = DecodePercent
MailParseHelper.DecodeScout = DecodeScout
MailParseHelper.DecodeDateTime = DecodeDateTime
MailParseHelper.DecodeIntegerWithSpearated = DecodeIntegerWithSpearated
MailParseHelper.DecodeWorldDesert = DecodeWorldDesert
MailParseHelper.DecodeWorldCityOutpost = DecodeWorldCityOutpost
MailParseHelper.DecodeWorldCityStronghold = DecodeWorldCityStronghold
MailParseHelper.DecodeWorldCityAttachment = DecodeWorldCityAttachment
MailParseHelper.DecodeBattleField = DecodeBattleField
MailParseHelper.GetParam = GetParam
MailParseHelper.GetMailParamTable = GetMailParamTable
MailParseHelper.CheckMailBattleReportIntegrity = CheckMailBattleReportIntegrity
MailParseHelper.TryChangeChallengeZombieAllianceMailDesc = TryChangeChallengeZombieAllianceMailDesc
return MailParseHelper
