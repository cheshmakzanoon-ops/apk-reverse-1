local logger = require("Framework.Logger.Logger")
local PlayerInfoDataManager = BaseClass("PlayerInfoDataManager")
local UILWRemarkNameData = require("UI.LWPlayerInfo.UILWPlayerRemarkName.UILWRemarkNameList.Model.UILWRemarkNameData")

local function __init(self)
  self.otherPlayerData = {}
  self.selfPlayerData = nil
  self.otherPlayerRemarkList = {}
  self.singlePageRemarkPlayerCount = 500
  self.titleList = {}
  self.hasAddAttrTitle = false
  self.getTitleList = nil
  self.showHighFive = false
  self.lastTimePlayerInfoGet = {}
  self.lockRequest = false
end

local function __delete(self)
  self.otherPlayerData = nil
  self.selfPlayerData = nil
  self.otherPlayerRemarkList = nil
  self.showHighFive = false
end

local function RefreshSelfPlayerData(self, message)
  if self.selfPlayerData == nil then
    self.selfPlayerData = BasePlayerInfo.New()
  end
  self.selfPlayerData:ParseData(message)
  self.selfPlayerData.updateTime = UITimeManager:GetInstance():GetServerTime()
end

local function RefreshOtherPlayerData(self, message)
  local data = BasePlayerInfo.New()
  data:ParseData(message)
  data.updateTime = UITimeManager:GetInstance():GetServerTime()
  self.otherPlayerData[data.uid] = data
end

local function RefreshPlayerData(self, message)
  if message.uid ~= nil then
    if message.uid == self:GetSelfUid() then
      self:RefreshSelfPlayerData(message)
    else
      self:RefreshOtherPlayerData(message)
    end
  end
end

local function GetPlayerDataByUid(self, uid, force)
  local curTime = UITimeManager:GetInstance():GetServerTime()
  local retPlayerInfo
  if uid == self:GetSelfUid() then
    retPlayerInfo = self.selfPlayerData
    if retPlayerInfo then
      LuaEntry.Player.level = retPlayerInfo.level
    end
  else
    retPlayerInfo = self.otherPlayerData[uid]
  end
  if force then
    return retPlayerInfo
  end
  if retPlayerInfo ~= nil then
    local timeDiff = curTime - retPlayerInfo.updateTime
    if timeDiff <= 15000 then
      return retPlayerInfo
    end
  end
  return nil
end

local function RequestPlayerData(self, uid_, fetchProfileHint_, force_)
  if self.lockRequest then
    return
  end
  self.lockRequest = true
  uid_ = uid_ or LuaEntry.Player.uid
  if fetchProfileHint_ or uid_ == LuaEntry.Player.uid then
    SFSNetwork.SendMessage(MsgDefines.GetNewUserInfo, uid_, fetchProfileHint_)
    self.lockRequest = false
    return
  end
  if self:GetPlayerDataByUid(uid_, force_) then
    EventManager:GetInstance():Broadcast(EventId.GetNewUserInfoSucc, uid_)
    self.lockRequest = false
    return
  end
  local now = UITimeManager:GetInstance():GetServerTime()
  local lastTime = self.lastTimePlayerInfoGet[uid_] or 0
  if now - lastTime < 10000 then
    self.lockRequest = false
    return
  end
  self.lastTimePlayerInfoGet[uid_] = now
  SFSNetwork.SendMessage(MsgDefines.GetNewUserInfo, uid_)
  self.lockRequest = false
end

local function RequestPlayerDataMulti(self, uid, force_)
  if not self.requestUidDic then
    self.requestUidDic = {}
  end
  self.requestUidDic[uid] = force_ or 0
  if self.timer == nil then
    self.timer = TimerManager:GetInstance():GetTimer(0.1, self.PlayerDataMultiTimer, self, true, false, false)
  end
  self.timer:Start()
end

