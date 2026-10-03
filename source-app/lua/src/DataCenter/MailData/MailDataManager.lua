local MailDataManager = BaseClass("MailDataManager", CEventable)
local MailDBManager = require("DataCenter.MailData.MailDBManager")
local MailFileManager = require("DataCenter.MailData.MailFileManager")
local MailGroup = require("DataCenter.MailData.MailGroup")
local MailInfo = require("DataCenter.MailData.MailInfo")
local MailTranslateManager = require("DataCenter.MailData.MailTranslateManager")
local MailFilterManager = require("DataCenter.MailData.MailFilterManager")
local Localization = CS.GameEntry.Localization
require("DataCenter.MailData.MailEnum")
local rapidjson = require("rapidjson")
local base64 = require("Framework.Common.base64")
local THIRTY_DAYS = 2592000000
local ONE_DAY = 86400000
local REQUEST_COUNT = 20
local Mail_Receive_Log_Key = "Mail_Receive_Log_Key"
local estimateTableSize = require("Common.Debug.EstimateTableSize")
local UseFileSystem = true

function MailDataManager:__initGroup()
  local group = {}
  group[MailInternalGroup.MAIL_IN_hide] = MailGroup.New(MailInternalGroup.MAIL_IN_hide)
  group[MailInternalGroup.MAIL_IN_report] = MailGroup.New(MailInternalGroup.MAIL_IN_report)
  group[MailInternalGroup.MAIL_IN_alliance] = MailGroup.New(MailInternalGroup.MAIL_IN_alliance)
  group[MailInternalGroup.MAIL_IN_activity] = MailGroup.New(MailInternalGroup.MAIL_IN_activity)
  group[MailInternalGroup.MAIL_IN_system] = MailGroup.New(MailInternalGroup.MAIL_IN_system)
  group[MailInternalGroup.MAIL_IN_daily] = MailGroup.New(MailInternalGroup.MAIL_IN_daily)
  group[MailInternalGroup.MAIL_IN_charge] = MailGroup.New(MailInternalGroup.MAIL_IN_charge)
  group[MailInternalGroup.MAIL_IN_favor] = MailGroup.New(MailInternalGroup.MAIL_IN_favor)
  group[MailInternalGroup.MAIL_IN_season] = MailGroup.New(MailInternalGroup.MAIL_IN_season)
  self.group = group
  if LocalController:instance():hasTable(TableName.Mail_Group) then
    LocalController:instance():visitTable(TableName.Mail_Group, function(id, lineData)
      local mailType = lineData.type
      local mailGroup = lineData.group
      MailTypeToInternalGroup[tonumber(mailType)] = tonumber(mailGroup)
    end)
  end
end

function MailDataManager:__mailTypeToGroup(mailType, saveFlag)
  if saveFlag == 1 then
    return MailInternalGroup.MAIL_IN_favor
  end
  local groupType = MailTypeToInternalGroup[mailType]
  return groupType
end

function MailDataManager:__init()
  self.group = {}
  self.DB = MailDBManager.New()
  self.Filter = MailFilterManager.New()
  self.File = MailFileManager.New()
  self.Translate = MailTranslateManager.New()
  self.queryingMails = {}
  self.pullOver = false
  self.initUnrewardCountSuccess = false
  self.cachePush = {}
  self.gmDeleteMailList = {}
  self.mailSuccessLogs = {}
  self.mailTipBtnType = 0
  self.fromTag = nil
  self.fromData = nil
  self:RegisterEvent(EventId.BeforeLoginMsgSend, self.HandleBeforeLoginMsgSend)
  self:RegisterEvent(EventId.BattleReportPlaybackExitMidway, self.ClearFromTagAndFromData)
  self:__reset()
  MailPrint("MailDataManager:__init " .. tostring(self))
end

function MailDataManager:__delete()
  self.mailList = nil
  self.shareMailList = nil
  self.tempMailList = {}
  self.isAll = nil
  self.message = nil
  self.rewardCount = nil
  self.queryingMails = nil
  self.mailLikeList = nil
  self.Translate = nil
  self.pullOver = false
  self.initUnrewardCountSuccess = false
  self.cachePush = {}
  self.gmDeleteMailList = {}
  if self.File then
    self.File:Delete()
    self.File = nil
  end
  self.fromTag = nil
  self.fromData = nil
  self.mailTipBtnType = nil
end

function MailDataManager:__reset()
  self.mailList = {}
  self.shareMailList = {}
  self.tempMailList = {}
  self.lastUid = "0"
  self.lastTime = 0
  self.mailLikeList = {}
  self.serverLastUid = "0"
  self.serverLastTime = 0
  self.isAll = false
  self.rewardCount = 0
  self.message = {}
  self.gmDeleteMailList = {}
  self.mailTipBtnType = 0
  self.pullOver = false
  self.initUnrewardCountSuccess = false
  self:__initGroup()
  self.__estimateSize = 0
  self.__estimateSizeShare = 0
  self.__estimateSize = estimateTableSize(self)
end

function MailDataManager:HandleBeforeLoginMsgSend()
  self.pullOver = false
  self.initUnrewardCountSuccess = false
end

function MailDataManager:Startup()
  self:__reset()
  self.pullOver = false
  self.initUnrewardCountSuccess = false
  self.DB:Init(function(status, result)
    self:StartPull()
  end)
  self:CreateBattleReportTimer()
end

function MailDataManager:Cleanup()
  self:__reset()
  self.pullOver = false
  self.initUnrewardCountSuccess = false
  self.cachePush = {}
  if self.File then
    self.File:Delete()
    self.File = nil
  end
  if not table.IsNullOrEmpty(self.mailSuccessLogs) then
    CommonUtil.PlayerPrefsSetTable(Mail_Receive_Log_Key, self.mailSuccessLogs)
  end
  self.mailSuccessLogs = {}
  self:ClearBattleReportTimer()
end

function MailDataManager:CreateMailData()
  return MailInfo.New()
end

function MailDataManager:OnLiteReconnect()
end

function MailDataManager:StartPull()
  self.pullOver = false
  self.initUnrewardCountSuccess = false
  if self.oldestRewardUid then
    SFSNetwork.SendMessage(MsgDefines.MailGetMuti, self.oldestRewardUid, 0, REQUEST_COUNT, true, self.staticUids)
    Logger.LogInfo("MailDataManager::StartPull.1: " .. tostring(self.oldestRewardUid))
  else
    SFSNetwork.SendMessage(MsgDefines.MailGetMuti, self.lastUid, self.lastTime, REQUEST_COUNT, true)
    Logger.LogInfo("MailDataManager::StartPull.2: " .. tostring(self.lastUid))
  end
end

function MailDataManager:ContinuePull()
  SFSNetwork.SendMessage(MsgDefines.MailGetMuti, "0", 0, REQUEST_COUNT, false)
end

