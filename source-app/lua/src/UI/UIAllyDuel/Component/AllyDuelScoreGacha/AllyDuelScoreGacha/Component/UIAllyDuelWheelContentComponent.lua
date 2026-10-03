local base = UIBaseContainer
local UIAllyDuelWheelContentComponent = BaseClass("UIAllyDuelWheelContentComponent", UIBaseContainer)
local UIAllyDuelSegmentComponent = require("UI.UIAllyDuel.Component.AllyDuelScoreGacha.AllyDuelScoreGacha.Component.UIAllyDuelSegmentComponent")
local Localization = CS.GameEntry.Localization
UIAllyDuelWheelContentComponent.AnimParam = {
  SingleSegmentAngle = 36,
  RotateDirection = -1,
  PreRotateRound = 2,
  RotateDuration = 2.5
}

function UIAllyDuelWheelContentComponent:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function UIAllyDuelWheelContentComponent:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UIAllyDuelWheelContentComponent:OnDisable()
  base.OnDisable(self)
  if not IsNull(self.sequenceSegment) then
    self.sequenceSegment:Kill()
    self.sequenceSegment = nil
  end
  if not IsNull(self.sequenceWheel) then
    self.sequenceWheel:Kill()
    self.sequenceWheel = nil
  end
  self:ClearDelayShowTenGachaTimer()
  self.tenGachaRewardListCache = nil
  self.tenGachaCurPlayIndex = nil
end

function UIAllyDuelWheelContentComponent:ComponentDefine()
  self.viewSkin = self:AddComponent(UIViewSkinBridge, "")
  self.compEffUiSUIDecorationGachaMainXiaojiang = self.viewSkin:AddComponent(self, UIBaseContainer, 1)
  self.compPointerImageTop = self.viewSkin:AddComponent(self, UIBaseContainer, 2)
  self.compEffUiSUIDecorationGachaMainShilianStar = self.viewSkin:AddComponent(self, UIBaseContainer, 3)
  self.rawImgWheelBaseImage = self.viewSkin:AddComponent(self, UIRawImage, 4)
  self.compWheelSegmentContent = self.viewSkin:AddComponent(self, UIBaseContainer, 5)
  self.compWheelSegment01 = self.viewSkin:AddComponent(self, UIAllyDuelSegmentComponent, 6)
  self.compWheelSegment02 = self.viewSkin:AddComponent(self, UIAllyDuelSegmentComponent, 7)
  self.compWheelSegment03 = self.viewSkin:AddComponent(self, UIAllyDuelSegmentComponent, 8)
  self.compWheelSegment04 = self.viewSkin:AddComponent(self, UIAllyDuelSegmentComponent, 9)
  self.compWheelSegment05 = self.viewSkin:AddComponent(self, UIAllyDuelSegmentComponent, 10)
  self.compWheelSegment06 = self.viewSkin:AddComponent(self, UIAllyDuelSegmentComponent, 11)
  self.compWheelSegment07 = self.viewSkin:AddComponent(self, UIAllyDuelSegmentComponent, 12)
  self.compWheelSegment08 = self.viewSkin:AddComponent(self, UIAllyDuelSegmentComponent, 13)
  self.compWheelSegment09 = self.viewSkin:AddComponent(self, UIAllyDuelSegmentComponent, 14)
  self.compWheelSegment10 = self.viewSkin:AddComponent(self, UIAllyDuelSegmentComponent, 15)
  self.compSegments = {
    self.compWheelSegment01,
    self.compWheelSegment02,
    self.compWheelSegment03,
    self.compWheelSegment04,
    self.compWheelSegment05,
    self.compWheelSegment06,
    self.compWheelSegment07,
    self.compWheelSegment08,
    self.compWheelSegment09,
    self.compWheelSegment10
  }
  self.materialBaseImage = self.rawImgWheelBaseImage:GetMaterial()
end

function UIAllyDuelWheelContentComponent:ComponentDestroy()
  self.viewSkin = nil
  self.compEffUiSUIDecorationGachaMainXiaojiang = nil
  self.compPointerImageTop = nil
  self.compEffUiSUIDecorationGachaMainShilianStar = nil
  self.rawImgWheelBaseImage = nil
  self.compWheelSegmentContent = nil
  self.compWheelSegment01 = nil
  self.compWheelSegment02 = nil
  self.compWheelSegment03 = nil
  self.compWheelSegment04 = nil
  self.compWheelSegment05 = nil
  self.compWheelSegment06 = nil
  self.compWheelSegment07 = nil
  self.compWheelSegment08 = nil
  self.compWheelSegment09 = nil
  self.compWheelSegment10 = nil
  self.compSegments = nil
  self.materialBaseImage = nil
end

function UIAllyDuelWheelContentComponent:DataDefine()
  self.allRandomTemplateList = {}
  self.animEndCallback = nil
  self.showSegmentHighlight = nil
end

