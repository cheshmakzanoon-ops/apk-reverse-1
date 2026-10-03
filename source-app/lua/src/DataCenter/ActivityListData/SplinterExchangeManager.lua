local SplinterExchangeManager = BaseClass("SplinterExchangeManager")

local function __init(self)
  self.exchangeInfoList = {}
  for key, value in pairs(SplinterExchangeType) do
    local exchangeInfo = SplinterExchangeInfo.New()
    exchangeInfo:InitByCfg(value)
    self.exchangeInfoList[value.Id] = exchangeInfo
  end
  self:AddListener()
end

local function __delete(self)
  self.exchangeInfoList = nil
  self:RemoveListener()
end

local function AddListener(self)
end

local function RemoveListener(self)
end

local function RefreshSelfInfo(self, message)
  if message and message.type then
    self.exchangeInfoList[message.type]:RefreshSelfInfo(message)
  end
end

local function RefreshALInfoList(self, message)
  if message and message.type then
    self.exchangeInfoList[message.type]:RefreshALInfoList(message)
  end
end

local function CancelExchange(self, type)
  self.exchangeInfoList[type]:CancelExchange()
end

local function RefreshRecordDataList(self, message)
  self.exchangeInfoList[message.type]:RefreshRecordDataList(message)
end

local function RefreshOneRecordData(self, message)
  self.exchangeInfoList[message.type]:RefreshOneRecordData(message)
end

local function RefreshSelfRecordShowData(self, message)
  self.exchangeInfoList[message.type]:RefreshSelfRecordShowData(message)
end

local function GetRecordDataByUuid(self, type, uuid)
  return self.exchangeInfoList[type]:GetRecordDataByUuid(uuid)
end

local function GetAlExchangeDataList(self, type)
  return self.exchangeInfoList[type]:GetAlExchangeDataList()
end

local function GetSelfExchangeData(self, type)
  return self.exchangeInfoList[type]:GetSelfExchangeData()
end

local function GetRecordDataList(self, type)
  return self.exchangeInfoList[type]:GetRecordDataList()
end

local function GetAllFragNum(self, type)
  return self.exchangeInfoList[type]:GetAllFragNum()
end

local function SetShowExchangeRedPoint(self, message)
  if message and message.TREASURE_FRAGMENT then
    self.exchangeInfoList[SplinterExchangeType.DispatchTreasure.Id]:SetShowExchangeRedPoint(message)
  end
end

local function GetExchangeLogRedPoint(self, type)
  return self.exchangeInfoList[type]:GetExchangeLogRedPoint()
end

local function GetFragGoodsIdList(self, type)
  return self.exchangeInfoList[type].fragGoodsIdList
end

local function GetExchangeInfo(self, type)
  return self.exchangeInfoList[type]
end

local function GetIndexByGoodsId(self, type, goodsId)
  if type == nil then
    return 0
  end
  return self.exchangeInfoList[type]:GetIndexByGoodsId(goodsId)
end

local function GetIndexStrByIndex(self, type, index)
  if (type == SplinterExchangeType.DispatchTreasure.Id or type == SplinterExchangeType.DigTreasure.Id) and index and 0 < index then
    return "M" .. index
  else
    return ""
  end
end

local function GetIndexStrByGoodsId(self, type, goodsId)
  return self:GetIndexStrByIndex(type, self:GetIndexByGoodsId(type, goodsId))
end

local function GetLogRedPointStrByType(self, type)
  return self.exchangeInfoList[type]:GetCfgData().LogRedPoint
end

local function GetSplinterTypeByLogRedPointStr(self, str)
  for key, value in pairs(SplinterExchangeType) do
    if value.LogRedPoint == str then
      return value.Id
    end
  end
  return nil
end

SplinterExchangeManager.__init = __init
SplinterExchangeManager.__delete = __delete
SplinterExchangeManager.AddListener = AddListener
SplinterExchangeManager.RemoveListener = RemoveListener
SplinterExchangeManager.RefreshSelfInfo = RefreshSelfInfo
SplinterExchangeManager.RefreshALInfoList = RefreshALInfoList
SplinterExchangeManager.CancelExchange = CancelExchange
SplinterExchangeManager.RefreshRecordDataList = RefreshRecordDataList
SplinterExchangeManager.RefreshSelfRecordShowData = RefreshSelfRecordShowData
SplinterExchangeManager.RefreshOneRecordData = RefreshOneRecordData
SplinterExchangeManager.GetAlExchangeDataList = GetAlExchangeDataList
SplinterExchangeManager.GetSelfExchangeData = GetSelfExchangeData
SplinterExchangeManager.GetRecordDataList = GetRecordDataList
SplinterExchangeManager.GetRecordDataByUuid = GetRecordDataByUuid
SplinterExchangeManager.GetAllFragNum = GetAllFragNum
SplinterExchangeManager.GetExchangeLogRedPoint = GetExchangeLogRedPoint
SplinterExchangeManager.SetShowExchangeRedPoint = SetShowExchangeRedPoint
SplinterExchangeManager.GetFragGoodsIdList = GetFragGoodsIdList
SplinterExchangeManager.GetExchangeInfo = GetExchangeInfo
SplinterExchangeManager.GetIndexByGoodsId = GetIndexByGoodsId
SplinterExchangeManager.GetIndexStrByIndex = GetIndexStrByIndex
SplinterExchangeManager.GetIndexStrByGoodsId = GetIndexStrByGoodsId
SplinterExchangeManager.GetLogRedPointStrByType = GetLogRedPointStrByType
SplinterExchangeManager.GetSplinterTypeByLogRedPointStr = GetSplinterTypeByLogRedPointStr
return SplinterExchangeManager
