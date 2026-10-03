local UILWTorchRelayBattleMainView = BaseClass("UILWTorchRelayBattleMainView", UIBaseView)
local UILWTorchRelayBattleMainDebugItemComponent = require("UI/LWTorchRelay/Battle/Main/Component/UILWTorchRelayBattleMainDebugItemComponent")
local TorchRelayBattleBuffIconItem = require("UI/LWTorchRelay/Battle/Main/Component/TorchRelayBattleBuffIconItem")
local TorchConstant = require("DataCenter/LWBattle/Logic/TorchRelayBattle/TorchRelayBattleConstant")
local UICommonResItem = require("UI.UICommonResItem.UICommonResItemV2.UICommonResItem")
local TorchRelayBattleStageCheerConfigTemplate = require("DataCenter/LWBattle/Logic/TorchRelayBattle/Config/TorchRelayBattleStageCheerConfigTemplate")
local base = UIBaseView
local Localization = CS.GameEntry.Localization
local buff_state_root_path = "Root/buffStateRoot"
local power_progress_path = "Root/speedPowerRoot/powerProgress"
local speed_power_max_effect_root_path = "Root/speedPowerRoot/speedPowerMaxEffectRoot"

function UILWTorchRelayBattleMainView:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
  self:OnOpen()
end

function UILWTorchRelayBattleMainView:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UILWTorchRelayBattleMainView:ComponentDefine()
  self.compTopContent = self:AddComponent(UIBaseContainer, "Root/TopContent")
  self.sliderStamina = self:AddComponent(UISlider, "Root/TopContent/StaminaSlider")
  self.textStamina = self:AddComponent(UIText, "Root/TopContent/StaminaText")
  self.textScoreTitle = self:AddComponent(UIText, "Root/TopContent/ScoreTitleText")
  self.textScoreTitle:SetText(Localization:GetString("activity_torch_relay_desc_24"))
  self.textScore = self:AddComponent(UIText, "Root/TopContent/ScoreText")
  self.compRewardBoxContent = self:AddComponent(UIBaseContainer, "Root/RewardBoxContent")
  self.imgRewardBoxProgress = self:AddComponent(UIImage, "Root/RewardBoxContent/RewardBoxProgress")
  self.imgRewardBoxClaimedIcon = self:AddComponent(UIImage, "Root/RewardBoxContent/RewardBoxClaimedIcon")
  self.textRewardBoxTitle = self:AddComponent(UIText, "Root/RewardBoxContent/RewardBoxTitle")
  self.textRewardBoxTitle:SetText(Localization:GetString(390175))
  self.textRewardBoxValue = self:AddComponent(UIText, "Root/RewardBoxContent/RewardBoxValue")
  self.compCheerContent = self:AddComponent(UIBaseContainer, "Root/CheerContent")
  self.compNormalCheerItem = self:AddComponent(UIBaseContainer, "Root/CheerContent/NormalCheerItem")
  self.compNormalCheerUIPlayerHead = self:AddComponent(UICommonHead, "Root/CheerContent/NormalCheerItem/NormalCheerUIPlayerHead")
  self.textNormalCheerName = self:AddComponent(UIText, "Root/CheerContent/NormalCheerItem/NormalCheerName")
  self.textNormalCheerTitle = self:AddComponent(UIText, "Root/CheerContent/NormalCheerItem/NormalCheerTitle")
  self.textNormalCheerTitle:SetText(Localization:GetString("activity_torch_relay_desc_29"))
  self.compAdvanceCheerItem = self:AddComponent(UIBaseContainer, "Root/CheerContent/AdvanceCheerItem")
  self.textAdvanceCheerTitle = self:AddComponent(UIText, "Root/CheerContent/AdvanceCheerItem/AdvanceCheerTitle")
  self.textAdvanceCheerTitle:SetText(Localization:GetString("activity_torch_relay_desc_28"))
  self.textAdvanceCheerName = self:AddComponent(UIText, "Root/CheerContent/AdvanceCheerItem/AdvanceCheerName")
  self.compAdvanceCheerUIPlayerHead = self:AddComponent(UICommonHead, "Root/CheerContent/AdvanceCheerItem/AdvanceCheerUIPlayerHead")
  self.compEnterContent = self:AddComponent(UIBaseContainer, "EnterContent")
  self.enterAni = self.compEnterContent.gameObject:GetComponent(typeof(CS.SimpleAnimation))
  self.textEnterTitle = self:AddComponent(UIText, "EnterContent/EnterTitle")
  self.textEnterTitle:SetText(Localization:GetString("activity_torch_relay_title_6"))
  self.compCheer = self:AddComponent(UIBaseContainer, "EnterContent/Cheer")
  self.textCheerTitle = self:AddComponent(UIText, "EnterContent/Cheer/CheerTitle")
  self.textCheerTitle:SetText(Localization:GetString("activity_torch_relay_desc_23"))
  self.compLayout = self:AddComponent(UIBaseContainer, "EnterContent/Cheer/Layout")
  self.compCheerItem01 = self:AddComponent(UIBaseContainer, "EnterContent/Cheer/Layout/CheerItem01")
  self.compUIPlayerHead01 = self:AddComponent(UICommonHead, "EnterContent/Cheer/Layout/CheerItem01/UIPlayerHead01")
  self.textServerText01 = self:AddComponent(UIText, "EnterContent/Cheer/Layout/CheerItem01/ServerText01")
  self.textNameText01 = self:AddComponent(UIText, "EnterContent/Cheer/Layout/CheerItem01/NameText01")
  self.compCheerItem02 = self:AddComponent(UIBaseContainer, "EnterContent/Cheer/Layout/CheerItem02")
  self.compUIPlayerHead02 = self:AddComponent(UICommonHead, "EnterContent/Cheer/Layout/CheerItem02/UIPlayerHead02")
  self.textServerText02 = self:AddComponent(UIText, "EnterContent/Cheer/Layout/CheerItem02/ServerText02")
  self.textNameText02 = self:AddComponent(UIText, "EnterContent/Cheer/Layout/CheerItem02/NameText02")
  self.compCheerEmpty = self:AddComponent(UIBaseContainer, "EnterContent/CheerEmpty")
  self.textCheerTitleEmpty = self:AddComponent(UIText, "EnterContent/CheerEmpty/CheerTitleEmpty")
  self.textCheerTitleEmpty:SetText(Localization:GetString("activity_torch_relay_desc_41"))
  self.btnEnter = self:AddComponent(UIButton, "EnterContent/EnterBtn")
  self.btnEnter:SetOnClick(function()
    self:OnBtnEnterClick()
  end)
  self.textEnter = self:AddComponent(UIText, "EnterContent/EnterBtn/Btn/EnterText")
  self.textEnter:SetText(Localization:GetString("activity_torch_relay_button_6"))
  self.compReadyBg = self:AddComponent(UIBaseContainer, "EnterContent/readyBg")
  self.textReadyTxt = self:AddComponent(UIText, "EnterContent/readyTxt")
  self.btnBack = self:AddComponent(UIButton, "BackBtn")
  self.btnBack:SetOnClick(function()
    self:OnBtnBackClick()
  end)
  self.btnBack:SetActive(false)
  self.buff_state_root = self:AddComponent(UIBaseContainer, buff_state_root_path)
  self.buffItemReqDic = {}
  self.buffItemDic = {}
  self.power_progress_root = self:AddComponent(UIBaseContainer, "Root/speedPowerRoot")
  self.power_progress = self:AddComponent(UIImage, power_progress_path)
  self.power_progress:SetFillAmount(0)
  self.speedPowerAddRecord = {}
  self.isPlayerSpeedPowerAni = false
  self.speed_power_max_effect_root = self:AddComponent(UIBaseContainer, speed_power_max_effect_root_path)
  self.textSpeedPower = self:AddComponent(UIText, "Root/speedPowerRoot/speedPowerText")
  self.compEffectRed = self:AddComponent(UIBaseContainer, "Root/EffectRed")
  self.compWinContent = self:AddComponent(UIBaseContainer, "Root/WinContent")
  self.textWinBanner = self:AddComponent(UIText, "Root/WinContent/WinBannerText")
  self.textWinBanner:SetText(Localization:GetString("activity_torch_relay_desc_54"))
  self.invincibleSpecialBarNode = self:AddComponent(UIBaseContainer, "Root/CheerContent/InvincibleItem")
  self.invincibleSpecialBarNode:SetActive(false)
  self.sliderInvincibleResidueTime = self:AddComponent(UISlider, "Root/CheerContent/InvincibleItem/InvincibleResidueTime")
  self.textInvincibleItemTitle = self:AddComponent(UIText, "Root/CheerContent/InvincibleItem/InvincibleItemTitle")
  self.textInvincibleItemTitle:SetLocalText("helloween_run_desc1")
