local ActLotteryDraw100ResultCtrl = BaseClass("ActLotteryDraw100ResultCtrl", UIBaseCtrl)

local function CloseSelf(self)
  UIManager:GetInstance():DestroyWindow(UIWindowNames.ActLotteryDraw100Result)
end

ActLotteryDraw100ResultCtrl.CloseSelf = CloseSelf
return ActLotteryDraw100ResultCtrl
