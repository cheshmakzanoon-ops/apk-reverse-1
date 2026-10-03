local PushFlowerTrainDayTimesMessage = BaseClass("PushFlowerTrainDayTimesMessage", SFSBaseMessage)
local base = SFSBaseMessage

function PushFlowerTrainDayTimesMessage:OnCreate(param)
  base.OnCreate(self)
end

function PushFlowerTrainDayTimesMessage:HandleMessage(t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
  else
    DataCenter.FlowerTrainDataManager:UpdateInteractionNumData(t)
  end
end

return PushFlowerTrainDayTimesMessage
