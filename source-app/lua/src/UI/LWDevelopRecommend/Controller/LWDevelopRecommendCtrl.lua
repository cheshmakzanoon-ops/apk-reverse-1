local LWDevelopRecommendCtrl = BaseClass("LWDevelopRecommendCtrl", UIBaseCtrl)

function LWDevelopRecommendCtrl:CloseSelf()
  UIManager:GetInstance():DestroyWindow(UIWindowNames.LWDevelopRecommend)
end

return LWDevelopRecommendCtrl
