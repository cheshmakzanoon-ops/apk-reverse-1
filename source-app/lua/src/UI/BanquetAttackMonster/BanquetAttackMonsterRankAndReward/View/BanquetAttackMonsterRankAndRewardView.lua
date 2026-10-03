local BanquetAttackMonsterRankAndRewardView = BaseClass("BanquetAttackMonsterRankAndRewardView", UIBaseView)
local base = UIBaseView
local Localization = CS.GameEntry.Localization
local BanquetAttackMonsterRankContent = require("UI.BanquetAttackMonster.BanquetAttackMonsterRankAndReward.Component.BanquetAttackMonsterRankContent")
local BanquetAttackMonsterRewardContent = require("UI.BanquetAttackMonster.BanquetAttackMonsterRankAndReward.Component.BanquetAttackMonsterRewardContent")
local EffectDesc = require("UI.UIDecoration.UIDecorationMain.Component.EffectDesc")
local UIDecorationChatBubble = require("UI.UIDecoration.UIDecorationMain.Component.UIDecorationChatBubble")
local CommonActivityPopUpBgPart = require("UI.LWActivityCommonSecondPopUp.UIActivityDetailCommon.Component.CommonActivityPopUpBgPart")
local activityThemPath = "Assets/Main/Sprites/UI/ActivityThemeSkin/%s"
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
local common_activity_pop_up_bg_part_path = "UICommonPopUpTitle/safearea/CommonActivityPopUpBgPart"
local type_button0_path = "tabSv/Viewport/Content/Tab0/TypeButton0"
local select0_path = "tabSv/Viewport/Content/Tab0/select0"
local type_button1_path = "tabSv/Viewport/Content/Tab1/TypeButton1"
local select1_path = "tabSv/Viewport/Content/Tab1/select1"
local unselect_text0_path = "tabSv/Viewport/Content/Tab0/unselectText0"
local select_text0_path = "tabSv/Viewport/Content/Tab0/select0/selectText0"
local unselect_text1_path = "tabSv/Viewport/Content/Tab1/unselectText1"
local select_text1_path = "tabSv/Viewport/Content/Tab1/select1/selectText1"
local select_bg_path = "selectContent/selectBg"
local unselect_text_toggle1_path = "selectContent/selectBg/Toggle1/unselectTextToggle1"
local checkmark1_path = "selectContent/selectBg/Toggle1/selectToggle1/Checkmark1"
local select_text_toggle1_path = "selectContent/selectBg/Toggle1/selectToggle1/selectTextToggle1"
local unselect_text_toggle2_path = "selectContent/selectBg/Toggle2/unselectTextToggle2"
local checkmark2_path = "selectContent/selectBg/Toggle2/selectToggle2/Checkmark2"
local select_text_toggle2_path = "selectContent/selectBg/Toggle2/selectToggle2/selectTextToggle2"

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
    local select = segment:AddComponent(UIBaseContainer, "select" .. i)
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
  self.rankObj = self:AddComponent(BanquetAttackMonsterRankContent, "RankObj")
  self.rewardObj = self:AddComponent(BanquetAttackMonsterRewardContent, "RewardObj")
  self.show_bubble_content = self:AddComponent(UIBaseContainer, show_bubble_content_path)
  self.effect_left = self:AddComponent(EffectDesc, effect_left_path)
  self.chat_bubble = self:AddComponent(UIDecorationChatBubble, chat_bubble_path)
  self.banner_img = self:AddComponent(UIRawImage, banner_img_path)
  self.show_reward_item_content = self:AddComponent(UIBaseContainer, show_reward_item_content_path)
  self.show_reward_item = self:AddComponent(UICommonResItem, show_reward_item_path)
  self.show_reward_item_name = self:AddComponent(UITextMeshProUGUIEx, show_reward_item_name_path)
  self.commonActivityPopUpBgPart = self:AddComponent(CommonActivityPopUpBgPart, common_activity_pop_up_bg_part_path)
  self.commonActivityPopUpBgPart:SetCloseCallback(BindCallback(self.ctrl, self.ctrl.CloseSelf))
  self.unSelect1Image = self:AddComponent(UIImage, type_button0_path)
  self.select1Image = self:AddComponent(UIImage, select0_path)
  self.unSelect2Image = self:AddComponent(UIImage, type_button1_path)
  self.select2Image = self:AddComponent(UIImage, select1_path)
  self.unselect1Text = self:AddComponent(UIText, unselect_text0_path)
  self.select1Text = self:AddComponent(UIText, select_text0_path)
  self.unselect2Text = self:AddComponent(UIText, unselect_text1_path)
  self.select2Text = self:AddComponent(UIText, select_text1_path)
  self.select_bg = self:AddComponent(UIImage, select_bg_path)
  self.unselect_text_toggle1 = self:AddComponent(UIText, unselect_text_toggle1_path)
  self.checkmark1 = self:AddComponent(UIImage, checkmark1_path)
  self.select_text_toggle1 = self:AddComponent(UIText, select_text_toggle1_path)
  self.unselect_text_toggle2 = self:AddComponent(UIText, unselect_text_toggle2_path)
  self.checkmark2 = self:AddComponent(UIImage, checkmark2_path)
  self.select_text_toggle2 = self:AddComponent(UIText, select_text_toggle2_path)
  self:ShowPanel()
  self:RefreshViewPacking()
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
  local bannerPath = DataCenter.ActivityListDataManager:GetActivityModLoadPath(UIAssets.UIActBanquetAttackMonsterTexturePath, bannerName)
  self.banner_img:LoadSprite(bannerPath)
