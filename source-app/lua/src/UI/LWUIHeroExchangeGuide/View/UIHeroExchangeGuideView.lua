local UIHeroExchangeGuideView = BaseClass("UIHeroExchangeGuideView", UIBaseView)
local base = UIBaseView
local Localization = CS.GameEntry.Localization
local UIGray = CS.UIGray
local panel_path = "Root/panel"
local guide_raw_img1_path = "Root/Content/GuideImgRoot/GuideRawImg1"
local guide_raw_img2_path = "Root/Content/GuideImgRoot/GuideRawImg2"
local guide_raw_img3_path = "Root/Content/GuideImgRoot/GuideRawImg3"
local guide_raw_img4_path = "Root/Content/GuideImgRoot/GuideRawImg4"
local guide_raw_img5_path = "Root/Content/GuideImgRoot/GuideRawImg5"
local next_page_btn_path = "Root/Content/NextPageBtn"
local prev_page_btn_path = "Root/Content/PrevPageBtn"
local page_info_text_path = "Root/Content/PageInfoText"
local title_text_path = "Root/Content/TitleArea/TitleText"
local desc_text_path = "Root/Content/DescText"
local receive_reward_btn_path = "Root/Content/ReceiveRewardBtn"
local reward_btn_text_path = "Root/Content/ReceiveRewardBtn/RewardBtnText"
local startPageIndex = 1
local endPageIndex = 5

local function OnCreate(self)
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
  local param = self:GetUserData()
  self.activityId = param.activityId
  self.activityInfo = DataCenter.ActivityListDataManager:GetActivityDataById(self.activityId)
  self:RefreshPage()
end

local function OnDestroy(self)
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

local function OnEnable(self)
  base.OnEnable(self)
end

local function OnDisable(self)
  base.OnDisable(self)
end

local function ComponentDefine(self)
  self.closePanelBtn = self:AddComponent(UIButton, panel_path)
  self.closePanelBtn:SetOnClick(function()
    self:CloseGuidePanel()
  end)
  local page1 = self:AddComponent(UIBaseContainer, guide_raw_img1_path)
  local page2 = self:AddComponent(UIBaseContainer, guide_raw_img2_path)
  local page3 = self:AddComponent(UIBaseContainer, guide_raw_img3_path)
  local page4 = self:AddComponent(UIBaseContainer, guide_raw_img4_path)
  local page5 = self:AddComponent(UIBaseContainer, guide_raw_img5_path)
  self.allPageImgList = {}
  self.allPageImgList[1] = page1
  self.allPageImgList[2] = page2
  self.allPageImgList[3] = page3
  self.allPageImgList[4] = page4
  self.allPageImgList[5] = page5
  self.nextPageBtn = self:AddComponent(UIButton, next_page_btn_path)
  self.nextPageBtn:SetOnClick(function()
    self:OnClickNextPage()
  end)
  self.prevPageBtn = self:AddComponent(UIButton, prev_page_btn_path)
  self.prevPageBtn:SetOnClick(function()
    self:OnClickPrevPage()
  end)
  self.receiveRewardBtn = self:AddComponent(UIButton, receive_reward_btn_path)
  self.receiveRewardBtn:SetOnClick(function()
    self:ReceiveReward()
  end)
  self.pageInfoText = self:AddComponent(UIText, page_info_text_path)
  self.titleText = self:AddComponent(UIText, title_text_path)
  self.descText = self:AddComponent(UIText, desc_text_path)
  self.rewardBtnText = self:AddComponent(UIText, reward_btn_text_path)
end

local function ComponentDestroy(self)
  self.allPageImgList = nil
end

local function DataDefine(self)
  self.curPageIndex = 1
  self.descKeyList = {}
  self.descKeyList[1] = "activity_hero_change_guide_tips_1"
  self.descKeyList[2] = "activity_hero_change_guide_tips_2"
  self.descKeyList[3] = "activity_hero_change_guide_tips_3"
  self.descKeyList[4] = "activity_hero_change_guide_tips_4"
  self.descKeyList[5] = "activity_hero_change_reward_tips"
end

local function DataDestroy(self)
  self.curPageIndex = nil
  self.descKeyList = nil
end

