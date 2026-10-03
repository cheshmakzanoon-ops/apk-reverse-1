local base = UIBaseContainer
local LWUIRewardChangePreview_HonorShop_NewItemComponent = BaseClass("LWUIRewardChangePreview_HonorShop_NewItemComponent", UIBaseContainer)
local Localization = CS.GameEntry.Localization

function LWUIRewardChangePreview_HonorShop_NewItemComponent:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function LWUIRewardChangePreview_HonorShop_NewItemComponent:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function LWUIRewardChangePreview_HonorShop_NewItemComponent:ComponentDefine()
  self.viewSkin = self:AddComponent(UIViewSkinBridge, "")
  self.compUICommonResItem01 = self.viewSkin:AddComponent(self, UICommonResItem, 1)
  self.textNum = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 2)
  self.anim = self.transform:GetComponent(typeof(CS.UnityEngine.Animation))
end

function LWUIRewardChangePreview_HonorShop_NewItemComponent:ComponentDestroy()
  self.viewSkin = nil
  self.compUICommonResItem01 = nil
  self.textNum = nil
end

function LWUIRewardChangePreview_HonorShop_NewItemComponent:DataDefine()
end

function LWUIRewardChangePreview_HonorShop_NewItemComponent:DataDestroy()
end

function LWUIRewardChangePreview_HonorShop_NewItemComponent:OnAddListener()
  base.OnAddListener(self)
end

function LWUIRewardChangePreview_HonorShop_NewItemComponent:OnRemoveListener()
  base.OnRemoveListener(self)
end

function LWUIRewardChangePreview_HonorShop_NewItemComponent:ReInit(reward, limitCount)
  self.compUICommonResItem01:ReInit(reward)
  self.textNum:SetText(tostring(limitCount))
end

function LWUIRewardChangePreview_HonorShop_NewItemComponent:PlayIn()
  if IsNotNull(self.anim) then
    self.anim:Play()
  end
end

return LWUIRewardChangePreview_HonorShop_NewItemComponent
