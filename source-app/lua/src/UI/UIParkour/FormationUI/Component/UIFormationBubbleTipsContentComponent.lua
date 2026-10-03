local base = UIBaseContainer
local UIFormationBubbleTipsContentComponent = BaseClass("UIFormationBubbleTipsContentComponent", UIBaseContainer)
local Localization = CS.GameEntry.Localization

function UIFormationBubbleTipsContentComponent:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function UIFormationBubbleTipsContentComponent:OnDestroy()
  self:ClearDelayTimer()
  self:ClearTween()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UIFormationBubbleTipsContentComponent:ComponentDefine()
  self.viewSkin = self:AddComponent(UIViewSkinBridge, "")
  self.compRoot = self.viewSkin:AddComponent(self, UIBaseContainer, 1)
  self.textBubbleTips = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 2)
end

function UIFormationBubbleTipsContentComponent:ComponentDestroy()
  self.viewSkin = nil
  self.compRoot = nil
  self.textBubbleTips = nil
end

function UIFormationBubbleTipsContentComponent:DataDefine()
  self.isLogicActive = false
  self.squadData = nil
  self.showTipsLanguageKey = ""
  self.isFirstShow = true
end

function UIFormationBubbleTipsContentComponent:DataDestroy()
  self.isLogicActive = nil
  self.squadData = nil
  self.showTipsLanguageKey = nil
  self.isFirstShow = nil
end

function UIFormationBubbleTipsContentComponent:OnAddListener()
  base.OnAddListener(self)
end

function UIFormationBubbleTipsContentComponent:OnRemoveListener()
  base.OnRemoveListener(self)
end

function UIFormationBubbleTipsContentComponent:CheckIsShowBubbleTips(squadData)
  self.squadData = squadData
  local temporaryIsFirstShow = self.isFirstShow
  self.isFirstShow = false
  if self.squadData == nil then
    self:SetActive(false)
    return
  end
  if self:GetActive() then
    return
  end
  local heroCount = self.squadData:GetLocalHeroesCount()
  local allHeroList = DataCenter.HeroDataManager:GetAllHeroList()
  local totalHeroCount = table.count(allHeroList)
  local isNeedShow = false
  if heroCount < 5 and heroCount < totalHeroCount then
    for uuid, heroData in pairs(allHeroList) do
      local hasHero = self.squadData:HasLocalHero(uuid)
      if not hasHero then
        isNeedShow = true
        self.showTipsLanguageKey = "quick_placement_opti_plot_1"
        break
      end
    end
  end
  if not isNeedShow then
    local localHeroes = self.squadData.localHeroes
    local frontReasonable, backReasonable = true, true
    for heroUuid, slotIndex in pairs(localHeroes) do
      if slotIndex == 1 or slotIndex == 2 then
        local heroData = DataCenter.HeroDataManager:GetHeroByUuid(heroUuid)
        if heroData and heroData.meta and heroData.meta.job ~= 1 then
          frontReasonable = false
        end
      else
        local heroData = DataCenter.HeroDataManager:GetHeroByUuid(heroUuid)
        if heroData and heroData.meta and heroData.meta.job == 1 then
          backReasonable = false
        end
      end
    end
    if not frontReasonable and not backReasonable then
      isNeedShow = true
      self.showTipsLanguageKey = "quick_placement_opti_plot_2"
    end
  end
  self:SetBubbleActive(isNeedShow, temporaryIsFirstShow)
  if isNeedShow then
    self.textBubbleTips:SetLocalText(self.showTipsLanguageKey)
  end
end

function UIFormationBubbleTipsContentComponent:SetBubbleActive(active, isFirstShow)
  if self.isLogicActive ~= active then
    self.isLogicActive = active
    if active then
      self:PlayShowTween(isFirstShow)
      self:PlayDelayTimer()
    else
      self:PlayHideTween()
    end
  end
end

function UIFormationBubbleTipsContentComponent:PlayShowTween(isFirstShow)
  self:ClearTween()
  self.sequence = CS.DG.Tweening.DOTween.Sequence()
  if self.compRoot then
    if isFirstShow then
      self:SetActive(false)
      self.sequence:AppendInterval(1)
      self.sequence:AppendCallback(function()
        if self.isLogicActive then
          self:SetActive(true)
          self.compRoot.transform.localRotation = Quaternion.identity
          self.compRoot.transform.localScale = Vector3.New(0.92, 0.92, 1)
        end
      end)
    else
      self:SetActive(true)
      self.compRoot.transform.localRotation = Quaternion.identity
      self.compRoot.transform.localScale = Vector3.New(0.92, 0.92, 1)
    end
    self.sequence:Append(self.compRoot.transform:DOScale(Vector3.New(1.08, 1.08, 1), 0.1):SetLoops(2, CS.DG.Tweening.LoopType.Yoyo))
  end
end

function UIFormationBubbleTipsContentComponent:PlayHideTween()
  self:ClearTween()
  self.sequence = CS.DG.Tweening.DOTween.Sequence()
  if self.compRoot then
    self.compRoot.transform.localRotation = Quaternion.identity
    self.sequence:Append(self.compRoot.transform:DOLocalRotate(Vector3(0, 0, 2), 0.05):SetLoops(2, CS.DG.Tweening.LoopType.Yoyo))
    self.sequence:Append(self.compRoot.transform:DOLocalRotate(Vector3(0, 0, -2), 0.05):SetLoops(2, CS.DG.Tweening.LoopType.Yoyo))
    self.sequence:AppendCallback(function()
      self:SetActive(false)
    end)
  end
end

function UIFormationBubbleTipsContentComponent:ClearTween()
  if self.sequence ~= nil then
    self.sequence:Kill()
    self.sequence = nil
  end
end

function UIFormationBubbleTipsContentComponent:PlayDelayTimer()
  self:ClearDelayTimer()
  self.delayTimer = TimerManager:GetInstance():DelayInvoke(function()
    self.delayTimer = nil
    self:SetBubbleActive(false)
  end, 3)
end

function UIFormationBubbleTipsContentComponent:ClearDelayTimer()
  if self.delayTimer ~= nil then
    self.delayTimer:Stop()
    self.delayTimer = nil
  end
end

return UIFormationBubbleTipsContentComponent
