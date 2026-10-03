local base = UIBaseContainer
local UIBFDsbDuelActRulesGroupRulesDetailItem2 = BaseClass("UIBFDsbDuelActRulesGroupRulesDetailItem2", UIBaseContainer)
local Localization = CS.GameEntry.Localization

function UIBFDsbDuelActRulesGroupRulesDetailItem2:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function UIBFDsbDuelActRulesGroupRulesDetailItem2:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UIBFDsbDuelActRulesGroupRulesDetailItem2:ComponentDefine()
  self.viewSkin = self:AddComponent(UIViewSkinBridge, "")
  self.textIndexTxt = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 1)
  self.imgIcon2 = self.viewSkin:AddComponent(self, UIImage, 2)
  self.compBG1 = self.viewSkin:AddComponent(self, UIBaseContainer, 3)
  self.imgIcon1 = self.viewSkin:AddComponent(self, UIImage, 4)
  self.imgIcon3 = self.viewSkin:AddComponent(self, UIImage, 5)
  self.textDesc1 = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 6)
  self.textDesc2 = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 7)
  self.textDesc3 = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 8)
  self.textRankTxt = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 9)
  self.textDesc4 = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 10)
  self.imgIcon4 = self.viewSkin:AddComponent(self, UIImage, 11)
  self.textRankTxt:SetLocalText("302043")
end

function UIBFDsbDuelActRulesGroupRulesDetailItem2:ComponentDestroy()
  self.viewSkin = nil
  self.textIndexTxt = nil
  self.imgIcon2 = nil
  self.compBG1 = nil
  self.imgIcon1 = nil
  self.imgIcon3 = nil
  self.textDesc1 = nil
  self.textDesc2 = nil
  self.textDesc3 = nil
  self.textRankTxt = nil
  self.textDesc4 = nil
  self.imgIcon4 = nil
end

function UIBFDsbDuelActRulesGroupRulesDetailItem2:DataDefine()
end

function UIBFDsbDuelActRulesGroupRulesDetailItem2:DataDestroy()
end

function UIBFDsbDuelActRulesGroupRulesDetailItem2:OnAddListener()
  base.OnAddListener(self)
end

function UIBFDsbDuelActRulesGroupRulesDetailItem2:OnRemoveListener()
  base.OnRemoveListener(self)
end

function UIBFDsbDuelActRulesGroupRulesDetailItem2:SetData(guideData, index)
  self.guideData = guideData
  local descList = string.split(guideData.desc, ",")
  if 8 <= #descList then
    self.imgIcon1:LoadSpriteAuto(descList[1])
    self.imgIcon2:LoadSpriteAuto(descList[3])
    self.imgIcon3:LoadSpriteAuto(descList[5])
    self.imgIcon4:LoadSpriteAuto(descList[7])
    self.textDesc1:SetLocalText(descList[2])
    self.textDesc2:SetLocalText(descList[4])
    self.textDesc3:SetLocalText(descList[6])
    self.textDesc4:SetLocalText(descList[8])
  end
  self.compBG1:SetActive(1 < index)
  self.textIndexTxt:SetText(index)
end

return UIBFDsbDuelActRulesGroupRulesDetailItem2
