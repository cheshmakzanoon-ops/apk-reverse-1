local PushLittleGamePVPKickMessage = BaseClass("PushLittleGamePVPKickMessage", SFSBaseMessage)
local base = SFSBaseMessage

local function HandleMessage(self, t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
  end
  local room = DataCenter.LWGGGoDataManager:GetRoom()
  room:Kick(t, errCode)
end

PushLittleGamePVPKickMessage.HandleMessage = HandleMessage
return PushLittleGamePVPKickMessage
