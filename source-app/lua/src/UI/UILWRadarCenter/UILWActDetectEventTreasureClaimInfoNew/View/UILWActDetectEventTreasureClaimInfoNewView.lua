local UILWActDetectEventTreasureClaimInfoNewView = BaseClass("UILWActDetectEventTreasureClaimInfoNewView", UIBaseView)
local base = UIBaseView
local Localization = CS.GameEntry.Localization
local UILWActDetectEventTreasureClaimInfoNewPlayerItemRender = require("UI.UILWRadarCenter.UILWActDetectEventTreasureClaimInfoNew.Component.UILWActDetectEventTreasureClaimInfoNewPlayerItemRender")
local panel_btn_path = "PanelBtn"
local title_text_path = "Content/TitleText"
local reward_tips_text_path = "Content/RewardTipsText"
local close_tips_text_path = "Content/CloseTipsText"
local bg_raw_image_path = "Content/BgRawImage"
local close_btn_path = "Content/CloseBtn"
local owner_player_head_path = "Content/OwnerPlayerHead"
local owner_player_name_text_path = "Content/OwnerPlayerNameText"
local reward_scroll_view_path = "Content/RewardScrollView"
local receive_reward_tips_text_path = "Content/ReceiveRewardTipsContent/ReceiveRewardTipsText"
local receive_reward_tips_text_type2_path = "Content/ReceiveRewardTipsContent/ReceiveRewardTipsTextType2"
local player_scroll_view_path = "Content/PlayerScrollView"
local have_get_tips_text_path = "Content/HaveGetTipsText"
local like_path = "Content/Like"
local common_bg_orange_path = "Content/Common_bg_orange"
local bg_icon_raw_path = "Content/bgIconRaw"
local common_bg_orange2_path = "Content/Common_bg_orange2"
local receive_reward_tips_content_path = "Content/ReceiveRewardTipsContent"
local like_bg_path = "Content/Like/likeBg"
local like_icon_path = "Content/Like/likeIcon"

function UILWActDetectEventTreasureClaimInfoNewView:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self.treasureClaimInfoDate = self:GetUserData()
  self:RefreshView()
  PostEventLog.Track(PostEventLog.Defines.ActRadarTreasureGetResultOpen, {
    eventId = self.treasureClaimInfoDate.cfgId,
    uid = self.treasureClaimInfoDate.ownerInfo.uid
  })
end

