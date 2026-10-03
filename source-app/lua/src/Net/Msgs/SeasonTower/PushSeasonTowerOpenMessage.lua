local PushSeasonTowerOpenMessage = BaseClass("PushSeasonTowerOpenMessage", SFSBaseMessage)
local base = SFSBaseMessage

function PushSeasonTowerOpenMessage:OnCreate(param)
  base.OnCreate(self)
end

function PushSeasonTowerOpenMessage:HandleMessage(t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
  else
    DataCenter.LWSeasonTowerManager:RequestSeasonInfo()
  end
end

return PushSeasonTowerOpenMessage