end

function UILWTorchRelayBattleMainView:ComponentDestroy()
  self.speedPowerMaxParticleCpts = nil
  if self.speedPowerMaxAniReq then
    self.speedPowerMaxAniReq:Destroy()
    self.speedPowerMaxAniReq = nil1
  end
  self.power_progress = nil
  self.speedPowerAddRecord = nil
  for i, v in pairs(self.buffItemReqDic) do
    if v then
      v:Destroy()
    end
  end
  self.buff_state_root:RemoveComponents(TorchRelayBattleBuffIconItem)
  self.buff_state_root = nil
  self.buffItemReqDic = nil
  self.buffItemDic = nil
  self.compTopContent = nil
  self.sliderStamina = nil
  self.textStamina = nil
  self.textScore = nil
  self.compRewardBoxContent = nil
  self.imgRewardBoxProgress = nil
  self.imgRewardBoxClaimedIcon = nil
  self.textRewardBoxTitle = nil
  self.textRewardBoxValue = nil
  self.compCheerContent = nil
  self.compNormalCheerItem = nil
  self.compNormalCheerUIPlayerHead = nil
  self.textNormalCheerName = nil
  self.textNormalCheerTitle = nil
  self.compAdvanceCheerItem = nil
  self.textAdvanceCheerTitle = nil
  self.textAdvanceCheerName = nil
  self.compAdvanceCheerUIPlayerHead = nil
  self.compCheerEmpty = nil
  self.textCheerTitleEmpty = nil
  self.compEnterContent = nil
  self.textEnterTitle = nil
  self.compCheer = nil
  self.textCheerTitle = nil
  self.compLayout = nil
  self.compCheerItem01 = nil
  self.compUIPlayerHead01 = nil
  self.textServerText01 = nil
  self.textNameText01 = nil
  self.compCheerItem02 = nil
  self.compUIPlayerHead02 = nil
  self.textServerText02 = nil
  self.textNameText02 = nil
  self.btnEnter = nil
  self.textEnter = nil
  self.compReadyBg = nil
  self.textReadyTxt = nil
  self.btnBack = nil
  self.compDebugItemTemplate = nil
  self.compDebugItemContent = nil
  self.speed_power_max_effect_root = nil
  self.power_progress_root = nil
  self.compEffectRed = nil
  self.textSpeedPower = nil
  self.compWinContent = nil
  self.textWinBanner = nil
  self.sliderInvincibleResidueTime = nil
  self.textInvincibleItemTitle = nil
  self.invincibleSpecialBarNode = nil
  self.enterAni = nil
