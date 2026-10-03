local LWCityDefenceCtrl = BaseClass("LWCityDefenceCtrl", UIBaseCtrl)

local function CloseSelf(self, useAnimation)
  UIManager:GetInstance():DestroyWindow(UIWindowNames.LWCityDefence, {anim = useAnimation})
end

local function GetFormationList()
  return {
    1,
    2,
    3,
    4
  }
end

LWCityDefenceCtrl.CloseSelf = CloseSelf
return LWCityDefenceCtrl