function UIAllyDuelWheelContentComponent:DataDestroy()
  if not IsNull(self.sequenceSegment) then
    self.sequenceSegment:Kill()
    self.sequenceSegment = nil
  end
  if not IsNull(self.sequenceWheel) then
    self.sequenceWheel:Kill()
    self.sequenceWheel = nil
  end
  self:ClearDelayShowTenGachaTimer()
  self.allRandomTemplateList = nil
  self.animEndCallback = nil
  self.showSegmentHighlight = nil
end

function UIAllyDuelWheelContentComponent:OnAddListener()
  base.OnAddListener(self)
end

function UIAllyDuelWheelContentComponent:OnRemoveListener()
  base.OnRemoveListener(self)
end

function UIAllyDuelWheelContentComponent:Update()
  if self.showSegmentHighlight and self.compSegments ~= nil and self.compPointerImageTop ~= nil then
    local pointerZ = self.compPointerImageTop.transform.eulerAngles.z
    for i, v in pairs(self.compSegments) do
      local angles = v:GetEulerAngles()
      local segmentZ = angles.z
      local left = segmentZ - 18
      local right = segmentZ + 18
      local isIn = pointerZ >= left and pointerZ < right or pointerZ >= left + 360 and pointerZ < right + 360 or pointerZ >= left - 360 and pointerZ < right - 360
      v:SetHighlightActive(isIn)
    end
  end
end

function UIAllyDuelWheelContentComponent:ReInit(configId, resetPointer)
  self.configId = configId
  self.showSegmentHighlight = true
  if resetPointer then
    self.curPointerIndex = 1
    local lastIndex = DataCenter.AllyDuelScoreGachaManager:GetLastGachaResultCache()
    self.compPointerImageTop.rectTransform.localRotation = Quaternion.Euler(0, 0, -1 * (lastIndex - 1) * self.AnimParam.SingleSegmentAngle)
    self.rawImgWheelBaseImage.rectTransform.localRotation = Quaternion.Euler(0, 0, 0)
    self.compWheelSegmentContent.rectTransform.localRotation = Quaternion.Euler(0, 0, 0)
  end
  self.compPointerImageTop:SetActive(true)
  local configData = DataCenter.AllyDuelScoreGachaManager:GetConfigData(self.configId)
  if configData == nil then
    return
  end
  local allItemData = configData:GetAllItemDataInOrder()
  for i, v in ipairs(self.compSegments) do
    v:SetActive(allItemData[i] ~= nil)
    if allItemData[i] ~= nil then
      v:ReInit(self.configId, allItemData[i], i, resetPointer)
    end
  end
  self.compEffUiSUIDecorationGachaMainShilianStar:SetActive(false)
  self:SetBlur(0)
  self:UpdateSegmentAngle()
end

function UIAllyDuelWheelContentComponent:SetBlur(value)
  if self.materialBaseImage ~= nil then
    self.materialBaseImage:SetFloat("_BlurOffset", value)
  end
  if self.compSegments ~= nil then
    for i, v in pairs(self.compSegments) do
      v:SetBlur(value)
    end
  end
end

function UIAllyDuelWheelContentComponent:UpdateSegmentAngle()
  if self.compSegments ~= nil then
    for i, v in pairs(self.compSegments) do
      v:UpdateAngle()
    end
  end
end

function UIAllyDuelWheelContentComponent:RotatePointerFromZeroToIndex(index, completeCallback)
  if self.compPointerImageTop == nil then
    return
  end
  self.compPointerImageTop:SetActive(true)
  if not IsNull(self.sequenceSegment) then
    self.sequenceSegment:Kill()
    self.sequenceSegment = nil
  end
  if not IsNull(self.sequenceWheel) then
    self.sequenceWheel:Kill()
    self.sequenceWheel = nil
  end
  local wheelRotateDelta = math.random(1, 9)
  local sequenceWheel = CS.DG.Tweening.DOTween.Sequence()
  local angleWheel = (self.AnimParam.SingleSegmentAngle * wheelRotateDelta + 360 * self.AnimParam.PreRotateRound) * -1 * self.AnimParam.RotateDirection
  sequenceWheel:Append(self.rawImgWheelBaseImage.transform:DORotate(Vector3.New(0, 0, angleWheel), self.AnimParam.RotateDuration, CS.DG.Tweening.RotateMode.FastBeyond360):SetEase(CS.DG.Tweening.Ease.InOutExpo))
  sequenceWheel:Join(self.compWheelSegmentContent.transform:DORotate(Vector3.New(0, 0, angleWheel), self.AnimParam.RotateDuration, CS.DG.Tweening.RotateMode.FastBeyond360):SetEase(CS.DG.Tweening.Ease.InOutExpo))
  sequenceWheel:Join(CS.DG.Tweening.DOTween.To(function()
    return 0
  end, function(value)
    local v = 0
    if value <= 0.5 then
      v = 6.25 * value ^ 2 + -0.5625
    else
      v = -4.17 * value ^ 2 + 2.04
    end
    if v < 0 then
      v = 0
    end
    self:SetBlur(v)
  end, 1, self.AnimParam.RotateDuration):SetEase(CS.DG.Tweening.Ease.Linear))
  sequenceWheel:OnUpdate(function()
    self:UpdateSegmentAngle()
  end)
  sequenceWheel:OnComplete(function()
    self:UpdateSegmentAngle()
  end)
  self.sequenceWheel = sequenceWheel
  local sequenceSegment = CS.DG.Tweening.DOTween.Sequence()
  local angleSegment = (self.AnimParam.SingleSegmentAngle * ((10 - wheelRotateDelta + index) % 10 - 1) + 360 * self.AnimParam.PreRotateRound) * self.AnimParam.RotateDirection
  sequenceSegment:Append(self.compPointerImageTop.transform:DORotate(Vector3.New(0, 0, angleSegment), self.AnimParam.RotateDuration, CS.DG.Tweening.RotateMode.FastBeyond360):SetEase(CS.DG.Tweening.Ease.InOutExpo))
  sequenceSegment:OnComplete(function()
    if completeCallback ~= nil then
      completeCallback(wheelRotateDelta)
    end
  end)
  self.sequenceSegment = sequenceSegment
