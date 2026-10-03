local AllianceListItemShow = {
  pic = "",
  name = "",
  type = AllianceButtonType.None
}
local OneData = DataClass("OneData", AllianceListItemShow)
local UIAllianceMainTableCtrl = BaseClass("UIAllianceMainTableCtrl", UIBaseCtrl)
local Localization = CS.GameEntry.Localization

local function CloseSelf(self)
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UIAllianceMainTable)
end

local function CloseAll(self)
  UIManager.Instance:DestroyWindow(UIWindowNames.UIAllianceMainTable)
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UILWPlayerDetail)
end

local function Close(self)
  UIManager:GetInstance():DestroyWindowByLayer(UILayer.Background)
end

local function GetAllianceId(self)
  local data = DataCenter.AllianceBaseDataManager:GetAllianceBaseData()
  return data.uid
end

local function GetAllianceBaseData(self)
  return DataCenter.AllianceBaseDataManager:GetAllianceBaseData()
end

local function CheckIsSelfAll(self)
  return true
end

local function GetAllianceButtonShow(self)
  local list = {}
  LocalController:instance():visitTable("alliance_info", function(id, lineData)
    local tempId = lineData:getValue("id")
    local vec = string.split(lineData:getValue("pic"), ".")
    if 1 < #vec then
      local data = OneData.New()
      data.order = tonumber(lineData:getValue("order"))
      local pic = "Assets/Main/Sprites/UI/UIAlliance/ApsAlliance/" .. vec[1]
      local name = tostring(lineData:getValue("name"))
      if tempId == 6 then
        data.type = AllianceButtonType.AllianceSalary
        data.pic = pic
        data.name = Localization:GetString(name)
      elseif tempId == 5 then
        data.type = AllianceButtonType.AllianceHelp
        data.pic = pic
        data.name = Localization:GetString(name)
        table.insert(list, data)
      elseif tempId == 9 then
        local unlock = DataCenter.AllianceBaseDataManager:CheckIfAllianceFuncOpen(AllianceTaskFuncType.AllianceScience)
        local isSwitchOn = LuaEntry.DataConfig:CheckSwitch("alliance_shop")
        if unlock and isSwitchOn then
          data.type = AllianceButtonType.AllianceShop
          data.pic = pic
          data.name = Localization:GetString(name)
          table.insert(list, data)
        end
      elseif tempId == 1 then
        data.type = AllianceButtonType.AllianceBattle
        data.pic = pic
        data.name = Localization:GetString(name)
        table.insert(list, data)
      elseif tempId == 7 then
        local unlock = DataCenter.AllianceBaseDataManager:CheckIfAllianceFuncOpen(AllianceTaskFuncType.AllianceScience)
        local isSwitchOn = LuaEntry.DataConfig:CheckSwitch("alliancescience_entrance")
        if isSwitchOn and unlock then
          data.type = AllianceButtonType.AllianceScience
          data.pic = pic
          data.name = Localization:GetString(name)
          table.insert(list, data)
        end
      elseif tempId == 8 then
        data.type = AllianceButtonType.AllianceGift
        data.pic = pic
        data.name = Localization:GetString(name)
        table.insert(list, data)
      elseif tempId == 2 then
        data.type = AllianceButtonType.AllianceMember
        data.pic = pic
        data.name = Localization:GetString(name)
        table.insert(list, data)
      elseif tempId == 17 then
        data.type = AllianceButtonType.EverydayTask
        data.pic = "Assets/Main/Sprites/UI/UIAlliance/ApsAlliance/img_iconAllianceTask"
        data.name = Localization:GetString(name)
        table.insert(list, data)
      elseif tempId == 21 then
        data.type = AllianceButtonType.AllianceCity
        data.pic = pic
        data.name = Localization:GetString(name)
        table.insert(list, data)
      elseif tempId == 22 then
        if DataCenter.AllianceBaseDataManager:CheckIfCanPayAsLeader() then
          data.type = AllianceButtonType.BecomeLeader
          data.pic = pic
          data.name = Localization:GetString(name)
          table.insert(list, data)
        end
      elseif tempId == 23 then
        local unlocked = DataCenter.AlLeaderElectManager:CheckModuleUnlocked()
        if unlocked and DataCenter.AlLeaderElectManager:CheckIfLeaderElecting() then
          data.type = AllianceButtonType.AlLeaderElect
          data.pic = pic
          data.name = Localization:GetString(name)
          table.insert(list, data)
        end
      elseif tempId == 24 then
        local unlocked = DataCenter.AllianceTaskManager:CheckIfAllianceTaskOpen()
        if unlocked then
          data.type = AllianceButtonType.AllianceTask
          data.pic = pic
          data.name = Localization:GetString(name)
          table.insert(list, data)
        end
      end
    end
  end)
  table.sort(list, function(a, b)
    if a.order ~= b.order then
      return a.order < b.order
    elseif a.type ~= b.type then
      return a.type < b.type
    else
      return false
    end
  end)
  return list