end

function UILWTorchRelayBattleMainView:DataDefine()
  self.scorePrefix = nil
  if self.delayHideNormalCheerTimer then
    self.delayHideNormalCheerTimer:Stop()
    self.delayHideNormalCheerTimer = nil
  end
  if self.delayHideAdvanceCheerTimer then
    self.delayHideAdvanceCheerTimer:Stop()
    self.delayHideAdvanceCheerTimer = nil
  end
  if self.delayHideMilestoneTimer then
    self.delayHideMilestoneTimer:Stop()
    self.delayHideMilestoneTimer = nil
  end
  if self.enterCountdownTimer then
    self.enterCountdownTimer:Stop()
    self.enterCountdownTimer = nil
  end
  if self.delayHideSpeedTextTimer then
    self.delayHideSpeedTextTimer:Stop()
    self.delayHideSpeedTextTimer = nil
  end
end

function UILWTorchRelayBattleMainView:DataDestroy()
  self.scorePrefix = nil
  if self.delayHideNormalCheerTimer then
    self.delayHideNormalCheerTimer:Stop()
    self.delayHideNormalCheerTimer = nil
  end
  if self.delayHideAdvanceCheerTimer then
    self.delayHideAdvanceCheerTimer:Stop()
    self.delayHideAdvanceCheerTimer = nil
  end
  if self.delayHideMilestoneTimer then
    self.delayHideMilestoneTimer:Stop()
    self.delayHideMilestoneTimer = nil
  end
  if self.enterCountdownTimer then
    self.enterCountdownTimer:Stop()
    self.enterCountdownTimer = nil
  end
  if self.delayHideSpeedTextTimer then
    self.delayHideSpeedTextTimer:Stop()
    self.delayHideSpeedTextTimer = nil
  end
