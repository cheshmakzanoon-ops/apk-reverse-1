local LWUIGiftShowDetailInfoCtrl = BaseClass("LWUIGiftShowDetailInfoCtrl", UIBaseCtrl)

local function CloseSelf(self)
  UIManager:GetInstance():DestroyWindow(UIWindowNames.LWUIGiftShowDetailInfo)
end

LWUIGiftShowDetailInfoCtrl.CloseSelf = CloseSelf
return LWUIGiftShowDetailInfoCtrl
