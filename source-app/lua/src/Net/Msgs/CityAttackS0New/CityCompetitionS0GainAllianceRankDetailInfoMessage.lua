local CityCompetitionS0GainAllianceRankDetailInfoMessage = BaseClass("CityCompetitionS0GainAllianceRankDetailInfoMessage", SFSBaseMessage)
local base = SFSBaseMessage

function CityCompetitionS0GainAllianceRankDetailInfoMessage:OnCreate(cityId)
  base.OnCreate(self)
  self.sfsObj:PutInt("cityId", cityId)
end

function CityCompetitionS0GainAllianceRankDetailInfoMessage:HandleMessage(t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
  else
    DataCenter.AttackCityS0DataManager:UpdateAllianceRankDetailMessage(t)
  end
end

return CityCompetitionS0GainAllianceRankDetailInfoMessage
