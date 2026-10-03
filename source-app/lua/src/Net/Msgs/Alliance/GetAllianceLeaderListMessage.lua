local GetAllianceLeaderListMessage = BaseClass("GetAllianceLeaderListMessage", SFSBaseMessage)
local base = SFSBaseMessage

function GetAllianceLeaderListMessage:OnCreate()
  base.OnCreate(self)
end

function GetAllianceLeaderListMessage:HandleMessage(message)
  base.HandleMessage(self, message)
  local errCode = message.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
  else
    DataCenter.AccountAllianceLeaderListManager:SetAllianceLeaderInfo(message)
  end
end

return GetAllianceLeaderListMessage
