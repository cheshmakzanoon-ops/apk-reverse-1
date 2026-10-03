local CityCompetitionS0CityClueGainRewardMessage = BaseClass("CityCompetitionS0CityClueGainRewardMessage", SFSBaseMessage)
local base = SFSBaseMessage

function CityCompetitionS0CityClueGainRewardMessage:OnCreate(configId)
  base.OnCreate(self)
  self.sfsObj:PutInt("configId", configId)
end

function CityCompetitionS0CityClueGainRewardMessage:HandleMessage(t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
  else
    DataCenter.AttackCityS0DataManager:UpdateRewardInfoMessage(t)
  end
end

return CityCompetitionS0CityClueGainRewardMessage
