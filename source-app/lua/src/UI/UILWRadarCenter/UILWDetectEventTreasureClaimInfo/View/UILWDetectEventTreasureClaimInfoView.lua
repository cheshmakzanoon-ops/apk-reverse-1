local UILWDetectEventTreasureClaimInfoView = BaseClass("UILWDetectEventTreasureClaimInfoView", UIBaseView)
local base = UIBaseView
local Localization = CS.GameEntry.Localization
local UILWDetectEventTreasureClaimPlayerItemRender = require("UI.UILWRadarCenter.UILWDetectEventTreasureClaimInfo.Component.UILWDetectEventTreasureClaimPlayerItemRender")
local UILuckyBuffFromTipsComponent = require("UI/UILWRadarCenter/UILWDetectEventTreasureClaimInfo/Component/UILuckyBuffFromTipsComponent")
local panel_btn_path = "PanelBtn"
local root_content_path = "Content"
local title_text_path = "Content/TitleText"
local reward_tips_text_path = "Content/RewardTipsText"
local close_tips_text_path = "Content/CloseTipsText"
local bg_raw_image_path = "Content/BgRawImage"
local close_btn_path = "Content/CloseBtn"
local owner_player_head_path = "Content/OwnerPlayerHead"
local owner_player_name_text_path = "Content/OwnerPlayerNameText"
local reward_scroll_view_path = "Content/RewardScrollView"
local receive_reward_tips_text_path = "Content/ReceiveRewardTipsContent/ReceiveRewardTipsText"
local player_scroll_view_path = "Content/PlayerScrollView"
local multi_reward_text_path = "Content/MultiRewardText"

function UILWDetectEventTreasureClaimInfoView:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self.treasureClaimInfoDate = self:GetUserData()
  self:RefreshView()
end

function UILWDetectEventTreasureClaimInfoView:OnDestroy()
  self:ComponentDestroy()
  self.luckyBuffSenderInfo = nil
  self.luckyBuffFromTipsPos = nil
  base.OnDestroy(self)
end

function UILWDetectEventTreasureClaimInfoView:ComponentDefine()
  self.root_content = self:AddComponent(UIBaseContainer, root_content_path)
  self.title_text = self:AddComponent(UITextMeshProUGUIEx, title_text_path)
  self.title_text:SetLocalText("radar_title_1")
  self.reward_tips_text = self:AddComponent(UITextMeshProUGUIEx, reward_tips_text_path)
  self.reward_tips_text:SetLocalText("100349")
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
  self.player_scroll_view = self:AddComponent(UIScrollView, player_scroll_view_path)
  self.player_scroll_view:SetOnItemMoveIn(function(itemObj, index)
    self:OnPlayerItemMoveIn(itemObj, index)
  end)
  self.player_scroll_view:SetOnItemMoveOut(function(itemObj, index)
    self:OnPlayerItemMoveOut(itemObj, index)
  end)
  self.multiRewardText = self:AddComponent(UIText, multi_reward_text_path)
end

function UILWDetectEventTreasureClaimInfoView:ComponentDestroy()
  self.root_content = nil
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
  self.multiRewardText = nil
end

function UILWDetectEventTreasureClaimInfoView:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.RefreshDetectEventGetTreasureClaimInfo, self.OnRefreshClaimInfoView)
end

function UILWDetectEventTreasureClaimInfoView:OnRemoveListener()
  self:RemoveUIListener(EventId.RefreshDetectEventGetTreasureClaimInfo, self.OnRefreshClaimInfoView)
  base.OnRemoveListener(self)
end

function UILWDetectEventTreasureClaimInfoView:OnRefreshClaimInfoView(data)
  self.treasureClaimInfoDate = data
  self:RefreshView()
end

function UILWDetectEventTreasureClaimInfoView:RefreshView()
  if self.treasureClaimInfoDate == nil then
    Logger.LogError("\230\137\147\229\188\128\230\140\150\230\142\152\229\174\157\232\151\143\231\154\132\232\174\176\229\189\149\231\149\140\233\157\162\230\149\176\230\141\174\228\184\186\231\169\186")
    return
  end
  local detectEventTemplate = DataCenter.DetectEventTemplateManager:GetDetectEventTemplate(tostring(self.treasureClaimInfoDate.eventId))
  if detectEventTemplate ~= nil then
    self.bg_raw_image:LoadSprite(detectEventTemplate.pic)
  end
  local uid = self.treasureClaimInfoDate.ownerInfo.uid
  local pic = self.treasureClaimInfoDate.ownerInfo.headPic
  local picVer = self.treasureClaimInfoDate.ownerInfo.headPicVer
  local headSkinId = self.treasureClaimInfoDate.ownerInfo.headSkinId
  local headSkinET = self.treasureClaimInfoDate.ownerInfo.headSkinET
  self.owner_player_head:SetHeadAndFrame(uid, pic, picVer, nil, headSkinId, headSkinET)
  local showName = DataCenter.PlayerInfoDataManager:GetRemarkOrRealName(uid, self.treasureClaimInfoDate.ownerInfo.name)
  self.owner_player_name_text:SetText(showName)
  local selfClaimState = self.treasureClaimInfoDate:GetSelfClaimState()
  if selfClaimState == DetectEventTreasureClaimState.NoClaim then
    self.receive_reward_tips_text:SetLocalText("radar_tips_4")
  elseif selfClaimState == DetectEventTreasureClaimState.NormalClaim then
    if self.treasureClaimInfoDate:GetSelfIsTriggerLuckyBuff() then
      self.receive_reward_tips_text:SetLocalText("luckyBuff_desc_diggerReward2", self.treasureClaimInfoDate:GetSelfLuckyBuffMultiple())
    else
      self.receive_reward_tips_text:SetLocalText("radar_tips_5")
    end
  elseif self.treasureClaimInfoDate:GetSelfIsTriggerLuckyBuff() then
    self.receive_reward_tips_text:SetLocalText("luckyBuff_desc_diggerReward2", self.treasureClaimInfoDate:GetSelfLuckyBuffMultiple())
  else
    self.receive_reward_tips_text:SetLocalText("radar_tips_6")
  end
  self:ShowReward()
  self:ShowClaimPlayerInfo()
  self:RefreshMultiRewardInfo()
