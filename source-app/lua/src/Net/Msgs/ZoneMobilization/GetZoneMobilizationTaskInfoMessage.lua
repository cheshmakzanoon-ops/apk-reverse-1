local GetZoneMobilizationTaskInfoMessage = BaseClass("GetZoneMobilizationTaskInfoMessage", SFSBaseMessage)
local base = SFSBaseMessage

function GetZoneMobilizationTaskInfoMessage:OnCreate(action)
  base.OnCreate(self)
  self.sfsObj:PutInt("action", action)
end

function GetZoneMobilizationTaskInfoMessage:HandleMessage(message)
  base.HandleMessage(self, message)
  local errCode = message.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
  else
    DataCenter.LWZoneMobilizationManager:InitTaskAndResourcePointsData(message)
  end
end

return GetZoneMobilizationTaskInfoMessage
