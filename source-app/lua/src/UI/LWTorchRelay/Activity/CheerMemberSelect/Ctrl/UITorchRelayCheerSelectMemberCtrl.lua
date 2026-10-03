local UITorchRelayCheerSelectMemberCtrl = BaseClass("UITorchRelayCheerSelectMemberCtrl", UIBaseCtrl)

function UITorchRelayCheerSelectMemberCtrl:CloseSelf()
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UITorchRelayCheerSelectMember)
end

function UITorchRelayCheerSelectMemberCtrl:GetMemberList(activityId)
  local data = DataCenter.ActivityTorchRelayManager:GetActivityData(activityId)
  if data == nil then
    Logger.LogError("[TorchRelay] what???   self.activityId \239\188\154" .. activityId)
    return
  end
  return data:GetAllCheerPlayersData()
end

return UITorchRelayCheerSelectMemberCtrl
