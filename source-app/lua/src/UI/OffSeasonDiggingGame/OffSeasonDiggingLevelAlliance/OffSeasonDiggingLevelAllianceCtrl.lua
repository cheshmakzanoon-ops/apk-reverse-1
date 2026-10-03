local OffSeasonDiggingLevelAllianceCtrl = BaseClass("OffSeasonDiggingLevelAllianceCtrl", UIBaseCtrl)

local function CloseSelf(self)
  UIManager:GetInstance():DestroyWindow(UIWindowNames.OffSeasonDiggingLevelAllianceView, {anim = true, playEffect = false})
end

local function OnCustomKeyCodeEscape(self)
  local window = UIManager:GetInstance():GetWindow(UIWindowNames.OffSeasonDiggingLevelAllianceView)
  if window and window.View then
    window.View:PlayCloseAni()
  end
end

OffSeasonDiggingLevelAllianceCtrl.CloseSelf = CloseSelf
OffSeasonDiggingLevelAllianceCtrl.OnCustomKeyCodeEscape = OnCustomKeyCodeEscape
return OffSeasonDiggingLevelAllianceCtrl
