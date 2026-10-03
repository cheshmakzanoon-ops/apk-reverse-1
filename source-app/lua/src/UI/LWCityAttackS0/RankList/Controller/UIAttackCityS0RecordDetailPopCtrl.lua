local UIAttackCityS0RecordDetailPopCtrl = BaseClass("UIAttackCityS0RecordDetailPopCtrl", UIBaseCtrl)

local function CloseSelf(self)
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UIAttackCityS0RecordDetailPop, {anim = false})
end

UIAttackCityS0RecordDetailPopCtrl.CloseSelf = CloseSelf
return UIAttackCityS0RecordDetailPopCtrl
