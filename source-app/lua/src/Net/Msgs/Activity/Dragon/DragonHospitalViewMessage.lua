local DragonHospitalViewMessage = BaseClass("DragonHospitalViewMessage", SFSBaseMessage)
local base = SFSBaseMessage
local Localization = CS.GameEntry.Localization

function DragonHospitalViewMessage:OnCreate()
  base.OnCreate(self)
end

function DragonHospitalViewMessage:HandleMessage(t)
  base.HandleMessage(self, t)
  DataCenter.ActDragonManager:OnHandleDragonHospitalView(t)
end

return DragonHospitalViewMessage
