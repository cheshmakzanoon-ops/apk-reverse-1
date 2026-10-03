local ActMigrationManager = BaseClass("ActMigrationManager")
local Localization = CS.GameEntry.Localization
local Resource = CS.GameEntry.Resource
local TypeofRT = typeof(CS.UnityEngine.RectTransform)
local ActMigrationData = require("DataCenter.ActMigrationManager.ActMigrationData")
local ActMigrationScoreData = require("DataCenter.ActMigrationManager.ActMigrationScoreData")
local ActMigrationPlayerData = require("DataCenter.ActMigrationManager.ActMigrationPlayerData")
local ActMigrationAlMarketData = require("DataCenter.ActMigrationManager.ActMigrationAlMarketData")
local ActMigrationAllyRecruitTranslateData = require("DataCenter.ActMigrationManager.ActMigrationAllyRecruitTranslateData")
local ActMigrationStarList = require("DataCenter.ActMigrationManager.ActMigrationStarList")
local MyToNum = tonumber
local MyInsert = table.insert
local MySplit = string.split
local MyStrNull = string.IsNullOrEmpty
local MyStr2Array = string.string2array_i_oneSep
local MAIN_TIPS = "_ACT_MIGRATION_MAIN_TIPS"
local MARKET_TIME_KEY = "_MIGRATION_MARKET_TIME"
local MIGRATE_FORCE_TIME = 1200000

function ActMigrationManager:__init()
  self.remainNumber = 0
  self.actInfo = nil
  self.scoreData = nil
  self.settingData = nil
  self.applyDic = {}
  self.applyIdList = {}
  self.marketDic = {}
  self.guideConfig = nil
  self.seasonTipsConfig = nil
  self.alMarketListData = {}
  self.selfAllianceMarketData = nil
  self.publishCDEndTime = nil
  self.allyRecruitTranslateTextDic = {}
  self.seatIdx2Name = {}
  self.starList = nil
end

function ActMigrationManager:__delete()
  self.remainNumber = 0
  self:ClearFakeLoading()
  self.actInfo = nil
  self.scoreData = nil
  self.settingData = nil
  self.applyDic = {}
  self.applyIdList = {}
  self.marketDic = {}
  self.p_applyId = nil
  self.p_applyMsg = nil
  self.guideConfig = nil
  self.seasonTipsConfig = nil
  self.alMarketListData = nil
  self.selfAllianceMarketData = nil
  self.publishCDEndTime = nil
  self.allyRecruitTranslateTextDic = nil
  self.seatIdx2Name = nil
  self.starList = nil
end

function ActMigrationManager:OnEnterGame()
  local activityId = self:GetCurActId(true)
  if activityId == nil then
    return
  end
  self:ReqActInfo(true)
end

function ActMigrationManager:GetCurActId(bForce)
  local actInfo = DataCenter.ActivityListDataManager:GetOneOpenActivityByType(EnumActivity.ActMigration.Type)
  if actInfo == nil then
    return
  end
  local activityId = tostring(actInfo.id)
  if MyStrNull(activityId) then
    return
  end
  if not bForce then
    local _, stageInfo = self:GetCurStageInfo()
    if stageInfo == nil then
      return
    end
    if stageInfo.state == ActMigrationState.Announce then
      local eTime = stageInfo ~= nil and stageInfo.eTime or 0
      local curTime = UITimeManager:GetInstance():GetServerTime()
      if eTime < curTime then
        return
      end
    end
  end
  return activityId
end

function ActMigrationManager:GoToView(activityId)
  if activityId == nil then
    return
  end
  SeasonUtil.OpenSeasonActivityById(true, activityId)
end

function ActMigrationManager:DoMsgReport(info, reportType)
  if info == nil then
    return
  end
  if info.uid == LuaEntry.Player:GetUid() then
    return
  end
  if MyStrNull(info.message) then
    return
  end
  UIManager:GetInstance():OpenWindow(UIWindowNames.UIChatReport, {anim = true}, {
    type = reportType or ReportType.actMigrate,
    uid = info.uid,
    name = info.name,
    msg = info.message
  })
end

function ActMigrationManager:DoMsgTrans(msg, cb)
  if MyStrNull(msg) then
    if cb then
      cb(false)
    end
    return
  end
  ChatManager2:GetInstance().Translate:Translate(msg, nil, nil, function(ok, rtnTbl)
    if ok then
      if cb then
        cb(true, rtnTbl.translateMsg)
      end
    else
      UIUtil.ShowTipsId(rtnTbl.code)
      if cb then
        cb(false)
      end
    end
  end)
end

function ActMigrationManager:CheckGotoTipStatus()
  if not RaceEntranceUtil.IsNewEntranceOpen() then
    return nil
  end
  local actId = self:GetCurActId(true)
  if actId == nil then
    return nil
  end
  local _, stageInfo = self:GetCurStageInfo()
  if stageInfo.state == ActMigrationState.Apply then
    local lastTime = tonumber(CommonUtil.PlayerPrefsGetString(MAIN_TIPS, "0")) or 0
    local eTime = stageInfo ~= nil and stageInfo.eTime or 0
    if lastTime ~= 0 and lastTime < eTime then
      return nil
    end
    return "battlefield_entrance_tips1003"
  end
  return nil
end

function ActMigrationManager:RecordGotoTipStatus()
  local now = UITimeManager:GetInstance():GetServerTime()
  CommonUtil.PlayerPrefsSetString(MAIN_TIPS, tostring(now))
end

function ActMigrationManager:ReqActInfo(bForce)
  local curTime = UITimeManager:GetInstance():GetServerTime()
  if bForce or self.lastGetActInfoTime == nil or curTime - self.lastGetActInfoTime > 60000 then
    SFSNetwork.SendMessage(MsgDefines.ActMigrationInfo)
    self.lastGetActInfoTime = curTime
  end
end

function ActMigrationManager:HandleActInfo(t)
  if t == nil then
    return
  end
  if self.actInfo == nil then
    self.actInfo = ActMigrationData.New()
  end
  self.actInfo:ParseData(t)
  EventManager:GetInstance():Broadcast(EventId.ActMigrationInfoUpdate)
end

function ActMigrationManager:HandleApplyRedNum(applyRedNum)
  if applyRedNum then
    local myInfo = self:GetMyInfo()
    if myInfo then
      myInfo.applyRedNum = applyRedNum
      EventManager:GetInstance():Broadcast(EventId.ActMigrationInfoUpdate)
    end
  end
