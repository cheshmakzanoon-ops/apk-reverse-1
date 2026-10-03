local LWChatPinData = BaseClass("LWChatPinData")
local ChatPinAllianceNoticeItemCell = require("UI.UIChatNew.Component.ChatPinAllianceNoticeItemCell")
local ChatPinAllianceGatherItemCell = require("UI.UIChatNew.Component.ChatPinAllianceGatherItemCell")
local ChatPinAskLeaderGatherItemCell = require("UI/UIChatNew.Component.ChatPinAskLeaderGatherItemCell")
local _pin_notice_item_prefab = "Assets/Main/Prefabs/UI/ChatNew/ChatPinNoticeItem.prefab"
local _pin_invite_member_item_prefab = "Assets/Main/Prefabs/UI/ChatNew/ChatPinItem.prefab"
local _pin_ask_leader_gather_item_prefab = "Assets/Main/Prefabs/UI/ChatNew/ChatPinAskLeaderGatherItem.prefab"

local function __init(self)
  self.type = nil
  self.overTime = nil
  self.content = nil
end

local function __delete(self)
  self.type = nil
  self.overTime = nil
  self.content = nil
end

local function InitData(self, msg)
  self.uuid = msg.uuid
  self.type = msg.type
  self.overTime = msg.overTime
  self.content = msg.content
end

local function GetPrefabPath(self)
  if self.type == ChatPinMessageType.AllianceNotice then
    return _pin_notice_item_prefab
  elseif self.type == ChatPinMessageType.AllianceGatherMember then
    return _pin_invite_member_item_prefab
  elseif self.type == ChatPinMessageType.AllianceGatherLeader then
    return _pin_ask_leader_gather_item_prefab
  end
end

local function GetChatPinName(self)
  if self.type == ChatPinMessageType.AllianceNotice then
    return "notice"
  elseif self.type == ChatPinMessageType.AllianceGatherMember then
    return "pinItem"
  elseif self.type == ChatPinMessageType.AllianceGatherLeader then
    return "leaderGather"
  end
end

local function GetPrefabClass(self)
  if self.type == ChatPinMessageType.AllianceNotice then
    return ChatPinAllianceNoticeItemCell
  elseif self.type == ChatPinMessageType.AllianceGatherMember then
    return ChatPinAllianceGatherItemCell
  elseif self.type == ChatPinMessageType.AllianceGatherLeader then
    return ChatPinAskLeaderGatherItemCell
  end
end

LWChatPinData.__init = __init
LWChatPinData.__delete = __delete
LWChatPinData.InitData = InitData
LWChatPinData.GetPrefabPath = GetPrefabPath
LWChatPinData.GetPrefabClass = GetPrefabClass
LWChatPinData.GetChatPinName = GetChatPinName
return LWChatPinData
