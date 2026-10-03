local UISetAttackTimesCtrl = BaseClass("UISetAttackTimesCtrl", UIBaseCtrl)

local function CloseSelf(self)
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UISetAttackTimes)
end

local function Close(self)
  UIManager:GetInstance():DestroyWindowByLayer(UILayer.Normal)
end

UISetAttackTimesCtrl.CloseSelf = CloseSelf
UISetAttackTimesCtrl.Close = Close
UISetAttackTimesCtrl.CheckName = CheckName
UISetAttackTimesCtrl.SendCheckNameMessage = SendCheckNameMessage
UISetAttackTimesCtrl.SendChangeNameMessage = SendChangeNameMessage
return UISetAttackTimesCtrl
