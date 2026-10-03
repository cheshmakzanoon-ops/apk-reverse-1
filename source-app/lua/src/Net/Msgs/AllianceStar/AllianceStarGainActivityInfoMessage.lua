local AllianceStarGainActivityInfoMessage = BaseClass("AllianceStarGainActivityInfoMessage", SFSBaseMessage)
local base = SFSBaseMessage

function AllianceStarGainActivityInfoMessage:OnCreate(param)
  base.OnCreate(self)
end

function AllianceStarGainActivityInfoMessage:HandleMessage(t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
  elseif DataCenter.AllianceStarManager.ceremonyScene then
  end
end

return AllianceStarGainActivityInfoMessage
