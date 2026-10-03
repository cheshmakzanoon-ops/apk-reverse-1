local ChooseDominator = BaseClass("ChooseDominator", UIBaseContainer)
local ChooseDominatorPopup = require("UI.UILWHero.UIHeroPVPFormationPanel.Component.ChooseDominatorPopup")
local DominatorUtils = require("DataCenter.Dominator.Main.DominatorUtils")
local ArmyFormationUtils = require("DataCenter.ArmyFormationData.ArmyFormationUtils")
local base = UIBaseContainer

function ChooseDominator:OnCreate(btnContainer, popupContainer)
  base.OnCreate(self)
  self.btnContainer = btnContainer
  self.popupContainer = popupContainer
  self:ComponentDefine()
end

function ChooseDominator:OnDestroy()
  if self.popup and self.popup.gameObject then
    self.popupContainer:RemoveComponents(ChooseDominatorPopup)
  end
  if self.popupReq then
    self:GameObjectDestroy(self.popupReq)
  end
  if self.btnReq then
    self:GameObjectDestroy(self.btnReq)
  end
  self.popup = nil
  self.popupReq = nil
  if self.btn and self.btn.gameObject then
    self.btnContainer:RemoveComponent(self.btn:GetName(), UIButton)
  end
  self.btn = nil
  self.btnReq = nil
  self.btnContainer = nil
  self.popupContainer = nil
  self.squadData = nil
  self.extraData = nil
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function ChooseDominator:ComponentDefine()
end

function ChooseDominator:ComponentDestroy()
  self.btn = nil
  self.icon = nil
  self.trialIcon = nil
end

function ChooseDominator:OnDominatorUpdate(squadUuid)
  if self.squadData and self.squadData.uuid == squadUuid then
    self:RefreshSelectedDominator()
  end
end

function ChooseDominator:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.DominatorFormationUpdate, self.OnDominatorUpdate)
end

function ChooseDominator:OnRemoveListener()
  base.OnRemoveListener(self)
  self:RemoveUIListener(EventId.DominatorFormationUpdate, self.OnDominatorUpdate)
end

function ChooseDominator:RefreshLines()
end

function ChooseDominator:OnEnable()
  base.OnEnable(self)
end

function ChooseDominator:Refresh()
  local isShow = false
  if self.source == EnterHeroSquadPanelWay.DetectEventPVE then
    isShow = DataCenter.DominatorManager:HasDominatorUnlockBattleForTrial()
  elseif self.source == EnterHeroSquadPanelWay.TowerupJeepAdventure then
    if self.extraData ~= nil and self.extraData.pageType == JeepAdventurePageType.Domintor then
      isShow = DataCenter.DominatorManager:HasDominatorUnlockBattleForTrial()
    else
      isShow = DataCenter.DominatorManager:HasDominatorUnlockBattle()
    end
  elseif self.source == EnterHeroSquadPanelWay.HeroTryOut then
    isShow = false
  else
    isShow = DataCenter.DominatorManager:HasDominatorUnlockBattle()
  end
  self:SetBtnState(isShow)
end

function ChooseDominator:RefreshSelectedDominator()
  if self.icon then
    local setNamed = false
    local squadUsingDominator = DominatorUtils.GetSquadUseDominator(self.source, self.squadIdx, self.squadData)
    if squadUsingDominator then
      local dominatorInfo = DataCenter.DominatorManager:GetInfoByUuid(squadUsingDominator)
      if dominatorInfo then
        setNamed = true
        local mainTemplate = dominatorInfo:GetMainTemplate()
        if mainTemplate then
          local iconPath = mainTemplate:GetSmallPicPath()
          self.icon:LoadSprite(iconPath)
        else
          self.icon:LoadSprite(LoadPath.DominatorDefaultRoundIcon)
        end
        local isTrial = false
        if not dominatorInfo:IsUnlockedBattle() and dominatorInfo:IsUnlockedBattleForTrial() then
          isTrial = true
        end
        if self.trialIcon then
          self.trialIcon:SetActive(isTrial)
        end
      end
    else
      self.icon:LoadSprite("Assets/Main/Sprites/UI/UILWHeroSquad/zxl_zhuzai_biandui_tianjia.png")
      if self.trialIcon then
        self.trialIcon:SetActive(false)
      end
    end
  end
