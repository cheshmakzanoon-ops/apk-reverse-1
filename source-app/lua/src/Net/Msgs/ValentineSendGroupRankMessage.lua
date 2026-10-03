local ValentineSendGroupRankMessage = BaseClass("ValentineSendGroupRankMessage", SFSBaseMessage)
local base = SFSBaseMessage

function ValentineSendGroupRankMessage:OnCreate(activityId, type, startIndex, endIndex)
  base.OnCreate(self)
  self.sfsObj:PutInt("activityId", activityId)
  self.sfsObj:PutInt("start", startIndex)
  self.sfsObj:PutInt("end", endIndex)
  self.sfsObj:PutInt("type", type)
end

function ValentineSendGroupRankMessage:HandleMessage(t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
  else
  end
end

return ValentineSendGroupRankMessage
