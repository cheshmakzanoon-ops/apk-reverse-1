local base = UIBaseContainer
local UIBountyHunterSweepRewardCostTipPanelComponent = BaseClass("UIBountyHunterSweepRewardCostTipPanelComponent", UIBaseContainer)
local Localization = CS.GameEntry.Localization
local UIBountyHunterSweepRewardEventItemComponent = require("UI.UIActivityCenterTable.Component.ActBountyHunter.Sweep.Result.Component.UIBountyHunterSweepRewardEventItemComponent")

function UIBountyHunterSweepRewardCostTipPanelComponent:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function UIBountyHunterSweepRewardCostTipPanelComponent:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UIBountyHunterSweepRewardCostTipPanelComponent:ComponentDefine()
  self.viewSkin = self:AddComponent(UIViewSkinBridge, "")
  self.btnMask = self.viewSkin:AddComponent(self, UIButton, 1)
  self.btnMask:SetOnClick(function()
    self:OnBtnMaskClick()
  end)
  self.textDesc = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 2)
  self.compEventBefore = self.viewSkin:AddComponent(self, UIBountyHunterSweepRewardEventItemComponent, 3)
  self.compEventAfter = self.viewSkin:AddComponent(self, UIBountyHunterSweepRewardEventItemComponent, 4)
end

function UIBountyHunterSweepRewardCostTipPanelComponent:ComponentDestroy()
  self.viewSkin = nil
  self.btnMask = nil
  self.textDesc = nil
  self.compEventBefore = nil
  self.compEventAfter = nil
end

function UIBountyHunterSweepRewardCostTipPanelComponent:DataDefine()
end

function UIBountyHunterSweepRewardCostTipPanelComponent:DataDestroy()
end

function UIBountyHunterSweepRewardCostTipPanelComponent:OnBtnMaskClick()
  self:SetActive(false)
end

function UIBountyHunterSweepRewardCostTipPanelComponent:SetData(data, activityData)
  local name = ""
  if activityData then
    name = activityData:GetRefreshItemName()
  end
  self.textDesc:SetText(Localization:GetString("hunter_report_desc2", name))
  local skipCount = data.skipCount or {}
  local skipData = {count = 0}
  for _, v in pairs(skipCount) do
    skipData.id = v.id
    skipData.count = skipData.count + v.count
  end
  self.compEventBefore:ReInitKill(skipData)
  self.compEventBefore:ShowAnim(0)
  local refreshCount = data.refreshCount or {}
  local refreshData = {count = 0}
  for _, v in pairs(refreshCount) do
    refreshData.id = v.id
    refreshData.count = refreshData.count + v.count
  end
  self.compEventAfter:ReInitKill(refreshData)
  self.compEventAfter:ShowAnim(0)
end

return UIBountyHunterSweepRewardCostTipPanelComponent
