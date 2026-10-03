local base = UIBaseContainer
local FormationTacticalCardSkillPart = BaseClass("FormationTacticalCardSkillPart", UIAsyncContainer)
local Localization = CS.GameEntry.Localization
local FormationTacticalCardSkillState = require("UI.UIFormation.UIFormationSelectListNew.Component.FormationTacticalCardSkillState")
local TCCoreCardItemComponent = require("UI.LWUITCCardMain.Component.CardEntity.TCCoreCardItemComponent")
local CARD_DISPLAY_CONFIG = {
  isShowLv = false,
  isShowStar = false,
  isDeluxeShow = false,
  showBg = true,
  isShowDeck = false
}

function FormationTacticalCardSkillPart:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function FormationTacticalCardSkillPart:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function FormationTacticalCardSkillPart:ComponentDefine()
  self.viewSkin = self:AddComponent(UIViewSkinBridge, "")
  self.compIdleState = self.viewSkin:AddComponent(self, FormationTacticalCardSkillState, 1)
  self.compUsingState = self.viewSkin:AddComponent(self, FormationTacticalCardSkillState, 2)
  self.compSelectState = self.viewSkin:AddComponent(self, FormationTacticalCardSkillState, 3)
  self.compCdState = self.viewSkin:AddComponent(self, FormationTacticalCardSkillState, 4)
  self.compTCCoreCardItem = self.viewSkin:AddComponent(self, TCCoreCardItemComponent, 5)
  self.imgTimeoutMask = self.viewSkin:AddComponent(self, UIImage, 6)
  self.cardBtnTrigger = self.viewSkin:AddComponent(self, UIEventTrigger, 7)
  self.compUsingVfxNode = self.viewSkin:AddComponent(self, UIVfx, 8)
  self.cardBtn = self:AddComponent(UIButton, "cardBtn")
  self.cardBtn:SetOnClick(function()
    self:OnPointerClick()
  end)
  self.cardBtnTrigger:onLongPress(function()
    self:OnLongPress()
  end)
  self.cardBtnTrigger:OnPointerUp(function()
    self:OnPointerUp()
  end)
  self.compIdleState:SetActive(false)
  self.compUsingState:SetActive(false)
  self.compSelectState:SetActive(false)
  self.compCdState:SetActive(false)
  self.curStateCpt = nil
end

function FormationTacticalCardSkillPart:ComponentDestroy()
  self.viewSkin = nil
  self.compIdleState = nil
  self.compUsingState = nil
  self.compSelectState = nil
  self.compCdState = nil
  self.compTCCoreCardItem = nil
  self.imgTimeoutMask = nil
  self.eventTriggerCardBtn = nil
  self.compUsingVfxNode = nil
end

function FormationTacticalCardSkillPart:DataDefine()
  self.cdEndTime = 0
  self.effectEndTime = 0
end

function FormationTacticalCardSkillPart:DataDestroy()
  self.cdEndTime = nil
  self.effectEndTime = nil
  self.showData = nil
  self.usePos = nil
end

function FormationTacticalCardSkillPart:OnAddListener()
  base.OnAddListener(self)
end

function FormationTacticalCardSkillPart:OnRemoveListener()
  base.OnRemoveListener(self)
end

function FormationTacticalCardSkillPart:SetDataCache(showData)
  self.showData = showData
end

function FormationTacticalCardSkillPart:UpdateData()
  if BattleFieldUtil.InBattleField() then
    return
  end
  if self.showData == nil then
    return
  end
  self:Refresh()
end

function FormationTacticalCardSkillPart:Refresh()
  if self.showData == nil then
    return
  end
  self.skillData = self.showData.skillData
  self.curState = self.showData.tempState
  if self.skillData == nil or self.curState == nil then
    Logger.LogError("skillData is nil  or  curState is nil")
    return
  end
  self.cardData = DataCenter.TacticalCardDataManager:GetCardData(self.skillData.cardUuid)
  self.deckTemplate = LocalController:instance():getLine(TableName.BATTLE_CARD_DECK, self.cardData:GetDeck())
  self.skillTemp = self.showData.skillTemp
  self.compTCCoreCardItem:SetData(self.cardData, CARD_DISPLAY_CONFIG)
  self.compTCCoreCardItem:SetClickFunc(function(cardId, cardUuid, cardLevel, cardStar, cardData)
    if not self.cardData or self.cardData.cardId ~= cardId then
      return
    end
    local newState = self.curState
    if self.curState == TCCardSkillState.Normal then
      newState = TCCardSkillState.FormationArmySelected
    elseif self.curState == TCCardSkillState.CD then
      UIUtil.ShowTipsId("battle_card_use_float_02")
    elseif self.curState == TCCardSkillState.Effect then
      UIUtil.ShowTipsId("battle_card_use_float_01")
    elseif self.curState == TCCardSkillState.FormationArmySelected then
      newState = TCCardSkillState.Normal
    end
    if newState ~= self.curState then
      self.curState = newState
      self:RefreshStateCpt()
    end
  end)
  self:RefreshStateCpt()
end

function FormationTacticalCardSkillPart:GetStateCpt()
  if self.curState == TCCardSkillState.Normal then
    return self.compIdleState
  elseif self.curState == TCCardSkillState.CD then
    return self.compCdState
  elseif self.curState == TCCardSkillState.Effect then
    return self.compUsingState
  elseif self.curState == TCCardSkillState.FormationArmySelected then
    return self.compSelectState
  end
