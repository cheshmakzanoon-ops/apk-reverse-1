local CityCompetitionS0GainActivityInfoMessage = BaseClass("CityCompetitionS0GainActivityInfoMessage", SFSBaseMessage)
local base = SFSBaseMessage

function CityCompetitionS0GainActivityInfoMessage:OnCreate(param)
  base.OnCreate(self)
end

function CityCompetitionS0GainActivityInfoMessage:HandleMessage(t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
  else
    DataCenter.AttackCityS0DataManager:UpdateActivityMainMessage(t)
  end
end

return CityCompetitionS0GainActivityInfoMessage