end

function UILWTorchRelayBattleMainView:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.GF_guide_done, self.OnGuideDone)
end

function UILWTorchRelayBattleMainView:OnRemoveListener()
  self:RemoveUIListener(EventId.GF_guide_done, self.OnGuideDone)
  base.OnRemoveListener(self)
end

function UILWTorchRelayBattleMainView:OnOpen()
  self.param = self:GetUserData()
  self.compEnterContent:SetActive(false)
  self.compTopContent:SetActive(false)
  self.compCheerContent:SetActive(false)
  self.power_progress_root:SetActive(false)
  self.compRewardBoxContent:SetActive(false)
  self.compEffectRed:SetActive(false)
  self.compWinContent:SetActive(false)
  local hasCheer = not table.IsNullOrEmpty(self.param.cheerData)
  self.compCheer:SetActive(hasCheer)
  self.compCheerEmpty:SetActive(not hasCheer)
  if hasCheer then
    self.compCheerItem01:SetActive(self.param.cheerData[1] ~= nil)
    self.compCheerItem02:SetActive(self.param.cheerData[2] ~= nil)
    if self.param.cheerData[1] ~= nil then
      self.compUIPlayerHead01:SetData(self.param.cheerData[1].uid, self.param.cheerData[1].pic, self.param.cheerData[1].picver)
      self.textServerText01:SetText(UIUtil.FormatServerAllianceName(self.param.cheerData[1].serverId, self.param.cheerData[1].abbr, ""))
      self.textNameText01:SetText(self.param.cheerData[1].name)
    end
    if self.param.cheerData[2] ~= nil then
      self.compUIPlayerHead02:SetData(self.param.cheerData[2].uid, self.param.cheerData[2].pic, self.param.cheerData[2].picver)
      self.textServerText02:SetText(UIUtil.FormatServerAllianceName(self.param.cheerData[2].serverId, self.param.cheerData[2].abbr, ""))
      self.textNameText02:SetText(self.param.cheerData[2].name)
    end
  end
  if not DataCenter.LWGuideFlowManager.Runner:IsRun() and not DataCenter.LWGuideFlowManager:ReadDone(TorchConstant.START_GUIDE_ID) then
    DataCenter.LWGuideFlowManager.Runner:Run(TorchConstant.START_GUIDE_ID)
  else
    self:StartEnterCountdown()
  end
end

function UILWTorchRelayBattleMainView:StartEnterCountdown()
  self.enterAni:Play()
  self.compEnterContent:SetActive(true)
  self.enterCountdown = TorchConstant.ENTER_COUNT_DOWN
  self.textReadyTxt:SetText(tostring(self.enterCountdown))
  if self.enterCountdownTimer then
    self.enterCountdownTimer:Stop()
    self.enterCountdownTimer = nil
  end
  
  function self.enterCountdownAction(temp)
    self:UpdateEnterCountdown()
  end
  
  self.enterCountdownTimer = TimerManager:GetInstance():GetTimer(1, self.enterCountdownAction, self, false, false, false)
  self.enterCountdownTimer:Start()
