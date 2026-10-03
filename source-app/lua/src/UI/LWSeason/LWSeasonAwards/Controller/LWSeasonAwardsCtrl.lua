local LWSeasonAwardsCtrl = BaseClass("LWSeasonAwardsCtrl", UIBaseCtrl)
local Localization = CS.GameEntry.Localization

function LWSeasonAwardsCtrl:CloseSelf()
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UILWSeasonAwards)
end

function LWSeasonAwardsCtrl:GetAlInfos()
  local alData = DataCenter.AllianceBaseDataManager:GetAllianceBaseData()
  if alData == nil then
    return
  end
  local icon = alData.icon
  local name = "[" .. alData.abbr .. "] " .. alData.allianceName
  local infos = {icon = icon, name = name}
  return infos
end

function LWSeasonAwardsCtrl:GetMemberAndOnlineNum(rank)
  return DataCenter.SeasonRewardDataManager:GetAllianceMemberListByRank(rank)
end

function LWSeasonAwardsCtrl:GetMemberListByRank(rank)
  local showList = {}
  local list = DataCenter.SeasonRewardDataManager:GetAllianceMemberListByRank(rank)
  local selfUid = LuaEntry.Player.uid
  if list ~= nil then
    table.walk(list, function(k, v)
      local oneData = self:SwitchMemberData(v)
      if v.uid == selfUid then
        table.insert(showList, 1, oneData)
      else
        table.insert(showList, oneData)
      end
    end)
  end
  return showList
end

function LWSeasonAwardsCtrl:SwitchMemberData(v)
  local oneData = {}
  oneData.name = v.name
  oneData.gender = v.gender
  oneData.power = toInt(v.power)
  oneData.uid = v.uid
  oneData.rank = v.rank
  oneData.pic = v.pic or ""
  oneData.picVer = v.picVer or 0
  oneData.headBg = v:GetHeadBgImg()
  oneData.mainCityLv = toInt(v.mainCityLv)
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
  oneData.seasonRole = v.seasonRole and v.seasonRole or 0
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
  oneData.rewardIndex = v.rewardIndex
  return oneData
end

return LWSeasonAwardsCtrl