function UILWActDetectEventTreasureClaimInfoNewView:OnDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UILWActDetectEventTreasureClaimInfoNewView:ComponentDefine()
  self.title_text = self:AddComponent(UITextMeshProUGUIEx, title_text_path)
  self.title_text:SetLocalText("activity_wajueji_27000_tips12")
  self.reward_tips_text = self:AddComponent(UITextMeshProUGUIEx, reward_tips_text_path)
  self.reward_tips_text:SetLocalText("activity_sports_uitips_013")
  self.close_tips_text = self:AddComponent(UITextMeshProUGUIEx, close_tips_text_path)
  self.close_tips_text:SetLocalText("radar_tips_10")
  self.panel_btn = self:AddComponent(UIButton, panel_btn_path)
  self.panel_btn:SetOnClick(function()
    self.ctrl:CloseSelf()
  end)
  self.bg_raw_image = self:AddComponent(UIRawImage, bg_raw_image_path)
  self.close_btn = self:AddComponent(UIButton, close_btn_path)
  self.close_btn:SetOnClick(function()
    self.ctrl:CloseSelf()
  end)
  self.owner_player_head = self:AddComponent(UICommonHead, owner_player_head_path)
  self.owner_player_name_text = self:AddComponent(UITextMeshProUGUIEx, owner_player_name_text_path)
  self.reward_scroll_view = self:AddComponent(UIScrollView, reward_scroll_view_path)
  self.reward_scroll_view:SetOnItemMoveIn(function(itemObj, index)
    self:OnRewardItemMoveIn(itemObj, index)
  end)
  self.reward_scroll_view:SetOnItemMoveOut(function(itemObj, index)
    self.OnRewardItemMoveOut(itemObj, index)
  end)
  self.receive_reward_tips_text = self:AddComponent(UITextMeshProUGUIEx, receive_reward_tips_text_path)
  self.receive_reward_tips_text_type2 = self:AddComponent(UITextMeshProUGUIEx, receive_reward_tips_text_type2_path)
  self.player_scroll_view = self:AddComponent(UIScrollView, player_scroll_view_path)
  self.player_scroll_view:SetOnItemMoveIn(function(itemObj, index)
    self:OnPlayerItemMoveIn(itemObj, index)
  end)
  self.player_scroll_view:SetOnItemMoveOut(function(itemObj, index)
    self:OnPlayerItemMoveOut(itemObj, index)
  end)
  self.have_get_tips_text = self:AddComponent(UITextMeshProUGUIEx, have_get_tips_text_path)
  self.like = self:AddComponent(UIButton, like_path)
  self.like:SetOnClick(function()
    self:OnLikeClick()
  end)
  self.common_bg_orange = self:AddComponent(UIRawImage, common_bg_orange_path)
  self.bg_icon_raw = self:AddComponent(UIRawImage, bg_icon_raw_path)
  self.common_bg_orange2 = self:AddComponent(UIImage, common_bg_orange2_path)
  self.receive_reward_tips_content = self:AddComponent(UIRawImage, receive_reward_tips_content_path)
  self.like_bg = self:AddComponent(UIRawImage, like_bg_path)
  self.like_icon = self:AddComponent(UIRawImage, like_icon_path)
  self.receive_reward_tips_content:LoadSpriteAsync(string.format(LoadPath.ActRadarRawImg, "2024ChristmasParty/zyf_shengdanjie_riwajuejilu_bantou1"))
  self.like_bg:LoadSpriteAsync(string.format(LoadPath.ActRadarRawImg, "2024ChristmasParty/zyf_shengdanjie_riwajuejilu_bantou2"))
end

function UILWActDetectEventTreasureClaimInfoNewView:ComponentDestroy()
  self.panel_btn = nil
  self.title_text = nil
  self.reward_tips_text = nil
  self.close_tips_text = nil
  self.bg_raw_image = nil
  self.close_btn = nil
  self.owner_player_head = nil
  self.owner_player_name_text = nil
  self:ClearRewardScroll()
  self.reward_scroll_view = nil
  self.receive_reward_tips_text = nil
  self:ClearClaimPlayerInfoScroll()
  self.player_scroll_view = nil
  self.like = nil
  self.common_bg_orange = nil
  self.bg_icon_raw = nil
  self.common_bg_orange2 = nil
  self.receive_reward_tips_content = nil
  self.like_bg = nil
  self.like_icon = nil
end

function UILWActDetectEventTreasureClaimInfoNewView:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.RefreshDetectEventGetTreasureClaimInfo, self.OnRefreshClaimInfoView)
end

function UILWActDetectEventTreasureClaimInfoNewView:OnRemoveListener()
  self:RemoveUIListener(EventId.RefreshDetectEventGetTreasureClaimInfo, self.OnRefreshClaimInfoView)
  base.OnRemoveListener(self)
end

function UILWActDetectEventTreasureClaimInfoNewView:OnRefreshClaimInfoView(data)
  self.treasureClaimInfoDate = data
  self:RefreshView()
end

