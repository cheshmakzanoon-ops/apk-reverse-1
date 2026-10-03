local base = UIBaseContainer
local AllianceMilitaryRewardPreviewItem = BaseClass("AllianceMilitaryRewardPreviewItem", UIBaseContainer)
local Localization = CS.GameEntry.Localization
local RewardItem = require("UI/LWAllianceMilitaryPay/RewardPreview/Component/MilitaryPreviewReward")
local RewardUtil = require("Util.RewardUtil")

function AllianceMilitaryRewardPreviewItem:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function AllianceMilitaryRewardPreviewItem:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function AllianceMilitaryRewardPreviewItem:ComponentDefine()
  self.imgBox = self:AddComponent(UIImage, "imgBox")
  self.txtName = self:AddComponent(UITextMeshProUGUIEx, "txtName")
  self.scrollView = self:AddComponent(UIScrollView, "rewardScrollview")
  self.bg = self:AddComponent(UIImage, "bg2")
  self.scrollView:SetOnItemMoveIn(function(itemObj, index)
    self:OnItemMoveIn(itemObj, index)
  end)
  self.scrollView:SetOnItemMoveOut(function(itemObj, index)
    self:OnItemMoveOut(itemObj, index)
  end)
end

function AllianceMilitaryRewardPreviewItem:ComponentDestroy()
  self:ClearScroll()
  self.imgBox = nil
  self.txtName = nil
  self.scrollView = nil
  self.rewardList = nil
end

function AllianceMilitaryRewardPreviewItem:DataDefine()
end

function AllianceMilitaryRewardPreviewItem:DataDestroy()
end

function AllianceMilitaryRewardPreviewItem:OnAddListener()
  base.OnAddListener(self)
end

function AllianceMilitaryRewardPreviewItem:OnRemoveListener()
  base.OnRemoveListener(self)
end

function AllianceMilitaryRewardPreviewItem:ReInit(template, level)
  local color = template.color
  self.imgBox:LoadSprite(string.format(LoadPath.LWAllianceMilitaryPayIconPath, AllianceSalaryRewardImage[color]))
  self.bg:LoadSprite(string.format(LoadPath.LWAllianceMilitaryPayIconPath, AllianceSalaryRewardBg[color]))
  self.txtName:SetLocalText(template.name, level)
  self.rewardId = template.rewardIds[level]
  if not self.rewardId then
    return
  end
  self.rewardList = RewardUtil.GetRewardItem(self.rewardId)
  self:RefreshScrollView()
end

function AllianceMilitaryRewardPreviewItem:RefreshScrollView()
  if #self.rewardList > 0 then
    self.scrollView:SetTotalCount(#self.rewardList)
    self.scrollView:RefillCells()
  end
end

function AllianceMilitaryRewardPreviewItem:OnItemMoveIn(itemObj, index)
  itemObj.name = tostring(index)
  local cellItem = self.scrollView:AddComponent(RewardItem, itemObj)
  if cellItem ~= nil then
    cellItem:ReInit(self.rewardList[index], self.curLevel)
  end
end

function AllianceMilitaryRewardPreviewItem:OnItemMoveOut(itemObj, index)
  self.scrollView:RemoveComponent(itemObj.name, RewardItem)
end

function AllianceMilitaryRewardPreviewItem:ClearScroll()
  self.scrollView:ClearCells()
  self.scrollView:RemoveComponents(RewardItem)
end

return AllianceMilitaryRewardPreviewItem