local function PlayerDataMultiTimer(self)
  self.timer:Stop()
  self.timer = nil
  if table.IsNullOrEmpty(self.requestUidDic) then
    return
  end
  local now = UITimeManager:GetInstance():GetServerTime()
  local uidArr = {}
  for uid, v in pairs(self.requestUidDic) do
    if not self:GetPlayerDataByUid(uid, v == true) then
      local lastTime = self.lastTimePlayerInfoGet[uid] or 0
      if 10000 < now - lastTime then
        self.lastTimePlayerInfoGet[uid] = now
        table.insert(uidArr, uid)
      end
    end
  end
  self.requestUidDic = nil
  if 0 < #uidArr then
    for i, uid in ipairs(uidArr) do
      SFSNetwork.SendMessage(MsgDefines.GetNewUserInfo, uid)
    end
  else
    EventManager:GetInstance():Broadcast(EventId.GetNewUserInfoMultiSucc)
  end
end

local function GetSelfUid(self)
  return LuaEntry.Player:GetUid()
end

local function ChangeSelfName(self, name)
  if self.selfPlayerData ~= nil then
    self.selfPlayerData:ChangeSelfName(name)
  end
end

local function ChangeSelfGender(self, gender)
  if self.selfPlayerData ~= nil then
    self.selfPlayerData:ChangeSelfGender(gender)
  end
end

local function ChangeSelfMood(self, moodStr)
  if self.selfPlayerData ~= nil then
    self.selfPlayerData:ChangeMoodStr(moodStr)
  end
end

local function ChangeSelfTitle(self, title)
  if self.selfPlayerData ~= nil then
    self.selfPlayerData:ChangeTitle(title)
    self.selfPlayerData.updateTime = UITimeManager:GetInstance():GetServerTime()
  end
end

local function ChangeSelfTitlePosition(self, title, position)
  if self.selfPlayerData ~= nil then
    self.selfPlayerData:ChangeTitlePosition(title, position)
  end
end

local function SetPlayerInteractiveHistory(self, receiveList, sendList)
  self.theInteractiveHistory = {receive = receiveList, send = sendList}
end

local function GetPlayerInteractiveHistory(self)
  return self.theInteractiveHistory or {}
end

function PlayerInfoDataManager:ParseRemarkNameMessage(page, remarkList)
  if 3 <= page then
    logger.LogError("\228\187\142\230\156\141\229\138\161\229\153\168\228\184\139\229\143\145\231\154\132page\233\161\181\230\149\176\228\184\141\229\175\185\239\188\154" .. page)
    return
  end
  if page == 1 then
    self.otherPlayerRemarkList = {}
  end
  if remarkList and 0 < #remarkList and remarkList[1].uid ~= LuaEntry.Player.uid then
    logger.LogError("\229\164\135\230\179\168\229\144\141\229\136\151\232\161\168\230\156\141\229\138\161\229\153\168\228\184\139\229\143\145\230\149\176\230\141\174\233\148\153\232\175\175\239\188\140\231\142\169\229\174\182Uid\228\184\142\229\189\147\229\137\141\228\184\141\231\172\166")
  end
  table.walk(remarkList, function(k, v)
    local remarkNameData = UILWRemarkNameData.New()
    remarkNameData:ParseData(v)
    table.insert(self.otherPlayerRemarkList, remarkNameData)
  end)
  if page == 1 and #self.otherPlayerRemarkList >= self.singlePageRemarkPlayerCount then
    DataCenter.PlayerInfoDataManager:RequestRemarkNameList(2)
  else
    table.sort(self.otherPlayerRemarkList, function(a, b)
      return a.lastUpdateTime > b.lastUpdateTime
    end)
    EventManager:GetInstance():Broadcast(EventId.RefreshRemarkNameListView)
  end
end

