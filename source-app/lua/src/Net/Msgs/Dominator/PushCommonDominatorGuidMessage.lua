local PushCommonDominatorGuidMessage = BaseClass("PushCommonDominatorGuidMessage", SFSBaseMessage)
local base = SFSBaseMessage

function PushCommonDominatorGuidMessage:OnCreate(param)
  base.OnCreate(self)
  self.sfsObj:PutInt("dominatorId", param.dominatorId)
  self.sfsObj:PutInt("guid", param.guid)
end

function PushCommonDominatorGuidMessage:HandleMessage(t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
  else
    DataCenter.DominatorCockatriceUnlockManager:UpdateGuideProgress(t, false)
  end
end

return PushCommonDominatorGuidMessage
