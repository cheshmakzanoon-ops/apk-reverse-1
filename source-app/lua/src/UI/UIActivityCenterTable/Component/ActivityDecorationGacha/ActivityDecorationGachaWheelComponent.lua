local base = UIBaseContainer
local ActivityDecorationUpgradeWheelComponent = BaseClass("ActivityDecorationUpgradeWheelComponent", UIBaseContainer)
local Localization = CS.GameEntry.Localization
local ActivityDecorationGachaSegmentComponent = require("UI/UIActivityCenterTable/Component/ActivityDecorationGacha/ActivityDecorationGachaSegmentComponent")
ActivityDecorationUpgradeWheelComponent.AnimParam = {
  SingleSegmentAngle = 36,
  RotateDirection = -1,
  PreRotateRound = 2,
  RotateDuration = 2.5
}

function ActivityDecorationUpgradeWheelComponent:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function ActivityDecorationUpgradeWheelComponent:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function ActivityDecorationUpgradeWheelComponent:OnDisable()
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

function ActivityDecorationUpgradeWheelComponent:ComponentDefine()
  self.compWheelSegment01 = self:AddComponent(ActivityDecorationGachaSegmentComponent, "WheelSegmentContent/WheelSegment01")
  self.compWheelSegment02 = self:AddComponent(ActivityDecorationGachaSegmentComponent, "WheelSegmentContent/WheelSegment02")
  self.compWheelSegment03 = self:AddComponent(ActivityDecorationGachaSegmentComponent, "WheelSegmentContent/WheelSegment03")
  self.compWheelSegment04 = self:AddComponent(ActivityDecorationGachaSegmentComponent, "WheelSegmentContent/WheelSegment04")
  self.compWheelSegment05 = self:AddComponent(ActivityDecorationGachaSegmentComponent, "WheelSegmentContent/WheelSegment05")
  self.compWheelSegment06 = self:AddComponent(ActivityDecorationGachaSegmentComponent, "WheelSegmentContent/WheelSegment06")
  self.compWheelSegment07 = self:AddComponent(ActivityDecorationGachaSegmentComponent, "WheelSegmentContent/WheelSegment07")
  self.compWheelSegment08 = self:AddComponent(ActivityDecorationGachaSegmentComponent, "WheelSegmentContent/WheelSegment08")
  self.compWheelSegment09 = self:AddComponent(ActivityDecorationGachaSegmentComponent, "WheelSegmentContent/WheelSegment09")
  self.compWheelSegment10 = self:AddComponent(ActivityDecorationGachaSegmentComponent, "WheelSegmentContent/WheelSegment10")
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
  self.compPointerImageTop = self:AddComponent(UIBaseContainer, "PointerImageTop")
  self.compPointerEffect = self:AddComponent(UIBaseContainer, "PointerImageTop/Eff_ui_s_UIDecorationGachaMain_xiaojiang")
  self.compEffUiSUIDecorationGachaMainShilianStar = self:AddComponent(UIBaseContainer, "PointerImageTop/Eff_ui_s_UIDecorationGachaMain_shilian_star")
  self.compWheelBaseImage = self:AddComponent(UIBaseContainer, "WheelBaseImage")
  self.imgWheelBaseImage = self:AddComponent(UIRawImage, "WheelBaseImage")
  self.materialBaseImage = self.imgWheelBaseImage:GetMaterial()
  self.compWheelSegmentContent = self:AddComponent(UIBaseContainer, "WheelSegmentContent")
  self.compEffUiSUIDecorationGachaMainXiyousaoguang1 = self:AddComponent(UIBaseContainer, "WheelSegmentContent/WheelSegment01/Eff_ui_s_UIDecorationGachaMain_xiyousaoguang1")
  self.compEffUiSUIDecorationGachaMainXiyousaoguang4 = self:AddComponent(UIBaseContainer, "WheelSegmentContent/WheelSegment04/Eff_ui_s_UIDecorationGachaMain_xiyousaoguang4")
  self.compEffUiSUIDecorationGachaMainXiyousaoguang8 = self:AddComponent(UIBaseContainer, "WheelSegmentContent/WheelSegment08/Eff_ui_s_UIDecorationGachaMain_xiyousaoguang8")
