local IChatItemPost = require("UI.UIChatNewV2.Component.ChatItem.IChatItemPost")
local ChatItemPost_TorchRelayCheer = BaseClass("ChatItemPost_TorchRelayCheer", IChatItemPost)
local base = IChatItemPost
local Localization = CS.GameEntry.Localization
local reward_path = "reward"
local share_msg_path = "ShareMsg"
local btns_path = "btnCheer"
local btn_cheer_path = "btnCheer/btnCheerText"
local my_path = "alliance_icon_bg"
local HEAD_ICON_SPACING = 21

function ChatItemPost_TorchRelayCheer:OnCreate()
  base.OnCreate(self)
  self.cellList = {}
  self:ComponentDefine()
end

function ChatItemPost_TorchRelayCheer:ComponentDefine()
  self.reward = self:AddComponent(UICommonResItem, reward_path)
  self.share_msg = self:AddComponent(UITextMeshProUGUIEx, share_msg_path)
  self.btn = self:AddComponent(UIButton, btns_path)
  self.btn_cheer = self:AddComponent(UITextMeshProUGUIEx, btn_cheer_path)
  self.btn_cheer:SetLocalText("activity_torch_relay_button_11")
  self.my = self:AddComponent(UIBaseContainer, my_path)
  self.btn:SetOnClick(function()
    self:OnBtnClick()
  end)
  self.helpRoot = self:AddComponent(UIBaseContainer, "helpRoot")
  self.helpRootLayout = self:AddComponent(UIBaseContainer, "helpRoot/helpLayout")
end

function ChatItemPost_TorchRelayCheer:OnRecycle()
  self.cellList = {}
  self:RemoveAllPlayerHead()
end

function ChatItemPost_TorchRelayCheer:RemoveAllPlayerHead()
  self.helpRootLayout:RemoveComponents(UICommonHead)
  if self.playerHeadReqs then
    for i, v in pairs(self.playerHeadReqs) do
      if v then
        v:Destroy()
      end
    end
    self.playerHeadReqs = nil
  end
end

function ChatItemPost_TorchRelayCheer:OnLoaded()
  local chatData = self:ChatData()
  if chatData == nil then
    return
  end
  self.playerHeadReqs = {}
  self._chatData = chatData
  local activityId = self._chatData.attachmentIdJsonObj.activityId
  local activityData = DataCenter.ActivityTorchRelayManager:GetActivityData(tostring(activityId))
  if activityData == nil then
    self.share_msg:SetLocalText("458272")
    self.helpRoot:SetActive(false)
    self.reward.gameObject:SetActive(false)
    self.btn.gameObject:SetActive(false)
    return
  end
  self.helpRoot:SetActive(true)
  local seqId = self._chatData.seqId
  local roomId = self._chatData.roomId
  self.primId = activityId .. "_" .. roomId .. "_" .. seqId
  local isMe = self._chatData:isMyChat()
  if not isMe then
    local rewardPara = DataCenter.RewardManager:ParseOneRewardStr(activityData.config.cheer_other_reward_show)
    self.reward:ReInit(rewardPara)
    self:RefreshStatus()
  end
  self.reward:SetActive(not isMe)
  self.my:SetActive(isMe)
  self.btn:SetActive(not isMe)
  self:RefreshCurPlayerDesc(0)
  self:RefreshHelpPlayer()
end

function ChatItemPost_TorchRelayCheer:OnBtnClick()
  local isMe = self._chatData:isMyChat()
  if isMe then
    return
  end
  local tarUid = self._chatData.senderUid
  local activityId = self._chatData.attachmentIdJsonObj.activityId
  local seqId = self._chatData.seqId
  local roomId = self._chatData.roomId
  SFSNetwork.SendMessage(MsgDefines.ActivityTorchRelayCheerOtherInChat, activityId, roomId, self.primId, seqId, tarUid)
  DataCenter.ActivityTorchRelayManager:SetCheerOtherInChat(self.primId)
  self:RefreshStatus()
end

function ChatItemPost_TorchRelayCheer:OnUpdateMsg(chatData)
  if not chatData then
    return
  end
  if chatData.seqId ~= self._chatData.seqId or chatData.roomId ~= self._chatData.roomId or chatData.post ~= PostType.TorchRelayCheer then
    return
  end
  self:RefreshStatus()
  self:RefreshHelpPlayer()