local function OnAddListener(self)
  base.OnAddListener(self)
  self:AddUIListener(EventId.ExchangeHeroReceiveRewardSuccess, self.ClosePanel)
end

local function OnRemoveListener(self)
  self:RemoveUIListener(EventId.ExchangeHeroReceiveRewardSuccess, self.ClosePanel)
  base.OnRemoveListener(self)
end

function UIHeroExchangeGuideView:OnClickNextPage()
  self.curPageIndex = Mathf.Clamp(self.curPageIndex + 1, startPageIndex, endPageIndex)
  self:RefreshPage()
end

function UIHeroExchangeGuideView:OnClickPrevPage()
  self.curPageIndex = Mathf.Clamp(self.curPageIndex - 1, startPageIndex, endPageIndex)
  self:RefreshPage()
end

function UIHeroExchangeGuideView:RefreshPage()
  for k, v in ipairs(self.allPageImgList) do
    v:SetActive(k == self.curPageIndex)
  end
  local descKey = self.descKeyList[self.curPageIndex]
  if not self:IsLastPage() then
    self.descText:SetLocalText(descKey)
  elseif self.activityInfo then
    local rewardItemInfo = self.activityInfo.para_1
    local items = string.split(rewardItemInfo, "|")
    if items then
      local itemId = items[1]
      local count = items[2]
      if itemId and count then
        local itemName = ""
        local itemMeta = DataCenter.ItemTemplateManager:GetItemTemplate(itemId)
        if itemMeta then
          itemName = Localization:GetString(itemMeta.name)
        end
        self.descText:SetLocalText(descKey, count, itemName)
      end
    end
  end
  local titleKeyStr = "activity_hero_change_guide_title"
  if self:IsLastPage() then
    titleKeyStr = "activity_hero_change_reward_title"
  end
  self.titleText:SetLocalText(titleKeyStr)
  self.pageInfoText:SetText(string.format("%s/%s", self.curPageIndex, endPageIndex))
  self:RefreshBtnState()
end

function UIHeroExchangeGuideView:RefreshBtnState()
  self.prevPageBtn:SetActive(not self:IsFirstPage())
  self.nextPageBtn:SetActive(not self:IsLastPage())
  self.receiveRewardBtn:SetActive(self:IsLastPage())
  if self:IsLastPage() then
    local isReceivedReward = DataCenter.ActExchangeHeroDataManager:GetReceiveRewardState(self.activityId)
    if isReceivedReward then
      self.rewardBtnText:SetLocalText("170003")
      UIGray.SetGray(self.receiveRewardBtn.transform, true, false)
    else
      self.rewardBtnText:SetLocalText("170004")
      UIGray.SetGray(self.receiveRewardBtn.transform, false, true)
    end
  end
end

function UIHeroExchangeGuideView:ReceiveReward()
  SFSNetwork.SendMessage(MsgDefines.LwSeasonHeroReceiveSwitchReward, self.activityId)
end

function UIHeroExchangeGuideView:IsLastPage()
  return self.curPageIndex == endPageIndex
end

function UIHeroExchangeGuideView:IsFirstPage()
  return self.curPageIndex == startPageIndex
end

function UIHeroExchangeGuideView:CloseGuidePanel()
  self:ClosePanel()
  local isReceivedReward = DataCenter.ActExchangeHeroDataManager:GetReceiveRewardState(self.activityId)
  if not isReceivedReward then
    self:ReceiveReward()
  end
end

function UIHeroExchangeGuideView:ClosePanel()
  self.ctrl:CloseSelf()
end

UIHeroExchangeGuideView.OnCreate = OnCreate
UIHeroExchangeGuideView.OnDestroy = OnDestroy
UIHeroExchangeGuideView.OnEnable = OnEnable
UIHeroExchangeGuideView.OnDisable = OnDisable
UIHeroExchangeGuideView.ComponentDefine = ComponentDefine
UIHeroExchangeGuideView.ComponentDestroy = ComponentDestroy
UIHeroExchangeGuideView.DataDefine = DataDefine
UIHeroExchangeGuideView.DataDestroy = DataDestroy
UIHeroExchangeGuideView.OnAddListener = OnAddListener
UIHeroExchangeGuideView.OnRemoveListener = OnRemoveListener
return UIHeroExchangeGuideView