end

function ChooseDominator:SetData(source, squadIdx, extraData)
  self.source = source
  self.squadIdx = squadIdx
  self.extraData = extraData
  self:Refresh()
  if self.popup then
    self.popup:SetData(self.source, self.squadIdx)
  end
end

function ChooseDominator:SetSquadData(squadData)
  local prevSquadData = self.squadData
  self.squadData = squadData
  if prevSquadData ~= self.squadData then
    self:RefreshSelectedDominator()
  end
  if self.popup then
    self.popup:SetSquadData(self.squadData)
  end
end

local Btn_Path = "Assets/Main/Prefabs/UI/UIHero/LWHero/Formation/formationChooseDominator.prefab"

function ChooseDominator:SetBtnState(show)
  self.showState = show
  if self.btn then
    self.btn:SetActive(self.showState)
    if self.showState then
      self:RefreshSelectedDominator()
    end
  elseif show and not self.btnReq then
    self.btnReq = self:GameObjectInstantiateAsync(Btn_Path, function(req)
      local obj = req.gameObject
      if IsNull(obj) then
        return
      end
      local go = obj.transform
      go:SetParent(self.btnContainer.transform)
      local name = "ChooseDominator"
      go.name = name
      go:Set_localScale(1, 1, 1)
      self.btn = self.btnContainer:AddComponent(UIButton, name)
      self.btn:SetOnClick(function()
        self:OnClick()
      end)
      self.icon = self.btn:AddComponent(UIImage, "icon")
      self.trialIcon = self.btn:AddComponent(UIBaseContainer, "trail")
      self.btn:SetActive(self.showState)
      if self.showState then
        self:RefreshSelectedDominator()
      end
    end)
  end
end

function ChooseDominator:OnClick()
  if self.popupState == nil then
    self.popupState = false
  end
  self.popupState = not self.popupState
  self:RefreshPopupState(self.popupState)
end

local PopupPath = "Assets/Main/Prefabs/UI/UIHero/LWHero/Formation/popupChooseDominator.prefab"

function ChooseDominator:RefreshPopupState(show)
  if self.popup then
    self.popup:SetActive(show)
  end
  if show and not self.popupReq then
    self.popupReq = self:GameObjectInstantiateAsync(PopupPath, function(req)
      local obj = req.gameObject
      if IsNull(obj) then
        return
      end
      local go = obj.transform
      go:SetParent(self.popupContainer.transform)
      go:Set_localScale(1, 1, 1)
      local name = "ChooseDominatorPopup"
      go.name = name
      self.popup = self.popupContainer:AddComponent(ChooseDominatorPopup, name, self, self.source, self.squadIdx, self.squadData)
      local x, y, z = self.btn:GetPositionXYZ()
      self.popup:SetPosition(x, y, z)
      self.popup:SetActive(self.popupState)
    end)
  end
end

function ChooseDominator:HidePopup()
  self.popupState = false
  self:RefreshPopupState(self.popupState)
end

function ChooseDominator:OnChooseDominator(dominatorUuid)
  local squadData = ArmyFormationUtils.GetArmyFormationDataByEnterWay(self.source, self.squadIdx, self.squadData)
  if squadData == nil then
    return
  end
  if not squadData:IsFree() or self.holder.CanEdit and not self.holder:CanEdit() then
    if self.source == EnterHeroSquadPanelWay.HSRDeparture then
      UIUtil.ShowTipsId("server_train_formation_tips")
    else
      UIUtil.ShowTipsId("dominator_squad_march_warning")
    end
    return
  end
  local squadUsingDominator = DominatorUtils.GetSquadUseDominator(self.source, self.squadIdx, self.squadData)
  if squadUsingDominator and squadUsingDominator == dominatorUuid then
    DominatorUtils.UnsetSquadUseDominator(self.source, self.squadIdx, self.squadData)
  else
    DominatorUtils.SetSquadUseDominator(self.source, self.squadIdx, dominatorUuid, self.squadData)
  end
  self:HidePopup()
  self:RefreshSelectedDominator()
end

return ChooseDominator
