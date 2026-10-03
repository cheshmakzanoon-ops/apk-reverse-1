local UICommonSpecRemindCtrl = BaseClass("UICommonSpecRemindCtrl", UIBaseCtrl)

function UICommonSpecRemindCtrl:CloseSelf()
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UICommonSpecRemind)
end

return UICommonSpecRemindCtrl
