local PushOutpostScoreChangeMessage = BaseClass("PushOutpostScoreChangeMessage", SFSBaseMessage)
local base = SFSBaseMessage
local tmpScoreCache = {}

function PushOutpostScoreChangeMessage:OnCreate()
  base.OnCreate(self)
end

function PushOutpostScoreChangeMessage:HandleMessage(t)
  base.HandleMessage(self, t)
  local ownerServerId = toInt(t.ownerServerId)
  local cityId = toInt(t.cityId)
  if 0 < cityId and 0 < ownerServerId then
    local info = SeasonUtil.GetSeasonInfo(ownerServerId)
    if info then
      local serverId = info:GetNinePalacesServer(5)
      t.serverId = serverId
      t.now = UITimeManager:GetInstance():GetServerTime()
      tmpScoreCache[serverId * 10000 + cityId] = t
      EventManager:GetInstance():Broadcast(EventId.OutpostBattleOccupyServerChanged, t)
    end
  end
end

function PushOutpostScoreChangeMessage.GetTempScoreInfo(cityId, serverId)
  if tmpScoreCache then
    return tmpScoreCache[serverId * 10000 + cityId]
  end
  return nil
end

function PushOutpostScoreChangeMessage.CleanTempScoreInfo()
  tmpScoreCache = {}
end

return PushOutpostScoreChangeMessage
