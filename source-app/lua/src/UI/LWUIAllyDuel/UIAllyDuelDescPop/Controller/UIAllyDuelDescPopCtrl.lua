local UIAllyDuelDescPopCtrl = BaseClass("UIAllyDuelDescPopCtrl", UIBaseCtrl)

function UIAllyDuelDescPopCtrl:CloseSelf()
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UIAllyDuelDescPop)
end

return UIAllyDuelDescPopCtrl
