local base = UIBaseContainer
local UILWT11IdleGameSurpriseBoxItemComponent = BaseClass("UILWT11IdleGameSurpriseBoxItemComponent", UIBaseContainer)
local Localization = CS.GameEntry.Localization

function UILWT11IdleGameSurpriseBoxItemComponent:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function UILWT11IdleGameSurpriseBoxItemComponent:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UILWT11IdleGameSurpriseBoxItemComponent:ComponentDefine()
  self.viewSkin = self:AddComponent(UIViewSkinBridge, "")
  self.compUICommonResItem = self.viewSkin:AddComponent(self, UICommonResItem, 1)
end

function UILWT11IdleGameSurpriseBoxItemComponent:ComponentDestroy()
  self.viewSkin = nil
  self.compUICommonResItem = nil
end

function UILWT11IdleGameSurpriseBoxItemComponent:DataDefine()
end

function UILWT11IdleGameSurpriseBoxItemComponent:DataDestroy()
end

function UILWT11IdleGameSurpriseBoxItemComponent:ReInit(data)
  self.compUICommonResItem:ReInit(data)
end

return UILWT11IdleGameSurpriseBoxItemComponent
