local UIHeroRecruitPreviewCtrl = BaseClass("UIHeroRecruitPreviewCtrl", UIBaseCtrl)

function UIHeroRecruitPreviewCtrl:CloseSelf()
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UIHeroRecruitPreview, {anim = false})
end

function UIHeroRecruitPreviewCtrl:SetCurIndex(index)
  self.curIndex = index
end

function UIHeroRecruitPreviewCtrl:GetCurIndex()
  return self.curIndex
end

return UIHeroRecruitPreviewCtrl