end

function ActMigrationManager:GetStageInfo(stage)
  local actInfo = self:GetActInfo()
  if actInfo ~= nil then
    return actInfo:GetStageInfo(stage)
  end
  return nil
end

function ActMigrationManager:GetCurStageInfo()
  local actInfo = self:GetActInfo()
  if actInfo ~= nil then
    return actInfo:GetCurStageInfo()
  end
  return 0, nil
end

function ActMigrationManager:GetActInfo()
  return self.actInfo
end

function ActMigrationManager:GetMyInfo()
  local actInfo = self:GetActInfo()
  return actInfo ~= nil and actInfo.myInfo or nil
end

function ActMigrationManager:GetRedNum(ignoreCheck)
  if not ignoreCheck and not self:CheckCanSetting() then
    return 0
  end
  local _, info = self:GetCurStageInfo()
  local flag = info ~= nil and info.state == ActMigrationState.Apply
  if flag then
    local myInfo = self:GetMyInfo()
    return myInfo ~= nil and myInfo.applyRedNum or 0
  end
  return 0
end

function ActMigrationManager:GetServerInfo(serverId)
  local actInfo = self:GetActInfo()
  return actInfo ~= nil and actInfo:GetServer(serverId) or nil
end

function ActMigrationManager:GetMyServerInfo()
  return self:GetServerInfo(LuaEntry.Player:GetSourceServerId())
end

function ActMigrationManager:GetStageEndTime(stageInfo)
  if stageInfo == nil then
    return 0
  end
  local eTime = stageInfo.eTime or 0
  if stageInfo.state == ActMigrationState.Migrate then
    eTime = eTime - MIGRATE_FORCE_TIME
  end
  return eTime
end

function ActMigrationManager:GetMigrateForceTime()
  return MIGRATE_FORCE_TIME
end

function ActMigrationManager:CheckCanMigrate()
  local myInfo = self:GetMyInfo()
  if myInfo == nil then
    return false
  end
  if myInfo.applyState == 2 then
    local _, stageInfo = self:GetCurStageInfo()
    if stageInfo ~= nil and stageInfo.state == ActMigrationState.Migrate then
      local endTime = self:GetStageEndTime(stageInfo)
      local curTime = UITimeManager:GetInstance():GetServerTime()
      return endTime > curTime
    end
  end
  local mailUuid = myInfo.mailUuid
  if not MyStrNull(mailUuid) then
    local mailInfo = DataCenter.MailDataManager:GetMailInfoById(mailUuid)
    if mailInfo and mailInfo.status == 0 then
      return true
    end
  end
  return false
end

function ActMigrationManager:CheckCanSetting(showTip)
  local sInfo = self:GetMyServerInfo()
  if sInfo then
    local sId = LuaEntry.Player:GetSourceServerId()
    if LuaEntry.Player:IsPresident(sId) then
      return true
    end
  end
  if showTip then
    UIUtil.ShowTipsId("migration_activity_tips_20013")
  end
  return false
end

function ActMigrationManager:GetSeatShowName(keyIndex)
  if self.personStandard == nil then
    self:GetPersonStandard()
  end
  return self.seatIdx2Name and self.seatIdx2Name[keyIndex]
end

function ActMigrationManager:GetOpenConfig()
  local actInfo = self:GetActInfo()
  return actInfo ~= nil and actInfo:GetOpenConfig() or nil
end

function ActMigrationManager:UpdateMyInfo(info)
  local actInfo = self:GetActInfo()
  if actInfo ~= nil then
    actInfo:UpdateMyInfo(info)
  end
  EventManager:GetInstance():Broadcast(EventId.ActMigrationInfoUpdate)
end

function ActMigrationManager:UpdateShareCDTime(time)
  local myInfo = self:GetMyInfo()
  if myInfo then
    myInfo.shareCdTime = time
  end
end

function ActMigrationManager:ReqApplyPanelInfo(serverId)
  self.reqServerId = serverId
  SFSNetwork.SendMessage(MsgDefines.ActMigrationApplyPanel, serverId)
end

function ActMigrationManager:ReqServerInfo(serverId)
  self.reqServerId = serverId
  SFSNetwork.SendMessage(MsgDefines.ActMigrationServerInfo, serverId)
end

function ActMigrationManager:HandleServerInfo(t)
  local sInfo = self:GetServerInfo(self.reqServerId)
  if sInfo then
    sInfo:UpdateDetail(t)
  end
  EventManager:GetInstance():Broadcast(EventId.ActMigrationServerInfoUpdate, self.reqServerId)
  self.reqServerId = nil
end

function ActMigrationManager:ReqApply(serverId, message)
  self.p_applyId = serverId
  self.p_applyMsg = message
  SFSNetwork.SendMessage(MsgDefines.ActMigrationApply, serverId, message)
end

function ActMigrationManager:ReqCancelApply()
  UIUtil.ShowSecondMessageByParam({
    tipText = Localization:GetString("migration_activity_tips_20033"),
    btnNum = 2,
    showToggle = false,
    sureAction = function()
      SFSNetwork.SendMessage(MsgDefines.ActMigrationCancelApply)
    end
  })
end

function ActMigrationManager:UpdatePApply()
  local sId = self.p_applyId or 0
  if sId ~= 0 then
    self:ReqServerInfo(sId)
  end
end

function ActMigrationManager:HandleApply(apply)
  local myInfo = self:GetMyInfo()
  if myInfo ~= nil then
    if apply and myInfo.applyState == ActMigrationMyState.UnApply then
      local sId = self.p_applyId or 0
      if sId ~= 0 then
        self:ReqServerInfo(sId)
      end
      if self.p_applyId and self.p_applyMsg then
        self:UpdateMyInfo({
          serverId = self.p_applyId,
          applyState = ActMigrationMyState.Applied,
          applyMessage = self.p_applyMsg
        })
      end
    elseif not apply then
      local sId = myInfo ~= nil and myInfo.serverId or 0
      if sId ~= 0 then
        self:ReqServerInfo(sId)
      end
      if myInfo.applyState == ActMigrationMyState.Applied then
        UIUtil.ShowTipsId("migration_activity_tips_20023")
      end
      self:UpdateMyInfo({
        serverId = 0,
        applyState = ActMigrationMyState.UnApply,
        applyMessage = ""
      })
    end
  end
  UIManager:GetInstance():DestroyWindow(UIWindowNames.LWUIMigrationRequest)
