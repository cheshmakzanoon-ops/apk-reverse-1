local LandLockData = BaseClass("LandLockData")

local function __init(self)
  self.id = 0
  self.state = LandLockState.Finished
  self.prefabName = ""
  self.pos = {x = 0, y = 0}
  self.size = {x = 0, y = 0}
  self.priorList = {}
  self.nextList = {}
  self.pveList = {}
  self.pveFinishDict = {}
  self.needPay = false
  self.rewardType = LandLockRewardType.None
  self.alters = {}
  self.dynamicObj = {}
  self.landToZone = nil
  self.hideRewardPop = false
  self.paid = false
  self.rewardCount = 0
  self.rewardCache = nil
end

local function __delete(self)
  self.id = nil
  self.state = nil
  self.prefabName = nil
  self.pos = nil
  self.size = nil
  self.priorList = nil
  self.nextList = nil
  self.pveList = nil
  self.pveFinishDict = nil
  self.needPay = nil
  self.rewardType = nil
  self.alters = nil
  self.dynamicObj = nil
  self.landToZone = nil
  self.hideRewardPop = nil
  self.paid = nil
  self.rewardCount = nil
  self.rewardCache = nil
end

local function InitByTemplate(self, template)
  if template == nil then
    return
  end
  self.id = template.id or 0
  self.state = LandLockState.Finished
  self.prefabName = template.prefabName or ""
  self.pos = template.pos or {x = 0, y = 0}
  self.size = template.size or {x = 0, y = 0}
  self.priorList = template.priorList or {}
  self.nextList = template.nextList or {}
  self.pveList = template.pveList or {}
  self.pveFinishDict = {}
  local _, count = template:GetCost()
  self.needPay = 0 < count
  self.rewardType = template.rewardType or LandLockRewardType.None
  self.dynamicObj = template.dynamicObj
  self.landToZone = template.landToZone
  self.hideRewardPop = template.hideRewardPop
end

local function GetCurPve(self)
  for _, pve in ipairs(self.pveList) do
    if not self.pveFinishDict[pve] then
      return pve
    end
  end
  return 0
end

local function HasPve(self, pve)
  return table.hasvalue(self.pveList, pve)
end

local function GetPointId(self)
  local tilePosX = DataCenter.BuildManager.main_city_pos.x + self.pos.x
  local tilePosY = DataCenter.BuildManager.main_city_pos.y + self.pos.y
  return SceneUtils.TileXYToIndex(tilePosX, tilePosY)
end

local function GetCenterPointId(self)
  local template = DataCenter.LandLockManager:GetTemplate(self.id)
  local sumX = 0
  local sumY = 0
  for _, tile in ipairs(template.tileList) do
    sumX = sumX + tile.x
    sumY = sumY + tile.y
  end
  local x = Mathf.Round(sumX / #template.tileList)
  local y = Mathf.Round(sumY / #template.tileList)
  local tilePosX = DataCenter.BuildManager.main_city_pos.x + x
  local tilePosY = DataCenter.BuildManager.main_city_pos.y + y
  return SceneUtils.TileXYToIndex(tilePosX, tilePosY, ForceChangeScene.City)
end

local function GetCenterWorldPos(self)
  local template = DataCenter.LandLockManager:GetTemplate(self.id)
  local xMin, xMax, yMin, yMax = IntMaxValue, IntMinValue, IntMaxValue, IntMinValue
  for _, tile in ipairs(template.tileList) do
    xMin = math.min(xMin, tile.x)
    xMax = math.max(xMax, tile.x)
    yMin = math.min(yMin, tile.y)
    yMax = math.max(yMax, tile.y)
  end
  local tilePosMin = DataCenter.BuildManager.main_city_pos + Vector2.New(xMin, yMin)
  local tilePosMax = DataCenter.BuildManager.main_city_pos + Vector2.New(xMax, yMax)
  local worldPosMin = SceneUtils.TileToWorld(tilePosMin)
  local worldPosMax = SceneUtils.TileToWorld(tilePosMax)
  return Vector3.New((worldPosMin.x + worldPosMax.x) / 2, 0, (worldPosMin.z + worldPosMax.z) / 2)
end

local function CheckNeedBuild(self)
  local template = DataCenter.LandLockManager:GetTemplate(self.id)
  for _, v in ipairs(template.needBuild) do
    local buildData = DataCenter.BuildManager:GetMaxLvBuildDataByBuildId(v.buildId, true)
    if buildData == nil or buildData.level < v.level then
      return false
    end
  end
  return true
end

local function CheckNeedChapter(self)
  local template = DataCenter.LandLockManager:GetTemplate(self.id)
  local curChapter = DataCenter.ChapterTaskManager:GetCurChapterId() or 0
  return curChapter >= template.needChapter
end

local function CheckNeedQuest(self)
  local template = DataCenter.LandLockManager:GetTemplate(self.id)
  for _, questId in ipairs(template.needQuest) do
    if not DataCenter.TaskManager:IsFinishTask(tostring(questId)) and not DataCenter.ChapterTaskManager:CheckIsSuccess(tostring(questId)) then
      return false
    end
  end
  return true
end

local function HasReward(self, rewardType)
  if rewardType == nil or self.rewardType == rewardType then
    return self.rewardCount > 0
  end
  return false
end

local function GetPveFinishCount(self)
  local count = 0
  for _, pve in ipairs(self.pveList) do
    if self.pveFinishDict[pve] then
      count = count + 1
    end
  end
  return count
end

local function GetCurPveNeedPower(self)
  local pve = self:GetCurPve()
  local pveTemplate = DataCenter.PveLevelTemplateManager:GetTemplate(pve)
  if pveTemplate then
    local monsterTemplate = pveTemplate:GetFirstBattleMonsterTemplate()
    if monsterTemplate then
      return monsterTemplate.recommend_power
    end
  end
  return 0
end

local function IsLandLockShowBuild(self)
  if self.state ~= LandLockState.Locked and self.state ~= LandLockState.Unlocked then
    return false
  end
  local template = DataCenter.LandLockManager:GetTemplate(self.id)
  return #template.showBuildIds > 0
end

LandLockData.__init = __init
LandLockData.__delete = __delete
LandLockData.InitByTemplate = InitByTemplate
LandLockData.GetCurPve = GetCurPve
LandLockData.HasPve = HasPve
LandLockData.GetPointId = GetPointId
LandLockData.GetCenterPointId = GetCenterPointId
LandLockData.GetCenterWorldPos = GetCenterWorldPos
LandLockData.CheckNeedBuild = CheckNeedBuild
LandLockData.CheckNeedChapter = CheckNeedChapter
LandLockData.CheckNeedQuest = CheckNeedQuest
LandLockData.HasReward = HasReward
LandLockData.GetPveFinishCount = GetPveFinishCount
LandLockData.GetCurPveNeedPower = GetCurPveNeedPower
LandLockData.IsLandLockShowBuild = IsLandLockShowBuild
return LandLockData
