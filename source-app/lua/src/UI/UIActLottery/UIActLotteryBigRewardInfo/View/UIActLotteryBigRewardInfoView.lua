local UIActLotteryBigRewardInfoView = BaseClass("UIActLotteryBigRewardInfoView", UIBaseView)
local base = UIBaseView
local Localization = CS.GameEntry.Localization
local UIActLotteryBigRewardInfoPlayerContent = require("UI.UIActLottery.UIActLotteryBigRewardInfo.Component.UIActLotteryBigRewardInfoPlayerContent")
local UIActLotteryBigRewardInfoRewardContent = require("UI.UIActLottery.UIActLotteryBigRewardInfo.Component.UIActLotteryBigRewardInfoRewardContent")
local lottery_reward_player_content_path = "LotteryRewardPlayerContent"
local lottery_reward_show_content_path = "LotteryRewardShowContent"
UIActLotteryBigRewardInfoView.TabType = {Player = 1, Reward = 2}

function UIActLotteryBigRewardInfoView:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
  self.curSelectTab = self.TabType.Player
  self:UpdateTab()
  self:UpdateContent()
end

function UIActLotteryBigRewardInfoView:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UIActLotteryBigRewardInfoView:ComponentDefine()
  self.btnPanel = self:AddComponent(UIButton, "UICommonPopUpTitle/panel")
  self.btnPanel:SetOnClick(function()
    self:OnBtnPanelClick()
  end)
  self.textTitle = self:AddComponent(UIText, "UICommonPopUpTitle/Common_bg_orange/Common_img_title/titleText")
  self.textTitle:SetLocalText("thxgiv_Lottery_pre")
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
  self.lottery_reward_player_content = self:AddComponent(UIActLotteryBigRewardInfoPlayerContent, lottery_reward_player_content_path)
  self.lottery_reward_show_content = self:AddComponent(UIActLotteryBigRewardInfoRewardContent, lottery_reward_show_content_path)
end

function UIActLotteryBigRewardInfoView:ComponentDestroy()
  self.btnPanel = nil
  self.textTitle = nil
  self.btnClose = nil
  self.compTabLayout = nil
  self.lottery_reward_player_content = nil
  self.lottery_reward_show_content = nil
end

function UIActLotteryBigRewardInfoView:DataDefine()
  self.hasInitTab = {}
  self.activityId = self:GetUserData()
  self.activityInfo = DataCenter.ActivityListDataManager:GetActivityDataById(self.activityId)
end

function UIActLotteryBigRewardInfoView:DataDestroy()
  self.hasInitTab = nil
end

function UIActLotteryBigRewardInfoView:OnAddListener()
  base.OnAddListener(self)
end

function UIActLotteryBigRewardInfoView:OnRemoveListener()
  base.OnRemoveListener(self)
end

function UIActLotteryBigRewardInfoView:UpdateTab()
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

function UIActLotteryBigRewardInfoView:UpdateContent()
  if self.curSelectTab == nil or self.activityId == nil then
    return
  end
  if self.curSelectTab == self.TabType.Player then
    self.lottery_reward_player_content:SetActive(true)
    self.lottery_reward_show_content:SetActive(false)
    self.lottery_reward_player_content:SetData(self.activityId)
  else
    self.lottery_reward_player_content:SetActive(false)
    self.lottery_reward_show_content:SetActive(true)
    self.lottery_reward_show_content:SetData(self.activityId)
  end
  self.hasInitTab[self.curSelectTab] = true
end

function UIActLotteryBigRewardInfoView:OnBtnPanelClick()
  self.ctrl:CloseSelf()
end

function UIActLotteryBigRewardInfoView:OnBtnCloseClick()
  self.ctrl:CloseSelf()
end

function UIActLotteryBigRewardInfoView:GetTabLocalText(tab)
  if tab == self.TabType.Player then
    return Localization:GetString("thxgiv_Lottery_BigRecord")
  elseif tab == self.TabType.Reward then
    return Localization:GetString("thxgiv_Lottery_TicAward")
  end
  return ""
end

function UIActLotteryBigRewardInfoView:OnSelectTab(tabType)
  if tabType == self.curSelectTab then
    return
  end
  self.curSelectTab = tabType
  self:UpdateTab()
  self:UpdateContent()
end

return UIActLotteryBigRewardInfoView
