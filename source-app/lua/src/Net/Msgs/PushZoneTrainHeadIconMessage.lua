local PushZoneTrainHeadIconMessage = BaseClass("PushZoneTrainHeadIconMessage", SFSBaseMessage)
local base = SFSBaseMessage

function PushZoneTrainHeadIconMessage:OnCreate(param)
  base.OnCreate(self)
end

function PushZoneTrainHeadIconMessage:HandleMessage(t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
  elseif t.passengerHeadInfos then
    DataCenter.HSRDataManager:SetHeadInfos(t.passengerHeadInfos)
  end
end

return PushZoneTrainHeadIconMessage
