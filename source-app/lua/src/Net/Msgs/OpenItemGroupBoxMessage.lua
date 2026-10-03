local OpenItemGroupBoxMessage = BaseClass("OpenItemGroupBoxMessage", SFSBaseMessage)
local base = SFSBaseMessage

function OpenItemGroupBoxMessage:OnCreate(param)
  base.OnCreate(self)
  self.sfsObj:PutUtfString("itemId", tostring(param.itemId))
  self.sfsObj:PutInt("num", param.num)
end

function OpenItemGroupBoxMessage:HandleMessage(t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
  else
    DataCenter.BoxItemDrawManager:OnOpenItemGroupBox(t)
  end
end

return OpenItemGroupBoxMessage
