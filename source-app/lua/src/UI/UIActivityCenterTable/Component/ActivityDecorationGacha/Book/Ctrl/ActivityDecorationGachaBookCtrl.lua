local ActivityDecorationGachaBookCtrl = BaseClass("ActivityDecorationGachaBookCtrl", UIBaseCtrl)

function ActivityDecorationGachaBookCtrl:CloseSelf()
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UIActivityDecorationGachaBook)
end

return ActivityDecorationGachaBookCtrl
