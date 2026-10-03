local IChatItemPost = require("UI.UIChatNewV2.Component.ChatItem.IChatItemPost")
local ChatItemPost_MultipleParkour = BaseClass("MultipleParkour", IChatItemPost)
local base = IChatItemPost
local rapidjson = require("rapidjson")

function ChatItemPost_MultipleParkour:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
end

function ChatItemPost_MultipleParkour:ComponentDefine()
  self._shareNode = self:AddComponent(UIButton, "")
  self._shareNode:SetOnClick(BindCallback(self, self.OnClickBg))
  self.shareMsg = self:AddComponent(UIText, "ShareIconNode/ShareMsg")
  self.titleMsg = self:AddComponent(UIText, "ShareIconNode/TitleMsg")
end

function ChatItemPost_MultipleParkour:OnClickBg()
  if self._chatData == nil then
    return
  end
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

function ChatItemPost_MultipleParkour:OnLoaded()
  local chatdata = self:ChatData()
  if chatdata == nil then
    return
  end
  self._chatData = chatdata
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

function ChatItemPost_MultipleParkour:OnRecycle()
  self.data = nil
end

return ChatItemPost_MultipleParkour
