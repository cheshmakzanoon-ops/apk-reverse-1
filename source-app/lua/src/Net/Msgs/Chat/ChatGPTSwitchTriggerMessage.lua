local ChatGPTSwitchTriggerMessage = BaseClass("ChatGPTSwitchTriggerMessage", SFSBaseMessage)
local base = SFSBaseMessage

function ChatGPTSwitchTriggerMessage:OnCreate()
  base.OnCreate(self)
  local dataList = DataCenter.LWChatAIManager:GetSwitchPush()
  for push_id, _ in pairs(dataList) do
    local status = Setting:GetBool("ai.chat.push." .. push_id, true)
    self.sfsObj:PutBool(tostring(push_id), status)
  end
  dataList = DataCenter.LWChatAIManager:GetSwitchRecv()
  for push_id, _ in pairs(dataList) do
    local status = Setting:GetBool("ai.chat.push." .. push_id, true)
    self.sfsObj:PutBool(tostring(push_id), status)
  end
end

function ChatGPTSwitchTriggerMessage:HandleMessage(t)
  base.HandleMessage(self, t)
end

return ChatGPTSwitchTriggerMessage
