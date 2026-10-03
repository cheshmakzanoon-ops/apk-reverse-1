local ChatTransLateFeedbackMessage = BaseClass("ChatTransLateFeedbackMessage", SFSBaseMessage)

local function OnCreate(self, param)
  if param then
    self.sfsObj:PutUtfString("param", param)
  end
end

local function HandleMessage(self, msg)
end

ChatTransLateFeedbackMessage.OnCreate = OnCreate
ChatTransLateFeedbackMessage.HandleMessage = HandleMessage
return ChatTransLateFeedbackMessage
