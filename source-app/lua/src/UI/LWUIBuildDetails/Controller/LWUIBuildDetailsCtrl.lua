local LWUIBuildDetailsCtrl = BaseClass("LWUIBuildDetailsCtrl", UIBaseCtrl)
local buildData

local function CloseSelf(self)
  UIManager.Instance:DestroyWindow(UIWindowNames.LWUIBuildDetails)
  DataCenter.ArrowManager:RemoveFingerArrow(true)
end

local function GetTrenchDataList(self, curBuildIndex)
  local trenchDataList = {}
  buildData = DataCenter.BuildManager:GetBuildingDataByPointId(curBuildIndex)
  local buildLine = LocalController:instance():getLine(LuaEntry.Player:GetABTestTableName(TableName.Building), buildData.itemId)
  local maxCount = tonumber(buildLine.hero_slots)
  if maxCount == nil then
    return trenchDataList
  end
  local data = DataCenter.BuildTemplateManager:GetBuildingDesTemplate(buildData.itemId)
  local tempdata, trenchData
  local lastSlots = 0
  local workerData
  local count = tonumber(data.max_level)
  tempdata = LocalController:instance():getLine(LuaEntry.Player:GetABTestTableName(TableName.Building), buildData.itemId + count)
  local curdata = LocalController:instance():getLine(LuaEntry.Player:GetABTestTableName(TableName.Building), buildData.itemId + buildData.level)
  local tempLevel = buildData.level
  lastSlots = tonumber(tempdata.hero_slots)
  for i = 1, lastSlots do
    trenchData = {}
    trenchData.type = BuildDisPatchingHeroTrenchState.LOCK
    if i <= tonumber(curdata.hero_slots) then
      trenchData.type = BuildDisPatchingHeroTrenchState.ADD
      if buildData.assignedHeroList[i] ~= nil and buildData.assignedHeroList[i] ~= "" then
        workerData = DataCenter.WorkerDataManager:GetWorkerDataByUid(tonumber(buildData.assignedHeroList[i]))
        trenchData.workerData = workerData
        trenchData.type = BuildDisPatchingHeroTrenchState.HERO
      end
    else
      local nextData = LocalController:instance():getLine(LuaEntry.Player:GetABTestTableName(TableName.Building), buildData.itemId + tempLevel)
      if i <= tonumber(nextData.hero_slots) then
        trenchData.lockLevel = tempLevel
      else
        tempLevel = tempLevel + 1
        nextData = LocalController:instance():getLine(LuaEntry.Player:GetABTestTableName(TableName.Building), buildData.itemId + tempLevel)
        if i <= tonumber(nextData.hero_slots) then
          trenchData.lockLevel = tempLevel
        end
      end
    end
    trenchData.curBuildData = buildData
    trenchData.curBuildIndex = curBuildIndex
    table.insert(trenchDataList, trenchData)
  end
  return trenchDataList
end

LWUIBuildDetailsCtrl.CloseSelf = CloseSelf
LWUIBuildDetailsCtrl.GetTrenchDataList = GetTrenchDataList
return LWUIBuildDetailsCtrl