end

local function GetRedPotCount(self, type)
  local count = 0
  if type == AllianceButtonType.AllianceBattle then
    count = DataCenter.AllianceWarDataManager:GetAllianceWarMemberRed()
    count = count + DataCenter.AllianceAlertDataManager:GetAlertNum()
    if 1 < count then
      count = 1
    end
  elseif type == AllianceButtonType.AllianceGift then
    count = DataCenter.AllianceGiftDataManager:GetGiftNum()
  elseif type == AllianceButtonType.AllianceHelp then
    count = DataCenter.AllianceHelpDataManager:GetHelpNum()
  elseif type == AllianceButtonType.AllianceCheck then
    count = DataCenter.AllianceMemberDataManager:GetAllianceApplyRedCount()
  elseif type == AllianceButtonType.EverydayTask then
    count = 0
  elseif type == AllianceButtonType.AlLeaderElect then
    count = DataCenter.AlLeaderElectManager:GetAlElectRedCount()
  elseif type == AllianceButtonType.AllianceTask then
    count = DataCenter.AllianceTaskManager:GetTaskRedCount()
  elseif type == AllianceButtonType.AllianceSetting then
    local data = DataCenter.AllianceBaseDataManager:GetAllianceBaseData()
    local showTip = DataCenter.AllianceBaseDataManager:IsR4orR5()
    if showTip then
      local needRed = DataCenter.AllianceBaseDataManager:CheckIfNeedSettingTip()
      count = needRed and 1 or 0
    end
  elseif type == AllianceButtonType.AllianceScience then
    local curNum = DataCenter.AllianceScienceDataManager:GetResDonateRestCount()
    local maxNum = DataCenter.AllianceScienceDataManager:GetResDonateMaxCount()
    count = curNum >= maxNum / 2 and curNum or 0
  elseif type == AllianceButtonType.AllianceCity and DataCenter.AllianceDeclareWarManager:CheckWarIsNew() then
    count = 1
  end
  return count
end

local function OnSetAnnounceClick(self, announce)
  local canChange = DataCenter.AllianceBaseDataManager:IsSelfLeader() or DataCenter.AllianceBaseDataManager:IsR4orR5()
  if canChange then
    UIManager:GetInstance():OpenWindow(UIWindowNames.UIAllianceChangeAnnounce, {anim = true}, 2, announce)
  else
    UIUtil.ShowTipsId(390201)
  end
end

