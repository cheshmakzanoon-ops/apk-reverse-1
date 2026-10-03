local UIAlMemberRecommendCtrl = BaseClass("UIAlMemberRecommendCtrl", UIBaseCtrl)

local function CloseSelf(self)
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UIAlMemberRecommend)
end

UIAlMemberRecommendCtrl.CloseSelf = CloseSelf
return UIAlMemberRecommendCtrl
