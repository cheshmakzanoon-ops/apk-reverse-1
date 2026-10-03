local base = UIBaseContainer
local UILWHeroTryOutTaskItemComponent = BaseClass("UILWHeroTryOutTaskItemComponent", UIBaseContainer)
local Localization = CS.GameEntry.Localization

function UILWHeroTryOutTaskItemComponent:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function UILWHeroTryOutTaskItemComponent:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UILWHeroTryOutTaskItemComponent:ComponentDefine()
  self.viewSkin = self:AddComponent(UIViewSkinBridge, "")
  self.textTitle = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 1)
  self.scrollViewUICommonScrollViewHorizontal = self.viewSkin:AddComponent(self, UIScrollView, 2)
  self.btnGo = self.viewSkin:AddComponent(self, UIButton, 3)
  self.btnGo:SetOnClick(function()
    self:OnBtnGoClick()
  end)
  self.textGoBtn = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 4)
  self.btnLock = self.viewSkin:AddComponent(self, UIButton, 5)
  self.btnLock:SetOnClick(function()
    self:OnBtnLockClick()
  end)
  self.textLockBtn = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 6)
  self.compFinished = self.viewSkin:AddComponent(self, UIBaseComponent, 7)
  self.scrollViewUICommonScrollViewHorizontal:SetFixedItemSize(150, 150)
  self.scrollViewUICommonScrollViewHorizontal:SetOnItemMoveIn(function(itemObj, index)
    self:OnItemMoveIn(itemObj, index)
  end)
  self.scrollViewUICommonScrollViewHorizontal:SetOnItemMoveOut(function(itemObj, index)
    self:OnItemMoveOut(itemObj, index)
  end)
  self.textGoBtn:SetLocalText("herotrial_btn_03")
  self.textLockBtn:SetLocalText("herotrial_btn_03")
  self.btnGo:SetSafeClickMode(true)
end

function UILWHeroTryOutTaskItemComponent:ComponentDestroy()
  self:ClearScroll()
  self.viewSkin = nil
  self.textTitle = nil
  self.scrollViewUICommonScrollViewHorizontal = nil
  self.btnGo = nil
  self.textGoBtn = nil
  self.btnLock = nil
  self.textLockBtn = nil
  self.compFinished = nil
end

function UILWHeroTryOutTaskItemComponent:DataDefine()
  self.template = nil
  self.waitPlotGroupId = nil
  self.groupIndex = 0
  self.tagTemplate = nil
end

function UILWHeroTryOutTaskItemComponent:DataDestroy()
  self.template = nil
  self.waitPlotGroupId = nil
  self.groupIndex = nil
  self.tagTemplate = nil
end

function UILWHeroTryOutTaskItemComponent:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.PlotGroupDone, self.OnPlotGroupDone)
  self:AddUIListener(EventId.PlotViewClosedAbnormally, self.OnPlotGroupCloseAbnormally)
end

function UILWHeroTryOutTaskItemComponent:OnRemoveListener()
  self:RemoveUIListener(EventId.PlotGroupDone, self.OnPlotGroupDone)
  self:RemoveUIListener(EventId.PlotViewClosedAbnormally, self.OnPlotGroupCloseAbnormally)
  base.OnRemoveListener(self)
end

