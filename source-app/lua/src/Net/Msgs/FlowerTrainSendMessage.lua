local FlowerTrainSendMessage = BaseClass("FlowerTrainSendMessage", SFSBaseMessage)
local base = SFSBaseMessage
local Localization = CS.GameEntry.Localization

function FlowerTrainSendMessage:OnCreate(pointId, itemId)
  base.OnCreate(self)
  self.sfsObj:PutInt("itemId", itemId)
  self.sfsObj:PutInt("pointId", pointId)
end

function FlowerTrainSendMessage:HandleMessage(t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    if t.errorPara2 then
      UIUtil.ShowTips(Localization:GetString(errCode, table.unpack(t.errorPara2)))
    else
      UIUtil.ShowTipsId(errCode)
    end
  else
  end
end

return FlowerTrainSendMessage
