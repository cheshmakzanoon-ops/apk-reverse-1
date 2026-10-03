local SeasonHunterMVPCtrl = BaseClass("SeasonHunterMVPCtrl", UIBaseCtrl)

local function CloseSelf(self)
  UIManager:GetInstance():DestroyWindow(UIWindowNames.SeasonHunterMVP)
end

SeasonHunterMVPCtrl.CloseSelf = CloseSelf
return SeasonHunterMVPCtrl
