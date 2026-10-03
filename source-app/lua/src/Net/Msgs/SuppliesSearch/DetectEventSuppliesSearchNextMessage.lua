local DetectEventSuppliesSearchNextMessage = BaseClass("DetectEventSuppliesSearchNextMessage", SFSBaseMessage)
local base = SFSBaseMessage

function DetectEventSuppliesSearchNextMessage:OnCreate(uuid)
  base.OnCreate(self)
  self.sfsObj:PutLong("eventUuid", uuid)
end

function DetectEventSuppliesSearchNextMessage:HandleMessage(t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
  else
    DataCenter.SuppliesSearchManager:UpdateSuppliesSearchInfo(SuppliesSearchType.Detect, t)
  end
end

return DetectEventSuppliesSearchNextMessage
