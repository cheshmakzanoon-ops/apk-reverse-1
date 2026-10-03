local RebirthHospitalHistoryMessage = BaseClass("RebirthHospitalHistoryMessage", SFSBaseMessage)
local base = SFSBaseMessage

local function OnCreate(self, uid)
  base.OnCreate(self)
end

local function HandleMessage(self, t)
  base.HandleMessage(self, t)
  DataCenter.RebirthHospitalManager:OnRebirthHistoryMessageCallback(t)
end

RebirthHospitalHistoryMessage.OnCreate = OnCreate
RebirthHospitalHistoryMessage.HandleMessage = HandleMessage
return RebirthHospitalHistoryMessage