function PlayerInfoDataManager:AddOrRefreshPlayerRemark(targetUid, remark, lastUpdateTime)
  if targetUid == nil or remark == nil or lastUpdateTime == nil then
    return
  end
  self.otherPlayerRemarkList = self.otherPlayerRemarkList or {}
  for i = 1, #self.otherPlayerRemarkList do
    if self.otherPlayerRemarkList[i]:GetPlayerUid() == targetUid then
      if remark == "" then
        table.remove(self.otherPlayerRemarkList, i)
        return
      end
      self.otherPlayerRemarkList[i]:SetRemarkName(remark)
      self.otherPlayerRemarkList[i]:SetLastUpdateTime(lastUpdateTime)
      return
    end
  end
  local remarkNameData = UILWRemarkNameData.New()
  remarkNameData:SetPlayerUid(targetUid)
  remarkNameData:SetRemarkName(remark)
  remarkNameData:SetLastUpdateTime(lastUpdateTime)
  table.insert(self.otherPlayerRemarkList, remarkNameData)
end

function PlayerInfoDataManager:GetOtherPlayerRemarkList()
  return self.otherPlayerRemarkList or {}
end

function PlayerInfoDataManager:GetRemarkOrRealName(uid, realName)
  realName = realName or ""
  if IsNull(uid) then
    return realName, false
  end
  self.otherPlayerRemarkList = self.otherPlayerRemarkList or {}
  for i = 1, #self.otherPlayerRemarkList do
    if self.otherPlayerRemarkList[i]:GetPlayerUid() == uid then
      return self.otherPlayerRemarkList[i]:GetRemarkName(), true
    end
  end
  return realName, false
end

function PlayerInfoDataManager:RequestRemarkNameList(page)
  SFSNetwork.SendMessage(MsgDefines.RemarkNameListMessage, page, self.singlePageRemarkPlayerCount)
end

function PlayerInfoDataManager:IsReachRemarkLimit()
  if self.otherPlayerRemarkList == nil then
    return false
  end
  return #self.otherPlayerRemarkList >= self.singlePageRemarkPlayerCount * 2
end

function PlayerInfoDataManager:IsPlayerRemarked(uid)
  if IsNull(uid) then
    return false
  end
  self.otherPlayerRemarkList = self.otherPlayerRemarkList or {}
  for i = 1, #self.otherPlayerRemarkList do
    if self.otherPlayerRemarkList[i]:GetPlayerUid() == uid then
      return true
    end
  end
  return false
end

function PlayerInfoDataManager:NeedRequestGoldDetail()
  if self.lastTimeRequestGoldDetail == nil then
    return true
  end
  local curTime = UITimeManager:GetInstance():GetServerTime()
  if curTime - self.lastTimeRequestGoldDetail > 300 then
    return true
  end
  return false
end

function PlayerInfoDataManager:RequestGoldDetail()
  SFSNetwork.SendMessage(MsgDefines.GoldDetail)
  self.lastTimeRequestGoldDetail = UITimeManager:GetInstance():GetServerTime()
end

function PlayerInfoDataManager:NeedRequestGoldBrickDetail()
  if self.lastTimeRequestGoldBrickDetail == nil then
    return true
  end
  local curTime = UITimeManager:GetInstance():GetServerTime()
  if curTime - self.lastTimeRequestGoldBrickDetail > 1000 then
    return true
  end
  return false
end

function PlayerInfoDataManager:RequestGoldBrickDetail()
  SFSNetwork.SendMessage(MsgDefines.GoldDetail)
  SFSNetwork.SendMessage(MsgDefines.GoldBrickDetail)
  self.lastTimeRequestGoldBrickDetail = UITimeManager:GetInstance():GetServerTime()
end

function PlayerInfoDataManager:OnGetGoldDetail(message)
  if LuaEntry and LuaEntry.Player then
    LuaEntry.Player:UpdateGold(message)
    EventManager:GetInstance():Broadcast(EventId.GetGoldDetailData)
  end
end

function PlayerInfoDataManager:OnGetGoldBrickDetail(message)
  if LuaEntry and LuaEntry.Player then
    LuaEntry.Player:UpdateGoldBrickDetail(message)
    EventManager:GetInstance():Broadcast(EventId.GetGoldBrickDetail)
  end
end

