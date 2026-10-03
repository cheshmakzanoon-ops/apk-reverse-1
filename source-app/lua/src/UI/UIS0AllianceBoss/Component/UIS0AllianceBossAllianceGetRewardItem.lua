local base = UIBaseContainer
local UIS0AllianceBossAllianceGetRewardItem = BaseClass("UIS0AllianceBossAllianceGetRewardItem", UIBaseContainer)

function UIS0AllianceBossAllianceGetRewardItem:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
  self:InitView()
end

function UIS0AllianceBossAllianceGetRewardItem:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UIS0AllianceBossAllianceGetRewardItem:ComponentDefine()
  self.viewSkin = self:AddComponent(UIViewSkinBridge, "")
  self.compImgBgGreen = self.viewSkin:AddComponent(self, UIBaseContainer, 1)
  self.scrollView = self.viewSkin:AddComponent(self, UIScrollView, 2)
  self.compImgStar02 = self.viewSkin:AddComponent(self, UIBaseContainer, 3)
  self.compImgStar03 = self.viewSkin:AddComponent(self, UIBaseContainer, 4)
  self.compImgStar04 = self.viewSkin:AddComponent(self, UIBaseContainer, 5)
  self.compImgStar05 = self.viewSkin:AddComponent(self, UIBaseContainer, 6)
  self.textPointNum = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 7)
  self.textMultipleNum = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 8)
  self.compMultiple = self.viewSkin:AddComponent(self, UIBaseContainer, 9)
  self.compImgStar = self.viewSkin:AddComponent(self, UIBaseContainer, 10)
  self.compImgStar01 = self.viewSkin:AddComponent(self, UIBaseContainer, 11)
  self.scrollView:SetOnItemMoveIn(function(itemObj, index)
    self:OnRewardItemMoveIn(itemObj, index)
  end)
  self.scrollView:SetOnItemMoveOut(function(itemObj, index)
    self:OnRewardItemMoveOut(itemObj, index)
  end)
end

function UIS0AllianceBossAllianceGetRewardItem:ComponentDestroy()
  self:ClearScroll()
  self.viewSkin = nil
  self.compImgBgGreen = nil
  self.scrollView = nil
  self.compImgStar02 = nil
  self.compImgStar03 = nil
  self.compImgStar04 = nil
  self.compImgStar05 = nil
  self.textPointNum = nil
  self.textMultipleNum = nil
  self.compMultiple = nil
  self.compImgStar = nil
  self.compImgStar01 = nil
end

function UIS0AllianceBossAllianceGetRewardItem:DataDefine()
  self.starList = nil
end

function UIS0AllianceBossAllianceGetRewardItem:DataDestroy()
  self.starList = nil
end

function UIS0AllianceBossAllianceGetRewardItem:OnAddListener()
  base.OnAddListener(self)
end

function UIS0AllianceBossAllianceGetRewardItem:OnRemoveListener()
  base.OnRemoveListener(self)
end

function UIS0AllianceBossAllianceGetRewardItem:InitView()
  self.starList = {
    self.compImgStar01,
    self.compImgStar02,
    self.compImgStar03,
    self.compImgStar04,
    self.compImgStar05
  }
end

function UIS0AllianceBossAllianceGetRewardItem:RefreshItem(isSelf, star, minDmg, dmg, bonus, rewardId)
  if star and minDmg and dmg and bonus and rewardId then
    self.compImgStar:SetActive(star == 1)
    for i, v in ipairs(self.starList) do
      v:SetActive(i < star)
    end
    local minDmgStr = string.GetFormattedStr2(minDmg)
    if dmg == -1 then
      self.textPointNum:SetText(minDmgStr .. "+")
    else
      local dmgStr = string.GetFormattedStr2(dmg)
      self.textPointNum:SetText(minDmgStr .. "-" .. dmgStr)
    end
    if bonus == 1 then
      self.compMultiple:SetActive(false)
    else
      self.compMultiple:SetActive(true)
      self.textMultipleNum:SetText("x" .. bonus)
    end
    self.compImgBgGreen:SetActive(isSelf)
    if rewardId then
      local rewardList = DataCenter.RewardTemplateManager:GetList(rewardId)
      if rewardList and 0 < #rewardList then
        self.rewardList = rewardList
        self:ClearScroll()
        self.scrollView:SetTotalCount(#rewardList)
        self.scrollView:RefillCells()
      end
    end
  end
  self.compImgBgGreen:SetActive(isSelf)
end

function UIS0AllianceBossAllianceGetRewardItem:OnRewardItemMoveIn(itemObj, index)
  itemObj.name = tostring(index)
  local cellItem = self.scrollView:AddComponent(UICommonResItem, itemObj)
  if cellItem ~= nil then
    local reward = self.rewardList[index]
    if reward then
      cellItem:ParseInfo(reward)
    end
  end
end

function UIS0AllianceBossAllianceGetRewardItem:OnRewardItemMoveOut(itemObj, index)
  self.scrollView:RemoveComponent(itemObj.name, UICommonResItem)
end

function UIS0AllianceBossAllianceGetRewardItem:ClearScroll()
  self.scrollView:ClearCells()
  self.scrollView:RemoveComponents(UICommonResItem)
end

return UIS0AllianceBossAllianceGetRewardItem
