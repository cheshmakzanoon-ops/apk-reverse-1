local LWChatPinData = require("DataCenter.LWChat.LWChatPinData")
local UIChatViewTopTip = require("UI.UIChatNewV2.Component.UIChatViewTopTip")
local LWChatPinManager = BaseClass("LWChatPinManager")
local Setting = CS.GameEntry.Setting
local showPushSettingCount = 5

function LWChatPinManager:__init()
  self.pinMsg = {}
  self.privateDic = CommonUtil.PlayerPrefsGetTable("PRIVATE_PUSHOPEN_LIST", {})
  self.rejectAllianceGatherMember = CommonUtil.PlayerPrefsGetString(SettingKeys.RejectAllianceGatherMemberPin, "")
end

function LWChatPinManager:__delete()
  self.rejectAllianceGatherMember = nil
end

function LWChatPinManager:HandlePinMsg(msg)
  self.pinMsg = {}
  if msg then
    if msg.info then
      for i, v in pairs(msg.info) do
        local data = self.pinMsg[v.type]
        data = data or LWChatPinData.New()
        data:InitData(v)
        self.pinMsg[v.type] = data
      end
    else
      local data = self.pinMsg[msg]
      data = data or LWChatPinData.New()
      data:InitData(msg)
      self.pinMsg[msg.type] = data
    end
  end
  EventManager:GetInstance():Broadcast(EventId.ChatPinUpdate)
end

function LWChatPinManager:GetRoomPushOpenIsOnKey(id)
  return id .. "pushOpenTip"
end

function LWChatPinManager:GetIsOpenPush(room)
  return self.privateDic[self:GetRoomPushOpenIsOnKey(room.roomId)]
end

function LWChatPinManager:GetIsShowPushSetting(room)
  local otherCount = 0
  local me = 0
  if room and room:isPrivateChat() then
    for i, msg in pairs(room.msgs) do
      if msg.senderUid == ChatInterface.getPlayerUid() then
        me = me + 1
      else
        otherCount = otherCount + 1
      end
    end
  end
  return me >= showPushSettingCount and otherCount >= showPushSettingCount
end

function LWChatPinManager:GetPrivePushPin(room)
  if self:GetIsShowPushSetting(room) then
    if self.privateDic[self:GetRoomPushOpenIsOnKey(room.roomId)] then
      return
    end
    local uid = room:GetPrivateUser()
    local topTipData = {
      content = "chat_convo_noti_guide",
      callBackText = "button_name_open",
      uid = room:GetPrivateUser()
    }
    
    function topTipData.GetPrefabPath()
      return "Assets/Main/Prefabs/UI/ChatNew/PinItem/LWUIChatViewTip.prefab"
    end
    
    function topTipData.GetPrefabClass()
      return UIChatViewTopTip
    end
    
    function topTipData.GetChatPinName()
      return "pushTip"
    end
    
    function topTipData.callBack()
      if not CS.GameEntry.Sdk:GetIsNotifyOpen() then
        CS.GameEntry.Sdk:AskForNotifyPermission()
        return
      end
      if uid then
        SFSNetwork.SendMessage(MsgDefines.LWUserPushChatSettings, uid, 1)
        UIUtil.ShowTipsId("chat_convo_noti_guide_toast")
        return true
      end
    end
    
    function topTipData.closeCallBack()
      self.privateDic[self:GetRoomPushOpenIsOnKey(room.roomId)] = true
      self:SavePrivePushPin()
    end
    
    return topTipData
  end
end

function LWChatPinManager:GetAllianceOpenPushPin()
  local topTipData = {
    content = "alliance_noti_guide_member",
    callBackText = "390097"
  }
  
  function topTipData.GetPrefabPath()
    return "Assets/Main/Prefabs/UI/ChatNew/PinItem/LWUIChatViewTip.prefab"
  end
  
  function topTipData.GetPrefabClass()
    return UIChatViewTopTip
  end
  
  function topTipData.GetChatPinName()
    return "pushTip"
  end
  
  function topTipData.callBack()
    if not CS.GameEntry.Sdk:GetIsNotifyOpen() then
      CS.GameEntry.Sdk:AskForNotifyPermission()
      return true
    end
  end
  
  function topTipData.closeCallBack()
    local allianceData = DataCenter.AllianceBaseDataManager:GetAllianceBaseData()
    self:SetNoticeNotifyOpenTime(allianceData.noticeNotifyOpenTime)
  end
  
  return topTipData
