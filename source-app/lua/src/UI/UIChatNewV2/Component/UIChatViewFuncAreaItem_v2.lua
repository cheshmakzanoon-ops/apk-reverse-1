local base = UIBaseContainer
local UIChatViewFuncAreaItem_v2 = BaseClass("UIChatViewFuncAreaItem_v2", base)
local Localization = CS.GameEntry.Localization
local imgFunc_path = "FuncImg"
local textFuncName_path = "TextFuncName"
local btnClick_path = ""
local redDotRoot_path = "FuncImg/redPacketDot"
local textRedDotNum_path = "FuncImg/redPacketDot/imgDot/redPacketDotNum"
local lockRoot = "FuncImg/Lock"
local load_path = "FuncImg/Load"

function UIChatViewFuncAreaItem_v2:OnCreate()
  base.OnCreate(self)
  self.ImgFunc = self:AddComponent(UIImage, imgFunc_path)
  self.TextFuncName = self:AddComponent(UITextMeshProUGUIEx, textFuncName_path)
  self.BtnClick = self:AddComponent(UIButton, btnClick_path)
  self.RedDotRoot = self:AddComponent(UIBaseContainer, redDotRoot_path)
  self.TextRedDotNum = self:AddComponent(UIText, textRedDotNum_path)
  self.LockRoot = self:AddComponent(UIBaseContainer, lockRoot)
  self.load = self:AddComponent(UIImage, load_path)
end

function UIChatViewFuncAreaItem_v2:OnDestroy()
  self.ImgFunc = nil
  self.TextFuncName = nil
  self.BtnClick = nil
  self.RedDotRoot = nil
  self.TextRedDotNum = nil
  self.LockRoot = nil
  self.load = nil
  base.OnDestroy(self)
end

function UIChatViewFuncAreaItem_v2:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.CHAT_SPEAK_UID_DATA_GET, self.OnGetRefreshMsgFunc)
  self:AddUIListener(EventId.UPDATE_MSG_USERINFO, self.OnGetRefreshMsgFunc)
end

function UIChatViewFuncAreaItem_v2:OnRemoveListener()
  self:RemoveUIListener(EventId.CHAT_SPEAK_UID_DATA_GET, self.OnGetRefreshMsgFunc)
  self:RemoveUIListener(EventId.UPDATE_MSG_USERINFO, self.OnGetRefreshMsgFunc)
  base.OnRemoveListener(self)
end

function UIChatViewFuncAreaItem_v2:UpdateItem(curFuncConfig)
  if curFuncConfig == nil then
    Logger.LogError("ChatBottom\233\131\168\229\136\134\239\188\140\229\186\149\233\131\168\233\133\141\231\189\174\228\184\186\231\169\186\227\128\130")
    return
  end
  self.curFuncConfig = curFuncConfig
  local curRoomGroup
  local currRoom = self.view:GetSelectedRoom()
  if currRoom then
    curRoomGroup = currRoom.group
  end
  self.ImgFunc:LoadSprite(curFuncConfig.getImageFunc(curRoomGroup))
  self.TextFuncName:SetLocalText(curFuncConfig.txtName)
  self:SetFuncRedDotState(curFuncConfig)
  self:SetFuncLockState(curFuncConfig)
  self:ShowFuncBtnClickCallback(curFuncConfig)
end

function UIChatViewFuncAreaItem_v2:SetFuncRedDotState(curFuncConfig)
  if curFuncConfig.redPointType == 0 then
    self.RedDotRoot:SetActive(false)
    return
  elseif curFuncConfig.redPointType == 1 then
    self.TextRedDotNum:SetActive(false)
  end
  if curFuncConfig == ChatBottomFuncConfig.RedPackage then
    local redDotNum = self.view.bottom:GetFuncRedDotNumByType(ChatBottomFuncConfig.RedPackage)
    self.TextRedDotNum:SetText(redDotNum)
    self.RedDotRoot:SetActive(0 < redDotNum)
  end
end

function UIChatViewFuncAreaItem_v2:OnGetRefreshMsgFunc()
  self:SetFuncLockState(self.curFuncConfig)
