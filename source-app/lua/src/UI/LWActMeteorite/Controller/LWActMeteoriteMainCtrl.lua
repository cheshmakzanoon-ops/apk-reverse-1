local LWActMeteoriteMainCtrl = BaseClass("LWActMeteoriteMainCtrl", UIBaseCtrl)

function LWActMeteoriteMainCtrl:CloseSelf()
  UIManager:GetInstance():DestroyWindow(UIWindowNames.LWActMeteoriteMain)
end

return LWActMeteoriteMainCtrl
