local GuideRecordMessage = BaseClass("GuideRecordMessage", SFSBaseMessage)
local base = SFSBaseMessage

function GuideRecordMessage:OnCreate(type, step)
  base.OnCreate(self)
  self.sfsObj:PutUtfString("type", tostring(type))
  self.sfsObj:PutUtfString("step", tostring(step))
end

function GuideRecordMessage:HandleMessage(t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
  else
    DataCenter.GuideRecordDataManager:SetRecordTabData(t.type, t.step)
  end
end

return GuideRecordMessage