end

function ActMigrationManager:ReqScoreInfo()
  SFSNetwork.SendMessage(MsgDefines.ActMigrationScoreInfo)
end

function ActMigrationManager:HandleScore(t)
  if t == nil then
    return
  end
  if self.scoreData == nil then
    self.scoreData = ActMigrationScoreData.New()
  end
  self.scoreData:ParseData(t)
  EventManager:GetInstance():Broadcast(EventId.ActMigrationScoreInfoUpdate)
end

function ActMigrationManager:GetScoreInfo()
  return self.scoreData
end

function ActMigrationManager:ReqApplyList(startIndex, number)
  SFSNetwork.SendMessage(MsgDefines.ActMigrationApplyListInfo, startIndex or 0, number or 200)
end

function ActMigrationManager:ReqApplyListSearch(name)
  SFSNetwork.SendMessage(MsgDefines.ActMigrationApplyListSearch, name)
end

local function SortApplyList(a, b)
  local self = DataCenter.ActMigrationManager
  local dataA = self:GetPlayerDataByUid(a)
  local dataB = self:GetPlayerDataByUid(b)
  if dataA == nil then
    return false
  end
  if dataB == nil then
    return true
  end
  local flagA = dataA.applyState == 1
  local flagB = dataB.applyState == 1
  if flagA ~= flagB then
    return flagA
  end
  return dataA.time < dataB.time
end

function ActMigrationManager:UpdateOnePlayer(info)
  local uid = info.uid
  local data = self.applyDic[uid]
  if data == nil then
    data = ActMigrationPlayerData.New()
    self.applyDic[uid] = data
    MyInsert(self.applyIdList, uid)
  end
  data:ParseData(info)
  return uid
end

function ActMigrationManager:HandleApplyList(t)
  if t == nil then
    return
  end
  if t.remainNumber ~= nil then
    self.remainNumber = t.remainNumber
    EventManager:GetInstance():Broadcast(EventId.ActMigrationServerInfoUpdate, LuaEntry.Player:GetSourceServerId())
  end
  local list = t.applyList
  local result = {}
  if not table.IsNullOrEmpty(list) then
    for _, v in pairs(list) do
      local uid = self:UpdateOnePlayer(v)
      MyInsert(result, uid)
    end
    table.sort(result, SortApplyList)
    self.applyIdList = result
  end
  if not self:CheckCanSetting() then
    local cnt = 0
    for _, uid in ipairs(self.applyIdList) do
      local pInfo = self:GetPlayerDataByUid(uid)
      if pInfo and pInfo.applyState == 1 then
        cnt = cnt + 1
      end
    end
    self:HandleApplyRedNum(cnt)
  end
  EventManager:GetInstance():Broadcast(EventId.ActMigrationGetPlayerList, result)
end

function ActMigrationManager:GetPlayerDataByUid(uid)
  return self.applyDic[uid]
end

function ActMigrationManager:ReqSetting(setting)
  if not self:CheckCanSetting(true) then
    return
  end
  SFSNetwork.SendMessage(MsgDefines.ActMigrationSetting, setting)
end

function ActMigrationManager:HandleSetting(t)
  local serverInfo = self:GetMyServerInfo()
  if serverInfo then
    serverInfo:ParseData(t)
    EventManager:GetInstance():Broadcast(EventId.ActMigrationServerInfoUpdate, serverInfo.serverId)
  end
end

function ActMigrationManager:ReqApproval(uid, type)
  if not self:CheckCanSetting(true) then
    return
  end
  self.lastApprovalUid = uid
  self.lastApprovalType = type
  SFSNetwork.SendMessage(MsgDefines.ActMigrationApproval, uid, type)
end

function ActMigrationManager:HandleApproval(t)
  local sInfo = self:GetMyServerInfo()
  if t.remainNumber ~= nil then
    self.remainNumber = t.remainNumber
  end
  if t.curFupinScore ~= nil and sInfo ~= nil and sInfo.curFupinScore ~= nil then
    sInfo.curFupinScore = t.curFupinScore
  end
  local pInfo = self:GetPlayerDataByUid(self.lastApprovalUid)
  if pInfo then
    pInfo.applyState = self.lastApprovalType == 1 and 2 or 0
    EventManager:GetInstance():Broadcast(EventId.ActMigrationPlayerUpdate, pInfo.uid)
    if sInfo ~= nil and self.lastApprovalType == 1 then
      local identity = pInfo.identity
      local isFupin = sInfo:IsFupin()
      if identity == ActMigrationIdentity.High or not isFupin then
        if identity == ActMigrationIdentity.High then
          sInfo.highPlayerIn = sInfo.highPlayerIn + 1
        elseif identity == ActMigrationIdentity.Normal then
          sInfo.playerIn = sInfo.playerIn + 1
        elseif identity == ActMigrationIdentity.Low then
          sInfo.lowPlayerIn = sInfo.lowPlayerIn + 1
        elseif identity == ActMigrationIdentity.SuperLow then
          sInfo.superLowPlayerIn = sInfo.superLowPlayerIn + 1
        end
      end
    end
  end
  if sInfo ~= nil then
    EventManager:GetInstance():Broadcast(EventId.ActMigrationServerInfoUpdate, sInfo.serverId)
  end
end

function ActMigrationManager:SharePersonInvite(uid)
  if uid == nil then
    return
  end
  if not DataCenter.AllianceBaseDataManager:IsR4orR5() then
    UIUtil.ShowTipsId(393018)
    return false
  end
  local allianceData = DataCenter.AllianceBaseDataManager:GetAllianceBaseData()
  if allianceData == nil then
    UIUtil.ShowTipsId(390845)
    return false
  end
  local t = {}
  local chat_channel = ChatInterface.getRoomMgr():getPrivateRoomData(uid)
  local roomId
  if chat_channel == nil then
    roomId = ChatInterface.GetUtil().GeneratePrivateRoomId(uid)
  else
    roomId = chat_channel:getRoomId()
  end
  t.roomId = roomId
  t.post = PostType.MIGRATE_INVITE
  t.newTypeMsg = true
  local param = {}
  t.param = param
  param.toUser = uid
  param.allianceId = allianceData.uid
  param.language = allianceData.language
  param.inviteAlliance = allianceData.allianceName
  param.abbr = allianceData.abbr
  param.curMember = allianceData.curMember
  param.maxMember = allianceData.maxMember
  param.country = allianceData.country
  param.icon = allianceData.icon
  EventManager:GetInstance():Broadcast(ChatEventEnum.CHAT_SHARE_COMMAND, t)
  local info = self:GetMarketPlayer(uid)
  if info then
    info.bInvited = true
  end
  return true