end

function UILWTorchRelayBattleMainView:UpdateEnterCountdown()
  if self.enterCountdown <= 0 then
    if self.enterCountdownTimer then
      self.enterCountdownTimer:Stop()
      self.enterCountdownTimer = nil
    end
    self:OnEnterGame()
  end
  if self.textReadyTxt then
    self.textReadyTxt:SetText(tostring(self.enterCountdown))
  end
  self.enterCountdown = self.enterCountdown - 1
end

function UILWTorchRelayBattleMainView:SetStaminaSliderValue(value, totalValue)
  if totalValue <= 0 then
    return
  end
  if self.sliderStamina then
    self.sliderStamina:SetValue(value / totalValue)
  end
  local str = math.floor(math.max(0, value)) .. "/" .. totalValue
  if self.curTextStamina ~= str and self.textStamina then
    self.textStamina:SetText(str)
    self.curTextStamina = str
  end
end

function UILWTorchRelayBattleMainView:SetScoreText(value)
  if self.textScore then
    self.textScore:SetText(tostring(value) .. "m")
  end
end

function UILWTorchRelayBattleMainView:SetSpeedPower(value, totalValue, addSpeedShowValue)
  table.insert(self.speedPowerAddRecord, value)
  if self.isPlayerSpeedPowerAni == false and #self.speedPowerAddRecord == 1 then
    self:PlaySpeedPowerChangeAni(totalValue, addSpeedShowValue)
  end
end

function UILWTorchRelayBattleMainView:PlaySpeedPowerChangeAni(totalValue, addSpeedShowValue)
  local targetValue = self.speedPowerAddRecord[1]
  if targetValue == nil then
    return
  end
  local tarFillAmount
  if targetValue == totalValue then
    tarFillAmount = 1
  elseif targetValue == 0 then
    tarFillAmount = 0
  else
    tarFillAmount = targetValue / totalValue
  end
  local duration = TorchConstant.UI_SPEED_POWER_ADD_ANI_TIME
  if targetValue == 0 then
    duration = TorchConstant.UI_SPEED_POWER_TO_ZERO_ANI_TIME
  end
  table.remove(self.speedPowerAddRecord, 1)
  self.isPlayerSpeedPowerAni = true
  self.power_progress.unity_image:DOFillAmount(tarFillAmount, duration):SetEase(CS.DG.Tweening.Ease.InOutQuad):OnComplete(function()
    self.isPlayerSpeedPowerAni = false
    self:PlaySpeedPowerChangeAni(totalValue)
  end)
  if tarFillAmount == 1 then
    self:PlaySpeedPowerMaxAni()
  end
  if addSpeedShowValue and 0 < addSpeedShowValue then
    self.textSpeedPower:SetActive(true)
    self.textSpeedPower:SetText("+" .. tostring(addSpeedShowValue))
    if self.delayHideSpeedTextTimer then
      self.delayHideSpeedTextTimer:Stop()
    end
    self.delayHideSpeedTextTimer = TimerManager:GetInstance():DelayInvoke(function()
      if self.textSpeedPower then
        self.textSpeedPower:SetActive(false)
      end
    end, 1)
  end
end

function UILWTorchRelayBattleMainView:PlaySpeedPowerMaxAni()
  if not self.speedPowerMaxAniReq then
    self.speedPowerMaxAniReq = CS.GameEntry.Resource:InstantiateAsync(EffectAssets.TorchRelaySpeedPowerMaxEffect)
    self.speedPowerMaxAniReq:completed("+", function()
      local buffEffectObj = self.speedPowerMaxAniReq.gameObject
      buffEffectObj.transform:SetParent(self.speed_power_max_effect_root.transform)
      buffEffectObj.transform:Set_localPosition(0, 0, 0)
      buffEffectObj:SetActive(true)
    end)
  elseif self.speedPowerMaxAniReq.isDone then
    if not self.speedPowerMaxParticleCpts then
      self.speedPowerMaxParticleCpts = self.speedPowerMaxAniReq.gameObject.transform:GetComponentsInChildren(typeof(CS.UnityEngine.ParticleSystem))
    end
    if not IsNull(self.speedPowerMaxParticleCpts) then
      for i = 0, self.speedPowerMaxParticleCpts.Length - 1 do
        self.speedPowerMaxParticleCpts[i]:Play()
      end
    end
  end
