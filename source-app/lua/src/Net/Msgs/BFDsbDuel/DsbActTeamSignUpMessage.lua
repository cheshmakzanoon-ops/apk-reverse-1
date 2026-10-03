local DsbActTeamSignUpMessage = BaseClass("DsbActTeamSignUpMessage", SFSBaseMessage)
local base = SFSBaseMessage

function DsbActTeamSignUpMessage:OnCreate(param)
  base.OnCreate(self)
  self.sfsObj:PutInt("team", param.team)
end

function DsbActTeamSignUpMessage:HandleMessage(t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
  else
    BattlefieldDsbDuelUtils.ActInfo:OnGetActTeamSignUpMsg(t)
  end
end

return DsbActTeamSignUpMessage
