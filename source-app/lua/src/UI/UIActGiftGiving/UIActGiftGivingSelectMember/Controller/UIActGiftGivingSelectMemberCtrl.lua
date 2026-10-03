local UIActGiftGivingSelectMemberCtrl = BaseClass("UIActGiftGivingSelectMemberCtrl", UIBaseCtrl)

local function CloseSelf(self, useAnimation)
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UIActGiftGivingSelectMember, {anim = useAnimation})
end

local function Close(self)
  UIManager:GetInstance():DestroyWindowByLayer(UILayer.Normal)
end

UIActGiftGivingSelectMemberCtrl.CloseSelf = CloseSelf
UIActGiftGivingSelectMemberCtrl.Close = Close
return UIActGiftGivingSelectMemberCtrl
