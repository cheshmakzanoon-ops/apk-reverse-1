local StartActivityBatchDigV2Message = BaseClass("StartActivityBatchDigV2Message", SFSBaseMessage)
local base = SFSBaseMessage

function StartActivityBatchDigV2Message:OnCreate(activityId)
  base.OnCreate(self)
  self.sfsObj:PutInt("activityId", activityId)
end

function StartActivityBatchDigV2Message:HandleMessage(t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
    DataCenter.ActivityTreasureHuntNewManager:OnReqBatchDigError()
  else
    DataCenter.ActivityTreasureHuntNewManager:OnReqBatchDig(t)
  end
end

return StartActivityBatchDigV2Message
