local UILWTeamLeaderSelectCoinS4Ctrl = BaseClass("UILWTeamLeaderSelectCoinCtrl", UIBaseCtrl)

function UILWTeamLeaderSelectCoinS4Ctrl:CloseSelf()
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UILWTeamLeaderSelectCoinS4)
end

return UILWTeamLeaderSelectCoinS4Ctrl
