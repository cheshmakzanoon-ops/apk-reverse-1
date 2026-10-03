local SeasonPhotoMessageCtrl = BaseClass("SeasonPhotoMessageCtrl", UIBaseCtrl)

local function CloseSelf(self)
  UIManager:GetInstance():DestroyWindow(UIWindowNames.SeasonPhotoMessage)
end

SeasonPhotoMessageCtrl.CloseSelf = CloseSelf
return SeasonPhotoMessageCtrl