end

function UILWDetectEventTreasureClaimInfoView:ShowReward()
  local rewardCount = table.count(self.treasureClaimInfoDate.rewardList)
  self:ClearRewardScroll()
  if 0 < rewardCount then
    self.reward_scroll_view:SetTotalCount(rewardCount)
    self.reward_scroll_view:RefillCells()
  end
end

function UILWDetectEventTreasureClaimInfoView:OnRewardItemMoveIn(itemObj, index)
  itemObj.name = tostring(index)
  local itemRender = self.reward_scroll_view:AddComponent(UICommonResItem, itemObj)
  itemRender:ReInit(self.treasureClaimInfoDate.rewardList[index])
  itemRender:SetLocalScaleXYZ(0.75, 0.75, 0.75)
end

function UILWDetectEventTreasureClaimInfoView:OnRewardItemMoveOut(itemObj, index)
  self.reward_scroll_view:RemoveComponent(itemObj.name, UICommonResItem)
end

function UILWDetectEventTreasureClaimInfoView:ClearRewardScroll()
  self.reward_scroll_view:ClearCells()
  self.reward_scroll_view:RemoveComponents(UICommonResItem)
end

function UILWDetectEventTreasureClaimInfoView:ShowClaimPlayerInfo()
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

function UILWDetectEventTreasureClaimInfoView:OnPlayerItemMoveIn(itemObj, index)
  itemObj.name = tostring(index)
  local itemRender = self.player_scroll_view:AddComponent(UILWDetectEventTreasureClaimPlayerItemRender, itemObj)
  itemRender:ReInit(self.playerInfoList[index])
end

function UILWDetectEventTreasureClaimInfoView:OnPlayerItemMoveOut(itemObj, index)
  self.player_scroll_view:RemoveComponent(itemObj.name, UILWDetectEventTreasureClaimPlayerItemRender)
end

function UILWDetectEventTreasureClaimInfoView:ClearClaimPlayerInfoScroll()
  self.player_scroll_view:ClearCells()
  self.player_scroll_view:RemoveComponents(UILWDetectEventTreasureClaimPlayerItemRender)
end

function UILWDetectEventTreasureClaimInfoView:RefreshMultiRewardInfo()
  if self.treasureClaimInfoDate and self.treasureClaimInfoDate.createTime then
    local receiveNumberMulti = MultiRewardDropUtils.GetCurRadarTreasureReceiveMultiValue(self.treasureClaimInfoDate.createTime / 1000)
    if receiveNumberMulti and 1 < receiveNumberMulti then
      self.multiRewardText:SetActive(true)
      self.multiRewardText:SetLocalText("activity_multiple_tips2", receiveNumberMulti)
    else
      self.multiRewardText:SetActive(false)
    end
  else
    self.multiRewardText:SetActive(false)
  end
end

function UILWDetectEventTreasureClaimInfoView:ShowLuckyBuffFromTips(senderInfo, clickPos)
  if not senderInfo or not clickPos then
    if self.luckyBuffFromTipsComponent then
      self.luckyBuffFromTipsComponent:SetActive(false)
    end
    return
  end
  self.luckyBuffSenderInfo = senderInfo
  self.luckyBuffFromTipsPos = clickPos
  if not self.luckyBuffFromTipsReq then
    self.luckyBuffFromTipsReq = self:GameObjectInstantiateAsync("Assets/Main/Prefabs/UI/UILuckyBuff/UILuckyBuffFromTips.prefab", function(request)
      if request.isError then
        self:GameObjectDestroy(self.luckyBuffFromTipsReq)
        self.luckyBuffFromTipsReq = nil
        return
      end
      local _go = request.gameObject
      local pTF = _go.transform
      pTF:SetParent(self.root_content.transform)
      pTF:Set_localPosition(0, 0, 0)
      pTF:Set_localScale(1, 1, 1)
      pTF:Set_offsetMin(0, 0)
      pTF:Set_offsetMax(0, 0)
      self.luckyBuffFromTipsComponent = self.root_content:AddComponent(UILuckyBuffFromTipsComponent, _go.name)
      self.luckyBuffFromTipsComponent:SetDataAndPosition(self.luckyBuffSenderInfo, self.luckyBuffFromTipsPos)
    end)
  elseif self.luckyBuffFromTipsComponent then
    self.luckyBuffFromTipsComponent:SetActive(true)
    self.luckyBuffFromTipsComponent:SetDataAndPosition(self.luckyBuffSenderInfo, self.luckyBuffFromTipsPos)
  end
end

return UILWDetectEventTreasureClaimInfoView
