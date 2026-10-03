local PushBiuBiuPVPInfoMessage = BaseClass("PushBiuBiuPVPInfoMessage", SFSBaseMessage)
local base = SFSBaseMessage

local function HandleMessage(self, t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
  else
    local room = DataCenter.LWBiuBiuDataManager:GetRoom()
    room:UpdateMsg(t)
  end
end

PushBiuBiuPVPInfoMessage.HandleMessage = HandleMessage
return PushBiuBiuPVPInfoMessage
