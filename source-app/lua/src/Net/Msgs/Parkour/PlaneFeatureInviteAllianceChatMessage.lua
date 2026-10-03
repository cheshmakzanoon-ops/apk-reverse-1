local PlaneFeatureInviteAllianceChatMessage = BaseClass("PlaneFeatureInviteAllianceChatMessage", SFSBaseMessage)
local base = SFSBaseMessage

function PlaneFeatureInviteAllianceChatMessage:OnCreate(stageId)
  base.OnCreate(self)
  self.sfsObj:PutInt("stageId", stageId)
end

function PlaneFeatureInviteAllianceChatMessage:HandleMessage(t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
  else
    UIUtil.ShowTipsId(120061)
    local shareTimes = t.shareTimes
    local lastShareTime = t.lastShareTime
    DataCenter.LWStageFeatureChapterManager:UpdateShareTimes(shareTimes)
    DataCenter.LWStageFeatureChapterManager:UpdateLastShareTime(lastShareTime)
  end
end

return PlaneFeatureInviteAllianceChatMessage
