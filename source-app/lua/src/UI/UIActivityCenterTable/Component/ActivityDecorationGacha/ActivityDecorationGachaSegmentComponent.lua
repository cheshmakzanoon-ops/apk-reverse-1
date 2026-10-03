local base = UIBaseContainer
local ActivityDecorationGachaSegmentComponent = BaseClass("ActivityDecorationGachaSegmentComponent", UIBaseContainer)
local Localization = CS.GameEntry.Localization

function ActivityDecorationGachaSegmentComponent:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function ActivityDecorationGachaSegmentComponent:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function ActivityDecorationGachaSegmentComponent:OnDisable()
  base.OnDisable(self)
  self:StopDelayShowTenGachaTimer()
end

function ActivityDecorationGachaSegmentComponent:UpdateAngle()
  if self.compUICommonResItem ~= nil then
    self.compUICommonResItem.transform.rotation = Quaternion.identity
  end
  if self.textSegmentDecorationCount ~= nil then
    self.textSegmentDecorationCount.transform.rotation = Quaternion.identity
  end
  if self.textTenGacha ~= nil then
    self.textTenGacha.transform.rotation = Quaternion.identity
  end
  self:UpdateItemCountTextPosition()
  self:UpdateResItemPosition()
end

function ActivityDecorationGachaSegmentComponent:ComponentDefine()
  self.compHightlightImage = self:AddComponent(UIBaseContainer, "HightlightImage")
  self.animator = self:AddComponent(UIAnimator, "")
  self.compUICommonResItem = self:AddComponent(UICommonResItem, "UICommonResItem")
  self.imgItemIcon = self:AddComponent(UIImage, "UICommonResItem/clickBtn/ItemIcon")
  self.materialItemIcon = self.imgItemIcon:GetMaterial()
  self.imgSegmentBackground = self:AddComponent(UIImage, "SegmentBackground")
  self.materialBackground = self.imgSegmentBackground:GetMaterial()
  self.textSegmentDecorationCount = self:AddComponent(UIText, "SegmentDecorationCountText")
  self.compEffUiSUIDecorationGachaMainDajiangDanchou = self:AddComponent(UIBaseContainer, "Eff_ui_s_UIDecorationGachaMain_dajiang_danchou")
  self.compEffUiSUIDecorationGachaMainDajiangShilian01 = self:AddComponent(UIBaseContainer, "Eff_ui_s_UIDecorationGachaMain_dajiang_shilian01")
  self.compEffUiSUIDecorationGachaMainDajiangShilian02 = self:AddComponent(UIBaseContainer, "Eff_ui_s_UIDecorationGachaMain_dajiang_shilian02")
  self.compTenGachaBackground = self:AddComponent(UIBaseContainer, "TenGachaRoot/TenGachaBackground")
  self.textTenGacha = self:AddComponent(UIText, "TenGachaRoot/TenGachaText")
  self.canvasTenGacha = self:AddComponent(UICanvasGroup, "TenGachaRoot/TenGachaText")
  self.canvasCount = self:AddComponent(UICanvasGroup, "SegmentDecorationCountText")
  self.compTenGachaRoot = self:AddComponent(UIBaseContainer, "TenGachaRoot")
end

function ActivityDecorationGachaSegmentComponent:ComponentDestroy()
  self.compHightlightImage = nil
  self.animator = nil
  self.btnUINew = nil
  self.imgSegmentBackground = nil
  self.imgSegmentDecoration = nil
  self.textSegmentDecorationCount = nil
  self.compEffUiSUIDecorationGachaMainDajiangDanchou = nil
  self.compEffUiSUIDecorationGachaMainDajiangShilian01 = nil
  self.compEffUiSUIDecorationGachaMainDajiangShilian02 = nil
  self.compTenGachaBackground = nil
  self.textTenGacha = nil
  self.compTenGachaRoot = nil
  self.materialItemIcon = nil
  self.materialBackground = nil
  self.canvasTenGacha = nil
  self.canvasCount = nil
end

function ActivityDecorationGachaSegmentComponent:DataDefine()
  self.activityId = nil
  self.itemData = nil
end

function ActivityDecorationGachaSegmentComponent:DataDestroy()
  self:StopDelayShowTenGachaTimer()
  self.activityId = nil
  self.itemData = nil
