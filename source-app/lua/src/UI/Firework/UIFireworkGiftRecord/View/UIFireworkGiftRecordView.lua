local base = UIBaseView
local UIFireworkGiftRecordView = BaseClass("UIFireworkGiftRecordView", base)
local UIFireworkGiftRecordItemRender = require("UI.Firework.UIFireworkGiftRecord.Component.UIFireworkGiftRecordItemRender")
local LWFireworkGiftRecordInfo = require("DataCenter.LWFirework.LWFireworkGiftRecordInfo")
local UICommonResItem = require("UI.UICommonResItem.UICommonResItemV2.UICommonResItem")
local Localization = CS.GameEntry.Localization
local RewardUtil = require("Util.RewardUtil")
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
local player_scroll_view_path = "Content/PlayerScrollView"
local multiRewardText_path = "Content/MultiRewardText"

local function OnCreate(self)
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

local function OnDestroy(self)
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

local function OnEnable(self)
  base.OnEnable(self)
  if self.viewData then
    SFSNetwork.SendMessage(MsgDefines.GetFireworksGiftRecord, self.viewData)
  end
end

local function OnDisable(self)
  base.OnDisable(self)
end

local function ComponentDefine(self)
  self.panel_btn = self:AddComponent(UIButton, panel_btn_path)
  self.title_text = self:AddComponent(UIText, title_text_path)
  self.reward_tips_text = self:AddComponent(UIText, reward_tips_text_path)
  self.close_tips_text = self:AddComponent(UIText, close_tips_text_path)
  self.bg_raw_image = self:AddComponent(UIRawImage, bg_raw_image_path)
  self.close_btn = self:AddComponent(UIButton, close_btn_path)
  self.owner_player_head = self:AddComponent(UIBaseContainer, owner_player_head_path)
  self.owner_player_name_text = self:AddComponent(UIText, owner_player_name_text_path)
  self.reward_scroll_view = self:AddComponent(UIScrollView, reward_scroll_view_path)
  self.receive_reward_tips_text = self:AddComponent(UIText, receive_reward_tips_text_path)
  self.player_scroll_view = self:AddComponent(UIScrollView, player_scroll_view_path)
  self.multiRewardText = self:AddComponent(UIText, multiRewardText_path)
  self.receive_reward_tips_text = self:AddComponent(UITextMeshProUGUIEx, receive_reward_tips_text_path)
  self.receive_reward_tips_text:OnPointerClick(function(evtData)
    self:OnTxtPointerClick(evtData)
  end)
  self.panel_btn:SetOnClick(function()
    self.ctrl:CloseSelf()
  end)
  self.close_btn:SetOnClick(function()
    self.ctrl:CloseSelf()
  end)
  self.owner_player_head = self:AddComponent(UICommonHead, owner_player_head_path)
  self.reward_scroll_view:SetOnItemMoveIn(function(itemObj, index)
    self:OnRewardItemMoveIn(itemObj, index)
  end)
  self.reward_scroll_view:SetOnItemMoveOut(function(itemObj, index)
    self:OnRewardItemMoveOut(itemObj, index)
  end)
  self.player_scroll_view:SetOnItemMoveIn(function(itemObj, index)
    self:OnPlayerItemMoveIn(itemObj, index)
  end)
  self.player_scroll_view:SetOnItemMoveOut(function(itemObj, index)
    self:OnPlayerItemMoveOut(itemObj, index)
  end)
  self.title_text:SetLocalText("firework_interface_1005")
  self.reward_tips_text:SetLocalText("firework_interface_1006")
end

local function ComponentDestroy(self)
  self:ClearRewardScroll()
  self:ClearClaimPlayerInfoScroll()
  self.panel_btn = nil
  self.title_text = nil
  self.reward_tips_text = nil
  self.close_tips_text = nil
  self.bg_raw_image = nil
  self.close_btn = nil
  self.owner_player_head = nil
  self.owner_player_name_text = nil
  self.reward_scroll_view = nil
  self.receive_reward_tips_text = nil
  self.player_scroll_view = nil
  self.multiRewardText = nil
end

local function DataDefine(self)
  self.viewData = self:GetUserData()
  self.serverData = nil
end

local function DataDestroy(self)
  self.viewData = nil
  self.serverData = nil
end

function UIFireworkGiftRecordView:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.FireworkGetFireworksGiftRecord, self.OnFireworkGetFireworksGiftRecord)
end

function UIFireworkGiftRecordView:OnRemoveListener()
  self:RemoveUIListener(EventId.FireworkGetFireworksGiftRecord, self.OnFireworkGetFireworksGiftRecord)
  base.OnRemoveListener(self)
end

function UIFireworkGiftRecordView:OnFireworkGetFireworksGiftRecord(data)
  self.serverData = data
  self.fireworkGiftRecordInfo = LWFireworkGiftRecordInfo.New()
  self.fireworkGiftRecordInfo:InitData(self.serverData)
  self:RefreshView()
end