function PlayerInfoDataManager:ShowGoldDetail()
  local goldDetailFunctionUnlock = false
  local unlockType = LuaEntry.DataConfig:TryGetNum("diamond_recharge_tips", "k1", 0)
  if unlockType == 1 then
    local isJPUser = LuaEntry.Player.JPUser
    goldDetailFunctionUnlock = isJPUser
  end
  return goldDetailFunctionUnlock
end

function PlayerInfoDataManager:CanShowGoldBrickDetail()
  local functionUnlock = false
  local unlockType = LuaEntry.DataConfig:TryGetNum("diamond_recharge_tips", "k2", 0)
  if unlockType == 1 then
    local isJPUser = LuaEntry.Player.JPUser
    functionUnlock = isJPUser
  end
  return functionUnlock
end

function PlayerInfoDataManager:SetPlayerFriendsCircleSetting(message)
  if message.uid and self.otherPlayerData[message.uid] then
    self.otherPlayerData[message.uid]:ParseData(message)
  end
end

function PlayerInfoDataManager:GetTitleList()
  local showList = {}
  if self.titleList then
    local curTime = UITimeManager:GetInstance():GetServerTime()
    for i, v in ipairs(self.titleList) do
      if not v.endTime or v.endTime <= 0 or curTime < v.endTime then
        table.insert(showList, v)
      end
    end
  end
  return showList
end

function PlayerInfoDataManager:GetTitle(cfgId)
  if self.titleList then
    for i, v in ipairs(self.titleList) do
      if v.cfgId == cfgId then
        return v
      end
    end
  end
  return nil
end

function PlayerInfoDataManager:HasTitleSkill(checkView)
  if not self.titleList then
    return false
  end
  local curTime = UITimeManager:GetInstance():GetServerTime()
  for i, v in ipairs(self.titleList) do
    if not v.endTime or v.endTime <= 0 or curTime < v.endTime then
      local info = DataCenter.PlayerTitleTemplateManager:GetTitleInfo(v.cfgId)
      if info and info.linkSkill and 0 < info.linkSkill then
        if checkView then
          local skillTemp = DataCenter.MasteryManager:GetSkillTemplate(info.linkSkill)
          if skillTemp and not skillTemp:CheckUsePosition(MasterySkillUsePosType.SkillView) then
            return true
          end
        else
          return true
        end
      end
    end
  end
end

function PlayerInfoDataManager:UpdateTitleList(titleList)
  if titleList then
    self.titleList = titleList
  end
  local hasAddAttrTitle = false
  if self.titleList then
    for i, v in ipairs(self.titleList) do
      local info = DataCenter.PlayerTitleTemplateManager:GetTitleInfo(v.cfgId)
      if info then
        hasAddAttrTitle = hasAddAttrTitle or info.extraPara ~= nil or info.status ~= nil
      end
      if v.popUpState ~= 1 then
        self:ShowGetTitle(v)
      end
    end
  end
  self.hasAddAttrTitle = hasAddAttrTitle
  EventManager:GetInstance():Broadcast(EventId.UserTitleGetListMessage)
end

function PlayerInfoDataManager:UpdateTitle(title)
  if not (title and self.titleList) or title.uid ~= self:GetSelfUid() then
    return
  end
  title.requestTime = UITimeManager:GetInstance():GetServerTime()
  local oldTitle = self:GetTitle(title.cfgId)
  if oldTitle then
    if title.globalNum then
      oldTitle.globalNum = title.globalNum
    end
    oldTitle.rank = title.rank
    oldTitle.createTime = title.createTime
    oldTitle.endTime = title.endTime
    oldTitle.position = title.position
    oldTitle.count = title.count
    oldTitle.getTimes = title.getTimes
    oldTitle.popUpState = title.popUpState
    oldTitle.requestTime = title.requestTime
    oldTitle.globalNum = title.globalNum
  else
    table.insert(self.titleList, title)
  end
  if title.popUpState ~= 1 then
    self:ShowGetTitle(title)
  end
  EventManager:GetInstance():Broadcast(EventId.UserTitleUpdate, title)
end

