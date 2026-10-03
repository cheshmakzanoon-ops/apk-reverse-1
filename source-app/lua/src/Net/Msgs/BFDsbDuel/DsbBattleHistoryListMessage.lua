local DsbBattleHistoryListMessage = BaseClass("DsbBattleHistoryListMessage", SFSBaseMessage)
local base = SFSBaseMessage

function DsbBattleHistoryListMessage:OnCreate(param)
  base.OnCreate(self)
end

function DsbBattleHistoryListMessage:HandleMessage(t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
  else
    BattlefieldDsbDuelUtils.ActInfo:OnGetBattleHistoryList(t)
  end
end

return DsbBattleHistoryListMessage