end

function UIChatViewFuncAreaItem_v2:SetFuncLockState(curFuncConfig)
  self.LockRoot:SetActive(false)
  self.load:SetActive(false)
  if curFuncConfig == ChatBottomFuncConfig.PhotoAlbum then
    local curRoomGroup
    local currRoom = self.view:GetSelectedRoom()
    if currRoom then
      curRoomGroup = currRoom.group
    end
    local isOpen = ChatManager2:GetInstance():IsActivePhotoAlbum(curRoomGroup)
    if isOpen then
      local isCanUse = self:CheckPhotoAlbumFuncCanUse()
      if isCanUse then
      else
        self.load:SetActive(true)
      end
    else
      self.LockRoot:SetActive(true)
    end
  end
end

function UIChatViewFuncAreaItem_v2:CheckPhotoAlbumFuncCanUse()
  local canUse = false
  local curRoomGroup
  local currRoom = self.view:GetSelectedRoom()
  if currRoom then
    curRoomGroup = currRoom.group
  end
  if ChatManager2:GetInstance():IsActivePhotoAlbum(curRoomGroup) then
    local checkOtherLvPass = false
    if curRoomGroup == ChatGroupType.GROUP_CUSTOM then
      if currRoom then
        local selfServerId = LuaEntry.Player:GetSourceServerId()
        local otherUserData = currRoom:getPrivateOtherMember()
        if otherUserData and otherUserData.srcServer > 0 then
          local otherServerId = otherUserData.srcServer
          local serverLvPass = false
          local roomMgr = ChatManager2:GetInstance().Room
          local state, speakData = roomMgr:TryGetChatSpeakUid(currRoom.roomId)
          if state == ChatMsgReqState.HaveData then
            checkOtherLvPass = true
          end
        end
      end
    else
      checkOtherLvPass = true
    end
    if checkOtherLvPass then
      canUse = true
    end
  end
  return canUse
end

