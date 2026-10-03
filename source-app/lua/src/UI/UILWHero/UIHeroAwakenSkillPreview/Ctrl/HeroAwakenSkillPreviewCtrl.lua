local HeroAwakenSkillPreviewCtrl = BaseClass("HeroAwakenSkillPreviewCtrl", UIBaseCtrl)

function HeroAwakenSkillPreviewCtrl:CloseSelf()
  UIManager:GetInstance():DestroyWindow(UIWindowNames.HeroAwakenSkillPreview)
end

return HeroAwakenSkillPreviewCtrl