end

function ActMigrationManager:ShareImmigrantInvite(info, myServerInfo, tips)
  if not info then
    return
  end
  local share_param = {}
  share_param.postType = PostType.ActMigration
  share_param.serverId = myServerInfo.serverId
  share_param.config_id = myServerInfo.cfgId
  local chatData = {}
  chatData.post = share_param.postType
  chatData.postType = share_param.postType
  chatData.param = share_param
  chatData.tipText = tips
  UIManager:GetInstance():OpenWindow(UIWindowNames.UIPositionShare, {anim = true}, chatData)
end

function ActMigrationManager:GetShareImmigrantInviteCd()
  return LuaEntry.DataConfig:TryGetNum("lw_migration", "k1", 1)
end

function ActMigrationManager:CheckShareImmigrantInviteCd(showTip)
  local myInfo = self:GetMyInfo()
  local shareCdTime = myInfo ~= nil and myInfo.shareCdTime or 0
  local curTime = UITimeManager:GetInstance():GetServerTime()
  if shareCdTime > curTime then
    local leftTime = math.floor(shareCdTime - curTime)
    leftTime = UITimeManager:GetInstance():SecondToFmtStringWithoutHour(leftTime / 1000)
    if showTip then
      UIUtil.ShowTips(CS.GameEntry.Localization:GetString("migration_activity_tips_20014", self:GetShareImmigrantInviteCd(), leftTime))
    end
    return false
  end
  return true
end

function ActMigrationManager:JumpToTab(tab)
  local activityId = self:GetCurActId()
  if activityId == nil then
    return
  end
  self.jumpToTab = tab
  self:GoToView(activityId)
end

function ActMigrationManager:JumpFromShare(serverId)
  local activityId = self:GetCurActId()
  if activityId == nil then
    return
  end
  self.jumpToServerId = serverId
  self:GoToView(activityId)
end

function ActMigrationManager:ReqMigrate()
  SFSNetwork.SendMessage(MsgDefines.ActMigration)
end

function ActMigrationManager:ReqGiveUp(serverId)
  UIUtil.ShowSecondMessageByParam({
    tipText = Localization:GetString("migration_activity_tips_20017"),
    btnNum = 2,
    showToggle = false,
    sureAction = function()
      UIUtil.ShowSecondMessageByParam({
        tipText = Localization:GetString("migration_activity_tips_20020", LuaEntry.Player:GetSourceServerId(), serverId),
        btnNum = 2,
        showToggle = false,
        sureAction = function()
          SFSNetwork.SendMessage(MsgDefines.ActMigrationGiveUp)
        end
      })
    end
  })
end

function ActMigrationManager:ReqMarket()
  SFSNetwork.SendMessage(MsgDefines.ActMigrationMarketList)
end

local function SortMarketList(a, b)
  local self = DataCenter.ActMigrationManager
  local dataA = self:GetMarketPlayer(a)
  local dataB = self:GetMarketPlayer(b)
  if not dataA or not dataB then
    return false
  end
  if dataA.bInvited ~= dataB.bInvited then
    return not dataA.bInvited
  end
  local markTime = self:GetMarketTime()
  local flagA = markTime <= dataA.time
  local flagB = markTime <= dataB.time
  if flagA ~= flagB then
    return flagA
  end
  if dataA.power ~= dataB.power then
    return dataA.power > dataB.power
  end
  if dataA.lv ~= dataB.lv then
    return dataA.lv > dataB.lv
  end
  return dataA.uid > dataB.uid
end

function ActMigrationManager:HandleMarket(t)
  local list = t.marketList
  if table.IsNullOrEmpty(list) then
    return
  end
  local idList = {}
  local dic = {}
  for _, info in pairs(list) do
    local uid = info.uid
    local data = self.marketDic[uid]
    if data == nil then
      data = ActMigrationPlayerData.New()
    end
    data:ParseData(info)
    dic[uid] = data
    MyInsert(idList, uid)
  end
  self.marketDic = dic
  if not table.IsNullOrEmpty(idList) then
    table.sort(idList, SortMarketList)
  end
  EventManager:GetInstance():Broadcast(EventId.ActMigrationGetMarketList, idList)
end

function ActMigrationManager:GetMarketTime()
  return CommonUtil.PlayerPrefsGetLong(MARKET_TIME_KEY, 0)
end

function ActMigrationManager:UpdateMarketTime(lastTime)
  local time = lastTime or 0
  if time == 0 then
    for _, info in pairs(self.marketDic) do
      if time < info.time then
        time = info.time
      end
    end
  end
  local signTime = self:GetMarketTime()
  if time > signTime then
    CommonUtil.PlayerPrefsSetLong(MARKET_TIME_KEY, time)
  end
end

function ActMigrationManager:GetMarketPlayer(uid)
  return self.marketDic[uid]
end

function ActMigrationManager:GetGuideConfig(gType)
  if self.guideConfig == nil or self.guideConfig[gType] == nil then
    local list = {}
    LocalController:instance():visitTable(TableName.Migration_Guide, function(id, lineData)
      local type = MyToNum(lineData:getValue("type"))
      if gType ~= type then
        return
      end
      local data = {}
      data.id = id
      if type == 1 then
        data.nameList = lineData:getValue("name_list")
        data.iconList = lineData:getValue("icon_list")
        data.descList = lineData:getValue("desc_list")
        MyInsert(list, data)
      elseif type == 2 then
        data.nameList = MySplit(lineData:getValue("name_list"), ";")
        data.iconList = MySplit(lineData:getValue("icon_list"), ";")
        data.descList = MySplit(lineData:getValue("desc_list"), ";")
        data.tittle = lineData:getValue("tittle")
        data.subTittle = lineData:getValue("sub_tittle")
        data.desc = lineData:getValue("tittle_desc")
        data.state = MyToNum(lineData:getValue("activity_time"))
        list[data.state] = data
      end
    end)
    if self.guideConfig == nil then
      self.guideConfig = {}
    end
    self.guideConfig[gType] = list
  end
  return self.guideConfig[gType]
