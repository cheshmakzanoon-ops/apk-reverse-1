local UICityEventUAVRewardCtrl = BaseClass("UICityEventUAVRewardCtrl", UIBaseCtrl)

local function CloseSelf(self)
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UICityEventUAVRewardView, {anim = false})
end

UICityEventUAVRewardCtrl.CloseSelf = CloseSelf
return UICityEventUAVRewardCtrl
