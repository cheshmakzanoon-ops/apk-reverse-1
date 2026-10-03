local LWPVPArenaPeakRewardsItem = BaseClass("LWPVPArenaPeakRewardsItem", UIBaseContainer)
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization
local compBook = {
  {
    path = "txtRank",
    name = "txtRank",
    type = UIText
  },
  {
    path = "items/Item1",
    name = "item1",
    type = UICommonResItem
  },
  {
    path = "items/Item2",
    name = "item2",
    type = UICommonResItem
  },
  {
    path = "items/Item3",
    name = "item3",
    type = UICommonResItem
  },
  {
    path = "items/Item4",
    name = "item4",
    type = UICommonResItem
  },
  {
    path = "items/Item5",
    name = "item5",
    type = UICommonResItem
  },
  {
    path = "items/Item6",
    name = "item6",
    type = UICommonResItem
  }
}

function LWPVPArenaPeakRewardsItem:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
end

function LWPVPArenaPeakRewardsItem:OnDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function LWPVPArenaPeakRewardsItem:ComponentDefine()
  self:DefineCompsByBook(compBook)
end

function LWPVPArenaPeakRewardsItem:ComponentDestroy()
  self:ClearCompsByBook(compBook)
end

function LWPVPArenaPeakRewardsItem:Refresh(data)
  self.txtRank:SetText(data.rank)
  for i = 1, 6 do
    local item = self["item" .. i]
    local reward = data.rewards[i]
    if reward then
      item:SetActive(true)
      item:ReInit(reward)
    else
      item:SetActive(false)
    end
  end
end

return LWPVPArenaPeakRewardsItem
