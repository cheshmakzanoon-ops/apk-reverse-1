local PushWorldOccupyInfoUpdateMessage = BaseClass("PushWorldOccupyInfoUpdateMessage", SFSBaseMessage)
local base = SFSBaseMessage
local DelayFetch

function PushWorldOccupyInfoUpdateMessage:OnCreate()
  base.OnCreate(self)
end

function PushWorldOccupyInfoUpdateMessage:HandleMessage(t)
  base.HandleMessage(self, t)
  local serverId = LuaEntry.Player:GetSelfServerId()
  if t.server ~= nil then
    serverId = t.server
  end
  if DelayFetch == nil or DelayFetch[serverId] == nil then
    if DelayFetch == nil then
      DelayFetch = {}
    end
    DelayFetch[serverId] = TimerManager:GetInstance():DelayInvoke(function()
      SFSNetwork.SendMessage(MsgDefines.FetchWorldOccupyInfo, serverId)
      DelayFetch[serverId] = nil
    end, 1)
  end
end

return PushWorldOccupyInfoUpdateMessage
