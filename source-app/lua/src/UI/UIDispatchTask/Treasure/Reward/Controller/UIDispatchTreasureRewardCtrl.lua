local UIDispatchTreasureRewardCtrl = BaseClass("UIDispatchTreasureRewardCtrl", UIBaseCtrl)

local function SetView(self, view)
  self.view = view
end

local function CloseSelf(self)
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UIDispatchTreasureReward)
end

local function ShowReward(self, message, closeFunc)
  self:CloseSelf()
  if message and message.reward then
    DataCenter.ActDispatchTreasureManager:ShowDigReward(message, closeFunc)
  end
  self.view = nil
end

local function OnCustomKeyCodeEscape(self)
  EventManager:GetInstance():Broadcast(EventId.OnDispatchTreasureRewardEscClose)
  if self.view then
    self:ShowReward(self.view.message, self.view.closeCallback)
  else
    self:CloseSelf()
  end
end

UIDispatchTreasureRewardCtrl.CloseSelf = CloseSelf
UIDispatchTreasureRewardCtrl.ShowReward = ShowReward
UIDispatchTreasureRewardCtrl.OnCustomKeyCodeEscape = OnCustomKeyCodeEscape
UIDispatchTreasureRewardCtrl.SetView = SetView
return UIDispatchTreasureRewardCtrl
