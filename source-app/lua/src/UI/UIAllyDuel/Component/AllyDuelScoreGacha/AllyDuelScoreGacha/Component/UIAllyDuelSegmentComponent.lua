local base = UIBaseContainer
local UIAllyDuelSegmentComponent = BaseClass("UIAllyDuelSegmentComponent", UIBaseContainer)
local Localization = CS.GameEntry.Localization

function UIAllyDuelSegmentComponent:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function UIAllyDuelSegmentComponent:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UIAllyDuelSegmentComponent:ComponentDefine()
  self.viewSkin = self:AddComponent(UIViewSkinBridge, "")
  self.rawImgHightlightImage = self.viewSkin:AddComponent(self, UIRawImage, 1)
  self.animator = self.viewSkin:AddComponent(self, UIAnimator, 2)
  self.compUICommonResItem = self.viewSkin:AddComponent(self, UICommonResItem, 3)
  self.imgItemIcon = self.viewSkin:AddComponent(self, UIImage, 4)
  self.imgSegmentBackground = self.viewSkin:AddComponent(self, UIImage, 5)
  self.textSegmentDecorationCount = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 6)
  self.compEffUiSUIDecorationGachaMainDajiangDanchou = self.viewSkin:AddComponent(self, UIBaseContainer, 7)
  self.compEffUiSUIDecorationGachaMainDajiangShilian01 = self.viewSkin:AddComponent(self, UIBaseContainer, 8)
  self.compEffUiSUIDecorationGachaMainDajiangShilian02 = self.viewSkin:AddComponent(self, UIBaseContainer, 9)
  self.compTenGachaBackground = self.viewSkin:AddComponent(self, UIBaseContainer, 10)
  self.textTenGacha = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 11)
  self.canvasCount = self.viewSkin:AddComponent(self, UICanvasGroup, 12)
  self.compTenGachaRoot = self.viewSkin:AddComponent(self, UIBaseContainer, 13)
  self.canvasTenGacha = self.viewSkin:AddComponent(self, UICanvasGroup, 14)
  self.materialItemIcon = self.imgItemIcon:GetMaterial()
  self.materialBackground = self.imgSegmentBackground:GetMaterial()
end

function UIAllyDuelSegmentComponent:ComponentDestroy()
  self.viewSkin = nil
  self.rawImgHightlightImage = nil
  self.animator = nil
  self.compUICommonResItem = nil
  self.imgItemIcon = nil
  self.imgSegmentBackground = nil
  self.textSegmentDecorationCount = nil
  self.compEffUiSUIDecorationGachaMainDajiangDanchou = nil
  self.compEffUiSUIDecorationGachaMainDajiangShilian01 = nil
  self.compEffUiSUIDecorationGachaMainDajiangShilian02 = nil
  self.compTenGachaBackground = nil
  self.textTenGacha = nil
  self.canvasCount = nil
  self.compTenGachaRoot = nil
  self.canvasTenGacha = nil
  self.materialItemIcon = nil
  self.materialBackground = nil
end

function UIAllyDuelSegmentComponent:DataDefine()
  self.itemData = nil
  self.configId = nil
end

function UIAllyDuelSegmentComponent:DataDestroy()
  self:StopDelayShowTenGachaTimer()
  self.itemData = nil
  self.configId = nil
end

function UIAllyDuelSegmentComponent:OnAddListener()
  base.OnAddListener(self)
end

function UIAllyDuelSegmentComponent:OnRemoveListener()
  base.OnRemoveListener(self)
end

function UIAllyDuelSegmentComponent:ReInit(configId, itemData, index, isReset)
  self.configId = configId
  self.itemData = itemData
  self.index = index
  if self.configId == nil or self.itemData == nil then
    return
  end
  self.imgSegmentBackground:LoadSpriteAuto(self.itemData:GetSegmentItemBaseImagePath())
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
    self.rawImgHightlightImage:SetActive(false)
  end
  self.animator:Play("kong")
end

function UIAllyDuelSegmentComponent:SetTenGachaRootActive()
  if self.compTenGachaRoot ~= nil then
    self.compTenGachaRoot:SetActive(true)
  end
  if self.textTenGacha ~= nil then
    self.textTenGacha:SetText("1")
  end
end

function UIAllyDuelSegmentComponent:StopDelayShowTenGachaTimer()
  if self.delayShowTenGachaTimer ~= nil then
    self.delayShowTenGachaTimer:Stop()
    self.delayShowTenGachaTimer = nil
  end
end

function UIAllyDuelSegmentComponent:PlayBigRewardAnim(isTen)
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

function UIAllyDuelSegmentComponent:SetTenGachaText(count)
  self.animator:Play("chongfu")
  self:StopDelayShowTenGachaTimer()
  self.delayShowTenGachaTimer = TimerManager:GetInstance():DelayInvoke(function()
    if self.textTenGacha ~= nil then
      self.textTenGacha:SetText(tostring(count))
    end
  end, 0.4)
end

function UIAllyDuelSegmentComponent:UpdateItemCountTextPosition()
  if self.imgSegmentBackground ~= nil and self.textSegmentDecorationCount ~= nil then
    local a = self.imgSegmentBackground.transform.position
    a = a + Vector3(0, -30, 0)
    self.textSegmentDecorationCount.transform.position = a
  end
end

function UIAllyDuelSegmentComponent:UpdateResItemPosition()
  if self.imgSegmentBackground ~= nil and self.compUICommonResItem ~= nil then
    local a = self.imgSegmentBackground.transform.position
    self.compUICommonResItem.transform.position = a
  end
end

function UIAllyDuelSegmentComponent:GetEulerAngles()
  return self.transform.eulerAngles
end

function UIAllyDuelSegmentComponent:SetHighlightActive(isActive)
  self.rawImgHightlightImage:SetActive(isActive)
end

function UIAllyDuelSegmentComponent:SetBlur(value)
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

function UIAllyDuelSegmentComponent:UpdateAngle()
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

return UIAllyDuelSegmentComponent
