local UIActLotterySelfInfoView = BaseClass("UIActLotterySelfInfoView", UIBaseView)
local UIActLotterySelfInfoBeSendContent = require("UI.UIActLottery.UIActLotterySelfInfo.Component.UIActLotterySelfInfoBeSendContent")
local UIActLotterySelfInfoBigRewardContent = require("UI.UIActLottery.UIActLotterySelfInfo.Component.UIActLotterySelfInfoBigRewardContent")
local base = UIBaseView
local Localization = CS.GameEntry.Localization
local lottery_reward_content_path = "LotteryRewardContent"
local be_send_content_path = "BeSendContent"
UIActLotterySelfInfoView.TabType = {BeSend = 1, Reward = 2}

function UIActLotterySelfInfoView:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
  self.curSelectTab = self.TabType.BeSend
  self:UpdateTab()
  self:UpdateContent()
end

function UIActLotterySelfInfoView:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UIActLotterySelfInfoView:ComponentDefine()
  self.btnPanel = self:AddComponent(UIButton, "UICommonPopUpTitle/panel")
  self.btnPanel:SetOnClick(function()
    self:OnBtnPanelClick()
  end)
  self.textTitle = self:AddComponent(UIText, "UICommonPopUpTitle/Common_bg_orange/Common_img_title/titleText")
  self.textTitle:SetLocalText("thxgiv_RecordWindowTitle")
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
  self.lottery_reward_content = self:AddComponent(UIActLotterySelfInfoBigRewardContent, lottery_reward_content_path)
  self.be_send_content = self:AddComponent(UIActLotterySelfInfoBeSendContent, be_send_content_path)
end

function UIActLotterySelfInfoView:ComponentDestroy()
  self.btnPanel = nil
  self.textTitle = nil
  self.btnClose = nil
  self.compTabLayout = nil
  self.lottery_reward_content = nil
  self.be_send_content = nil
end

function UIActLotterySelfInfoView:DataDefine()
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

function UIActLotterySelfInfoView:DataDestroy()
  self.hasInitTab = nil
end

function UIActLotterySelfInfoView:OnAddListener()
  base.OnAddListener(self)
end

function UIActLotterySelfInfoView:OnRemoveListener()
  base.OnRemoveListener(self)
end

function UIActLotterySelfInfoView:UpdateTab()
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

function UIActLotterySelfInfoView:UpdateContent()
  if self.curSelectTab == nil or self.activityId == nil then
    return
  end
  if self.curSelectTab == self.TabType.BeSend then
    self.be_send_content:SetActive(true)
    self.lottery_reward_content:SetActive(false)
    self.be_send_content:SetData(self.activityId)
  elseif self.curSelectTab == self.TabType.Reward then
    self.be_send_content:SetActive(false)
    self.lottery_reward_content:SetActive(true)
    self.lottery_reward_content:SetData(self.activityId)
  end
  self.hasInitTab[self.curSelectTab] = true
end

function UIActLotterySelfInfoView:OnBtnPanelClick()
  self.ctrl:CloseSelf()
end

function UIActLotterySelfInfoView:OnBtnCloseClick()
  self.ctrl:CloseSelf()
end

function UIActLotterySelfInfoView:GetTabLocalText(tab)
  local name = ""
  if tab == self.TabType.BeSend then
    name = Localization:GetString("thxgiv_Lottery_history")
  elseif tab == self.TabType.Reward then
    name = Localization:GetString("thxgiv_Lottery_awardrecord")
  end
  return name
end

function UIActLotterySelfInfoView:OnSelectTab(tabType)
  if tabType == self.curSelectTab then
    return
  end
  self.curSelectTab = tabType
  self:UpdateTab()
  self:UpdateContent()
end

return UIActLotterySelfInfoView
