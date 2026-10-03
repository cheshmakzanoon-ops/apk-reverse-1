local NewCenterLikeMessage = BaseClass("NewCenterLikeMessage", SFSBaseMessage)

local function OnCreate(self, type, uid)
  self.sfsObj:PutInt("type", type)
  self.sfsObj:PutLong("uuid", uid)
end

local function HandleMessage(self, msg)
end

NewCenterLikeMessage.OnCreate = OnCreate
NewCenterLikeMessage.HandleMessage = HandleMessage
return NewCenterLikeMessage