function PlayerInfoDataManager:ShareTitle(cfgId, uid)
  if not cfgId then
    UIUtil.ShowTipsId("lw_title_ui_13")
    return
  end
  local share_param = {}
  share_param.postType = PostType.Title
  share_param.uid = uid
  share_param.cfgId = cfgId
  local chatData = {}
  chatData.post = share_param.postType
  chatData.postType = share_param.postType
  chatData.param = share_param
  UIManager:GetInstance():OpenWindow(UIWindowNames.UIPositionShare, {anim = true}, chatData)
end

function PlayerInfoDataManager:ShowTitleDetail(titleId, uid)
  if not uid then
    return
  end
  SFSNetwork.SendMessage(MsgDefines.UserTitleGetDetail, titleId, uid)
end

function PlayerInfoDataManager:ShowGetTitle(titleData)
  if not self.getTitleList then
    self.getTitleList = {}
  else
    for i, v in ipairs(self.getTitleList) do
      if v.cfgId == titleData.cfgId then
        return
      end
    end
  end
  table.insert(self.getTitleList, titleData)
  local canShow = not BattleFieldUtil.InBattleField() and (SceneUtils.GetIsInCity() or SceneUtils.GetIsInWorld())
  if not canShow then
    DataCenter.UIPopWindowManager:Push(UIWindowNames.UITitleGetShow, {anim = true}, self.getTitleList)
    return
  end
  if not UIManager:GetInstance():IsWindowOpen(UIWindowNames.UITitleGetShow) then
    UIManager:GetInstance():OpenWindow(UIWindowNames.UITitleGetShow, {anim = true}, self.getTitleList)
  end
end

function PlayerInfoDataManager:RequestHighFiveInfo()
  self.showHighFive = true
  DataCenter.PlayerInfoDataManager:RequestPlayerData(LuaEntry.Player.uid, "2")
end

function PlayerInfoDataManager:OnReceiveNewUserInfo(uid)
  if LuaEntry.Player.uid ~= uid then
    return
  end
  local info = DataCenter.PlayerInfoDataManager:GetPlayerDataByUid(uid, true)
  if info == nil then
    return
  end
  if not self.showHighFive then
    return
  end
  self.showHighFive = false
  local isThumbsUp = info.highFiveDiff and info.highFivePlayerList and info.highFiveDiff > 0 and table.count(info.highFivePlayerList) ~= 0
  if isThumbsUp then
    UIManager:GetInstance():OpenWindow(UIWindowNames.UILWPlayerThumbsUpGlory, {anim = true}, DeepCopy(info))
    info.highFiveCount = info.joinAllianceThumbsUpCount
  end
end

PlayerInfoDataManager.__init = __init
PlayerInfoDataManager.__delete = __delete
PlayerInfoDataManager.RefreshPlayerData = RefreshPlayerData
PlayerInfoDataManager.GetPlayerDataByUid = GetPlayerDataByUid
PlayerInfoDataManager.RequestPlayerData = RequestPlayerData
PlayerInfoDataManager.RequestPlayerDataMulti = RequestPlayerDataMulti
PlayerInfoDataManager.PlayerDataMultiTimer = PlayerDataMultiTimer
PlayerInfoDataManager.GetSelfUid = GetSelfUid
PlayerInfoDataManager.RefreshSelfPlayerData = RefreshSelfPlayerData
PlayerInfoDataManager.RefreshOtherPlayerData = RefreshOtherPlayerData
PlayerInfoDataManager.ChangeSelfName = ChangeSelfName
PlayerInfoDataManager.ChangeSelfGender = ChangeSelfGender
PlayerInfoDataManager.ChangeSelfMood = ChangeSelfMood
PlayerInfoDataManager.ChangeSelfTitle = ChangeSelfTitle
PlayerInfoDataManager.ChangeSelfTitlePosition = ChangeSelfTitlePosition
PlayerInfoDataManager.SetPlayerInteractiveHistory = SetPlayerInteractiveHistory
PlayerInfoDataManager.GetPlayerInteractiveHistory = GetPlayerInteractiveHistory
return PlayerInfoDataManager
