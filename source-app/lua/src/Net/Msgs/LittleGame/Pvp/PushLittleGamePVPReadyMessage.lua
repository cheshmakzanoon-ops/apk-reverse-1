local PushLittleGamePVPReadyMessage = BaseClass("PushLittleGamePVPReadyMessage", SFSBaseMessage)
local base = SFSBaseMessage

local function HandleMessage(self, t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
  end
  local room = DataCenter.LWGGGoDataManager:GetRoom()
  room:Ready(t, errCode)
end

PushLittleGamePVPReadyMessage.HandleMessage = HandleMessage
return PushLittleGamePVPReadyMessage
