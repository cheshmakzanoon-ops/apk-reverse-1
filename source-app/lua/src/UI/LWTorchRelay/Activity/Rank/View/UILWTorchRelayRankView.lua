local UILWTorchRelayRankView = BaseClass("UILWTorchRelayRankView", UIBaseView)
local base = UIBaseView
local Localization = CS.GameEntry.Localization
local UILWTorchRelayRankItemComponent = require("UI/LWTorchRelay/Activity/Rank/Component/UILWTorchRelayRankItemComponent")
local UILWTorchRelayRankRewardItemComponent = require("UI/LWTorchRelay/Activity/Rank/Component/UILWTorchRelayRankRewardItemComponent")
local EffectDesc = require("UI.UIDecoration.UIDecorationMain.Component.EffectDesc")
local UIDecorationChatBubble = require("UI.UIDecoration.UIDecorationMain.Component.UIDecorationChatBubble")
local toggle1_path = "selectContent/selectBg/Toggle1"
local selectToggle1_path = "selectContent/selectBg/Toggle1/selectToggle1"
local toggle2_path = "selectContent/selectBg/Toggle2"
local selectToggle2_path = "selectContent/selectBg/Toggle2/selectToggle2"
local show_bubble_content_path = "bannerImg/ShowBubbleContent"
local effect_left_path = "bannerImg/ShowBubbleContent/EffectLeft"
local chat_bubble_path = "bannerImg/ShowBubbleContent/ChatBubble"
local banner_img_path = "bannerImg"

local function OnCreate(self)
  base.OnCreate(self)
  self.M = DataCenter.ActivityTorchRelayManager
  self.param = self:GetUserData()
  self.actId = self.param.activityId
  self.belongSelect = self.M.RankType.Personal
  self.dataSelect = self.M.RankDataType.Rank
  self.actListData = DataCenter.ActivityListDataManager:GetActivityDataById(self.actId)
  self.panel = self:AddComponent(UIButton, "UICommonPopUpTitle/panel")
  self.panel:SetOnClick(function()
    self.ctrl:CloseSelf()
  end)
  self._close_btn = self:AddComponent(UIButton, "UICommonPopUpTitle/safearea/BtnClose")
  self._close_btn:SetOnClick(function()
    self.ctrl:CloseSelf()
  end)
  self.title = self:AddComponent(UIText, "UICommonPopUpTitle/safearea/TopBar/TextTitle")
  self.title:SetLocalText("390040")
  self.segmentN = self:AddComponent(UIBaseContainer, "tabSv/Viewport/Content")
  self.segmentTbN = {}
  for i = 0, 1 do
    local segment = self:AddComponent(UIBaseContainer, "tabSv/Viewport/Content/Tab" .. i)
    local btn = segment:AddComponent(UIButton, "")
    btn:SetOnClick(function()
      self:OnClickSegment(i + 1)
    end)
    local select = segment:AddComponent(UIBaseContainer, "select")
    local newSeg = {selectN = select, btnN = btn}
    table.insert(self.segmentTbN, newSeg)
  end
  self.toggle1 = self:AddComponent(UIButton, toggle1_path)
  self.toggle1:SetOnClick(function()
    DataCenter.LWSoundManager:PlayEffect(SoundAssetId.SFX_UI_General_Click_1st)
    self:OnToggleSelect(self.M.RankDataType.Rank)
  end)
  self.selectToggle1 = self:AddComponent(UIBaseContainer, selectToggle1_path)
  self.toggle2 = self:AddComponent(UIButton, toggle2_path)
  self.toggle2:SetOnClick(function()
    DataCenter.LWSoundManager:PlayEffect(SoundAssetId.SFX_UI_General_Click_1st)
    self:OnToggleSelect(self.M.RankDataType.Reward)
  end)
  self.selectToggle2 = self:AddComponent(UIBaseContainer, selectToggle2_path)
  self.rankObj = self:AddComponent(UILWTorchRelayRankItemComponent, "RankObj")
  self.rewardObj = self:AddComponent(UILWTorchRelayRankRewardItemComponent, "RewardObj")
  self.show_bubble_content = self:AddComponent(UIBaseContainer, show_bubble_content_path)
  self.effect_left = self:AddComponent(EffectDesc, effect_left_path)
  self.chat_bubble = self:AddComponent(UIDecorationChatBubble, chat_bubble_path)
  self.banner_img = self:AddComponent(UIRawImage, banner_img_path)
  self.bannerImgBorder = self:AddComponent(UIImage, "bannerImg/Image")
  self:ShowPanel()