end

local function IsSeasonConditionValid(season, seasonBeginDay, seasonEndDay)
  local isIn = false
  local nowSeason = DataCenter.SeasonDataManager:GetSeason()
  if nowSeason == season then
    local day = UITimeManager:GetInstance():GetServerOpenDays()
    if nowSeason ~= 0 then
      day = DataCenter.SeasonDataManager:GetSeasonDurationDay() + 1
    end
    if seasonBeginDay <= day and seasonEndDay >= day then
      isIn = true
    end
  end
  return isIn
end

function ActMigrationManager:GetSeasonTips(tType)
  if self.seasonTipsConfig == nil then
    local list = {}
    LocalController:instance():visitTable(TableName.LW_Migration_Season_Tips, function(id, lineData)
      local type = MyToNum(lineData:getValue("type"))
      local data = {}
      data.id = id
      data.type = type
      data.dialog_id = lineData:getValue("dialog_id")
      local seasonInfo = string.split(lineData:getValue("season_days"), ";")
      data.seasonId = tonumber(seasonInfo[1]) or 0
      local days = string.split(seasonInfo[2] or "", "-")
      data.dayS = tonumber(days[1]) or 0
      data.dayE = tonumber(days[2]) or 0
      MyInsert(list, data)
    end)
    self.seasonTipsConfig = list
  end
  local tipsKey
  for _, v in ipairs(self.seasonTipsConfig) do
    if v.type == tType and IsSeasonConditionValid(v.seasonId, v.dayS, v.dayE) then
      tipsKey = v.dialog_id
      break
    end
  end
  if string.IsNullOrEmpty(tipsKey) and GMUtils.IsGM() then
    local error = string.format("[\232\173\166\229\145\138] \233\133\141\231\189\174Migration_Season_Tips\228\184\173\230\137\190\228\184\141\229\136\176\231\177\187\229\158\139\228\184\186 %s , \232\181\155\229\173\163\228\184\186 %s \231\154\132\233\133\141\231\189\174\239\188\140\232\175\183\232\129\148\231\179\187\230\152\140\230\181\183\239\188\129", tType, DataCenter.SeasonDataManager:GetSeason())
    UIUtil.ShowTips(error)
    Logger.LogError(error)
  end
  return tipsKey or "100206"
end

function ActMigrationManager:GetSeatMaxCountByStateAndIdentify(serverState, identify)
  local config = self:GetZoneStandard(serverState)
  if not config then
    return 0
  end
  if identify == ActMigrationIdentity.SuperLow then
    return config.superLowNum or 0
  elseif identify == ActMigrationIdentity.Low then
    return config.lowNum or 0
  elseif identify == ActMigrationIdentity.Normal then
    return config.normalNum or 0
  elseif identify == ActMigrationIdentity.High then
    return config.strongNum or 0
  end
  return 0
end

function ActMigrationManager:GetZoneStandard(serverState)
  if self.zoneStandard == nil then
    local openConfig = self:GetOpenConfig()
    local myGroup = openConfig ~= nil and openConfig.group or nil
    local configs = {}
    LocalController:instance():visitTable(TableName.LW_Zone_Migration_Standard, function(id, lineData)
      local group = MyToNum(lineData:getValue("group"))
      if myGroup ~= group then
        return
      end
      local data = {}
      data.id = id
      data.status = MyToNum(lineData:getValue("status")) or 0
      data.superLowNum = MyToNum(lineData:getValue("super_low_number")) or 0
      data.lowNum = MyToNum(lineData:getValue("lower_number")) or 0
      data.normalNum = MyToNum(lineData:getValue("normal_number")) or 0
      data.strongNum = MyToNum(lineData:getValue("strong_number")) or 0
      MyInsert(configs, data)
    end)
    self.zoneStandard = configs
  end
  if serverState == nil then
    return self.zoneStandard
  end
  for _, v in ipairs(self.zoneStandard) do
    if serverState == v.status then
      return v
    end
  end
  return nil
end

function ActMigrationManager:GetMyServerSeatState(seatIndex)
  if seatIndex < 0 or 3 < seatIndex then
    return 0, 0
  end
  local myInfo = self:GetMyServerInfo()
  if not myInfo then
    return 0, 0
  end
  local info = self:GetMyZoneStandard()
  if not info then
    return 0, 0
  end
  local playerIn, total = 0, 0
  if seatIndex == ActMigrationIdentity.Low then
    total = info.lowNum or 0
    playerIn = myInfo.lowPlayerIn or 0
  elseif seatIndex == ActMigrationIdentity.Normal then
    total = info.normalNum or 0
    playerIn = myInfo.playerIn or 0
  elseif seatIndex == ActMigrationIdentity.High then
    total = info.strongNum or 0
    playerIn = myInfo.highPlayerIn or 0
  elseif seatIndex == ActMigrationIdentity.SuperLow then
    total = info.superLowNum or 0
    playerIn = myInfo.superLowPlayerIn or 0
  end
  local remain = Mathf.Max(total - playerIn, 0)
  return remain, total
end

function ActMigrationManager:GetMyZoneStandard()
  local sInfo = self:GetMyServerInfo()
  return self:GetZoneStandard(sInfo.serverState)
end

function ActMigrationManager:GetPersonStandard()
  if self.personStandard == nil then
    local openConfig = self:GetOpenConfig()
    local myGroup = openConfig ~= nil and openConfig.group or nil
    local configs = {}
    LocalController:instance():visitTable(TableName.LW_Migration_Person_Standard, function(id, lineData)
      local group = MyToNum(lineData:getValue("group"))
      if myGroup ~= group then
        return
      end
      local data = {}
      data.id = id
      data.range = MyStr2Array(lineData:getValue("range"), ";")
      data.name = lineData:getValue("identity_name")
      data.type = lineData:getValue("identity_type")
      data.cost = MyToNum(lineData:getValue("cost"))
      self.seatIdx2Name[data.type] = data.name
      MyInsert(configs, data)
    end)
    self.personStandard = configs
  end
  return self.personStandard
end

