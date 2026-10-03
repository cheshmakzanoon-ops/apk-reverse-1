local base = UIBaseContainer
local UIBountyHunterSweepRewardItemComponent = BaseClass("UIBountyHunterSweepRewardItemComponent", UIBaseContainer)
local Localization = CS.GameEntry.Localization
local u_i_common_res_item_path = "UICommonResItem"

function UIBountyHunterSweepRewardItemComponent:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function UIBountyHunterSweepRewardItemComponent:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UIBountyHunterSweepRewardItemComponent:ComponentDefine()
  self.viewSkin = self:AddComponent(UIViewSkinBridge, "")
  self.anim = self.viewSkin:AddComponent(self, UISimpleAnimation, 1)
  self.effectNormal = self.viewSkin:AddComponent(self, UIBaseContainer, 2)
  self.effectSpecial = self.viewSkin:AddComponent(self, UIBaseContainer, 3)
  self.u_i_common_res_item = self:AddComponent(UICommonResItem, u_i_common_res_item_path)
end

function UIBountyHunterSweepRewardItemComponent:ComponentDestroy()
  if self.timer then
    self.timer:Stop()
    self.timer = nil
  end
  self.viewSkin = nil
  self.anim = nil
  self.effectNormal = nil
  self.effectSpecial = nil
  self.u_i_common_res_item = nil
end

function UIBountyHunterSweepRewardItemComponent:DataDefine()
end

function UIBountyHunterSweepRewardItemComponent:DataDestroy()
end

function UIBountyHunterSweepRewardItemComponent:ReInit(data)
  self.template = DataCenter.ItemTemplateManager:GetItemTemplate(data.value.id)
  local itemParam = UICommonResItem.Param.New()
  itemParam.rewardType = data.type
  itemParam.itemId = data.value.id
  itemParam.count = data.value.num
  itemParam.enableClick = true
  self.u_i_common_res_item:ReInit(itemParam)
  self.u_i_common_res_item:SetRewardAlpha(0)
end

function UIBountyHunterSweepRewardItemComponent:Show()
  self.u_i_common_res_item:SetRewardAlpha(1)
end

function UIBountyHunterSweepRewardItemComponent:ShowAnim(delay)
  if delay == nil or delay <= 0 then
    self:ShowEffect()
    return
  end
  if self.timer then
    self.timer:Stop()
    self.timer = nil
  end
  self.timer = TimerManager:GetInstance():DelayInvoke(function()
    self:ShowEffect()
  end, delay)
end

function UIBountyHunterSweepRewardItemComponent:ShowEffect()
  self.u_i_common_res_item:SetRewardAlpha(1)
  self.u_i_common_res_item:PlayAnimator("Eff_ui_icon_chuxian_tongyong_new")
  self.u_i_common_res_item:SetRewardEffect(0.7)
end

return UIBountyHunterSweepRewardItemComponent
