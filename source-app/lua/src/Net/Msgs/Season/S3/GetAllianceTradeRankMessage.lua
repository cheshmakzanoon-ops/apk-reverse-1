local GetAllianceTradeRankMessage = BaseClass("GetAllianceTradeRankMessage", SFSBaseMessage)
local base = SFSBaseMessage

function GetAllianceTradeRankMessage:OnCreate()
  base.OnCreate(self)
end

function GetAllianceTradeRankMessage:HandleMessage(t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
  else
    local selfAllianceId = LuaEntry.Player.allianceId
    local list, selfData = {}
    t.rankArray = t.rankArray or {}
    for i, v in ipairs(t.rankArray) do
      list[i] = self:GetRankData(v, i)
      if not selfData and v.allianceId == selfAllianceId then
        selfData = list[i]
      end
    end
    if not selfData then
      local allianceData = LuaEntry.Player:IsInAlliance() and DataCenter.AllianceBaseDataManager:GetAllianceBaseData()
      selfData = {}
      selfData.isAlliance = true
      if allianceData then
        selfData.uid = selfAllianceId
        selfData.serverId = LuaEntry.Player:GetSourceServerId()
        selfData.allianceName = allianceData.allianceName
        selfData.firstName = "[" .. allianceData.abbr .. "]" .. allianceData.allianceName
        selfData.icon = allianceData.icon
        selfData.rank = "50+"
        selfData.power = string.GetFormattedSeperatorNum(t.score or 0)
      else
        selfData.uid = nil
        selfData.serverId = LuaEntry.Player:GetSourceServerId()
        selfData.firstName = "-"
        selfData.icon = nil
        selfData.power = "0"
        selfData.rank = "50+"
      end
    end
    EventManager:GetInstance():Broadcast(EventId.GetAllianceTradeRank, {list = list, selfData = selfData})
  end
end

function GetAllianceTradeRankMessage:GetRankData(rank, index)
  local data = {}
  data.isAlliance = true
  data.uid = rank.allianceId
  data.serverId = rank.serverId
  data.allianceName = rank.name
  data.firstName = UIUtil.FormatAllianceAndName(rank.abbr, rank.name)
  data.icon = rank.icon
  data.rank = index
  data.power = string.GetFormattedSeperatorNum(rank.score or 0)
  return data
end

return GetAllianceTradeRankMessage
