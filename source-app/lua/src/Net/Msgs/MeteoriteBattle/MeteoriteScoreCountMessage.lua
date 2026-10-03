local MeteoriteScoreCountMessage = BaseClass("MeteoriteScoreCountMessage", SFSBaseMessage)
local base = SFSBaseMessage

function MeteoriteScoreCountMessage:OnCreate()
  base.OnCreate(self)
end

function MeteoriteScoreCountMessage:HandleMessage(t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
  else
    DataCenter.ActMeteoriteBattleManager:OnScoreUpdate(t)
  end
end

return MeteoriteScoreCountMessage
