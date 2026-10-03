local base = UIBaseContainer
local UIS0AllianceBossAllianceRewardPreview = BaseClass("UIS0AllianceBossAllianceRewardPreview", UIBaseContainer)
local UIS0AllianceBossSliderAlliance = require("UI.UIS0AllianceBoss.Component.UIS0AllianceBossSliderAlliance")
local UIS0AllianceBossAllianceGetRewardItem = require("UI.UIS0AllianceBoss.Component.UIS0AllianceBossAllianceGetRewardItem")
local UIS0AllianceBossRewardItem = require("UI.UIS0AllianceBoss.Component.UIS0AllianceBossRewardItem")
local Localization = CS.GameEntry.Localization
local ITEM_HEIGHT = 137
local TOP_OFFSET = 4
local SPACING = 12
local VIEWPORT_HEIGHT = ITEM_HEIGHT * 3

function UIS0AllianceBossAllianceRewardPreview:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
  self:InitView()
end

function UIS0AllianceBossAllianceRewardPreview:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UIS0AllianceBossAllianceRewardPreview:ComponentDefine()
  self.viewSkin = self:AddComponent(UIViewSkinBridge, "")
  self.btnInfo = self.viewSkin:AddComponent(self, UIButton, 1)
  self.btnInfo:SetOnClick(function()
    self:OnBtnInfoClick()
  end)
  self.textTitle01 = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 2)
  self.compS0AllianceBossSliderAlliance = self.viewSkin:AddComponent(self, UIS0AllianceBossSliderAlliance, 3)
  self.textTitle02 = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 4)
  self.scrollViewReward = self.viewSkin:AddComponent(self, UIScrollView, 5)
  self.compContentReward = self.viewSkin:AddComponent(self, UIBaseContainer, 6)
  self.textTitle03 = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 7)
  self.compContentGetReward = self.viewSkin:AddComponent(self, UIBaseContainer, 8)
  self.scrollViewGetReward = self.viewSkin:AddComponent(self, UIScrollView, 9)
  self.scrollViewReward:SetOnItemMoveIn(function(itemObj, index)
    self:OnRewardItemMoveIn(itemObj, index)
  end)
  self.scrollViewReward:SetOnItemMoveOut(function(itemObj, index)
    self:OnRewardItemMoveOut(itemObj, index)
  end)
  self.scrollViewGetReward:SetOnItemMoveIn(function(itemObj, index)
    self:OnGetRewardItemMoveIn(itemObj, index)
  end)
  self.scrollViewGetReward:SetOnItemMoveOut(function(itemObj, index)
    self:OnGetRewardItemMoveOut(itemObj, index)
  end)
end

function UIS0AllianceBossAllianceRewardPreview:ComponentDestroy()
  self:ClearGetRewardScroll()
  self:ClearRewardScroll()
  self.viewSkin = nil
  self.btnInfo = nil
  self.textTitle01 = nil
  self.compS0AllianceBossSliderAlliance = nil
  self.textTitle02 = nil
  self.scrollViewReward = nil
  self.compContentReward = nil
  self.textTitle03 = nil
  self.compContentGetReward = nil
  self.scrollViewGetReward = nil
end

function UIS0AllianceBossAllianceRewardPreview:DataDefine()
  self.star = nil
  self.alliance_bonus = nil
  self.allianceDmg = nil
  self.allianceReward = nil
  self.rewardList = nil
  self.bossData = nil
  self.curDifficulty = nil
  self.curBonus = nil
end

function UIS0AllianceBossAllianceRewardPreview:DataDestroy()
  self.star = nil
  self.alliance_bonus = nil
  self.allianceDmg = nil
  self.allianceReward = nil
  self.rewardList = nil
  self.bossData = nil
  self.curDifficulty = nil
  self.curBonus = nil
end

function UIS0AllianceBossAllianceRewardPreview:OnAddListener()
  base.OnAddListener(self)
end

function UIS0AllianceBossAllianceRewardPreview:OnRemoveListener()
  base.OnRemoveListener(self)
end

function UIS0AllianceBossAllianceRewardPreview:InitView()
  self.textTitle01:SetLocalText("s0_alliance_boss_alliance_total_damage")
  self.curDifficulty = DataCenter.S0AllianceBossDataManager.curDifficulty
  self.textTitle02:SetLocalText("s0_alliance_boss_current_reward")
  self.textTitle03:SetLocalText("s0_alliance_boss_reward_preview")
end

