local SeasonTowerInfoMessage = BaseClass("SeasonTowerInfoMessage", SFSBaseMessage)
local base = SFSBaseMessage

function SeasonTowerInfoMessage:OnCreate(param)
  base.OnCreate(self)
end

function SeasonTowerInfoMessage:HandleMessage(t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
  else
    DataCenter.LWSeasonTowerManager:OnSeasonTowerInfoResp(t)
  end
end

return SeasonTowerInfoMessage
