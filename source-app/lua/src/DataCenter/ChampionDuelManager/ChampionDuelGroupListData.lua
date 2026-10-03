local ChampionDuelGroupListData = BaseClass("ChampionDuelGroupListData")
local ChampionDuelTeamInfoData = require("DataCenter.ChampionDuelManager.ChampionDuelTeamInfoData")

function ChampionDuelGroupListData:__init()
  self.myRank = nil
  self.ranks = {}
end

function ChampionDuelGroupListData:__delete()
  self.myRank = nil
  self.ranks = {}
end

function ChampionDuelGroupListData:ParseData(message)
  if message == nil then
    return
  end
  local selfData = message.self
  if selfData ~= nil then
    local info = ChampionDuelTeamInfoData.New()
    info:ParseData(selfData)
    self.myRank = info
  end
  local rankData = message.rank
  if rankData ~= nil then
    self.ranks = {}
    for _, v in pairs(rankData) do
      local info = ChampionDuelTeamInfoData.New()
      info:ParseData(v)
      self.ranks[info.rank] = info
    end
  end
end

function ChampionDuelGroupListData:GetRank(rank)
  return self.ranks ~= nil and self.ranks[rank] or nil
end

return ChampionDuelGroupListData
