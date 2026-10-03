local MailInfo = BaseClass("MailInfo")
local MailParseHelper = require("DataCenter.MailData.MailParseHelper")
local rapidjson = require("rapidjson")
local THIRTY_DAYS = 2592000000
local ONE_DAY = 86400000

local function __init(self)
  self.uid = ""
  self.toUser = ""
  self.fromUser = ""
  self.fromName = ""
  self.title = ""
  self.subTitle = ""
  self.contents = ""
  self.status = 0
  self.type = 0
  self.createTime = 0
  self.rewardStatus = 1
  self.rewardTime = 0
  self.itemIdFlag = 0
  self.groupId = -1
  self.translateMsg = nil
  self.translatedLang = nil
  self.expireTime = 0
  self.mailId = -1
  self.__ext = nil
  self.channelId = ""
  self.tabType = 0
  self.custom = ""
  self.customTb = nil
  self.originalLang = ""
  self.isTranslating = 0
  self.initBattleReport = false
  self.battleReportInfo = {}
  self.mailIntegrityCallbacks = {}
  self.callbacks = {}
  self.downloadTimer = nil
  self.isVirtualBattleReportMail = false
end

local function __delete(self)
  self.uid = nil
  self.contents = nil
  self.title = nil
  self.subTitle = nil
  self.fromName = nil
  self.fromUser = nil
  self.status = nil
  self.type = nil
  self.createTime = nil
  self.rewardStatus = nil
  self.rewardTime = nil
  self.itemIdFlag = nil
  self.groupId = nil
  self.translateMsg = nil
  self.translatedLang = nil
  self.expireTime = nil
  self.mailId = -1
  self.__ext = nil
  self.channelId = nil
  self.tabType = nil
  self.custom = ""
  self.customTb = nil
  self.initBattleReport = false
  self.battleReportInfo = {}
  self.mailIntegrityCallbacks = {}
  self.callbacks = {}
  if self.downloadTimer ~= nil then
    self.downloadTimer:Stop()
  end
  self.downloadTimer = nil
  self.isVirtualBattleReportMail = false
end

local function ParseBaseData(self, info)
  if table.IsNullOrEmpty(info) then
    return
  end
  self.uid = info.uid
  self.toUser = info.toUser
  self.fromName = info.fromName
  self.fromUser = info.fromUser
  self.type = info.type
  self.status = info.status
  self.createTime = info.createTime
  self.itemIdFlag = info.itemIdFlag
  self.translateMsg = info.translateMsg
  self.translatedLang = info.translatedLang
  self.expireTime = info.expireTime
  if info.saveFlag and info.saveFlag ~= 0 then
    self.saveFlag = info.saveFlag
  end
  self.title = info.title
  self.originTitle = info.title
  self.custom = info.custom or ""
  local contents
  if info.contentsArr ~= nil then
    local contentsArr = info.contentsArr
    contents = string.join(contentsArr)
  elseif info.contentsLocal ~= nil then
    contents = info.contentsLocal
  else
    contents = info.contents
  end
  self.contents = contents
  self.mailId = self:GetMailId() or -1
  if not string.IsNullOrEmpty(info.translationId) then
    self.translationId = info.translationId
  end
  if not string.IsNullOrEmpty(info.rewardId) then
    self.rewardId = info.rewardId
  end
  self.rewardStatus = info.rewardStatus
  self.rewardTime = info.rewardTime
  self:InitBattleReportParam()
end

local function ParseMailData(self, message)
  self.ParseBaseData(self, message)
  self.SetMailChannel(self)
end

local function SetMailChannel(self)
end

local function SetMailRead(self)
  if self.status ~= 1 then
    self.status = 1
  end
end

local function GetMailHeader(self)
  if self.tabHeader == nil then
    self.tabHeader = rapidjson.decode(self.title) or {}
  end
  return self.tabHeader
end

local function GetMailBody(self)
  if self.tabBody == nil then
    self.tabBody = rapidjson.decode(self.contents) or {}
  end
  return self.tabBody
end

local function GetMailCustom(self)
  if not self.customTb then
    if string.IsNullOrEmpty(self.custom) then
      self.customTb = {}
    else
      self.customTb = rapidjson.decode(self.custom) or {}
    end
  end
  return self.customTb
end

local function GetMailTitle(self)
  self:GetMailHeader()
  if type(self.tabHeader) == "number" then
    return "\232\128\129\231\137\136\230\156\172"
  end
  if self.tabHeader.h == nil then
    return "\232\128\129\231\137\136\230\156\172"
  end
  if self.tabHeader.h ~= nil then
    return MailParseHelper:DecodeMessage(self.tabHeader.h.title)
  else
    return ""
  end
end

