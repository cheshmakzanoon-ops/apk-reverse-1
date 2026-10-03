local base = UIBaseContainer
local UILWDominatorGorillaTreatmentItemComponent = BaseClass("UILWDominatorGorillaTreatmentItemComponent", UIBaseContainer)
local Localization = CS.GameEntry.Localization

function UILWDominatorGorillaTreatmentItemComponent:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function UILWDominatorGorillaTreatmentItemComponent:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UILWDominatorGorillaTreatmentItemComponent:ComponentDefine()
  self.imgItemIcon = self:AddComponent(UIImage, "ItemIcon")
  self.btnItemIcon = self:AddComponent(UIButton, "ItemIcon")
  self.btnItemIcon:SetOnClick(function()
    self:OnBtnItemIconClick()
  end)
  self.textItemNum = self:AddComponent(UIText, "ItemNumText")
  self.btnLayout = self:AddComponent(UIButton, "Layout")
  self.btnLayout:SetSafeClickMode(true)
  self.btnLayout:SetSafeClickModeTime(2)
  self.btnLayout:SetOnClick(function()
    self:OnBtnLayoutClick()
  end)
  self.textEffect = self:AddComponent(UIText, "Layout/EffectText")
  self.compEffUiTreatmentItemSaoguang = self:AddComponent(UIBaseContainer, "VFX_saoguang")
  self.compEffUiTreatmentItemSaoguang:SetActive(false)
end

function UILWDominatorGorillaTreatmentItemComponent:ComponentDestroy()
  self.imgItemIcon = nil
  self.btnItemIcon = nil
  self.textItemNum = nil
  self.btnLayout = nil
  self.textEffect = nil
  self.compEffUiTreatmentItemSaoguang = nil
end

function UILWDominatorGorillaTreatmentItemComponent:DataDefine()
end

function UILWDominatorGorillaTreatmentItemComponent:DataDestroy()
  if self.delayTimer ~= nil then
    self.delayTimer:Stop()
    self.delayTimer = nil
  end
end

function UILWDominatorGorillaTreatmentItemComponent:ReInit(info, data, pageComp)
  self.info = info
  self.data = data
  self.pageComp = pageComp
  if self.info == nil or self.data == nil then
    return
  end
  local itemIcon = DataCenter.RewardManager:GetPicByType(RewardType.GOODS, self.data.itemId)
  if not string.IsNullOrEmpty(itemIcon) then
    self.imgItemIcon:LoadSprite(itemIcon)
  end
  local userCount = DataCenter.ItemData:GetItemCount(self.data.itemId)
  self.textItemNum:SetText("\195\151" .. tostring(userCount))
  self.textEffect:SetText("+" .. self.data.addProgress)
end

function UILWDominatorGorillaTreatmentItemComponent:OnAddListener()
  base.OnAddListener(self)
end

function UILWDominatorGorillaTreatmentItemComponent:OnRemoveListener()
  base.OnRemoveListener(self)
end

function UILWDominatorGorillaTreatmentItemComponent:OnBtnLayoutClick()
  if self.info == nil or self.data == nil then
    return
  end
  if not self.info:IsInTreatment() then
    return
  end
  if not self.pageComp then
    return
  end
  if self.pageComp.isTreatmentAnimPlaying then
    return
  end
  local userCount = DataCenter.ItemData:GetItemCount(self.data.itemId)
  if 1 <= userCount then
    DataCenter.DominatorManager:SendGorillaTreatmentMessage(self.info.uuid, self.data.itemId)
    if self.pageComp then
      self.pageComp.isTreatmentAnimPlaying = true
    end
  else
    self:OnBtnGotoClick()
  end
end

function UILWDominatorGorillaTreatmentItemComponent:OnBtnItemIconClick()
  if self.info == nil or self.data == nil then
    return
  end
  local param = {}
  param.itemId = self.data.itemId
  param.alignObject = self.imgItemIcon
  UIManager:GetInstance():OpenWindow(UIWindowNames.UIItemTips, {anim = true}, param)
end

function UILWDominatorGorillaTreatmentItemComponent:OnBtnGotoClick()
  if self.info == nil or self.data == nil then
    return
  end
  if not self.info:IsInTreatment() then
    return
  end
  LWResourceLackUtil:GotoGoodsItemLack(self.data.itemId, 1)
end

function UILWDominatorGorillaTreatmentItemComponent:PlayFinishAnim(delay)
  local function Play()
    if self.compEffUiTreatmentItemSaoguang then
      self.compEffUiTreatmentItemSaoguang:SetActive(true)
    end
  end
  
  if not delay or delay <= 0 then
    Play()
  else
    if self.delayTimer ~= nil then
      self.delayTimer:Stop()
      self.delayTimer = nil
    end
    self.delayTimer = TimerManager:GetInstance():DelayInvoke(function()
      Play()
    end, delay)
  end
end

return UILWDominatorGorillaTreatmentItemComponent
