local CrossKingPersonScoreRankMessage = BaseClass("CrossKingPersonScoreRankMessage", SFSBaseMessage)
local base = SFSBaseMessage

function CrossKingPersonScoreRankMessage:OnCreate()
  base.OnCreate(self)
end

function CrossKingPersonScoreRankMessage:HandleMessage(t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
    return
  end
  DataCenter.ZoneWarManager:SetPersonScoreRank(t)
end

function CrossKingPersonScoreRankMessage:GetTestData()
  local t = {}
  local ranks = {}
  t.ranks = ranks
  local count = math.random(15, 30)
  for i = 1, count do
    local rankData = {}
    rankData.rank = i
    rankData.uid = "player_" .. i
    rankData.score = math.random(1000, 5000)
    rankData.name = "PlayerName" .. i
    rankData.pic = ""
    rankData.picVer = 0
    rankData.allianceAbbr = "abb" .. math.random(1, 10)
    rankData.allianceName = "AllianceName" .. math.random(1, 10)
    rankData.headSkinId = math.random(1, 50)
    table.insert(ranks, rankData)
  end
  local player = LuaEntry.Player
  local selfData = ranks[2]
  selfData.uid = player.uid
  selfData.name = player.name
  selfData.pic = player.pic
  selfData.picVer = player.picVer
  local data = DataCenter.AllianceBaseDataManager:GetAllianceBaseData()
  selfData.allianceAbbr = data and data.abbr or ""
  selfData.allianceName = data and data.allianceName or ""
  return t
end

return CrossKingPersonScoreRankMessage
