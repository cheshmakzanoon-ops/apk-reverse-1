local BloodyQueenS1RestChooseCityDefendSetMessage = BaseClass("BloodyQueenS1RestChooseCityDefendSetMessage", SFSBaseMessage)
local base = SFSBaseMessage

function BloodyQueenS1RestChooseCityDefendSetMessage:OnCreate(operateType, cityId)
  base.OnCreate(self)
  self.sfsObj:PutInt("operateType", operateType)
  self.sfsObj:PutInt("cityId", cityId)
end

function BloodyQueenS1RestChooseCityDefendSetMessage:HandleMessage(t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
  else
  end
end

return BloodyQueenS1RestChooseCityDefendSetMessage
