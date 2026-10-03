local LWActMeteoriteRankAwardCtrl = BaseClass("LWActMeteoriteRankAwardCtrl", UIBaseCtrl)

function LWActMeteoriteRankAwardCtrl:CloseSelf()
  UIManager:GetInstance():DestroyWindow(UIWindowNames.LWActMeteoriteRankAward)
end

return LWActMeteoriteRankAwardCtrl
