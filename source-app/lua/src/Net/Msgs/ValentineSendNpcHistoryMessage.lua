local ValentineSendNpcHistoryMessage = BaseClass("ValentineSendNpcHistoryMessage", SFSBaseMessage)
local base = SFSBaseMessage

function ValentineSendNpcHistoryMessage:OnCreate(param)
  base.OnCreate(self)
  self.sfsObj:PutInt("activityId", param.activityId)
end

function ValentineSendNpcHistoryMessage:HandleMessage(t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
  else
    DataCenter.ValentineDataManager:OnNpcHistoryDataUpdate(t)
  end
end

return ValentineSendNpcHistoryMessage
