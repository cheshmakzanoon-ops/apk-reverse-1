local TCCardEquipConfirmCtrl = BaseClass("TCCardEquipConfirmCtrl", UIBaseCtrl)

local function CloseSelf(self)
  UIManager:GetInstance():DestroyWindow(UIWindowNames.TCCardEquipConfirm)
end

TCCardEquipConfirmCtrl.CloseSelf = CloseSelf
return TCCardEquipConfirmCtrl
