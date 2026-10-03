local MailRankDataManager = BaseClass("MailRankDataManager")
local rapidjson = require("rapidjson")
local Localization = CS.GameEntry.Localization
local MailRankDataDownloadManager = CS.MailRankDataDownloadManager
local File = CS.System.IO.File
local util = require("Common.Tools.cjson.util")

local function __init(self)
  self.requestingUuid = nil
  self.requestingCrc = nil
  self.requestingSize = nil
  self.savePath = nil
  self.mailRankDataDict = {}
  self:AddListener()
end

local function __delete(self)
  self.requestingUuid = nil
  self.requestingCrc = nil
  self.requestingSize = nil
  self.savePath = nil
  self.mailRankDataDict = {}
  self:RemoveListener()
end

local function AddListener(self)
  EventManager:GetInstance():AddListener(EventId.GetMailRankDataDownLoad, self.GetDataInLocalFile)
end

local function RemoveListener(self)
  EventManager:GetInstance():RemoveListener(EventId.GetMailRankDataDownLoad, self.GetDataInLocalFile)
end

local function TryGetMailRankData(self, mailRankDataUuid, crc, size, address)
  self.requestingUuid = mailRankDataUuid
  self.requestingCrc = crc
  self.requestingSize = size
  self.savePath = MailRankDataDownloadManager.instance:GetSavePath(mailRankDataUuid)
  local isHave = self.GetDataInDict(self.requestingUuid)
  if isHave then
    return
  end
  isHave = self.GetDataInLocalFile(self.savePath)
  if isHave then
    return
  end
  self.GetDataByDownLoad(self.requestingUuid, self.requestingCrc, self.requestingSize, address)
end

local function CancelGetMailRankData(self)
  self.requestingUuid = nil
  self.requestingCrc = nil
  self.requestingSize = nil
  self.savePath = nil
end

local function GetDataInDict(mailRankDataUuid)
  local self = DataCenter.MailRankDataManager
  local isHave = false
  if self.mailRankDataDict[mailRankDataUuid] then
    isHave = true
    EventManager:GetInstance():Broadcast(EventId.GetMailRankData, {
      uuid = mailRankDataUuid,
      data = self.mailRankDataDict[mailRankDataUuid]
    })
  end
  return isHave
end

local function GetDataInLocalFile(savePath)
  local self = DataCenter.MailRankDataManager
  local isHave = false
  if not File.Exists(savePath) then
    return isHave
  end
  if savePath == self.savePath then
    local readDataStr = File.ReadAllBytes(savePath)
    if readDataStr ~= nil then
      isHave = true
      local dataStr = readDataStr
      local msgData = PBController.ParsePbFromBytes(dataStr, "protobuf.LwCommonJsonOss") or {}
      self.mailRankDataDict[self.requestingUuid] = msgData
      self.GetDataInDict(self.requestingUuid)
    end
  end
  return isHave
end

local function GetDataByDownLoad(mailRankDataUuid, crc, size, address)
  if address == nil then
    address = ""
  end
  local self = DataCenter.MailRankDataManager
  MailRankDataDownloadManager.instance:TryDownloadMailRankData(mailRankDataUuid, size, crc, address)
end

MailRankDataManager.__init = __init
MailRankDataManager.__delete = __delete
MailRankDataManager.AddListener = AddListener
MailRankDataManager.RemoveListener = RemoveListener
MailRankDataManager.TryGetMailRankData = TryGetMailRankData
MailRankDataManager.CancelGetMailRankData = CancelGetMailRankData
MailRankDataManager.GetDataInDict = GetDataInDict
MailRankDataManager.GetDataInLocalFile = GetDataInLocalFile
MailRankDataManager.GetDataByDownLoad = GetDataByDownLoad
return MailRankDataManager
