local PushUserDesertInfoMessage = BaseClass("PushUserDesertInfoMessage", SFSBaseMessage)
local base = SFSBaseMessage

function PushUserDesertInfoMessage:OnCreate()
  base.OnCreate(self)
end

function PushUserDesertInfoMessage:HandleMessage(t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode == nil and t.fightWinLv then
    DataCenter.SeasonDataManager:UpdateDesertMaxLevel(toInt(t.fightWinLv))
  end
end

return PushUserDesertInfoMessage
