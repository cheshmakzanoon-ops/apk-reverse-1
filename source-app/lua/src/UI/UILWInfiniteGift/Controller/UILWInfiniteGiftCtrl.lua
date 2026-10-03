local UILWInfiniteGiftCtrl = BaseClass("UILWInfiniteGiftCtrl", UIBaseCtrl)

local function CloseSelf(self)
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UILWInfiniteGift)
end

UILWInfiniteGiftCtrl.CloseSelf = CloseSelf
UILWInfiniteGiftCtrl.Close = Close
return UILWInfiniteGiftCtrl
