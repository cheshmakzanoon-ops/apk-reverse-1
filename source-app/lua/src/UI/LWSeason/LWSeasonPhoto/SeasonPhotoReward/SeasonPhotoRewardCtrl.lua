local SeasonPhotoRewardCtrl = BaseClass("SeasonPhotoRewardCtrl", UIBaseCtrl)

local function CloseSelf(self)
  UIManager:GetInstance():DestroyWindow(UIWindowNames.SeasonPhotoReward)
end

SeasonPhotoRewardCtrl.CloseSelf = CloseSelf
return SeasonPhotoRewardCtrl
