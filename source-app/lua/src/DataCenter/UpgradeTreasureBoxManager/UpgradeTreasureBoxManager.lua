local UpgradeTreasureBoxManager = BaseClass("UpgradeTreasureBoxManager")
local UpgradeTreasureBoxData = require("DataCenter.UpgradeTreasureBoxManager.UpgradeTreasureBoxData")
local UpgradeTreasureBoxTemplate = require("DataCenter.UpgradeTreasureBoxManager.UpgradeTreasureBoxTemplate")

local function __init(self)
  self.config = nil
  self.rewardCache = nil
  self.treasureBoxDataAutoList = {}
  self.treasureBoxDataNonAutoList = {}
end

local function __delete(self)
  self.config = nil
  self.rewardCache = nil
  self.treasureBoxDataAutoList = nil
  self.treasureBoxDataNonAutoList = nil
end

function UpgradeTreasureBoxManager:OnRecAllUpgradeTreasureBox(msg)
  local data = msg and msg.data
  self.treasureBoxDataAutoList = {}
  self.treasureBoxDataNonAutoList = {}
  if data and data[1] then
    for _, v in ipairs(data) do
      local treasureBoxData = UpgradeTreasureBoxData.New()
      treasureBoxData:ParseInfo(v)
      if treasureBoxData:IsAuto() then
        table.insert(self.treasureBoxDataAutoList, treasureBoxData)
      else
        table.insert(self.treasureBoxDataNonAutoList, treasureBoxData)
      end
    end
    local treasureBoxNonAutoData = self.treasureBoxDataNonAutoList[1]
    if treasureBoxNonAutoData then
      EventManager:GetInstance():Broadcast(EventId.OnRecUpgradeTreasureBox)
      UIManager:GetInstance():OpenWindow(UIWindowNames.UIUpgradeTreasureBoxView, {anim = true, playEffect = 91111}, treasureBoxNonAutoData)
    end
  end
end

function UpgradeTreasureBoxManager:OnReceiveOneUpgradeTreasureBoxInfo(msg)
  local data = msg and msg.data
  if data and data[1] then
    local treasureBoxData = UpgradeTreasureBoxData.New()
    treasureBoxData:ParseInfo(data[1])
    if treasureBoxData:IsAuto() then
      table.insert(self.treasureBoxDataAutoList, treasureBoxData)
      EventManager:GetInstance():Broadcast(EventId.RefreshAutoUpgradeTreasureBoxNum, true)
    else
      local activityList = DataCenter.ActivityListDataManager:GetActivityDataByType(EnumActivity.BanquetAttackMonster.Type)
      local targetActId = 0
      if activityList and 0 < #activityList then
        targetActId = tonumber(activityList[1].id) or 0
        local isOnAutoAttack = DataCenter.ActBanquetV2Data:GetIsOnAutoAttack(targetActId)
        if isOnAutoAttack then
          return
        end
      end
      table.insert(self.treasureBoxDataNonAutoList, treasureBoxData)
      UIManager:GetInstance():OpenWindow(UIWindowNames.UIUpgradeTreasureBoxView, {anim = true, playEffect = 91111}, treasureBoxData)
      EventManager:GetInstance():Broadcast(EventId.OnRecUpgradeTreasureBox)
    end
  elseif UIManager:GetInstance():GetWindow(UIWindowNames.UIUpgradeTreasureBoxView) then
    UIManager:GetInstance():DestroyWindow(UIWindowNames.UIUpgradeTreasureBoxView)
  end
end

function UpgradeTreasureBoxManager:InitConfig()
  if self.config == nil then
    self.config = {}
    LocalController:instance():visitTable(TableName.Upgrade_TreasureBox, function(_, lineData)
      if lineData ~= nil then
        local template = UpgradeTreasureBoxTemplate.New()
        template:UpdateData(lineData)
        local levelGroup = tonumber(template.level_group)
        if not self.config[levelGroup] then
          self.config[levelGroup] = {}
        end
        local boxGroups = self.config[levelGroup]
        table.insert(boxGroups, template)
      end
    end)
  end
end

function UpgradeTreasureBoxManager:GetConfigByLevelGroup(levelGroup)
  if not self.config or table.count(self.config) == 0 then
    self:InitConfig()
  end
  return self.config[levelGroup]
end

function UpgradeTreasureBoxManager:GetBoxName(group, quality)
  local boxGroups = self:GetConfigByLevelGroup(group)
  if not boxGroups then
    Logger.LogError("UpgradeTreasureBoxManager:GetBoxName boxGroups is nil, group:" .. tostring(group))
    return ""
  end
  for _, boxTemplate in pairs(boxGroups) do
    if boxTemplate.color == quality then
      return boxTemplate.box_name
    end
  end
  return ""
end

function UpgradeTreasureBoxManager:GetAllBoxInfo(groupId)
  local result = {}
  local boxGroups = self:GetConfigByLevelGroup(groupId)
  if not boxGroups then
    Logger.LogError("UpgradeTreasureBoxManager:GetAllBoxInfo boxGroups is nil, group:" .. tostring(groupId))
    return ""
  end
  for _, boxTemplate in pairs(boxGroups) do
    table.insert(result, boxTemplate)
  end
  return result
end

function UpgradeTreasureBoxManager:GetMaxUpgradeTimes(uuid, isAuto)
  local treasureBoxDataList = isAuto and self.treasureBoxDataAutoList or self.treasureBoxDataNonAutoList
  for _, treasureBoxData in pairs(treasureBoxDataList) do
    if treasureBoxData:GetUuid() == uuid then
      return treasureBoxData:GetMaxUpgradeTimes()
    end
  end
  return 0
end

function UpgradeTreasureBoxManager:GetLastNotRedProgress(uuid, isAuto)
  local treasureBoxDataList = isAuto and self.treasureBoxDataAutoList or self.treasureBoxDataNonAutoList
  for _, treasureBoxData in pairs(treasureBoxDataList) do
    if treasureBoxData:GetUuid() == uuid then
      return treasureBoxData:GetLastNotRedProgress()
    end
  end
  return 1
end

function UpgradeTreasureBoxManager:CacheRewardData(data)
  self.rewardCache = data
end

function UpgradeTreasureBoxManager:GetCacheRewardData()
  return self.rewardCache
end

function UpgradeTreasureBoxManager:GetAutoBoxNum()
  return #self.treasureBoxDataAutoList
end

function UpgradeTreasureBoxManager:RemoveTreasureBoxByUuid(uuid, isAuto)
  local treasureBoxDataList = isAuto and self.treasureBoxDataAutoList or self.treasureBoxDataNonAutoList
  for i, treasureBoxData in pairs(treasureBoxDataList) do
    if treasureBoxData:GetUuid() == uuid then
      table.remove(treasureBoxDataList, i)
      break
    end
  end
  local playerId = LuaEntry.Player.uid
  local autoLeftNum = self.treasureBoxDataAutoList and #self.treasureBoxDataAutoList or 0
  local nonAutoLeftNum = self.treasureBoxDataNonAutoList and #self.treasureBoxDataNonAutoList or 0
  PostEventLog.Track(PostEventLog.Defines.UpgradeTreasureBoxLeftBoxNum, {
    playerId = playerId,
    autoNum = autoLeftNum,
    nonAutoLeftNum = nonAutoLeftNum
  })
end

function UpgradeTreasureBoxManager:GetFirstAutoBoxData()
  return self.treasureBoxDataAutoList[1]
end

UpgradeTreasureBoxManager.__init = __init
UpgradeTreasureBoxManager.__delete = __delete
return UpgradeTreasureBoxManager
