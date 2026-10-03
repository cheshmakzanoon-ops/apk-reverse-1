local ChatTreasureShare = BaseClass("ChatTreasureShare", SFSBaseMessage)

local function OnCreate(self, param)
  if LuaEntry and LuaEntry.Player then
    local curServerId = LuaEntry.Player:GetCurServerId()
    if curServerId then
      self.sfsObj:PutInt("CurServerId", curServerId)
    end
  end
  self.sfsObj:PutLong("post", param.post)
  self.sfsObj:PutUtfString("lang", param.lang)
  if param.msg then
    self.sfsObj:PutUtfString("msg", param.msg)
  else
    self.sfsObj:PutUtfString("msg", "?")
  end
  if param.roomId then
    self.sfsObj:PutUtfString("roomId", param.roomId)
  end
  self.sfsObj:PutUtfString("attachmentId", param.attachmentId)
  if param.treasureUid then
    self.sfsObj:PutUtfString("uuid", tostring(param.treasureUid))
  end
end

local function HandleMessage(self, msg)
end

ChatTreasureShare.OnCreate = OnCreate
ChatTreasureShare.HandleMessage = HandleMessage
return ChatTreasureShare
