local LWActMeteoriteAwardCtrl = BaseClass("LWActMeteoriteAwardCtrl", UIBaseCtrl)

function LWActMeteoriteAwardCtrl:CloseSelf()
  UIManager:GetInstance():DestroyWindow(UIWindowNames.LWActMeteoriteAward)
end

return LWActMeteoriteAwardCtrl