end

function UILWTorchRelayBattleMainView:OnEnterGame()
  if self.param ~= nil and self.param.enterCallback ~= nil then
    self.param.enterCallback()
  end
  self.compEnterContent:SetActive(false)
  self.compTopContent:SetActive(true)
  self.compRewardBoxContent:SetActive(true)
  self.imgRewardBoxClaimedIcon:SetActive(false)
  self.compCheerContent:SetActive(true)
  self.compNormalCheerItem:SetActive(false)
  self.compAdvanceCheerItem:SetActive(false)
  self.power_progress_root:SetActive(true)
  self.textSpeedPower:SetActive(false)
  self.buff_state_root:SetActive(true)
end

function UILWTorchRelayBattleMainView:OnBtnEnterClick()
end

function UILWTorchRelayBattleMainView:OnBtnBackClick()
  Logger.LogInfo(string.format("Torch Relay Battle Log Info: %s", "back click"))
  self.ctrl:CloseSelf()
  DataCenter.LWBattleManager:Exit(nil, "quit")
end

function UILWTorchRelayBattleMainView:ShowBuff(buffData)
  local buffState = buffData.state
  local buffItemReq = self.buffItemReqDic[buffState]
  if not buffItemReq then
    self:CreateBuffIconItem(buffState, buffData)
  elseif buffItemReq.isDone == true and self.buffItemDic[buffState] then
    self.buffItemDic[buffState]:SetData(buffData)
    self.buffItemDic[buffState]:SetActive(true)
  end
end

function UILWTorchRelayBattleMainView:CreateBuffIconItem(state, buffData)
  self.buffItemReqDic[state] = CS.GameEntry.Resource:InstantiateAsync(UIAssets.UITorchRelayBattleBuffIconItem)
  self.buffItemReqDic[state]:completed("+", function()
    local go = self.buffItemReqDic[state].gameObject
    go:SetActive(true)
    go.transform:SetParent(self.buff_state_root.transform)
    go.transform:Set_localPosition(ResetPosition.x, ResetPosition.y, ResetPosition.z)
    go.transform:Set_localScale(ResetScale.x, ResetScale.y, ResetScale.z)
    go.name = tostring(state)
    local item = self.buff_state_root:AddComponent(TorchRelayBattleBuffIconItem, go.name)
    item:SetData(buffData)
    self.buffItemDic[state] = item
  end)
end

function UILWTorchRelayBattleMainView:UpdateBuffResidueTime(state, residueTime, duration)
  local buffItem = self.buffItemDic[state]
  if buffItem then
    buffItem:UpdateResidueTime(residueTime, duration)
  end
  if state == TorchRelayBuffState.Invincible then
    local curSliderValue = residueTime / duration
    self.sliderInvincibleResidueTime:SetValue(curSliderValue)
  end
end

function UILWTorchRelayBattleMainView:HideBuff(buffState)
  local buffItemReq = self.buffItemReqDic[buffState]
  if buffItemReq == nil then
    return
  end
  if buffItemReq.isDone == false then
    buffItemReq:Destroy()
    self.buffItemReqDic[buffState] = nil
    self.buffItemDic[buffState] = nil
  elseif self.buffItemDic[buffState] then
    self.buffItemDic[buffState]:SetActive(false)
  end
  if buffState == TorchRelayBuffState.Invincible then
    self:HideInvincibleSpecialBar()
  end
end