end

function UIAllyDuelWheelContentComponent:PlayOneGachaAnim(index)
  self.showSegmentHighlight = true
  self:RotatePointerFromZeroToIndex(index, function(wheelRotateDelta)
    self.showSegmentHighlight = false
    if self.animEndCallback ~= nil then
      self.animEndCallback()
    end
  end)
end

function UIAllyDuelWheelContentComponent:PlayTenGachaAnimHelper(endLoopCallback)
  if table.IsNullOrEmpty(self.tenGachaRewardListCache) then
    if endLoopCallback ~= nil then
      endLoopCallback()
    end
    return
  end
  if self.tenGachaCurPlayIndex == nil then
    if endLoopCallback ~= nil then
      endLoopCallback()
    end
    return
  end
  if self.tenGachaCurPlayIndex > #self.tenGachaRewardListCache then
    if endLoopCallback ~= nil then
      endLoopCallback()
    end
    return
  end
  self:RotatePointerFromZeroToIndex(self.tenGachaRewardListCache[self.tenGachaCurPlayIndex].pos or 1, function()
    if table.IsNullOrEmpty(self.tenGachaRewardListCache) or self.tenGachaCurPlayIndex > #self.tenGachaRewardListCache then
      return
    end
    local delayNextTime = 0.5
    local rewardIndex = self.tenGachaRewardListCache[self.tenGachaCurPlayIndex].pos or 1
    if self.hasShownRewardIndexList[rewardIndex] == nil then
      if self.compSegments ~= nil and self.compSegments[rewardIndex] ~= nil then
        self.compSegments[rewardIndex]:SetTenGachaRootActive()
      end
      self.hasShownRewardIndexList[rewardIndex] = 1
    else
      self.hasShownRewardIndexList[rewardIndex] = self.hasShownRewardIndexList[rewardIndex] + 1
      if self.compSegments ~= nil and self.compSegments[rewardIndex] ~= nil then
        self.compSegments[rewardIndex]:SetTenGachaText(self.hasShownRewardIndexList[rewardIndex])
      end
      if self.compEffUiSUIDecorationGachaMainShilianStar ~= nil then
        self.compEffUiSUIDecorationGachaMainShilianStar:SetActive(true)
      end
    end
    self.tenGachaCurPlayIndex = self.tenGachaCurPlayIndex + 1
    self.delayShowTenGachaTimer = TimerManager:GetInstance():DelayInvoke(function()
      if self.compEffUiSUIDecorationGachaMainShilianStar ~= nil then
        self.compEffUiSUIDecorationGachaMainShilianStar:SetActive(false)
      end
      self:ClearDelayShowTenGachaTimer()
      self:PlayTenGachaAnimHelper(endLoopCallback)
    end, delayNextTime)
  end)
end

function UIAllyDuelWheelContentComponent:PlayTenGachaAnim(rewardList)
  self.showSegmentHighlight = true
  self.tenGachaRewardListCache = rewardList
  self.hasShownRewardIndexList = {}
  self.tenGachaCurPlayIndex = 1
  self:PlayTenGachaAnimHelper(function()
    self.showSegmentHighlight = false
    if self.animEndCallback ~= nil then
      self.animEndCallback()
    end
  end)
end

function UIAllyDuelWheelContentComponent:PlayGachaAnim(evtData, animEndCallback)
  if evtData == nil or evtData.num == nil or evtData.data == nil then
    return
  end
  if table.IsNullOrEmpty(evtData.data.rewardArr) then
    return
  end
  self.animEndCallback = animEndCallback
  if evtData.num == 1 then
    local index = evtData.data.rewardArr[1].pos
    self:PlayOneGachaAnim(index)
  else
    self:PlayTenGachaAnim(evtData.data.rewardArr)
  end
end

function UIAllyDuelWheelContentComponent:ClearDelayShowTenGachaTimer()
  if self.delayShowTenGachaTimer ~= nil then
    self.delayShowTenGachaTimer:Stop()
    self.delayShowTenGachaTimer = nil
  end
end

return UIAllyDuelWheelContentComponent
