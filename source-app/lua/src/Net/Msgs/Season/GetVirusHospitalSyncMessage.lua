local GetVirusHospitalSyncMessage = BaseClass("GetVirusHospitalSyncMessage", SFSBaseMessage)
local base = SFSBaseMessage

function GetVirusHospitalSyncMessage:OnCreate()
  base.OnCreate(self)
end

function GetVirusHospitalSyncMessage:HandleMessage(t)
  base.HandleMessage(self, t)
end

return GetVirusHospitalSyncMessage
