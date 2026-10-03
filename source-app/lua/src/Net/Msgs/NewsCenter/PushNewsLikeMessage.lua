local PushNewsLikeMessage = BaseClass("PushNewsLikeMessage", SFSBaseMessage)
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
    DataCenter.LWNewsCenterManager:OnNewsLiked(t.uuid, t.likeNum)
  end
end

PushNewsLikeMessage.OnCreate = OnCreate
PushNewsLikeMessage.HandleMessage = HandleMessage
return PushNewsLikeMessage
