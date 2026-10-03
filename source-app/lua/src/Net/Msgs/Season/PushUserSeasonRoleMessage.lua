local PushUserSeasonRoleMessage = BaseClass("PushUserSeasonRoleMessage", SFSBaseMessage)
local base = SFSBaseMessage

local function OnCreate(self, id)
  base.OnCreate(self)
end

local function HandleMessage(self, t)
  base.HandleMessage(self, t)
  if t.errorCode then
    UIUtil.ShowTipsId(t.errorCode)
    return
  end
  if t.seasonRole then
    LuaEntry.Player:RefreshSeasonRole(t.seasonRole)
    EventManager:GetInstance():Broadcast(EventId.PushUserSeasonRoleEvent)
  end
end

PushUserSeasonRoleMessage.OnCreate = OnCreate
PushUserSeasonRoleMessage.HandleMessage = HandleMessage
return PushUserSeasonRoleMessage
