local SeasonPhotoListCtrl = BaseClass("SeasonPhotoListCtrl", UIBaseCtrl)

local function CloseSelf(self)
  UIManager:GetInstance():DestroyWindow(UIWindowNames.SeasonPhotoList)
end

SeasonPhotoListCtrl.CloseSelf = CloseSelf
return SeasonPhotoListCtrl
