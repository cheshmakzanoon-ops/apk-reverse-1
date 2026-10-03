local DsbActPlayerListMessage = BaseClass("DsbActPlayerListMessage", SFSBaseMessage)
local base = SFSBaseMessage

function DsbActPlayerListMessage:OnCreate(param)
  base.OnCreate(self)
end

function DsbActPlayerListMessage:HandleMessage(t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
  else
    BattlefieldDsbDuelUtils.ActInfo:OnGetActPlayerListMsg(t)
  end
end

return DsbActPlayerListMessage