end

function FormationTacticalCardSkillPart:RefreshStateCpt()
  local buffData
  if self.skillTemp then
    buffData = DataCenter.StatusManager:GetBuff(tonumber(self.skillTemp.effect_para1[1]))
    if buffData and buffData.endTime > UITimeManager:GetInstance():GetServerTime() then
      self.curState = TCCardSkillState.Effect
    end
  end
  if self.curStateCpt then
    self.curStateCpt:SetActive(false)
  end
  self.curStateCpt = self:GetStateCpt()
  self.curStateCpt:SetActive(true)
  self.imgTimeoutMask:SetActive(false)
  self.compUsingVfxNode:Remove()
  if self.curState == TCCardSkillState.Normal then
    if self.compTCCoreCardItem then
      self.compTCCoreCardItem:SetSelectObjState(false)
    end
    self.curStateCpt:SetDesc(Localization:GetString("battle_card_use_01", Localization:GetString(self.skillData.template.name)))
  elseif self.curState == TCCardSkillState.CD then
    self.cdEndTime = self.skillData:GetSkillCdOverTime()
    self.imgTimeoutMask:SetActive(true)
  elseif self.curState == TCCardSkillState.Effect then
    self.effectEndTime = buffData.endTime
    self.curStateCpt:SetBg(self.deckTemplate.deck_banner)
    self.compUsingVfxNode:PlayByStay(self.deckTemplate.deck_fx)
  elseif self.curState == TCCardSkillState.FormationArmySelected then
    self.curStateCpt:SetBgColorHex(self.deckTemplate.deck_color)
    self.curStateCpt:SetDesc(Localization:GetString("battle_card_use_02", Localization:GetString(self.skillData.template.name)))
    if self.compTCCoreCardItem then
      self.compTCCoreCardItem:SetSelectObjState(true)
    end
  end
  self:Update1000MS()
end

function FormationTacticalCardSkillPart:RefreshLearnStateView()
end

function FormationTacticalCardSkillPart:GetUseCardSkill()
  if self.curState == TCCardSkillState.FormationArmySelected then
    return self.skillData.cardUuid, self.skillData:GetSkillGroupId()
  end
end

function FormationTacticalCardSkillPart:Update1000MS()
  if self.showData == nil then
    return
  end
  if self.curState == TCCardSkillState.CD or self.curState == TCCardSkillState.Effect then
    local curTime = UITimeManager:GetInstance():GetServerTime()
    local newState = self.curState
    if curTime < self.effectEndTime then
      newState = TCCardSkillState.Effect
      local leftTime = self.effectEndTime - curTime
      if leftTime < 0 then
        leftTime = 0
      end
      local countDownTimeStr = UITimeManager:GetInstance():SecondToFmtStringWithoutHour(leftTime * 0.001)
      self.curStateCpt:SetDesc(Localization:GetString("battle_card_use_03", Localization:GetString(self.skillData.template.name), countDownTimeStr))
    elseif curTime < self.cdEndTime and curTime >= self.effectEndTime then
      newState = TCCardSkillState.CD
      local leftTime = self.cdEndTime - curTime
      if leftTime < 0 then
        leftTime = 0
      end
      local countDownTimeStr = UITimeManager:GetInstance():MilliSecondToFmtString(leftTime)
      local cdTime = self.skillData:GetSkillCdTime()
      local percent = math.min(1, leftTime / cdTime)
      self.imgTimeoutMask:SetFillAmount(percent)
      self.curStateCpt:SetDesc(Localization:GetString("battle_card_use_04", Localization:GetString(self.skillData.template.name), countDownTimeStr))
    elseif self.skillData and 0 >= self.skillData:GetSkillResidueCount() then
      newState = TCCardSkillState.CD
    else
      newState = TCCardSkillState.Normal
    end
    if newState ~= self.curState then
      self.curState = newState
      self:RefreshStateCpt()
    end
  end
end

function FormationTacticalCardSkillPart:OnLongPress()
  self.isPointerDown = true
  local param = {}
  param.alignObject = self.transform
  param.width = 515
  param.skillData = self.skillData
  param.showArrow = true
  param.showLockImage = self.showLockImage
  param.addPosY = 80
  UIManager:GetInstance():OpenWindow(UIWindowNames.UITCCardSkillTip, {anim = true}, param)
end

function FormationTacticalCardSkillPart:OnPointerUp()
  self.isPointerDown = false
end

function FormationTacticalCardSkillPart:OnPointerClick()
  if not self.cardData then
    return
  end
  if self.isPointerDown then
    return
  end
  local newState = self.curState
  if self.curState == TCCardSkillState.Normal then
    newState = TCCardSkillState.FormationArmySelected
  elseif self.curState == TCCardSkillState.CD then
    UIUtil.ShowTipsId("battle_card_use_float_02")
  elseif self.curState == TCCardSkillState.Effect then
    UIUtil.ShowTipsId("battle_card_use_float_01")
  elseif self.curState == TCCardSkillState.FormationArmySelected then
    newState = TCCardSkillState.Normal
  end
  if newState ~= self.curState then
    self.curState = newState
    self:RefreshStateCpt()
  end
end

return FormationTacticalCardSkillPart
