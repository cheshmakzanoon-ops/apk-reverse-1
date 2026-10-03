local UITrainDriverInviteCtrl = BaseClass("UITrainDriverInviteCtrl", UIBaseCtrl)

local function CloseSelf(self)
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UITrainDriverInvite)
end

local function Close(self)
  UIManager:GetInstance():DestroyWindowByLayer(UILayer.Normal)
end

UITrainDriverInviteCtrl.CloseSelf = CloseSelf
UITrainDriverInviteCtrl.Close = Close
return UITrainDriverInviteCtrl
