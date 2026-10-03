local UISurfingGuildCtrl = BaseClass("UISurfingGuildCtrl", UIBaseCtrl)

local function CloseSelf(self)
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UISurfingGuild, {anim = false})
end

UISurfingGuildCtrl.CloseSelf = CloseSelf
return UISurfingGuildCtrl
