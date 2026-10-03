local UILWActConcertRewardRecordView = BaseClass("UILWActConcertRewardRecordView", UIBaseView)
local M = UILWActConcertRewardRecordView
local base = UIBaseView
local Localization = CS.GameEntry.Localization
local UILWActDetectEventTreasureClaimInfoPlayerItemRender = require("UI.UIActConcert.UILWActConcertRewardRecord.Component.UILWActConcertRewardRecordClaimInfoPlayerItemRender")
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
local have_get_tips_text_path = "Content/HaveGetTipsText"

function M:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self.recordData = self:GetUserData()
  self:RefreshView()
  SFSNetwork.SendMessage(MsgDefines.SkinPartyReceivePlayers, self.recordData.ownerUid, self.recordData.statusId, self.recordData.expiredTime)
end

function M:OnDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function M:ComponentDefine()
  self.title_text = self:AddComponent(UITextMeshProUGUIEx, title_text_path)
  self.title_text:SetLocalText("activity_concert_13")
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
  self.player_scroll_view = self:AddComponent(UIScrollView, player_scroll_view_path)
  self.player_scroll_view:SetOnItemMoveIn(function(itemObj, index)
    self:OnPlayerItemMoveIn(itemObj, index)
  end)
  self.player_scroll_view:SetOnItemMoveOut(function(itemObj, index)
    self:OnPlayerItemMoveOut(itemObj, index)
  end)
  self.have_get_tips_text = self:AddComponent(UITextMeshProUGUIEx, have_get_tips_text_path)
end

function M:ComponentDestroy()
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
end

function M:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.PlayerMessageInfo, self.UpdatePlayerHeadAndName)
  self:AddUIListener(EventId.BuildMainPartyRewardRecordRefresh, self.ShowClaimPlayerInfo)
end

function M:OnRemoveListener()
  base.OnRemoveListener(self)
  self:RemoveUIListener(EventId.PlayerMessageInfo, self.UpdatePlayerHeadAndName)
  self:RemoveUIListener(EventId.BuildMainPartyRewardRecordRefresh, self.ShowClaimPlayerInfo)
end

function M:OnRefreshClaimInfoView(data)
  self.recordData = data
  self:RefreshView()
end

function M:RefreshView()
  if self.recordData == nil then
    Logger.LogError("\233\159\179\228\185\144\232\138\130  \230\137\147\229\188\128\232\174\176\229\189\149\231\149\140\233\157\162\230\149\176\230\141\174\228\184\186\231\169\186")
    return
  end
  local concertConfig = self.recordData.concertConfig
  local detectEventTemplate = DataCenter.DetectEventTemplateManager:GetDetectEventTemplate(concertConfig.detectEventId)
  if detectEventTemplate ~= nil then
    self.bg_raw_image:LoadSpriteAsync(detectEventTemplate.pic)
  end
  self:UpdatePlayerHeadAndName(self.recordData.ownerUid)
  if self.recordData.remainingNum <= 0 then
    local recordKey = self.recordData.ownerUid .. "_" .. self.recordData.statusId .. "_" .. self.recordData.expiredTime
    local hasGot = DataCenter.ActConcertDataManager:HasGotBuildMainReward(recordKey)
    if hasGot then
      self.receive_reward_tips_text:SetLocalText("radar_tips_5")
    else
      self.receive_reward_tips_text:SetLocalText("radar_tips_4")
    end
  else
    self.receive_reward_tips_text:SetText("")
  end
  self.have_get_tips_text:SetLocalText("activity_sports_uitips_014", (string.format("%s/%s", self.recordData.maxClaimCount - self.recordData.remainingNum, self.recordData.maxClaimCount)))
  self:ShowReward()
  self:ClearClaimPlayerInfoScroll()
end

function M:UpdatePlayerHeadAndName(uid)
  if uid == self.recordData.ownerUid then
    local userinfo = ChatInterface.getUserData(uid, true)
    if userinfo ~= nil then
      local userPic = userinfo.headPic or ""
      local userPicVer = userinfo.headPicVer or 0
      local headSkinId = userinfo.headSkinId or 0
      local headSkinET = userinfo.headSkinET or 0
      self.owner_player_head:ShowLoadingAinmation()
      self.owner_player_head:SetCustomLoadCallback(function()
        self.owner_player_head:HideLoadingAinmation()
      end)
      self.owner_player_head:SetHeadAndFrame(uid, userPic, userPicVer, nil, headSkinId, headSkinET)
      local userName = userinfo.userName or ""
      local showName = DataCenter.PlayerInfoDataManager:GetRemarkOrRealName(self.recordData.ownerUid, userName)
      self.owner_player_name_text:SetText(showName)
    end
  end
