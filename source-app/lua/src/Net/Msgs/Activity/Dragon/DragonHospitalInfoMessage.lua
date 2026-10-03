local DragonHospitalInfoMessage = BaseClass("DragonHospitalInfoMessage", SFSBaseMessage)
local base = SFSBaseMessage
local Localization = CS.GameEntry.Localization

function DragonHospitalInfoMessage:OnCreate()
  base.OnCreate(self)
end

function DragonHospitalInfoMessage:HandleMessage(t)
  base.HandleMessage(self, t)
end

return DragonHospitalInfoMessage
