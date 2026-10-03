local DsbActSignUpMessage = BaseClass("DsbActSignUpMessage", SFSBaseMessage)
local base = SFSBaseMessage

function DsbActSignUpMessage:OnCreate(param)
  base.OnCreate(self)
end

function DsbActSignUpMessage:HandleMessage(t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
  else
    BattlefieldDsbDuelUtils.ActInfo:OnGetActSignUpMsg(t)
  end
end

return DsbActSignUpMessage