local function OnGotoClick(self, type)
  if type == AllianceButtonType.AllianceQuit then
    UIUtil.ShowLeaveAllianceTips(function(isDismiss)
      self:QuitAlliance(isDismiss)
    end)
  elseif type == AllianceButtonType.AllianceBattle then
    if self:GetPersonalList() then
      DataCenter.AllianceWarDataManager:OpenALWarMain(true, 1)
    elseif DataCenter.AllianceWarDataManager:GetAlertNum() > 0 or 0 < DataCenter.AllianceAlertDataManager:GetAlertNum() then
      EventManager:GetInstance():Broadcast(EventId.RefreshAlertUI)
      DataCenter.AllianceWarDataManager:OpenALWarMain(true, 3)
    else
      DataCenter.AllianceWarDataManager:OpenALWarMain(true, 2)
    end
  elseif type == AllianceButtonType.BecomeLeader then
    local goldCost = LuaEntry.DataConfig:TryGetNum("union_Administration", "k3")
    UIUtil.ShowMessage(Localization:GetString("141086", goldCost), 2, GameDialogDefine.CONFIRM, GameDialogDefine.CANCEL, function()
      if LuaEntry.Player.gold >= goldCost then
        SFSNetwork.SendMessage(MsgDefines.BecomeAlLeader)
      else
        GoToUtil.GotoPayTips(goldCost)
      end
    end, nil)
  elseif type == AllianceButtonType.AllianceGift then
    UIManager:GetInstance():OpenWindow(UIWindowNames.UIAllianceGift, {anim = true, hideTop = true})
  elseif type == AllianceButtonType.AllianceHelp then
    UIManager:GetInstance():OpenWindow(UIWindowNames.UIAllianceHelp, {anim = true, hideTop = true})
  elseif type == AllianceButtonType.AllianceShop then
    UIManager:GetInstance():OpenWindow(UIWindowNames.UIAllianceShop, {anim = true, hideTop = true})
  elseif type == AllianceButtonType.AllianceScience then
    if UIManager:GetInstance():IsWindowOpen(UIWindowNames.UILWPlayerDetail) then
      UIManager:GetInstance():DestroyWindow(UIWindowNames.UILWPlayerDetail)
    end
    UIManager:GetInstance():OpenWindow(UIWindowNames.UIAllianceScience, {anim = true, hideTop = true})
  elseif type == AllianceButtonType.AllianceSetting then
    if DataCenter.AllianceBaseDataManager:IsR4orR5() then
      UIManager:GetInstance():OpenWindow(UIWindowNames.UISettingAlliance, {anim = true, hideTop = true})
    else
      UIUtil.ShowTipsId(390201)
    end
  elseif type == AllianceButtonType.AllianceCheck then
    UIManager:GetInstance():OpenWindow(UIWindowNames.UIAllianceApplyList, {anim = true, hideTop = true})
  elseif type == AllianceButtonType.AllianceList then
    UIManager:GetInstance():OpenWindow(UIWindowNames.UIJoinAlliance, {anim = true, hideTop = true})
  elseif type == AllianceButtonType.AllianceRank then
    UIManager:GetInstance():OpenWindow(UIWindowNames.UIAllianceRankTable, {anim = true, hideTop = true})
  elseif type == AllianceButtonType.AllianceMail then
    UIManager:GetInstance():OpenWindow(UIWindowNames.UIMailSend, {anim = true, hideTop = true}, MailType.MAIL_ALLIANCE_ALL, self:GetAllianceId())
  elseif type == AllianceButtonType.AllianceMember then
    UIManager:GetInstance():OpenWindow(UIWindowNames.UIAllianceMemberDetail, {anim = true, hideTop = true}, self:GetAllianceId(), AllianceMemberOpenType.AllianceMember)
  elseif type == AllianceButtonType.AllianceMoveInvite then
    UIManager:GetInstance():OpenWindow(UIWindowNames.UIMoveCityTip, {anim = true, hideTop = true}, {openType = 2})
  elseif type == AllianceButtonType.AllianceInvite then
    UIManager:GetInstance():OpenWindow(UIWindowNames.UIAllianceInviteList, {anim = true, hideTop = true})
  elseif type == AllianceButtonType.EverydayTask then
    UIManager:GetInstance():OpenWindow(UIWindowNames.UIAllianceEveryDayTask, {anim = true, hideTop = true})
  elseif type == AllianceButtonType.AllianceCity then
    UIManager:GetInstance():OpenWindow(UIWindowNames.UIAllianceCity, {anim = true, hideTop = true})
  elseif type == AllianceButtonType.AlLeaderElect then
    local baseInfo = DataCenter.AllianceBaseDataManager:GetAllianceBaseData()
    if baseInfo then
      if baseInfo.sysAlState == SysAlState.SignUp or baseInfo.sysAlState == SysAlState.R4Elect or baseInfo.sysAlState == SysAlState.LeaderElect then
        UIManager:GetInstance():OpenWindow(UIWindowNames.UIAlLeaderCandidates)
      else
        UIManager:GetInstance():OpenWindow(UIWindowNames.UIAlLeaderElectResult)
      end
    else
      UIUtil.ShowTipsId(120018)
    end
  elseif type == AllianceButtonType.AllianceTask then
    UIManager:GetInstance():OpenWindow(UIWindowNames.UIAllianceTask, {anim = true, hideTop = true})
  else
    UIUtil.ShowTipsId(120018)
  end
end

local function DismissAlliance(self)
  SFSNetwork.SendMessage(MsgDefines.AlDismiss)
  self:CloseSelf()
end

local function QuitAlliance(self, isDismiss)
  if isDismiss then
    SFSNetwork.SendMessage(MsgDefines.AlDismiss)
  else
    SFSNetwork.SendMessage(MsgDefines.AlLeave)
  end
  self:CloseSelf()
end

