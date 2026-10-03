local PushLittleGamePVPInfoMessage = BaseClass("PushLittleGamePVPInfoMessage", SFSBaseMessage)
local base = SFSBaseMessage

local function HandleMessage(self, t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
  else
    local room = DataCenter.LWGGGoDataManager:GetRoom(t.activityType)
    room:UpdateMsg(t)
  end
end

PushLittleGamePVPInfoMessage.HandleMessage = HandleMessage
return PushLittleGamePVPInfoMessage
