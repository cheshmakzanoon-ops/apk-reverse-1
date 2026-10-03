local DsbActTeamModifyMessage = BaseClass("DsbActTeamModifyMessage", SFSBaseMessage)
local base = SFSBaseMessage

function DsbActTeamModifyMessage:OnCreate(param)
  base.OnCreate(self)
  self.sfsObj:PutBool("open", param.open)
end

function DsbActTeamModifyMessage:HandleMessage(t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
  else
    BattlefieldDsbDuelUtils.ActInfo:OnGetActTeamModifyMsg(t)
  end
end

return DsbActTeamModifyMessage