function MailDataManager:OnGetMailListMessage(message, processCache, refreshUnrewardCount)
  local saveList = {}
  local list = message.msg or {}
  if message.delMailGroupIds then
    self.gmDeleteMailList = message.delMailGroupIds or {}
  end
  for _, v in ipairs(list) do
    local m = self:GetMailInfoById(v.uid)
    local override = false
    if m == nil then
      m = self:CreateMailData()
      m:ParseBaseData(v)
      m.newMail = true
      self:AddMail(m)
    else
      override = true
      local oldStatus = m.status
      local oldRewardStatus = m.rewardStatus
      m:ParseBaseData(v)
      if m.groupId then
        local group = self.group[m.groupId]
        if group then
          if oldStatus == 0 and m.status == 1 then
            group:SetUnreadCount(group:GetUnreadCount() - 1)
          elseif oldStatus == 1 and m.status == 0 then
            group:SetUnreadCount(group:GetUnreadCount() + 1)
          end
          if oldRewardStatus == 0 and m.rewardStatus == 1 then
            group:SetUnrewardCount(group:GetUnrewardCount() - 1)
          elseif oldRewardStatus == 1 and m.rewardStatus == 0 then
            group:SetUnrewardCount(group:GetUnrewardCount() + 1)
          end
        end
      end
    end
    table.insert(saveList, m)
  end
  if not table.IsNullOrEmpty(saveList) then
    self.DB:InsertMailDatas(saveList, function(allisok, result)
      if allisok then
        self:OnMailInsertDBSuccess(saveList)
      end
    end)
  end
  if message.more then
    self:ContinuePull()
  else
    self.pullOver = true
    if 0 < #self.cachePush then
      local fakeMsg = self.cachePush
      self.cachePush = {}
      self:OnGetMailListMessage({msg = fakeMsg}, true, true)
    else
      self:ReadAllHideMail()
      self:DeleteExpireMail()
      self:DeleteGMMarkPresidentMail()
      if refreshUnrewardCount then
        self.DB:UpdateGroupUnreadCount(function()
          self.initUnrewardCountSuccess = true
        end)
      end
      EventManager:GetInstance():Broadcast(EventId.MailPush)
    end
  end
end

function MailDataManager:AddMail(mailData, calcTotal)
  if self.mailList == nil then
    return false
  end
  if table.IsNullOrEmpty(mailData) then
    MailPrint("mailData = nil !!")
    return false
  end
  if not self.lastTime or mailData.createTime > self.lastTime then
    self.lastTime = mailData.createTime
    self.lastUid = mailData.uid
  end
  if mailData.type == MailType.FIGHT_MONSTER and mailData.createTime < MonsterMailDeleteTimeStamp then
    return
  end
  local mailDataSize = estimateTableSize(mailData)
  local v = self.mailList[mailData.uid]
  if v then
    local prevSize = estimateTableSize(v)
    self.__estimateSize = self.__estimateSize + mailDataSize - prevSize
    v:ParseBaseData(mailData)
    return false
  end
  self.mailList[mailData.uid] = mailData
  self.__estimateSize = self.__estimateSize + mailDataSize + 32
  local groupId = self:__mailTypeToGroup(mailData.type, mailData.saveFlag)
  if groupId and self.group then
    local group = self.group[groupId]
    if group then
      group:AddMail(mailData, calcTotal)
      return true
    end
  end
  return false
end

function MailDataManager:HasMail(uid)
  local mailData = self.mailList[uid]
  if mailData then
    return true
  end
  return false
end

