local UseItemDecorationMessage = BaseClass("UseItemDecorationMessage", SFSBaseMessage)
local base = SFSBaseMessage

function UseItemDecorationMessage:OnCreate(itemId)
  base.OnCreate(self)
  self.sfsObj:PutInt("itemId", toInt(itemId))
end

function UseItemDecorationMessage:HandleMessage(t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
  else
    UIUtil.ShowTipsId(120089)
  end
end

return UseItemDecorationMessage
