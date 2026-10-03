local UILWAlMemberCtrl = BaseClass("UILWAlMemberCtrl", UIBaseCtrl)
local Localization = CS.GameEntry.Localization
local AllianceMemberShowInfo = require("DataCenter.AllianceData.AllianceMemberShowInfo")

local function SetView(self, view)
  self.view = view
end

local function ClearView(self)
  self.view = nil
end

local function CloseSelf(self)
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UILWAlMember)
end

local function GetLeaderInfo(self)
  local oneData = {}
  oneData.name = ""
  oneData.power = ""
  oneData.kill = ""
  oneData.uid = ""
  oneData.rank = ""
  oneData.isSelfAlliance = true
  local baseData = DataCenter.AllianceBaseDataManager:GetAllianceBaseData()
  oneData.icon = baseData.icon
  if baseData.leaderUid and not baseData:CheckIfIsVirtualLeader() then
    local leaderData = DataCenter.AllianceMemberDataManager:GetAllianceMemberByUid(baseData.leaderUid)
    if leaderData == nil then
      return nil
    end
    oneData.name = leaderData.name
    oneData.power = string.GetFormattedSeperatorNum(leaderData.power)
    oneData.kill = 0
    oneData.uid = leaderData.uid
    oneData.rank = leaderData.rank
    oneData.isOnline = leaderData.online
    oneData.headBg = leaderData:GetHeadBgImg()
    oneData.pic = leaderData.pic
    oneData.picVer = leaderData.picVer
    oneData.offLineTime = leaderData.offLineTime
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
    oneData.rankName = DataCenter.AllianceMemberDataManager:GetAllianceRankNameByRank(leaderData.rank)
    oneData.viewOpen = DataCenter.AllianceMemberDataManager:GetAllianceRankVisible()
  end
  return oneData
end

local function GetMemberAndOnlineNum(self, rank)
  return DataCenter.AllianceMemberDataManager:GetAllianceMemberListByRank(rank)
end

local function GetMemberListByRank(self, rank)
  local showList = {}
  local list = DataCenter.AllianceMemberDataManager:GetAllianceMemberListByRank(rank)
  local selfUid = LuaEntry.Player.uid
  if list ~= nil then
    table.walk(list, function(k, v)
      local oneData = {}
      oneData.name = v.name
      oneData.gender = v.gender
      oneData.power = v.power
      oneData.uid = v.uid
      oneData.rank = v.rank
      oneData.pic = v.pic or ""
      oneData.picVer = v.picVer or 0
      oneData.headBg = v:GetHeadBgImg()
      oneData.mainCityLv = v.mainCityLv
      oneData.isSelfAlliance = true
      oneData.pointId = v.pointId
      if v.rank == 4 then
        local officialNum = DataCenter.AllianceMemberDataManager:GetOfficialPosByUid(v.uid)
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
      oneData.isInactive = v:CheckIfIsInactivePlayer()
      oneData.online_time = ""
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
      oneData.isFar = v.isFar
      if v.uid == selfUid then
        table.insert(showList, 1, oneData)
      else
        table.insert(showList, oneData)
      end
    end)
  end
  return showList
end

local function OnClickOffcialByType(self, type)
  if type == LWAlMemberOffcialType.Deputy_Al_Leader then
    UIUtil.ShowTipsId(393003)
  else
    UIUtil.ShowTipsId(393003)
  end
end

function UILWAlMemberCtrl:GetAllShowData(rankGroupShowMember, keyword, fromSearch, autoShowMax)
  return DataCenter.AllianceMemberDataManager:GetAllShowData(rankGroupShowMember, keyword, fromSearch, autoShowMax)
end

UILWAlMemberCtrl.SetView = SetView
UILWAlMemberCtrl.ClearView = ClearView
UILWAlMemberCtrl.CloseSelf = CloseSelf
UILWAlMemberCtrl.GetLeaderInfo = GetLeaderInfo
UILWAlMemberCtrl.GetMemberListByRank = GetMemberListByRank
UILWAlMemberCtrl.OnClickOffcialByType = OnClickOffcialByType
UILWAlMemberCtrl.GetMemberAndOnlineNum = GetMemberAndOnlineNum
return UILWAlMemberCtrl