end

function M:ShowReward()
  local concertConfig = self.recordData.concertConfig
  local bubbleReward = concertConfig.bubble_reward
  if string.IsNullOrEmpty(bubbleReward) then
    Logger.LogError("\233\159\179\228\185\144\232\138\130  \233\133\141\231\189\174\232\175\187\229\143\150\233\148\153\232\175\175")
    return
  end
  local line = LocalController:instance():getLine(TableName.RewardConfig, bubbleReward)
  if line == nil then
    Logger.LogError("\233\159\179\228\185\144\232\138\130  \233\133\141\231\189\174\232\175\187\229\143\150\233\148\153\232\175\175")
    return result
  end
  self.show_reward_list = {}
  local itemValues = line:getValue("item") or ""
  local numValues = line:getValue("num") or ""
  if not string.IsNullOrEmpty(itemValues) and not string.IsNullOrEmpty(numValues) then
    local ids = string.split(itemValues, ";")
    local nums = string.split(numValues, ";")
    if ids ~= nil and 0 < #ids then
      for i, id in pairs(ids) do
        local oneData = {}
        oneData.itemId = id
        oneData.count = nums[i] or 0
        oneData.rewardType = RewardType.GOODS
        table.insert(self.show_reward_list, oneData)
      end
    end
  end
  local rewardCount = table.count(self.show_reward_list)
  self:ClearRewardScroll()
  if 0 < rewardCount then
    self.reward_scroll_view:SetTotalCount(rewardCount)
    self.reward_scroll_view:RefillCells()
  end
end

function M:OnRewardItemMoveIn(itemObj, index)
  itemObj.name = tostring(index)
  local itemRender = self.reward_scroll_view:AddComponent(UICommonResItem, itemObj)
  itemRender:ReInit(self.show_reward_list[index])
  itemRender:SetLocalScaleXYZ(0.75, 0.75, 0.75)
end

function M:OnRewardItemMoveOut(itemObj, index)
  self.reward_scroll_view:RemoveComponent(itemObj.name, UICommonResItem)
end

function M:ClearRewardScroll()
  self.reward_scroll_view:ClearCells()
  self.reward_scroll_view:RemoveComponents(UICommonResItem)
end

function M:ShowClaimPlayerInfo(t)
  local rewardRecordList = t.playerArr
  if rewardRecordList == nil or #rewardRecordList == 0 then
    return
  end
  self.playerInfoList = {}
  for i = 1, #rewardRecordList do
    local playerInfo = {}
    if rewardRecordList[i] then
      playerInfo.costTime = rewardRecordList[i].time or 0
      local info = rewardRecordList[i].info
      playerInfo.gender = info.gender
      playerInfo.headPic = info.pic
      playerInfo.headPicVer = info.picver
      playerInfo.headSkinET = info.headSkinET
      playerInfo.headSkinId = info.headSkinId
      playerInfo.isBigReward = false
      playerInfo.level = info.level
      playerInfo.name = info.name
      playerInfo.uid = info.uid
      local wholeRewardStr = ""
      local reward = DataCenter.RewardManager:ReturnRewardParamForMessage(rewardRecordList[i].reward)
      for j = 1, #reward do
        local num = reward[j].count or 0
        local rewardStr = reward[j].rewardType .. ";" .. reward[j].itemId .. ";" .. num
        wholeRewardStr = wholeRewardStr .. rewardStr
        if j < #reward then
          wholeRewardStr = wholeRewardStr .. "|"
        end
      end
      playerInfo.reward = wholeRewardStr
    end
    table.insert(self.playerInfoList, playerInfo)
  end
  table.sort(self.playerInfoList, function(a, b)
    return a.costTime < b.costTime
  end)
  local playerCount = table.count(self.playerInfoList)
  if 0 < playerCount then
    self.player_scroll_view:SetTotalCount(playerCount)
    self.player_scroll_view:RefillCells()
  end
end

function M:OnPlayerItemMoveIn(itemObj, index)
  itemObj.name = tostring(index)
  local itemRender = self.player_scroll_view:AddComponent(UILWActDetectEventTreasureClaimInfoPlayerItemRender, itemObj)
  itemRender:ReInit(self.playerInfoList[index])
end

function M:OnPlayerItemMoveOut(itemObj, index)
  self.player_scroll_view:RemoveComponent(itemObj.name, UILWActDetectEventTreasureClaimInfoPlayerItemRender)
end

function M:ClearClaimPlayerInfoScroll()
  self.player_scroll_view:ClearCells()
  self.player_scroll_view:RemoveComponents(UILWActDetectEventTreasureClaimInfoPlayerItemRender)
end

return M
