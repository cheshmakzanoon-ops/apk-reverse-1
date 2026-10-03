local base = UIBaseContainer
local UILWMailDetailLandlordBuffItem = BaseClass("UILWMailDetailLandlordBuffItem", UIBaseContainer)
local Localization = CS.GameEntry.Localization

function UILWMailDetailLandlordBuffItem:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function UILWMailDetailLandlordBuffItem:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UILWMailDetailLandlordBuffItem:ComponentDefine()
  self.viewSkin = self:AddComponent(UIViewSkinBridge, "")
  self.imgBuffIcon = self.viewSkin:AddComponent(self, UIImage, 1)
end

function UILWMailDetailLandlordBuffItem:ComponentDestroy()
  self.viewSkin = nil
  self.imgBuffIcon = nil
end

function UILWMailDetailLandlordBuffItem:DataDefine()
end

function UILWMailDetailLandlordBuffItem:DataDestroy()
end

function UILWMailDetailLandlordBuffItem:OnAddListener()
  base.OnAddListener(self)
end

function UILWMailDetailLandlordBuffItem:OnRemoveListener()
  base.OnRemoveListener(self)
end

function UILWMailDetailLandlordBuffItem:ReInit(skillId)
  local stateTemplate = DataCenter.StatusManager:GetTemplate(skillId)
  if stateTemplate then
    self.imgBuffIcon:LoadSpriteAsync(stateTemplate.icon)
  end
end

return UILWMailDetailLandlordBuffItem
