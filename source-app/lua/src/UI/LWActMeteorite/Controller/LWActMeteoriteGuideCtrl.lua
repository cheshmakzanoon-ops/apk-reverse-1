local LWActMeteoriteGuideCtrl = BaseClass("LWActMeteoriteGuideCtrl", UIBaseCtrl)

function LWActMeteoriteGuideCtrl:CloseSelf()
  UIManager:GetInstance():DestroyWindow(UIWindowNames.LWActMeteoriteGuide)
end

return LWActMeteoriteGuideCtrl
