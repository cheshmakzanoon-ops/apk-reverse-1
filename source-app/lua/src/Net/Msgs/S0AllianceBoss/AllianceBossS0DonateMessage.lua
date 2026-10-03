local AllianceBossS0DonateMessage = BaseClass("AllianceBossS0DonateMessage", SFSBaseMessage)
local base = SFSBaseMessage

function AllianceBossS0DonateMessage:OnCreate()
  base.OnCreate(self)
end

function AllianceBossS0DonateMessage:HandleMessage(message)
  base.HandleMessage(self, message)
  local errorCode = message.errorCode
  if errorCode ~= nil then
    UIUtil.ShowTipsId(errorCode)
    return
  end
  DataCenter.S0AllianceBossDataManager:ParseCurDonateInfo(message)
end

return AllianceBossS0DonateMessage
