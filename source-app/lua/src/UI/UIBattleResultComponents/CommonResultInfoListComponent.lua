local base = UIBaseContainer
local CommonResultInfoListComponent = BaseClass("CommonResultInfoListComponent", UIBaseContainer)
local Localization = CS.GameEntry.Localization

function CommonResultInfoListComponent:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function CommonResultInfoListComponent:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function CommonResultInfoListComponent:ComponentDefine()
  self.viewSkin = self:AddComponent(UIViewSkinBridge, "")
  self.imgIcon = self.viewSkin:AddComponent(self, UIImage, 1)
  self.textTxtInfo = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 2)
  self.compNum = self.viewSkin:AddComponent(self, UIBaseComponent, 3)
  self.textTxtInfoNum = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 4)
  self.textTxtInfoNumAfter = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 5)
  self.imgNewRecord = self.viewSkin:AddComponent(self, UIImage, 6)
  self.textRecordTitle = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 7)
  self.rootSimpleAnimation = self.viewSkin:AddComponent(self, UISimpleAnimation, 8)
  self.canvasGroupImgBg = self.viewSkin:AddComponent(self, UICanvasGroup, 9)
  self.imgArrow = self.viewSkin:AddComponent(self, UIImage, 10)
end

function CommonResultInfoListComponent:ComponentDestroy()
  self.viewSkin = nil
  self.imgIcon = nil
  self.textTxtInfo = nil
  self.compNum = nil
  self.textTxtInfoNum = nil
  self.textTxtInfoNumAfter = nil
  self.imgNewRecord = nil
  self.textRecordTitle = nil
  self.rootSimpleAnimation = nil
  self.canvasGroupImgBg = nil
  self.imgArrow = nil
end

function CommonResultInfoListComponent:DataDefine()
end

function CommonResultInfoListComponent:DataDestroy()
end

function CommonResultInfoListComponent:OnAddListener()
  base.OnAddListener(self)
end

function CommonResultInfoListComponent:OnRemoveListener()
  base.OnRemoveListener(self)
end

function CommonResultInfoListComponent:ReInit(data)
  if not data then
    return
  end
  if data.icon then
    self.imgIcon:LoadSpriteAsync(data.icon)
  end
  self.textTxtInfo:SetText(data.name or "")
  self.textTxtInfoNum:SetText(data.valueStr or "")
  if data.valueStrNew then
    self.imgArrow:SetActive(true)
    self.textTxtInfoNumAfter:SetActive(true)
    self.textTxtInfoNumAfter:SetText(data.valueStrNew)
  else
    self.imgArrow:SetActive(false)
    self.textTxtInfoNumAfter:SetActive(false)
  end
  if data.tipStr then
    self.imgNewRecord:SetActive(true)
    self.textRecordTitle:SetText(data.tipStr)
  else
    self.imgNewRecord:SetActive(false)
  end
  CS.UnityEngine.UI.LayoutRebuilder.ForceRebuildLayoutImmediate(self.compNum.transform)
end

function CommonResultInfoListComponent:SetRootAlpha(alpha)
  if self.canvasGroupImgBg then
    self.canvasGroupImgBg:SetAlpha(alpha)
  end
end

function CommonResultInfoListComponent:RewindPlayRootAnimation(animationName)
  if self.rootSimpleAnimation then
    self.rootSimpleAnimation:Rewind(animationName)
    self.rootSimpleAnimation:Play(animationName)
  end
end

function CommonResultInfoListComponent:StopRootAnimation()
  if self.rootSimpleAnimation then
    self.rootSimpleAnimation:Stop()
  end
end

return CommonResultInfoListComponent