function ActMigrationManager:GetMyPersonStandard()
  local myInfo = self:GetMyInfo()
  local identity = myInfo ~= nil and myInfo.identity or ActMigrationIdentity.Low
  local configs = self:GetPersonStandard()
  for _, v in ipairs(configs) do
    if identity == v.type then
      return v
    end
  end
  return nil
end

function ActMigrationManager:GetItemId()
  if self.itemId == nil then
    self.itemId = 661013
  end
  return self.itemId
end

function ActMigrationManager:GetItemShopId()
  return 70029
end

function ActMigrationManager:GetItemIcon()
  local itemId = self:GetItemId()
  return DataCenter.ItemTemplateManager:GetIconPath(itemId)
end

function ActMigrationManager:GetItemHave()
  local itemId = self:GetItemId()
  return DataCenter.ItemData:GetItemCount(itemId)
end

function ActMigrationManager:GetStageText(state)
  local str = Localization:GetString("migration_activity_interface_1000" .. 3 + state)
  return str
end

local IMG_PLAYER_TYPE = "Assets/Main/Sprites/UI/LWUIMigration/mjc_S2_yimin_shenfen_icon_%d.png"

function ActMigrationManager:GetPlayerTypeImg(identity)
  local idx = 4
  if identity == ActMigrationIdentity.Low then
    idx = 1
  elseif identity == ActMigrationIdentity.Normal then
    idx = 2
  elseif identity == ActMigrationIdentity.High then
    idx = 3
  end
  return string.format(IMG_PLAYER_TYPE, idx)
end

local IMG_STATE_BG_1 = "Assets/Main/Sprites/UI/LWCommon/Sprite/cfm_tongyong_yeqian_sanji_1.png"
local IMG_STATE_BG_2 = "Assets/Main/Sprites/UI/LWUIMigration/mjc_S2_yimin_shenpi_erji_dichen_1.png"
local IMG_STATE_BG_3 = "Assets/Main/Sprites/UI/LWUIMigration/mjc_tongyong_erji_dichen_2.png"
local IMG_STATE_K_2 = "Assets/Main/Sprites/UI/LWUIMigration/mjc_S2_yimin_shenpi_jujue_kuang.png"
local IMG_STATE_K_3 = "Assets/Main/Sprites/UI/LWUIMigration/mjc_S2_yimin_shenpi_tongyi_kuang.png"

function ActMigrationManager:GetApplyStateImg(state)
  if state == 2 then
    return IMG_STATE_BG_3, IMG_STATE_K_3
  elseif state == 1 then
    return IMG_STATE_BG_1, IMG_STATE_K_3
  end
  return IMG_STATE_BG_2, IMG_STATE_K_2
end

function ActMigrationManager:GetRewards(idx)
  local values = string.string2array_i_oneSep(LuaEntry.DataConfig:TryGetStr("newbee_immigrate_setting", "k1"), ";")
  local rewardId = values ~= nil and values[idx] or nil
  if rewardId == nil or rewardId == 0 then
    return {}
  end
  local groups = DataCenter.ChampionDuelManager:GetRewardsById(rewardId)
  return groups
end

function ActMigrationManager:OnBtnIdentityClick(transform, identity)
  local strTip = Localization:GetString("migration_activity_tips_20040")
  UIUtil.ShowBubbleTips(strTip, transform.position, 0, -30, 0, nil, nil)
end

function ActMigrationManager:ClearFakeLoading()
  self:DeleteTimer()
  if self.postPrefabAsset then
    self.postPrefabAsset:Destroy()
  end
  self.postPrefabAsset = nil
end

local CLS_M_REWARD = "UI.LWUINewBeeMigrate.Component.LWUINewBeeMigrateLoading"
local PREFAB_M_REWARD = "Assets/Main/Prefabs/UI/LWMainUI/LWUINewBeeMigrateLoadingItem.prefab"

function ActMigrationManager:LoadMReward(content)
  local comp
  comp = content:LoadComponentAsync(CLS_M_REWARD, PREFAB_M_REWARD, content, function()
    comp:SetAnchoredPositionXY(0, 210)
  end)
  comp:SetData(self:GetRewards(2))
end

function ActMigrationManager:LoadFakeLoading(panelLoading, fakeCb)
  panelLoading:SetActive(true)
  local language = Localization.Language
  local Language = CS.GameFramework.Localization.Language
  local prefabPath = CS.GameDefines.UIAssets.SubLoadingNormal
  local bSeasonSnow = false
  local isArabic = false
  if not Config.IsPC() then
    isArabic = CommonUtil.IsArabic()
    if isArabic then
      prefabPath = CS.GameDefines.UIAssets.SubLoadingArabic
    elseif language == Language.SubLoadingKorean then
      prefabPath = CS.GameDefines.UIAssets.SubLoadingKorean
    elseif language == Language.SubLoadingJapanese then
      prefabPath = CS.GameDefines.UIAssets.SubLoadingJapanese
    elseif language == Language.SubLoadingThai then
      prefabPath = CS.GameDefines.UIAssets.SubLoadingThai
    else
      local seasonMapType = CS.UnityEngine.PlayerPrefs.GetInt(CS.GameDefines.SettingKeys.SEASON_MAP_TYPE)
      if seasonMapType == 3 then
        prefabPath = CS.GameDefines.UIAssets.SubLoadingSeasonSnow
        bSeasonSnow = true
      end
    end
  end
  local request = Resource:InstantiateAsync(prefabPath)
  self.postPrefabAsset = request
  request:completed("+", function(req)
    local go = req.gameObject
    if IsNull(go) then
      if type(req.Destroy) == "function" then
        req:Destroy()
      end
      self.postPrefabAsset = nil
      return
    end
    local rectTF = go:GetComponent(TypeofRT)
    if rectTF ~= nil then
      rectTF:SetParent(panelLoading.transform)
      rectTF:Set_localScale(1, 1, 1)
      rectTF:Set_offsetMin(0, 0)
      rectTF:Set_offsetMax(0, 0)
      rectTF:Set_pivot(0.5, 0.5)
    end
    if Config.IsPC() then
      self:FixBg(go)
    elseif isArabic then
      self:FixArabic(go)
    end
    self:InitFill(go, fakeCb)
    self:LoadMReward(panelLoading)
  end)
end

function ActMigrationManager:GetTypeTarget(go, name, type)
  local target = go.transform:Find(name)
  if target then
    return target:GetComponent(type)
  end
  return nil
