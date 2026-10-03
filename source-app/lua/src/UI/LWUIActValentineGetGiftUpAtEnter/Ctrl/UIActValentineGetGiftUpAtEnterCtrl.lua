local UIActValentineGetGiftUpAtEnterCtrl = BaseClass("UIActValentineGetGiftUpAtEnterCtrl", UIBaseCtrl)

local function CloseSelf(self)
  UIManager:GetInstance():DestroyWindow(UIWindowNames.ValentineGetGiftUpAtEnter)
end

UIActValentineGetGiftUpAtEnterCtrl.CloseSelf = CloseSelf
return UIActValentineGetGiftUpAtEnterCtrl
