local S6CityAltarFishCtrl = BaseClass("S6CityAltarFishCtrl", UIBaseCtrl)

function S6CityAltarFishCtrl:CloseSelf()
  UIManager:GetInstance():DestroyWindow(UIWindowNames.S6CityAltarFish)
end

return S6CityAltarFishCtrl