function UILWActDetectEventTreasureClaimInfoNewView:RefreshView()
  if self.treasureClaimInfoDate == nil then
    Logger.LogError("\230\137\147\229\188\128\230\140\150\230\142\152\229\174\157\232\151\143\231\154\132\232\174\176\229\189\149\231\149\140\233\157\162\230\149\176\230\141\174\228\184\186\231\169\186")
    return
  end
  local detectEventTemplate = DataCenter.DetectEventTemplateManager:GetDetectEventTemplate(tostring(self.treasureClaimInfoDate.eventId))
  if detectEventTemplate ~= nil then
    self.bg_raw_image:LoadSpriteAuto(detectEventTemplate.pic)
  end
  local uid = self.treasureClaimInfoDate.ownerInfo.uid
  local pic = self.treasureClaimInfoDate.ownerInfo.headPic
  local picVer = self.treasureClaimInfoDate.ownerInfo.headPicVer
  local headSkinId = self.treasureClaimInfoDate.ownerInfo.headSkinId
  local headSkinET = self.treasureClaimInfoDate.ownerInfo.headSkinET
  self.owner_player_head:SetHeadAndFrame(uid, pic, picVer, nil, headSkinId, headSkinET)
  local showName = DataCenter.PlayerInfoDataManager:GetRemarkOrRealName(uid, self.treasureClaimInfoDate.ownerInfo.name)
  self.owner_player_name_text:SetText(showName)
  local isOffSeasonTreasure = detectEventTemplate.type == DetectEventType.OFF_SEASON_TREASURE
  self.receive_reward_tips_text_type2:SetActive(isOffSeasonTreasure)
  self.receive_reward_tips_text:SetActive(not isOffSeasonTreasure)
  local textReceiveRewardTips
  if isOffSeasonTreasure then
    textReceiveRewardTips = self.receive_reward_tips_text_type2
    self.have_get_tips_text:SetColorHex("98D5FF")
  else
    textReceiveRewardTips = self.receive_reward_tips_text
    self.have_get_tips_text:SetColorHex("E1F8FF")
  end
  local selfClaimState = self.treasureClaimInfoDate:GetSelfClaimState()
  if selfClaimState == DetectEventTreasureClaimState.NoClaim then
    textReceiveRewardTips:SetLocalText("radar_tips_4")
  elseif selfClaimState == DetectEventTreasureClaimState.NormalClaim then
    textReceiveRewardTips:SetLocalText("radar_tips_5")
  elseif isOffSeasonTreasure then
    local multiple = self.treasureClaimInfoDate:GetSelfBigRewardMultiple()
    if multiple then
      textReceiveRewardTips:SetLocalText("s1_qingdian_double_banner", multiple)
    else
      textReceiveRewardTips:SetText("")
    end
  else
    textReceiveRewardTips:SetLocalText("radar_tips_6")
  end
  self.show_reward_list = {}
  local showRewardStr = detectEventTemplate.show_reward
  local showRewardDataList = string.string2array_i(showRewardStr, ";", "|")
  for i = 1, #showRewardDataList do
    if #showRewardDataList[i] == 3 then
      local itemData = {}
      itemData.rewardType = showRewardDataList[i][1]
      itemData.itemId = showRewardDataList[i][2]
      itemData.count = showRewardDataList[i][3]
      table.insert(self.show_reward_list, itemData)
    end
  end
  local curNum = DataCenter.ActDetectTreasureDataManager:GetCurDigTimes(self.treasureClaimInfoDate.eventId)
  local maxNum = DataCenter.ActDetectTreasureDataManager:GetMaxDigTimes(self.treasureClaimInfoDate.eventId)
  self.have_get_tips_text:SetLocalText("activity_sports_uitips_014", (string.format("%s/%s", curNum, maxNum)))
  self:RefreshConfigShowData()
  self:ShowReward()
  self:ShowClaimPlayerInfo()
end

function UILWActDetectEventTreasureClaimInfoNewView:RefreshConfigShowData()
  local detectEventTemplate = DataCenter.DetectEventTemplateManager:GetDetectEventTemplate(tostring(self.treasureClaimInfoDate.eventId))
  if detectEventTemplate == nil then
    return
  end
  local dataStr = detectEventTemplate.bg_para
  if string.IsNullOrEmpty(dataStr) then
    return
  end
  local dataList = string.split(dataStr, "|")
  if #dataList == 7 then
    local path = string.format(LoadPath.ActRadarRawImg, dataList[1])
    self.common_bg_orange:LoadSpriteAuto(path)
    path = string.format(LoadPath.ActRadarRawImg, dataList[2])
    self.bg_icon_raw:LoadSpriteAuto(path)
    local colorList = string.string2array_i_oneSep(dataList[3], ",")
    if #colorList == 4 then
      self.receive_reward_tips_content:SetColorRGBA255(colorList[1], colorList[2], colorList[3], colorList[4])
    end
    colorList = string.string2array_i_oneSep(dataList[4], ",")
    if #colorList == 4 then
      self.like_bg:SetColorRGBA255(colorList[1], colorList[2], colorList[3], colorList[4])
    end
    path = string.format(LoadPath.ActRadarRawImg, dataList[5])
    self.like_icon:LoadSpriteAuto(path)
    path = string.format(UIAssets.UIActDetectTreasureSpritePath, dataList[6])
    self.common_bg_orange2:LoadSpriteAsync(path)
  end
