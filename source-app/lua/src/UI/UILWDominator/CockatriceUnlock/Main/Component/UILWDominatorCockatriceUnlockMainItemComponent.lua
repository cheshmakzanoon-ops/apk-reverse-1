local base = UIBaseContainer
local UILWDominatorCockatriceUnlockMainItemComponent = BaseClass("UILWDominatorCockatriceUnlockMainItemComponent", UIBaseContainer)
local Localization = CS.GameEntry.Localization

function UILWDominatorCockatriceUnlockMainItemComponent:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function UILWDominatorCockatriceUnlockMainItemComponent:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UILWDominatorCockatriceUnlockMainItemComponent:ComponentDefine()
  self.imgIcon = self:AddComponent(UIImage, "Icon")
  self.btnFragment01 = self:AddComponent(UIButton, "")
  self.btnFragment01:SetOnClick(function()
    self:OnBtnFragment01Click()
  end)
  self.compLockedContent = self:AddComponent(UIBaseContainer, "LockedContent")
  self.compFinished = self:AddComponent(UIBaseContainer, "Finished")
  self.compRedDotWithoutNum = self:AddComponent(UIBaseContainer, "RedDotWithoutNum")
  self.compGoing = self:AddComponent(UIBaseContainer, "Going")
  self.compUnlockedContent = self:AddComponent(UIBaseContainer, "UnlockedContent")
  self.compEffUiCockatriceReserch = self:AddComponent(UIBaseContainer, "bg/Eff_ui_cockatrice_reserch")
end

function UILWDominatorCockatriceUnlockMainItemComponent:ComponentDestroy()
  self.imgIcon = nil
  self.btnFragment01 = nil
  self.compLockedContent = nil
  self.compFinished = nil
  self.compRedDotWithoutNum = nil
  self.compGoing = nil
  self.compUnlockedContent = nil
  self.compEffUiCockatriceReserch = nil
end

function UILWDominatorCockatriceUnlockMainItemComponent:DataDefine()
end

function UILWDominatorCockatriceUnlockMainItemComponent:DataDestroy()
end

function UILWDominatorCockatriceUnlockMainItemComponent:OnAddListener()
  base.OnAddListener(self)
end

function UILWDominatorCockatriceUnlockMainItemComponent:OnRemoveListener()
  base.OnRemoveListener(self)
end

function UILWDominatorCockatriceUnlockMainItemComponent:ReInit(index)
  self.index = index
  local curState = DataCenter.DominatorCockatriceUnlockManager:GetTaskGroupState(self.index)
  local iconPath = DataCenter.DominatorCockatriceUnlockManager:GetQuestGroupIconPath(self.index)
  if not string.IsNullOrEmpty(iconPath) then
    self.imgIcon:LoadSprite(iconPath)
  end
  self.compLockedContent:SetActive(curState == DataCenter.DominatorCockatriceUnlockManager.TaskGroupState.Waiting or curState == DataCenter.DominatorCockatriceUnlockManager.TaskGroupState.Locked)
  self.compFinished:SetActive(curState == DataCenter.DominatorCockatriceUnlockManager.TaskGroupState.Finished)
  self.compGoing:SetActive(curState == DataCenter.DominatorCockatriceUnlockManager.TaskGroupState.Going)
  self.compEffUiCockatriceReserch:SetActive(curState == DataCenter.DominatorCockatriceUnlockManager.TaskGroupState.Going)
  self.compRedDotWithoutNum:SetActive(DataCenter.DominatorCockatriceUnlockManager:GetGroupShowRedCount(self.index) > 0)
  self.compUnlockedContent:SetActive(false)
  if curState == DataCenter.DominatorCockatriceUnlockManager.TaskGroupState.Going and not DataCenter.DominatorCockatriceUnlockManager:IsHasShownQuestGroupUnlockEffect(self.index) then
    self.compUnlockedContent:SetActive(true)
    DataCenter.DominatorCockatriceUnlockManager:SetHasShownQuestGroupUnlockEffect(self.index)
  end
end

function UILWDominatorCockatriceUnlockMainItemComponent:OnBtnFragment01Click()
  local curState = DataCenter.DominatorCockatriceUnlockManager:GetTaskGroupState(self.index)
  if curState == DataCenter.DominatorCockatriceUnlockManager.TaskGroupState.Going then
    UIManager:GetInstance():OpenWindow(UIWindowNames.UILWDominatorCockatriceUnlock, {anim = true}, self.index)
  elseif curState == DataCenter.DominatorCockatriceUnlockManager.TaskGroupState.Finished then
    UIUtil.ShowTipsId("war_eagle_event_desc_13")
  elseif curState == DataCenter.DominatorCockatriceUnlockManager.TaskGroupState.Waiting then
    UIUtil.ShowTipsId("war_eagle_event_desc_14")
  elseif curState == DataCenter.DominatorCockatriceUnlockManager.TaskGroupState.Locked then
    local preIndex = self.index - 1
    if 0 < preIndex and DataCenter.DominatorCockatriceUnlockManager:GetTaskGroupState(preIndex) == DataCenter.DominatorCockatriceUnlockManager.TaskGroupState.Going then
      UIUtil.ShowTipsId("war_eagle_event_desc_14")
    else
      local unlockTime = DataCenter.DominatorCockatriceUnlockManager:GetQuestGroupUnlockTime(self.index)
      local nowTime = UITimeManager:GetInstance():GetServerTime()
      local timeStr = UITimeManager:GetInstance():MilliSecondToFmtString(math.max(0, unlockTime - nowTime))
      UIUtil.ShowTips(Localization:GetString("war_eagle_event_desc_15", timeStr))
    end
  end
end

return UILWDominatorCockatriceUnlockMainItemComponent
