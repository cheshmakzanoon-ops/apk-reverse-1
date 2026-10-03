local UIActSlotMachineSelectCardItem = BaseClass("UIActSlotMachineSelectCardItem", UIBaseContainer)
local M = UIActSlotMachineSelectCardItem
local base = UIBaseContainer
local CardQualityType = ActSlotMachineSelectCardQualityType
local CardBgPath = ActSlotMachineSelectCardBgPath
local CardAnimState = ActSlotMachineSelectCardAnimState

function M:OnCreate()
  base.OnCreate(self)
  self.curQualityType = nil
  self.cardIndex = nil
  self.animTimer = nil
  self:ComponentDefine()
  self:ResetCardState()
end

function M:OnDestroy()
  self.curQualityType = nil
  if self.animTimer then
    self.animTimer:Stop()
    self.animTimer = nil
  end
  self.cardIndex = nil
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function M:OnEnable()
  base.OnEnable(self)
end

function M:OnDisable()
  base.OnDisable(self)
  if self.orangeFlipSoundHandle then
    DataCenter.LWSoundManager:StopSound(self.orangeFlipSoundHandle)
    self.orangeFlipSoundHandle = nil
  end
  if self.purpleFlipSoundHandle then
    DataCenter.LWSoundManager:StopSound(self.purpleFlipSoundHandle)
    self.purpleFlipSoundHandle = nil
  end
  if self.blueFlipSoundHandle then
    DataCenter.LWSoundManager:StopSound(self.blueFlipSoundHandle)
    self.blueFlipSoundHandle = nil
  end
end

function M:ComponentDefine()
  self.simAnimRoot = self:AddComponent(UISimpleAnimation, "")
  self.imgRewardBg = self:AddComponent(UIImage, "anim_root/reward_root/Bg")
  self.textRewardNum = self:AddComponent(UITextMeshProUGUIEx, "anim_root/reward_root/NumText")
  self.item = self:AddComponent(UICommonResItem, "anim_root/reward_root/node_item/UICommonResItem")
  self.compMulit = self:AddComponent(UIBaseContainer, "anim_root/reward_root/mulit")
  self.btnCardFlip = self:AddComponent(UIButton, "anim_root/CardBg/Bg_kapai")
  self.btnCardFlip:SetOnClick(function()
    self:OnBtnCardFlipClick()
  end)
  self.compRewardRoot = self:AddComponent(UIBaseContainer, "anim_root/reward_root")
  self.compCardBgRoot = self:AddComponent(UIBaseContainer, "anim_root/CardBg")
  self.compBg_kapai = self:AddComponent(UIBaseContainer, "anim_root/CardBg/Bg_kapai")
  self.imgEdgeLight = self:AddComponent(UIImage, "anim_root/CardBg/EdgeLight")
  self.compEffectBack = self:AddComponent(UIBaseContainer, "anim_root/Effect_back")
  self.compOrangeFlipBlingEffect = self:AddComponent(UIBaseContainer, "anim_root/KillEffect_gold")
  self.compPurpleFlipBlingEffect = self:AddComponent(UIBaseContainer, "anim_root/KillEffect_purple")
  self.compCardBgEffect = self:AddComponent(UIBaseContainer, "anim_root/CardBg/Kapai_Effect")
  self.compBlueBrokeEffect = self:AddComponent(UIBaseContainer, "anim_root/CardBg/Eff_ui_broke")
  self.canvasGroupAnimRoot = self:AddComponent(UICanvasGroup, "anim_root")
end

function M:ComponentDestroy()
  self.simAnimRoot = nil
  self.imgRewardBg = nil
  self.textRewardNum = nil
  self.item = nil
  self.compMulit = nil
  self.btnCardFlip = nil
  self.compRewardRoot = nil
  self.compCardBgRoot = nil
  self.compBg_kapai = nil
  self.imgEdgeLight = nil
  self.compEffectBack = nil
  self.compOrangeFlipBlingEffect = nil
  self.compPurpleFlipBlingEffect = nil
  self.compCardBgEffect = nil
  self.compBlueBrokeEffect = nil
  self.canvasGroupAnimRoot = nil
end

function M:ResetCardState()
  self.simAnimRoot:Stop()
  self.compEffectBack:SetActive(false)
  self.canvasGroupAnimRoot:SetAlpha(1)
  self.imgEdgeLight:SetAlpha(0)
  self.compOrangeFlipBlingEffect:SetActive(false)
  self.compPurpleFlipBlingEffect:SetActive(false)
  self.compCardBgRoot:SetEulerAngles(Vector3.zero)
  self.compBg_kapai:SetActive(true)
  self.compRewardRoot:SetActive(true)
  self.compCardBgEffect:SetActive(false)
  self.compBlueBrokeEffect:SetActive(false)
end

