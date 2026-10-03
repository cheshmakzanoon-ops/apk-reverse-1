local PushLittleGamePVPReadyOKMessage = BaseClass("PushLittleGamePVPReadyOKMessage", SFSBaseMessage)
local base = SFSBaseMessage

local function HandleMessage(self, t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
  else
    local room = DataCenter.LWGGGoDataManager:GetRoom()
    room:FightReady()
  end
end

PushLittleGamePVPReadyOKMessage.HandleMessage = HandleMessage
return PushLittleGamePVPReadyOKMessage
