local PushAllianceCongratulationReceiveVisitorMessage = BaseClass("PushAllianceCongratulationReceiveVisitorMessage", SFSBaseMessage)
local base = SFSBaseMessage

function PushAllianceCongratulationReceiveVisitorMessage:OnCreate(param)
  base.OnCreate(self)
end

function PushAllianceCongratulationReceiveVisitorMessage:HandleMessage(t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
  else
    DataCenter.RewardManager:AddRewardsAndRes(t)
    UIManager:GetInstance():OpenWindow(UIWindowNames.LWAllianceThumbsUpPopView, {anim = true}, t)
    if t.visitorUidList then
      for _, v in ipairs(t.visitorUidList) do
        DataCenter.CityVisitorManager:RemoveAllianceCongratulationVisitorList(v)
      end
    end
  end
end

return PushAllianceCongratulationReceiveVisitorMessage
