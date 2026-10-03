local DsbBattlePlayerInfoMessage = BaseClass("DsbBattlePlayerInfoMessage", SFSBaseMessage)
local base = SFSBaseMessage

function DsbBattlePlayerInfoMessage:OnCreate(team)
  base.OnCreate(self)
  self.sfsObj:PutInt("group", team)
end

function DsbBattlePlayerInfoMessage:HandleMessage(t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
  else
    DataCenter.BattlefieldDsbDuelManager:OnHandleBattlePlayerInfoMsg(t)
  end
end

return DsbBattlePlayerInfoMessage