end

local function OnDestroy(self)
  base.OnDestroy(self)
end

local function OnClickSegment(self, index)
  self:SelectSegment(index)
end

local function SelectSegment(self, seg)
  if self.belongSelect == seg then
    return
  end
  self.belongSelect = seg
  self:ShowPanel()
end

local function OnToggleSelect(self, index)
  if self.dataSelect == index then
    return
  end
  self.dataSelect = index
  self:ShowPanel()
end

local function ShowPanel(self)
  self.segmentTbN[self.M.RankType.Personal].selectN:SetActive(self.belongSelect == self.M.RankType.Personal)
  self.segmentTbN[self.M.RankType.Alliance].selectN:SetActive(self.belongSelect == self.M.RankType.Alliance)
  self.selectToggle1:SetActive(self.dataSelect == self.M.RankDataType.Rank)
  self.selectToggle2:SetActive(self.dataSelect == self.M.RankDataType.Reward)
  if self.dataSelect == self.M.RankDataType.Rank then
    self.rankObj:SetActive(true)
    self.rewardObj:SetActive(false)
    self.rankObj:SetData(self.actId, self.belongSelect)
  elseif self.dataSelect == self.M.RankDataType.Reward then
    self.rankObj:SetActive(false)
    self.rewardObj:SetActive(true)
    self.rewardObj:SetData(self.actId, self.belongSelect)
  end
  if self.belongSelect == self.M.RankType.Personal then
    self:RefreshShowBubble()
  else
    self.show_bubble_content:SetActive(false)
  end
  local activityData = DataCenter.ActivityTorchRelayManager:GetActivityData(self.actId)
  if activityData and activityData.config then
    self.banner_img:LoadSpriteAsync(activityData.config:GetRankBannerBg())
  end
end

local function RefreshShowBubble(self)
  self.show_bubble_content:SetActive(false)
  if self.actId then
    local data = self.M:GetActivityData(self.actId)
    if data and data.config then
      local bubbleTemplate = DataCenter.DecorationTemplateManager:GetTemplate(data.config.rank_banner_show)
      if bubbleTemplate then
        self.show_bubble_content:SetActive(true)
        self.chat_bubble:ReInit(self:GetChatBubbleData(bubbleTemplate.id))
        local effectData = DecorationUtil.GetEffectDesc(bubbleTemplate.id)
        self.effect_left:ReInit(effectData)
      end
    end
  end
end

local function GetChatBubbleData(self, decorationId)
  local result = {}
  result.decorationId = decorationId
  result.frame = DataCenter.DecorationDataManager:GetSelfHeadFrame()
  result.bubbleRes, result.msgColor = DataCenter.DecorationDataManager:GetChatBubbleAndMsgColor(decorationId, LongMaxValue)
  local activityData = DataCenter.ActivityTorchRelayManager:GetActivityData(self.actId)
  if activityData and activityData.config then
    result.bubbleResBorder = activityData.config:GetRankBannerBorder()
  end
  return result
end

UILWTorchRelayRankView.OnCreate = OnCreate
UILWTorchRelayRankView.OnDestroy = OnDestroy
UILWTorchRelayRankView.OnClickSegment = OnClickSegment
UILWTorchRelayRankView.SelectSegment = SelectSegment
UILWTorchRelayRankView.OnToggleSelect = OnToggleSelect
UILWTorchRelayRankView.ShowPanel = ShowPanel
UILWTorchRelayRankView.RefreshShowBubble = RefreshShowBubble
UILWTorchRelayRankView.GetChatBubbleData = GetChatBubbleData
return UILWTorchRelayRankView
