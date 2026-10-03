local UILWTruckRecordDetailCtrl = BaseClass("UILWTruckRecordDetailCtrl", UIBaseCtrl)

local function CloseSelf(self)
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UILWTruckRecordDetail)
end

UILWTruckRecordDetailCtrl.CloseSelf = CloseSelf
return UILWTruckRecordDetailCtrl
