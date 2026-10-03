local AllianceRescueStopCityFireMessage = BaseClass("AllianceRescueStopCityFireMessage", SFSBaseMessage)
local base = SFSBaseMessage

function AllianceRescueStopCityFireMessage:OnCreate()
  base.OnCreate(self)
end

function AllianceRescueStopCityFireMessage:HandleMessage(t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
  end
end

return AllianceRescueStopCityFireMessage
