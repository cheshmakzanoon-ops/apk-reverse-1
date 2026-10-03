local RoadBubbleManager = BaseClass("RoadBubbleManager")
local RoadBubbleTip = require("UI.BuildBubbleTip.View.RoadBubbleTip")
local TileBgScale1 = Vector3.New(0.7, 0.7, 0.7)
local TileBgScale2 = Vector3.New(1, 1, 1)
local TileBgScale3 = Vector3.New(0.6, 0.6, 0.6)
local MaxDistance = 40
local ShowLod = 1

function RoadBubbleManager:__init()
  self.bubbleDic = {}
  self.inViewCollect = {}
  self.showBubbleNode = true
  self.lodCache = ShowLod
  self:AddListener()
end

function RoadBubbleManager:__delete()
  self:RemoveListener()
  self:ClearAll()
  self.showBubbleNode = true
  self.lodCache = 1
  self.bubbleDic = {}
  self.inViewCollect = {}
end

function RoadBubbleManager:AddListener()
  if self.worldCollectPointOutViewSignal == nil then
    function self.worldCollectPointOutViewSignal(pointId)
      self:WorldCollectPointOutViewSignal(pointId)
    end
    
    EventManager:GetInstance():AddListener(EventId.WorldCollectPointOutView, self.worldCollectPointOutViewSignal)
  end
  if self.worldCollectPointInViewSignal == nil then
    function self.worldCollectPointInViewSignal(pointId)
      self:WorldCollectPointInViewSignal(pointId)
    end
    
    EventManager:GetInstance():AddListener(EventId.WorldCollectPointInView, self.worldCollectPointInViewSignal)
  end
  if self.updateRoadDataSignal == nil then
    function self.updateRoadDataSignal(pointId)
      self:UpdateRoadDataSignal(pointId)
    end
    
    EventManager:GetInstance():AddListener(EventId.UpdateRoadData, self.updateRoadDataSignal)
  end
  if self.changeCameraLodSignal == nil then
    function self.changeCameraLodSignal(pointId)
      self:ChangeCameraLodSignal(pointId)
    end
    
    EventManager:GetInstance():AddListener(EventId.ChangeCameraLod, self.changeCameraLodSignal)
  end
end

function RoadBubbleManager:RemoveListener()
  if self.worldCollectPointOutViewSignal ~= nil then
    EventManager:GetInstance():RemoveListener(EventId.WorldCollectPointOutView, self.worldCollectPointOutViewSignal)
    self.worldCollectPointOutViewSignal = nil
  end
  if self.worldCollectPointInViewSignal ~= nil then
    EventManager:GetInstance():RemoveListener(EventId.WorldCollectPointInView, self.worldCollectPointInViewSignal)
    self.worldCollectPointInViewSignal = nil
  end
  if self.updateRoadDataSignal ~= nil then
    EventManager:GetInstance():RemoveListener(EventId.UpdateRoadData, self.updateRoadDataSignal)
    self.updateRoadDataSignal = nil
  end
  if self.changeCameraLodSignal ~= nil then
    EventManager:GetInstance():RemoveListener(EventId.ChangeCameraLod, self.changeCameraLodSignal)
    self.changeCameraLodSignal = nil
  end
end

function RoadBubbleManager:Startup()
end

function RoadBubbleManager:CreateOneBubble(param)
  if param ~= nil then
    if self.bubbleDic[param.mainPoint] == nil then
      self.bubbleDic[param.mainPoint] = {}
    end
    if self.bubbleDic[param.mainPoint][param.pointId] == nil then
      local bubble = RoadBubbleTip.New(param)
      self.bubbleDic[param.mainPoint][param.pointId] = bubble
    else
      self.bubbleDic[param.mainPoint][param.pointId]:ReInit(param)
    end
  end
end

function RoadBubbleManager:DeleteOneBubble(mainPointId, pointId)
  local list = self.bubbleDic[mainPointId]
  if list ~= nil then
    if pointId == nil then
      for k, v in pairs(list) do
        v:Destroy()
      end
      self.bubbleDic[mainPointId] = nil
    elseif list[pointId] ~= nil then
      list[pointId]:Destroy()
      list[pointId] = nil
    end
  end
