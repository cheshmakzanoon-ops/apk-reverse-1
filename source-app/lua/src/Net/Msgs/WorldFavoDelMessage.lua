local WorldFavoDelMessage = BaseClass("WorldFavoDelMessage", SFSBaseMessage)
local base = SFSBaseMessage
local Localization = CS.GameEntry.Localization

local function OnCreate(self, point, type, server, worldId)
  base.OnCreate(self)
  self.sfsObj:PutInt("point", point)
  self.sfsObj:PutInt("type", type)
  self.sfsObj:PutInt("server", server)
  self.sfsObj:PutInt("worldId", worldId or LuaEntry.Player:GetCurWorldId())
end

local function HandleMessage(self, t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
  elseif t.point ~= nil and t.server ~= nil then
    DataCenter.WorldFavoDataManager:DelBookmark(t.point, t.server)
    EventManager:GetInstance():Broadcast(EventId.RefreshBookmark)
    UIUtil.ShowTipsId(280154)
  end
end

WorldFavoDelMessage.OnCreate = OnCreate
WorldFavoDelMessage.HandleMessage = HandleMessage
return WorldFavoDelMessage
