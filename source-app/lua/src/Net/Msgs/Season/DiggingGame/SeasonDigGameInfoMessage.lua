local SeasonDigGameInfoMessage = BaseClass("SeasonDigGameInfoMessage", SFSBaseMessage)
local base = SFSBaseMessage
local DiggingMapData = require("DataCenter.DiggingGame.DiggingMapData")

local function OnCreate(self, uuid, type_, uid_)
  base.OnCreate(self)
  self.sfsObj:PutInt("type", type_ or SeasonDigGameType.Single)
  self.sfsObj:PutLong("uuid", uuid)
  self.sfsObj:PutUtfString("uid", uid_ or LuaEntry.Player.uid)
end

local function HandleMessage(self, t)
  base.HandleMessage(self, t)
  if t.errorCode ~= nil then
    UIUtil.ShowTipsId(t.errorCode)
    return
  end
  local data = DiggingMapData.New()
  data:UpdateData(t)
  DataCenter.DiggingDataManager.curMapData = data
  EventManager:GetInstance():Broadcast(EventId.DiggingGameMapData, data)
  if data.type == SeasonDigGameType.Alliance then
    UIManager:GetInstance():OpenWindow(UIWindowNames.DiggingLevelAllianceView, {anim = true}, data)
  else
    UIManager:GetInstance():OpenWindow(UIWindowNames.DiggingLevelSingleView, {anim = true}, data)
  end
end

local __Cache = {}

local function GetTestData(self, uuid, type_)
  if __Cache[uuid] then
    return __Cache[uuid]
  end
  local levelData = {
    type = type_ or SeasonDigGameType.Single,
    uuid = uuid,
    uid = LuaEntry.Player.uid,
    mapConfigId = 10001,
    blockInfo = {},
    personalOpenInfo = nil,
    allianceOpenInfo = nil,
    rewardState = 0,
    helpInfo = nil
  }
  if levelData.type == SeasonDigGameType.Single then
    levelData.mapConfigId = 10001
  else
    levelData.mapConfigId = math.random(16001, 16010)
  end
  local levelConfig = DataCenter.DiggingDataTemplateManager:GetConfigData(levelData.mapConfigId)
  local width = levelConfig.num_width
  local height = levelConfig.num_height
  local failureTimes = 100
  for i, itemId in ipairs(levelConfig.block) do
    local config = DataCenter.DiggingDataTemplateManager:GetConfigDataBlock(itemId)
    local blockWidth = config.size_width
    local blockHeight = config.size_height
    local data = {
      bid = config.id,
      pos = 0
    }
    local x, y, right, bottom, targetX, targetY, targetRight, targetBottom, targetConfig = 0, 0
    local overlap = false
    for j = 1, failureTimes do
      x = math.random(0, width - blockWidth)
      y = math.random(0, height - blockHeight)
      right = x + blockWidth
      bottom = y + blockHeight
      overlap = false
      for k, v in pairs(levelData.blockInfo) do
        targetConfig = DataCenter.DiggingDataTemplateManager:GetConfigDataBlock(v.bid)
        targetX, targetY = DataCenter.DiggingDataManager:GetPosByIndex(v.pos, width)
        targetRight = targetX + targetConfig.size_width
        targetBottom = targetY + targetConfig.size_height
        if targetX >= right or x >= targetRight or bottom <= targetY or y >= targetBottom then
        else
          overlap = true
          break
        end
      end
      if not overlap then
        data.pos = DataCenter.DiggingDataManager:GetIndexByPos(x, y, width)
        table.insert(levelData.blockInfo, data)
        break
      end
    end
  end
  local brickDic = {}
  local helpInfo = {}
  local pos = 0
  local now = UITimeManager:GetInstance():GetServerTime()
  for i = 0, width - 1 do
    for j = 0, height - 1 do
      pos = pos + 1
      if levelData.type == SeasonDigGameType.Single then
        if math.random(1, 1000) > 900 then
          brickDic[pos] = {pos = pos}
          if math.random(1, 1000) > 500 then
            local member = DataCenter.AllianceMemberDataManager:GetRandomMember()
            table.insert(helpInfo, {
              pos = pos,
              playerInfo = {
                uid = member.uid,
                name = member.name,
                pic = member.pic,
                picVer = member.picVer
              },
              helpTime = now - math.random(1000, 100000)
            })
          end
        end
      else
        local playerInfo
        for k, v in pairs(levelData.blockInfo) do
          local config = DataCenter.DiggingDataTemplateManager:GetConfigDataBlock(v.bid)
          local blockWidth = config.size_width
          local blockHeight = config.size_height
          local targetX, targetY = DataCenter.DiggingDataManager:GetPosByIndex(v.pos, width)
          if targetX < i + 1 and i < targetX + blockWidth and targetY < j + 1 and j < targetY + blockHeight then
            playerInfo = DataCenter.AllianceMemberDataManager:GetRandomMember()
            break
          end
        end
        brickDic[pos] = {pos = pos, playerInfo = playerInfo}
      end
    end
  end
  levelData.helpInfo = helpInfo
  if levelData.type == SeasonDigGameType.Single then
    levelData.personalOpenInfo = {}
    for k, v in pairs(brickDic) do
      table.insert(levelData.personalOpenInfo, v.pos)
    end
  else
    levelData.allianceOpenInfo = {}
    for k, v in pairs(brickDic) do
      table.insert(levelData.allianceOpenInfo, v)
    end
  end
  local getBlock = true
  for k, v in pairs(levelData.blockInfo) do
    local config = DataCenter.DiggingDataTemplateManager:GetConfigDataBlock(v.bid)
    local blockWidth = config.size_width
    local blockHeight = config.size_height
    if not DataCenter.DiggingDataManager:CheckBlockGet(v.pos, brickDic, width, blockWidth, blockHeight) then
      getBlock = false
      break
    end
  end
  if getBlock then
    levelData.rewardState = 2
  end
  __Cache[uuid] = levelData
  DataCenter.DiggingDataManager.__Cache = __Cache
  return levelData
end

SeasonDigGameInfoMessage.GetTestData = GetTestData
SeasonDigGameInfoMessage.OnCreate = OnCreate
SeasonDigGameInfoMessage.HandleMessage = HandleMessage
return SeasonDigGameInfoMessage
