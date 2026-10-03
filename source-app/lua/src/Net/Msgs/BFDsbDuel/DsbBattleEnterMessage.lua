local DsbBattleEnterMessage = BaseClass("DsbBattleEnterMessage", SFSBaseMessage)
local base = SFSBaseMessage

function DsbBattleEnterMessage:OnCreate(team)
  base.OnCreate(self)
  BattlefieldDsbDuelUtils.Log("\229\143\145\233\128\129\232\191\155\229\133\165\230\136\152\229\156\186\230\182\136\230\129\175\239\188\140team=%s", team)
  self.sfsObj:PutInt("team", team)
end

function DsbBattleEnterMessage:HandleMessage(t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
    return
  end
  DataCenter.BattlefieldDsbDuelManager:OnHandleEnterBattleMessage(t, false)
end

return DsbBattleEnterMessage
