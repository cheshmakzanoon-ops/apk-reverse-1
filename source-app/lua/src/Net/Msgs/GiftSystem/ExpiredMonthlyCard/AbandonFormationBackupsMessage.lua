local AbandonFormationBackupsMessage = BaseClass("AbandonFormationBackupsMessage", SFSBaseMessage)
local base = SFSBaseMessage

function AbandonFormationBackupsMessage:OnCreate(index)
  base.OnCreate(self)
  self.sfsObj:PutInt("index", index)
end

function AbandonFormationBackupsMessage:HandleMessage(t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
  else
    DataCenter.MonthCardNewManager:AbandonExpiredFormation()
  end
end

return AbandonFormationBackupsMessage
