local GetZoneMobilizationInfoMessage = BaseClass("GetZoneMobilizationInfoMessage", SFSBaseMessage)
local base = SFSBaseMessage

function GetZoneMobilizationInfoMessage:OnCreate(tabType)
  base.OnCreate(self)
  self.sfsObj:PutInt("tabType", tabType)
end

function GetZoneMobilizationInfoMessage:HandleMessage(message)
  base.HandleMessage(self, message)
  local errCode = message.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
  else
    DataCenter.LWZoneMobilizationManager:InitZoneMobilizationInfoData(message)
  end
end

return GetZoneMobilizationInfoMessage
