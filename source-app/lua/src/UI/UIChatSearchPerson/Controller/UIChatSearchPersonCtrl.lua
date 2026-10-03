local UIChatSearchPersonCtrl = BaseClass("UIChatSearchPersonCtrl", UIBaseCtrl)

function UIChatSearchPersonCtrl:__init()
  self.chatRoomdId = nil
end

function UIChatSearchPersonCtrl:CloseSelf()
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UIChatSearchPerson)
end

function UIChatSearchPersonCtrl:GetLeaderInfo()
  local baseData = DataCenter.AllianceBaseDataManager:GetAllianceBaseData()
  if baseData == nil or baseData:CheckIfIsVirtualLeader() then
    return nil
  end
  local leaderData = DataCenter.AllianceMemberDataManager:GetAllianceMemberByUid(baseData.leaderUid)
  return leaderData
end

function UIChatSearchPersonCtrl:GetRoomData()
  if self.chatRoomdId == nil then
    return nil
  end
  local roomdata = ChatInterface.getRoomData(self.chatRoomdId)
  return roomdata
end

function UIChatSearchPersonCtrl:GetChatRoomMemberIds()
  local roomdata = self:GetRoomData()
  if roomdata == nil then
    return {}
  end
  return roomdata.memberList or {}
end

function UIChatSearchPersonCtrl:IsUserInChatRoom(userId)
  local memberList = self:GetChatRoomMemberIds()
  for k, v in pairs(memberList) do
    if v == userId then
      return true
    end
  end
  return false
end

function UIChatSearchPersonCtrl:InitAllianceMemberData()
  local baseData = DataCenter.AllianceBaseDataManager:GetAllianceBaseData()
  if baseData == nil then
    return nil
  end
  SFSNetwork.SendMessage(MsgDefines.AlRank, baseData.uid)
end

function UIChatSearchPersonCtrl:GetRankData(rank)
  local oneData = {}
  oneData.rank = rank
  local list = DataCenter.AllianceMemberDataManager:GetAllianceMemberListByRank(rank)
  local k1 = LuaEntry.DataConfig:TryGetStr("alliance_player_limit", "k1")
  local k2 = LuaEntry.DataConfig:TryGetStr("alliance_player_limit", "k2")
  if list ~= nil and 0 < #list then
    local count = #list
    if rank == 4 then
      oneData.rankNum = count .. "/" .. k1
    elseif rank == 3 then
      oneData.rankNum = count .. "/" .. k2
    else
      oneData.rankNum = count
    end
  elseif rank == 4 then
    oneData.rankNum = "0" .. "/" .. k1
  elseif rank == 3 then
    oneData.rankNum = "0" .. "/" .. k2
  else
    oneData.rankNum = "0"
  end
  return oneData
end

function UIChatSearchPersonCtrl:GetMemberListByRank(rank)
  local showList = {}
  local list = DataCenter.AllianceMemberDataManager:GetAllianceMemberListByRank(rank)
  if list ~= nil then
    table.walk(list, function(k, v)
      local oneData = {}
      oneData.name = v.name
      oneData.power = v.power
      oneData.uid = v.uid
      oneData.rank = v.rank
      oneData.isSelfAlliance = self.isSelfAlliance
      if v.rank == 4 then
        local officialNum = ""
        if self.isSelfAlliance then
          officialNum = DataCenter.AllianceMemberDataManager:GetOfficialByUid(v.uid)
        else
          officialNum = DataCenter.AllianceTempListManager:GetOfficialByUid(v.uid)
        end
        if officialNum == "" then
          oneData.officialPic = "Assets/Main/Sprites/UI/UIRank/btn_PlusXS"
          oneData.officialNum = 0
        elseif officialNum == "1" then
          oneData.officialPic = "Assets/Main/Sprites/UI/UIAlliance/UIAlliance_icon_office1"
          oneData.officialNum = 1
        elseif officialNum == "2" then
          oneData.officialPic = "Assets/Main/Sprites/UI/UIAlliance/UIAlliance_icon_office2"
          oneData.officialNum = 2
        elseif officialNum == "3" then
          oneData.officialPic = "Assets/Main/Sprites/UI/UIAlliance/UIAlliance_icon_office3"
          oneData.officialNum = 3
        elseif officialNum == "4" then
          oneData.officialPic = "Assets/Main/Sprites/UI/UIAlliance/UIAlliance_icon_office4"
          oneData.officialNum = 4
        end
      end
      oneData.online_time = ""
      if self.isSelfAlliance then
        oneData.isOnline = v.online
        if v.online then
          oneData.online_time = Localization:GetString("390188")
        else
          local deltaTime = UITimeManager:GetInstance():GetServerTime() - v.offLineTime
          if 86400000 < deltaTime then
            local day = math.floor(deltaTime / 86400000)
            oneData.online_time = Localization:GetString("390506", day)
          elseif 3600000 < deltaTime then
            local hour = math.floor(deltaTime / 3600000)
            oneData.online_time = Localization:GetString("390505", hour)
          elseif 60000 < deltaTime then
            local minute = math.floor(deltaTime / 60000)
            oneData.online_time = Localization:GetString("390504", minute)
          else
            oneData.online_time = Localization:GetString("390504", 1)
          end
        end
      end
      table.insert(showList, oneData)
    end)
  end
  return showList
end

return UIChatSearchPersonCtrl
