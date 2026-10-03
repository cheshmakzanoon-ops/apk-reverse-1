local DominatorClickHandbookMessage = BaseClass("DominatorClickHandbookMessage", SFSBaseMessage)
local base = SFSBaseMessage

function DominatorClickHandbookMessage:OnCreate(param)
  base.OnCreate(self)
  self.sfsObj:PutLong("uuid", param.uuid)
  self.sfsObj:PutInt("id", param.id)
  DataCenter.DominatorManager:SetUnlockArchiveIdCache(param.id)
end

function DominatorClickHandbookMessage:HandleMessage(t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
  else
    DataCenter.DominatorManager:OnUnlockArchiveMessageCallback(t)
  end
end

return DominatorClickHandbookMessage