local function GetMailSubTitle(self)
  self:GetMailHeader()
  if type(self.tabHeader) == "number" then
    return "\232\128\129\231\137\136\230\156\172"
  end
  if self.tabHeader.h == nil then
    return "\232\128\129\231\137\136\230\156\172"
  end
  if self.tabHeader.h ~= nil then
    return MailParseHelper:DecodeMessage(self.tabHeader.h.subTitle)
  else
    return ""
  end
end

local function GetMailMessage(self)
  self:GetMailBody()
  if type(self.tabBody) == "number" then
    return "\232\128\129\231\137\136\230\156\172"
  end
  if self.tabBody.b == nil then
    return "\232\128\129\231\137\136\230\156\172"
  end
  return MailParseHelper:DecodeMessage(self.tabBody.b.content, self.tabBody.b.extra)
end

local function GetMailMessageExtra(self)
  self:GetMailBody()
  if type(self.tabBody) == "number" then
    return "\232\128\129\231\137\136\230\156\172"
  end
  if self.tabBody.b == nil then
    return "\232\128\129\231\137\136\230\156\172"
  end
  return self.tabBody.b.extra
end

local function GetContentMailId(self)
  self:GetMailBody()
  if type(self.tabBody) == "number" then
    return "\232\128\129\231\137\136\230\156\172"
  end
  if self.tabBody.b == nil then
    return "\232\128\129\231\137\136\230\156\172"
  end
  local mailId = -1
  if self.tabBody.b and self.tabBody.b.mailId then
    mailId = self.tabBody.b.mailId
  end
  return mailId
end

local function GetMailParam(self, index)
  self:GetMailBody()
  if type(self.tabBody) == "number" then
    return "\232\128\129\231\137\136\230\156\172"
  end
  if self.tabBody.b == nil then
    return "\232\128\129\231\137\136\230\156\172"
  end
  return MailParseHelper:GetParam(self.tabBody.b.content, index)
end

local function GetMailParamTable(self, index)
  self:GetMailBody()
  if type(self.tabBody) == "number" then
    return "\232\128\129\231\137\136\230\156\172"
  end
  if self.tabBody.b == nil then
    return "\232\128\129\231\137\136\230\156\172"
  end
  return MailParseHelper:GetMailParamTable(self.tabBody.b.content, index)
end

local function GetMailMessageTranslated(self)
  return self.translateMsg
end

local function GetMessage(self)
  return self:GetMailMessage()
end

local function GetMailSFSObj(self)
  self:GetMailBody()
  if type(self.tabBody) == "number" then
    return "\232\128\129\231\137\136\230\156\172"
  end
  if self.tabBody.obj == nil then
    return "\232\128\129\231\137\136\230\156\172"
  end
  return self.tabBody.obj
end

local function GetMailPay(self)
  self:GetMailBody()
  if self.tabBody.b == nil then
    return nil
  end
  return self.tabBody.b.pay
end

local function GetMailId(self)
  self:GetMailBody()
  if self.tabBody.b == nil then
    return nil
  end
  return self.tabBody.b.mailId
end

local function GetMailReward(self)
  self:GetMailBody()
  if self.tabBody.b == nil then
    return nil
  end
  local reward = self.tabBody.b.reward
  if reward ~= nil and reward.rewardInfo ~= nil then
    local rewardInfo = reward.rewardInfo
    local showReward = {}
    for k, v in pairs(rewardInfo) do
      v.num = tonumber(v.num)
      local needInsert = true
      if 0 < #showReward then
        for i = 1, #showReward do
          if needInsert == true then
            local data = showReward[i]
            if data.type == v.type then
              local itemId = data.id
              if itemId ~= nil and itemId ~= 0 and itemId ~= "" then
                if itemId == v.id then
                  data.num = data.num + v.num
                  needInsert = false
                end
              else
                data.num = data.num + v.num
                needInsert = false
              end
            end
          end
        end
      end
      if needInsert then
        table.insert(showReward, v)
      end
    end
    reward.rewardInfo = showReward
  end
  return reward
end

local function GetMailUserInfo(self)
  self:GetMailBody()
  if self.tabBody.b == nil then
    return nil
  end
  return self.tabBody.b.userInfo
end

function MailInfo:GetBodyData(dataKey)
  self:GetMailBody()
  if self.tabBody.b == nil then
    return nil
  end
  return self.tabBody.b[dataKey]
end

local function GetMailExt(self)
  if self.__ext == nil then
    self.__ext = MailParseHelper.ParseContent(self)
  end
  return self.__ext
end

function MailInfo:HasMummyJoin()
  local data = self:GetMailExt()
  if data and data.fixedSoldierType == SoldierType.Mummy then
    return true
  end
  return false
end