function UILWHeroTryOutTaskItemComponent:ReInit(groupData, tagTemplate, template)
  if groupData == nil or tagTemplate == nil or template == nil then
    return
  end
  self.groupIndex = groupData.groupIndex
  self.tagTemplate = tagTemplate
  self.template = template
  self.textTitle:SetLocalText(self.template.name)
  self.rewards = self.template:GetRewardsForShow()
  if #self.rewards > 0 then
    self.scrollViewUICommonScrollViewHorizontal:SetTotalCount(#self.rewards)
    self.scrollViewUICommonScrollViewHorizontal:RefillCells()
  end
  local curState = self:GetState()
  self.btnGo:SetActive(curState == DataCenter.HeroTryOutManager.State.Going)
  self.btnLock:SetActive(curState == DataCenter.HeroTryOutManager.State.Locked)
  self.compFinished:SetActive(curState == DataCenter.HeroTryOutManager.State.Finished)
end

function UILWHeroTryOutTaskItemComponent:OnItemMoveIn(itemObj, index)
  itemObj.transform:Set_localScale(0.75, 0.75, 0.75)
  itemObj.name = tostring(index)
  local cellItem = self.scrollViewUICommonScrollViewHorizontal:AddComponent(UICommonResItem, itemObj)
  if cellItem ~= nil then
    cellItem:ReInit(self.rewards[index])
  end
end

function UILWHeroTryOutTaskItemComponent:OnItemMoveOut(itemObj, index)
  self.scrollViewUICommonScrollViewHorizontal:RemoveComponent(itemObj.name, UICommonResItem)
end

function UILWHeroTryOutTaskItemComponent:ClearScroll()
  self.scrollViewUICommonScrollViewHorizontal:ClearCells()
  self.scrollViewUICommonScrollViewHorizontal:RemoveComponents(UICommonResItem)
end

function UILWHeroTryOutTaskItemComponent:OnBtnGoClick()
  if self.template ~= nil then
    local curState = self:GetState()
    if curState ~= DataCenter.HeroTryOutManager.State.Going then
      Logger.LogInfo("HeroTryOut\239\188\140UILWHeroTryOutTaskItemComponent:OnBtnGoClick state is not going, return " .. tostring(curState))
      return
    end
    local id = self.template.id
    if CS.SceneManager.IsInPVE() or UIManager:GetInstance():IsWindowOpen(UIWindowNames.UIPVELoading) then
      Logger.LogInfo("HeroTryOut\239\188\140UILWHeroTryOutTaskItemComponent:OnBtnGoClick in pve, return " .. tostring(id))
      return
    end
    if self.template.plot_enter and self.template.plot_enter > 0 then
      self.waitPlotGroupId = self.template.plot_enter
      DataCenter.LWPlotManager:CheckPlotValidity()
      EventManager:GetInstance():Broadcast(EventId.PlayPlotGroup, {
        plotGroupId = self.template.plot_enter,
        hideMainUI = false
      })
    else
      DataCenter.HeroTryOutManager:EnterBattle(id, false, "UILWHeroTryOutTaskItemComponent:OnBtnGoClick")
    end
  end
end

function UILWHeroTryOutTaskItemComponent:OnBtnLockClick()
end

function UILWHeroTryOutTaskItemComponent:OnPlotGroupDone(plotGroupId)
  if self.template ~= nil then
    local id = self.template.id
    local curState = self:GetState()
    if curState ~= DataCenter.HeroTryOutManager.State.Going then
      Logger.LogInfo("HeroTryOut\239\188\140UILWHeroTryOutTaskItemComponent:OnPlotGroupDone state is not going, return " .. tostring(curState))
      return
    end
    if CS.SceneManager.IsInPVE() or UIManager:GetInstance():IsWindowOpen(UIWindowNames.UIPVELoading) then
      Logger.LogInfo("HeroTryOut\239\188\140UILWHeroTryOutTaskItemComponent:OnPlotGroupDone in pve, return " .. tostring(id))
      return
    end
    if plotGroupId == self.waitPlotGroupId and self.template.plot_enter and self.template.plot_enter > 0 and plotGroupId == self.template.plot_enter then
      self.waitPlotGroupId = nil
      DataCenter.HeroTryOutManager:EnterBattle(id, false, "UILWHeroTryOutTaskItemComponent:OnPlotGroupDone " .. tostring(plotGroupId))
    end
  end
end

function UILWHeroTryOutTaskItemComponent:OnPlotGroupCloseAbnormally(plotGroupId)
  if self.template ~= nil then
    local id = self.template.id
    local curState = self:GetState()
    if curState ~= DataCenter.HeroTryOutManager.State.Going then
      Logger.LogInfo("HeroTryOut\239\188\140UILWHeroTryOutTaskItemComponent:OnPlotGroupCloseAbnormally state is not going, return " .. tostring(curState))
      return
    end
    if CS.SceneManager.IsInPVE() or UIManager:GetInstance():IsWindowOpen(UIWindowNames.UIPVELoading) then
      Logger.LogInfo("HeroTryOut\239\188\140UILWHeroTryOutTaskItemComponent:OnPlotGroupCloseAbnormally in pve, return " .. tostring(id))
      return
    end
    if plotGroupId == self.waitPlotGroupId and self.template.plot_enter and self.template.plot_enter > 0 and plotGroupId == self.template.plot_enter then
      self.waitPlotGroupId = nil
      DataCenter.HeroTryOutManager:EnterBattle(id, false, "UILWHeroTryOutTaskItemComponent:OnPlotGroupCloseAbnormally " .. tostring(plotGroupId))
    end
  end
end

function UILWHeroTryOutTaskItemComponent:GetState()
  if self.template == nil or self.tagTemplate == nil or self.groupIndex == nil then
    return DataCenter.HeroTryOutManager.State.Locked
  end
  local isGroupTimeOpen = self.tagTemplate:IsTagOpen() and self.tagTemplate:IsGroupTimeOpenByGroupIndex(self.groupIndex)
  if not isGroupTimeOpen then
    return DataCenter.HeroTryOutManager.State.Locked
  else
    return self.template:GetState()
  end
end

return UILWHeroTryOutTaskItemComponent
