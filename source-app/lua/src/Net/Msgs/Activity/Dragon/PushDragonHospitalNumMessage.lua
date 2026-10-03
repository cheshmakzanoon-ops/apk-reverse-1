local PushDragonHospitalNumMessage = BaseClass("PushDragonHospitalNumMessage", SFSBaseMessage)
local base = SFSBaseMessage
local Localization = CS.GameEntry.Localization

function PushDragonHospitalNumMessage:OnCreate()
  base.OnCreate(self)
end

function PushDragonHospitalNumMessage:HandleMessage(t)
  base.HandleMessage(self, t)
  DataCenter.ActDragonManager:OnHandleDragonHospitalNum(t)
end

return PushDragonHospitalNumMessage