function UIChatViewFuncAreaItem_v2:ShowFuncBtnClickCallback(curFuncConfig)
  if curFuncConfig == ChatBottomFuncConfig.RedPackage then
    self.BtnClick:SetOnClick(function()
      UIManager:GetInstance():OpenWindow(UIWindowNames.UIRedPacketBag)
    end)
  elseif curFuncConfig == ChatBottomFuncConfig.PhotoAlbum then
    local curRoomGroup
    local currRoom = self.view:GetSelectedRoom()
    if currRoom then
      curRoomGroup = currRoom.group
    end
    if ChatManager2:GetInstance():IsActivePhotoAlbum(curRoomGroup) then
      self.BtnClick:SetOnClick(function()
        DataCenter.LWSoundManager:PlayEffect(SoundAssetId.SFX_UI_General_Click_1st)
        local isRoomPass = false
        local currRoomSet = self.view:GetSelectedRoomSet()
        if currRoomSet and currRoomSet.category == ChatRoomCategory.ALLIANCE then
          isRoomPass = true
        end
        if curRoomGroup == ChatGroupType.GROUP_CUSTOM or curRoomGroup == ChatGroupType.GROUP_CUSTOM_GROUP then
          isRoomPass = true
        end
        if not isRoomPass then
          Logger.LogInfo("UIChatViewFuncAreaItem_v2 PhotoAlbum isRoomPass false")
          return
        end
        local checkOtherLvPass = false
        if curRoomGroup == ChatGroupType.GROUP_CUSTOM then
          if currRoom then
            local selfServerId = LuaEntry.Player:GetSourceServerId()
            local otherUserData = currRoom:getPrivateOtherMember()
            if otherUserData and otherUserData.srcServer > 0 then
              local otherServerId = otherUserData.srcServer
              local serverLvPass = false
              if selfServerId == otherServerId then
                serverLvPass = true
              else
                local otherLv = otherUserData.mainBuildingLevel
                local needLv = ChatManager2:GetInstance():SendPicToPrivateNeedLv()
                if otherLv >= needLv then
                  serverLvPass = true
                else
                  UIUtil.ShowTips(Localization:GetString("picture_send_private_tips2", needLv))
                end
              end
              if serverLvPass then
                local roomMgr = ChatManager2:GetInstance().Room
                local state, speakData = roomMgr:TryGetChatSpeakUid(currRoom.roomId)
                if state == ChatMsgReqState.HaveData then
                  if speakData[otherUserData.uid] then
                    checkOtherLvPass = true
                  else
                    UIUtil.ShowTips(Localization:GetString("picture_send_private_tips3"))
                  end
                else
                  Logger.LogInfo("UIChatViewFuncAreaItem_v2 PhotoAlbum ChatSpeakUid nil")
                end
              end
            else
              Logger.LogInfo("UIChatViewFuncAreaItem_v2 PhotoAlbum otherUserData nil")
            end
          else
            Logger.LogInfo("UIChatViewFuncAreaItem_v2 PhotoAlbum currRoom nil")
          end
        else
          checkOtherLvPass = true
        end
        if not checkOtherLvPass then
          return
        end
        if 0 <= CS.StringUtils.VersionCompare(CS.GameEntry.Sdk.Version, "1.0.244") then
          local targetRoomId, targetUserInfoUid = self:GetCurRoomDataWhenOpenAlbum()
          DataCenter.ChatSendPhotoManager:OnPhotoClick(targetRoomId, targetUserInfoUid)
        else
          UIUtil.ShowTipsId("version_update_unlock_notice")
        end
      end)
    else
      self.BtnClick:SetOnClick(function()
        local isPass, tipStr = ChatManager2:GetInstance():IsActivePhotoAlbum(curRoomGroup)
        if not string.IsNullOrEmpty(tipStr) then
          UIUtil.ShowTips(tipStr)
        else
          Logger.LogInfo("UIChatViewFuncAreaItem_v2 PhotoAlbum tipStr isNullOrEmpty")
        end
      end)
    end
  elseif curFuncConfig == ChatBottomFuncConfig.TranslateAll then
    self.BtnClick:SetOnClick(function()
      local isOpen = ChatInterface.TranslateAllIsOpen()
      if not isOpen then
        UIUtil.ShowTipsId("full_page_translation_notice")
        return
      end
      PostEventLog.Track(PostEventLog.Defines.FULL_PAGE_TRANSLATION)
      EventManager:GetInstance():Broadcast(ChatEventEnum.CHAT_TRANSLATE_All)
    end)
  elseif curFuncConfig == ChatBottomFuncConfig.Gift then
    self.BtnClick:SetOnClick(function()
      self:OnSendGiftClick()
    end)
  elseif curFuncConfig == ChatBottomFuncConfig.ShareMyPoint then
    self.BtnClick:SetOnClick(function()
      self:OnShareMyPointClick()
    end)
  end
end

function UIChatViewFuncAreaItem_v2:GetCurRoomDataWhenOpenAlbum()
  local currRoom = self.view:GetSelectedRoom()
  if not currRoom then
    Logger.LogError("\229\143\145\233\128\129\229\155\190\231\137\135\230\151\182\239\188\140\229\189\147\229\137\141\233\128\137\228\184\173\231\154\132\230\136\191\233\151\180Id\228\184\186\231\169\186")
    return
  end
  local userInfo = currRoom:getPrivateOtherMember()
  if currRoom.group == ChatGroupType.GROUP_TMPRoom and not userInfo then
    Logger.LogError("\229\143\145\233\128\129\229\155\190\231\137\135\230\151\182\239\188\140\229\189\147\229\137\141\231\167\129\232\129\138\231\154\132userInfo\228\184\186\231\169\186")
    return
  end
  local userInfoUid = userInfo and userInfo.uid or -1
  return currRoom:getRoomId(), userInfoUid
end

