local LWAlDonateRankContent = BaseClass("LWAlDonateRankContent", UIBaseContainer)
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization
local RankContent = require("UI.UILWAlliance.UILWAllianceRank.Component.LWAlRankContent")
local tab_path = "typeSelect/typeTab%d"

function LWAlDonateRankContent:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
  self:ReInit()
end

function LWAlDonateRankContent:OnDestroy()
  self:ComponentDestroy()
  self:DataDestroy()
  base.OnDestroy(self)
end

function LWAlDonateRankContent:ComponentDefine()
  self.tabs = {}
  for i = 1, 2 do
    local tab = {}
    local rootPath = string.format(tab_path, i)
    tab.tab = self:AddComponent(UIButton, rootPath)
    tab.tab_select = tab.tab:AddComponent(UIBaseContainer, "select")
    tab.tab_name = tab.tab:AddComponent(UIText, "name")
    local index = i
    tab.tab:SetOnClick(function()
      self:DoSelectTabIndex(index)
    end)
    self.tabs[i] = tab
  end
  self.rankContent = self:AddComponent(RankContent, "rankContent")
  self.rewardBtn = self:AddComponent(UIButton, "RewardBtn")
  self.rewardBtn:SetOnClick(function()
    UIManager:GetInstance():OpenWindow(UIWindowNames.UILWAlRankRewardPanel, {anim = true})
  end)
  self.rewardBtnText = self:AddComponent(UIText, "RewardBtn/RewardBtnText")
  self.rewardBtnText:SetLocalText(130065)
  self.donateBtn = self:AddComponent(UIButton, "DonateBtn")
  self.donateBtn:SetOnClick(function()
    GoToUtil.GotoOpenView(UIWindowNames.UIAllianceScience, {
      anim = true,
      hideTop = true,
      UIMainAnim = UIMainAnimType.LeftRightBottomHide
    }, {autoOpenRecScience = true})
  end)
  self.donateText = self:AddComponent(UIText, "DonateBtn/DonateText")
  self.donateText:SetLocalText(390448)
end

function LWAlDonateRankContent:ComponentDestroy()
  for i = 1, #self.tabs do
    self.tabs[i] = nil
  end
  self.tabs = nil
  self.rankContent = nil
  self.rewardBtn = nil
  self.donateBtn = nil
end

function LWAlDonateRankContent:DataDefine()
  self.selectIndex = 1
  self.showTabData = {
    AlRankType.DonateDaily,
    AlRankType.DonateWeek
  }
end

function LWAlDonateRankContent:DataDestroy()
end

function LWAlDonateRankContent:ReInit()
  for i = 1, #self.tabs do
    if self.showTabData[i] ~= nil then
      self.tabs[i].tab:SetActive(true)
      self.tabs[i].tab_name:SetText(self:GetTabNameByType(self.showTabData[i]))
    else
      self.tabs[i].tab:SetActive(false)
    end
  end
end

function LWAlDonateRankContent:DoSelectTabIndex(index)
  if index == self.selectIndex then
    return
  end
  self.selectIndex = index
  self:RefreshBar()
  self:RefreshContent()
end

function LWAlDonateRankContent:GetTabNameByType(type)
  local name = ""
  if type == AlRankType.DonateDaily then
    name = Localization:GetString("390263")
  elseif type == AlRankType.DonateWeek then
    name = Localization:GetString("390207")
  end
  return name
end

function LWAlDonateRankContent:SetData()
  self:RefreshView()
end

function LWAlDonateRankContent:RefreshBar()
  for i = 1, #self.tabs do
    if self.showTabData[i] ~= nil then
      self.tabs[i].tab_select:SetActive(i == self.selectIndex)
    end
  end
end

function LWAlDonateRankContent:RefreshContent()
  local curType = self.showTabData[self.selectIndex]
  if curType == nil then
    return
  end
  self.rankContent:SetData(curType)
end

function LWAlDonateRankContent:RefreshView()
  self:RefreshBar()
  self:RefreshContent()
end

return LWAlDonateRankContent