local function GetAllianceManageList(self)
  local allianceMemberNum = DataCenter.AllianceMemberDataManager:GetAllianceMemberCount()
  local AllianceManageShow = {
    {
      pic = "Assets/Main/Sprites/UI/UIAlliance/ApsAlliance/img_iconSettingFunction_Setting1",
      name = Localization:GetString("280012"),
      type = AllianceButtonType.AllianceSetting
    },
    {
      pic = "Assets/Main/Sprites/UI/UIAlliance/ApsAlliance/img_iconAllianceList",
      name = Localization:GetString("390796"),
      type = AllianceButtonType.AllianceList
    },
    {
      pic = "Assets/Main/Sprites/UI/UIAlliance/ApsAlliance/img_iconAllianceApply",
      name = Localization:GetString("390834"),
      type = AllianceButtonType.AllianceCheck
    },
    {
      pic = "Assets/Main/Sprites/UI/UIAlliance/ApsAlliance/img_iconAllianceDissolve",
      name = 1 < allianceMemberNum and Localization:GetString("311007") or Localization:GetString("390951"),
      type = AllianceButtonType.AllianceQuit
    }
  }
  if DataCenter.AllianceBaseDataManager:IsSelfLeader() then
    local tb = {
      pic = "Assets/Main/Sprites/UI/UIAlliance/ApsAlliance/img_iconAllianceInviteMove",
      name = Localization:GetString("391077"),
      type = AllianceButtonType.AllianceMoveInvite
    }
    table.insert(AllianceManageShow, tb)
  end
  return AllianceManageShow
end

local function GetToggleRedPointCount(self, index)
  local count = 0
  if index == 1 then
    local allianceWar = 0
    local giftNum = self:GetRedPotCount(AllianceButtonType.AllianceGift)
    local helpNum = self:GetRedPotCount(AllianceButtonType.AllianceHelp)
    local task = self:GetRedPotCount(AllianceButtonType.EverydayTask)
    local city = self:GetRedPotCount(AllianceButtonType.AllianceCity)
    count = allianceWar + giftNum + helpNum + task + city
  elseif index == 2 then
    if DataCenter.AllianceBaseDataManager:IsR4orR5() then
      local applyCount = self:GetRedPotCount(AllianceButtonType.AllianceCheck)
      count = count + applyCount
    end
    local settingRedCount = self:GetRedPotCount(AllianceButtonType.AllianceSetting)
    count = count + settingRedCount
  elseif index == 4 then
    local moduleUnlock = DataCenter.AllianceBaseDataManager:CheckIfAllianceFuncOpen(AllianceTaskFuncType.AllianceCareer)
    if moduleUnlock and DataCenter.AllianceCareerManager:IsCanSetCareer() then
      count = count + DataCenter.AllianceCareerManager:GetRedNum()
    end
  elseif index == 5 then
    count = DataCenter.AllianceMemberDataManager:CheckIfNeedInactiveMemberBubble()
  end
  return count
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
  oneData.isSelfAlliance = true
  local baseData = DataCenter.AllianceBaseDataManager:GetAllianceBaseData()
  if baseData.leaderUid and not baseData:CheckIfIsVirtualLeader() then
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
  end
  return oneData
end

local function GetMemberListByRank(self, rank)
  local showList = {}
  local list = DataCenter.AllianceMemberDataManager:GetAllianceMemberListByRank(rank)
  local selfUid = LuaEntry.Player.uid
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
      oneData.isSelfAlliance = true
      if v.rank == 4 then
        local officialNum = DataCenter.AllianceMemberDataManager:GetOfficialByUid(v.uid)
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
      if v.uid == selfUid then
        table.insert(showList, 1, oneData)
      else
        table.insert(showList, oneData)
      end
    end)
  end
  return showList
end

local function GetRankData(self, rank)
  local oneData = {}
  oneData.rank = rank
  local list = DataCenter.AllianceMemberDataManager:GetAllianceMemberListByRank(rank)
  local k1 = LuaEntry.DataConfig:TryGetStr("alliance_player_limit", "k1")
  local k2 = LuaEntry.DataConfig:TryGetStr("alliance_player_limit", "k2")
  if list ~= nil and 0 < #list then
    local count = #list
    if rank == 4 then
      oneData.rankNum = count .. "/" .. k1
    else
      oneData.rankNum = count
    end
  elseif rank == 4 then
    oneData.rankNum = "0" .. "/" .. k1
  else
    oneData.rankNum = "0"
  end
  return oneData
end

