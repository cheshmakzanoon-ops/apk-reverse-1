local GuideRecordDataManager = BaseClass("GuideRecordDataManager")
local Localization = CS.GameEntry.Localization
local rapidjson = require("rapidjson")
local defaultVal

local function __init(self)
  self.function_guide = nil
  self.guidRecordTab = nil
end

local function __delete(self)
  self.function_guide = nil
  self.guidRecordTab = nil
end

function GuideRecordDataManager:InitData(initMsg)
  if initMsg.function_guide then
    self.function_guide = initMsg.function_guide
    self.guidRecordTab = nil
  end
end

function GuideRecordDataManager:TrySetRecordTab()
  if self.guidRecordTab == nil then
    if string.IsNullOrEmpty(self.function_guide) then
      self.guidRecordTab = {}
    else
      local getData = rapidjson.decode(self.function_guide)
      if getData and getData.guides then
        self.guidRecordTab = getData.guides
      else
        self.guidRecordTab = {}
      end
    end
  end
end

function GuideRecordDataManager:GetRecordTabData(recordType)
  self:TrySetRecordTab()
  if self.guidRecordTab[recordType] then
    return self.guidRecordTab[recordType]
  end
  return defaultVal
end

function GuideRecordDataManager:SetRecordTabDataByMsg(recordType, data)
  if recordType == nil or data == nil then
    return
  end
  SFSNetwork.SendMessage(MsgDefines.GuideRecord, recordType, data)
end

function GuideRecordDataManager:SetRecordTabData(recordType, data)
  if recordType == nil or data == nil then
    return
  end
  self:TrySetRecordTab()
  self.guidRecordTab[recordType] = data
  self:AfterNewSetFunc(recordType, data)
end

function GuideRecordDataManager:AfterNewSetFunc(recordType, data)
  if recordType == GuidServerRecordType.BirthdayDataRecord or recordType == GuidServerRecordType.BirthdayFuncAfterOpenInfoViewOpen then
    EventManager:GetInstance():Broadcast(EventId.BirthdaySetPanelOpenGuidServerRecord, data)
  elseif recordType == GuidServerRecordType.GiftShowAutoAni then
    EventManager:GetInstance():Broadcast(EventId.TypeGiftShowAutoAniGuidServerRecord, data)
  end
end

GuideRecordDataManager.__init = __init
GuideRecordDataManager.__delete = __delete
return GuideRecordDataManager
