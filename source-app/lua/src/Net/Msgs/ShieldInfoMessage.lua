local ShieldInfoMessage = BaseClass("ShieldInfoMessage", SFSBaseMessage)
local base = SFSBaseMessage

function ShieldInfoMessage:OnCreate(targetUuid)
  base.OnCreate(self)
  if targetUuid then
    self.sfsObj:PutLong("targetUuid", targetUuid)
  end
end

function ShieldInfoMessage:HandleMessage(t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
  else
    DataCenter.DefenceWallDataManager:SetWallBar(t)
  end
end

return ShieldInfoMessage
