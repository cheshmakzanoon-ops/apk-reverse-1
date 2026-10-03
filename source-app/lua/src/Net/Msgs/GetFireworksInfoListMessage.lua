local GetFireworksInfoListMessage = BaseClass("GetFireworksInfoListMessage", SFSBaseMessage)
local base = SFSBaseMessage

function GetFireworksInfoListMessage:OnCreate(param)
  base.OnCreate(self)
end

function GetFireworksInfoListMessage:HandleMessage(t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
  else
  end
end

return GetFireworksInfoListMessage
