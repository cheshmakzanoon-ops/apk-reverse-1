local AllianceBossS0ActInfoMessage = BaseClass("AllianceBossS0ActInfoMessage", SFSBaseMessage)
local base = SFSBaseMessage

function AllianceBossS0ActInfoMessage:OnCreate(type)
  base.OnCreate(self)
  self.sfsObj:PutInt("type", type)
end

function AllianceBossS0ActInfoMessage:HandleMessage(message)
  base.HandleMessage(self, message)
  local errorCode = message.errorCode
  if errorCode ~= nil then
    UIUtil.ShowTipsId(errorCode)
    return
  end
  DataCenter.S0AllianceBossDataManager:ParseActInfo(message)
  EventManager:GetInstance():BroadcastDeferred(EventId.RefreshActivityRedDot)
end

return AllianceBossS0ActInfoMessage
