local PushNewsCenterLikeMessage = BaseClass("PushNewsCenterLikeMessage", SFSBaseMessage)

local function OnCreate(self, tbl)
end

local function HandleMessage(self, serverData)
  if serverData and serverData.data then
    DataCenter.LWNewsCenterManager:UpdateNewsCenterLike(serverData.data)
  end
end

PushNewsCenterLikeMessage.OnCreate = OnCreate
PushNewsCenterLikeMessage.HandleMessage = HandleMessage
return PushNewsCenterLikeMessage
