local AllianceRecommendGainAllianceInfoForJumpMessage = BaseClass("AllianceRecommendGainAllianceInfoForJumpMessage", SFSBaseMessage)
local base = SFSBaseMessage

function AllianceRecommendGainAllianceInfoForJumpMessage:OnCreate(param)
  base.OnCreate(self)
end

function AllianceRecommendGainAllianceInfoForJumpMessage:HandleMessage(t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
  else
    UIManager:GetInstance():OpenWindow(UIWindowNames.UILWAlSwitchJob, {anim = true}, t)
  end
end

return AllianceRecommendGainAllianceInfoForJumpMessage
