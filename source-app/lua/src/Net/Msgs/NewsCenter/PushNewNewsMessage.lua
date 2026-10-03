local PushNewNewsMessage = BaseClass("PushNewNewsMessage", SFSBaseMessage)
local base = SFSBaseMessage

local function OnCreate(self)
  base.OnCreate(self)
end

local function HandleMessage(self, t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
  else
    DataCenter.LWNewsCenterManager:OnPushNewNews(t)
    EventManager:GetInstance():Broadcast(EventId.OnPushNewNews, t)
  end
end

PushNewNewsMessage.OnCreate = OnCreate
PushNewNewsMessage.HandleMessage = HandleMessage
return PushNewNewsMessage
