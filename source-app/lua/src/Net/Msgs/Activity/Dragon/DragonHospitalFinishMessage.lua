local DragonHospitalFinishMessage = BaseClass("DragonHospitalFinishMessage", SFSBaseMessage)
local base = SFSBaseMessage
local Localization = CS.GameEntry.Localization

function DragonHospitalFinishMessage:OnCreate()
  base.OnCreate(self)
end

function DragonHospitalFinishMessage:HandleMessage(t)
  base.HandleMessage(self, t)
  DataCenter.ActDragonManager:OnHandleDragonHospitalFinish()
end

return DragonHospitalFinishMessage
