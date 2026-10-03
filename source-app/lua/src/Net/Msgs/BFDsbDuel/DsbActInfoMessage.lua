local DsbActInfoMessage = BaseClass("DsbActInfoMessage", SFSBaseMessage)
local base = SFSBaseMessage

function DsbActInfoMessage:OnCreate(param)
  base.OnCreate(self)
end

function DsbActInfoMessage:HandleMessage(t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
  else
    DataCenter.BattlefieldDsbDuelManager:OnGetActInfoMsg(t)
  end
end

return DsbActInfoMessage
