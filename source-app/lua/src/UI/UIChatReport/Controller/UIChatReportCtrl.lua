local UIChatReportCtrl = BaseClass("UIChatReportCtrl", UIBaseCtrl)
local Localization = CS.GameEntry.Localization
local contentCof = {
  other = {
    {
      ReportType = ChatReportContent.avatar,
      Dialog = "report_source_avatar"
    },
    {
      ReportType = ChatReportContent.name,
      Dialog = "report_source_name"
    },
    {
      ReportType = ChatReportContent.chat,
      Dialog = "report_source_chat"
    },
    {
      ReportType = ChatReportContent.chatTranslate,
      Dialog = "report_translate"
    }
  },
  alliance = {
    {
      ReportType = ChatReportContent.allianceName,
      Dialog = "report_source_alliance_name"
    },
    {
      ReportType = ChatReportContent.allianceAcronym,
      Dialog = "report_source_alliance_abbreviation"
    },
    {
      ReportType = ChatReportContent.allianceManifesto,
      Dialog = "report_source_alliance_declaration"
    },
    {
      ReportType = ChatReportContent.allianceRankName,
      Dialog = "report_name_allianceRank"
    }
  },
  mailR4 = {
    {
      ReportType = ChatReportContent.mailR4,
      Dialog = "455138"
    }
  },
  mailPresident = {
    {
      ReportType = ChatReportContent.mailPresident,
      Dialog = "457055"
    }
  },
  allianceNotice = {
    {
      ReportType = ChatReportContent.allianceNotice,
      Dialog = "2900001"
    }
  },
  moment = {
    {
      ReportType = ChatReportContent.moment,
      Dialog = "report_moment"
    }
  },
  groupChat = {
    {
      ReportType = ChatReportContent.groupChatName,
      Dialog = "report_group_item1"
    }
  },
  giftMessage = {
    {
      ReportType = ChatReportContent.giftMessage,
      Dialog = "giftmessagereport_desc1"
    }
  },
  voiceRoom = {
    {
      ReportType = ChatReportContent.avatar,
      Dialog = "report_source_avatar"
    },
    {
      ReportType = ChatReportContent.name,
      Dialog = "report_source_name"
    },
    {
      ReportType = ChatReportContent.voiceChat,
      Dialog = "report_source_voice"
    }
  }
}
local Conf = {
  {
    ReportType = ChatReportType.Politics,
    Dialog = "208240"
  },
  {
    ReportType = ChatReportType.Ads,
    Dialog = "208241"
  },
  {
    ReportType = ChatReportType.Gambling,
    Dialog = "208242"
  },
  {
    ReportType = ChatReportType.Gm,
    Dialog = "208243"
  },
  {
    ReportType = ChatReportType.Sexy,
    Dialog = "208244"
  },
  {
    ReportType = ChatReportType.Attack,
    Dialog = "208245"
  },
  {
    ReportType = ChatReportType.Privacy,
    Dialog = "report_reason_privacy"
  },
  {
    ReportType = ChatReportType.Other,
    Dialog = "208248"
  }
}
local playerKey = "208252"
local allianceKey = "report_alliance"

local function GetReportReasonCof()
  return Conf
end

local function GetReportContentCof(data)
  if data.type == ReportType.alliance then
    return contentCof.alliance
  elseif data.type == ReportType.player then
    return {
      {
        ReportType = ChatReportContent.avatar,
        Dialog = "report_source_avatar"
      },
      {
        ReportType = ChatReportContent.name,
        Dialog = "report_source_name"
      }
    }
  elseif data.type == ReportType.mailR4 then
    return contentCof.mailR4
  elseif data.type == ReportType.mailPresident then
    return contentCof.mailPresident
  elseif data.type == ReportType.allianceNotice then
    return contentCof.allianceNotice
  elseif data.type == ReportType.FriendCircle or data.type == ReportType.FriendCircleMoment then
    return contentCof.moment
  elseif data.type == ReportType.GroupChat then
    return contentCof.groupChat
  elseif data.type == ReportType.gift then
    return contentCof.giftMessage
  elseif data.type == ReportType.voiceRoom then
    return contentCof.voiceRoom
  elseif data.type == ReportType.chat and data.chatData then
    if data.chatData.post == PostType.GiftGiving then
      local config = DeepCopy(contentCof.other)
      table.insert(config, {
        ReportType = ChatReportContent.giftMessage,
        Dialog = "giftmessagereport_desc1"
      })
      return config
    end
    return contentCof.other
  else
    return contentCof.other
  end
end

local function GetAnonymousShowName(chatData)
  local anonymousData = chatData.extra
  if anonymousData == nil then
    Logger.LogError("\229\164\141\230\180\187\232\138\130\226\128\148\226\128\148\226\128\148chatData\230\178\161\230\156\137extra")
    return ""
  end
  local curAnonymousInfo = string.split(anonymousData.anonymousHead, ";")
  local isAnonymous = tonumber(curAnonymousInfo[3]) == 0
  if not isAnonymous then
    return chatData:getSenderName()
  end
  local lastestAnonymousHead = anonymousData.anonymousHead
  curAnonymousInfo = string.split(lastestAnonymousHead, ";")
  local name = curAnonymousInfo[1]
  local showName = DataCenter.ActEasterEggManager:GetTranslateName(name)
  return showName
end

local function GetPlayerName(data, chatData)
  local key, name, allinceId
  if data.type == ReportType.chat or data.type == ReportType.player or data.type == ReportType.chatPhoto or data.type == ReportType.voiceRoom then
    key = playerKey
    name = chatData:getSenderName()
    if chatData.extra and chatData.extra.anonymousHead then
      name = GetAnonymousShowName(chatData)
    end
  elseif data.type == ReportType.championDuel or data.type == ReportType.ActEasterEggOwner or data.type == ReportType.gift then
    key = playerKey
    name = data.name
  elseif data.type == ReportType.actMigrate or data.type == ReportType.actMigrateAlly or data.type == ReportType.actMigrateSNotice then
    key = playerKey
    name = data.name
    if string.IsNullOrEmpty(name) and not string.IsNullOrEmpty(data.uid) then
      SFSNetwork.SendMessage(MsgDefines.GetNewUserInfo, data.uid)
    end
  elseif data.type == ReportType.GroupChat then
    key = "report_group"
    name = chatData.roomName
  elseif data.playerUid then
    key = playerKey
    local userInfo = ChatInterface.getUserData(data.playerUid)
    if userInfo then
      name = userInfo:GetUserName()
    end
  else
    key = allianceKey
    name = data.allinceName or ""
  end
  return Localization:GetString(key, name)
end

local function GetGroupChatName(data, roomData)
  if data.type == ReportType.GroupChat and roomData then
    return Localization:GetString("report_group") .. " : " .. roomData:getRoomName()
  end
end

local function CloseSelf(self)
  UIManager.Instance:DestroyWindow(UIWindowNames.UIChatReport)
end

local function Close(self)
  UIManager.Instance:DestroyWindowByLayer(UILayer.Normal, false)
end

UIChatReportCtrl.CloseSelf = CloseSelf
UIChatReportCtrl.Close = Close
UIChatReportCtrl.GetReportReasonCof = GetReportReasonCof
UIChatReportCtrl.GetReportContentCof = GetReportContentCof
UIChatReportCtrl.GetPlayerName = GetPlayerName
UIChatReportCtrl.GetGroupChatName = GetGroupChatName
return UIChatReportCtrl
