local UILWTeamLeaderSelectCoinCtrl = BaseClass("UILWTeamLeaderSelectCoinCtrl", UIBaseCtrl)

function UILWTeamLeaderSelectCoinCtrl:CloseSelf()
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UILWTeamLeaderSelectCoin)
end

return UILWTeamLeaderSelectCoinCtrl
