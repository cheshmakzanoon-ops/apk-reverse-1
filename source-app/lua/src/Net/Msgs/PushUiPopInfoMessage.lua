local PushUiPopInfoMessage = BaseClass("PushUiPopInfoMessage", SFSBaseMessage)
local base = SFSBaseMessage

function PushUiPopInfoMessage:OnCreate(param)
  base.OnCreate(self)
end

function PushUiPopInfoMessage:HandleMessage(t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
  else
    DataCenter.InteractionBubbleManager:HandlePushUiPopInfoMessage(t)
  end
end

return PushUiPopInfoMessage
