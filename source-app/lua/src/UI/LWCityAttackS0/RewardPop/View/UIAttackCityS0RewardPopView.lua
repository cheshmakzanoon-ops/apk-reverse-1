local UIAttackCityS0RewardPopView = BaseClass("UIAttackCityS0RewardPopView", UIBaseView)
local cityItem = require("UI.LWCityAttackS0.RewardPop.Component.cityItemComponent")
local rewardItem = require("UI.LWCityAttackS0.RewardPop.Component.rewardItemComponent")
local base = UIBaseView
local Localization = CS.GameEntry.Localization

function UIAttackCityS0RewardPopView:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
  self:InitUI()
end

function UIAttackCityS0RewardPopView:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UIAttackCityS0RewardPopView:ComponentDefine()
  self.viewSkin = self:AddComponent(UIViewSkinBridge, "")
  self.btnPanel = self.viewSkin:AddComponent(self, UIButton, 1)
  self.btnPanel:SetOnClick(function()
    self:OnBtnPanelClick()
  end)
  self.textTitle = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 2)
  self.btnClose = self.viewSkin:AddComponent(self, UIButton, 3)
  self.btnClose:SetOnClick(function()
    self:OnBtnCloseClick()
  end)
  self.textTitleInside = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 4)
  self.textDesc = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 5)
  self.cityScroll = self:AddComponent(UIScrollView, "root/cityScroll")
  self.cityContent = self.viewSkin:AddComponent(self, UIBaseComponent, 7)
  self.rewardScroll = self.viewSkin:AddComponent(self, UIScrollView, 8)
  self.rewardContent = self.viewSkin:AddComponent(self, UIBaseContainer, 9)
  self.cityScroll:SetOnItemMoveIn(function(itemObj, index)
    self:OnCreateCell(itemObj, index)
  end)
  self.cityScroll:SetOnItemMoveOut(function(itemObj, index)
    self:OnDeleteCell(itemObj, index)
  end)
  self.rewardScroll:SetOnItemMoveIn(function(itemObj, index)
    self:OnRewardCreateCell(itemObj, index)
  end)
  self.rewardScroll:SetOnItemMoveOut(function(itemObj, index)
    self:OnRewardDeleteCell(itemObj, index)
  end)
end

function UIAttackCityS0RewardPopView:ComponentDestroy()
  self.viewSkin = nil
  self.btnPanel = nil
  self.textTitle = nil
  self.btnClose = nil
  self.textTitleInside = nil
  self.textDesc = nil
  self.cityScroll = nil
  self.cityContent = nil
  self.rewardScroll = nil
  self.rewardContent = nil
end

function UIAttackCityS0RewardPopView:DataDefine()
  self.cityRewardList = nil
  self.cells = {}
  self.curIndex = 1
end

function UIAttackCityS0RewardPopView:DataDestroy()
  self:ClearScroll()
  self.cityRewardList = nil
  self.cells = nil
  self.curIndex = nil
  self.rewardList = nil
end

function UIAttackCityS0RewardPopView:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.AttackCityS0RewardPopSelect, self.UpdateRewardList)
end

function UIAttackCityS0RewardPopView:OnRemoveListener()
  self:RemoveUIListener(EventId.AttackCityS0RewardPopSelect, self.UpdateRewardList)
  base.OnRemoveListener(self)
end

function UIAttackCityS0RewardPopView:OnBtnPanelClick()
  self.ctrl:CloseSelf()
end

function UIAttackCityS0RewardPopView:OnBtnCloseClick()
  self.ctrl:CloseSelf()
end

function UIAttackCityS0RewardPopView:InitUI()
  self.cityRewardList = DataCenter.AttackCityS0ConfigManager:GetCityRewardConfigList()
  if self.cityRewardList and #self.cityRewardList > 0 then
    self:ShowScroll()
  end
  self:UpdateRewardList(self.curIndex)
end

function UIAttackCityS0RewardPopView:OnCreateCell(itemObj, index)
  itemObj.name = tostring(index)
  local item = self.cityScroll:AddComponent(cityItem, itemObj)
  item:ReInit(self.cityRewardList[index], index, self.curIndex)
  self.cells[index] = item
end

function UIAttackCityS0RewardPopView:OnDeleteCell(itemObj, index)
  self.cityScroll:RemoveComponent(itemObj.name, cityItem)
end

function UIAttackCityS0RewardPopView:ClearScroll()
  self.cityScroll:ClearCells()
  self.cityScroll:RemoveComponents(cityItem)
end

function UIAttackCityS0RewardPopView:ShowScroll()
  self:ClearScroll()
  local count = #self.cityRewardList
  self.cityScroll:SetTotalCount(count)
  if 0 < count then
    self.cityScroll:RefillCells()
  end
end

function UIAttackCityS0RewardPopView:UpdateRewardList(index)
  self.curIndex = index
  local personalReward = self.cityRewardList[index].personalReward
  local allianceReward = self.cityRewardList[index].allianceReward
  local reward = {personalReward, allianceReward}
  self.rewardList = reward
  self:ShowRewardScroll()
end

function UIAttackCityS0RewardPopView:OnRewardCreateCell(itemObj, index)
  itemObj.name = tostring(index)
  local item = self.rewardScroll:AddComponent(rewardItem, itemObj)
  item:ReInit(self.rewardList[index], index)
end

function UIAttackCityS0RewardPopView:OnRewardDeleteCell(itemObj, index)
  self.rewardScroll:RemoveComponent(itemObj.name, rewardItem)
end

function UIAttackCityS0RewardPopView:ClearRewardScroll()
  self.rewardScroll:ClearCells()
  self.rewardScroll:RemoveComponents(rewardItem)
end

function UIAttackCityS0RewardPopView:ShowRewardScroll()
  self:ClearRewardScroll()
  local count = #self.rewardList
  self.rewardScroll:SetTotalCount(count)
  if 0 < count then
    self.rewardScroll:RefillCells()
  end
end

return UIAttackCityS0RewardPopView
