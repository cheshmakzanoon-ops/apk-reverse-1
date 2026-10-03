local PushUpdateRebirthHospitalInfoMessage = BaseClass("PushUpdateRebirthHospitalInfoMessage", SFSBaseMessage)
local base = SFSBaseMessage

function PushUpdateRebirthHospitalInfoMessage:OnCreate(param)
  base.OnCreate(self)
end

function PushUpdateRebirthHospitalInfoMessage:HandleMessage(t)
  base.HandleMessage(self, t)
  DataCenter.RebirthHospitalManager:OnRebirthMessageCallback(t)
end

return PushUpdateRebirthHospitalInfoMessage
