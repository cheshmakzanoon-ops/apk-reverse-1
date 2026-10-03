local ActLotteryDrawResultCtrl = BaseClass("ActLotteryDrawResultCtrl", UIBaseCtrl)

local function CloseSelf(self)
  UIManager:GetInstance():DestroyWindow(UIWindowNames.ActLotteryDrawResult)
end

ActLotteryDrawResultCtrl.CloseSelf = CloseSelf
return ActLotteryDrawResultCtrl
