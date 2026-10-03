local UILWSeasonOutpostRankS6Ctrl = BaseClass("UILWSeasonOutpostRankS6Ctrl", UIBaseCtrl)

function UILWSeasonOutpostRankS6Ctrl:CloseSelf()
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UILWSeasonOutpostRankS6)
end

return UILWSeasonOutpostRankS6Ctrl
