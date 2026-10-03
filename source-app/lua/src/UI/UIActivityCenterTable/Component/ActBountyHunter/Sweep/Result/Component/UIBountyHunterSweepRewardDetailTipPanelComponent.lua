local base = UIBaseContainer
local UIBountyHunterSweepRewardDetailTipPanelComponent = BaseClass("UIBountyHunterSweepRewardDetailTipPanelComponent", UIBaseContainer)
local Localization = CS.GameEntry.Localization
local UIBountyHunterSweepRewardItemComponent = require("UI.UIActivityCenterTable.Component.ActBountyHunter.Sweep.Result.Component.UIBountyHunterSweepRewardItemComponent")
local UIBountyHunterSweepRewardItem_Path = "Assets/Main/Prefabs/UI/ActivityCenter/BountyHunter/BountyHunterSweep/UIBountyHunterSweepRewardItem.prefab"

function UIBountyHunterSweepRewardDetailTipPanelComponent:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function UIBountyHunterSweepRewardDetailTipPanelComponent:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UIBountyHunterSweepRewardDetailTipPanelComponent:ComponentDefine()
  self.viewSkin = self:AddComponent(UIViewSkinBridge, "")
  self.compMonsterRewardContent = self.viewSkin:AddComponent(self, UIBaseContainer, 1)
  self.compChestRewardContent = self.viewSkin:AddComponent(self, UIBaseContainer, 2)
  self.btnMask = self.viewSkin:AddComponent(self, UIButton, 3)
  self.btnMask:SetOnClick(function()
    self:OnBtnMaskClick()
  end)
end

function UIBountyHunterSweepRewardDetailTipPanelComponent:ComponentDestroy()
  self:ClearChestRewardContent()
  self:ClearMonsterRewardContent()
  self.viewSkin = nil
  self.compMonsterRewardContent = nil
  self.compChestRewardContent = nil
  self.btnMask = nil
end

function UIBountyHunterSweepRewardDetailTipPanelComponent:DataDefine()
  self.monsterReqsEvent = {}
  self.chestReqsEvent = {}
end

function UIBountyHunterSweepRewardDetailTipPanelComponent:DataDestroy()
  self.monsterReqsEvent = {}
  self.chestReqsEvent = {}
end

function UIBountyHunterSweepRewardDetailTipPanelComponent:OnBtnMaskClick()
  self:SetActive(false)
end

function UIBountyHunterSweepRewardDetailTipPanelComponent:SetData(data, bountyHunterData, skipAnim)
  self.data = data
  self.skipAnim = skipAnim
  self:RefreshMonsterRewardArea()
  self:RefreshChestRewardArea()
  CS.UnityEngine.UI.LayoutRebuilder.ForceRebuildLayoutImmediate(self.compMonsterRewardContent.transform)
end

function UIBountyHunterSweepRewardDetailTipPanelComponent:RefreshMonsterRewardArea()
  self:ClearMonsterRewardContent()
  for i = 1, #self.data.monsterReward do
    self.monsterReqsEvent[i] = self:GameObjectInstantiateAsync(UIBountyHunterSweepRewardItem_Path, function(request)
      if request.isError then
        return
      end
      local go = request.gameObject
      go.transform:SetParent(self.compMonsterRewardContent.transform)
      go.transform:Set_localScale(0.8, 0.8, 1)
      go.transform:Set_localEulerAngles(ResetPosition.x, ResetPosition.y, ResetPosition.z)
      local nameStr = "item_reward_" .. tostring(i)
      go.name = nameStr
      go.gameObject:SetActive(true)
      local cell = self.compMonsterRewardContent:AddComponent(UIBountyHunterSweepRewardItemComponent, go.name)
      cell:ReInit(self.data.monsterReward[i])
      if not self.skipAnim then
        cell:ShowAnim(0)
      else
        cell:Show()
      end
    end)
  end
end

function UIBountyHunterSweepRewardDetailTipPanelComponent:ClearMonsterRewardContent()
  self.compMonsterRewardContent:RemoveComponents(UIBountyHunterSweepRewardItemComponent)
  for k, v in pairs(self.monsterReqsEvent) do
    if v ~= nil then
      self:GameObjectDestroy(v)
    end
  end
  self.monsterReqsEvent = {}
end

function UIBountyHunterSweepRewardDetailTipPanelComponent:RefreshChestRewardArea()
  self:ClearChestRewardContent()
  for i = 1, #self.data.chestReward do
    self.chestReqsEvent[i] = self:GameObjectInstantiateAsync(UIBountyHunterSweepRewardItem_Path, function(request)
      if request.isError then
        return
      end
      local go = request.gameObject
      go.transform:SetParent(self.compChestRewardContent.transform)
      go.transform:Set_localScale(0.8, 0.8, 1)
      go.transform:Set_localEulerAngles(ResetPosition.x, ResetPosition.y, ResetPosition.z)
      local nameStr = "item_reward_" .. tostring(i)
      go.name = nameStr
      go.gameObject:SetActive(true)
      local cell = self.compChestRewardContent:AddComponent(UIBountyHunterSweepRewardItemComponent, go.name)
      cell:ReInit(self.data.chestReward[i])
      if not self.skipAnim then
        cell:ShowAnim(0)
      else
        cell:Show()
      end
    end)
  end
end

function UIBountyHunterSweepRewardDetailTipPanelComponent:ClearChestRewardContent()
  self.compChestRewardContent:RemoveComponents(UIBountyHunterSweepRewardItemComponent)
  for k, v in pairs(self.chestReqsEvent) do
    if v ~= nil then
      self:GameObjectDestroy(v)
    end
  end
  self.chestReqsEvent = {}
end

return UIBountyHunterSweepRewardDetailTipPanelComponent