function M:SetData(cardShowData)
  self.cardShowData = cardShowData
  self.boxData = cardShowData.boxData
  self.curQualityType = cardShowData.qualityType
  self.cardIndex = cardShowData.cardIndex
  local rewardData = {
    rewardType = cardShowData.rewardType,
    itemId = cardShowData.itemId,
    count = cardShowData.count
  }
  self.item:ReInit(rewardData)
  self.item:SetItemCountActive(false)
  self.item:SetImgQuailtyShow(false)
  self.textRewardNum:SetText(cardShowData.count)
  if self.curQualityType == CardQualityType.OrangeType then
    self.imgRewardBg:LoadSprite(CardBgPath.OrangeTypeBgPath)
    self.imgEdgeLight:SetColorRGBA255(255, 144, 1, 0)
  elseif self.curQualityType == CardQualityType.PurpleType then
    self.imgRewardBg:LoadSprite(CardBgPath.PurpleTypeBgPath)
    self.imgEdgeLight:SetColorRGBA255(253, 57, 255, 0)
  elseif self.curQualityType == CardQualityType.BlueType then
    self.imgRewardBg:LoadSprite(CardBgPath.BlueTypeBgPath)
    self.imgEdgeLight:SetColorRGBA255(0, 162, 255, 0)
  end
end

function M:SetCardIndex(index)
  self.cardIndex = index
end

function M:SetMultiFlagState(state)
  self.compMulit:SetActive(state)
end

function M:SetCardFlipState(flyRewardCallback)
  local flipState
  if self.curQualityType == CardQualityType.OrangeType then
    flipState = CardAnimState.OrangeCardFlip
    if self.orangeFlipSoundHandle then
      DataCenter.LWSoundManager:StopSound(self.orangeFlipSoundHandle)
      self.orangeFlipSoundHandle = nil
    end
    self.orangeFlipSoundHandle = DataCenter.LWSoundManager:PlaySound(202628, false)
  elseif self.curQualityType == CardQualityType.PurpleType then
    flipState = CardAnimState.PurpleCardFlip
    if self.purpleFlipSoundHandle then
      DataCenter.LWSoundManager:StopSound(self.purpleFlipSoundHandle)
      self.purpleFlipSoundHandle = nil
    end
    self.purpleFlipSoundHandle = DataCenter.LWSoundManager:PlaySound(202629, false)
  elseif self.curQualityType == CardQualityType.BlueType then
    flipState = CardAnimState.BlueCardFlip
    if self.blueFlipSoundHandle then
      DataCenter.LWSoundManager:StopSound(self.blueFlipSoundHandle)
      self.blueFlipSoundHandle = nil
    end
    self.blueFlipSoundHandle = DataCenter.LWSoundManager:PlaySound(202627, false)
  end
  self:SetCardAnimState(flipState)
  local isSuccess, aniTime = self.simAnimRoot:PlayAnimationReturnTime(flipState)
  if not isSuccess then
    Logger.LogError("UIActSlotMachineSelectCardItem   \230\146\173\230\148\190\229\138\168\231\148\187\229\164\177\232\180\165")
    return
  end
  
  local function flipCardCallback()
    self:AfterFlipCard()
    flyRewardCallback(self.cardShowData)
  end
  
  self.compMulit:SetActive(self.boxData.multiple ~= 1)
  if self.animTimer then
    self.animTimer:Stop()
  end
  self.animTimer = TimerManager:GetInstance():DelayInvoke(flipCardCallback, aniTime + 1)
  
  local function waitHideMulitFlag()
    if self.compMulit then
      self.compMulit:SetActive(self.boxData.multiple ~= 1)
    end
  end
  
  TimerManager:GetInstance():DelayInvoke(waitHideMulitFlag, aniTime - 0.1)
end

function M:ForceFlipCard()
  self.simAnimRoot:PlayAnimationReturnTime(CardAnimState.BlueCardFlip)
end

function M:AfterFlipCard()
  self.simAnimRoot:Play(CardAnimState.FadeOut)
  if self.animTimer then
    self.animTimer:Stop()
  end
  local remainDrawTimes = self.boxData.totalTimes - #self.boxData.indexArr
  if self.curQualityType == CardQualityType.BlueType then
    EventManager:GetInstance():Broadcast(EventId.ActSlotBlueCardBrokeApart, self.cardIndex)
  end
  if remainDrawTimes == 0 then
    EventManager:GetInstance():Broadcast(EventId.ActSlotBlueCardRemainTimesEqualZero)
  end
end

function M:SetCardAnimState(state)
  self.simAnimRoot:Stop()
  self.simAnimRoot:Play(state)
end

function M:BlueCardBrokeApart()
  self:SetCardAnimState(CardAnimState.BrokeApart)
  self.compRewardRoot:SetActive(false)
end

function M:OnBtnCardFlipClick()
  if not self.view:CheckCanOpenBox() then
    return
  end
  if self.view:IsActivityOver() then
    return
  end
  self.view:SetWaitSendTime()
  SFSNetwork.SendMessage(MsgDefines.SlotsOpenBoxNew, self.cardShowData.activityId, self.boxData.uuid, self.cardIndex, self.view.openTime)
end

return M
