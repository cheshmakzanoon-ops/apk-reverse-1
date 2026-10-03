local ScienceDataManager = BaseClass("ScienceDataManager")

local function __init(self)
  self.allScience = {}
  self.scienceTabProgress = {}
end

local function __delete(self)
  self.allScience = nil
  self.scienceTabProgress = nil
end

local function InitData(self, message)
  if message.science_new ~= nil then
    self.allScience = {}
    for k, v in pairs(message.science_new) do
      self:UpdateOneData(v)
    end
  end
  if message.scienceTabProgress ~= nil then
    self.scienceTabProgress = message.scienceTabProgress
  end
end

local function UpdateOneData(self, message)
  if message.itemId ~= nil then
    local id = message.itemId
    local one = self:GetScienceById(id)
    if one == nil then
      one = ScienceInfo.New()
      one:UpdateInfo(message)
      self.allScience[id] = one
    else
      one:UpdateInfo(message)
    end
  end
end

local function GetScienceById(self, id)
  return self.allScience[id]
end

local function GetAllScienceOnlyRead(self)
  return self.allScience
end

function ScienceDataManager:IsScienceTabProgressOptimizeFunctionOn()
  return LuaEntry.DataConfig:CheckSwitch("science_percent_server")
end

function ScienceDataManager:GetScienceTabProgress(tabId)
  local res = 0
  if self.scienceTabProgress ~= nil and tabId ~= nil then
    tabId = tostring(tabId)
    res = self.scienceTabProgress[tabId] or 0
  end
  res = Mathf.DecimalFormat(res / 100, 2)
  return res
end

function ScienceDataManager:UpdateScienceTabProgress(progress)
  local hasChanged = false
  if self.scienceTabProgress ~= nil then
    for k, v in pairs(progress) do
      if self.scienceTabProgress[k] ~= v then
        hasChanged = true
        break
      end
    end
  else
    hasChanged = true
  end
  self.scienceTabProgress = progress
  if hasChanged then
    EventManager:GetInstance():Broadcast(EventId.ScienceTabProgressDataChanged)
  end
end

function ScienceDataManager:SendScienceTabProgressGetMessage()
  SFSNetwork.SendMessage(MsgDefines.ScienceTabProgressGet)
end

ScienceDataManager.__init = __init
ScienceDataManager.__delete = __delete
ScienceDataManager.InitData = InitData
ScienceDataManager.UpdateOneData = UpdateOneData
ScienceDataManager.GetScienceById = GetScienceById
ScienceDataManager.GetAllScienceOnlyRead = GetAllScienceOnlyRead
return ScienceDataManager
