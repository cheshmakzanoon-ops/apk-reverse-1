local CityCompetitionS0GainThumbsUpRewardMessage = BaseClass("CityCompetitionS0GainThumbsUpRewardMessage", SFSBaseMessage)
local base = SFSBaseMessage

function CityCompetitionS0GainThumbsUpRewardMessage:OnCreate(cityId, targetUid)
  base.OnCreate(self)
  self.sfsObj:PutInt("cityId", cityId)
  self.sfsObj:PutUtfString("targetUid", targetUid)
end

function CityCompetitionS0GainThumbsUpRewardMessage:HandleMessage(t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
  else
    DataCenter.AttackCityS0DataManager:UpdateThumbsUpRewardMessage(t)
  end
end

return CityCompetitionS0GainThumbsUpRewardMessage