end

function UILWActDetectEventTreasureClaimInfoNewView:ShowReward()
  local rewardCount = table.count(self.show_reward_list)
  self:ClearRewardScroll()
  if 0 < rewardCount then
    self.reward_scroll_view:SetTotalCount(rewardCount)
    self.reward_scroll_view:RefillCells()
  end
end

function UILWActDetectEventTreasureClaimInfoNewView:OnRewardItemMoveIn(itemObj, index)
  itemObj.name = tostring(index)
  local itemRender = self.reward_scroll_view:AddComponent(UICommonResItem, itemObj)
  itemRender:ReInit(self.show_reward_list[index])
  itemRender:SetLocalScaleXYZ(0.75, 0.75, 0.75)
end

function UILWActDetectEventTreasureClaimInfoNewView:OnRewardItemMoveOut(itemObj, index)
  self.reward_scroll_view:RemoveComponent(itemObj.name, UICommonResItem)
end

function UILWActDetectEventTreasureClaimInfoNewView:ClearRewardScroll()
  self.reward_scroll_view:ClearCells()
  self.reward_scroll_view:RemoveComponents(UICommonResItem)
end

function UILWActDetectEventTreasureClaimInfoNewView:ShowClaimPlayerInfo()
  self.playerInfoList = self.treasureClaimInfoDate.treasureClaimPlayerInfoList
  table.sort(self.playerInfoList, function(a, b)
    return a.costTime < b.costTime
  end)
  self:ClearClaimPlayerInfoScroll()
  local playerCount = table.count(self.playerInfoList)
  if 0 < playerCount then
    self.player_scroll_view:SetTotalCount(playerCount)
    self.player_scroll_view:RefillCells()
  end
end

function UILWActDetectEventTreasureClaimInfoNewView:OnPlayerItemMoveIn(itemObj, index)
  itemObj.name = tostring(index)
  local itemRender = self.player_scroll_view:AddComponent(UILWActDetectEventTreasureClaimInfoNewPlayerItemRender, itemObj)
  itemRender:ReInit(self.playerInfoList[index], self.treasureClaimInfoDate.eventId)
end

function UILWActDetectEventTreasureClaimInfoNewView:OnPlayerItemMoveOut(itemObj, index)
  self.player_scroll_view:RemoveComponent(itemObj.name, UILWActDetectEventTreasureClaimInfoNewPlayerItemRender)
end

function UILWActDetectEventTreasureClaimInfoNewView:ClearClaimPlayerInfoScroll()
  self.player_scroll_view:ClearCells()
  self.player_scroll_view:RemoveComponents(UILWActDetectEventTreasureClaimInfoNewPlayerItemRender)
end

function UILWActDetectEventTreasureClaimInfoNewView:OnLikeClick()
  DataCenter.LWSoundManager:PlayEffect(SoundAssetId.SFX_UI_General_Click_1st)
  local eventId = self.treasureClaimInfoDate.eventId
  local uid = self.treasureClaimInfoDate.ownerInfo.uid
  local uuid = self.treasureClaimInfoDate.uuid
  local detectEventTemplate = DataCenter.DetectEventTemplateManager:GetDetectEventTemplate(tostring(self.treasureClaimInfoDate.eventId))
  local thumbsUpType
  if detectEventTemplate.type == DetectEventType.OFF_SEASON_TREASURE then
    thumbsUpType = InteractiveUtil.ThumbsUpType.OffSeasonDetect
  else
    thumbsUpType = InteractiveUtil.ThumbsUpType.ActRadarTreasure
  end
  InteractiveUtil.TryThumbsUp(uid, thumbsUpType, tostring(eventId), function()
    UIUtil.ShowTipsId("activity_sports_uitips_021")
  end, tostring(uuid))
end

return UILWActDetectEventTreasureClaimInfoNewView
