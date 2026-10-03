local ChatHeroDispatchShareCommand = BaseClass("ChatHeroDispatchShareCommand", SFSBaseMessage)
local base = SFSBaseMessage

function ChatHeroDispatchShareCommand:OnCreate(param)
  base.OnCreate(self)
  self.sfsObj:PutLong("uuid", param.uuid)
  self.sfsObj:PutInt("targetServer", param.targetServer)
  self.sfsObj:PutInt("type", param.type)
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
end

function ChatHeroDispatchShareCommand:HandleMessage(msg)
  if msg.errorCode then
    UIUtil.ShowErrorCodeTips(msg)
    return
  end
  if self.noShowChat then
    return
  end
  local isMark = false
  local extraInfo = msg.extraShareInfo
  if extraInfo ~= nil then
    local curNum = checknumber(extraInfo.num)
    local totalNum = LuaEntry.DataConfig:TryGetNum("dispatchtask_quick_mark", "k2", 0)
    if 0 < curNum and curNum <= totalNum then
      UIUtil.ShowTips(CS.GameEntry.Localization:GetString("dispatch_quick_mark_success_tips", curNum, totalNum))
      isMark = true
    end
  end
  if not isMark then
    UIUtil.ShowTipsId(120061)
  end
  if msg.gold then
    LuaEntry.Player.gold = msg.gold
    EventManager:GetInstance():Broadcast(EventId.UpdateGold)
  end
end

return ChatHeroDispatchShareCommand
