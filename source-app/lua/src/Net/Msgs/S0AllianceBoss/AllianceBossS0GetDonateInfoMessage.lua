local AllianceBossS0GetDonateInfoMessage = BaseClass("AllianceBossS0GetDonateInfoMessage", SFSBaseMessage)
local base = SFSBaseMessage

function AllianceBossS0GetDonateInfoMessage:OnCreate()
  base.OnCreate(self)
end

function AllianceBossS0GetDonateInfoMessage:HandleMessage(message)
  base.HandleMessage(self, message)
  local errorCode = message.errorCode
  if errorCode ~= nil then
    UIUtil.ShowTipsId(errorCode)
    return
  end
  DataCenter.S0AllianceBossDataManager:ParseDonateInfo(message)
end

return AllianceBossS0GetDonateInfoMessage