end

function ActivityDecorationUpgradeWheelComponent:ComponentDestroy()
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
  self.compPointerImageTop = nil
  self.compPointerEffect = nil
  self.compWheelBaseImage = nil
  self.compWheelSegmentContent = nil
  self.compEffUiSUIDecorationGachaMainShilianStar = nil
  self.compEffUiSUIDecorationGachaMainXiyousaoguang1 = nil
  self.compEffUiSUIDecorationGachaMainXiyousaoguang4 = nil
  self.compEffUiSUIDecorationGachaMainXiyousaoguang8 = nil
  self.imgWheelBaseImage = nil
  self.materialBaseImage = nil
  self.compSegments = nil
end

function ActivityDecorationUpgradeWheelComponent:DataDefine()
  self.allRandomTemplateList = {}
  self.animEndCallback = nil
  self.showSegmentHighlight = nil
end

function ActivityDecorationUpgradeWheelComponent:DataDestroy()
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

function ActivityDecorationUpgradeWheelComponent:OnAddListener()
  base.OnAddListener(self)
end

function ActivityDecorationUpgradeWheelComponent:OnRemoveListener()
  base.OnRemoveListener(self)
end

function ActivityDecorationUpgradeWheelComponent:Update()
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

function ActivityDecorationUpgradeWheelComponent:ReInit(activityId, resetPointer)
  self.activityId = activityId
  self.showSegmentHighlight = true
  if resetPointer then
    self.curPointerIndex = 1
    local lastIndex = DataCenter.ActivityDecorationGachaManager:GetLastGachaResultCache()
    self.compPointerImageTop.rectTransform.localRotation = Quaternion.Euler(0, 0, -1 * (lastIndex - 1) * self.AnimParam.SingleSegmentAngle)
    self.compWheelBaseImage.rectTransform.localRotation = Quaternion.Euler(0, 0, 0)
    self.compWheelSegmentContent.rectTransform.localRotation = Quaternion.Euler(0, 0, 0)
  end
  self.compPointerImageTop:SetActive(true)
  local activityData = DataCenter.ActivityDecorationGachaManager:GetActivityData(self.activityId)
  if activityData == nil then
    return
  end
  local allItemData = activityData:GetAllItemDataInOrder()
  for i, v in ipairs(self.compSegments) do
    v:SetActive(allItemData[i] ~= nil)
    if allItemData[i] ~= nil then
      v:ReInit(self.activityId, allItemData[i], i, resetPointer)
    end
  end
  self.compPointerEffect:SetActive(false)
  self.compEffUiSUIDecorationGachaMainShilianStar:SetActive(false)
  self:SetBlur(0)
  self:UpdateSegmentAngle()
end

function ActivityDecorationUpgradeWheelComponent:SetBlur(value)
  if self.materialBaseImage ~= nil then
    self.materialBaseImage:SetFloat("_BlurOffset", value)
  end
  if self.compSegments ~= nil then
    for i, v in pairs(self.compSegments) do
      v:SetBlur(value)
    end
  end
end

function ActivityDecorationUpgradeWheelComponent:UpdateSegmentAngle()
  if self.compSegments ~= nil then
    for i, v in pairs(self.compSegments) do
      v:UpdateAngle()
    end
  end
end

function ActivityDecorationUpgradeWheelComponent:RotatePointerFromZeroToIndex(index, completeCallback)
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
  sequenceWheel:Append(self.compWheelBaseImage.transform:DORotate(Vector3.New(0, 0, angleWheel), self.AnimParam.RotateDuration, CS.DG.Tweening.RotateMode.FastBeyond360):SetEase(CS.DG.Tweening.Ease.InOutExpo))
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

