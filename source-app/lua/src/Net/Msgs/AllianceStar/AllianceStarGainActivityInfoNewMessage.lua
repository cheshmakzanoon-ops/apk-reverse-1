local AllianceStarGainActivityInfoNewMessage = BaseClass("AllianceStarGainActivityInfoNewMessage", SFSBaseMessage)
local base = SFSBaseMessage

function AllianceStarGainActivityInfoNewMessage:OnCreate(param)
  base.OnCreate(self)
end

function AllianceStarGainActivityInfoNewMessage:HandleMessage(t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
  else
    DataCenter.AllianceStarManager:OnAllianceStarGainActivityInfoNew(t)
  end
end

return AllianceStarGainActivityInfoNewMessage