end

function LWChatPinManager:SavePrivePushPin()
  CommonUtil.PlayerPrefsSetTable("PRIVATE_PUSHOPEN_LIST", self.privateDic)
end

function LWChatPinManager:GetAllPinData(room)
  local result = {}
  local roomGroup = room.group
  if roomGroup == ChatGroupType.GROUP_CUSTOM then
    if room:isPrivateChat() then
      local tipData = self:GetPrivePushPin(room)
      if tipData then
        table.insert(result, tipData)
      end
    end
  elseif roomGroup == ChatGroupType.GROUP_ALLIANCE then
    local isExistGather
    for i, v in pairs(self.pinMsg) do
      if v.type == ChatPinMessageType.AllianceGatherMember and not DataCenter.AllianceBaseDataManager:IsSelfLeader() then
        local isReject = self:GetRejectAllianceGatherMember(v.uuid)
        if not isReject then
          table.insert(result, v)
          isExistGather = true
        end
      end
      if v.type == ChatPinMessageType.AllianceGatherLeader and DataCenter.AllianceBaseDataManager:IsSelfLeader() and not Setting:GetPrivateBool("DONT_SHOW_LEADER_GATHER_PIN", false) then
        table.insert(result, v)
        isExistGather = true
      end
    end
    if not isExistGather and not CS.GameEntry.Sdk:GetIsNotifyOpen() and not DataCenter.AllianceBaseDataManager:IsSelfLeader() then
      local allianceData = DataCenter.AllianceBaseDataManager:GetAllianceBaseData()
      local time = self:GetNoticeNotifyOpenTime()
      if allianceData and time ~= allianceData.noticeNotifyOpenTime then
        local topTipData = self:GetAllianceOpenPushPin()
        table.insert(result, topTipData)
      end
    end
    local allianceNoticeData = DataCenter.AllianceNoticeManager:GetFirstNotice()
    if allianceNoticeData and not DataCenter.AllianceNoticeManager:IsNoticeManuallyClosed() then
      table.insert(result, allianceNoticeData)
    end
  elseif roomGroup == ChatGroupType.GROUP_ALLIANCE_MANAGER then
    local firstR4R5Notice = DataCenter.AllianceNoticeManager:GetFirstR4R5Notice()
    if firstR4R5Notice and not DataCenter.AllianceNoticeManager:IsR4R5NoticeManuallyClosed() then
      table.insert(result, firstR4R5Notice)
    end
  end
  return result
end

function LWChatPinManager:RemovePinData(uuid)
  for i, v in pairs(self.pinMsg) do
    if v.uuid == uuid then
      self.pinMsg[i] = nil
      EventManager:GetInstance():Broadcast(EventId.ChatPinUpdate)
      return
    end
  end
end

function LWChatPinManager:GetNoticeNotifyOpenTime()
  return tonumber(CommonUtil.PlayerPrefsGetString("NoticeNotifyOpenTime", "0"))
end

function LWChatPinManager:SetNoticeNotifyOpenTime(time)
  local localTime = time or UITimeManager:GetInstance():GetServerTime()
  CommonUtil.PlayerPrefsSetString("NoticeNotifyOpenTime", localTime)
end

function LWChatPinManager:RecordRejectAllianceGatherMember(uid)
  self.rejectAllianceGatherMember = tostring(uid)
  CommonUtil.PlayerPrefsSetString(SettingKeys.RejectAllianceGatherMemberPin, self.rejectAllianceGatherMember)
end

function LWChatPinManager:GetRejectAllianceGatherMember(uid)
  if self.rejectAllianceGatherMember == tostring(uid) then
    return true
  end
  return false
end

function LWChatPinManager:HaveAllianceGatherMemberMsg()
  for i, v in pairs(self.pinMsg) do
    if v.type == ChatPinMessageType.AllianceGatherMember and not DataCenter.AllianceBaseDataManager:IsSelfLeader() then
      local isReject = self:GetRejectAllianceGatherMember(v.uuid)
      if not isReject then
        return true
      end
    end
  end
  return false
end

return LWChatPinManager