local function CanClaimReward(self)
  return self.rewardStatus == 0
end

function MailInfo:SetTranslationMsg(translateMsg)
  self.translateMsg = translateMsg
end

function MailInfo:GetTranslationMsg()
  return self.translateMsg
end

function MailInfo:SetOriginalLang(originalLang)
  self.originalLang = originalLang
end

function MailInfo:SetTranslatedLang(translatedLang)
  self.translatedLang = translatedLang
end

function MailInfo:setSendState(sendingState)
  self.sendState = sendingState
end

function MailInfo:SetIsTranslating(isTranslating)
  if isTranslating == true then
    self.isTranslating = 1
  elseif isTranslating == false then
    self.isTranslating = 0
  else
    self.isTranslating = isTranslating
  end
end

function MailInfo:IsTranslating()
  if self.isTranslating == 1 then
    return true
  end
  return false
end

function MailInfo:IsTranslatError()
  if self.isTranslating == -1 then
    return true
  end
  return false
end

local function GetRewardData(rewardInfo)
  if rewardInfo then
    return {
      rewardType = rewardInfo.type,
      itemId = rewardInfo.id,
      count = rewardInfo.num
    }
  end
  return nil
end

local function UpdateMailContents(self, contents)
  self.contents = contents
  self.tabBody = nil
  self.__ext = nil
end

local function GetBattleReportInfo(self)
  if not self.initBattleReport then
    self:InitBattleReportParam()
  end
  return self.battleReportInfo
end

local function InitBattleReportParam(self)
  self.initBattleReport = true
  if self:IsBattleReportMailType() then
    local sfs = self:GetMailSFSObj()
    local battleReport = sfs.battleContent or ""
    local pb_BattleReport = PBController.ParsePb1(battleReport, "protobuf.LwBattleReport")
    local downLoadTimes = LuaEntry.DataConfig:CheckSwitch("report_download_switchLine") and 1 or 3
    self.battleReportInfo = {
      uuid = pb_BattleReport.uuid,
      version = pb_BattleReport.version,
      reportIntegrity = table.count(pb_BattleReport.player) ~= 0 or not (pb_BattleReport.version >= NEED_REQUEST_REPORT_VERSION),
      isAddressMode = pb_BattleReport.address and BattleReportUtil.IsAddressMode(pb_BattleReport.address) or false,
      address = pb_BattleReport.address,
      isDownloading = false,
      downloadTimes = downLoadTimes
    }
    if MailTypeToInternalGroup[self.type] == MailInternalGroup.MAIL_IN_hide and self.type ~= MailType.NEW_ARENA_KOF_BATTLE and self.type ~= MailType.ARENA_BATTLE_REPORT then
      self:DownloadBattleReport()
    end
  end
end

local function LoadBattleReportFromFile(self)
  local info = self:GetBattleReportInfo()
  info.isDownloading = true
  if DataCenter.MailDataManager.File:IsFileExist(self.uid) then
    DataCenter.MailDataManager.File:GetFileContent(self.uid, function(contents)
      self:UpdateMailContents(contents)
      local sfs = self:GetMailSFSObj()
      self:OnDownloadBattleReportFinish(sfs and sfs.battleContent, 0)
    end)
    return true
  end
  return false
end

local function DownloadBattleReport(self, force)
  if not self:IsBattleReportMailType() then
    return
  end
  local info = self:GetBattleReportInfo()
  if not force and info.reportIntegrity then
    return
  end
  if not force and info.isDownloading then
    return
  end
  if self:LoadBattleReportFromFile() then
    return
  end
  if info.uuid == nil then
    return
  end
  if not force and info.downloadTimes <= 0 then
    return
  end
  local isAddressMode = false
  if info.isAddressMode then
    isAddressMode = true
  end
  local address = ""
  if info.address then
    address = info.address
  end
  info.isDownloading = true
  info.downloadTimes = info.downloadTimes - 1
  BattleReportUtil.DownloadBattleReport(info.uuid, {
    type = "mail",
    id = self.uid
  }, isAddressMode, address, force)
end

local function DelayDownloadBattleReport(self, delayTime)
  if self.downloadTimer then
    self.downloadTimer:Stop()
    self.downloadTimer = nil
  end
  self.downloadTimer = TimerManager:GetInstance():DelayInvoke(function()
    self:DownloadBattleReport()
  end, delayTime)
end

