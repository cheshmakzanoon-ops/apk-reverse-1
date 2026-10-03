local CityCompetitionS0GainAllianceRankPreviewInfoMessage = BaseClass("CityCompetitionS0GainAllianceRankPreviewInfoMessage", SFSBaseMessage)
local base = SFSBaseMessage

function CityCompetitionS0GainAllianceRankPreviewInfoMessage:OnCreate(param)
  base.OnCreate(self)
end

function CityCompetitionS0GainAllianceRankPreviewInfoMessage:HandleMessage(t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
  else
    DataCenter.AttackCityS0DataManager:UpdateAllianceRankMessage(t)
  end
end

return CityCompetitionS0GainAllianceRankPreviewInfoMessage
