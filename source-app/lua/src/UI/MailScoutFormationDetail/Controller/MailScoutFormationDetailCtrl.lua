local MailScoutFormationDetailCtrl = BaseClass("MailScoutFormationDetailCtrl", UIBaseCtrl)

local function CloseSelf(self, useAnimation)
  UIManager:GetInstance():DestroyWindow(UIWindowNames.MailScoutFormationDetail, {anim = useAnimation})
end

MailScoutFormationDetailCtrl.CloseSelf = CloseSelf
return MailScoutFormationDetailCtrl
