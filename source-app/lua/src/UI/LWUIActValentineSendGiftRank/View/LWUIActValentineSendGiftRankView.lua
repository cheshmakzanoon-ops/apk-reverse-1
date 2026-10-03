local ValentineSendGiftRankView = BaseClass("ValentineSendGiftRankView", UIBaseView)
local LWUIActValentineRankContent = require("UI.LWUIActValentineSendGiftRank.Component.LWUIActValentineRankContent")
local ULWUIActValentineRankRewardContent = require("UI.LWUIActValentineSendGiftRank.Component.ULWUIActValentineRankRewardContent")
local base = UIBaseView
local Localization = CS.GameEntry.Localization
local reward_content_path = "RankRewardContent"
local rank_content_path = "RankContent"
local common_bg_path = "Common_bg"
ValentineSendGiftRankView.TabType = {RankView = 1, Reward = 2}

function ValentineSendGiftRankView:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
  self.curSelectTab = self.TabType.RankView
  self:UpdateTab()
  self:UpdateContent()
end

function ValentineSendGiftRankView:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function ValentineSendGiftRankView:ComponentDefine()
  self.btnPanel = self:AddComponent(UIButton, "UICommonPopUpTitle/panel")
  self.btnPanel:SetOnClick(function()
    self:OnBtnPanelClick()
  end)
  self.textTitle = self:AddComponent(UIText, "UICommonPopUpTitle/Common_bg_orange/Common_img_title/titleText")
  self.textTitle:SetLocalText("activity_99136_8")
  self.btnClose = self:AddComponent(UIButton, "UICommonPopUpTitle/Common_bg_orange/CloseBtn")
  self.btnClose:SetOnClick(function()
    self:OnBtnCloseClick()
  end)
  self.compTabLayout = self:AddComponent(UIBaseContainer, "TabLayout")
  self.compTabList = {}
  for i, v in pairs(self.TabType) do
    local tab = {}
    tab.tabType = v
    local tabPath = "TabLayout/Tab" .. tostring(v)
    tab.objRoot = self:AddComponent(UIBaseContainer, tabPath)
    tab.objSelect = tab.objRoot:AddComponent(UIBaseContainer, "Select")
    tab.objUnSelect = tab.objRoot:AddComponent(UIBaseContainer, "UnSelect")
    tab.text = tab.objRoot:AddComponent(UIText, "Group/titleText")
    tab.btn = tab.objRoot:AddComponent(UIButton, "Btn")
    local index = v
    tab.btn:SetOnClick(function()
      self:OnSelectTab(index)
    end)
    self.compTabList[index] = tab
  end
  self.reward_content = self:AddComponent(ULWUIActValentineRankRewardContent, reward_content_path)
  self.rank_content = self:AddComponent(LWUIActValentineRankContent, rank_content_path)
  self.common_bg = self:AddComponent(UIBaseContainer, common_bg_path)
end

function ValentineSendGiftRankView:ComponentDestroy()
  self.btnPanel = nil
  self.textTitle = nil
  self.btnClose = nil
  self.compTabLayout = nil
  self.reward_content = nil
  self.rank_content = nil
  self.common_bg = nil
end

function ValentineSendGiftRankView:DataDefine()
  self.hasInitTab = {}
  self.activityId = self:GetUserData()
  self.activityInfo = DataCenter.ActivityListDataManager:GetActivityDataById(self.activityId)
  if self.activityInfo == nil then
    return
  end
  self.activityDetailData = DataCenter.ActLotteryDataManager:GetActData(self.activityId)
  if self.activityDetailData == nil then
    return
  end
end

function ValentineSendGiftRankView:DataDestroy()
  self.hasInitTab = nil
end

function ValentineSendGiftRankView:OnAddListener()
  base.OnAddListener(self)
end

function ValentineSendGiftRankView:OnRemoveListener()
  base.OnRemoveListener(self)
end

function ValentineSendGiftRankView:UpdateTab()
  if self.compTabList == nil then
    return
  end
  for i, v in pairs(self.compTabList) do
    local isSelect = self.curSelectTab == v.tabType
    v.objSelect:SetActive(isSelect)
    v.objUnSelect:SetActive(not isSelect)
    v.text:SetText(self:GetTabLocalText(v.tabType))
  end
end

function ValentineSendGiftRankView:UpdateContent()
  if self.curSelectTab == nil or self.activityId == nil then
    return
  end
  if self.curSelectTab == self.TabType.RankView then
    self.common_bg:SetSizeDeltaXY(744, 821.5)
    self.rank_content:SetActive(true)
    self.reward_content:SetActive(false)
    self.rank_content:SetData(self.activityId)
  elseif self.curSelectTab == self.TabType.Reward then
    self.common_bg:SetSizeDeltaXY(744, 924.3)
    self.rank_content:SetActive(false)
    self.reward_content:SetActive(true)
    self.reward_content:SetData(self.activityId)
  end
  self.hasInitTab[self.curSelectTab] = true
end

function ValentineSendGiftRankView:OnBtnPanelClick()
  self.ctrl:CloseSelf()
end

function ValentineSendGiftRankView:OnBtnCloseClick()
  self.ctrl:CloseSelf()
end

function ValentineSendGiftRankView:GetTabLocalText(tab)
  local name = ""
  if tab == self.TabType.RankView then
    name = Localization:GetString("activity_99136_9")
  elseif tab == self.TabType.Reward then
    name = Localization:GetString("activity_99136_11")
  end
  return name
end

function ValentineSendGiftRankView:OnSelectTab(tabType)
  if tabType == self.curSelectTab then
    return
  end
  self.curSelectTab = tabType
  self:UpdateTab()
  self:UpdateContent()
end

return ValentineSendGiftRankView
