local AreaInfo = BaseClass("AreaInfo")

local function __init(self)
  self.id = 0
  self.time = 0
  self.alInfoList = {}
end

local function __delete(self)
  self.id = nil
  self.time = nil
  self.alInfoList = nil
end

local function ParseData(self, message)
  if message == nil then
    return
  end
  local size = LuaEntry.DataConfig:TryGetNum("world_news_info", "k6")
  if size <= 0 then
    size = 50
  end
  local blockNum = math.floor(6500 / size)
  if message.id ~= nil then
    local areaId = message.id
    local v2 = {}
    v2.x = areaId % blockNum
    v2.y = math.floor(areaId / blockNum)
    v2.x = v2.x * size + math.floor(size / 2)
    v2.y = v2.y * size + math.floor(size / 2)
    self.id = SceneUtils.TilePosToIndex(v2)
  end
  if message.time ~= nil then
    self.time = message.time
  end
  self.alInfoList = {}
  local temDic = {}
  if message.alInfo ~= nil then
    local arr = message.alInfo
    for k, v in pairs(arr) do
      local abbr = "[" .. v .. "] "
      if temDic[abbr] == nil then
        table.insert(self.alInfoList, abbr)
        temDic[abbr] = 1
      end
    end
  end
  temDic = {}
end

AreaInfo.__init = __init
AreaInfo.__delete = __delete
AreaInfo.ParseData = ParseData
return AreaInfo