end

function ActMigrationManager:FixBg(go)
  local background = go.transform:Find("Background")
  if not background then
    return
  end
  local rtf = background.gameObject:GetComponent(TypeofRT)
  if rtf then
    CS.RectTransformUtils.ApplyAutoScaling(rtf, 1.7777777777777777)
  end
  local bgImg = background:GetComponent(typeof(CS.UnityEngine.UI.RawImage))
  if bgImg then
    bgImg:LoadSpriteAsync("Assets/Main/SingleSprites/cfm_hengban_loading.png")
  end
end

function ActMigrationManager:FixArabic(go)
  local spineParent = self:GetTypeTarget(go, "Arabic_Spine", TypeofRT)
  if spineParent then
    local spine = self:GetTypeTarget(go, "Arabic_Spine/New SkeletonGraphic", TypeofRT)
    if spine then
      local curWidth = spineParent.rect.width
      spine:Set_localScale(curWidth / DefaultScreenWidth, 1, 1)
    end
  end
end

function ActMigrationManager:InitFill(go, fakeCb)
  local fill = self:GetTypeTarget(go, "ProgressBg/Slider", typeof(CS.UnityEngine.UI.Slider))
  if fill then
    fill.value = 0
  end
  self.fakeLoadingFill = fill
  self:AddTimer(fakeCb)
end

function ActMigrationManager:AddTimer(fakeCb)
  self:DeleteTimer()
  local num = 0
  local max = 100
  
  function self.fakeLoadingTimerAction()
    if num < max then
      num = num + 1
    else
      self:DeleteTimer()
      if fakeCb then
        fakeCb()
      end
    end
    if self.fakeLoadingFill then
      self.fakeLoadingFill.value = num / max
    end
  end
  
  self.fakeLoadingTimer = TimerManager:GetInstance():GetTimer(1, self.fakeLoadingTimerAction, self, false, true, false)
  self.fakeLoadingTimer:Start()
end

function ActMigrationManager:DeleteTimer()
  if self.fakeLoadingTimer ~= nil then
    self.fakeLoadingTimer:Stop()
    self.fakeLoadingTimer = nil
  end
  self.fakeLoadingTimerAction = nil
end

function ActMigrationManager:GetCountByMigrationIdentity(targetIdentity)
  local ret = 0
  for k, v in pairs(self.applyDic) do
    if v.identity == targetIdentity then
      ret = ret + 1
    end
  end
  return ret
end

function ActMigrationManager:ReqAllianceMarketListData(data)
  local msgData = {
    startIndex = data.startIndex or 0,
    num = data.num or MIGRATION_ALLY_LIST_FIX_REQ_NUM,
    searchName = data.searchName or "",
    saveTag = data.saveTag and 1 or 0,
    searchTag = table.concat(data.searchTag, "|"),
    searchLanguage = ""
  }
  if data.saveLang and data.searchLanguageId then
    local lanName = SuportedLanguagesLocalName[data.searchLanguageId]
    if lanName then
      msgData.searchLanguage = lanName
    end
  end
  if self:NewChooseCompEnable() then
    msgData.comprehensiveScore = data.stars or 0
    msgData.desertTime = data.desertTime or 7
  end
  SFSNetwork.SendMessage(MsgDefines.SeasonMigrateAlMarketList, msgData)
end

function ActMigrationManager:OnHandleAllianceMarketListData(msg)
  if msg and msg.allianceMarketList then
    local startIndex = msg.startIndex
    local num = msg.num
    for i = startIndex + 1, startIndex + num do
      self.alMarketListData[i] = nil
    end
    for i = 1, #msg.allianceMarketList do
      local item = msg.allianceMarketList[i]
      self.alMarketListData[startIndex + i] = DeepCopy(item)
    end
    EventManager:GetInstance():Broadcast(EventId.ActMigrationOnHandleAllianceMarketList)
  end
end

function ActMigrationManager:ReqSelfAllianceMarketData()
  SFSNetwork.SendMessage(MsgDefines.SeasonMigrateGetAllianceMarket)
end

function ActMigrationManager:OnHandleSelfAllianceMarketData(msg)
  if msg then
    self.selfAllianceMarketData = ActMigrationAlMarketData.New()
    self.selfAllianceMarketData:ParseData(msg)
    self.publishCDEndTime = msg.cdEndTime
    EventManager:GetInstance():Broadcast(EventId.ActMigrationOnHandleSelfAllianceMarket)
  end
end

function ActMigrationManager:SendPublishSelfAllianceMarketData(data)
  SFSNetwork.SendMessage(MsgDefines.SeasonMigratePublishAllianceMarket, data)
end

function ActMigrationManager:OnHandlePublishSelfAllianceMarketData(msg)
  if msg then
    self.selfAllianceMarketData = ActMigrationAlMarketData.New(msg)
    self.selfAllianceMarketData:ParseData(msg)
    EventManager:GetInstance():Broadcast(EventId.ActMigrationOnHandlePublishAllianceMarket)
  end
end

function ActMigrationManager:GetRemainPublishTextCDTime()
  if self.publishCDEndTime and self.publishCDEndTime ~= 1 then
    local curTime = UITimeManager:GetInstance():GetServerTime()
    return self.publishCDEndTime - curTime
  end
end

function ActMigrationManager:SendSaveAllianceMarket(allianceId, isSave)
  local data = {allianceId = allianceId, type = isSave}
  UIUtil.ShowTipsId(isSave == 1 and "300033" or "280154")
  SFSNetwork.SendMessage(MsgDefines.SeasonMigrateSaveAllianceMarket, data)
end

function ActMigrationManager:OnHandleSaveAllianceMarket(msg)
  if msg and msg.success then
    EventManager:GetInstance():Broadcast(EventId.ActMigrationOnHandleSaveAllianceMarket)
  end
end

function ActMigrationManager:SendCancelPublishSelfAllianceMarketData()
  SFSNetwork.SendMessage(MsgDefines.SeasonMigrateDeleteAllianceMarket)
end

function ActMigrationManager:OnHandleCancelPublishSelfAllianceMarketData(msg)
  if msg then
    EventManager:GetInstance():Broadcast(EventId.ActMigrationOnHandleDeleteAllianceMarket)
  end
end

