local GaleArenaRefreshMessage = BaseClass("GaleArenaRefreshMessage", SFSBaseMessage)
local base = SFSBaseMessage

local function OnCreate(self, isRefresh)
  base.OnCreate(self)
  self.sfsObj:PutInt("isRefresh", isRefresh)
end

local function HandleMessage(self, t)
  base.HandleMessage(self, t)
  if t ~= nil then
    if t.errorCode == nil then
      if t.remainGold ~= nil then
        LuaEntry.Player.gold = t.remainGold
        EventManager:GetInstance():Broadcast(EventId.UpdateGold)
      end
      EventManager:GetInstance():Broadcast(EventId.NewGaleArenaRefresh, t)
    else
      UIUtil.ShowTipsId(t.errorCode)
    end
  end
end

GaleArenaRefreshMessage.OnCreate = OnCreate
GaleArenaRefreshMessage.HandleMessage = HandleMessage
return GaleArenaRefreshMessage
