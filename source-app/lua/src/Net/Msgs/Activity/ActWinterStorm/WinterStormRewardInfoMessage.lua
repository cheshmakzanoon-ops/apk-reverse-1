local WinterStormRewardInfoMessage = BaseClass("WinterStormRewardInfoMessage", SFSBaseMessage)
local base = SFSBaseMessage

function WinterStormRewardInfoMessage:OnCreate()
  base.OnCreate(self)
end

function WinterStormRewardInfoMessage:HandleMessage(t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
  else
    DataCenter.ActWinterStormManager:HandleRewardInfo(t)
  end
end

return WinterStormRewardInfoMessage
