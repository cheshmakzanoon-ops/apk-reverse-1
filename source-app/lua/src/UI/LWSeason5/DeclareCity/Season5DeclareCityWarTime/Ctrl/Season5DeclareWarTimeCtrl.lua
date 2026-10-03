local Season5DeclareWarTimeCtrl = BaseClass("Season5DeclareWarTimeCtrl", UIBaseCtrl)

function Season5DeclareWarTimeCtrl:CloseSelf()
  UIManager:GetInstance():DestroyWindow(UIWindowNames.Season5DeclareWarTimeView)
end

return Season5DeclareWarTimeCtrl
