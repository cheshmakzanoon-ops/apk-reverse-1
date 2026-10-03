local UIAllyDuelBoxTechUpPopCtrl = BaseClass("UIAllyDuelBoxTechUpPopCtrl", UIBaseCtrl)

function UIAllyDuelBoxTechUpPopCtrl:CloseSelf()
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UIAllyDuelBoxTechUpPop)
end

return UIAllyDuelBoxTechUpPopCtrl
