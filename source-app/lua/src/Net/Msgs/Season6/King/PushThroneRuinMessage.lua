local PushThroneRuinMessage = BaseClass("PushThroneRuinMessage", SFSBaseMessage)
local base = SFSBaseMessage
local DelayFetch

function PushThroneRuinMessage:OnCreate()
  base.OnCreate(self)
end

function PushThroneRuinMessage:HandleMessage(t)
  base.HandleMessage(self, t)
  local serverId = t.serverId or LuaEntry.Player:GetSelfServerId()
  if DelayFetch == nil or DelayFetch[serverId] == nil then
    if DelayFetch == nil then
      DelayFetch = {}
    end
    DelayFetch[serverId] = TimerManager:GetInstance():DelayInvoke(function()
      SFSNetwork.SendMessage(MsgDefines.FetchWorldOccupyInfo, serverId)
      DelayFetch[serverId] = nil
    end, 1)
  end
  SFSNetwork.SendMessage(MsgDefines.FetchRainforestKingBattleActivityInfo)
end

return PushThroneRuinMessage
