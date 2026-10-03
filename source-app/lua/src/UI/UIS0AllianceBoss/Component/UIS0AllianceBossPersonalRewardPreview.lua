local base = UIBaseContainer
local UIS0AllianceBossPersonalRewardPreview = BaseClass("UIS0AllianceBossPersonalRewardPreview", UIBaseContainer)
local Localization = CS.GameEntry.Localization
local UIS0AllianceBossPersonalGetRewardItem = require("UI.UIS0AllianceBoss.Component.UIS0AllianceBossPersonalGetRewardItem")

function UIS0AllianceBossPersonalRewardPreview:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function UIS0AllianceBossPersonalRewardPreview:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UIS0AllianceBossPersonalRewardPreview:ComponentDefine()
  self.viewSkin = self:AddComponent(UIViewSkinBridge, "")
  self.scrollView = self.viewSkin:AddComponent(self, UIScrollView, 1)
  self.compOneself = self.viewSkin:AddComponent(self, UIS0AllianceBossPersonalGetRewardItem, 2)
  self.scrollView:SetOnItemMoveIn(function(itemObj, index)
    self:OnItemMoveIn(itemObj, index)
  end)
  self.scrollView:SetOnItemMoveOut(function(itemObj, index)
    self:OnItemMoveOut(itemObj, index)
  end)
end

function UIS0AllianceBossPersonalRewardPreview:ComponentDestroy()
  self:ClearScroll()
  self.viewSkin = nil
  self.scrollView = nil
  self.compOneself = nil
end

function UIS0AllianceBossPersonalRewardPreview:DataDefine()
end

function UIS0AllianceBossPersonalRewardPreview:DataDestroy()
end

function UIS0AllianceBossPersonalRewardPreview:OnAddListener()
  base.OnAddListener(self)
end

function UIS0AllianceBossPersonalRewardPreview:OnRemoveListener()
  base.OnRemoveListener(self)
end

function UIS0AllianceBossPersonalRewardPreview:RefreshView(bossTemp, viewCurChallenge)
  local personalMaxDmg = 0
  local personalDmgData
  local curDmg = 0
  self.star = 0
  if bossTemp then
    personalMaxDmg = bossTemp.personalMaxDmg
    personalDmgData = bossTemp.personalDmg
    self.personalDmg = personalDmgData
    self.personalReward = bossTemp.personalReward
    if self.personalDmg and self.personalReward then
      local count = #self.personalDmg
      if viewCurChallenge then
        self.bossData = DataCenter.S0AllianceBossDataManager.bossData
        if self.bossData then
          curDmg = self.bossData.playerDamage
        end
        local star = 0
        if 0 < curDmg then
          star = 1
        end
        for i, v in ipairs(self.personalDmg) do
          if v < curDmg and v ~= -1 then
            star = i + 1
          end
        end
        self.star = star
      end
      if 0 < count then
        self:ClearScroll()
        self.scrollView:SetTotalCount(count)
        self.scrollView:RefillCells()
      end
    end
    if curDmg == 0 then
      self.compOneself:SetActive(false)
    else
      self.compOneself:SetActive(true)
      local minDmg = self.star == 1 and 1 or self.personalDmg[self.star - 1]
      local dmg = self.personalDmg[self.star]
      local reward = self.personalReward[self.star]
      self.compOneself:RefreshItem(true, minDmg, dmg, reward)
    end
  end
end

function UIS0AllianceBossPersonalRewardPreview:OnItemMoveIn(itemObj, index)
  itemObj.name = tostring(index)
  local cellItem = self.scrollView:AddComponent(UIS0AllianceBossPersonalGetRewardItem, itemObj)
  if cellItem ~= nil and self.personalDmg and self.personalReward then
    local minDmg = index == 1 and 1 or self.personalDmg[index - 1]
    local dmg = self.personalDmg[index]
    local reward = self.personalReward[index]
    cellItem:RefreshItem(self.star == index, minDmg, dmg, reward)
  end
end

function UIS0AllianceBossPersonalRewardPreview:OnItemMoveOut(itemObj, index)
  self.scrollView:RemoveComponent(itemObj.name, UIS0AllianceBossPersonalGetRewardItem)
end

function UIS0AllianceBossPersonalRewardPreview:ClearScroll()
  self.scrollView:ClearCells()
  self.scrollView:RemoveComponents(UIS0AllianceBossPersonalGetRewardItem)
end

return UIS0AllianceBossPersonalRewardPreview
