local CommonRankItemShow = {
  uid = "",
  firstName = "",
  secondName = "",
  rank = -1,
  power = "",
  allianceName = "",
  icon = "",
  costTimeInMills = 0
}
local UILWGGGoRankCtrl = BaseClass("UILWGGGoRankCtrl", UIBaseCtrl)
local OneData = DataClass("OneData", CommonRankItemShow)
local Localization = CS.GameEntry.Localization

function UILWGGGoRankCtrl:CloseSelf()
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UILWGGGoRank)
end

function UILWGGGoRankCtrl:ReplayChallenge()
  DataCenter.LWGGGoDataManager:SetReplayMode(true)
  SFSNetwork.SendMessage(MsgDefines.ActivityLittleGamePveStartReplay, DataCenter.LWGGGoDataManager:GetVersion(), DataCenter.LWGGGoDataManager:GetActivityType())
end

function UILWGGGoRankCtrl:GetRankList(type)
  local showList = {}
  local list = DataCenter.LWGGGoDataManager:GetRankData(type)
  if list and list.rankArr then
    table.walk(list.rankArr, function(k, v)
      local oneData = self:ParseRankData(v, type)
      if oneData ~= nil then
        table.insert(showList, oneData)
      end
    end)
  end
  return showList, list and list.owner
end

function UILWGGGoRankCtrl:ParseRankData(item, type)
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
        oneData.firstName = Localization:GetString(SuportedLanguagesLocalName[SuportedServerLanguagesLocalName[item.language] or ""] or "") or ""
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
    local costTime = (item.costTimeInMills or item.score or 0) / 1000
    oneData.costTimeInMills = costTime
    oneData.trytimes = item.trytimes or 0
    oneData.pic = item.pic
    oneData.picVer = item.picVer
    oneData.headFrame = item:GetHeadBgImg()
  else
    oneData.uid = ""
    oneData.firstName = "-"
    oneData.rank = "-"
    oneData.power = 0
    oneData.costTimeInMills = 0
    oneData.trytimes = 0
  end
  return oneData
end

function UILWGGGoRankCtrl:GetSelfData(selfData, type)
  local oneData = OneData.New()
  local Player = LuaEntry.Player
  oneData.serverId = LuaEntry.Player:GetSourceServerId()
  oneData.rank = selfData.rank
  oneData.power = selfData.score
  oneData.type = type
  local costTime = (selfData.costTimeInMills or selfData.score or 0) / 1000
  oneData.costTimeInMills = costTime
  oneData.trytimes = selfData.trytimes or 0
  local allianceData = DataCenter.AllianceBaseDataManager:GetAllianceBaseData()
  if type == LittleGameRankType.Language then
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

function UILWGGGoRankCtrl:CheckRewardBtnStat(type)
  if type == LittleGameRankType.Owner then
    local actData = DataCenter.LWGGGoDataManager:GetActivityData()
    if actData == nil then
      return false
    end
    return not string.IsNullOrEmpty(actData.rankRewardParam)
  end
  return false
end

function UILWGGGoRankCtrl:GetRankRewardList(type)
  if type == LittleGameRankType.Owner then
    return DataCenter.LWGGGoDataManager:GetRewardList(type)
  end
  return nil
end

function UILWGGGoRankCtrl:OpenRewardLogic(param, type)
  if type == LittleGameRankType.Owner then
    SFSNetwork.SendMessage(MsgDefines.GetSeasonRankRewardInfo, param)
  end
end

function UILWGGGoRankCtrl:GetActivityDescription(type)
  local result = {
    title = "s6_cave_exploration_activit_title",
    content1 = "",
    content2 = "",
    desc = ""
  }
  local rankId = DataCenter.LWGGGoDataManager:GetRankConfigId()
  local rankConfig = LocalController:instance():getLine(TableName.LW_Season_rank, rankId)
  if type == LittleGameRankType.Owner then
    result.content1 = "season_s4_activity_1200010_desc23"
    result.content2 = "s6_miniGame_para_limit"
  else
    result.content1 = "season_s5_rules_ui_desc2"
    result.content2 = "s6_miniGame_para_limit"
  end
  return result
end

return UILWGGGoRankCtrl