local function OnDownloadBattleReportFinish(self, battleContent, code)
  if code == 404 or IsNull(battleContent) then
    DelayDownloadBattleReport(self, 3)
    return
  end
  if CommonUtil.IsGrayServer(3, 68) or CommonUtil.IsDebug() then
    local pb_BattleReport = PBController.ParsePb1(battleContent, "protobuf.LwBattleReport")
    if pb_BattleReport == nil then
      local str = CS.System.Convert.FromBase64String(battleContent)
      local strDecompress = CS.GameEntry.Network:ExecuteZstdDecompressor(str, "")
      pb_BattleReport = PBController.ParsePbFromBytes(strDecompress, "protobuf.LwBattleReport")
      if not pb_BattleReport then
        Logger.LogWarning("second decompress battle report fail")
      else
        battleContent = CS.System.Convert.ToBase64String(strDecompress)
        local uuid = pb_BattleReport.uuid or ""
        Logger.LogInfo("second decompress battle report success,uuid==" .. uuid)
      end
    end
  end
  local info = self:GetBattleReportInfo()
  info.isDownloading = false
  if IsNull(battleContent) then
    return
  end
  local obj = self:GetMailSFSObj()
  obj.battleContent = battleContent
  self:UpdateMailContents(rapidjson.encode(self:GetMailBody()))
  info.reportIntegrity = true
  for _, v in ipairs(self.callbacks) do
    v(self)
  end
  self.mailIntegrityCallbacks = {}
  self.callbacks = {}
end

local function IsBattleReportIntegrity(self)
  if not self:IsBattleReportMailType() then
    return true
  end
  if self.isVirtualBattleReportMail then
    return true
  end
  local info = self:GetBattleReportInfo()
  return info.reportIntegrity == true
end

local function IsBattleReportMailType(self)
  return BattleReportMailType[self.type]
end

local function GetBattleReportUuid(self)
  local info = self:GetBattleReportInfo()
  return info.uuid
end

local function OnMailIntegrityExecute(self, callback)
  if self:IsBattleReportIntegrity() then
    callback(self)
  elseif self.mailIntegrityCallbacks[tostring(callback)] == nil then
    self.mailIntegrityCallbacks[tostring(callback)] = callback
    table.insert(self.callbacks, callback)
  end
end

local function IsMailOutOfDate(self, server)
  local time = server and 7 * ONE_DAY or THIRTY_DAYS
  local now = UITimeManager:GetInstance():GetServerTime()
  return now - time > (self.createTime or 0)
end

local function InitVirtualBattleReportMailData(self, data)
  self.__ext = data
  self.uid = tostring(data.uuid)
  self.type = MailType.NEW_FIGHT
  self.createTime = data.battleTime
  self.isVirtualBattleReportMail = true
end

MailInfo.__init = __init
MailInfo.__delete = __delete
MailInfo.ParseBaseData = ParseBaseData
MailInfo.ParseMailData = ParseMailData
MailInfo.SetMailChannel = SetMailChannel
MailInfo.SetMailRead = SetMailRead
MailInfo.GetMailTitle = GetMailTitle
MailInfo.GetMailSubTitle = GetMailSubTitle
MailInfo.GetMailMessage = GetMailMessage
MailInfo.GetMailMessageExtra = GetMailMessageExtra
MailInfo.GetMailReward = GetMailReward
MailInfo.GetMailPay = GetMailPay
MailInfo.GetMailUserInfo = GetMailUserInfo
MailInfo.GetMailSFSObj = GetMailSFSObj
MailInfo.GetMailExt = GetMailExt
MailInfo.GetMailHeader = GetMailHeader
MailInfo.GetMailBody = GetMailBody
MailInfo.GetMailCustom = GetMailCustom
MailInfo.CanClaimReward = CanClaimReward
MailInfo.GetMailMessageTranslated = GetMailMessageTranslated
MailInfo.GetMailParam = GetMailParam
MailInfo.GetMessage = GetMessage
MailInfo.GetMailId = GetMailId
MailInfo.GetRewardData = GetRewardData
MailInfo.UpdateMailContents = UpdateMailContents
MailInfo.InitBattleReportParam = InitBattleReportParam
MailInfo.DownloadBattleReport = DownloadBattleReport
MailInfo.OnDownloadBattleReportFinish = OnDownloadBattleReportFinish
MailInfo.IsBattleReportIntegrity = IsBattleReportIntegrity
MailInfo.IsBattleReportMailType = IsBattleReportMailType
MailInfo.GetBattleReportUuid = GetBattleReportUuid
MailInfo.OnMailIntegrityExecute = OnMailIntegrityExecute
MailInfo.LoadBattleReportFromFile = LoadBattleReportFromFile
MailInfo.GetBattleReportInfo = GetBattleReportInfo
MailInfo.IsMailOutOfDate = IsMailOutOfDate
MailInfo.GetContentMailId = GetContentMailId
MailInfo.GetMailParamTable = GetMailParamTable
MailInfo.InitVirtualBattleReportMailData = InitVirtualBattleReportMailData
return MailInfo