function UIFireworkGiftRecordView:RefreshView()
  if self.fireworkGiftRecordInfo == nil then
    return
  end
  local uid = self.fireworkGiftRecordInfo.senderInfo.uid
  local pic = self.fireworkGiftRecordInfo.senderInfo.pic
  local picVer = self.fireworkGiftRecordInfo.senderInfo.picVer
  local headSkinId = self.fireworkGiftRecordInfo.senderInfo.headSkinId
  local headSkinET = self.fireworkGiftRecordInfo.senderInfo.headSkinET
  self.owner_player_head:SetHeadAndFrame(uid, pic, picVer, nil, headSkinId, headSkinET)
  self.owner_player_head:SetEnableClickShowInfo(true, true)
  local showName = DataCenter.PlayerInfoDataManager:GetRemarkOrRealName(uid, self.fireworkGiftRecordInfo.senderInfo.name)
  self.owner_player_name_text:SetText(showName)
  local selfClaimState = self.fireworkGiftRecordInfo:GetSelfClaimState()
  if selfClaimState == DetectEventTreasureClaimState.NoClaim then
    local remainNum = self.fireworkGiftRecordInfo:GetRemainNum()
    if 0 < remainNum then
      self.receive_reward_tips_text:SetText(string.format("<u>%s</u>", Localization:GetString("firework_tips_1012", remainNum)))
    else
      self.receive_reward_tips_text:SetLocalText("firework_interface_1007")
    end
  elseif selfClaimState == DetectEventTreasureClaimState.NormalClaim then
    self.receive_reward_tips_text:SetLocalText("firework_interface_1012")
  else
    self.receive_reward_tips_text:SetLocalText("firework_interface_1013")
  end
  self:ShowReward()
  self:ShowClaimPlayerInfo()
end

function UIFireworkGiftRecordView:ShowReward()
  local rewardId = self.fireworkGiftRecordInfo.rewardId
  self.rewardList = RewardUtil.GetRewardItemAndResource(rewardId, ";")
  local rewardCount = table.count(self.rewardList)
  self:ClearRewardScroll()
  if 0 < rewardCount then
    self.reward_scroll_view:SetTotalCount(rewardCount)
    self.reward_scroll_view:RefillCells()
  end
end

function UIFireworkGiftRecordView:OnRewardItemMoveIn(itemObj, index)
  itemObj.name = tostring(index)
  local itemRender = self.reward_scroll_view:AddComponent(UICommonResItem, itemObj)
  itemRender:ReInit(self.rewardList[index])
  itemRender:SetLocalScaleXYZ(0.75, 0.75, 0.75)
end

function UIFireworkGiftRecordView:OnRewardItemMoveOut(itemObj, index)
  self.reward_scroll_view:RemoveComponent(itemObj.name, UICommonResItem)
end

function UIFireworkGiftRecordView:ClearRewardScroll()
  self.reward_scroll_view:ClearCells()
  self.reward_scroll_view:RemoveComponents(UICommonResItem)
end

function UIFireworkGiftRecordView:ShowClaimPlayerInfo()
  self.playerInfoList = self.fireworkGiftRecordInfo.recordPlayerInfoList
  table.sort(self.playerInfoList, function(a, b)
    return a.time < b.time
  end)
  self:ClearClaimPlayerInfoScroll()
  local playerCount = table.count(self.playerInfoList)
  if 0 < playerCount then
    self.player_scroll_view:SetTotalCount(playerCount)
    self.player_scroll_view:RefillCells()
  end
end

function UIFireworkGiftRecordView:OnPlayerItemMoveIn(itemObj, index)
  itemObj.name = tostring(index)
  local itemRender = self.player_scroll_view:AddComponent(UIFireworkGiftRecordItemRender, itemObj)
  itemRender:ReInit(self.playerInfoList[index])
end

function UIFireworkGiftRecordView:OnPlayerItemMoveOut(itemObj, index)
  self.player_scroll_view:RemoveComponent(itemObj.name, UIFireworkGiftRecordItemRender)
end

function UIFireworkGiftRecordView:ClearClaimPlayerInfoScroll()
  self.player_scroll_view:ClearCells()
  self.player_scroll_view:RemoveComponents(UIFireworkGiftRecordItemRender)
end

function UIFireworkGiftRecordView:RefreshMultiRewardInfo()
  if self.fireworkGiftRecordInfo then
    local receiveNumberMulti = MultiRewardDropUtils.GetCurRadarTreasureReceiveMultiValue(self.fireworkGiftRecordInfo.createTime / 1000)
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

function UIFireworkGiftRecordView:OnTxtPointerClick(evtData)
  if self.fireworkGiftRecordInfo then
    local selfClaimState = self.fireworkGiftRecordInfo:GetSelfClaimState()
    if selfClaimState == DetectEventTreasureClaimState.NoClaim then
      local remainNum = self.fireworkGiftRecordInfo:GetRemainNum()
      if 0 < remainNum then
        local data = {
          uuid = self.fireworkGiftRecordInfo.uuid,
          ownerUid = self.fireworkGiftRecordInfo.ownerUid
        }
        SFSNetwork.SendMessage(MsgDefines.FindFireworksGiftWorldPoint, data)
      end
    end
  end
end

UIFireworkGiftRecordView.OnCreate = OnCreate
UIFireworkGiftRecordView.OnDestroy = OnDestroy
UIFireworkGiftRecordView.OnEnable = OnEnable
UIFireworkGiftRecordView.OnDisable = OnDisable
UIFireworkGiftRecordView.ComponentDefine = ComponentDefine
UIFireworkGiftRecordView.ComponentDestroy = ComponentDestroy
UIFireworkGiftRecordView.DataDefine = DataDefine
UIFireworkGiftRecordView.DataDestroy = DataDestroy
return UIFireworkGiftRecordView
