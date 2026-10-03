local UIActSlotMachineTipCommonCtrl = BaseClass("UIActSlotMachineTipCommonCtrl", UIBaseCtrl)

local function CloseSelf(self)
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UIActSlotMachineTipCommon)
end

UIActSlotMachineTipCommonCtrl.CloseSelf = CloseSelf
return UIActSlotMachineTipCommonCtrl
