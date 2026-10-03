local AllianceKirovDiffItem = BaseClass("AllianceKirovDiffItem", UIBaseContainer)
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization

function AllianceKirovDiffItem:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function AllianceKirovDiffItem:OnDestroy()
  self:ComponentDestroy()
  self:DataDestroy()
  base.OnDestroy(self)
end

function AllianceKirovDiffItem:ComponentDefine()
  self.last = self:AddComponent(UIBaseComponent, "Last")
  self.recommend = self:AddComponent(UIBaseComponent, "Recommend")
  self.checkmark = self:AddComponent(UIBaseComponent, "Checkmark")
  self.label = self:AddComponent(UITextMeshProUGUIEx, "Label")
  self.lock = self:AddComponent(UIBaseComponent, "Lock")
  local btn = self:AddComponent(UIButton, "")
  btn:SetOnClick(function()
    self:OnBtnClick()
  end)
end

function AllianceKirovDiffItem:ComponentDestroy()
  self.last = nil
  self.checkmark = nil
  self.label = nil
  self.lock = nil
end

function AllianceKirovDiffItem:DataDefine()
end

function AllianceKirovDiffItem:DataDestroy()
end

function AllianceKirovDiffItem:OnAddListener()
  base.OnAddListener(self)
end

function AllianceKirovDiffItem:OnRemoveListener()
  base.OnRemoveListener(self)
end

function AllianceKirovDiffItem:Refresh(isLock, nLevel)
  self.isLock = isLock
  self.lock:SetActive(isLock)
  self.label:SetText("Lv." .. nLevel)
  self.nLevel = nLevel
end

function AllianceKirovDiffItem:SetCheckmark(isSelect)
  self.checkmark:SetActive(isSelect)
end

function AllianceKirovDiffItem:OnBtnClick()
  if self.isLock then
    UIUtil.ShowTipsId("challenge_zombie_open_condition_num")
    return
  end
  self.view:ChooseDiff(self.nLevel)
end

return AllianceKirovDiffItem
