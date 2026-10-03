local BuildQueueLeaseMessage = BaseClass("BuildQueueLeaseMessage", SFSBaseMessage)
local base = SFSBaseMessage

local function OnCreate(self, id)
  base.OnCreate(self)
  self.sfsObj:PutInt("id", id)
end

local function HandleMessage(self, t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
  elseif t.remainGold ~= nil then
    LuaEntry.Player.gold = t.remainGold
    EventManager:GetInstance():Broadcast(EventId.UpdateGold)
  end
end

BuildQueueLeaseMessage.OnCreate = OnCreate
BuildQueueLeaseMessage.HandleMessage = HandleMessage
return BuildQueueLeaseMessage
