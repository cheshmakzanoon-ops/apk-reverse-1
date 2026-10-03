local UIOffSeason1TaskCtrl = BaseClass("UIOffSeason1TaskCtrl", UIBaseCtrl)

function UIOffSeason1TaskCtrl:CloseSelf()
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UIOffSeason1Task)
end

return UIOffSeason1TaskCtrl
