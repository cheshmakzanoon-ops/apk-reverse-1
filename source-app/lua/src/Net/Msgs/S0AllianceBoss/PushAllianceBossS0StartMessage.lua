local PushAllianceBossS0StartMessage = BaseClass("PushAllianceBossS0StartMessage", SFSBaseMessage)
local base = SFSBaseMessage

function PushAllianceBossS0StartMessage:OnCreate()
  base.OnCreate(self)
end

function PushAllianceBossS0StartMessage:HandleMessage(message)
  base.HandleMessage(self, message)
  local errorCode = message.errorCode
  if errorCode ~= nil then
    UIUtil.ShowTipsId(errorCode)
    return
  end
  DataCenter.S0AllianceBossDataManager:ReqActMainMessage()
end

return PushAllianceBossS0StartMessage
