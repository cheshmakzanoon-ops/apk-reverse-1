local PushCityCompetitionS0ActivityUpdateInfoMessage = BaseClass("PushCityCompetitionS0ActivityUpdateInfoMessage", SFSBaseMessage)
local base = SFSBaseMessage

function PushCityCompetitionS0ActivityUpdateInfoMessage:OnCreate(param)
  base.OnCreate(self)
end

function PushCityCompetitionS0ActivityUpdateInfoMessage:HandleMessage(t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
  else
    DataCenter.AttackCityS0DataManager:PushRefreshMsg(t)
  end
end

return PushCityCompetitionS0ActivityUpdateInfoMessage
