local UIFishRankCtrl = BaseClass("UIFishRankCtrl", UIBaseCtrl)

function UIFishRankCtrl:CloseSelf()
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UIFishRank)
end

return UIFishRankCtrl
