local RecoverFormationBackupsMessage = BaseClass("RecoverFormationBackupsMessage", SFSBaseMessage)
local base = SFSBaseMessage

function RecoverFormationBackupsMessage:OnCreate(index)
  base.OnCreate(self)
  self.sfsObj:PutInt("index", index)
end

function RecoverFormationBackupsMessage:HandleMessage(t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
  elseif t then
    DataCenter.MonthCardNewManager:RecoverExpiredFormation(t)
  end
end

return RecoverFormationBackupsMessage
