local base = UIBaseContainer
local UIS0AllianceBossPersonalGetRewardItem = BaseClass("UIS0AllianceBossPersonalGetRewardItem", UIBaseContainer)
local Localization = CS.GameEntry.Localization

function UIS0AllianceBossPersonalGetRewardItem:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function UIS0AllianceBossPersonalGetRewardItem:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UIS0AllianceBossPersonalGetRewardItem:ComponentDefine()
  self.viewSkin = self:AddComponent(UIViewSkinBridge, "")
  self.compImgBgGreen = self.viewSkin:AddComponent(self, UIBaseContainer, 1)
  self.textPointNum = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 2)
  self.scrollView = self.viewSkin:AddComponent(self, UIScrollView, 3)
  self.scrollView:SetOnItemMoveIn(function(itemObj, index)
    self:OnRewardItemMoveIn(itemObj, index)
  end)
  self.scrollView:SetOnItemMoveOut(function(itemObj, index)
    self:OnRewardItemMoveOut(itemObj, index)
  end)
end

function UIS0AllianceBossPersonalGetRewardItem:ComponentDestroy()
  self:ClearScroll()
  self.viewSkin = nil
  self.compImgBgGreen = nil
  self.textPointNum = nil
  self.scrollView = nil
end

function UIS0AllianceBossPersonalGetRewardItem:DataDefine()
end

function UIS0AllianceBossPersonalGetRewardItem:DataDestroy()
end

function UIS0AllianceBossPersonalGetRewardItem:OnAddListener()
  base.OnAddListener(self)
end

function UIS0AllianceBossPersonalGetRewardItem:OnRemoveListener()
  base.OnRemoveListener(self)
end

function UIS0AllianceBossPersonalGetRewardItem:RefreshItem(isSelf, minDmg, dmg, rewardId)
  if minDmg and dmg and rewardId then
    if rewardId then
      local rewardList = DataCenter.RewardTemplateManager:GetList(rewardId)
      if rewardList and 0 < #rewardList then
        self.rewardList = rewardList
        self:ClearScroll()
        self.scrollView:SetTotalCount(#rewardList)
        self.scrollView:RefillCells()
      end
    end
    local minDmgStr = string.GetFormattedStr2(minDmg)
    if dmg == -1 then
      self.textPointNum:SetText(minDmgStr .. "+")
    else
      local dmgStr = string.GetFormattedStr2(dmg)
      self.textPointNum:SetText(minDmgStr .. "-" .. dmgStr)
    end
  end
  self.compImgBgGreen:SetActive(isSelf)
end

function UIS0AllianceBossPersonalGetRewardItem:OnRewardItemMoveIn(itemObj, index)
  itemObj.name = tostring(index)
  local cellItem = self.scrollView:AddComponent(UICommonResItem, itemObj)
  if cellItem ~= nil then
    local reward = self.rewardList[index]
    if reward then
      cellItem:ParseInfo(reward)
    end
  end
end

function UIS0AllianceBossPersonalGetRewardItem:OnRewardItemMoveOut(itemObj, index)
  self.scrollView:RemoveComponent(itemObj.name, UICommonResItem)
end

function UIS0AllianceBossPersonalGetRewardItem:ClearScroll()
  self.scrollView:ClearCells()
  self.scrollView:RemoveComponents(UICommonResItem)
end

return UIS0AllianceBossPersonalGetRewardItem
