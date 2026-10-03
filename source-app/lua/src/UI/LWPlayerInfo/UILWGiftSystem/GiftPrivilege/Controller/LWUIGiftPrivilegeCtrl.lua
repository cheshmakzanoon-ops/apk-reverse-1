local LWUIGiftPrivilegeCtrl = BaseClass("LWUIGiftPrivilegeCtrl", UIBaseCtrl)

local function CloseSelf(self)
  UIManager:GetInstance():DestroyWindow(UIWindowNames.LWUIGiftPrivilege)
end

LWUIGiftPrivilegeCtrl.CloseSelf = CloseSelf
return LWUIGiftPrivilegeCtrl
