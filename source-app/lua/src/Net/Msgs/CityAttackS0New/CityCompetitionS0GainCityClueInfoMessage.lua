local CityCompetitionS0GainCityClueInfoMessage = BaseClass("CityCompetitionS0GainCityClueInfoMessage", SFSBaseMessage)
local base = SFSBaseMessage

function CityCompetitionS0GainCityClueInfoMessage:OnCreate(param)
  base.OnCreate(self)
end

function CityCompetitionS0GainCityClueInfoMessage:HandleMessage(t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
  else
    DataCenter.AttackCityS0DataManager:UpdateCityClueInfoMessage(t)
  end
end

return CityCompetitionS0GainCityClueInfoMessage