end

function RoadBubbleManager:GetBgScale(tiles)
  if tiles == BuildTilesSize.One then
    return TileBgScale1
  else
    return TileBgScale2
  end
  return TileBgScale2
end

function RoadBubbleManager:GetIconScale()
  return ResetScale
end

function RoadBubbleManager:GetNeedShowBubbleParam(mainPoint, pointId)
  local boardData = DataCenter.BoardManager:GetBoardDataByPointId(pointId)
  if boardData ~= nil then
    local param = {}
    param.uuid = boardData.uuid
    param.model = UIAssets.BuildStateIcon
    param.bgName = string.format(LoadPath.UIBuildBubble, BuildBubbleIconName.BgUnSelect)
    param.iconName = string.format(LoadPath.UIBuildBubble, BuildBubbleIconName.RemoveRoad)
    param.buildBubbleType = BuildBubbleType.RemoveRoad
    param.pointId = boardData.pointId
    param.tileX = BuildTilesSize.One
    param.tileY = BuildTilesSize.One
    param.callBack = self.OnClickCallBack
    param.bgScale = self:GetBgScale(param)
    param.iconScale = self:GetIconScale(param)
    param.mainPoint = mainPoint
    param.visible = self:GetCanVisible()
    return param
  end
end

function RoadBubbleManager:CheckShowBubble(mainPoint, pointId)
  local param = self:GetNeedShowBubbleParam(mainPoint, pointId)
  if param == nil then
    self:DeleteOneBubble(mainPoint, pointId)
  else
    self:CreateOneBubble(param)
  end
end

function RoadBubbleManager:WorldCollectPointInViewSignal(pointId)
end

function RoadBubbleManager:WorldCollectPointOutViewSignal(pointId)
  if self.inViewCollect[pointId] ~= nil then
    self.inViewCollect[pointId] = nil
  end
  self:DeleteOneBubble(pointId)
end

function RoadBubbleManager:OnClickCallBack(param)
  if param.buildBubbleType == BuildBubbleType.RemoveRoad then
    SFSNetwork.SendMessage(MsgDefines.BuildRoadDestroyNew, {
      arr = {
        param.pointId
      }
    })
    DataCenter.RoadBubbleManager:DeleteOneBubble(param.mainPoint, param.pointId)
  end
end

function RoadBubbleManager:UpdateRoadDataSignal(uuid)
  local boardData = DataCenter.BoardManager:GetBoardData(uuid)
  if boardData ~= nil then
  else
    for k, v in pairs(self.bubbleDic) do
      for k1, v1 in pairs(v) do
        if v1.param.uuid == uuid then
          v1:Destroy()
          v[k1] = nil
          return
        end
      end
    end
  end
end

function RoadBubbleManager:CheckAllCollect()
  for k, v in pairs(self.inViewCollect) do
    self:WorldCollectPointInViewSignal(k)
  end
end

function RoadBubbleManager:ChangeCameraLodSignal(lod)
  self.lodCache = lod
  self:RefreshBubbleNode()
end

function RoadBubbleManager:ShowBubbleNode()
  self.showBubbleNode = true
  self:RefreshBubbleNode()
end

function RoadBubbleManager:HideBubbleNode()
  self.showBubbleNode = false
  self:RefreshBubbleNode()
end

function RoadBubbleManager:RefreshBubbleNode()
  local active = self:GetCanVisible()
  for k, v in pairs(self.bubbleDic) do
    for k1, v1 in pairs(v) do
      v1:SetVisible(active)
    end
  end
end

function RoadBubbleManager:GetCanVisible()
  return self.showBubbleNode and self.lodCache <= ShowLod
end

function RoadBubbleManager:ClearAll()
  for k, v in pairs(self.bubbleDic) do
    for k1, v1 in pairs(v) do
      v1:Destroy()
    end
  end
  self.bubbleDic = {}
end

return RoadBubbleManager
