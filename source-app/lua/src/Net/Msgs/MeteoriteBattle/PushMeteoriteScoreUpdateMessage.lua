local PushMeteoriteScoreUpdateMessage = BaseClass("PushMeteoriteScoreUpdateMessage", SFSBaseMessage)
local base = SFSBaseMessage

function PushMeteoriteScoreUpdateMessage:OnCreate()
  base.OnCreate(self)
end

function PushMeteoriteScoreUpdateMessage:HandleMessage(t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
    return
  end
  DataCenter.ActMeteoriteBattleManager:OnScoreUpdate(t)
end

return PushMeteoriteScoreUpdateMessage