function ActMigrationManager:AddOrGetAllyRecruitTranslateDatas(allianceId, postContent, postLang)
  self.allyRecruitTranslateTextDic = self.allyRecruitTranslateTextDic or {}
  if self.allyRecruitTranslateTextDic[allianceId] == nil then
    self.allyRecruitTranslateTextDic[allianceId] = ActMigrationAllyRecruitTranslateData.New()
  end
  local transData = self.allyRecruitTranslateTextDic[allianceId]
  transData:SetAllianceId(allianceId)
  transData:SetSourceMsg(postContent)
  transData:SetSourceLang(postLang)
  return transData
end

function ActMigrationManager:GetAllyRecruitTranslateDatas(allianceId)
  local transDataList = self.allyRecruitTranslateTextDic[allianceId]
  if transDataList == nil then
    Logger.LogError("\231\191\187\232\175\145\231\188\147\229\173\152\228\184\186\231\169\186!")
    return
  end
  if self.allyRecruitTranslateTextDic[allianceId] == nil then
    Logger.LogError("\231\191\187\232\175\145\231\188\147\229\173\152\228\184\186\231\169\186!allianceId\239\188\154  " .. allianceId)
    return
  end
  return self.allyRecruitTranslateTextDic[allianceId]
end

function ActMigrationManager:OpenFupinGuide()
  local param = {}
  param.howToPlayList = {500013}
  UIManager:GetInstance():OpenWindow(UIWindowNames.UILWHowToPlay, {anim = true}, param)
end

function ActMigrationManager:TryGetStarList()
  if self.starList then
    return self.starList
  end
  self:SendServerStarListRequest()
  return nil
end

function ActMigrationManager:SendServerStarListRequest()
  if self.starList then
    return
  end
  SFSNetwork.SendMessage(MsgDefines.SeasonMigrateServerStarList)
end

function ActMigrationManager:SendServerStarDetailRequest(serverId)
  if not serverId then
    return
  end
  SFSNetwork.SendMessage(MsgDefines.SeasonMigrateServerStarDetail, serverId)
end

function ActMigrationManager:OnHandleServerStarList(msg)
  if self.starList then
    return
  end
  self.starList = self.starList or ActMigrationStarList.New()
  self.starList:ParseData(msg)
  EventManager:GetInstance():Broadcast(EventId.ActMigrationStarListRefresh)
end

function ActMigrationManager:GetMyScore()
  local myInfo = self:GetMyInfo()
  return myInfo and myInfo.score or 0
end

function ActMigrationManager:OnHandleServerStarDetail(msg)
  if self.starList then
    local info = self.starList:ParseServerData(msg)
    if not info then
      return
    end
    EventManager:GetInstance():Broadcast(EventId.ActMigrationStarDetailRefresh, info)
  end
end

function ActMigrationManager:NewChooseCompEnable()
  return LuaEntry.DataConfig:CheckSwitch("migration_opt_hire")
end

function ActMigrationManager:IsZoneStarEnable()
  local switchEnable = LuaEntry.DataConfig:CheckSwitch("migration_opt_zone_star")
  if not switchEnable then
    return false
  end
  local itemSeason = LuaEntry.DataConfig:TryGetNum("lw_migration", "k8", 0)
  local currentSeason = SeasonUtil.GetSeason()
  local seasonCheck = itemSeason <= currentSeason
  return seasonCheck
end

function ActMigrationManager:OnGetKingInfoHandler(msg)
  if not msg or not msg.migrateOpenState then
    return
  end
  self.nbServerDic = self.nbServerDic or {}
  self.nbServerDic[msg.serverId] = msg.migrateOpenState == 3
end

function ActMigrationManager:IsNBServer()
  if not self:IsZoneStarEnable() then
    return false
  end
  if not self.nbServerDic then
    return false
  end
  local curServer = LuaEntry.Player:GetCurServerId()
  return self.nbServerDic[curServer] == true
end

function ActMigrationManager:GetMaxMarkPlayerNum()
  return LuaEntry.DataConfig:TryGetNum("lw_migration", "k9", 500)
end

function ActMigrationManager:ReqPlayerMark(targetUid, isMark)
  if not self:CheckCanSetting(true) then
    return
  end
  if isMark then
    local myInfo = self:GetMyInfo()
    local cur = myInfo ~= nil and myInfo.markedCount or 0
    local max = self:GetMaxMarkPlayerNum()
    if cur >= max then
      UIUtil.ShowTips(Localization:GetString("migration_activity_tips_20059", max))
      return
    end
    SFSNetwork.SendMessage(MsgDefines.ActMigrationMarkPlayer, targetUid, isMark)
  else
    UIUtil.ShowSecondMessageByParam({
      tipText = Localization:GetString("migration_activity_tips_20062"),
      btnNum = 2,
      showToggle = false,
      sureAction = function()
        SFSNetwork.SendMessage(MsgDefines.ActMigrationMarkPlayer, targetUid, isMark)
      end
    })
  end
end

function ActMigrationManager:ReqPlayerMarkSearch(content)
  SFSNetwork.SendMessage(MsgDefines.ActMigrationMarkSearchName, content or "")
end

function ActMigrationManager:UpdatePlayerMark(targetUid, serverId, isMark)
  if MyStrNull(targetUid) then
    return
  end
  local myInfo = self:GetMyInfo()
  if myInfo then
    myInfo:SetMarkedUid(targetUid, serverId, isMark)
    EventManager:GetInstance():Broadcast(EventId.ActMigrationMarkPlayerUpdate, targetUid)
    if isMark ~= nil then
      UIUtil.ShowTipsId(isMark and "migration_activity_tips_20060" or "migration_activity_tips_20061")
    end
  end
end

function ActMigrationManager:GetPlayerMark(targetUid)
  local myInfo = self:GetMyInfo()
  return myInfo ~= nil and myInfo:GetMarkServerId(targetUid) or nil
end

function ActMigrationManager:IsPlayerMarked(targetUid)
  return self:GetPlayerMark(targetUid) ~= nil
end

function ActMigrationManager:GetAllMarkUids()
  local myInfo = self:GetMyInfo()
  return myInfo ~= nil and myInfo:GetAllMarkUids() or {}
end

function ActMigrationManager:OnAlLeaderChanged()
  local myInfo = self:GetMyInfo()
  if myInfo ~= nil then
    myInfo:ResetMarkedData()
  end
end

return ActMigrationManager
