local S6MilitaryEliteScoreTipsCtrl = BaseClass("S6MilitaryEliteScoreTipsCtrl", UIBaseCtrl)

function S6MilitaryEliteScoreTipsCtrl:CloseSelf()
  UIManager:GetInstance():DestroyWindow(UIWindowNames.S6MilitaryEliteScoreTipsView)
end

return S6MilitaryEliteScoreTipsCtrl
