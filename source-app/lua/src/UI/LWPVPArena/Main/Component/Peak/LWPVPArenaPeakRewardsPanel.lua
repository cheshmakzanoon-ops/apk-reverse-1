local LWPVPArenaPeakRewardsPanel = BaseClass("LWPVPArenaPeakRewardsPanel", UIBaseContainer)
local base = UIBaseContainer
local UIRewardsItem = require("UI.LWPVPArena.Main.Component.Peak.LWPVPArenaPeakRewardsItem")
local Localization = CS.GameEntry.Localization
local compBook = {
  {
    path = "top/txtTitle",
    name = "txtTitle",
    type = UIText
  },
  {
    path = "top/btnClose",
    name = "btnClose",
    type = UIButton
  },
  {
    path = "txtTips",
    name = "txtTips",
    type = UIText
  },
  {
    path = "scrollRewards",
    name = "scrollRewards",
    type = UIDynamicVerticleScrollRectEx
  },
  {
    path = "black",
    name = "btnBlack",
    type = UIButton
  }
}

function LWPVPArenaPeakRewardsPanel:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
end

function LWPVPArenaPeakRewardsPanel:OnDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
  self.itemDatas = nil
  self.rewardItemMap = nil
end

function LWPVPArenaPeakRewardsPanel:ComponentDefine()
  self:DefineCompsByBook(compBook)
  self.txtTitle:SetText(Localization:GetString("130065"))
  self.txtTips:SetText(Localization:GetString("801119"))
  self.btnClose:SetOnClick(function()
    if self.holder then
      self.holder:SetActive(false)
    end
  end)
  self.btnBlack:SetOnClick(function()
    if self.holder then
      self.holder:SetActive(false)
    end
  end)
  self.itemIncNo = 1
  self.rewardItemMap = {}
  self.scrollRewards:AddInstantiateItemListener(function(itemObj, prefabIdx)
    itemObj.name = "rewardItem_" .. self.itemIncNo
    self.itemIncNo = self.itemIncNo + 1
    local rewardItem = self:AddComponent(UIRewardsItem, itemObj)
    self.rewardItemMap[itemObj] = rewardItem
  end)
  self.scrollRewards:AddDisplayItemListener(function(itemObj, dataIdx)
    local rewardItem = self.rewardItemMap[itemObj]
    if rewardItem then
      rewardItem:Refresh(self.itemDatas[dataIdx + 1])
    end
  end)
end

function LWPVPArenaPeakRewardsPanel:ComponentDestroy()
  self:ClearCompsByBook(compBook)
end

function LWPVPArenaPeakRewardsPanel:Refresh(rewardsData)
  self.itemDatas = {}
  local prefabIdxs = {}
  for i, v in ipairs(rewardsData.rankRewards) do
    local rank = v.minRank == v.maxRank and tostring(v.minRank) or v.minRank .. "-" .. v.maxRank
    local rewards = DataCenter.RewardManager:ReturnRewardParamForMessage(v.reward) or {}
    table.insert(self.itemDatas, {rank = rank, rewards = rewards})
    if i <= 3 then
      table.insert(prefabIdxs, i - 1)
    else
      table.insert(prefabIdxs, 3)
    end
  end
  self.scrollRewards:SetDatas(prefabIdxs)
end

return LWPVPArenaPeakRewardsPanel
