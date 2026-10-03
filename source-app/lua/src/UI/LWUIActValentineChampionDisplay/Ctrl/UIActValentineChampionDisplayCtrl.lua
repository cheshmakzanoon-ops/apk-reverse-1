local UIActValentineChampionDisplayCtrl = BaseClass("UIActValentineChampionDisplayCtrl", UIBaseCtrl)

local function CloseSelf(self)
  UIManager:GetInstance():DestroyWindow(UIWindowNames.ValentineChampionDisplay)
end

UIActValentineChampionDisplayCtrl.CloseSelf = CloseSelf
return UIActValentineChampionDisplayCtrl
