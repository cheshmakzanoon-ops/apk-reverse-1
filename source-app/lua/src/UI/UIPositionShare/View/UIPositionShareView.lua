local ShareItem = require("UI.UIPositionShare.Component.UIPositionShareItem")
local UIPositionShareView = BaseClass("UIPositionShareView", UIBaseView)
local base = UIBaseView
local Localization = CS.GameEntry.Localization
local UIPositionShare_RedPacketComponent = require("UI/UIPositionShare/Component/RedPacket/UIPositionShare_RedPacketComponent")
local txt_title_path = "UICommonPopUpTitle/Common_img_title/titleText"
local close_btn_path = "UICommonPopUpTitle/CloseBtn"
local return_btn_path = "UICommonPopUpTitle/panel"
local optionKey = "RedPacketCopyWorld"
local common_bg_orange_path = "UICommonPopUpTitle/Common_bg_orange"
local tip_text_path = "UICommonPopUpTitle/Common_bg_orange/TipText"
local mid_tip_text_path = "ImgBg/MidTipText"

local function OnCreate(self)
  base.OnCreate(self)
  local share_param = self:GetUserData()
  share_param = self.ctrl.GetParamByType(share_param)
  self.itemList = {}
  if type(share_param) == "table" then
    if share_param.worldId == nil then
      share_param.worldId = LuaEntry.Player:GetCurWorldId()
      share_param.worldType = LuaEntry.Player:GetCurWorldType()
      if BattleFieldUtil.InBattleField(BattleFieldType.Desert) then
        share_param.allianceId = LuaEntry.Player.allianceId
        share_param.actDragonGroup = DataCenter.ActDragonManager:GetCurGroupIdx()
      elseif BattleFieldUtil.InBattleField(BattleFieldType.EpidemicZone) then
        share_param.allianceId = LuaEntry.Player.allianceId
        share_param.actDragonGroup = DataCenter.ActEpidemicZoneManager:GetCurGroupIdx()
      elseif BattleFieldUtil.InBattleField(BattleFieldType.DsbDuel) then
        share_param.allianceId = LuaEntry.Player.allianceId
        share_param.actDragonGroup = BattlefieldDsbDuelUtils.GetCurrentTeam()
      end
    end
    if share_param.sid == nil then
      share_param.sid = LuaEntry.Player:GetCurServerId()
    end
  end
  self.chat_data_param = share_param
  self.txt_title = self:AddComponent(UIText, txt_title_path)
  self.txt_title:SetLocalText(110073)
  self.close_btn = self:AddComponent(UIButton, close_btn_path)
  self.close_btn:SetOnClick(function()
    self:CloseView()
  end)
  self.return_btn = self:AddComponent(UIButton, return_btn_path)
  self.return_btn:SetOnClick(function()
    self:CloseView()
  end)
  self.itemContent = self:AddComponent(UIBaseContainer, "ImgBg/Scroll_View_mainView/MainViewport/MainContent")
  self.ScrollView = self:AddComponent(UILoopListView2, "ImgBg/Scroll_View_mainView")
  self.ScrollView:InitListViewParam2(0, function(listview, index)
    return self:OnGetItemByIndex(listview, index)
  end, nil, nil, function(loopListViewItem)
    self:OnRecycleItemFunc(loopListViewItem)
  end)
  
  function self.ScrollView.unity_looplistview2.mOnEndDragAction()
    self:OnEndDrag()
  end
  
  self.list = {}
  self.bg_orange = self:AddComponent(UIBaseContainer, common_bg_orange_path)
  self.tip_text = self:AddComponent(UIText, tip_text_path)
  if share_param.tipText then
    self.tip_text:SetText(share_param.tipText)
    self.tip_text:SetActive(true)
  else
    self.tip_text:SetText(share_param.tipText)
    self.tip_text:SetActive(false)
  end
  self.txt_mid = self:AddComponent(UIText, mid_tip_text_path)
  self.txt_mid:SetActive(false)
  self.compDynamicRoot = self:AddComponent(UIBaseComponent, "ImgBg/Dynamic")
  self.compDynamicContent = self:AddComponent(UIBaseContainer, "ImgBg/Dynamic/DynamicContent")
  self.dynamicComp = nil
end

function UIPositionShareView:CloseView()
  if self.chat_data_param.post == PostType.NewsCenterLink and self.chat_data_param.isShowWeb then
    DataCenter.LWNewsCenterManager:ShowNewsWeb(self.chat_data_param.param.uuid, self.chat_data_param.openType, false)
  end
  self.ctrl:CloseSelf()
end

function UIPositionShareView:GetItemNameSequence()
  NameCount = NameCount + 1
  return tostring(NameCount)
end

