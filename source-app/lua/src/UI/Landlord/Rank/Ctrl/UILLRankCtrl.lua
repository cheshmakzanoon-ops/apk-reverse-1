local UILLRankCtrl = BaseClass("UILLRankCtrl", UIBaseCtrl)

function UILLRankCtrl:CloseSelf()
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UILLRank)
end

return UILLRankCtrl
