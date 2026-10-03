local ValentineCrossBaseRewardMessage = BaseClass("ValentineCrossBaseRewardMessage", SFSBaseMessage)
local base = SFSBaseMessage

function ValentineCrossBaseRewardMessage:OnCreate(param)
  base.OnCreate(self)
  self.sfsObj:PutInt("activityId", param.activityId)
  self.sfsObj:PutUtfString("otherUid", param.otherUid)
end

function ValentineCrossBaseRewardMessage:HandleMessage(t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
  else
    UIUtil.ShowTipsId("360037")
  end
end

return ValentineCrossBaseRewardMessage
