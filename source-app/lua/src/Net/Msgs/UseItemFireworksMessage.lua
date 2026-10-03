local UseItemFireworksMessage = BaseClass("UseItemFireworksMessage", SFSBaseMessage)
local base = SFSBaseMessage

function UseItemFireworksMessage:OnCreate(itemId)
  base.OnCreate(self)
  self.sfsObj:PutInt("itemId", itemId)
end

function UseItemFireworksMessage:HandleMessage(t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
  else
  end
end

return UseItemFireworksMessage
