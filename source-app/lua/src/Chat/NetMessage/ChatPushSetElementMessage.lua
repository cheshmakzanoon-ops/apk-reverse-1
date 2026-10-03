local ChatPushSetElementMessage = BaseClass("ChatPushSetElementMessage", SFSBaseMessage)

local function OnCreate(self, roomId, state)
  if state then
    self.sfsObj:PutInt("state", state)
  end
  if roomId then
    self.sfsObj:PutUtfString("roomId", roomId)
  end
  self.sfsObj:PutInt("type", 1)
end

local function HandleMessage(self, msg)
  if msg.errorCode ~= nil then
    UIUtil.ShowErrorCodeTips(msg)
  else
    DataCenter.PushSettingsManager:SetGroupChatSetting(msg.roomId, msg.state)
  end
end

ChatPushSetElementMessage.OnCreate = OnCreate
ChatPushSetElementMessage.HandleMessage = HandleMessage
return ChatPushSetElementMessage