function UIS0AllianceBossAllianceRewardPreview:RefreshView(bossTemp, viewCurChallenge)
  local allianceMaxDmg = 0
  local allianceDmgData
  local curDmg = 0
  self.viewCurChallenge = viewCurChallenge
  if bossTemp then
    allianceMaxDmg = bossTemp.allianceMaxDmg
    allianceDmgData = bossTemp.allianceDmg
    local allianceReward = bossTemp.allianceReward
    self.alliance_bonus = bossTemp.alliance_bonus
    self.allianceDmg = allianceDmgData
    self.allianceReward = allianceReward
    local star = 0
    if viewCurChallenge then
      self.bossData = DataCenter.S0AllianceBossDataManager.bossData
      if self.bossData then
        curDmg = self.bossData.totalDamage
        if curDmg == 0 then
          star = -1
        elseif self.allianceDmg then
          star = #self.allianceDmg - 1
          for i, v in ipairs(self.allianceDmg) do
            if v > curDmg then
              star = i - 1
              break
            end
          end
        end
      end
    end
    self.star = star
    if self.alliance_bonus and self.allianceDmg and self.allianceReward then
      local count = #self.allianceDmg
      if 0 < count then
        self:ClearGetRewardScroll()
        self.scrollViewGetReward:SetTotalCount(count)
        self.scrollViewGetReward:RefillCells()
        local index = math.max(star + 1, 1)
        self.scrollViewGetReward:ScrollToCell(index, 1000)
      end
      if star <= 0 then
        self.curBonus = 1
      else
        self.curBonus = self.alliance_bonus[star + 1]
      end
    end
    if allianceReward then
      local index = 0
      if viewCurChallenge and star and 0 < star then
        index = star
      end
      local result = {}
      local curReward = allianceReward[index + 1]
      if curReward then
        local rewardList = DataCenter.RewardTemplateManager:GetList(curReward)
        if rewardList then
          for _, reward in ipairs(rewardList) do
            result[#result + 1] = reward
          end
        end
      end
      self.rewardList = result
      local count = #result
      if 0 < count then
        self:ClearRewardScroll()
        self.scrollViewReward:SetTotalCount(count)
        self.scrollViewReward:RefillCells()
      end
    end
  end
  self.compS0AllianceBossSliderAlliance:RefreshView(curDmg, allianceMaxDmg, allianceDmgData, nil, true)
end

function UIS0AllianceBossAllianceRewardPreview:OnRewardItemMoveIn(itemObj, index)
  itemObj.name = tostring(index)
  local cellItem = self.scrollViewReward:AddComponent(UIS0AllianceBossRewardItem, itemObj)
  if cellItem ~= nil then
    local rewardId = self.rewardList[index]
    if rewardId then
      cellItem:RefreshItem(rewardId, self.curBonus)
    end
  end
end

function UIS0AllianceBossAllianceRewardPreview:OnRewardItemMoveOut(itemObj, index)
  self.scrollViewReward:RemoveComponent(itemObj.name, UIS0AllianceBossRewardItem)
end

function UIS0AllianceBossAllianceRewardPreview:ClearRewardScroll()
  self.scrollViewReward:ClearCells()
  self.scrollViewReward:RemoveComponents(UIS0AllianceBossRewardItem)
end

function UIS0AllianceBossAllianceRewardPreview:OnGetRewardItemMoveIn(itemObj, index)
  itemObj.name = tostring(index)
  local cellItem = self.scrollViewGetReward:AddComponent(UIS0AllianceBossAllianceGetRewardItem, itemObj)
  if cellItem ~= nil then
    if table.IsNullOrEmpty(self.alliance_bonus) or table.IsNullOrEmpty(self.allianceDmg) or table.IsNullOrEmpty(self.allianceReward) then
      return
    end
    local minDmg = index == 1 and 1 or self.allianceDmg[index - 1] or 0
    local dmg = self.allianceDmg[index] or 0
    local bonus = self.alliance_bonus[index] or 0
    local reward = self.allianceReward[index] or 0
    local isSelf = self.viewCurChallenge and self.star + 1 == index
    cellItem:RefreshItem(isSelf, index, minDmg, dmg, bonus, reward)
  end
end

function UIS0AllianceBossAllianceRewardPreview:OnGetRewardItemMoveOut(itemObj, index)
  self.scrollViewGetReward:RemoveComponent(itemObj.name, UIS0AllianceBossAllianceGetRewardItem)
end

function UIS0AllianceBossAllianceRewardPreview:ClearGetRewardScroll()
  self.scrollViewGetReward:ClearCells()
  self.scrollViewGetReward:RemoveComponents(UIS0AllianceBossAllianceGetRewardItem)
end

function UIS0AllianceBossAllianceRewardPreview:OnBtnInfoClick()
  if self.context == nil then
    self.context = Localization:GetString("s0_alliance_boss_alliance_damage_tips")
  end
  UIUtil.ShowBubbleTips(self.context, self.btnInfo.transform.position, 0, 20, 0, nil, nil, {reversal = true})
end

return UIS0AllianceBossAllianceRewardPreview