function UILWTorchRelayBattleMainView:OnCheerTriggered(cheerData)
  if cheerData and cheerData.cheerId then
    local line = LocalController:instance():getLine(TableName.Activity_Torch_Relay_Stage_Cheer, tonumber(cheerData.cheerId))
    if line then
      local template = TorchRelayBattleStageCheerConfigTemplate.New()
      template:InitData(line)
      if template.cheer_rare == 0 then
        self.textNormalCheerName:SetText(cheerData.name)
        self.compNormalCheerItem:SetActive(true)
        if self.delayHideNormalCheerTimer then
          self.delayHideNormalCheerTimer:Stop()
        end
        self.delayHideNormalCheerTimer = TimerManager:GetInstance():DelayInvoke(function()
          if self.compNormalCheerItem then
            self.compNormalCheerItem:SetActive(false)
          end
        end, 4)
      else
        self.textAdvanceCheerName:SetText(cheerData.name)
        self.compAdvanceCheerItem:SetActive(true)
        if self.delayHideAdvanceCheerTimer then
          self.delayHideAdvanceCheerTimer:Stop()
        end
        self.delayHideAdvanceCheerTimer = TimerManager:GetInstance():DelayInvoke(function()
          if self.compAdvanceCheerItem then
            self.compAdvanceCheerItem:SetActive(false)
          end
        end, 4)
      end
    end
  end
end

function UILWTorchRelayBattleMainView:UpdateRewardBoxProgress(value)
  if self.imgRewardBoxProgress then
    self.imgRewardBoxProgress:SetFillAmount(value)
  end
end

function UILWTorchRelayBattleMainView:ShowRewardBoxClaimed()
  if self.imgRewardBoxClaimedIcon then
    self.imgRewardBoxClaimedIcon:SetActive(true)
    if self.delayHideMilestoneTimer then
      self.delayHideMilestoneTimer:Stop()
    end
    self.delayHideMilestoneTimer = TimerManager:GetInstance():DelayInvoke(function()
      if self.imgRewardBoxClaimedIcon then
        self.imgRewardBoxClaimedIcon:SetActive(false)
      end
    end, 2)
  end
end

function UILWTorchRelayBattleMainView:UpdateRewardBoxNextValue(score)
  if self.textRewardBoxValue then
    self.textRewardBoxValue:SetText(tostring(score) .. "m")
  end
end

function UILWTorchRelayBattleMainView:UpdateRewardBoxMaxed()
  if self.imgRewardBoxProgress then
    self.imgRewardBoxProgress:SetFillAmount(1)
  end
  if self.imgRewardBoxClaimedIcon then
    self.imgRewardBoxClaimedIcon:SetActive(true)
  end
end

function UILWTorchRelayBattleMainView:UpdateRedEffect(isOn)
  if self.compEffectRed then
    self.compEffectRed:SetActive(isOn)
    if isOn and self.rectTransform then
      local rectSize = self.rectTransform.rect
      local scaleWidth = rectSize.width / DefaultScreenWidth
      local scaleHeight = rectSize.height / DefaultScreenHeight
      self.compEffectRed:SetLocalScaleXYZ(scaleWidth, scaleHeight, 1)
      self.compEffectRed:SetLocalScaleXYZ(scaleWidth, scaleHeight, 1)
    end
  end
end

function UILWTorchRelayBattleMainView:OnGuideDone(guideId)
  if guideId == TorchConstant.START_GUIDE_ID then
    self:StartEnterCountdown()
  end
end

function UILWTorchRelayBattleMainView:OnWinGame()
  self.buff_state_root:SetActive(false)
  self.power_progress_root:SetActive(false)
  self.compRewardBoxContent:SetActive(false)
  self.compTopContent:SetActive(false)
  self.compWinContent:SetActive(true)
end

function UILWTorchRelayBattleMainView:OnShowFinalResult()
  self.compWinContent:SetActive(false)
end

function UILWTorchRelayBattleMainView:ShowInvincibleSpecialBar()
  self.invincibleSpecialBarNode:SetActive(true)
end

function UILWTorchRelayBattleMainView:HideInvincibleSpecialBar()
  self.invincibleSpecialBarNode:SetActive(false)
end

return UILWTorchRelayBattleMainView
