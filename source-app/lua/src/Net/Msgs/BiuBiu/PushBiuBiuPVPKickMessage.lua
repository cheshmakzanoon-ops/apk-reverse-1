local PushBiuBiuPVPKickMessage = BaseClass("PushBiuBiuPVPKickMessage", SFSBaseMessage)
local base = SFSBaseMessage

local function HandleMessage(self, t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
  end
  local room = DataCenter.LWBiuBiuDataManager:GetRoom()
  room:Kick(t, errCode)
end

PushBiuBiuPVPKickMessage.HandleMessage = HandleMessage
return PushBiuBiuPVPKickMessage
