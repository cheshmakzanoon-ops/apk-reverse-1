local BattleCardListMessage = BaseClass("BattleCardListMessage", SFSBaseMessage)
local base = SFSBaseMessage

function BattleCardListMessage:OnCreate(param)
  base.OnCreate(self)
end

function BattleCardListMessage:HandleMessage(t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
  else
    DataCenter.TacticalCardDataManager:UpdateDataFromServerData(t, false)
  end
end

return BattleCardListMessage
