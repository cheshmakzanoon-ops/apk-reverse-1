local TreasureTenRewardPanelCtrl = BaseClass("TreasureTenRewardPanelCtrl", UIBaseCtrl)

function TreasureTenRewardPanelCtrl:SetView(view)
  self.view = view
end

function TreasureTenRewardPanelCtrl:CloseSelf()
  UIManager:GetInstance():DestroyWindow(UIWindowNames.TreasureTenRewardPanelView)
end

function TreasureTenRewardPanelCtrl:ShowReward(message, closeFunc)
  self:CloseSelf()
  if message and message.reward then
    DataCenter.ActDispatchTreasureManager:ShowDigReward(message, closeFunc)
  end
  self.view = nil
end

function TreasureTenRewardPanelCtrl:OnCustomKeyCodeEscape()
  EventManager:GetInstance():Broadcast(EventId.OnDispatchTreasureRewardEscClose)
  if self.view then
    self.view.btnClose:Click()
  else
    self:CloseSelf()
  end
end

return TreasureTenRewardPanelCtrl
