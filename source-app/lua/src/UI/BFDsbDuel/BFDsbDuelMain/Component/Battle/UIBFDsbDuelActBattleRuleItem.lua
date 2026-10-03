local base = UIBaseContainer
local UIBFDsbDuelActBattleRuleItem = BaseClass("UIBFDsbDuelActBattleRuleItem", UIBaseContainer)
local Localization = CS.GameEntry.Localization

function UIBFDsbDuelActBattleRuleItem:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function UIBFDsbDuelActBattleRuleItem:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UIBFDsbDuelActBattleRuleItem:ComponentDefine()
  self.viewSkin = self:AddComponent(UIViewSkinBridge, "")
  self.imgIcon = self.viewSkin:AddComponent(self, UIImage, 1)
  self.textTxt = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 2)
  self.compLine = self.viewSkin:AddComponent(self, UIBaseContainer, 3)
end

function UIBFDsbDuelActBattleRuleItem:ComponentDestroy()
  self.viewSkin = nil
  self.imgIcon = nil
  self.textTxt = nil
  self.compLine = nil
end

function UIBFDsbDuelActBattleRuleItem:DataDefine()
end

function UIBFDsbDuelActBattleRuleItem:DataDestroy()
end

function UIBFDsbDuelActBattleRuleItem:OnAddListener()
  base.OnAddListener(self)
end

function UIBFDsbDuelActBattleRuleItem:OnRemoveListener()
  base.OnRemoveListener(self)
end

function UIBFDsbDuelActBattleRuleItem:SetData(data)
  self.imgIcon:LoadSpriteAuto(data.pic)
  self.textTxt:SetLocalText(data.desc)
  self.compLine:SetActive(not data.isLast)
end

return UIBFDsbDuelActBattleRuleItem
