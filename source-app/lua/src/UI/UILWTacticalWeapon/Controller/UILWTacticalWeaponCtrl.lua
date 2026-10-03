local UILWTacticalWeaponCtrl = BaseClass("UILWTacticalWeaponCtrl", UIBaseCtrl)

local function CloseSelf(self)
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UILWTacticalWeapon)
end

local function SetAnimationFlag(self, status)
  self.aniFlag = status
end

local function OnCustomKeyCodeEscape(self)
  if self.aniFlag == true then
    return
  end
  self:CloseSelf()
end

UILWTacticalWeaponCtrl.CloseSelf = CloseSelf
UILWTacticalWeaponCtrl.OnCustomKeyCodeEscape = OnCustomKeyCodeEscape
UILWTacticalWeaponCtrl.SetAnimationFlag = SetAnimationFlag
return UILWTacticalWeaponCtrl