function UIChatViewFuncAreaItem_v2:OnSendGiftClick()
  local currRoom = self.view:GetSelectedRoom()
  if not currRoom then
    return
  end
  if currRoom.group ~= ChatGroupType.GROUP_TMPRoom and currRoom.group ~= ChatGroupType.GROUP_CUSTOM then
    Logger.LogError("\229\143\145\233\128\129\231\164\188\231\137\169\230\151\182\239\188\140\229\189\147\229\137\141\233\128\137\228\184\173\231\154\132\230\136\191\233\151\180\233\157\158\231\167\129\232\129\138\230\136\191\233\151\180")
    return
  end
  local userInfo = currRoom:getPrivateOtherMember()
  if not userInfo then
    return
  end
  if not userInfo.uid then
    return
  end
  DataCenter.GiftSystemManager:OpenOperationView({
    windowType = GiftSystemConst.WindowType.Send,
    targetUid = userInfo.uid,
    targetServerId = userInfo.serverId
  })
end

function UIChatViewFuncAreaItem_v2:OnShareMyPointClick()
  local currRoom = self.view:GetSelectedRoom()
  if not currRoom then
    return
  end
  local isInDragon = BattleFieldUtil.InBattleField()
  local isDragonRoom = currRoom.group == ChatGroupType.GROUP_DRAGON_SELF_SERVER or currRoom.group == ChatGroupType.GROUP_DRAGON_ALL_SERVER
  local share_param = {}
  if isInDragon and isDragonRoom then
    local selfPos = LuaEntry.Player:GetMainWorldPos()
    if selfPos <= 0 then
      UIUtil.ShowTipsId("base_location_share_tips")
      return
    end
    local pos = SceneUtils.IndexToTilePos(selfPos, ForceChangeScene.World)
    share_param.oname = LuaEntry.Player:GetFullName()
    share_param.postType = PostType.Text_PointShare
    share_param.worldId = LuaEntry.Player:GetCurWorldId()
    share_param.worldType = LuaEntry.Player:GetCurWorldType()
    if BattleFieldUtil.InBattleField(BattleFieldType.Desert) then
      share_param.allianceId = LuaEntry.Player.allianceId
      share_param.actDragonGroup = DataCenter.ActDragonManager:GetCurGroupIdx()
    elseif BattleFieldUtil.InBattleField(BattleFieldType.EpidemicZone) then
      share_param.allianceId = LuaEntry.Player.allianceId
      share_param.actDragonGroup = DataCenter.ActEpidemicZoneManager:GetCurGroupIdx()
    end
    share_param.sid = LuaEntry.Player:GetCurServerId()
    share_param.x = pos.x
    share_param.y = pos.y
  else
    local selfPos = LuaEntry.Player.world_main_pos
    if selfPos <= 0 then
      UIUtil.ShowTipsId("base_location_share_tips")
      return
    end
    local pos = SceneUtils.IndexToTilePos(selfPos, ForceChangeScene.World)
    share_param.oname = LuaEntry.Player:GetFullName()
    share_param.postType = PostType.Text_PointShare
    share_param.worldId = 0
    share_param.worldType = 0
    share_param.sid = LuaEntry.Player:GetSelfServerId()
    share_param.x = pos.x
    share_param.y = pos.y
    if 0 < LuaEntry.Player.VirusLayer then
      share_param.statusLayer = LuaEntry.Player.VirusLayer
      share_param.statusIcon = string.format(LoadPath.LodIcon, "Mjc_saiji2_bingdu_icon.png")
    end
  end
  local chat_data = {}
  chat_data.roomId = currRoom:getRoomId()
  chat_data.post = PostType.Text_PointShare
  chat_data.param = share_param
  chat_data.group = currRoom.group
  if currRoom.group == ChatGroupType.GROUP_TMPRoom then
    chat_data.newTypeMsg = true
    local member = currRoom:getPrivateOtherMember()
    if member and member.uid then
      share_param.toUser = member.uid
    end
  end
  UIUtil.ShowMessage(Localization:GetString("base_location_share"), 2, "btn_send", "btn_cancel", function()
    EventManager:GetInstance():Broadcast(ChatEventEnum.CHAT_SHARE_COMMAND, chat_data)
  end, nil, nil)
end

return UIChatViewFuncAreaItem_v2
