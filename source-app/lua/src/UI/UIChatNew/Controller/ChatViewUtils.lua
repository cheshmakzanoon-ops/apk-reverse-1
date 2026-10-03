local ChatViewUtils = BaseClass("ChatViewUtils", Singleton)
local Const_ChatView_Width_Chat = 860
local Const_ChatView_Width_Quest = 1310
local Const_ChatView_Width_Radar = 870

function ChatViewUtils:__init()
  self._curRoomType = QuestRoomId
  self._screenWidth = 0.0
  self._chatItemWidthOffset = 150
  self._chatLeftItemMinHeight = 120
  self._chatRightItemMinHeight = 120
  self._chatViewHeight = DefaultScreenHeight
  self._ishorizontalScreen = true
  self._chatMainView = nil
  local Screen = CS.UnityEngine.Screen
  self._aspectRatio = Screen.width / Screen.height
  self._screenWidth = 750 / Screen.height * Screen.width
  self._chatViewWidth_Normal = self._screenWidth * (Const_ChatView_Width_Chat / 1334)
  self._chatViewWidth_Quest = Const_ChatView_Width_Quest
  self._chatViewWidth_Radar = Const_ChatView_Width_Radar
  self._currentRoomId = ""
end

function ChatViewUtils:GetUIHeightRatio()
  return self._chatViewHeight / Screen.height
end

function ChatViewUtils:GetChatViewWidth_Normal()
  local extra = 400
  return self._chatViewWidth_Normal + extra
end

function ChatViewUtils:GetChatViewWidth_Quest()
  return self._chatViewWidth_Quest
end

function ChatViewUtils:GetChatViewWidth_Radar()
  return self._chatViewWidth_Radar
end

function ChatViewUtils:GetChatViewHeight()
  return self._chatViewHeight
end

function ChatViewUtils:GetChatItemMaxWidth()
  if self._curRoomType == QuestRoomId then
    return self._chatViewWidth_Quest - self._chatItemWidthOffset
  elseif self._curRoomType == RadarRoomId then
    return self._chatViewWidth_Radar - self._chatItemWidthOffset
  else
    return self:GetChatViewWidth_Normal() - self._chatItemWidthOffset
  end
end

function ChatViewUtils:GetChatLeftItemMinHeight()
  return self._chatLeftItemMinHeight
end

function ChatViewUtils:GetChatRightItemMinHeight()
  return self._chatRightItemMinHeight
end

function ChatViewUtils:IsHorizontalScreen()
  return self._ishorizontalScreen
end

function ChatViewUtils:RotateScreen()
  self._ishorizontalScreen = not self._ishorizontalScreen
  if self._ishorizontalScreen then
    self._chatViewWidth = 880
  else
    self._chatViewWidth = 750
  end
end

function ChatViewUtils:SetChatMainView(chatMainView)
  self._chatMainView = chatMainView
end

function ChatViewUtils:GetChatMainView()
  return self._chatMainView
end

function ChatViewUtils:GetScreenWidth()
  return self._screenWidth
end

function ChatViewUtils:GetShowTime(secondTime)
  return UITimeManager:GetInstance():GetChatShowTime(secondTime)
end

function ChatViewUtils:GetAdaptOffsetX()
  return 0
end

function ChatViewUtils:GetCurrentRoomId()
  return self._currentRoomId
end

function ChatViewUtils:IsTmpPrivateChat(roomId)
  if roomId == nil or roomId == "" then
    return false
  end
  if string.startswith(roomId, ChatTempPrivateRoomId) then
    return true
  end
  return false
end

function ChatViewUtils:SetCurrentRoomId(roomId)
  self._currentRoomId = roomId
  if not self:IsTmpPrivateChat(roomId) and roomId ~= ChatGMRoomId and roomId ~= AlAutoInviteRoomId and roomId ~= E_CHAT_COUNTRY_ROOMID and roomId ~= E_CHAT_ALLIANCE_ROOMID then
    if self._privateUserInfo ~= nil then
      EventManager:GetInstance():Broadcast(ChatEventEnum.CHAT_REFRESH_CHANNEL)
    end
    self:SetPrivateUserInfo(nil)
  end
end

function ChatViewUtils:SetGmRoomTipMessage(message)
  self._GmTipMessage = message
end

function ChatViewUtils:GetGmRoomTipMessage()
  return self._GmTipMessage
end

function ChatViewUtils:GetPrivateUserInfo()
  return self._privateUserInfo
end

function ChatViewUtils:SetPrivateUserInfo(userInfo)
  self._privateUserInfo = userInfo
end

return ChatViewUtils
