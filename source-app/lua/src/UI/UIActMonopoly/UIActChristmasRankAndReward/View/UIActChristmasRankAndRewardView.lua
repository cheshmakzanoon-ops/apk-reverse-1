local UIActChristmasRankAndRewardView = BaseClass("UIActChristmasRankAndRewardView", UIBaseView)
local base = UIBaseView
local Localization = CS.GameEntry.Localization
local UIActChristmasRankContent = require("UI.UIActMonopoly.UIActChristmasRankAndReward.Component.UIActChristmasRankContent")
local UIActChristmasRewardContent = require("UI.UIActMonopoly.UIActChristmasRankAndReward.Component.UIActChristmasRewardContent")
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
local show_reward_item_content_path = "bannerImg/ShowRewardItemContent"
local show_reward_item_path = "bannerImg/ShowRewardItemContent/ShowRewardItem"
local show_reward_item_name_path = "bannerImg/ShowRewardItemContent/ShowRewardItemName"

local function OnCreate(self)
  base.OnCreate(self)
  self.actId, self.actBanquetId = self:GetUserData()
  self.belongSelect = ActChristmasTreeBelongType.Personal
  self.dataSelect = ActChristmasTreeDataType.Rank
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
    self:OnToggleSelect(ActChristmasTreeDataType.Rank)
  end)
  self.selectToggle1 = self:AddComponent(UIBaseContainer, selectToggle1_path)
  self.toggle2 = self:AddComponent(UIButton, toggle2_path)
  self.toggle2:SetOnClick(function()
    DataCenter.LWSoundManager:PlayEffect(SoundAssetId.SFX_UI_General_Click_1st)
    self:OnToggleSelect(ActChristmasTreeDataType.Reward)
  end)
  self.selectToggle2 = self:AddComponent(UIBaseContainer, selectToggle2_path)
  self.rankObj = self:AddComponent(UIActChristmasRankContent, "RankObj")
  self.rewardObj = self:AddComponent(UIActChristmasRewardContent, "RewardObj")
  self.show_bubble_content = self:AddComponent(UIBaseContainer, show_bubble_content_path)
  self.effect_left = self:AddComponent(EffectDesc, effect_left_path)
  self.chat_bubble = self:AddComponent(UIDecorationChatBubble, chat_bubble_path)
  self.banner_img = self:AddComponent(UIRawImage, banner_img_path)
  self.show_reward_item_content = self:AddComponent(UIBaseContainer, show_reward_item_content_path)
  self.show_reward_item = self:AddComponent(UICommonResItem, show_reward_item_path)
  self.show_reward_item_name = self:AddComponent(UITextMeshProUGUIEx, show_reward_item_name_path)
  self:ShowPanel()
end

local function OnDestroy(self)
  base.OnDestroy(self)
end

local function OnClickSegment(self, index)
  if index == ActChristmasTreeBelongType.Personal or LuaEntry.Player:IsInAlliance() then
    self:SelectSegment(index)
  else
    UIUtil.ShowTipsId(800935)
  end
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
  self.segmentTbN[ActChristmasTreeBelongType.Personal].selectN:SetActive(self.belongSelect == ActChristmasTreeBelongType.Personal)
  self.segmentTbN[ActChristmasTreeBelongType.Alliance].selectN:SetActive(self.belongSelect == ActChristmasTreeBelongType.Alliance)
  self.selectToggle1:SetActive(self.dataSelect == ActChristmasTreeDataType.Rank)
  self.selectToggle2:SetActive(self.dataSelect == ActChristmasTreeDataType.Reward)
  if self.dataSelect == ActChristmasTreeDataType.Rank then
    self.rankObj:SetActive(true)
    self.rewardObj:SetActive(false)
    self.rankObj:SetData(self.actId, self.belongSelect, self.actBanquetId)
  elseif self.dataSelect == ActChristmasTreeDataType.Reward then
    self.rankObj:SetActive(false)
    self.rewardObj:SetActive(true)
    self.rewardObj:SetData(self.actId, self.belongSelect)
  end
  if self.belongSelect == ActChristmasTreeBelongType.Personal then
    self:RefreshShowBubble()
  else
    self.show_bubble_content:SetActive(false)
    self.show_reward_item_content:SetActive(false)
  end
  local bannerName = self.actListData.para
  local bannerPath = string.format(UIAssets.UIActMonopolyTexturePath, bannerName)
  self.banner_img:LoadSprite(bannerPath)
end

local function RefreshShowBubble(self)
  self.show_bubble_content:SetActive(false)
  self.show_reward_item_content:SetActive(false)
  local actBanquetTemplate = DataCenter.ActivityPartyTemplateManager:GetActBanquetTemplate(self.actBanquetId)
  if actBanquetTemplate then
    local rank_banner_show = actBanquetTemplate.rank_banner_show
    if string.IsNullOrEmpty(rank_banner_show) then
      return
    end
    local paraList = string.string2array_num_oneSep(rank_banner_show, "|")
    if #paraList < 2 then
      return
    end
    local DecorationType = 1
    local GoodsType = 2
    if paraList[1] == DecorationType then
      local bubbleTemplate = DataCenter.DecorationTemplateManager:GetTemplate(paraList[2])
      if bubbleTemplate then
        self.show_bubble_content:SetActive(true)
        self.chat_bubble:ReInit(self:GetChatBubbleData(bubbleTemplate.id))
        local effectData = DecorationUtil.GetEffectDesc(bubbleTemplate.id)
        self.effect_left:ReInit(effectData)
      end
    else
      local goodsId = paraList[2]
      local goodsTemplate = DataCenter.ItemTemplateManager:GetItemTemplate(goodsId)
      if goodsTemplate then
        self.show_reward_item_content:SetActive(true)
        local param = {
          rewardType = RewardType.GOODS,
          itemId = goodsId
        }
        self.show_reward_item:ReInit(param)
        self.show_reward_item_name:SetText(goodsTemplate:GetName())
        local qualityColor = UIUtil.GetColorByQuality(goodsTemplate.quality)
        self.show_reward_item_name:SetColor(qualityColor)
      end
    end
  end
end

local function GetChatBubbleData(self, decorationId)
  local result = {}
  result.decorationId = decorationId
  result.frame = DataCenter.DecorationDataManager:GetSelfHeadFrame()
  result.bubbleRes, result.msgColor = DataCenter.DecorationDataManager:GetChatBubbleAndMsgColor(decorationId, LongMaxValue)
  return result
end

UIActChristmasRankAndRewardView.OnCreate = OnCreate
UIActChristmasRankAndRewardView.OnDestroy = OnDestroy
UIActChristmasRankAndRewardView.OnClickSegment = OnClickSegment
UIActChristmasRankAndRewardView.SelectSegment = SelectSegment
UIActChristmasRankAndRewardView.OnToggleSelect = OnToggleSelect
UIActChristmasRankAndRewardView.ShowPanel = ShowPanel
UIActChristmasRankAndRewardView.RefreshShowBubble = RefreshShowBubble
UIActChristmasRankAndRewardView.GetChatBubbleData = GetChatBubbleData
return UIActChristmasRankAndRewardView
