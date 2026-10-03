local ChatShareCommand = BaseClass("ChatShareCommand", SFSBaseMessage)

function ChatShareCommand:OnCreate(param)
  if not param then
    ChatPrint("ChatShareCommand \229\136\134\228\186\171\230\178\161\228\188\160\229\143\130\239\188\129\239\188\129\239\188\129 ")
    return
  end
  if LuaEntry and LuaEntry.Player then
    local curServerId = LuaEntry.Player:GetCurServerId()
    if curServerId then
      self.sfsObj:PutInt("CurServerId", curServerId)
    end
  end
  self.sfsObj:PutLong("post", param.post)
  self.sfsObj:PutUtfString("lang", param.lang)
  if param.msg then
    self.sfsObj:PutUtfString("msg", param.msg)
  else
    self.sfsObj:PutUtfString("msg", "?")
  end
  if param.roomId then
    self.sfsObj:PutUtfString("roomId", param.roomId)
  end
  if param.tradeName then
    self.sfsObj:PutUtfString("tradeName", param.tradeName)
  end
  if param.itemIds then
    local array = SFSArray.New()
    table.walk(param.itemIds, function(k, v)
      array:AddInt(v)
    end)
    self.sfsObj:PutSFSArray("itemIds", array)
  end
  if param.tradePoint then
    self.sfsObj:PutLong("tradePoint", param.tradePoint)
  end
  self.sfsObj:PutUtfString("attachmentId", param.attachmentId)
  if param.chatType then
    self.sfsObj:PutInt("chatType", param.chatType)
  end
  if param.langRoomLang then
    self.sfsObj:PutUtfString("langRoomLang", param.langRoomLang)
  end
  if param.toUser then
    self.sfsObj:PutUtfString("toUser", param.toUser)
  end
  if not string.IsNullOrEmpty(param.reportUid) and not string.IsNullOrEmpty(param.reportLang) then
    self.sfsObj:PutUtfString("reportUid", param.reportUid)
    self.sfsObj:PutUtfString("reportLang", param.reportLang)
  end
  if param.cardUuid then
    self.sfsObj:PutLong("cardUuid", param.cardUuid)
  end
  if param.planIndex then
    self.sfsObj:PutInt("planIndex", param.planIndex)
  end
  if param.bossUid then
    self.sfsObj:PutLong("bossUid", param.bossUid)
  end
  if param.ossAddress then
    self.sfsObj:PutUtfString("ossAddress", param.ossAddress)
  end
  if param.post and param.post == PostType.Season_BiuBiuResult then
    EventManager:GetInstance():Broadcast(EventId.SeasonBiuBiuChatShared)
  end
  if param.serverIdEx then
    self.sfsObj:PutInt("serverIdEx", param.serverIdEx)
  end
  if param.introductionEx then
    self.sfsObj:PutUtfString("introductionEx", param.introductionEx)
  end
  if param.freeEx ~= nil then
    self.sfsObj:PutBool("freeEx", param.freeEx)
  end
end

function ChatShareCommand:getShareChannelGroup()
  if self.shareChannel == ChatShareChannel.TO_COUNTRY then
    return ChatGroupType.GROUP_COUNTRY
  elseif self.shareChannel == ChatShareChannel.TO_ALLIANCE then
    return ChatGroupType.GROUP_ALLIANCE
  elseif self.shareChannel == ChatShareChannel.TO_PERSON then
    return ChatGroupType.GROUP_CUSTOM
  end
end

function ChatShareCommand:processErrorMessage(msg)
  if msg.errorCode and istable(msg.errorPara2) then
    UIUtil.ShowTips(msg.errorCode, msg.errorPara2[1])
  end
end

function ChatShareCommand:HandleMessage(msg)
  if msg.errorCode then
    UIUtil.ShowErrorCodeTips(msg)
    if msg.errorCode == "alliance_inviteLink_tips_notFree" then
      SFSNetwork.SendMessage(MsgDefines.AllianceShareFreeInfo, {})
    elseif msg.errorCode == "alliance_inviteLink_illegalChar_limit_12" then
      local param = {
        sensitive = true,
        introductionEx = msg.errorMsg
      }
      EventManager:GetInstance():Broadcast(EventId.AllianceInviteShareTextCheck, param)
    end
    return
  end
  if self.noShowChat then
    return
  end
  UIUtil.ShowTipsId(120061)
  if msg.postEx and msg.postEx == PostType.ALLIANCE_INVITE_SHARE_NEW then
    UIManager:GetInstance():DestroyWindow(UIWindowNames.UILWAllianceInviteShareNew)
  end
  local roomGroup = self:getShareChannelGroup()
  if msg.gold then
    LuaEntry.Player.gold = msg.gold
    EventManager:GetInstance():Broadcast(EventId.UpdateGold)
  end
end

return ChatShareCommand
