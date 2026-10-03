local ValentineSendNpcRewardMessage = BaseClass("ValentineSendNpcRewardMessage", SFSBaseMessage)
local base = SFSBaseMessage

function ValentineSendNpcRewardMessage:OnCreate(param)
  base.OnCreate(self)
  self.sfsObj:PutInt("activityId", param.activityId)
  self.sfsObj:PutInt("type", param.type)
  self.sfsObj:PutInt("npcId", param.npcId)
end

function ValentineSendNpcRewardMessage:HandleMessage(t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
  else
    DataCenter.ValentineDataManager:OnNpcRewardGet(t)
  end
end

return ValentineSendNpcRewardMessage
