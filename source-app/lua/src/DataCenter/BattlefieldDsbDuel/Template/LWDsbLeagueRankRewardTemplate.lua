local LWDsbLeagueRankRewardTemplate = BaseClass("LWDsbLeagueRankRewardTemplate")
local RewardUtil = require("Util.RewardUtil")

function LWDsbLeagueRankRewardTemplate:__init()
  self.id = 0
  self.season = 0
  self.type = 0
  self.para = ""
  self.rank_alliance = 0
  self.rank_zone = 0
  self.dialog = ""
end

function LWDsbLeagueRankRewardTemplate:__delete()
  self.id = nil
  self.season = nil
  self.type = nil
  self.para = nil
  self.rank_alliance = nil
  self.rank_zone = nil
  self.dialog = nil
end

function LWDsbLeagueRankRewardTemplate:UpdateData(rowData)
  if rowData == nil then
    return
  end
  self.id = rowData:getValue("id") or 0
  self.season = rowData:getValue("season") or 0
  self.type = rowData:getValue("type") or 0
  self.para = rowData:getValue("para") or ""
  self.rank_alliance = rowData:getValue("rank_alliance") or 0
  self.rank_zone = rowData:getValue("rank_zone") or 0
  self.dialog = rowData:getValue("dialog") or ""
end

function LWDsbLeagueRankRewardTemplate:GetRankRange()
  local rankParts = string.split(self.para, ",")
  if 2 <= #rankParts then
    return tonumber(rankParts[1]) or 1, tonumber(rankParts[2]) or 1
  end
  return 1, 1
end

function LWDsbLeagueRankRewardTemplate:IsInRankRange(rank)
  local startRank, endRank = self:GetRankRange()
  return rank >= startRank and rank <= endRank
end

function LWDsbLeagueRankRewardTemplate:GetRankRewardList()
  if string.IsNullOrEmpty(self.rank_alliance) or self.rank_alliance == 0 then
    return {}
  end
  return RewardUtil.GetRewardItemAndResource(self.rank_alliance)
end

function LWDsbLeagueRankRewardTemplate:GetZoneRankRewardList()
  if string.IsNullOrEmpty(self.rank_zone) or self.rank_zone == 0 then
    return {}
  end
  return RewardUtil.GetRewardItemAndResource(self.rank_zone)
end

return LWDsbLeagueRankRewardTemplate
