local GlobalData = BaseClass("GlobalData")
local util = require("Common.Tools.cjson.util")

function GlobalData:__init()
  self:ctor()
end

function GlobalData:ctor()
  self.db_timezone_offset = 0
  self.db_utc_timestamp = 0
  self.download_video_url = ""
  self.download_video_url2 = ""
  self.downloadurlcdn = ""
  self.downloadurl = ""
  self.eu_state = 0
  self.force_merge = 0
  self.force_use_downloadxml = 0
  self.isCN = false
  self.isArab = false
  self.lua = ""
  self.luaCode = ""
  self.luaCode_v3 = ""
  self.luaSize = 0
  self.luaVersion = ""
  self.luaVersion_v3 = ""
  self.luazipSize = 0
  self.randKey = 0
  self.reduce_init_data = 0
  self.serverVersion = ""
  self.updateType = 0
  self.upload_video_url = ""
  self.xmlVersion = ""
  self.gcmRegisterId = ""
  self.referrer = ""
  self.deeplinkParams = ""
  self.AndroidID = ""
  self.analyticID = ""
  self.s_isGooglePlayAvailable = false
  self.platformUID = ""
  self.parseRegisterId = ""
  self.fromCountry = "US"
  self.gaid = ""
  self.isLoginFlag = 0
  self.isInitFlag = 0
  self.isPause = 0
  self.isAuthenticate = false
  self.isTodayFirstLogin = false
  self.isClickMonthCardPop = 0
  self.isBind = 0
  self.isPayBind = 0
  self.isXMLInitFromServerFlag = false
  self.isFirstLoginGame = false
  self.translation = false
  self.mail_translation = false
  self.showFaceBookUi = false
  self.fbIsUpLoadImg = false
  self.version = ""
  self.usingXmlVersion = ""
  self.lang = ""
  self.uuid = ""
  self.platform = ""
  self.GPPlayerID = ""
  self.GPPlayerName = ""
  self.platformChannel = ""
  self.gaidCache = ""
  self.deeplinkPostUid = ""
  self.pauseTime = 0
  self.freshRechargeTotal = 0
  self.bFreshRechargeOpen = false
  self.activityPop = 0
  self.isInDataParsing = false
  self.isUploadPic = false
  self.isOpenTaiwanFlag = 0
  self.isOpenElvaChat = false
  self.isFAQVoteResp = false
  self.cityTileCountry = 0
  self.accFlag = false
  self.serverType = 0
  self.serverMax = 999
  self.accFlagNow = false
  self.statNewGame = false
  self.chinaSwitchFlag = 0
  self.nowGameCnt = 0
  self.freeSpdT = 0
  self.fileDataTableVersion = ""
  self.tomorrow = nil
  self.realTimezoneOffset = nil
  self.serverPicSlot = nil
  self.serverPicVer = nil
  self.lastestPicVer_ChatPhoto = -1
  self.readyForPicVer = false
  self.readyForSelectPic = false
  self.targetRoomId = -1
  self.targetUserInfoUid = -1
end

function GlobalData:InitFromNet(dict)
  self.db_utc_timestamp = dict.db_utc_timestamp or 0
  self.db_timezone_offset = dict.db_timezone_offset or 0
  self.tomorrow = dict.tomorrow
  self.realTimezoneOffset = dict.real_timezone_offset or 0
  UITimeManager:GetInstance():SetTimezoneOffset(self.realTimezoneOffset * 1000)
  self.gaid = dict.gaid or ""
  if dict.identification ~= nil then
    local temp = dict.identification
    self.isCN = temp.isCN
    self.isArab = temp.isArab
    self.isAuthenticate = temp.authenticate
  end
  self.isCN = CS.GameEntry.GlobalData:isChina()
  local path = util.GetPersistentDataPath()
  local curServerVersion = CS.GameEntry.Sdk.Version
  local name = path .. "/ZipDocument/getnewlua/" .. curServerVersion .. "/VERSION.txt"
  local str = util.file_load(name)
  if str ~= nil and str ~= "" then
    self.fileDataTableVersion = str
  end
end

function GlobalData:IsChina()
  return self.isCN
end

function GlobalData:GetIsAuthenticate()
  return self.isAuthenticate
end

function GlobalData:GetFileVersion()
  return self.fileDataTableVersion
end

return GlobalData
