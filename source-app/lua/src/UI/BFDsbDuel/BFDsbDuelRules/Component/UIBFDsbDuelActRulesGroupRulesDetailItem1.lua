local base = UIBaseContainer
local UIBFDsbDuelActRulesGroupRulesDetailItem1 = BaseClass("UIBFDsbDuelActRulesGroupRulesDetailItem1", UIBaseContainer)
local Localization = CS.GameEntry.Localization

function UIBFDsbDuelActRulesGroupRulesDetailItem1:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function UIBFDsbDuelActRulesGroupRulesDetailItem1:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UIBFDsbDuelActRulesGroupRulesDetailItem1:ComponentDefine()
  self.viewSkin = self:AddComponent(UIViewSkinBridge, "")
  self.rawImgIcon = self.viewSkin:AddComponent(self, UIRawImage, 1)
  self.textIndexTxt = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 2)
  self.textDesc = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 3)
  self.compBG1 = self.viewSkin:AddComponent(self, UIBaseContainer, 4)
end

function UIBFDsbDuelActRulesGroupRulesDetailItem1:ComponentDestroy()
  self.viewSkin = nil
  self.rawImgIcon = nil
  self.textIndexTxt = nil
  self.textDesc = nil
  self.compBG1 = nil
end

function UIBFDsbDuelActRulesGroupRulesDetailItem1:DataDefine()
end

function UIBFDsbDuelActRulesGroupRulesDetailItem1:DataDestroy()
end

function UIBFDsbDuelActRulesGroupRulesDetailItem1:OnAddListener()
  base.OnAddListener(self)
end

function UIBFDsbDuelActRulesGroupRulesDetailItem1:OnRemoveListener()
  base.OnRemoveListener(self)
end

function UIBFDsbDuelActRulesGroupRulesDetailItem1:SetData(guideData, index)
  self.guideData = guideData
  self.compBG1:SetActive(1 < index)
  self.rawImgIcon:LoadSpriteAuto(guideData.pic)
  self.textIndexTxt:SetText(index)
  self.textDesc:SetLocalText(guideData.desc)
end

return UIBFDsbDuelActRulesGroupRulesDetailItem1