function MailDataManager:OnGetDBMails(mailDatas)
  MailPrint("\228\187\142\230\149\176\230\141\174\229\186\147\232\191\148\229\155\158\233\130\174\228\187\182\230\149\176\230\141\174:" .. #mailDatas)
  for _, v in ipairs(mailDatas) do
    self:AddMail(v, false)
    local mail = DataCenter.MailDataManager:GetMailInfoById(v.uid)
    mail:DownloadBattleReport()
  end
  self:DeleteGMMarkPresidentMail()
  return self:ReadAllHideMail()
end

function MailDataManager:OnDBLatestMailUid(t)
  self.lastUid = t.uid or "0"
  self.lastTime = t.createTime or 0
end

function MailDataManager:OnDBGroupUnreadCount(list, redFix)
  MailPrint("OnDBGroupUnreadCount: " .. #list)
  for _, v in ipairs(list) do
    local group = self.group[v.groupId]
    if group then
      group:SetTotal(v.total)
      group:SetUnrewardCount(v.unreward)
      if redFix and redFix[v.groupId] then
        group:SetUnreadCount(v.unread - redFix[v.groupId])
      else
        group:SetUnreadCount(v.unread)
      end
    else
      MailPrint("OnDBGroupUnreadCount erorr, not found group : " .. v.groupId)
    end
  end
end

function MailDataManager:OnDBRewardState(list)
  MailPrint("OnDBRewardState: " .. #list)
  self.oldestRewardUid = nil
  self.staticUids = {}
  for _, v in ipairs(list) do
    if self.oldestRewardUid == nil then
      if v.rewardStatus == 0 then
        self.oldestRewardUid = v.uid
      end
    elseif v.rewardStatus == 1 then
      table.insert(self.staticUids, v.uid)
    end
  end
  if #self.staticUids == 0 then
    self.staticUids = nil
  end
end

function MailDataManager:SetMailTranslated(uid, transMsg, transLang)
  local mailData = self:GetMailInfoById(uid)
  if mailData == nil then
    return
  end
  self.DB:UpdateMailData_Translate(mailData.uid, transMsg, transLang)
end

function MailDataManager:ReadMail(uid)
  local mailData = self:GetMailInfoById(uid)
  if mailData == nil then
    MailPrint("mail not found: " .. uid)
    return
  end
  MailPrint("set Mail read! : " .. mailData.uid)
  if mailData.status == 1 then
    return
  end
  mailData.status = 1
  local group = self.group[mailData.groupId]
  if group == nil then
    MailPrint("error! no group ~!")
  end
  if group then
    group:SetUnreadCount(group:GetUnreadCount() - 1)
  end
  self.DB:UpdateMailData_Read(mailData.uid)
  SFSNetwork.SendMessage(MsgDefines.MailReadStatus, mailData.uid, 1)
  EventManager:GetInstance():Broadcast(EventId.MailPush)
end

function MailDataManager:ReadAllHideMail()
  if not self.group then
    return
  end
  local redFix = {}
  local hideGroup = self.group[MailInternalGroup.MAIL_IN_hide]
  local allHideMail = hideGroup:GetAllMail()
  if #allHideMail <= 0 then
    return redFix
  end
  local uids = {}
  for i = 1, #allHideMail do
    local mailInfo = allHideMail[i]
    if mailInfo.status == 0 then
      mailInfo.status = 1
      table.insert(uids, mailInfo.uid)
      local originGroupId = MailTypeToInternalGroup[mailInfo.type]
      if not redFix[originGroupId] then
        redFix[originGroupId] = 0
      end
      redFix[originGroupId] = redFix[originGroupId] + 1
    end
  end
  if 0 < #uids then
    self.DB:UpdateMailData_BatchRead(uids)
    self:BatchDoServerMail(MsgDefines.MailReadStatusBatch, uids)
  end
  return redFix
end

function MailDataManager:__ReadGroupMail(groupId)
  local group = self.group[groupId]
  if group == nil then
    MailPrint("ReadGroupMail error :" .. groupId)
    return
  end
  local t1 = UITimeManager:GetInstance():GetServerTime()
  self.DB:GetAllUnreadMailUids(groupId, function(uids)
    local t2 = UITimeManager:GetInstance():GetServerTime()
    self:ReportDebugLog("__ReadGroupMail Cost Time ", t2 - t1)
    local found = #uids ~= 0
    for _, v in ipairs(group.mailList) do
      if v.status ~= 1 and not found then
        table.insert(uids, v.uid)
      end
      v.status = 1
    end
    group:SetUnreadCount(0)
    self.DB:UpdateMailData_ReadAll(groupId)
    if not found then
      EventManager:GetInstance():Broadcast(EventId.MailPush)
    end
    if 0 < #uids then
      self:BatchDoServerMail(MsgDefines.MailReadStatusBatch, uids)
    end
  end)
end

function MailDataManager:__ClaimRewardGroupMail(groupId)
  local group = self.group[groupId]
  if group == nil then
    MailPrint("__ClaimRewardGroupMail error :" .. groupId)
    return
  end
  local t1 = UITimeManager:GetInstance():GetServerTime()
  self.DB:GetAllCanRewardMailUids(groupId, function(uids)
    local t2 = UITimeManager:GetInstance():GetServerTime()
    self:ReportDebugLog("__ClaimRewardGroupMail Cost Time ", t2 - t1)
    if #uids == 0 and 0 < group:GetUnrewardCount() then
      local logUids = {}
      for _, v in ipairs(group:GetAllMail()) do
        if v.rewardStatus == 0 then
          table.insert(logUids, v.uid)
          table.insert(uids, v.uid)
        end
      end
      local format = "MailDataManager __ClaimRewardGroupMail group %s has %d unrewardCount uids = %s"
      Logger.LogInfo(string.format(format, tostring(groupId), group:GetUnrewardCount(), table.concat(logUids, ",")))
    end
    if 0 < #uids then
      self:BatchDoServerMail(MsgDefines.MailRewardBatch, uids, groupId)
    end
  end)
end

function MailDataManager:OnRewardMails(uids, groupIdStr)
  if string.IsNullOrEmpty(uids) then
    return
  end
  uids = string.split(uids, ",")
  local group = self.group[tonumber(groupIdStr)]
  if group then
    group:SetUnrewardCount(group:GetUnrewardCount() - #uids)
  end
  self.DB:UpdateMailData_Claim(uids)
  for _, v in ipairs(uids) do
    local mailInfo = self.mailList[v]
    if mailInfo then
      mailInfo.rewardStatus = 1
    end
  end
  EventManager:GetInstance():Broadcast(EventId.MailPush)
end

function MailDataManager:DeleteMail(mailId, isForce)
  local mailData = self:GetMailInfoById(mailId)
  if mailData == nil then
    MailPrint("mail not found: " .. mailId)
    return
  end
  if not isForce and mailData.rewardStatus == 0 then
    MailPrint("mail has reward, cannot delete: " .. mailId)
    return
  end
  self:BatchDoServerMail(MsgDefines.MailBatchDel, mailId, "manual")
end

function MailDataManager:OnDeleteOneMail(mailId)
  if string.IsNullOrEmpty(mailId) then
    return
  end
  local mailData = self:GetMailInfoById(mailId)
  if mailData == nil then
    MailPrint("mail not found: " .. mailId)
    return
  end
  local group = self.group[mailData.groupId]
  if group then
    group:RemoveMail(mailId)
  end
  self.mailList[mailId] = nil
  local mailDataSize = estimateTableSize(mailData)
  self.__estimateSize = self.__estimateSize - mailDataSize
  self.DB:RemoveMailData(mailId)
  if UseFileSystem then
    self.File:DeleteFile(mailId)
  end
  EventManager:GetInstance():Broadcast(EventId.Mail_DeleteMailDone, mailId)
  EventManager:GetInstance():Broadcast(EventId.MailPush)
end

function MailDataManager:DeleteMailList(mailIdList)
  if mailIdList == nil or #mailIdList == 0 then
    return
  end
  for i = #mailIdList, 1, -1 do
    local mailId = mailIdList[i]
    local mailData = self:GetMailInfoById(mailId)
    if mailData == nil then
      MailPrint("mail not found: " .. mailId)
      table.remove(mailIdList, i)
    elseif mailData.rewardStatus == 0 then
      MailPrint("mail has reward, cannot delete: " .. mailId)
      table.remove(mailIdList, i)
    end
  end
  self:BatchDoServerMail(MsgDefines.MailBatchDel, mailIdList, "manual")
end

function MailDataManager:OnDeleteMailList(mailIdList)
  if mailIdList == nil or #mailIdList == 0 then
    return
  end
  for i = #mailIdList, 1, -1 do
    local mailId = mailIdList[i]
    local mailData = self:GetMailInfoById(mailId)
    if mailData == nil then
      MailPrint("mail not found: " .. mailId)
    else
      local group = self.group[mailData.groupId]
      if group then
        group:RemoveMail(mailId)
      end
      self.mailList[mailId] = nil
      local mailDataSize = estimateTableSize(mailData)
      self.__estimateSize = self.__estimateSize - mailDataSize
      self.DB:RemoveMailData(mailId)
      if UseFileSystem then
        self.File:DeleteFile(mailId)
      end
    end
  end
  EventManager:GetInstance():Broadcast(EventId.MailPush)
end

function MailDataManager:DeleteGroupMail(groupId)
  local group = self.group[groupId]
  if group == nil then
    MailPrint("DeleteGroupMail error :" .. groupId)
    return
  end
  if groupId == MailInternalGroup.MAIL_IN_hide then
    self:DeleteHideMail()
    return
  end
  self.DB:GetAllCanDeleteMailUids(groupId, function(uids)
    if #uids == 0 then
      local mails = group:GetAllMail()
      for _, v in pairs(mails) do
        if v.status == 1 and v.rewardStatus == 1 then
          table.insert(uids, v.uid)
        end
      end
    end
    if #uids == 0 then
      UIUtil.ShowTipsId("mail_tips_10004")
      EventManager:GetInstance():Broadcast(EventId.MailPush)
      return
    end
    self:BatchDoServerMail(MsgDefines.MailBatchDel, uids, "manual," .. groupId)
  end)
end

function MailDataManager:OnDeleteGroupMails(uids, groupIdStr)
  if string.IsNullOrEmpty(uids) then
    return
  end
  uids = string.split(uids, ",")
  MailPrint("\229\136\160\233\153\164\228\184\128\231\187\132\233\130\174\228\187\182:" .. groupIdStr .. "  " .. #uids)
  local groupId = tonumber(groupIdStr)
  local group = self.group[groupId]
  self.DB:RemoveMailDatas(uids)
  if UseFileSystem then
    self.File:RemoveMailDatas(uids)
  end
  local temp = {}
  for _, v in ipairs(group.mailList) do
    if v.status == 1 and v.rewardStatus == 1 then
      table.insert(temp, v.uid)
    end
  end
  for _, v in ipairs(temp) do
    group:RemoveMail(v)
    local mailDataSize = estimateTableSize(self.mailList[v])
    self.__estimateSize = self.__estimateSize - mailDataSize
    self.mailList[v] = nil
  end
  EventManager:GetInstance():Broadcast(EventId.MailPush)
end

function MailDataManager:BatchDoServerMail(msgDefine, uids, param)
  if not uids then
    return
  end
  if type(uids) == "table" and 0 < #uids then
    MailPrint("Batch:" .. msgDefine .. (param or "") .. "#uids=" .. #uids)
    local mailIdStr
    local batchNum = (#uids - 1) // 100
    for i = 1, batchNum do
      mailIdStr = table.concat(uids, ",", 1 + 100 * (i - 1), 100 * i)
      SFSNetwork.SendMessage(msgDefine, mailIdStr, param)
    end
    mailIdStr = table.concat(uids, ",", 1 + 100 * batchNum, #uids)
    SFSNetwork.SendMessage(msgDefine, mailIdStr, param)
  elseif type(uids) == "string" then
    SFSNetwork.SendMessage(msgDefine, uids, param)
  end
end

function MailDataManager:DeleteHideMail()
end

function MailDataManager:DeleteExpireMail()
  local now = UITimeManager:GetInstance():GetServerTime()
  local lastTimeStr = CommonUtil.PlayerPrefsGetString("LAST_TIME_DELETE_EXPIRE_MAIL", "")
  if not string.IsNullOrEmpty(lastTimeStr) then
    local lastTime = tonumber(lastTimeStr)
    if now - lastTime < ONE_DAY then
      return
    end
  end
  CommonUtil.PlayerPrefsSetString("LAST_TIME_DELETE_EXPIRE_MAIL", tostring(now))
  self.DB:GetAllExpireMailUids(now - THIRTY_DAYS, function(uids)
    if table.IsNullOrEmpty(uids) then
      return
    end
    self:BatchDoServerMail(MsgDefines.MailBatchDel, uids, "auto")
  end)
end

function MailDataManager:OnDeleteExpireMails(uids)
  if string.IsNullOrEmpty(uids) then
    return
  end
  uids = string.split(uids, ",")
  self.DB:RemoveMailDatas(uids)
  if UseFileSystem then
    self.File:RemoveMailDatas(uids)
  end
  for i = 1, #uids do
    local mailId = uids[i]
    local mailInfo = self.mailList[mailId]
    local mailDataSize = estimateTableSize(mailInfo)
    self.__estimateSize = self.__estimateSize - mailDataSize
    self.mailList[mailId] = nil
    if mailInfo then
      local group = self.group[mailInfo.groupId]
      if group then
        group:RemoveMail(mailId)
      end
    end
  end
  EventManager:GetInstance():Broadcast(EventId.MailPush)
end

function MailDataManager:__DeleteVirtualGroupMail(mailType, groupId, targetGroupId)
  local virMail = self:__GetVirtualMail(mailType, targetGroupId)
  if virMail then
    if virMail.status == 0 then
      return
    end
  else
    local group = self.group[groupId]
    if group and 0 < group:GetUnreadCount() then
      return
    end
  end
  self:DeleteGroupMail(groupId)
end

function MailDataManager:SetAllAndOne(state)
  self.isAll = state
end

function MailDataManager:SetAllRewardCount(count)
  self.message = {}
  self.message.electricityAdd = 0
  self.message.waterAdd = 0
  self.message.pvePointAdd = 0
  self.message.goldAdd = 0
  self.message.moneyAdd = 0
  self.message.stoneAdd = 0
  self.message.detectEventAdd = 0
  self.message.formationStaminaAdd = 0
  self.rewardCount = count
end

function MailDataManager:RewardMail(mailId)
  local mailData = self:GetMailInfoById(mailId)
  if mailData == nil then
    MailPrint("mail not found: " .. mailId)
    return
  end
  local now = UITimeManager:GetInstance():GetServerTime()
  if mailData.createTime < now - THIRTY_DAYS then
    UIUtil.ShowTips(Localization:GetString("mail_tips002", mailData:GetMailTitle()))
  end
  self:BatchDoServerMail(MsgDefines.MailRewardBatch, mailId, mailData.groupId)
end

function MailDataManager:ReadAndRewardGroupMail(groupId)
  local group = self.group[groupId]
  if group == nil then
    MailPrint("RewardGroupMail error :" .. groupId)
    return
  end
  self:__ReadGroupMail(groupId)
  self:__ClaimRewardGroupMail(groupId)
end

function MailDataManager:RewardCheckMails(reward)
  self.rewardCount = self.rewardCount - 1
  if reward.goods ~= nil then
    local goods = reward.goods
    if not self.message.goods then
      self.message.goods = {}
    end
    for k = 1, #goods do
      table.insert(self.message.goods, goods[k])
    end
  end
  if reward.electricity ~= nil then
    self.message.electricity = reward.electricity
  end
  if reward.electricityAdd ~= nil then
    self.message.electricityAdd = self.message.electricityAdd + reward.electricityAdd
  end
  if reward.water ~= nil then
    self.message.water = reward.water
  end
  if reward.waterAdd ~= nil then
    self.message.waterAdd = self.message.waterAdd + reward.waterAdd
  end
  if reward.gold ~= nil then
    self.message.gold = reward.gold
  end
  if reward.goldAdd ~= nil then
    self.message.goldAdd = self.message.goldAdd + reward.goldAdd
  end
  if reward.money ~= nil then
    self.message.money = reward.money
  end
  if reward.moneyAdd ~= nil then
    self.message.moneyAdd = self.message.moneyAdd + reward.moneyAdd
  end
  if reward.stone ~= nil then
    self.message.stone = reward.stone
  end
  if reward.stoneAdd ~= nil then
    self.message.stoneAdd = self.message.stoneAdd + reward.stoneAdd
  end
  if reward.pvePoint ~= nil then
    self.message.pvePoint = reward.pvePoint
  end
  if reward.pvePointAdd ~= nil then
    self.message.pvePointAdd = self.message.pvePointAdd + reward.pvePointAdd
  end
  if reward.getMoney ~= nil then
    self.message.getMoney = reward.getMoney
  end
  if reward.detectEvent ~= nil then
    self.message.detectEvent = reward.detectEvent
  end
  if reward.detectEventAdd ~= nil then
    self.message.detectEventAdd = self.message.detectEventAdd + reward.detectEventAdd
  end
  if reward.formationStamina ~= nil then
    self.message.formationStamina = reward.formationStamina
  end
  if reward.formationStaminaAdd ~= nil then
    self.message.formationStaminaAdd = self.message.formationStaminaAdd + reward.formationStaminaAdd
  end
  if self.rewardCount == 0 then
    if self.message.gold ~= nil then
      LuaEntry.Player.sm_addGoldCount = self.message.gold - self.message.goldAdd
    end
    DataCenter.RewardManager:ShowGiftReward(self.message, Localization:GetString("128027"))
  end
end

function MailDataManager:__GetVirtualMail(mailType, groupType)
  local groupReport = self.group[groupType]
  if groupReport == nil then
    return nil
  end
  local virMail
  for k, v in ipairs(groupReport.mailList) do
    if v.type == mailType then
      virMail = v
      break
    end
  end
  return virMail
end

function MailDataManager:__MakeVirtualMail(mailType, groupId, targetGroupId)
  local groupReport = self.group[targetGroupId]
  if groupReport == nil then
    return
  end
  local oldVirMail = self:__GetVirtualMail(mailType, targetGroupId)
  if oldVirMail then
    oldVirMail.status = 1
    groupReport:RemoveMail(oldVirMail.uid)
    self.mailList[oldVirMail.uid] = nil
    oldVirMail = nil
  end
  local group = self.group[groupId]
  if group == nil or group:HasMail() == false then
    return
  end
  local gatherTime = group.mailList[1].createTime
  local mailId = group.mailList[1].uid
  if groupReport:HasMail() == true and groupReport:IsGetAll() == false then
    local reportTime = groupReport.mailList[#groupReport.mailList].createTime
    if gatherTime < reportTime then
      return
    end
  end
  local num = math.random(9999)
  local virMail = self:CreateMailData()
  virMail.type = mailType
  virMail.createTime = gatherTime
  virMail.uid = "00000000-0000-" .. tostring(num) .. "-0000-000000000000"
  virMail.status = 1
  virMail.rewardStatus = 1
  self.mailList[virMail.uid] = virMail
  groupReport:AddMail(virMail)
  if group:GetUnreadCount() > 0 then
    virMail.status = 0
  else
    virMail.status = 1
  end
end

function MailDataManager:SaveMailAsOne(mailType, targetGroupType)
  local targetGroup = self.group[targetGroupType]
  if not targetGroup then
    return
  end
  local oldVirMail
  for k, v in ipairs(targetGroup.mailList) do
    if v.type == mailType then
      oldVirMail = v
      break
    end
  end
  if oldVirMail then
    oldVirMail.status = 1
    targetGroup:RemoveMail(oldVirMail.uid)
    self.mailList[oldVirMail.uid] = nil
    oldVirMail = nil
  end
  local dataGroup = self.group[MailTypeToInternalGroup[mailType]]
  if not dataGroup or not dataGroup:HasMail() then
    return
  end
  local latestTime = dataGroup.mailList[1].createTime
  local virUid = "00000000-0000-" .. mailType .. "-0000-000000000000"
  local newVirMail = self:CreateMailData()
  newVirMail.type = mailType
  newVirMail.createTime = latestTime
  newVirMail.title = dataGroup.mailList[1].title
  newVirMail.uid = virUid
  newVirMail.status = 1
  newVirMail.rewardStatus = 1
  self.mailList[newVirMail.uid] = newVirMail
  targetGroup:AddMail(newVirMail)
  if dataGroup:GetUnreadCount() > 0 then
    newVirMail.status = 0
  else
    newVirMail.status = 1
  end
end

function MailDataManager:GetGroup(groupId)
  local group = self.group[groupId]
  return group
end

function MailDataManager:GetGroupMailList(groupId)
  if not self.group then
    return {}
  end
  local group = self.group[groupId]
  if not group then
    return {}
  end
  return group.mailList
end

function MailDataManager:GetGroupUIMailList(groupId)
  if not self.group then
    return {}
  end
  local group = self.group[groupId]
  local list = group:GetUIMailList()
  for _, v in ipairs(list) do
    v:DownloadBattleReport()
  end
  return list
end

function MailDataManager:ClearGroupShowIndex(groupId)
  if not self.group then
    return
  end
  local group = self.group[groupId]
  if not group then
    return
  end
  return group:ClearShowIndex()
end

function MailDataManager:GetMoreGroupUIMailList(groupId)
  if not self.group then
    return
  end
  local group = self.group[groupId]
  group:PullMore()
end

function MailDataManager:GetMailGroupFilters(groupId)
  return self.Filter:GetFilters(groupId)
end

function MailDataManager:GetMailListByKeywords(group, types, mailIds, excludeMailIds, keyword, index, callback)
  local result = self.Filter:GetLocalizationKeyByKeywords(group, types, keyword)
  table.insert(result, keyword)
  if 20 < #result then
    Logger.LogWarning("GetMailListByKeywords keyword " .. tostring(keyword) .. " result more than 20")
  end
  self.DB:GetGroupMailByKeyword(group, types, mailIds, excludeMailIds, result, index, callback)
end

function MailDataManager:CleanGroupMailList(groupId)
  if not self.group or not self.group[groupId] then
    return
  end
  local toDeleteUids, toHideUids = self.group[groupId]:CleanUIMailList()
  if not table.IsNullOrEmpty(toDeleteUids) then
    self:BatchDoServerMail(MsgDefines.MailBatchDel, toDeleteUids, "auto")
  end
  for i = 1, #toHideUids do
    self.mailList[toHideUids[i]] = nil
  end
  if 0 < #toHideUids or 0 < #toDeleteUids then
    Logger.LogInfo(string.format("\227\128\144\233\130\174\228\187\182\227\128\145\230\151\167\231\137\136\230\156\172\233\130\174\228\187\182\230\149\176\233\135\143\239\188\154%s,\232\167\163\230\158\144\229\164\177\232\180\165\231\154\132\233\130\174\228\187\182\230\149\176\233\135\143\239\188\154%s,groupId=%s", #toDeleteUids, #toHideUids, groupId))
  end
end

function MailDataManager:GetMailInfoById(uid)
  if self.mailList ~= nil and uid ~= nil and self.mailList[uid] ~= nil then
    return self.mailList[uid]
  end
  if self.shareMailList and uid and self.shareMailList[uid] then
    return self.shareMailList[uid]
  end
  if self.tempMailList and uid and self.tempMailList[uid] then
    return self.tempMailList[uid]
  end
  MailPrint("GetMailInfoById uid not found: " .. (uid or "nil"))
  return nil
end

function MailDataManager:AddShareMail(mailData)
  local v = self.shareMailList[mailData.uid]
  if v == nil then
    if self.mailList[mailData.uid] then
      mailData = self.mailList[mailData.uid]
    end
    self.shareMailList[mailData.uid] = mailData
    local mailDataSize = estimateTableSize(mailData)
    self.__estimateSizeShare = self.__estimateSizeShare + mailDataSize + 32
  end
  print("MailDataManager:AddShareMail", self.__estimateSizeShare)
end

function MailDataManager:GetMailUnReadCountAll()
  if not self.group then
    return 0
  end
  local count = 0
  for k, v in pairs(self.group) do
    if k == MailInternalGroup.MAIL_IN_report or k == MailInternalGroup.MAIL_IN_alliance or k == MailInternalGroup.MAIL_IN_season or k == MailInternalGroup.MAIL_IN_system then
      count = count + v:GetUnreadCount()
    end
  end
  return count
end

function MailDataManager:GetMailUnReadCountByGroup(groupId)
  if self.group[groupId] == nil then
    return 0
  end
  return self.group[groupId]:GetUnreadCount()
end

function MailDataManager:GetMailUnRewardCountByGroup(groupId)
  if self.group[groupId] == nil then
    return 0
  end
  return self.group[groupId]:GetUnrewardCount()
end

function MailDataManager:GetMainUIUnRewardCount()
  local rewardCount = 0
  rewardCount = rewardCount + self:GetMailUnRewardCountByGroup(MailInternalGroup.MAIL_IN_activity)
  rewardCount = rewardCount + self:GetMailUnRewardCountByGroup(MailInternalGroup.MAIL_IN_system)
  rewardCount = rewardCount + self:GetMailUnRewardCountByGroup(MailInternalGroup.MAIL_IN_alliance)
  return rewardCount
end

function MailDataManager:SetFavor(uid)
  local mailData = self:GetMailInfoById(uid)
  if mailData == nil then
    return
  end
  if mailData:CanClaimReward() == true then
    MailPrint("set favor but has reward.")
    UIUtil.ShowTipsId("mail_tips_10009")
    return
  end
  if mailData.type == MailType.NEW_COLLECT_MAIL or mailData.type == MailType.MONSTER_INVASION_ATTACK_PLAYER or mailData.type == MailType.SANDWORM_KNOCK_OFF or mailData.type == MailType.LW_METEORITE_COLLECT or mailData.type == MailType.ALLIANCE_MONSTER_CHALLENGE_ATTACK then
    MailPrint("set favor but collect mail.")
    return
  end
  if mailData.type == MailType.RESOURCE_HELP_FROM or mailData.type == MailType.RESOURCE_HELP_TO or mailData.type == MailType.RESOURCE_HELP_FAIL then
    return
  end
  if mailData.saveFlag == 1 then
    MailPrint("Already in favor, why?")
  else
    mailData.saveFlag = 1
    SFSNetwork.SendMessage(MsgDefines.MailAddFavor, uid, 1)
    self.DB:UpdateMailData_AddFavor(uid)
    self:__MailMoveGroup(uid, MailInternalGroup.MAIL_IN_favor)
    if mailData.type == MailType.NEW_ARENA_KOF_BATTLE or mailData.type == MailType.ARENA_BATTLE_REPORT then
      EventManager:GetInstance():Broadcast(EventId.Mail_MoveToTab, MailInternalGroup.MAIL_IN_favor)
    else
      EventManager:GetInstance():Broadcast(EventId.Mail_DeleteMailDone, uid)
    end
  end
end

function MailDataManager:CancelFavor(uid)
  local mailData = self:GetMailInfoById(uid)
  if mailData == nil then
    return
  end
  if mailData.saveFlag == 0 then
    MailPrint("Not in favor, why?")
  else
    mailData.saveFlag = 0
    SFSNetwork.SendMessage(MsgDefines.MailCancelFavor, uid, 1)
    self.DB:UpdateMailData_CancelFavor(uid)
    self:__MailMoveGroup(uid, self:__mailTypeToGroup(mailData.type))
    EventManager:GetInstance():Broadcast(EventId.Mail_DeleteMailDone, uid)
  end
end

function MailDataManager:__MailMoveGroup(uid, toGroup)
  local mailData = self:GetMailInfoById(uid)
  if mailData == nil then
    return
  end
  local groupSrc = self.group[mailData.groupId]
  if groupSrc == nil then
    return
  end
  local groupDest = self.group[toGroup]
  if groupDest == nil then
    return
  end
  groupSrc:RemoveMail(mailData.uid)
  local curTime = mailData.createTime
  local moveTime = 0
  if groupDest:IsGetAll() == false then
    if 0 < #groupDest.mailList then
      moveTime = groupDest.mailList[#groupDest.mailList].createTime
    end
    if curTime < moveTime then
      groupDest:SetTotal(groupDest:GetTotal() + 1)
      return
    end
  end
  groupDest:AddMail(mailData)
  groupDest:Sort()
end

function MailDataManager:ReqMore(groupId, callback)
  local group = self.group[groupId]
  if group == nil then
    MailPrint("ReqMore groupId not found!")
    return false
  end
  if group:IsGetAll() then
    if callback then
      callback(false)
    end
    return false
  end
  local mailTotal = group:GetAllMailCountIncludeHide()
  DataCenter.MailDataManager.DB:QueryMoreMails(groupId, mailTotal, 20, function(mailDatas)
    if mailDatas and 0 < #mailDatas then
      self:OnGetDBMails(mailDatas)
    end
    if callback then
      callback(true)
    end
  end)
  return true
end

function MailDataManager:ReqMailByType(typ, start, count, callback)
  DataCenter.MailDataManager.DB:QueryMailsByType(typ, start, count, function(mailDatas)
    if type(mailDatas) == "table" then
      for _, v in pairs(mailDatas) do
        self:AddMail(v)
      end
    end
    if callback then
      callback(mailDatas)
    end
  end)
end

function MailDataManager:ReqMailByTypes(types, start, count, callback)
  DataCenter.MailDataManager.DB:QueryMailsByTypes(types, start, count, function(mailDatas)
    if type(mailDatas) == "table" then
      for _, v in ipairs(mailDatas) do
        self:AddMail(v)
      end
    end
    if callback then
      callback(mailDatas)
    end
  end)
end

function MailDataManager:TryShareMail(shareParam)
  if shareParam then
    local shareType
    if shareParam.post == PostType.Text_ScoutReport then
      shareType = ShareCheckType.MailScoutResult
    elseif shareParam.post == PostType.Text_Formation_Fight_Share then
      shareType = ShareCheckType.MailBattleReport
    end
    if shareType then
      self.cacheShareParam = shareParam
      SFSNetwork.SendMessage(MsgDefines.ShareCdCheck, shareType)
    end
  end
end

function MailDataManager:OnRecvShareCheckResult(t)
  if t.canSend then
    if self.cacheShareParam then
      EventManager:GetInstance():Broadcast(ChatEventEnum.CHAT_SHARE_COMMAND, self.cacheShareParam)
    end
  else
    UIUtil.ShowTipsId(141080)
  end
  self.cacheShareParam = nil
end

function MailDataManager:KickAllInactiveMembers(mailId)
  SFSNetwork.SendMessage(MsgDefines.MailKickInActiveMembers, mailId)
end

function MailDataManager:SaveUIHistory(uid)
  self.uiUid = uid
end

function MailDataManager:LoadUIHistory()
  return self.uiUid
end

function MailDataManager:GetUIStateByUid(uid)
  if not uid then
    return nil
  end
  if self.shareMailList[uid] then
    return 5, 0
  end
  local mailData = self.mailList[uid]
  if mailData then
    return 3, self:__mailTypeToGroup(mailData.type, mailData.saveFlag)
  end
  return nil
end

function MailDataManager:IsShare(uid)
  return self.shareMailList and self.shareMailList[uid]
end

function MailDataManager:ReqMailById(mailId, callback)
  if not mailId then
    return false
  end
  if self.queryingMails[mailId] then
    return false
  end
  DataCenter.MailDataManager.DB:QueryMailData(mailId, function(mailData)
    if self.queryingMails then
      self.queryingMails[mailId] = nil
    end
    if mailData then
      self:OnGetDBMails({mailData})
    end
    if callback then
      callback(mailData)
    end
  end)
  self.queryingMails[mailId] = true
  return true
end

function MailDataManager:SetMailLikeData(msg)
  if self.mailLikeList == nil then
    return
  end
  local mailId = msg.uid or msg.mailUuid
  if mailId == nil then
    return
  end
  local likeNum = msg.praise
  local dislikeNum = msg.stepon
  local selectType = msg.type or msg.selectType or msg.like
  local curTime = UITimeManager:GetInstance():GetServerTime()
  local expireTime = curTime + 5000
  local mailLikeData = {
    mailId = mailId,
    likeNum = likeNum,
    dislikeNum = dislikeNum,
    expireTime = expireTime,
    selectType = selectType
  }
  self.mailLikeList[mailId] = mailLikeData
end

function MailDataManager:GetMailLikeData(mailId)
  local data
  if self.mailLikeList == nil then
    return data
  end
  data = self.mailLikeList[mailId]
  return data
end

function MailDataManager:IsHaveLikeData(mailData)
  local isHave = false
  if mailData and mailData.type ~= nil then
    if mailData.type == MailType.MAIL_GM and mailData.fromName ~= "system" then
      isHave = true
    elseif UIUtil.UseNewPlayerInfo() then
      if mailData.type == MailType.LW_ALLIANCE_GROUP_MAIL then
        isHave = true
      elseif mailData.type == MailType.MAIL_PRESIDENT_SEND or mailData.type == MailType.MAIL_PRESIDENT_SEND_EIGHT then
        isHave = true
      end
    end
  end
  return isHave
end

function MailDataManager:GetMailInfoByIdInDB(uid, cb)
  if not uid then
    cb(nil)
    return
  end
  if self.mailList ~= nil and uid ~= nil and self.mailList[uid] ~= nil then
    cb(self.mailList[uid])
    return
  end
  if self.shareMailList and uid and self.shareMailList[uid] then
    cb(self.shareMailList[uid])
    return
  end
  self.__blockerHandleID = UIManager:GetInstance():EnableInteractionBlocker(2, 5)
  self:ReqMailById(uid, function(mailInfo)
    if self.__blockerHandleID then
      UIManager:GetInstance():DisableInteractionBlocker(self.__blockerHandleID)
      self.__blockerHandleID = nil
    end
    cb(mailInfo)
  end)
end

function MailDataManager:GetMailInfosByTypeInDB(type, count, cb)
  if not type then
    cb(nil)
    return
  end
  local mailByType = {}
  if self.mailList then
    for _, v in pairs(self.mailList) do
      if v.type == type then
        table.insert(mailByType, v)
      end
    end
  end
  if count <= #mailByType then
    table.sort(mailByType, function(a, b)
      return a.createTime > b.createTime
    end)
    local ret = {}
    for i = 1, count do
      table.insert(ret, mailByType[i])
    end
    cb(ret)
    return
  end
  self.__blockerHandleID = UIManager:GetInstance():EnableInteractionBlocker(2, 3)
  self:ReqMailByType(type, 0, count, function(mailInfos)
    if self.__blockerHandleID then
      UIManager:GetInstance():DisableInteractionBlocker(self.__blockerHandleID)
      self.__blockerHandleID = nil
    end
    cb(mailInfos)
  end)
end

function MailDataManager:HandleMailGetMessage(message)
  if not message then
    return
  end
  if message.errorCode ~= nil then
    UIUtil.ShowTipsId(message.errorCode)
    return
  end
  if table.count(message.msg) == 0 then
    return
  end
  local serverData = message.msg[1]
  if not serverData then
    return
  end
  local mailInfo = require("DataCenter.MailData.MailInfo").New()
  mailInfo:ParseBaseData(serverData)
  if mailInfo.uid then
    DataCenter.MailDataManager:AddShareMail(mailInfo)
    mailInfo:DownloadBattleReport(true)
    mailInfo:OnMailIntegrityExecute(function()
      UIManager:GetInstance():OpenWindow(UIWindowNames.UILWMailMain, {anim = false}, UIMailOpenType.Detail, mailInfo.uid)
    end)
  else
    Logger.LogError("\229\144\142\231\171\175\229\143\145\231\187\153\230\136\145\231\154\132uid\228\184\186\231\169\186\239\188\140\229\141\143\232\174\174\239\188\154mail.read")
  end
end

function MailDataManager:OpenShareMail(mailId, toUser)
  if mailId == nil then
    return
  end
  if string.IsNullOrEmpty(toUser) then
    Logger.LogError("OpenShareMail toUser Param Error")
  end
  local v = self:GetMailInfoById(mailId)
  if v == nil then
    SFSNetwork.SendMessage(MsgDefines.MailGet, mailId, "", toUser)
  else
    self:AddShareMail(v)
    v:DownloadBattleReport(true)
    v:OnMailIntegrityExecute(function()
      UIManager:GetInstance():OpenWindow(UIWindowNames.UILWMailMain, {anim = false}, UIMailOpenType.Detail, v.uid)
    end)
  end
end

function MailDataManager:HandleMailGetMutiMessage(message)
  local errCode = message.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
  end
  local list = message.msg or {}
  DataCenter.MailDataManager:OnGetMailListMessage(message, nil, true)
  for _, v in ipairs(list) do
    if v.uid == DataCenter.ActMeteoriteBattleManager.flyMailId then
      DataCenter.ActMeteoriteBattleManager:CheckIsNeedPop()
    end
  end
  if 0 < #list then
    EventManager:GetInstance():Broadcast(EventId.MailPush)
  end
end

function MailDataManager:HandlePushMailMessage(t)
  if self.pullOver == false then
    table.insert(self.cachePush, t)
    Logger.LogInfo("MailDataManager::CachePushMail: " .. tostring(t.uid))
    return
  end
  DataCenter.MailDataManager:OnGetMailListMessage({
    msg = {t}
  }, nil, t.rewardStatus == 0 and not self.initUnrewardCountSuccess)
  self:CheckPushMailBattleReport(t.uid)
  EventManager:GetInstance():Broadcast(EventId.MailPush, t.uid)
end

function MailDataManager:HandleMailBatchDelMessage(t)
  MailPrint("MailBatchDelMessage return : " .. tostring(t.success))
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
    Logger.LogError("\233\130\174\228\187\182\229\136\160\233\153\164\229\164\177\232\180\165\239\188\154errorCode=" .. errCode)
    return
  end
  if string.IsNullOrEmpty(t.type) then
    return
  end
  local params = string.split(t.type, ",")
  if params[1] == "auto" then
    DataCenter.MailDataManager:OnDeleteExpireMails(t.uids)
  elseif params[2] then
    DataCenter.MailDataManager:OnDeleteGroupMails(t.uids, params[2])
    UIUtil.ShowTipsId(310112)
  else
    local mailList = string.split(t.uids, ",")
    if #mailList == 1 then
      DataCenter.MailDataManager:OnDeleteOneMail(t.uids)
    else
      DataCenter.MailDataManager:OnDeleteMailList(mailList)
    end
    UIUtil.ShowTipsId(310112)
  end
end

function MailDataManager:HandleMailRewardBatchMessage(message)
  MailPrint("MailRewardBatchMessage:HandleMessage")
  if message.errorCode ~= nil then
    UIUtil.ShowTipsId(message.errorCode)
    Logger.LogError("\233\130\174\228\187\182\233\162\134\229\165\150\229\164\177\232\180\165\239\188\154errorCode=" .. message.errorCode)
    return
  end
  DataCenter.MailDataManager:OnRewardMails(message.uids, message.type)
  if message.goods == nil and message.stone == nil and message.exp == nil and message.gold == nil and message.dragonHonorScore == nil and message.water == nil and message.money == nil and message.electricity == nil and message.wood == nil and message.arms == nil and message.resourceItem == nil and message.equipment == nil and message.battleCard == nil then
    return
  end
  local needResourceUpdated = false
  if DataCenter.MailDataManager.isAll then
    DataCenter.LWSoundManager:PlaySound(SoundAssetId.Music_Effect_Ue_GetReward, false)
    DataCenter.RewardManager:ShowGiftReward(message)
  else
    EventManager:GetInstance():Broadcast(EventId.ReadOneMailRespond)
  end
  if message.goods then
    local rewardList = {}
    for k, v in pairs(message.goods) do
      local param = {}
      param.type = RewardType.GOODS
      param.value = v
      table.insert(rewardList, param)
    end
    DataCenter.RewardManager:AddRewards(rewardList)
  end
  if message.equipment then
    local rewardList = {}
    for k, v in pairs(message.equipment) do
      local param = {}
      param.type = RewardType.CommonEquip
      param.value = {}
      param.value.changes = v.changes
      table.insert(rewardList, param)
    end
    DataCenter.RewardManager:AddRewards(rewardList)
  end
  if message.stone then
    LuaEntry.Resource.metal = message.stone
    needResourceUpdated = true
  end
  if message.exp then
    LuaEntry.Player.exp = message.exp
  end
  if message.gold then
    LuaEntry.Player.gold = message.gold
    EventManager:GetInstance():Broadcast(EventId.UpdateGold)
  end
  if message.water then
    LuaEntry.Resource.water = message.water
    needResourceUpdated = true
  end
  if message.money then
    LuaEntry.Resource.money = message.money
    needResourceUpdated = true
  end
  if message.electricity then
    LuaEntry.Resource.electricity = message.electricity
    needResourceUpdated = true
  end
  if message.wood then
    LuaEntry.Resource.wood = message.wood
    needResourceUpdated = true
  end
  if message.dragonHonorScore then
    LuaEntry.Resource.honorScore = message.dragonHonorScore
    needResourceUpdated = true
  end
  if message.obsidian then
    LuaEntry.Resource.obsidian = message.obsidian
    needResourceUpdated = true
  end
  if message.flint then
    LuaEntry.Resource.flint = message.flint
    needResourceUpdated = true
  end
  if message.petroleum then
    LuaEntry.Resource.petroleum = message.petroleum
    needResourceUpdated = true
  end
  if needResourceUpdated == true then
    EventManager:GetInstance():Broadcast(EventId.ResourceUpdated)
  end
  if message.arms then
    local dic = message.arms
    if dic ~= nil then
      local armyInfo = DataCenter.ArmyManager:FindArmy(dic.itemId)
      if armyInfo ~= nil then
        armyInfo.free = armyInfo.free + dic.count
      end
    end
  end
end

function MailDataManager:PullAll()
  if self.pullOver == false then
    return
  end
  self.pullOver = false
  self.initUnrewardCountSuccess = false
  SFSNetwork.SendMessage(MsgDefines.MailGetMuti, "0", 0, REQUEST_COUNT, true)
end

function MailDataManager:CreateBattleReportTimer()
  self:ClearBattleReportTimer()
  self.battleReportTimer = TimerManager:GetInstance():GetTimer(3, self.OnBattleReportCheck, self, false, false, false)
  self.battleReportTimer:Start()
end

local function safeConcat(t, sep)
  if type(t) ~= "table" or type(sep) ~= "string" then
    return ""
  end
  local result = {}
  for _, v in ipairs(t) do
    table.insert(result, tostring(v))
  end
  return table.concat(result, sep)
end

function MailDataManager:OnBattleReportCheck()
end

function MailDataManager:ClearBattleReportTimer()
  if self.battleReportTimer ~= nil then
    self.battleReportTimer:Stop()
    self.battleReportTimer = nil
  end
end

function MailDataManager:OnBattleReportDownload(mailId, uuid, battleContent, code)
  local mailInfo = DataCenter.MailDataManager:GetMailInfoById(mailId)
  if mailInfo == nil then
    Logger.LogWarning("OnBattleReportDownload Can't Find MailId " .. tostring(mailId))
    return
  end
  mailInfo:OnDownloadBattleReportFinish(battleContent and CS.System.Convert.ToBase64String(battleContent), code)
  if battleContent == nil then
    return
  end
  self.File:UpdateFile(mailId, mailInfo.contents)
  self:OnMailInsertDBSuccess({mailInfo})
end

local function GetContent(reportData)
  if reportData == nil then
    return
  end
  local contents
  if reportData.contentsArr ~= nil then
    local contentsArr = reportData.contentsArr
    contents = string.join(contentsArr)
  elseif reportData.contentsLocal ~= nil then
    contents = reportData.contentsLocal
  else
    contents = reportData.contents
  end
  return contents
end

function MailDataManager:HandlePushMailBattleReportMessage(data)
  local contents = GetContent(data)
  if contents == nil then
    return
  end
  self.reportList = self.reportList or {}
  self.waitingReportList = self.waitingReportList or {}
  if self.waitingReportList[tostring(data.uuid)] then
    local mailInfo = self.waitingReportList[tostring(data.uuid)]
    self:OnBattleReportDownload(mailInfo.uid, data.uuid, contents, 0)
    self.waitingReportList[tostring(data.uuid)] = nil
    return
  end
  self.reportList[tostring(data.uuid)] = data
end

function MailDataManager:CheckPushMailBattleReport(mailId)
  local mailInfo = DataCenter.MailDataManager:GetMailInfoById(mailId)
  if mailInfo == nil then
    return
  end
  local uuid = mailInfo:GetBattleReportUuid()
  if uuid == nil then
    return
  end
  self.reportList = self.reportList or {}
  self.waitingReportList = self.waitingReportList or {}
  if self.reportList[tostring(uuid)] ~= nil then
    local contents = GetContent(self.reportList[tostring(uuid)])
    self:OnBattleReportDownload(mailInfo.uid, uuid, contents, 0)
    self.reportList[tostring(uuid)] = nil
    return
  end
  self.waitingReportList[tostring(uuid)] = mailInfo
end

function MailDataManager:OnPresidentMailGMDelete(data)
  table.insert(self.gmDeleteMailList, data.groupId)
  self:DeleteGMMarkPresidentMail()
end

function MailDataManager:DeleteGMMarkPresidentMail()
  local checkGroupIds = {
    MailInternalGroup.MAIL_IN_system,
    MailInternalGroup.MAIL_IN_activity,
    MailInternalGroup.MAIL_IN_alliance
  }
  local list = {}
  for _, id in ipairs(checkGroupIds) do
    local group = self.group[id]
    for _, delId in ipairs(self.gmDeleteMailList) do
      for _, v in ipairs(group.mailList) do
        local custom = v:GetMailCustom()
        if custom and custom.c and custom.c.groupId == delId then
          table.insert(list, v.uid)
        end
      end
    end
  end
  for _, v in ipairs(list) do
    DataCenter.MailDataManager:OnDeleteOneMail(v)
  end
end

function MailDataManager:ReportDebugLog(...)
end

function MailDataManager:IsTestServer()
  return true
end

function MailDataManager:OnMailInsertDBSuccess(saveList)
  self.mailSuccessLogs = self.mailSuccessLogs or {}
  for i, v in ipairs(saveList) do
    local mainTitle = ""
    local reportId = ""
    local integrity = ""
    if BattleReportMailType[v.type] then
      mainTitle = v:GetMailTitle()
      local info = v.battleReportInfo
      reportId = info and tostring(info.uuid) or ""
      integrity = info and tostring(info.reportIntegrity) or "true"
    else
      mainTitle = MailShowHelper.GetMainTitle(v)
      reportId = ""
      integrity = ""
    end
    table.insert(self.mailSuccessLogs, string.format("u[%s]r[%s]t[%s]", v.uid, reportId, v.type))
  end
end

function MailDataManager:ClearShareList()
  self.shareMailList = {}
end

function MailDataManager:GetTempMailById(uid)
  return self.tempMailList[uid]
end

function MailDataManager:RemoveTempMailById(uid)
  self.tempMailList[uid] = nil
end

function MailDataManager:ClearTempMailList()
  self.tempMailList = {}
end

function MailDataManager:AddTempMailData(mailData)
  if self.mailList[mailData.uid] then
    mailData = self.mailList[mailData.uid]
  end
  self.tempMailList[mailData.uid] = mailData
end

function MailDataManager:ClearFromTagAndFromData()
  self.fromTag = nil
  self.fromData = nil
end

function MailDataManager:SetMailTipBtnType(btnType)
  self.mailTipBtnType = btnType
end

function MailDataManager:GetMailTipBtnType()
  return self.mailTipBtnType
end

return MailDataManager
