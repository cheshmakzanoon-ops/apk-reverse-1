local base = UIBaseContainer
local LWUIRewardChangePreview_HonorShop_NewTitleComponent = BaseClass("LWUIRewardChangePreview_HonorShop_NewTitleComponent", UIBaseContainer)
local Localization = CS.GameEntry.Localization

function LWUIRewardChangePreview_HonorShop_NewTitleComponent:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function LWUIRewardChangePreview_HonorShop_NewTitleComponent:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function LWUIRewardChangePreview_HonorShop_NewTitleComponent:ComponentDefine()
  self.viewSkin = self:AddComponent(UIViewSkinBridge, "")
  self.textTitle = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 1)
  self.anim = self.transform:GetComponent(typeof(CS.UnityEngine.Animation))
end

function LWUIRewardChangePreview_HonorShop_NewTitleComponent:ComponentDestroy()
  self.viewSkin = nil
  self.textTitle = nil
end

function LWUIRewardChangePreview_HonorShop_NewTitleComponent:DataDefine()
end

function LWUIRewardChangePreview_HonorShop_NewTitleComponent:DataDestroy()
end

function LWUIRewardChangePreview_HonorShop_NewTitleComponent:OnAddListener()
  base.OnAddListener(self)
end

function LWUIRewardChangePreview_HonorShop_NewTitleComponent:OnRemoveListener()
  base.OnRemoveListener(self)
end

function LWUIRewardChangePreview_HonorShop_NewTitleComponent:ReInit(title)
  self.textTitle:SetText(title)
end

function LWUIRewardChangePreview_HonorShop_NewTitleComponent:PlayIn()
  if IsNotNull(self.anim) then
    self.anim:Play()
  end
end

return LWUIRewardChangePreview_HonorShop_NewTitleComponent
