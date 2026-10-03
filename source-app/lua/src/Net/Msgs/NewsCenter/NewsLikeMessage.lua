local NewsLikeMessage = BaseClass("NewsLikeMessage", SFSBaseMessage)
local base = SFSBaseMessage

local function OnCreate(self, newsUuid)
  base.OnCreate(self)
  self.sfsObj:PutLong("uuid", newsUuid)
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

NewsLikeMessage.OnCreate = OnCreate
NewsLikeMessage.HandleMessage = HandleMessage
return NewsLikeMessage
