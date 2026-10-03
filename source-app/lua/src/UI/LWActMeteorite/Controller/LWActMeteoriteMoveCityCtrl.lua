local LWActMeteoriteMoveCityCtrl = BaseClass("LWActMeteoriteMoveCityCtrl", UIBaseCtrl)

function LWActMeteoriteMoveCityCtrl:CloseSelf()
  UIManager:GetInstance():DestroyWindow(UIWindowNames.LWActMeteoriteMoveCity)
end

return LWActMeteoriteMoveCityCtrl
