local CommonRankItemShow = {
  uid = "",
  firstName = "",
  secondName = "",
  rank = -1,
  power = "",
  allianceName = "",
  icon = ""
}
local LWUISheepRankCtrl = BaseClass("LWUISheepRankCtrl", UIBaseCtrl)
local OneData = DataClass("OneData", CommonRankItemShow)
local Localization = CS.GameEntry.Localization

function LWUISheepRankCtrl:CloseSelf()
  UIManager:GetInstance():DestroyWindow(UIWindowNames.LWUISheepRank)
end

function LWUISheepRankCtrl:GetSheepRankList(type)
  local showList = {}
  local list = DataCenter.LWSheepDataManager:GetRankData(type)
  if list and list.rankArr then
    table.walk(list.rankArr, function(k, v)
      local oneData = self:ParseRankData(v, type)
      if oneData ~= nil then
        table.insert(showList, oneData)
      end
    end)
  end
  return showList, list.owner
end

function LWUISheepRankCtrl:ParseRankData(item, type)
  local oneData = OneData.New()
  if item ~= nil then
    oneData.uid = item.uid
    oneData.rank = item.rank
    oneData.serverId = item.srcServer
    oneData.type = type
    if item.language ~= nil then
      local curLanguage = SuportedServerLanguagesLocalName[item.language] or ""
      if curLanguage == Language.ChineseSimplified then
        curLanguage = Language.ChineseTraditional
      end
      if curLanguage == Language.ChineseTraditional then
        oneData.firstName = Localization:GetString(390759)
      else
        oneData.firstName = Localization:GetString(SuportedLanguagesLocalName[curLanguage] or "") or ""
      end
    elseif item.abbr == nil or item.abbr == "" then
      oneData.firstName = item.name
    elseif item.uid == LuaEntry.Player.uid then
      if LuaEntry.Player:IsInAlliance() then
        oneData.firstName = "[" .. item.abbr .. "] " .. item.name
      else
        oneData.firstName = item.name
      end
    else
      oneData.firstName = "[" .. item.abbr .. "] " .. item.name
    end
    oneData.power = string.GetFormattedSeperatorNum(item.score or 0)
    oneData.pic = item.pic
    oneData.picVer = item.picVer
    oneData.headFrame = item:GetHeadBgImg()
  else
    oneData.uid = ""
    oneData.firstName = "-"
    oneData.rank = "-"
    oneData.power = 0
  end
  return oneData
end

function LWUISheepRankCtrl:GetSelfData(selfData, type)
  local oneData = OneData.New()
  local Player = LuaEntry.Player
  oneData.serverId = LuaEntry.Player:GetSourceServerId()
  oneData.rank = selfData.rank
  oneData.power = selfData.score
  oneData.type = type
  local allianceData = DataCenter.AllianceBaseDataManager:GetAllianceBaseData()
  if type == SheepGameRankType.Language then
    local curLanguage = Localization:GetLanguage()
    if curLanguage == Language.ChineseSimplified then
      curLanguage = Language.ChineseTraditional
    end
    if curLanguage == Language.ChineseTraditional then
      oneData.firstName = Localization:GetString(390759) or ""
    else
      oneData.firstName = Localization:GetString(SuportedLanguagesLocalName[curLanguage]) or ""
    end
  elseif allianceData == nil or allianceData.abbr == nil or allianceData.abbr == "" then
    oneData.firstName = Player:GetName()
  elseif LuaEntry.Player:IsInAlliance() then
    oneData.firstName = "[" .. allianceData.abbr .. "] " .. Player:GetName()
  else
    oneData.firstName = Player:GetName()
  end
  oneData.uid = Player:GetUid()
  oneData.pic = Player:GetPic()
  oneData.picVer = Player.picVer
  oneData.headFrame = Player:GetHeadBgImg()
  return oneData
end

function LWUISheepRankCtrl:CheckRewardBtnStat(type)
  if type == SheepGameRankType.Owner then
    local actData = DataCenter.LWSheepDataManager:GetActivityData()
    if actData == nil then
      return false
    end
    return not string.IsNullOrEmpty(actData.rankRewardParam)
  end
  return false
end

function LWUISheepRankCtrl:GetRankRewardList(type)
  if type == SheepGameRankType.Owner then
    return DataCenter.LWSheepDataManager:GetRewardList(type)
  end
  return nil
end

function LWUISheepRankCtrl:OpenRewardLogic(param, type)
  if type == SheepGameRankType.Owner then
    SFSNetwork.SendMessage(MsgDefines.GetSeasonRankRewardInfo, param)
  end
end

function LWUISheepRankCtrl:GetActivityDescription(type)
  local result = {
    title = "season_s4_activity_1200010_desc22",
    content1 = "",
    content2 = "",
    desc = ""
  }
  if type == SheepGameRankType.Owner then
    result.content1 = "season_s4_activity_1200010_desc23"
    result.content2 = "season_s4_activity_1200010_desc24"
  else
    result.content1 = "season_s5_rules_ui_desc2"
    result.content2 = "season_s4_activity_1200010_desc26"
  end
  return result
end

return LWUISheepRankCtrl
