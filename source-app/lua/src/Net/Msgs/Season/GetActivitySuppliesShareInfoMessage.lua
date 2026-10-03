local GetActivitySuppliesShareInfoMessage = BaseClass("GetActivitySuppliesShareInfoMessage", SFSBaseMessage)
local base = SFSBaseMessage

function GetActivitySuppliesShareInfoMessage:OnCreate(serverId)
  base.OnCreate(self)
end

function GetActivitySuppliesShareInfoMessage:HandleMessage(t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
    return
  end
  DataCenter.SeasonSuppliesShareDataManager:UpdateInfo(t)
end

return GetActivitySuppliesShareInfoMessage
