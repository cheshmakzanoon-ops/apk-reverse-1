local UILWSeasonVirusRankCtrl = BaseClass("UILWSeasonVirusRankCtrl", UIBaseCtrl)

function UILWSeasonVirusRankCtrl:CloseSelf()
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UILWSeasonVirusRank)
end

return UILWSeasonVirusRankCtrl
