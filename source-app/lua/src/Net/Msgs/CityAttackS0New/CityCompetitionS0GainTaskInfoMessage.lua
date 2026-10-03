local CityCompetitionS0GainTaskInfoMessage = BaseClass("CityCompetitionS0GainTaskInfoMessage", SFSBaseMessage)
local base = SFSBaseMessage

function CityCompetitionS0GainTaskInfoMessage:OnCreate(cityLv)
  base.OnCreate(self)
  self.sfsObj:PutInt("cityLv", cityLv)
end

function CityCompetitionS0GainTaskInfoMessage:HandleMessage(t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
  else
    DataCenter.AttackCityS0DataManager:UpdateBattlePassTaskMessage(t)
  end
end

return CityCompetitionS0GainTaskInfoMessage
