local IChatItem = require("UI.UIChatNew.Component.ChatItem.IChatItem")
local ChatItemActivityMultipleParkour = BaseClass("ChatItemActivityMultipleParkour", IChatItem)
local base = IChatItem
local Localization = CS.GameEntry.Localization
local ChatHead = require("UI.UIChatNew.Component.ChatHead")
local ChatUserName = require("UI.UIChatNew.Component.ChatItem.ChatUserName")
local rapidjson = require("rapidjson")
local _cp_chatHead = "ChatHead"
local _cp_shareNode = "ChatShareNode"
local _cp_chatNameLayout = "ChatNameLayout"

function ChatItemActivityMultipleParkour:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
end

function ChatItemActivityMultipleParkour:OnDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function ChatItemActivityMultipleParkour:ComponentDefine()
  self._chatHead = self:AddComponent(ChatHead, _cp_chatHead)
  self._shareNode = self:AddComponent(UIButton, _cp_shareNode)
  self._shareNode:SetOnClick(BindCallback(self, self.OnClickBg))
  self._chatNameLayout = self:AddComponent(ChatUserName, _cp_chatNameLayout)
  self.shareMsg = self:AddComponent(UIText, "ChatShareNode/ShareIconNode/ShareMsg")
  self.titleMsg = self:AddComponent(UIText, "ChatShareNode/ShareIconNode/TitleMsg")
end

function ChatItemActivityMultipleParkour:ComponentDestroy()
  self.data = nil
end

function ChatItemActivityMultipleParkour:OnClickBg()
  if self._chatData.post == PostType.Activity_MultipleParkour then
    local actList = DataCenter.ActivityListDataManager:GetActivityDataByType(EnumActivity.MultipleParkour.Type)
    if actList and 0 < #actList then
      local actId = tonumber(actList[1].id)
      GoToUtil.GoActWindow({
        tonumber(actId)
      })
    else
      UIUtil.ShowTipsId(801141)
    end
  end
end

function ChatItemActivityMultipleParkour:UpdateItem(chatdata, index)
  base.UpdateItem(self, chatdata, index)
  if chatdata == nil then
    return
  end
  local senderUid = chatdata.senderUid
  local _userInfo = ChatManager2:GetInstance().User:getChatUserInfo(senderUid, true)
  if self._chatNameLayout then
    self._chatNameLayout:UpdateName(_userInfo, chatdata)
  end
  local data = rapidjson.decode(chatdata.attachmentId)
  self.titleMsg:SetLocalText("dev_multiple_stage_04")
  local win = data.win
  local topScore = data.topScore
  if data.serverRank then
    self.shareMsg:SetLocalText("multiply_door_tips_018", data.serverRank)
  elseif data.alncRank then
    self.shareMsg:SetLocalText("multiply_door_tips_019", data.alncRank)
  elseif data.passedLevel then
    self.shareMsg:SetLocalText("multiply_door_tips_020", data.passedLevel)
  elseif topScore then
    self.shareMsg:SetLocalText("dev_multiple_stage_27")
  else
    self.shareMsg:SetLocalText("dev_multiple_stage_28")
  end
  self.data = data
end

return ChatItemActivityMultipleParkour