function UIPositionShareView:OnGetItemByIndex(loopScroll, index)
  index = index + 1
  if index < 1 or index > #self.list then
    return nil
  end
  local prefabName = "UIPositionShareItem"
  local item = loopScroll:NewListViewItem(prefabName)
  if not item then
    return
  end
  local temp = self.itemList[item]
  if temp then
    temp:SetActive(true)
    if self.list[index].callback then
      temp:SetItemSimple(self.list[index])
    else
      temp:SetItemShow(self.list[index])
    end
  else
    local script = ShareItem
    local objectName = self:GetItemNameSequence()
    item.gameObject.name = objectName
    temp = self.itemContent:AddComponent(script, item.gameObject)
    temp:SetActive(true)
    if self.list[index].callback then
      temp:SetItemSimple(self.list[index])
    else
      temp:SetItemShow(self.list[index])
    end
    self.itemList[item] = temp
  end
  return item
end

function UIPositionShareView:OnRecycleItemFunc(loopListViewItem)
  if loopListViewItem == nil then
    return
  end
  local script = self.itemList[loopListViewItem]
  if script ~= nil then
    if script.OnRecycleItem then
      script:OnRecycleItem()
    end
    script:SetActive(false)
  end
end

function UIPositionShareView:OnEndDrag()
  if not ChatManager2:GetInstance().Room:GetIsNewPrivateList() then
    return
  end
  local containerTrans = self.ScrollView.unity_looplistview2.ContainerTrans
  if containerTrans.localPosition.y > containerTrans.rect.size.y - self.ScrollView.rectTransform.rect.size.y then
    ChatInterface.getRoomMgr():GetNewPrivateList(#self.list)
  end
end

local function OnDestroy(self)
  CommonUtil.PlayerPrefsSetBool(optionKey, self.isCopy)
  self.chat_data_param = nil
  self.txt_title = nil
  self.close_btn = nil
  self.return_btn = nil
  self.ScrollView = nil
  self.list = nil
  self.itemList = nil
  self.dynamicComp = nil
  base.OnDestroy(self)
end

local function RefreshList(self)
  local totalChatList = self.ctrl:GetChatList()
  self.compDynamicRoot:SetActive(false)
  self.ScrollView:SetOffsetMinXY(0, 0)
  self.ScrollView:SetOffsetMaxXY(0, 0)
  if self.chat_data_param.askVirusHelp then
    self.list = {}
    for _, chatItem in pairs(totalChatList) do
      if chatItem:isAllianceRoom() or chatItem:isPrivateChat() then
        table.insert(self.list, chatItem)
      end
    end
  elseif self.chat_data_param.postType == PostType.Text_ScoutReport or self.chat_data_param.postType == PostType.Text_Formation_Fight_Share then
    local canShareToWorld = LuaEntry.DataConfig:CheckSwitch("share_reportt")
    if canShareToWorld then
      self.list = totalChatList
    else
      self.list = {}
      for _, chatItem in pairs(totalChatList) do
        if not chatItem:isWorldRoom() then
          table.insert(self.list, chatItem)
        end
      end
    end
  elseif self.chat_data_param.postType == PostType.Text_AllianceTaskShare or self.chat_data_param.postType == PostType.Text_PointShare_Alliance then
    self.list = {}
    for _, chatItem in pairs(totalChatList) do
      if chatItem:isAllianceRoom() then
        table.insert(self.list, chatItem)
      end
    end
    if self.chat_data_param.postType == PostType.Text_PointShare_Alliance and self.chat_data_param.addWorldChannel then
      for _, chatItem in pairs(totalChatList) do
        if chatItem:isWorldRoom() then
          table.insert(self.list, chatItem)
        end
      end
    end
  elseif self.chat_data_param.postType == PostType.Activity_BargainShop then
    self.list = {}
    local selfServer = LuaEntry.Player:GetSourceServerId()
    local info
    for _, chatItem in pairs(totalChatList) do
      if chatItem:isAllianceRoom() then
        table.insert(self.list, chatItem)
      elseif chatItem:isPrivateChat() then
        info = chatItem:getPrivateOtherMember()
        if info and (info.serverId == 0 or info:getServerId() == selfServer or UIUtil.CheckDetectCanCrossServer()) then
          table.insert(self.list, chatItem)
        end
      elseif (chatItem:isWorldRoom() or chatItem:isLanguageRoom()) and (LuaEntry.Player:IsLoginSourceServer() or UIUtil.CheckDetectCanCrossServer()) then
        table.insert(self.list, chatItem)
      end
    end
  elseif self.chat_data_param.postType == PostType.TorchRelayCheer then
    self.list = {}
    for _, chatItem in pairs(totalChatList) do
      if chatItem:isAllianceRoom() or chatItem:isWorldRoom() or chatItem:isPrivateChat() or chatItem:isLanguageRoom() then
        table.insert(self.list, chatItem)
      end
    end
  elseif self.chat_data_param.post == PostType.Alliance_War or self.chat_data_param.post == PostType.GHOST_RECON_TASK_TEAM then
    self.list = {}
    local target = 0
    local userInfo
    for _, chatItem in pairs(totalChatList) do
      if chatItem:isAllianceRoom() then
        table.insert(self.list, chatItem)
      elseif chatItem:isPrivateChat() then
        target = chatItem:GetPrivateUser()
        userInfo = ChatInterface.getUserData(target)
        if userInfo and userInfo.allianceId and userInfo.allianceId == LuaEntry.Player:GetAllianceUid() then
          table.insert(self.list, chatItem)
        end
      end
    end
  elseif self.chat_data_param.post == PostType.StageFeatureHelpInvite then
    self.list = {}
    local target = 0
    local userInfo
    for _, chatItem in pairs(totalChatList) do
      if chatItem:isAllianceRoom() then
        table.insert(self.list, chatItem)
      elseif chatItem:isPrivateChat() then
        target = chatItem:GetPrivateUser()
        userInfo = ChatInterface.getUserData(target)
        if userInfo and userInfo.allianceId and userInfo.allianceId == LuaEntry.Player:GetAllianceUid() then
          table.insert(self.list, chatItem)
        end
      end
    end
  elseif self.chat_data_param.post == PostType.RedPackge_New then
    local template = DataCenter.RedPacketTemplateManager:GetTemplateByGoodsId(self.chat_data_param.redPocketId)
    if template ~= nil then
      self.list = {}
      for _, chatItem in pairs(totalChatList) do
        if chatItem:isAllianceRoom() and template:IsCanShareChannel(DataCenter.RedPacketManager.ChannelType.Alliance) then
          table.insert(self.list, chatItem)
        elseif chatItem:isWorldRoom() and template:IsCanShareChannel(DataCenter.RedPacketManager.ChannelType.World) then
          table.insert(self.list, chatItem)
        elseif chatItem:isSeasonRoom() and template:IsCanShareChannel(DataCenter.RedPacketManager.ChannelType.Season) then
          table.insert(self.list, chatItem)
        elseif chatItem:isAliFriendRoom() and template:IsCanShareChannel(DataCenter.RedPacketManager.ChannelType.AliFriend) then
          table.insert(self.list, chatItem)
        end
      end
      if 0 < template:GetCanCopyChannelCount() then
        self:CreateDynamicComponent(UIAssets.UIPositionShare_RedPacket, UIPositionShare_RedPacketComponent, self.chat_data_param.redPocketId)
      end
    end
  elseif self.chat_data_param.postType == PostType.SeasonTrendsShare then
    self.list = {}
    for _, chatItem in pairs(totalChatList) do
      if chatItem:isAllianceRoom() or chatItem:isWorldRoom() then
        table.insert(self.list, chatItem)
      end
    end
  elseif self.chat_data_param.postType == PostType.ActMigration then
    self.list = {}
    for _, chatItem in pairs(totalChatList) do
      if chatItem:isPrivateChat() then
        table.insert(self.list, chatItem)
      end
    end
    if #self.list == 0 then
      self.txt_mid:SetLocalText("migration_activity_interface_10118")
      self.txt_mid:SetActive(true)
    end
  elseif self.chat_data_param.postType == PostType.DiggingGameShareSingle then
    self.list = {}
    for _, chatItem in pairs(totalChatList) do
      if chatItem:isAllianceRoom() then
        table.insert(self.list, chatItem)
      end
    end
  elseif self.chat_data_param.postType == PostType.SeasonPhoto then
    self.list = {}
    if not self.chat_data_param.param.isMessage then
      local picData = {
        name = Localization:GetString("season_alliance_photo_UI_48"),
        icon = "Assets/Main/SeasonRes/Shared/Sprites/UISeasonPhoto/ljq_liaotian_xiazaitupian.png",
        callback = function()
          EventManager:GetInstance():Broadcast(EventId.SeasonPhotoSavePhoto, self.chat_data_param)
        end
      }
      self.list = {picData}
    end
    for _, chatItem in pairs(totalChatList) do
      if chatItem:isWorldRoom() or chatItem:isAllianceRoom() or chatItem:isLanguageRoom() or chatItem:isPrivateChat() then
        table.insert(self.list, chatItem)
      end
    end
  elseif self.chat_data_param.postType == PostType.Title then
    self.list = {}
    for _, chatItem in pairs(totalChatList) do
      if chatItem:isWorldRoom() or chatItem:isAllianceRoom() or chatItem:isLanguageRoom() or chatItem:isPrivateChat() then
        table.insert(self.list, chatItem)
      end
    end
  elseif self.chat_data_param.postType == PostType.STAGE_FEATURE_CHAPTER or self.chat_data_param.postType == PostType.FrontBreakSunday then
    self.list = {}
    for _, chatItem in pairs(totalChatList) do
      if chatItem:isAllianceRoom() or chatItem:isWorldRoom() or chatItem:isLanguageRoom() then
        table.insert(self.list, chatItem)
      end
    end
  elseif self.chat_data_param.postType == PostType.Chat_SendPhoto or self.chat_data_param.postType == PostType.T11IdleGameAllianceHelp then
    self.list = {}
    for _, chatItem in pairs(totalChatList) do
      if chatItem:isAllianceRoom() then
        table.insert(self.list, chatItem)
      end
    end
  elseif self.chat_data_param.postType == PostType.SeasonBankReport then
    self.list = {}
    for _, chatItem in pairs(totalChatList) do
      if chatItem:isWorldRoom() or chatItem:isAllianceRoom() or chatItem:isLanguageRoom() or chatItem:isPrivateChat() then
        table.insert(self.list, chatItem)
      end
    end
  elseif self.chat_data_param.postType == PostType.Season_BiuBiuInvite or self.chat_data_param.postType == PostType.Season_LittleGame_Invite then
    self.list = {}
    for _, chatItem in pairs(totalChatList) do
      if 0 < self.chat_data_param.param.betNum then
        if chatItem:isSeasonRoom() then
          table.insert(self.list, chatItem)
        end
      elseif chatItem:isAllianceRoom() or chatItem:isPrivateChat() then
        table.insert(self.list, chatItem)
      end
    end
  elseif self.chat_data_param.postType == PostType.Season_BiuBiuResult or self.chat_data_param.postType == PostType.Season_LittleGame_Result then
    self.list = {}
    for _, chatItem in pairs(totalChatList) do
      table.insert(self.list, chatItem)
    end
  elseif self.chat_data_param.postType == PostType.BF_WINTER_HISTORY_SHARE then
    self.list = {}
    for _, chatItem in pairs(totalChatList) do
      table.insert(self.list, chatItem)
    end
  else
    self.list = totalChatList
  end
  self:TryAddOtherShareType()
  self.ScrollView:StopMovement()
  self.ScrollView:SetListItemCount(#self.list, false, false)
  self.ScrollView.unity_looplistview2:RefreshAllShownItem()
end

local function OnEnable(self)
  base.OnEnable(self)
  self:RefreshList()
end

local function OnDisable(self)
  self.ScrollView:RecycleAllItem()
  base.OnDisable(self)
end

local function ClearScroll(self)
  self.ScrollView:RecycleAllItem()
end

local function OnAddListener(self)
  base.OnAddListener(self)
  self:AddUIListener(EventId.Chat_GetFriendList, self.RefreshList)
end

local function OnRemoveListener(self)
  base.OnRemoveListener(self)
  self:RemoveUIListener(EventId.Chat_GetFriendList, self.RefreshList)
end

local function OnItemClick(self, channel)
  if self.chat_data_param.post or self.chat_data_param.isShare then
    if self.chat_data_param.post == PostType.Text_StorageShopShare then
      local chatData = {}
      chatData.roomId = channel:getRoomId()
      chatData.post = self.chat_data_param.post
      chatData.param = self.chat_data_param
      if channel.group == ChatGroupType.GROUP_COUNTRY then
        DataCenter.StorageShopManager:TryShareStorageShop(chatData)
      else
        EventManager:GetInstance():Broadcast(ChatEventEnum.CHAT_SHARE_COMMAND, chatData)
      end
    elseif self.chat_data_param.post == PostType.Text_AllianceTaskShare then
      local chatData = {}
      chatData.roomId = channel:getRoomId()
      chatData.post = self.chat_data_param.post
      chatData.param = self.chat_data_param
      EventManager:GetInstance():Broadcast(ChatEventEnum.CHAT_SHARE_COMMAND, chatData)
    elseif self.chat_data_param.post == PostType.Alliance_War then
      local roomId = channel:getRoomId()
      local userId
      local channelType = ChatManager2:GetInstance().Room:GetChannelFromRoomId(roomId)
      if channelType == ChatShareChannel.TO_PERSON then
        userId = ChatManager2:GetInstance().Room:GetPrivateUserIdByRoomId(channel.name)
      end
      SFSNetwork.SendMessage(MsgDefines.SendRallyChat, self.chat_data_param.targetUid, userId and 2 or 1, userId)
    elseif self.chat_data_param.post == PostType.Activity_BargainShop then
      local chatData = {}
      chatData.roomId = channel:getRoomId()
      local shareType = DataCenter.ActBargainShopData:GetChannelFromRoomId(chatData.roomId)
      local userId
      if shareType == 3 then
        userId = ChatManager2:GetInstance().Room:GetPrivateUserIdByRoomId(chatData.roomId)
      end
      SFSNetwork.SendMessage(MsgDefines.BargainshareList, self.chat_data_param, userId, shareType, chatData.roomId)
    elseif self.chat_data_param.post == PostType.TorchRelayCheer then
      local chatData = {}
      chatData.roomId = channel:getRoomId()
      local shareType = DataCenter.ActBargainShopData:GetChannelFromRoomId(chatData.roomId)
      local userId
      if shareType == 3 then
        userId = ChatManager2:GetInstance().Room:GetPrivateUserIdByRoomId(chatData.roomId)
      end
      SFSNetwork.SendMessage(MsgDefines.ActivityTorchRelayToChat, self.chat_data_param.activityId, shareType, chatData.roomId)
    elseif self.chat_data_param.post == PostType.RedPackge_New then
      local chatType = 0
      if channel.group == ChatGroupType.GROUP_SEASON_ROOM then
        chatType = DataCenter.RedPacketManager.ChannelType.Season
      elseif channel.group == ChatGroupType.GROUP_COUNTRY then
        chatType = DataCenter.RedPacketManager.ChannelType.World
      elseif channel.group == ChatGroupType.GROUP_ALLIANCE then
        chatType = DataCenter.RedPacketManager.ChannelType.Alliance
      elseif channel.group == ChatGroupType.GROUP_ALLIANCE_FRIEND_ROOM then
        chatType = DataCenter.RedPacketManager.ChannelType.AliFriend
      end
      local isCopyToChat = false
      local copyChatChannelType = DataCenter.RedPacketManager.ChannelType.World
      if self.dynamicComp ~= nil and self.dynamicComp.GetIsCopyToChat ~= nil then
        isCopyToChat = self.dynamicComp:GetIsCopyToChat()
      end
      if isCopyToChat == true and self.dynamicComp ~= nil and self.dynamicComp.GetCopyChatChannelType ~= nil then
        copyChatChannelType = self.dynamicComp:GetCopyChatChannelType()
      end
      local redPocketType = self.chat_data_param.redPocketType
      if redPocketType == 3 then
        DataCenter.SeasonTradeShopDataManager:ReqUseRedPacket(self.chat_data_param.uid, chatType, isCopyToChat, copyChatChannelType)
      elseif redPocketType == RedPacketType.Birthday then
        local isInBirthdayVisible = true
        local curSetVisible = -1
        local setData = DataCenter.BirthdayDataManager:GetSetData()
        if setData then
          curSetVisible = setData.displayType
        end
        if curSetVisible == BirthdayShowArea.OnlySelf then
          isInBirthdayVisible = false
        elseif curSetVisible == BirthdayShowArea.Alliance then
          if channel.group == ChatGroupType.GROUP_COUNTRY then
            isInBirthdayVisible = false
          elseif not isCopyToChat then
            isInBirthdayVisible = false
          else
            isInBirthdayVisible = true
          end
        elseif curSetVisible == BirthdayShowArea.All then
          isInBirthdayVisible = true
        end
        if isInBirthdayVisible then
          SFSNetwork.SendMessage(MsgDefines.ItemUse, {
            uuid = self.chat_data_param.uid,
            num = self.chat_data_param.count,
            chatType = chatType,
            copy = isCopyToChat,
            copyChatType = copyChatChannelType
          })
        else
          local visibleName = DataCenter.BirthdayDataManager:GetVisibleNameByType(curSetVisible)
          local chat_data_param = self.chat_data_param
          UIUtil.ShowMessage(Localization:GetString("birthday_tips_18", visibleName), 2, "birthday_btn_2", nil, function()
            SFSNetwork.SendMessage(MsgDefines.ItemUse, {
              uuid = chat_data_param.uid,
              num = chat_data_param.count,
              chatType = chatType,
              copy = isCopyToChat,
              copyChatType = copyChatChannelType
            })
          end)
        end
      elseif redPocketType == RedPacketType.LuckyBuff or redPocketType == RedPacketType.LuckyWithoutBuff then
        if self.chat_data_param.expireTime >= UITimeManager:GetInstance():GetServerTime() then
          SFSNetwork.SendMessage(MsgDefines.AllianceLuckSiphonSendRedPackage, {
            uuid = self.chat_data_param.uid
          })
        else
          UIUtil.ShowTipsId(390843)
        end
      else
        SFSNetwork.SendMessage(MsgDefines.ItemUse, {
          uuid = self.chat_data_param.uid,
          num = self.chat_data_param.count,
          chatType = chatType,
          copy = isCopyToChat,
          copyChatType = copyChatChannelType
        })
      end
      EventManager:GetInstance():Broadcast(ChatEventEnum.CHAT_MOVETOBOTTOM)
    elseif self.chat_data_param.post == PostType.GHOST_RECON_TASK_TEAM then
      local type = channel.group == ChatGroupType.GROUP_ALLIANCE and 1 or 2
      local userId = 0
      if type == 2 then
        userId = ChatManager2:GetInstance().Room:GetPrivateUserIdByRoomId(channel.name)
      end
      SFSNetwork.SendMessage(MsgDefines.GhostReconHandleSendChat, self.chat_data_param.taskUUid, type, tostring(userId))
    elseif self.chat_data_param.post == PostType.ActMigration then
      if not DataCenter.ActMigrationManager:CheckShareImmigrantInviteCd(true) then
        return
      end
      local chatData = {}
      chatData.roomId = channel:getRoomId()
      chatData.post = self.chat_data_param.post
      chatData.param = self.chat_data_param.param
      EventManager:GetInstance():Broadcast(ChatEventEnum.CHAT_SHARE_COMMAND, chatData)
    elseif self.chat_data_param.isShare then
      local targetRoomId = channel:getRoomId()
      ChatManager2:GetInstance().Net:SendMessage(ChatMsgDefines.ChatTransfer, self.chat_data_param.chatData.roomId, self.chat_data_param.chatData.seqId, targetRoomId)
    elseif self.chat_data_param.post == PostType.STAGE_FEATURE_CHAPTER or self.chat_data_param.post == PostType.FrontBreakSunday then
      local curTime = UITimeManager:GetInstance():GetServerTime()
      CommonUtil.PlayerPrefsSetLong(SettingKeys.STAGE_FEATURE_SHARE_TIME, curTime)
      local chatData = {}
      chatData.roomId = channel:getRoomId()
      chatData.post = self.chat_data_param.post
      chatData.param = self.chat_data_param.param
      EventManager:GetInstance():Broadcast(ChatEventEnum.CHAT_SHARE_COMMAND, chatData)
    elseif self.chat_data_param.post == PostType.ValentineRankCard then
      local curTime = UITimeManager:GetInstance():GetServerTime()
      CommonUtil.PlayerPrefsSetLong(SettingKeys.VALENTINE_RANK_CARD_SHARE_TIME, curTime)
      local chatData = {}
      chatData.roomId = channel:getRoomId()
      chatData.post = self.chat_data_param.post
      chatData.param = self.chat_data_param.param
      EventManager:GetInstance():Broadcast(ChatEventEnum.CHAT_SHARE_COMMAND, chatData)
    elseif self.chat_data_param.post == PostType.FLOWER_TRAIN_POSITION_SHARE then
      local curTime = UITimeManager:GetInstance():GetServerTime()
      CommonUtil.PlayerPrefsSetLong(SettingKeys.FLOWER_TRAIN_POSITION_SHARE_TIME, curTime)
      local chatData = {}
      chatData.roomId = channel:getRoomId()
      chatData.post = self.chat_data_param.post
      chatData.param = self.chat_data_param
      EventManager:GetInstance():Broadcast(ChatEventEnum.CHAT_SHARE_COMMAND, chatData)
      PostEventLog.Track(PostEventLog.Defines.FlowerTrain_Share_Chat_Success, {
        share_type = 1,
        aid = tostring(chatData.param and chatData.param.uid),
        actId = tostring(chatData.param and chatData.param.trainItemId)
      })
    elseif self.chat_data_param.post == PostType.FLOWER_TRAIN_SHARE then
      local curTime = UITimeManager:GetInstance():GetServerTime()
      CommonUtil.PlayerPrefsSetLong(SettingKeys.FLOWER_TRAIN_RANK_CARD_SHARE_TIME, curTime)
      local chatData = {}
      chatData.roomId = channel:getRoomId()
      chatData.post = self.chat_data_param.post
      chatData.param = self.chat_data_param.param
      EventManager:GetInstance():Broadcast(ChatEventEnum.CHAT_SHARE_COMMAND, chatData)
      PostEventLog.Track(PostEventLog.Defines.FlowerTrain_Share_Chat_Success, {
        share_type = 3,
        aid = tostring(chatData.param and chatData.param.uid),
        actId = tostring(chatData.param and chatData.param.trainItemId)
      })
    elseif self.chat_data_param.post == PostType.TacticalCard or self.chat_data_param.post == PostType.TacticalCard_Deck then
      local chatData = {}
      chatData.roomId = channel:getRoomId()
      chatData.post = self.chat_data_param.post
      chatData.postType = self.chat_data_param.postType
      chatData.param = self.chat_data_param.param
      EventManager:GetInstance():Broadcast(ChatEventEnum.CHAT_SHARE_COMMAND, chatData)
    elseif self.chat_data_param.post == PostType.ActConcertReward then
      local chatData = {}
      chatData.roomId = channel:getRoomId()
      chatData.post = self.chat_data_param.post
      chatData.postType = self.chat_data_param.postType
      chatData.param = self.chat_data_param.param
      DataCenter.ActConcertDataManager:UpdateLastShareBubbleTime()
      EventManager:GetInstance():Broadcast(ChatEventEnum.CHAT_SHARE_COMMAND, chatData)
    elseif self.chat_data_param.post == PostType.MusicFestival2025_Share then
      local chatData = {}
      chatData.roomId = channel:getRoomId()
      chatData.post = self.chat_data_param.post
      chatData.postType = self.chat_data_param.postType
      chatData.param = self.chat_data_param.param
      DataCenter.ActCrazyRockDataManager:UpdateLastShareScoreTime()
      EventManager:GetInstance():Broadcast(ChatEventEnum.CHAT_SHARE_COMMAND, chatData)
    elseif self.chat_data_param.post == PostType.Chat_SendPhoto then
      local targetRoomId = channel:getRoomId()
      LuaEntry.GlobalData.targetRoomId = targetRoomId
      LuaEntry.GlobalData.targetUserInfoUid = -1
      if string.IsNullOrEmpty(self.chat_data_param.msg) then
        local filePath = self.chat_data_param.filePath
        local bigWidth = self.chat_data_param.bigWidth
        local bigHeight = self.chat_data_param.bigHeight
        if filePath and bigWidth and bigHeight then
          CS.UploadImageManager.Instance:SetUploadImageLimit(4000, 3072, 1280, 200)
          DataCenter.ChatSendPhotoManager:SetCurPhotoFuncType(PhotoFuncType.ChatSendPickPhoto)
          CS.UploadImageManager.Instance.curPhotoFuncType = PhotoFuncType.ChatSendPickPhoto
          CS.UploadImageManager.Instance:FinishedSelectSingleImage(filePath, bigWidth, bigHeight)
        end
      else
        local msg = self.chat_data_param.msg
        local picVer = self.chat_data_param.picVer
        local smallHeight = self.chat_data_param.smallHeight
        local smallWidth = self.chat_data_param.smallWidth
        local bigHeight = self.chat_data_param.bigHeight
        local bigWidth = self.chat_data_param.bigWidth
        if msg and picVer and smallHeight and smallWidth and bigHeight and bigWidth then
          ChatManager2:GetInstance():SendMessage_ChatPhoto(msg, PostType.Chat_SendPhoto, picVer, smallHeight, smallWidth, bigHeight, bigWidth)
        end
      end
    elseif self.chat_data_param.post == PostType.Season_LittleGame_Invite then
      local chatData = {}
      chatData.roomId = channel:getRoomId()
      chatData.post = self.chat_data_param.post
      chatData.postType = self.chat_data_param.postType
      chatData.param = self.chat_data_param.param
      local userId
      local chatDataRoom = ChatManager2:GetInstance().Room:GetRoomData(chatData.roomId)
      local channelType = ShootShareChannelType.None
      if chatDataRoom:isPrivateChat() then
        channelType = ShootShareChannelType.Private
        userId = ChatManager2:GetInstance().Room:GetPrivateUserIdByRoomId(channel.name)
      elseif chatDataRoom:isWorldRoom() then
        channelType = ShootShareChannelType.Country
      elseif chatDataRoom:isAllianceRoom() then
        channelType = ShootShareChannelType.Alliance
      elseif chatDataRoom:isSeasonRoom() then
        channelType = ShootShareChannelType.Season
      end
      SFSNetwork.SendMessage(MsgDefines.ActivityLittleGamePvpShare, channelType, userId)
    elseif self.chat_data_param.post == PostType.Season_BiuBiuInvite then
      local chatData = {}
      chatData.roomId = channel:getRoomId()
      chatData.post = self.chat_data_param.post
      chatData.postType = self.chat_data_param.postType
      chatData.param = self.chat_data_param.param
      local userId
      local chatData = ChatManager2:GetInstance().Room:GetRoomData(chatData.roomId)
      local channelType = ShootShareChannelType.None
      if chatData:isPrivateChat() then
        channelType = ShootShareChannelType.Private
        userId = ChatManager2:GetInstance().Room:GetPrivateUserIdByRoomId(channel.name)
      elseif chatData:isWorldRoom() then
        channelType = ShootShareChannelType.Country
      elseif chatData:isAllianceRoom() then
        channelType = ShootShareChannelType.Alliance
      elseif chatData:isSeasonRoom() then
        channelType = ShootShareChannelType.Season
      end
      SFSNetwork.SendMessage(MsgDefines.BiuBiuPVPShare, channelType, userId)
    elseif self.chat_data_param.post == PostType.T11IdleGameAllianceHelp then
      local param = {}
      param.eventUuid = self.chat_data_param.param.eventUuid
      SFSNetwork.SendMessage(MsgDefines.IdleGameEventShare, param)
    elseif self.chat_data_param.post == PostType.StageFeatureHelpInvite then
      local stageId = self.chat_data_param.param.stageId
      local roomId = channel:getRoomId()
      local userId
      local channelType = ChatManager2:GetInstance().Room:GetChannelFromRoomId(roomId)
      if channelType == ChatShareChannel.TO_PERSON then
        userId = ChatManager2:GetInstance().Room:GetPrivateUserIdByRoomId(channel.name)
        DataCenter.LWStageFeatureChapterManager:RequestHelpToPlayer(stageId, userId)
      elseif channelType == ChatShareChannel.TO_ALLIANCE then
        DataCenter.LWStageFeatureChapterManager:RequestHelpToAlliance(stageId)
      end
    elseif self.chat_data_param.post == PostType.BF_WINTER_HISTORY_SHARE then
      local chatData = {}
      chatData.roomId = channel:getRoomId()
      chatData.post = self.chat_data_param.post
      chatData.postType = self.chat_data_param.postType
      chatData.param = self.chat_data_param.param
      EventManager:GetInstance():Broadcast(ChatEventEnum.CHAT_SHARE_COMMAND, chatData)
    else
      if self.chat_data_param.post == PostType.ALLIANCE_MONSTER_CHALLENGE_NEW_REWARD then
        local curTs = UITimeManager:GetInstance():GetServerTime()
        CS.GameEntry.Setting:SetString(SettingKeys.AL_CHALLENGE_BOSS_BOX_SHARE, tostring(curTs))
      end
      if self.chat_data_param.post == PostType.NewsCenterLink then
        if self.chat_data_param.isShowWeb then
          DataCenter.LWNewsCenterManager:ShowNewsWeb(self.chat_data_param.param.uuid, self.chat_data_param.openType, true)
        else
          DataCenter.LWNewsCenterManager:ShareNewsWiki(self.chat_data_param.param.uuid)
        end
        PostEventLog.Track(PostEventLog.Defines.NewsCenterShare, {
          def_uid = self.chat_data_param.param.uuid,
          adgroup_name = channel.group
        })
      end
      local chatData = {}
      chatData.roomId = channel:getRoomId()
      chatData.post = self.chat_data_param.post
      chatData.param = self.chat_data_param.param
      EventManager:GetInstance():Broadcast(ChatEventEnum.CHAT_SHARE_COMMAND, chatData)
    end
    if self.chat_data_param.closeTipText then
      UIUtil.ShowTips(self.chat_data_param.closeTipText)
    end
    self.ctrl:CloseSelf()
  else
    UIManager:GetInstance():OpenWindow(UIWindowNames.UIPositionShareConfirm, {anim = true}, channel, self.chat_data_param)
  end
end

local function TryAddOtherShareType(self)
  self:TryAddAllianceNoticePointShare()
end

local function TryAddAllianceNoticePointShare(self)
  local postType = self.chat_data_param.postType
  if postType ~= nil then
    return
  end
  local post = self.chat_data_param.post
  if post ~= nil then
    return
  end
  local isShare = self.chat_data_param.isShare
  if isShare ~= nil then
    return
  end
  local isInDragon = BattleFieldUtil.InBattleField()
  if isInDragon then
    return
  end
  if not ChatInterface.isInAlliance() then
    return
  end
  if not DataCenter.AllianceBaseDataManager:IsR4orR5() then
    return
  end
  local RoomManager = ChatManager2:GetInstance().Room
  local allianceRoomData = RoomManager:GetRoomDataByGroup(ChatGroupType.GROUP_ALLIANCE)
  if allianceRoomData == nil then
    return
  end
  local param = {
    notice = "",
    isAdv = 0,
    isR4R5 = 0,
    photoData = nil,
    extraJsonData = {}
  }
  local share_param = self.chat_data_param
  if (share_param.type == ShareType.Pos or share_param.type == nil) and not string.IsNullOrEmpty(share_param.pos) then
    local pos = SceneUtils.IndexToTilePos(share_param.pos, ForceChangeScene.World)
    share_param.pos = nil
    share_param.x = pos.x
    share_param.y = pos.y
  end
  if type(share_param) == "table" then
    if share_param.worldId == nil then
      share_param.worldId = LuaEntry.Player:GetCurWorldId()
      share_param.worldType = LuaEntry.Player:GetCurWorldType()
      if BattleFieldUtil.InBattleField(BattleFieldType.Desert) then
        share_param.allianceId = LuaEntry.Player.allianceId
        share_param.actDragonGroup = DataCenter.ActDragonManager:GetCurGroupIdx()
      end
    end
    if share_param.sid == nil then
      share_param.sid = LuaEntry.Player:GetCurServerId()
    end
  end
  if param.extraJsonData == nil then
    param.extraJsonData = {}
  end
  local notice = param.notice or ""
  local extraJsonData = param.extraJsonData
  ChatInterface.AddOnePointShareDataToLast(notice, extraJsonData, share_param)
  local privateItemIndex = -1
  for i = 1, #self.list do
    local chatItem = self.list[i]
    if chatItem:isPrivateChat() then
      privateItemIndex = i
      break
    end
  end
  local dataInsertIndex = #self.list + 1
  if 0 < privateItemIndex then
    dataInsertIndex = privateItemIndex
  end
  local addData = {
    name = Localization:GetString("2900001"),
    icon = "Assets/Main/Sprites/UI/UIChatNew3/zyf_lmggfszb_tongmenggonggao_rukou_icon.png",
    callback = function()
      GoToUtil.OpenChatView(false, {anim = false, immediately = true}, {
        roomId = allianceRoomData.roomId
      })
      UIManager:GetInstance():OpenWindow(UIWindowNames.UIPostAllianceNotice, {anim = true}, param)
    end
  }
  table.insert(self.list, dataInsertIndex, addData)
end

function UIPositionShareView:CreateDynamicComponent(assetPath, cls, data)
  if self.dynamicReq == nil then
    self.dynamicReq = self:GameObjectInstantiateAsync(assetPath, function(request)
      if request.isError then
        return
      end
      local go = request.gameObject
      go:SetActive(true)
      go.transform:SetParent(self.compDynamicContent.transform)
      go.transform:Set_localScale(ResetScale.x, ResetScale.y, ResetScale.z)
      go.transform:Set_offsetMin(0, 0)
      go.transform:Set_offsetMax(0, 0)
      NameCount = NameCount + 1
      go.name = tostring(NameCount)
      self.dynamicComp = self.compDynamicContent:AddComponent(cls, go.name)
      self.dynamicComp:ReInit(data)
    end)
  elseif self.dynamicComp ~= nil then
    self.dynamicComp:ReInit(data)
  end
  self.ScrollView:SetOffsetMinXY(0, 300)
  self.ScrollView:SetOffsetMaxXY(0, 0)
  self.compDynamicRoot:SetActive(true)
end

UIPositionShareView.OnCreate = OnCreate
UIPositionShareView.OnDestroy = OnDestroy
UIPositionShareView.RefreshList = RefreshList
UIPositionShareView.OnEnable = OnEnable
UIPositionShareView.OnDisable = OnDisable
UIPositionShareView.ClearScroll = ClearScroll
UIPositionShareView.OnAddListener = OnAddListener
UIPositionShareView.OnRemoveListener = OnRemoveListener
UIPositionShareView.OnItemClick = OnItemClick
UIPositionShareView.TryAddOtherShareType = TryAddOtherShareType
UIPositionShareView.TryAddAllianceNoticePointShare = TryAddAllianceNoticePointShare
return UIPositionShareView
