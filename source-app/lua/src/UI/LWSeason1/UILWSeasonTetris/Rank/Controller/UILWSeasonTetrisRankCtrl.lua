local CommonRankItemShow = {
  uid = "",
  firstName = "",
  secondName = "",
  rank = -1,
  power = "",
  allianceName = "",
  icon = ""
}
local UILWSeasonTetrisRankCtrl = BaseClass("UILWSeasonTetrisRankCtrl", UIBaseCtrl)
local OneData = DataClass("OneData", CommonRankItemShow)
local Localization = CS.GameEntry.Localization

function UILWSeasonTetrisRankCtrl:CloseSelf()
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UILWSeasonTetrisRank)
end

function UILWSeasonTetrisRankCtrl:GetTetrisRankList(type)
  local showList = {}
  local list = DataCenter.SeasonTetrisManager:GetRankData(type)
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

function UILWSeasonTetrisRankCtrl:ParseRankData(item, type)
  local oneData = OneData.New()
  if item ~= nil then
    oneData.uid = item.uid
    oneData.rank = item.rank
    oneData.serverId = item.srcServer
    oneData.type = type
    if item.language ~= nil then
      oneData.firstName = Localization:GetString(SuportedLanguagesLocalName[SuportedServerLanguagesLocalName[item.language] or ""] or "") or ""
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

function UILWSeasonTetrisRankCtrl:GetSelfData(selfData, type)
  local oneData = OneData.New()
  local Player = LuaEntry.Player
  local allianceData = DataCenter.AllianceBaseDataManager:GetAllianceBaseData()
  oneData.serverId = LuaEntry.Player:GetSourceServerId()
  oneData.rank = selfData.rank
  oneData.power = string.GetFormattedSeperatorNum(selfData.score)
  oneData.type = type
  if type == SeasonTetrisRankType.Language then
    local curLanguage = Localization:GetLanguage()
    if curLanguage == Language.ChineseSimplified then
      curLanguage = Language.ChineseTraditional
    end
    oneData.firstName = Localization:GetString(SuportedLanguagesLocalName[curLanguage]) or ""
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

function UILWSeasonTetrisRankCtrl:CheckRewardBtnStat(type)
  if type == SeasonTetrisRankType.Owner then
    local actData = DataCenter.SeasonTetrisManager:GetActData()
    if actData == nil then
      return false
    end
    return not string.IsNullOrEmpty(actData.rankRewardParam)
  end
  return false
end

function UILWSeasonTetrisRankCtrl:GetRankRewardList(type)
  if type == SeasonTetrisRankType.Owner then
    return DataCenter.SeasonTetrisManager:GetRewardList(type)
  end
  return nil
end

function UILWSeasonTetrisRankCtrl:OpenRewardLogic(param, type)
  if type == SeasonTetrisRankType.Owner then
    SFSNetwork.SendMessage(MsgDefines.GetSeasonRankRewardInfo, param)
  end
end

function UILWSeasonTetrisRankCtrl:GetActivityDescription(type)
  local result = {
    title = "season_s1_rank450_name",
    content1 = "",
    content2 = "",
    desc = ""
  }
  if type == SeasonTetrisRankType.Owner then
    result.content1 = "season_s4_activity_1200010_desc23"
    result.content2 = "season_s1_activity1200030_desc15"
  else
    result.content1 = "season_s4_activity_1200010_desc25"
    result.content2 = "season_s1_activity1200030_desc16"
  end
  return result
end

return UILWSeasonTetrisRankCtrl