function ActivityDecorationUpgradeWheelComponent:PlayOneGachaAnim(index)
  self.showSegmentHighlight = true
  self:RotatePointerFromZeroToIndex(index, function(wheelRotateDelta)
    if DataCenter.ActivityDecorationGachaManager:IsBigReward(index) then
      if self.compSegments ~= nil and self.compSegments[index] ~= nil then
        self.compSegments[index]:PlayBigRewardAnim(false)
      end
    elseif self.compPointerEffect ~= nil then
      self.compPointerEffect:SetActive(true)
    end
    self.showSegmentHighlight = false
    if self.animEndCallback ~= nil then
      self.animEndCallback()
    end
  end)
end

function ActivityDecorationUpgradeWheelComponent:PlayTenGachaAnimHelper(endLoopCallback)
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
  self:RotatePointerFromZeroToIndex(self.tenGachaRewardListCache[self.tenGachaCurPlayIndex].pos, function()
    if table.IsNullOrEmpty(self.tenGachaRewardListCache) or self.tenGachaCurPlayIndex > #self.tenGachaRewardListCache then
      return
    end
    local delayNextTime = 0.5
    local rewardIndex = self.tenGachaRewardListCache[self.tenGachaCurPlayIndex].pos
    if self.hasShownRewardIndexList[rewardIndex] == nil then
      if self.compSegments ~= nil and self.compSegments[rewardIndex] ~= nil then
        if DataCenter.ActivityDecorationGachaManager:IsBigReward(rewardIndex) then
          self.compSegments[rewardIndex]:PlayBigRewardAnim(true)
          delayNextTime = 1
        else
          if self.compPointerEffect ~= nil then
            self.compPointerEffect:SetActive(true)
          end
          self.compSegments[rewardIndex]:SetTenGachaRootActive()
        end
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
      if self.compPointerEffect ~= nil then
        self.compPointerEffect:SetActive(false)
      end
      if self.compEffUiSUIDecorationGachaMainShilianStar ~= nil then
        self.compEffUiSUIDecorationGachaMainShilianStar:SetActive(false)
      end
      self:ClearDelayShowTenGachaTimer()
      self:PlayTenGachaAnimHelper(endLoopCallback)
    end, delayNextTime)
  end)
end

function ActivityDecorationUpgradeWheelComponent:PlayTenGachaAnim(rewardList)
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

function ActivityDecorationUpgradeWheelComponent:PlayGachaAnim(evtData, animEndCallback)
  if evtData == nil or evtData.num == nil or evtData.data == nil then
    return
  end
  if table.IsNullOrEmpty(evtData.data.rewardList) then
    return
  end
  self.animEndCallback = animEndCallback
  if evtData.num == 1 then
    local index = evtData.data.rewardList[1].pos
    self:PlayOneGachaAnim(index)
  else
    self:PlayTenGachaAnim(evtData.data.rewardList)
  end
end

function ActivityDecorationUpgradeWheelComponent:ClearDelayShowTenGachaTimer()
  if self.delayShowTenGachaTimer ~= nil then
    self.delayShowTenGachaTimer:Stop()
    self.delayShowTenGachaTimer = nil
  end
end

function ActivityDecorationUpgradeWheelComponent:ReVisibleBigRewardEffect()
  self.compEffUiSUIDecorationGachaMainXiyousaoguang1:SetActive(false)
  self.compEffUiSUIDecorationGachaMainXiyousaoguang1:SetActive(true)
  self.compEffUiSUIDecorationGachaMainXiyousaoguang4:SetActive(false)
  self.compEffUiSUIDecorationGachaMainXiyousaoguang4:SetActive(true)
  self.compEffUiSUIDecorationGachaMainXiyousaoguang8:SetActive(false)
  self.compEffUiSUIDecorationGachaMainXiyousaoguang8:SetActive(true)
end

return ActivityDecorationUpgradeWheelComponent
