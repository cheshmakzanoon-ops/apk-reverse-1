local CityCompetitionS0GainTaskRewardMessage = BaseClass("CityCompetitionS0GainTaskRewardMessage", SFSBaseMessage)
local base = SFSBaseMessage

function CityCompetitionS0GainTaskRewardMessage:OnCreate(cityLv, configId)
  base.OnCreate(self)
  self.sfsObj:PutInt("cityLv", cityLv)
  self.sfsObj:PutInt("configId", configId)
end

function CityCompetitionS0GainTaskRewardMessage:HandleMessage(t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
  else
    DataCenter.AttackCityS0DataManager:UpdateBattlePassTaskRewardStateMessage(t)
  end
end

return CityCompetitionS0GainTaskRewardMessage
