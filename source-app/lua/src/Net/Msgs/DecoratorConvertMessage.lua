local DecoratorConvertMessage = BaseClass("DecoratorConvertMessage", SFSBaseMessage)
local base = SFSBaseMessage

function DecoratorConvertMessage:OnCreate(buildingId, num)
  base.OnCreate(self)
  self.sfsObj:PutInt("buildingId", buildingId)
  self.sfsObj:PutInt("num", num)
end

function DecoratorConvertMessage:HandleMessage(t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
  else
  end
end

return DecoratorConvertMessage
