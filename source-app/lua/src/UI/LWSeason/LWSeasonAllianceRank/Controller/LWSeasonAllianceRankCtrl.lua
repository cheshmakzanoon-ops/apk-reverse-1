local LWSeasonAllianceRankCtrl = BaseClass("LWSeasonAllianceRankCtrl", UIBaseCtrl)
local RankItemShow = {
  type = RankingTypeServer.DEFAULT,
  isAlliance = false,
  uid = "",
  firstName = "",
  secondName = "",
  rank = -1,
  power = "",
  allianceName = "",
  icon = ""
}
local OneData = DataClass("OneData", RankItemShow)

function LWSeasonAllianceRankCtrl:CloseSelf()
  UIManager:GetInstance():DestroyWindow(UIWindowNames.LWSeasonAllianceRank)
end

function LWSeasonAllianceRankCtrl:GetSelfData(data)
  local oneData = {}
  local Player = LuaEntry.Player
  local allianceData = DataCenter.AllianceBaseDataManager:GetAllianceBaseData()
  oneData.isAlliance = false
  oneData.rank = data.rank
  oneData.score = data.score
  oneData.lootNum = data.loot_num
  oneData.abbr = allianceData.abbr
  oneData.name = Player:GetName()
  oneData.uid = Player:GetUid()
  oneData.pic = Player:GetPic()
  oneData.picVer = Player.picVer
  oneData.headFrame = Player:GetHeadBgImg()
  local rankData = PlayerRankData.New()
  rankData:ParseData(oneData)
  rankData.headFrame = oneData.headFrame
  return rankData
end

function LWSeasonAllianceRankCtrl:GetOneDataShow(isAlliance, type, item)
  local oneData = OneData.New()
  oneData.isAlliance = isAlliance
  oneData.type = type
  if item ~= nil then
    oneData.uid = item.uid
    oneData.rank = item.rank
    oneData.serverId = item.srcServer
    if isAlliance then
      oneData.allianceName = item.allianceName
      oneData.firstName = "[" .. item.allianceAbbr .. "]" .. item.allianceName
      oneData.icon = item.icon
      if type == RankingTypeServer.POWER_ALLIANCE then
        oneData.power = string.GetFormattedSeperatorNum(item.power or 0)
      elseif type == RankingTypeServer.KILL_ALLIANCE then
        oneData.power = string.GetFormattedSeperatorNum(item.kill or 0)
      end
    else
      if item.abbr == nil or item.abbr == "" then
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
      if type == RankingTypeServer.POWER then
        oneData.power = string.GetFormattedSeperatorNum(item.power or 0)
      elseif type == RankingTypeServer.KILL then
        oneData.power = string.GetFormattedSeperatorNum(item.kill or 0)
      elseif type == RankingTypeServer.HERO_TOTAL_POWER then
        oneData.power = string.GetFormattedSeperatorNum(item.heroPower or 0)
      elseif type == RankingTypeServer.PVE_STAGE then
        oneData.power = string.GetFormattedSeperatorNum(item.pveMaxStage or 0)
      elseif type == RankingTypeServer.ONE_HERO_POWER then
        oneData.power = string.GetFormattedSeperatorNum(item.power or 0)
        oneData.heroId = item.heroId
      elseif type == RankingTypeServer.BUILDING then
        oneData.power = string.GetFormattedSeperatorNum(item.baseLevel or 0)
      end
      oneData.pic = item.pic
      oneData.picVer = item.picVer
      oneData.headFrame = item:GetHeadBgImg()
    end
  else
    oneData.uid = ""
    oneData.firstName = "-"
    oneData.rank = "-"
    oneData.power = 0
  end
  return oneData
end

function LWSeasonAllianceRankCtrl:GetRankList(global, type, serverId)
  local showList = {}
  if type == RankingTypeServer.POWER_ALLIANCE or type == RankingTypeServer.KILL_ALLIANCE then
    local list = DataCenter.RankDataManager:GetAllianceRankListByType(global, type, serverId)
    table.walk(list, function(k, v)
      local oneData = self:GetOneDataShow(true, type, v)
      if oneData ~= nil then
        table.insert(showList, oneData)
      end
    end)
  else
    local list = DataCenter.RankDataManager:GetPlayerRankListByType(global, type, serverId)
    table.walk(list, function(k, v)
      local oneData = self:GetOneDataShow(false, type, v)
      if oneData ~= nil then
        table.insert(showList, oneData)
      end
    end)
  end
  return showList
end

return LWSeasonAllianceRankCtrl
