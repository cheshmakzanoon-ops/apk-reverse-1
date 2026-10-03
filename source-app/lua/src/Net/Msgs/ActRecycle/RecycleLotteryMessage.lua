local RecycleLotteryMessage = BaseClass("RecycleLotteryMessage", SFSBaseMessage)
local base = SFSBaseMessage

function RecycleLotteryMessage:OnCreate(activityId, num)
  base.OnCreate(self)
  self.sfsObj:PutInt("activityId", activityId)
  self.sfsObj:PutInt("num", num)
end

function RecycleLotteryMessage:HandleMessage(t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
  else
    DataCenter.ActRecycleManager:OnLotterySuccess(t)
  end
end

return RecycleLotteryMessage
