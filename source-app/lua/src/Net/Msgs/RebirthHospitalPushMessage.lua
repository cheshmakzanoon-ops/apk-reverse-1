local RebirthHospitalPushMessage = BaseClass("RebirthHospitalPushMessage", SFSBaseMessage)
local base = SFSBaseMessage

local function OnCreate(self, uid)
  base.OnCreate(self)
end

local function HandleMessage(self, t)
  base.HandleMessage(self, t)
  DataCenter.RebirthHospitalManager:OnRebirthPushMessageCallback(t)
end

RebirthHospitalPushMessage.OnCreate = OnCreate
RebirthHospitalPushMessage.HandleMessage = HandleMessage
return RebirthHospitalPushMessage
