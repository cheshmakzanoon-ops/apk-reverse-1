local ActivityArenaRefreshMessage = BaseClass("ActivityArenaRefreshMessage", SFSBaseMessage)
local base = SFSBaseMessage

local function OnCreate(self, activityId)
  base.OnCreate(self)
  self.sfsObj:PutInt("activityId", tonumber(activityId))
end

local function HandleMessage(self, t)
  base.HandleMessage(self, t)
  local errorCode = t.errorCode
  if errorCode ~= nil then
    UIUtil.ShowTipsId(errorCode)
    EventManager:GetInstance():Broadcast(EventId.ServerError, MsgDefines.ActivityArenaRefresh)
  elseif t.remainGold ~= nil and type(t.remainGold) == "number" then
    LuaEntry.Player.gold = t.remainGold
    EventManager:GetInstance():Broadcast(EventId.UpdateGold)
  end
end

ActivityArenaRefreshMessage.OnCreate = OnCreate
ActivityArenaRefreshMessage.HandleMessage = HandleMessage
return ActivityArenaRefreshMessage
