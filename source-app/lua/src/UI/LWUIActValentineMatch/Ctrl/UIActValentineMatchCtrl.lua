local UIActValentineMatchCtrl = BaseClass("UIActValentineMatchCtrl", UIBaseCtrl)
local Localization = CS.GameEntry.Localization
local Regex = CS.System.Text.RegularExpressions.Regex

function UIActValentineMatchCtrl:__init()
  self.curIndex = 1
  self.matchList = nil
end

function UIActValentineMatchCtrl:__delete()
  self.curIndex = nil
  self.matchList = nil
end

function UIActValentineMatchCtrl:CloseSelf()
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UIActValentineMatch)
end

function UIActValentineMatchCtrl:RequestMarchList(activityId)
  SFSNetwork.SendMessage(MsgDefines.ValentineFollowMatchList, activityId)
end

function UIActValentineMatchCtrl:RequestMarchDone(activityId)
  local matchList = self:GetMatchList(activityId)
  if matchList then
    local uid = matchList[self.curIndex].uid
    SFSNetwork.SendMessage(MsgDefines.ValentineFollowMatchMark, activityId, {uid})
  end
end

function UIActValentineMatchCtrl:RequestMatchAllDone(activityId)
  local matchList = self:GetMatchList(activityId)
  if matchList then
    local uidArr = {}
    local begin = self.curIndex
    for i = begin, #matchList do
      local uid = matchList[i].uid
      table.insert(uidArr, uid)
    end
    SFSNetwork.SendMessage(MsgDefines.ValentineFollowMatchMark, activityId, uidArr)
  end
end

function UIActValentineMatchCtrl:GetMatchList(activityId)
  if not self.matchList then
    self.matchList = DataCenter.ValentineDataManager:GetMatchList(activityId)
  end
  if not self.matchList then
    Logger.LogError("\230\131\133\228\186\186\232\138\130\230\180\187\229\138\168\233\133\141\229\175\185\229\136\151\232\161\168\228\184\186\231\169\186")
    return nil
  end
  return self.matchList
end

function UIActValentineMatchCtrl:GetMatch(activityId)
  local matchList = self:GetMatchList(activityId)
  if matchList and 0 < #matchList and self.curIndex and 0 < self.curIndex then
    return matchList[self.curIndex]
  end
  return nil
end

function UIActValentineMatchCtrl:MoveToNext()
  self.curIndex = self.curIndex + 1
end

function UIActValentineMatchCtrl:IfShowNext(activityId)
  local matchList = self:GetMatchList(activityId)
  if matchList and #matchList >= self.curIndex + 1 then
    return true
  end
  return false
end

function UIActValentineMatchCtrl:IfShowSkip(activityId)
  local matchList = self:GetMatchList(activityId)
  local temp = DataCenter.ValentineDataManager:GetActSendTempByActId(activityId)
  local skipNum = 0
  if temp then
    skipNum = temp.skipNum
  end
  if matchList then
    return skipNum < #matchList
  end
  return false
end

function UIActValentineMatchCtrl:IfShowLeftNum(activityId)
  local matchList = self:GetMatchList(activityId)
  if matchList then
    if #matchList <= 1 then
      return false, 0
    end
    return true, self.curIndex, #matchList
  end
end

function UIActValentineMatchCtrl:SendEmojiChatMsg(emojiId, activityId)
  local curMatch = self:GetMatch(activityId)
  if not curMatch then
    return
  end
  local canChat = DataCenter.LWRefundPunishManager:GetCanChat()
  if not canChat then
    return
  end
  if CoppaUtil.IsCoppaLimitWithTips() then
    return
  end
  if string.IsNullOrEmpty(curMatch.uid) then
    return
  end
  local userInfo = {}
  userInfo.uid = curMatch.uid
  userInfo.userName = curMatch.name
  UIManager:GetInstance():OpenWindow(UIWindowNames.UIChatNew_v2, {
    anim = true,
    onFinish = function()
      local chatView = UIManager:GetInstance():GetWindow(UIWindowNames.UIChatNew_v2)
      if chatView then
        local emojiData = LocalController:instance():getLine(TableName.LW_EMOJI, emojiId)
        local str = "\\u" .. emojiData.path
        local unicodeStr = Regex.Unescape(str)
        chatView.View.ctrl:SendMessage(unicodeStr, 0, PostType.Text_Normal, {isSendEmoji = true})
      end
    end
  }, {privateUserInfo = userInfo})
end

function UIActValentineMatchCtrl:OnCustomKeyCodeEscape()
end

return UIActValentineMatchCtrl
