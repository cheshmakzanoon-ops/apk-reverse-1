local PushBattleCardDataMessage = BaseClass("PushBattleCardDataMessage", SFSBaseMessage)
local base = SFSBaseMessage

function PushBattleCardDataMessage:OnCreate(param)
  base.OnCreate(self)
end

function PushBattleCardDataMessage:HandleMessage(t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
  else
    DataCenter.TacticalCardDataManager:UpdateDataFromServerData(t, false)
  end
end

return PushBattleCardDataMessage
