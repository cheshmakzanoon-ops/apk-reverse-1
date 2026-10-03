local base = UIBaseContainer
local UIParkourHeroQuickUpgradeContentComponent = BaseClass("UIParkourHeroQuickUpgradeContentComponent", UIBaseContainer)
local Localization = CS.GameEntry.Localization
local ResourceManager = CS.GameEntry.Resource

function UIParkourHeroQuickUpgradeContentComponent:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function UIParkourHeroQuickUpgradeContentComponent:OnDestroy()
  self:ClearHeroSpine()
  self:DeleteDelayCloseBubbleTimer()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UIParkourHeroQuickUpgradeContentComponent:ComponentDefine()
  self.viewSkin = self:AddComponent(UIViewSkinBridge, "")
  self.compHeroSpineContainer = self.viewSkin:AddComponent(self, UIBaseContainer, 1)
  self.btnClick = self.viewSkin:AddComponent(self, UIButton, 2)
  self.btnClick:SetOnClick(function()
    self:OnBtnClickClick()
  end)
  self.textBubbleTips = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 3)
  self.compBubbleContent = self.viewSkin:AddComponent(self, UIBaseContainer, 4)
  self.compBubbleContent:SetActive(false)
end

function UIParkourHeroQuickUpgradeContentComponent:ComponentDestroy()
  self.viewSkin = nil
  self.compHeroSpineContainer = nil
  self.btnClick = nil
  self.textBubbleTips = nil
  self.compBubbleContent = nil
end

function UIParkourHeroQuickUpgradeContentComponent:DataDefine()
  self.lastSpinePath = ""
end

function UIParkourHeroQuickUpgradeContentComponent:DataDestroy()
  self.lastSpinePath = nil
  self.delayCloseBubbleTime = nil
end

function UIParkourHeroQuickUpgradeContentComponent:OnAddListener()
  base.OnAddListener(self)
end

function UIParkourHeroQuickUpgradeContentComponent:OnRemoveListener()
  base.OnRemoveListener(self)
end

function UIParkourHeroQuickUpgradeContentComponent:ReInit(quickUpgradeHeroData, heroLanguageKey)
  self.quickUpgradeHeroData = quickUpgradeHeroData
  if string.IsNullOrEmpty(heroLanguageKey) then
    self.textBubbleTips:SetLocalText("quick_upgrade_plot")
  else
    self.textBubbleTips:SetLocalText(heroLanguageKey)
  end
  self:LoadHeroSpine()
  self:ShowPlotBubble()
end

function UIParkourHeroQuickUpgradeContentComponent:LoadHeroSpine()
  if not self.quickUpgradeHeroData then
    return
  end
  local newAppearanceId = DataCenter.LWSaveGirlManager:GetJPAppearanceId(self.quickUpgradeHeroData.heroData.modelId)
  local spinePath = GetTableData(LuaEntry.Player:GetABTestTableName(TableName.HeroAppearance), newAppearanceId, "show_model_path")
  if self.lastSpinePath ~= spinePath then
    self:ClearHeroSpine()
    self.lastSpinePath = spinePath
    if string.IsNullOrEmpty(spinePath) then
      return
    end
    self.heroSpineLoadRequest = ResourceManager:InstantiateAsync(spinePath)
    self.heroSpineLoadRequest:completed("+", function(req)
      local go = req.gameObject
      if IsNull(go) then
        self:ClearHeroSpine()
        return
      end
      go:SetActive(true)
      local transform = go.transform
      transform:SetParent(self.compHeroSpineContainer.transform)
      transform:Set_localScale(1, 1, 1)
      transform:Set_anchoredPosition(0, 0, 0)
    end)
  end
end

function UIParkourHeroQuickUpgradeContentComponent:ClearHeroSpine()
  if self.heroSpineLoadRequest ~= nil then
    self.heroSpineLoadRequest:Destroy()
    self.heroSpineLoadRequest = nil
  end
end

function UIParkourHeroQuickUpgradeContentComponent:ShowPlotBubble()
  self:DeleteDelayCloseBubbleTimer()
  local delayTime = self:GetDelayCloseBubbleTime()
  self.compBubbleContent:SetActive(true)
  self.delayClosePlotTimer = TimerManager:GetInstance():DelayInvoke(function()
    self.delayClosePlotTimer = nil
    if self.compBubbleContent then
      self.compBubbleContent:SetActive(false)
    end
  end, delayTime)
end

function UIParkourHeroQuickUpgradeContentComponent:DeleteDelayCloseBubbleTimer()
  if self.delayClosePlotTimer ~= nil then
    self.delayClosePlotTimer:Stop()
    self.delayClosePlotTimer = nil
  end
end

function UIParkourHeroQuickUpgradeContentComponent:GetDelayCloseBubbleTime()
  if self.delayCloseBubbleTime == nil then
    local value = LuaEntry.DataConfig:TryGetNum("quick_upgrade_hero_plot", "k2")
    if value then
      self.delayCloseBubbleTime = value / 1000
    end
  end
  return self.delayCloseBubbleTime or 0
end

function UIParkourHeroQuickUpgradeContentComponent:OnBtnClickClick()
  if self.quickUpgradeHeroData then
    local heroData = self.quickUpgradeHeroData.heroData
    if heroData == nil then
      return
    end
    PostEventLog.Track(PostEventLog.Defines.c_quick_upgrade_goto_2, {
      heroid = heroData.heroId
    })
    if self.quickUpgradeHeroData.canArmedUpgrade then
      UIManager:GetInstance():OpenWindow(UIWindowNames.UILWArmedUpgradeMain)
      return
    end
    local arrowData = {
      arrowType = HeroDetailGuideArrowType.Upgrade,
      heroUid = heroData.uuid
    }
    if self.quickUpgradeHeroData.levelType == HeroLevelType.CanStarLevel then
      arrowData.arrowType = HeroDetailGuideArrowType.Rank
    end
    UIManager:GetInstance():OpenWindow(UIWindowNames.UIHeroDetailPanel, {anim = false}, heroData.uuid, {
      heroData.uuid
    }, nil, arrowData)
  end
end

return UIParkourHeroQuickUpgradeContentComponent
