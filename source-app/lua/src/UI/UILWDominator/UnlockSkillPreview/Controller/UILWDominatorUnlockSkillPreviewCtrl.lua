local UILWDominatorUnlockSkillPreviewCtrl = BaseClass("UILWDominatorUnlockSkillPreviewCtrl", UIBaseCtrl)

local function CloseSelf(self)
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UILWDominatorUnlockSkillPreview)
end

UILWDominatorUnlockSkillPreviewCtrl.CloseSelf = CloseSelf
return UILWDominatorUnlockSkillPreviewCtrl
