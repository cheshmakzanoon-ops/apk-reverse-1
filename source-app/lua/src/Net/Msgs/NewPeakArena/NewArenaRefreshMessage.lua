local NewArenaRefreshMessage = BaseClass("NewArenaRefreshMessage", SFSBaseMessage)
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
      EventManager:GetInstance():Broadcast(EventId.NewArenaRefresh, t)
    else
      UIUtil.ShowTipsId(t.errorCode)
    end
  end
end

NewArenaRefreshMessage.OnCreate = OnCreate
NewArenaRefreshMessage.HandleMessage = HandleMessage
return NewArenaRefreshMessage
