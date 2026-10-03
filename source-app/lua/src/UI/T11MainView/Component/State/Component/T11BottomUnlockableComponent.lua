local base = UIBaseContainer
local T11BottomUnlockableComponent = BaseClass("T11BottomUnlockableComponent", UIBaseContainer)
local Localization = CS.GameEntry.Localization
local CommonGroupCost = require("UI.UICommonCostGroup.CommonGroupCostComponent")
local common_group_cost_path = "CommonGroupCost"

function T11BottomUnlockableComponent:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function T11BottomUnlockableComponent:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function T11BottomUnlockableComponent:ComponentDefine()
  self.viewSkin = self:AddComponent(UIViewSkinBridge, "")
  self.btnResearch = self.viewSkin:AddComponent(self, UIButton, 1)
  self.btnResearch:SetOnClick(function()
    self:OnBtnResearchClick()
  end)
  self.textTip = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 2)
  self.costItem = self:AddComponent(CommonGroupCost, common_group_cost_path)
end

function T11BottomUnlockableComponent:ComponentDestroy()
  self.viewSkin = nil
  self.btnResearch = nil
  self.textTip = nil
end

function T11BottomUnlockableComponent:DataDefine()
end

function T11BottomUnlockableComponent:DataDestroy()
end

function T11BottomUnlockableComponent:OnEnable()
  base.OnEnable(self)
  self:RefreshView()
end

function T11BottomUnlockableComponent:OnAddListener()
  base.OnAddListener(self)
end

function T11BottomUnlockableComponent:OnRemoveListener()
  base.OnRemoveListener(self)
end

function T11BottomUnlockableComponent:OnBtnResearchClick()
  local isExistLackRes = self.costItem:CheckIsLackRes(true)
  if isExistLackRes then
    return
  end
  if not T11Util.IfHasUnLockCamp() then
    UIUtil.ShowTipsId("t11_unlock_building_35")
    return
  end
  SFSNetwork.SendMessage(MsgDefines.SoldierElevenStage)
end

function T11BottomUnlockableComponent:RefreshView()
  local nextStageCostData = T11Util.GetNextStageUpgradeCostData()
  if not nextStageCostData then
    self.costItem:SetActive(false)
    return
  end
  self.costItem:SetActive(true)
  self.costItem:ReInit(nextStageCostData, true)
  local hasLockCamp = T11Util.IfHasUnLockCamp()
  local color = hasLockCamp and "60EF85" or "FF0000"
  local tipId = hasLockCamp and "soldier_eleven_unlock" or "t11_unlock_building_35_info"
  self.textTip:SetLocalText(tipId)
  self.textTip:SetColorHex(color)
end

return T11BottomUnlockableComponent
