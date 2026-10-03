local UIAllianceMemberDetailCtrl = BaseClass("UIAllianceMemberDetailCtrl", UIBaseCtrl)
local Localization = CS.GameEntry.Localization

local function CloseSelf(self)
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UIAllianceMemberDetail)
end

local function Close(self)
  UIManager:GetInstance():DestroyWindowByLayer(UILayer.Normal)
end

local function SetAllianceId(self, uid)
  self.allianceId = uid
  local selfAllianceId = LuaEntry.Player.allianceId
  self.isSelfAlliance = selfAllianceId == self:GetAllianceId()
end

local function CheckIsSelfAll(self)
  return LuaEntry.Player.allianceId == self:GetAllianceId()
end

local function GetAllianceId(self)
  return self.allianceId
end

local function InitAllianceMemberData(self)
  local tempAlId = self:GetAllianceId()
  if tempAlId then
    SFSNetwork.SendMessage(MsgDefines.AlRank, tempAlId)
  end
end

local function GetLeaderData(self)
  local oneData = {}
  oneData.name = ""
  oneData.power = ""
  oneData.kill = ""
  oneData.uid = ""
  oneData.rank = ""
  oneData.isSelfAlliance = self.isSelfAlliance
  if self.isSelfAlliance then
    local baseData = DataCenter.AllianceBaseDataManager:GetAllianceBaseData()
    if baseData:CheckIfIsVirtualLeader() then
      return oneData
    end
    local leaderData = DataCenter.AllianceMemberDataManager:GetAllianceMemberByUid(baseData.leaderUid)
    oneData.name = leaderData.name
    oneData.power = string.GetFormattedSeperatorNum(leaderData.power)
    oneData.kill = 0
    oneData.uid = leaderData.uid
    oneData.rank = leaderData.rank
    oneData.isOnline = leaderData.online
    oneData.headBg = leaderData:GetHeadBgImg()
    oneData.pic = leaderData.pic
    oneData.picVer = leaderData.picVer
    if leaderData.online then
      oneData.online_time = Localization:GetString("390188")
    else
      local deltaTime = UITimeManager:GetInstance():GetServerTime() - leaderData.offLineTime
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
  else
    local listData = DataCenter.AllianceTempListManager:GetAllianceMemberListByRank(5)
    table.walk(listData, function(k, v)
      oneData.name = v.name
      oneData.power = string.GetFormattedSeperatorNum(v.power)
      oneData.kill = 0
      oneData.uid = v.uid
      oneData.rank = v.rank
      oneData.headBg = v:GetHeadBgImg()
      oneData.pic = v.pic
      oneData.picVer = v.picVer
    end)
  end
  return oneData
end

local function GetMemberListByRank(self, rank)
  local showList = {}
  local list = {}
  if self.isSelfAlliance then
    list = DataCenter.AllianceMemberDataManager:GetAllianceMemberListByRank(rank)
  else
    list = DataCenter.AllianceTempListManager:GetAllianceMemberListByRank(rank)
  end
  if list ~= nil then
    table.walk(list, function(k, v)
      local oneData = {}
      oneData.name = v.name
      oneData.power = v.power
      oneData.uid = v.uid
      oneData.rank = v.rank
      oneData.pic = v.pic or ""
      oneData.picVer = v.picVer or 0
      oneData.headBg = v:GetHeadBgImg()
      oneData.mainCityLv = v.mainCityLv
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
        oneData.isInactive = v:CheckIfIsInactivePlayer()
      end
      table.insert(showList, oneData)
    end)
  end
  return showList
end

local function GetRankData(self, rank)
  local oneData = {}
  oneData.rank = rank
  local list = {}
  local r4MaxMemberNum = 0
  if self.isSelfAlliance then
    list = DataCenter.AllianceMemberDataManager:GetAllianceMemberListByRank(rank)
    r4MaxMemberNum = DataCenter.AllianceMemberDataManager:GetR4MaxMemberNum()
  else
    list = DataCenter.AllianceTempListManager:GetAllianceMemberListByRank(rank)
    r4MaxMemberNum = DataCenter.AllianceTempListManager:GetR4MaxMemberNum()
  end
  if list ~= nil and 0 < #list then
    local count = #list
    if rank == 4 then
      oneData.rankNum = count .. "/" .. r4MaxMemberNum
    else
      oneData.rankNum = count
    end
  elseif rank == 4 then
    oneData.rankNum = "0" .. "/" .. r4MaxMemberNum
  else
    oneData.rankNum = "0"
  end
  return oneData
end

local function OnShowAllianceMemberTips(self, uid, rank, posX, posY, name, openType)
  UIManager:GetInstance():OpenWindow(UIWindowNames.UILWPlayerDetail, {anim = true}, uid)
end

local function OnOfficialViewOpen(self, officialNum, uid)
  local selfAllianceId = LuaEntry.Player.allianceId
  if selfAllianceId == self:GetAllianceId() then
    local selfRank = DataCenter.AllianceBaseDataManager:GetSelfRank()
    UIManager:GetInstance():OpenWindow(UIWindowNames.UIAllianceOfficeSelect, selfRank, officialNum, uid)
  end
end

local function NeedShowInactive(self)
  return false
end

function UIAllianceMemberDetailCtrl:GetIsSelfAlliance()
  return self.isSelfAlliance
end

UIAllianceMemberDetailCtrl.CloseSelf = CloseSelf
UIAllianceMemberDetailCtrl.Close = Close
UIAllianceMemberDetailCtrl.SetAllianceId = SetAllianceId
UIAllianceMemberDetailCtrl.CheckIsSelfAll = CheckIsSelfAll
UIAllianceMemberDetailCtrl.GetAllianceId = GetAllianceId
UIAllianceMemberDetailCtrl.InitAllianceMemberData = InitAllianceMemberData
UIAllianceMemberDetailCtrl.GetLeaderData = GetLeaderData
UIAllianceMemberDetailCtrl.GetMemberListByRank = GetMemberListByRank
UIAllianceMemberDetailCtrl.GetRankData = GetRankData
UIAllianceMemberDetailCtrl.OnShowAllianceMemberTips = OnShowAllianceMemberTips
UIAllianceMemberDetailCtrl.OnOfficialViewOpen = OnOfficialViewOpen
UIAllianceMemberDetailCtrl.StartTrade = StartTrade
UIAllianceMemberDetailCtrl.ConfirmBeforeTrade = ConfirmBeforeTrade
UIAllianceMemberDetailCtrl.NeedShowInactive = NeedShowInactive
return UIAllianceMemberDetailCtrl
