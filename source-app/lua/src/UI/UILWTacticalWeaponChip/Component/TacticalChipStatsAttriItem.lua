local base = UIBaseContainer
local TacticalChipStatsAttriItem = BaseClass("TacticalChipStatsAttriItem", UIBaseContainer)
local Localization = CS.GameEntry.Localization
local VFX_DURATION = 0.5

function TacticalChipStatsAttriItem:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function TacticalChipStatsAttriItem:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function TacticalChipStatsAttriItem:ComponentDefine()
  self.textTitle = self:AddComponent(UITextMeshProUGUIEx, "title")
  self.textTitle:OnPointerClick(function(eventData)
    DataCenter.TacticalChipManager.UITextClickTips(eventData, self.textTitle)
  end)
  self.textNormalValue = self:AddComponent(UIText, "normalValue")
  self.compArrow = self:AddComponent(UIBaseContainer, "normalValue/arrow")
  self.textNextValue = self:AddComponent(UIText, "normalValue/nextValue")
  self.compVfxNode = self:AddComponent(UIVfx, "vfxNode", VfxAssets.CombatUpgradeEffect)
  self.compArrow:SetActive(false)
  self.textNextValue:SetActive(false)
end

function TacticalChipStatsAttriItem:ComponentDestroy()
  if self.vfxTimer then
    self.vfxTimer:Stop()
    self.vfxTimer = nil
  end
  self.textTitle = nil
  self.textNormalValue = nil
  self.compArrow = nil
  self.textNextValue = nil
  self.compVfxNode = nil
end

function TacticalChipStatsAttriItem:DataDefine()
end

function TacticalChipStatsAttriItem:DataDestroy()
  self.vfxId = nil
end

function TacticalChipStatsAttriItem:OnAddListener()
  base.OnAddListener(self)
end

function TacticalChipStatsAttriItem:OnRemoveListener()
  base.OnRemoveListener(self)
end

function TacticalChipStatsAttriItem:SetData(data)
  if self.data == nil then
    self.data = data
    self:RefreshUI()
    return
  end
  if self.data.value ~= data.value then
    self.compVfxNode:Replay()
    if self.vfxTimer then
      self.vfxTimer:Stop()
    end
    self.vfxTimer = TimerManager:GetInstance():DelayInvoke(function()
      self:RefreshUI()
    end, VFX_DURATION)
    self.data = data
  else
    self:RefreshUI()
  end
end

function TacticalChipStatsAttriItem:ShowPreData(data)
  if self.data == nil or self.data.value == data.value then
    return
  end
  self.textNextValue:SetText(data.value)
  self.compArrow:SetActive(true)
  self.textNextValue:SetActive(true)
end

function TacticalChipStatsAttriItem:RefreshUI()
  self.textTitle:SetText(self.data.title)
  self.textNormalValue:SetText(self.data.value)
  self.compArrow:SetActive(false)
  self.textNextValue:SetActive(false)
end

return TacticalChipStatsAttriItem