end

function ChatItemPost_TorchRelayCheer:RefreshStatus()
  local isCheer = DataCenter.ActivityTorchRelayManager:IsCheerOtherInChat(self.primId)
  CS.UIGray.SetGray(self.btn.transform, isCheer, not isCheer)
  if isCheer then
    self.btn_cheer:SetLocalText("activity_torch_relay_button_12")
  else
    self.btn_cheer:SetLocalText("activity_torch_relay_button_11")
  end
end

function ChatItemPost_TorchRelayCheer:RefreshHelpPlayer()
  local clientUpdateExtra = self._chatData.clientUpdateExtra
  self.cacheClientUpdateExtra = clientUpdateExtra
  self.cellList = {}
  self:RemoveAllPlayerHead()
  if string.IsNullOrEmpty(clientUpdateExtra) then
    return
  end
  local timeAndUidStr = string.split(clientUpdateExtra, "|")
  if 2 <= #timeAndUidStr then
    local timeStamp = timeAndUidStr[1]
    local uidStr = timeAndUidStr[2]
    if not string.IsNullOrEmpty(uidStr) then
      local uidList = string.split(uidStr, ",")
      self.playerHeadReqs = {}
      for i, uid in ipairs(uidList) do
        if uid then
          local data = UIUtil.GetPlayerInfoShowByUid(uid)
          self.playerHeadReqs[uid] = self:CreatePlayerHead(data, i)
        end
      end
      self:RefreshCurPlayerDesc(#uidList)
    end
  end
end

function ChatItemPost_TorchRelayCheer:RefreshCurPlayerDesc(playerNum)
  local activityId = self._chatData.attachmentIdJsonObj.activityId
  local activityData = DataCenter.ActivityTorchRelayManager:GetActivityData(tostring(activityId))
  if activityData == nil then
    return
  end
  local curPlayerNum = playerNum
  local playerLimitMax = activityData.config.cheer_num_max
  self.share_msg:SetLocalText("2025_NewYear_cheerMessage", curPlayerNum, playerLimitMax)
end

function ChatItemPost_TorchRelayCheer:CreatePlayerHead(data, index)
  return self:GameObjectInstantiateAsync(UIAssets.UIPlayerHead, function(request)
    if request.isError then
      return
    end
    local go = request.gameObject
    go.gameObject:SetActive(true)
    go.transform:SetParent(self.helpRootLayout.transform)
    go.transform.pivot = Vector2.New(0, 1)
    go.transform.anchorMin = Vector2.New(0, 1)
    go.transform.anchorMax = Vector2.New(0, 1)
    go.transform.sizeDelta = Vector2.New(80, 80)
    go.transform.localScale = Vector3.New(1, 1, 1)
    local posX = 21 * (index - 1)
    go.transform.anchoredPosition = Vector2.New(posX, 0)
    go.transform:SetAsFirstSibling()
    local name = "headIcon" .. index
    go.name = name
    local cell = self.helpRootLayout:AddComponent(UICommonHead, name)
    data.frameBg = data.headBg
    cell:ParseHeadInfo(data)
    self.cellList[data.uid] = cell
  end)
end

function ChatItemPost_TorchRelayCheer:RefreshUserInfo(uid)
  if self.cellList == nil then
    return
  end
  if self.cellList[uid] == nil then
    return
  end
  local user = UIUtil.GetPlayerInfoShowByUid(uid)
  if user == nil then
    return
  end
  user.frameBg = user.headBg
  self.cellList[uid]:ParseHeadInfo(user)
end

function ChatItemPost_TorchRelayCheer:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(ChatEventEnum.CHAT_ROOM_ONEMSG_UPDATA, self.OnUpdateMsg)
  self:AddUIListener(EventId.GetNewUserInfoSucc, self.RefreshUserInfo)
end

function ChatItemPost_TorchRelayCheer:OnRemoveListener()
  self:RemoveUIListener(ChatEventEnum.CHAT_ROOM_ONEMSG_UPDATA, self.OnUpdateMsg)
  self:RemoveUIListener(EventId.GetNewUserInfoSucc, self.RefreshUserInfo)
  base.OnRemoveListener(self)
end

return ChatItemPost_TorchRelayCheer