end

local function RefreshShowBubble(self)
  self.show_bubble_content:SetActive(false)
  self.show_reward_item_content:SetActive(false)
  local actBanquetTemplate = DataCenter.ActivityPartyNewTemplateManager:GetActBanquetTemplate(self.actBanquetId)
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

local function RefreshViewPacking(self)
  if self.actId then
    local lineData = LocalController:instance():getLine(TableName.Activity, self.actId)
    if lineData == nil then
      Logger.LogError("Activity GetTemplate lineData is nil id:" .. self.actId)
      return nil
    end
    if not lineData.festival_interface_config or not tonumber(lineData.festival_interface_config) then
      Logger.LogError("Activity GetTemplate lineData.festival_interface_config is nil or not a number id:" .. self.actId)
      return
    end
    self:ModifyPanelPacking(tonumber(lineData.festival_interface_config))
  end
end

local function ModifyPanelPacking(self, festivalInterfaceCfgId)
  local lineData = LocalController:instance():getLine(TableName.Festival_Interface_Config, festivalInterfaceCfgId)
  if lineData == nil then
    Logger.LogError("Festival_Interface_Config GetTemplate lineData is nil id:" .. festivalInterfaceCfgId)
    return
  end
  self.commonActivityPopUpBgPart:ModifyPanelPacking(lineData, UIWindowNames.UIActChristmasRankAndRewardCommon, self.actId)
  if not lineData.board_page or not lineData.board_page2 then
    Logger.LogError("Festival_Interface_Config GetTemplate lineData.board_page or board_page2 is nil id:" .. festivalInterfaceCfgId)
    return
  end
  local boardPageArr = string.split(lineData.board_page, "|")
  if table.length(boardPageArr) == 4 then
    local selectSpritePath = string.format(activityThemPath, boardPageArr[1])
    local unSelectSpritePath = string.format(activityThemPath, boardPageArr[2])
    local selectWorldColorArr = string.split(boardPageArr[3], ",")
    local unSelectWorldColorArr = string.split(boardPageArr[4], ",")
    self.select1Image:LoadSprite(selectSpritePath)
    self.select2Image:LoadSprite(selectSpritePath)
    self.unSelect1Image:LoadSprite(unSelectSpritePath)
    self.unSelect2Image:LoadSprite(unSelectSpritePath)
    if table.length(selectWorldColorArr) == 4 then
      self.select1Text:SetColorRGBA255(tonumber(selectWorldColorArr[1]), tonumber(selectWorldColorArr[2]), tonumber(selectWorldColorArr[3]), tonumber(selectWorldColorArr[4]))
      self.select2Text:SetColorRGBA255(tonumber(selectWorldColorArr[1]), tonumber(selectWorldColorArr[2]), tonumber(selectWorldColorArr[3]), tonumber(selectWorldColorArr[4]))
    end
    if table.length(unSelectWorldColorArr) == 4 then
      self.unselect1Text:SetColorRGBA255(tonumber(unSelectWorldColorArr[1]), tonumber(unSelectWorldColorArr[2]), tonumber(unSelectWorldColorArr[3]), tonumber(unSelectWorldColorArr[4]))
      self.unselect2Text:SetColorRGBA255(tonumber(unSelectWorldColorArr[1]), tonumber(unSelectWorldColorArr[2]), tonumber(unSelectWorldColorArr[3]), tonumber(unSelectWorldColorArr[4]))
    end
  end
  local boardPageArr2 = string.split(lineData.board_page2, "|")
  if table.length(boardPageArr2) == 4 then
    local selectSpritePath2 = string.format(activityThemPath, boardPageArr2[1])
    local unSelectSpritePath2 = string.format(activityThemPath, boardPageArr2[2])
    local selectWorldColorArr2 = string.split(boardPageArr2[3], ",")
    local unSelectWorldColorArr2 = string.split(boardPageArr2[4], ",")
    self.select_bg:LoadSprite(unSelectSpritePath2)
    if table.length(unSelectWorldColorArr2) == 4 then
      self.unselect_text_toggle1:SetColorRGBA255(tonumber(unSelectWorldColorArr2[1]), tonumber(unSelectWorldColorArr2[2]), tonumber(unSelectWorldColorArr2[3]), tonumber(unSelectWorldColorArr2[4]))
      self.unselect_text_toggle2:SetColorRGBA255(tonumber(unSelectWorldColorArr2[1]), tonumber(unSelectWorldColorArr2[2]), tonumber(unSelectWorldColorArr2[3]), tonumber(unSelectWorldColorArr2[4]))
    end
    self.checkmark1:LoadSprite(selectSpritePath2)
    self.checkmark2:LoadSprite(selectSpritePath2)
    if table.length(selectWorldColorArr2) == 4 then
      self.select_text_toggle1:SetColorRGBA255(tonumber(selectWorldColorArr2[1]), tonumber(selectWorldColorArr2[2]), tonumber(selectWorldColorArr2[3]), tonumber(selectWorldColorArr2[4]))
      self.select_text_toggle2:SetColorRGBA255(tonumber(selectWorldColorArr2[1]), tonumber(selectWorldColorArr2[2]), tonumber(selectWorldColorArr2[3]), tonumber(selectWorldColorArr2[4]))
    end
  end
end

BanquetAttackMonsterRankAndRewardView.OnCreate = OnCreate
BanquetAttackMonsterRankAndRewardView.OnDestroy = OnDestroy
BanquetAttackMonsterRankAndRewardView.OnClickSegment = OnClickSegment
BanquetAttackMonsterRankAndRewardView.SelectSegment = SelectSegment
BanquetAttackMonsterRankAndRewardView.OnToggleSelect = OnToggleSelect
BanquetAttackMonsterRankAndRewardView.ShowPanel = ShowPanel
BanquetAttackMonsterRankAndRewardView.RefreshShowBubble = RefreshShowBubble
BanquetAttackMonsterRankAndRewardView.GetChatBubbleData = GetChatBubbleData
BanquetAttackMonsterRankAndRewardView.ModifyPanelPacking = ModifyPanelPacking
BanquetAttackMonsterRankAndRewardView.RefreshViewPacking = RefreshViewPacking
return BanquetAttackMonsterRankAndRewardView