local function OnShowAllianceMemberTips(self, uid, rank, posX, posY, name)
  local selfAllianceId = LuaEntry.Player.allianceId
  if selfAllianceId == self:GetAllianceId() then
    local selfRank = DataCenter.AllianceBaseDataManager:GetSelfRank()
    local allianceMemberTipWind = UIManager:GetInstance():GetWindow(UIWindowNames.UIAllianceMemberTip)
    if allianceMemberTipWind then
      allianceMemberTipWind.View:Refresh(uid, rank, posX, posY, selfRank, UIWindowNames.UIAllianceMemberDetail, name, AllianceMemberOpenType.AllianceMember)
    else
      UIManager:GetInstance():OpenWindow(UIWindowNames.UIAllianceMemberTip, uid, rank, posX, posY, selfRank, UIWindowNames.UIAllianceMemberDetail, name, AllianceMemberOpenType.AllianceMember)
    end
  else
    local allianceMemberTipWind = UIManager:GetInstance():GetWindow(UIWindowNames.UIAllianceMemberTip)
    if allianceMemberTipWind then
      allianceMemberTipWind.View:Refresh(uid, rank, posX, posY, 0, UIWindowNames.UIAllianceMemberDetail, name, AllianceMemberOpenType.AllianceMember)
    else
      UIManager:GetInstance():OpenWindow(UIWindowNames.UIAllianceMemberTip, uid, rank, posX, posY, 0, UIWindowNames.UIAllianceMemberDetail, name, AllianceMemberOpenType.AllianceMember)
    end
  end
end

local function OnOfficialViewOpen(self, officialNum, uid)
  local selfAllianceId = LuaEntry.Player.allianceId
  if selfAllianceId == self:GetAllianceId() then
    local selfRank = DataCenter.AllianceBaseDataManager:GetSelfRank()
    UIManager:GetInstance():OpenWindow(UIWindowNames.UIAllianceOfficeSelect, selfRank, officialNum, uid)
  end
end

local function NeedShowInactive(self)
  return true
end

local function GetPersonalList(self)
  local list = {}
  local virtualAllianceMemberList = DataCenter.AllianceHelpVirtualMarchManager:GetVirtualMemberList()
  for i = 1, #virtualAllianceMemberList do
    table.insert(list, virtualAllianceMemberList[i])
  end
  local allianceList = DataCenter.AllianceWarDataManager:GetAllianceWarIdList()
  for i = 1, #allianceList do
    local info = DataCenter.AllianceWarDataManager:GetAllianceWarDataByUuid(allianceList[i])
    if info.targetUid == LuaEntry.Player:GetUid() then
      table.insert(list, allianceList[i])
    end
  end
  local personalList = DataCenter.RadarAlarmDataManager:GetAllMarches()
  for _, v in pairs(personalList) do
    local temp = DataCenter.AllianceWarDataManager:GetWarningType(v)
    if temp == WarningType.Attack or temp == WarningType.Scout or temp == WarningType.Assistance then
      table.insert(list, v)
    end
  end
  local crossServer = DataCenter.AllianceWarDataManager:GetCrossServer()
  if crossServer and next(crossServer) then
    for i = 1, #crossServer do
      if crossServer[i] ~= LuaEntry.Player:GetCurServerId() then
        table.insert(list, {
          serverId = crossServer[i],
          isCross = true
        })
      end
    end
  end
  if next(list) then
    return true
  end
  return false
end

UIAllianceMainTableCtrl.GetLeaderData = GetLeaderData
UIAllianceMainTableCtrl.GetMemberListByRank = GetMemberListByRank
UIAllianceMainTableCtrl.GetRankData = GetRankData
UIAllianceMainTableCtrl.OnShowAllianceMemberTips = OnShowAllianceMemberTips
UIAllianceMainTableCtrl.OnOfficialViewOpen = OnOfficialViewOpen
UIAllianceMainTableCtrl.CloseSelf = CloseSelf
UIAllianceMainTableCtrl.CloseAll = CloseAll
UIAllianceMainTableCtrl.Close = Close
UIAllianceMainTableCtrl.GetAllianceId = GetAllianceId
UIAllianceMainTableCtrl.GetAllianceBaseData = GetAllianceBaseData
UIAllianceMainTableCtrl.CheckIsSelfAll = CheckIsSelfAll
UIAllianceMainTableCtrl.GetAllianceButtonShow = GetAllianceButtonShow
UIAllianceMainTableCtrl.GetRedPotCount = GetRedPotCount
UIAllianceMainTableCtrl.OnGotoClick = OnGotoClick
UIAllianceMainTableCtrl.GetAllianceManageList = GetAllianceManageList
UIAllianceMainTableCtrl.QuitAlliance = QuitAlliance
UIAllianceMainTableCtrl.DismissAlliance = DismissAlliance
UIAllianceMainTableCtrl.GetToggleRedPointCount = GetToggleRedPointCount
UIAllianceMainTableCtrl.InitAllianceMemberData = InitAllianceMemberData
UIAllianceMainTableCtrl.OnSetAnnounceClick = OnSetAnnounceClick
UIAllianceMainTableCtrl.NeedShowInactive = NeedShowInactive
UIAllianceMainTableCtrl.GetPersonalList = GetPersonalList
return UIAllianceMainTableCtrl
