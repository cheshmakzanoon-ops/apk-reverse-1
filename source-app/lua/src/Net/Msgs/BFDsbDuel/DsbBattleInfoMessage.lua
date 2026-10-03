local DsbBattleInfoMessage = BaseClass("DsbBattleInfoMessage", SFSBaseMessage)
local base = SFSBaseMessage

function DsbBattleInfoMessage:OnCreate(param)
  base.OnCreate(self)
  self.sfsObj:PutInt("team", param.team)
end

function DsbBattleInfoMessage:HandleMessage(t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
  else
    DataCenter.BattlefieldDsbDuelManager:OnGetBattleInfoMsg(t)
  end
end

return DsbBattleInfoMessage
