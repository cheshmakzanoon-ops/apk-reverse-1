local AllyDrillDiffItem = BaseClass("AllyDrillDiffItem", UIBaseContainer)
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization

function AllyDrillDiffItem:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function AllyDrillDiffItem:OnDestroy()
  self:ComponentDestroy()
  self:DataDestroy()
  base.OnDestroy(self)
end

function AllyDrillDiffItem:ComponentDefine()
  self.last = self:AddComponent(UIBaseComponent, "Last")
  self.recommend = self:AddComponent(UIBaseComponent, "Recommend")
  self.checkmark = self:AddComponent(UIBaseComponent, "Checkmark")
  self.label = self:AddComponent(UIText, "Label")
  self.lock = self:AddComponent(UIBaseComponent, "Lock")
  local btn = self:AddComponent(UIButton, "")
  btn:SetOnClick(function()
    self:OnBtnClick()
  end)
end

function AllyDrillDiffItem:ComponentDestroy()
  self.last = nil
  self.checkmark = nil
  self.label = nil
  self.lock = nil
end

function AllyDrillDiffItem:DataDefine()
end

function AllyDrillDiffItem:DataDestroy()
end

function AllyDrillDiffItem:OnAddListener()
  base.OnAddListener(self)
end

function AllyDrillDiffItem:OnRemoveListener()
  base.OnRemoveListener(self)
end

function AllyDrillDiffItem:Refresh(isLast, isLock, isRecommend, difficulty, unlockLimit, unlockStageLimit, lockTips)
  self.isLock = isLock
  self.last:SetActive(false)
  self.recommend:SetActive(isRecommend)
  self.lock:SetActive(isLock)
  self.difficulty = difficulty
  self.lockTips = lockTips
  self.unlockLimit = unlockLimit
  self.unlockStageLimit = unlockStageLimit
  self.label:SetLocalText(2010379, self.difficulty)
end

function AllyDrillDiffItem:SetCheckmark(isSelect)
  self.checkmark:SetActive(isSelect)
end

function AllyDrillDiffItem:OnBtnClick()
  if self.isLock then
    UIUtil.ShowTips(Localization:GetString(self.lockTips, self.unlockLimit, self.unlockStageLimit))
    return
  end
  self.view:ChooseDiff(self.difficulty)
end

return AllyDrillDiffItem
