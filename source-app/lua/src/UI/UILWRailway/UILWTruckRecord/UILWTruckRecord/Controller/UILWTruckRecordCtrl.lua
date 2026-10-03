local UILWTruckRecordCtrl = BaseClass("UILWTruckRecordCtrl", UIBaseCtrl)

local function CloseSelf(self)
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UILWTruckRecord)
end

UILWTruckRecordCtrl.CloseSelf = CloseSelf
return UILWTruckRecordCtrl