end

function ActivityDecorationGachaSegmentComponent:OnAddListener()
  base.OnAddListener(self)
end

function ActivityDecorationGachaSegmentComponent:OnRemoveListener()
  base.OnRemoveListener(self)
end

function ActivityDecorationGachaSegmentComponent:ReInit(activityId, itemData, index, isReset)
  self.activityId = activityId
  self.itemData = itemData
  self.index = index
  if self.activityId == nil or self.itemData == nil then
    return
  end
  self.imgSegmentBackground:LoadSprite(self.itemData:GetSegmentItemBaseImagePath())
  self.textSegmentDecorationCount:SetText("\195\151" .. tostring(self.itemData.itemNum))
  local para = {}
  para.rewardType = self.itemData.itemType
  para.itemId = self.itemData.itemId
  para.count = self.itemData.itemNum
  self.compUICommonResItem:ReInit(para)
  self.compUICommonResItem:SetImgQuailtyShow(false)
  self.compUICommonResItem:SetItemCountActive(false)
  self.compTenGachaRoot:SetActive(false)
  if isReset then
    self.compHightlightImage:SetActive(false)
  end
  self.animator:Play("kong")
end

function ActivityDecorationGachaSegmentComponent:SetTenGachaRootActive()
  if self.compTenGachaRoot ~= nil then
    self.compTenGachaRoot:SetActive(true)
  end
  if self.textTenGacha ~= nil then
    self.textTenGacha:SetText("1")
  end
end

function ActivityDecorationGachaSegmentComponent:StopDelayShowTenGachaTimer()
  if self.delayShowTenGachaTimer ~= nil then
    self.delayShowTenGachaTimer:Stop()
    self.delayShowTenGachaTimer = nil
  end
end

function ActivityDecorationGachaSegmentComponent:PlayBigRewardAnim(isTen)
  if isTen then
    local ret, time = self.animator:PlayAnimationReturnTime("shilianchou")
    if ret then
      self:StopDelayShowTenGachaTimer()
      self.delayShowTenGachaTimer = TimerManager:GetInstance():DelayInvoke(function()
        self:SetTenGachaRootActive()
      end, time)
    end
  else
    self.animator:Play("danchou")
  end
end

function ActivityDecorationGachaSegmentComponent:SetTenGachaText(count)
  self.animator:Play("chongfu")
  self:StopDelayShowTenGachaTimer()
  self.delayShowTenGachaTimer = TimerManager:GetInstance():DelayInvoke(function()
    if self.textTenGacha ~= nil then
      self.textTenGacha:SetText(tostring(count))
    end
  end, 0.4)
end

function ActivityDecorationGachaSegmentComponent:UpdateItemCountTextPosition()
  if self.imgSegmentBackground ~= nil and self.textSegmentDecorationCount ~= nil then
    local a = self.imgSegmentBackground.transform.position
    a = a + Vector3(0, -30, 0)
    self.textSegmentDecorationCount.transform.position = a
  end
end

function ActivityDecorationGachaSegmentComponent:UpdateResItemPosition()
  if self.imgSegmentBackground ~= nil and self.compUICommonResItem ~= nil then
    local a = self.imgSegmentBackground.transform.position
    self.compUICommonResItem.transform.position = a
  end
end

function ActivityDecorationGachaSegmentComponent:GetEulerAngles()
  return self.transform.eulerAngles
end

function ActivityDecorationGachaSegmentComponent:SetHighlightActive(isActive)
  self.compHightlightImage:SetActive(isActive)
end

function ActivityDecorationGachaSegmentComponent:SetBlur(value)
  if self.materialItemIcon ~= nil then
    self.materialItemIcon:SetFloat("_BlurOffset", value)
  end
  if self.materialBackground ~= nil then
    self.materialBackground:SetFloat("_BlurOffset", value)
  end
  if self.canvasTenGacha ~= nil then
    if 0.1 < value then
      self.canvasTenGacha:SetAlpha(0.2)
    else
      self.canvasTenGacha:SetAlpha(1)
    end
  end
  if self.canvasCount ~= nil then
    if 0.1 < value then
      self.canvasCount:SetAlpha(0.2)
    else
      self.canvasCount:SetAlpha(1)
    end
  end
end

return ActivityDecorationGachaSegmentComponent
