local AircraftBubbleUtil = BaseClass("AircraftBubbleUtil")
local AircraftBubbleTip = require("Scene.GainWorkerManager.AircraftBubbleTip")
local tipsModels = {}

local function GetTipsModelIndexByUid(uid)
  for i = 1, #tipsModels do
    if tipsModels[i].uid == uid then
      return i
    end
  end
end

local function RemoveAllTip()
  for i = 1, #tipsModels do
    if tipsModels[i] then
      tipsModels[i].model:Delete()
    end
  end
  tipsModels = {}
end

local function CreateTips(self, workerDataList)
  RemoveAllTip()
  local isInOpeningStage = not DataCenter.LWOpeningStageManager:IsAllDone()
  local anchorPos
  if isInOpeningStage then
    anchorPos = DataCenter.LWOpeningStageManager.squadProxy.cells[1].position + Vector3(0, 3, 0)
  else
    local workerBuildDataList = DataCenter.BuildManager:GetAllBuildingByItemIdWithoutPickUp(BuildingTypes.Lw_BUILD_BATTLE_FEATURE_ENTRY)
    local buildData = workerBuildDataList[1]
    if buildData == nil then
      return
    end
    anchorPos = buildData:GetCenterVec()
  end
  local tempIndex = math.ceil(#workerDataList * 0.5)
  local offset = #workerDataList % 2 == 0 and -0.5 or 0
  for i = #workerDataList, 1, -1 do
    local pos
    pos = Vector3.New(anchorPos.x - (tempIndex - i) + offset, 3.5, anchorPos.z - (tempIndex - i) + offset)
    local bubbleTip = AircraftBubbleTip:New()
    bubbleTip.isInOpeningStage = isInOpeningStage
    workerDataList[i].pos = pos
    bubbleTip:Init(workerDataList[i])
    local info = {}
    info.model = bubbleTip
    info.uid = workerDataList[i].uid
    table.insert(tipsModels, info)
  end
end

local function AllBubbleSetActive(self, isOn)
  for i = 1, #tipsModels do
    if tipsModels[i] then
      tipsModels[i].model:SetActive(isOn)
    end
  end
end

local function SortTipsPos()
  local isInOpeningStage = not DataCenter.LWOpeningStageManager:IsAllDone()
  local anchorPos
  if isInOpeningStage then
    anchorPos = DataCenter.LWOpeningStageManager.squadProxy.cells[1].position + Vector3(0, 3, 0)
  else
    local workerBuildDataList = DataCenter.BuildManager:GetAllBuildingByItemIdWithoutPickUp(BuildingTypes.Lw_BUILD_BATTLE_FEATURE_ENTRY)
    local buildData = workerBuildDataList[1]
    if buildData == nil then
      return
    end
    anchorPos = buildData:GetCenterVec()
  end
  local tempIndex = math.ceil(#tipsModels * 0.5)
  local offset = #tipsModels % 2 == 0 and -0.5 or 0
  for i = 1, #tipsModels do
    local pos
    pos = Vector3.New(anchorPos.x - (tempIndex - i) + offset, 3.5, anchorPos.z - (tempIndex - i) + offset)
    tipsModels[i].model:RefreshPosition(pos)
  end
end

local function RemoveTipByUid(self, uid)
  local index = GetTipsModelIndexByUid(uid)
  if index then
    tipsModels[index].model:Delete()
    table.remove(tipsModels, index)
  end
  SortTipsPos()
end

AircraftBubbleUtil.CreateTips = CreateTips
AircraftBubbleUtil.RemoveTipByUid = RemoveTipByUid
AircraftBubbleUtil.RemoveAllTip = RemoveAllTip
AircraftBubbleUtil.AllBubbleSetActive = AllBubbleSetActive
return AircraftBubbleUtil
