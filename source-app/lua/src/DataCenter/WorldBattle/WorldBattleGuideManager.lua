local WorldBattleGuideManager = BaseClass("WorldBattleGuideManager")
local WorldBattleGuideBtn = BaseClass("WorldBattleGuideBtn", UIAsyncContainer)
local base = UIAsyncContainer
local Localization = CS.GameEntry.Localization
local dirtyDict = {}

function WorldBattleGuideManager:__init()
  self.metaDict = {}
  self.bubbleBtn = nil
  EventManager:GetInstance():AddListener(EventId.OnEnterWorld, self.OnEnterWorld)
  EventManager:GetInstance():AddListener(EventId.OnEnterCity, self.OnEnterCity)
end

function WorldBattleGuideManager:__delete()
  EventManager:GetInstance():RemoveListener(EventId.OnEnterWorld, self.OnEnterWorld)
  EventManager:GetInstance():RemoveListener(EventId.OnEnterCity, self.OnEnterCity)
end

function WorldBattleGuideManager:Init()
  SFSNetwork.SendMessage(MsgDefines.FetchWorldGuideTipData)
  if LocalController:instance():hasTable(TableName.WorldBattleGuide) then
    LocalController:instance():visitTable(TableName.WorldBattleGuide, function(id, line)
      local theType = toInt(line.type)
      self.metaDict[theType] = {
        type = theType,
        order = toInt(line.order),
        icon = line.icon
      }
    end)
  end
end

function WorldBattleGuideManager:OnEnterWorld()
  local this = DataCenter.WorldBattleGuideManager
  if this and this.bubbleTipLayout then
    this:TryUpdateBubble()
  end
end

function WorldBattleGuideManager:OnEnterCity()
  local this = DataCenter.WorldBattleGuideManager
  if this.bubbleBtn then
    this.bubbleBtn:SetActive(false)
  end
end

function WorldBattleGuideManager:SetBubbleTipLayoutRoot(bubbleTipLayout)
  self.bubbleTipLayout = bubbleTipLayout
  if CS.SceneManager.IsInWorld() then
    self:TryUpdateBubble()
  end
end

function WorldBattleGuideManager:TryUpdateBubble()
  if not (self.bubbleTipLayout ~= nil and CS.SceneManager.IsInWorld()) or BattleFieldUtil.InBattleField() then
    return
  end
  if self.dataList == nil then
    if self.bubbleBtn then
      self.bubbleBtn:SetActive(false)
    end
    return
  end
  local curServerId = LuaEntry.Player:GetCurServerId()
  local data = SeasonUtil.GetSeasonInfo(curServerId)
  if data then
    local mySourceServerId = LuaEntry.Player:GetSourceServerId()
    local theServerType = data:GetServerType(false)
    if theServerType == SeasonMapType.NineNation then
      if not data:IsInBattleServerGroupInt(mySourceServerId) then
        if self.bubbleBtn then
          self.bubbleBtn:SetActive(false)
        end
        return
      end
    elseif mySourceServerId ~= curServerId then
      if self.bubbleBtn then
        self.bubbleBtn:SetActive(false)
      end
      return
    end
  end
  if self.bubbleBtn == nil then
    local prefabPath = "Assets/Main/Prefabs/UI/LWMainUI/World/WorldBattleGuideBtn.prefab"
    self.bubbleBtn = UIBaseComponent.LoadComponentAsync(self, WorldBattleGuideBtn, prefabPath, self.bubbleTipLayout)
    self.bubbleBtn:SetActive(true)
  end
  self.bubbleBtn:SetBubbleData(self.dataList)
end

function WorldBattleGuideManager:OnServerData(events)
  local dataList = {}
  if events then
    for k, v in pairs(events) do
      local theType = toInt(v.type)
      local meta = self.metaDict[theType]
      if meta then
        if theType == 3 then
          v.marchUuid = toInt(v.eventKey)
        end
        table.insert(dataList, {meta = meta, data = v})
      end
    end
    table.sort(dataList, function(a, b)
      return a.meta.order > b.meta.order
    end)
  end
  self.dataList = dataList
  self:TryUpdateBubble()
end

function WorldBattleGuideManager:DropData(eventKey, eventType)
  SFSNetwork.SendMessage(MsgDefines.DropWorldGuideTipData, eventKey, eventType)
end

function WorldBattleGuideManager:DeleteData(events)
  if self.dataList then
    for k1, v1 in pairs(events) do
      for k2, v2 in pairs(self.dataList) do
        if v2 and v1 and v2.data and v2.data.eventKey == v1.eventKey then
          v2.data = nil
        end
      end
    end
  end
  self:TryUpdateBubble()
end

function WorldBattleGuideManager:AddData(events)
  local dataList = {}
  if events then
    for k, v in pairs(events) do
      local theType = toInt(v.type)
      local meta = self.metaDict[theType]
      if meta then
        local newData = true
        if self.dataList then
          for k2, v2 in pairs(self.dataList) do
            if v2 and v and v2.data and v2.data.eventKey == v.eventKey then
              v2.data = v
              newData = false
            end
          end
        end
        if newData then
          if theType == 3 then
            v.marchUuid = toInt(v.eventKey)
          end
          table.insert(dataList, {meta = meta, data = v})
        end
      end
    end
    table.sort(dataList, function(a, b)
      return a.meta.order > b.meta.order
    end)
  end
  self.dataList = dataList
  self:TryUpdateBubble()
end

function WorldBattleGuideBtn:OnCreate()
  base.OnCreate(self)
  self.btn = self:AddComponent(UIButton, "")
  self.icon = self:AddComponent(UIImage, "icon")
  self.arrow = self:AddComponent(UIImage, "arrow")
  self.txt = self:AddComponent(UITextMeshProUGUIEx, "txt")
  self.btn:SetOnClick(function()
    self:JumpTo(self.data)
  end)
  self.disText = Localization:GetString(GameDialogDefine.KILOMETRE)
  local x, y = self.transform:Get_lossyScale()
  self.lossyScale = y
end

function WorldBattleGuideBtn:OnDestroy()
  self.icon = nil
  self.arrow = nil
  self.txt = nil
  base.OnDestroy(self)
end

function WorldBattleGuideBtn:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.OnEnterCity, self.UpdateData)
  self:AddUIListener(EventId.OnEnterWorld, self.UpdateData)
  self:AddUIListener(EventId.WORLD_CAMERA_CHANGE_POINT, self.RefreshCameraPoint)
end

function WorldBattleGuideBtn:OnRemoveListener()
  self:RemoveUIListener(EventId.OnEnterCity, self.UpdateData)
  self:RemoveUIListener(EventId.OnEnterWorld, self.UpdateData)
  self:RemoveUIListener(EventId.WORLD_CAMERA_CHANGE_POINT, self.RefreshCameraPoint)
  base.OnRemoveListener(self)
end

function WorldBattleGuideBtn:JumpTo()
  if self.data and self.data.eventKey then
    dirtyDict[self.data.eventKey] = true
    DataCenter.WorldBattleGuideManager:DropData(self.data.eventKey, self.data.type)
  end
  if self.data == nil or self.data.serverId == nil then
    if self.dataFull and self.dataFull.data == self.data then
      self.dataFull.data = nil
      self:UpdateData()
    end
    return
  end
  if self.data and self.data.marchUuid then
    GoToUtil.JumpToMarchByUuid(self.data.marchUuid, self.data.serverId, 0)
    if self.dataFull and self.dataFull.data == self.data then
      self.dataFull.data = nil
      self:UpdateData()
    end
  elseif self.data and self.data.pointId then
    local worldPointPos = SceneUtils.TileIndexToWorld(self.data.pointId, ForceChangeScene.World, self.data.serverId)
    GoToUtil.GotoPos(worldPointPos, CS.SceneManager.World.InitZoom, 0.5, function()
      local param = {}
      param.position = CS.CSUtils.WorldPositionToUISpacePosition(worldPointPos)
      param.arrowType = ArrowType.Building
      param.positionType = PositionType.Screen
      DataCenter.ArrowManager:ShowArrow(param)
      if self.dataFull and self.dataFull.data == self.data then
        self.dataFull.data = nil
        self:UpdateData()
      end
    end, self.data.serverId, 0)
  end
end

function WorldBattleGuideBtn:SetBubbleData(dataList)
  self.dataList = dataList
  self:UpdateData()
end

function WorldBattleGuideBtn:RefreshCameraPoint()
  if self.data == nil then
    return
  end
  local curTilePos = SceneUtils.WorldToUniqueTile(CS.SceneManager.World.CurTarget)
  local targetWorldPos = SceneUtils.TileIndexToWorld(self.data.pointId, ForceChangeScene.World, self.data.serverId)
  local targetTilePos = SceneUtils.WorldToUniqueTile(targetWorldPos)
  local dist = math.floor(Vector2.Distance(curTilePos, targetTilePos))
  if 5 < dist then
    self.txt:SetText(dist .. self.disText)
  else
    self.txt:SetText("")
  end
  local curUIPos = self.transform.position
  local targetUIPos = CS.CSUtils.WorldPositionToUISpacePosition(targetWorldPos)
  local angle = math.deg(math.atan(targetUIPos.y - curUIPos.y, targetUIPos.x - curUIPos.x))
  self.arrow.transform:DORotate(Vector3.New(0, 0, angle - 90), 0)
end

function WorldBattleGuideBtn:UpdateData()
  if IsNull(self.gameObject) then
    return
  end
  local theWorld = CS.SceneManager.World
  if not (theWorld ~= nil and CS.SceneManager.IsInWorld()) or self.dataList == nil or BattleFieldUtil.InBattleField() then
    self:SetActive(false)
    return
  end
  local iconPath
  self.data = nil
  for k, v in pairs(self.dataList) do
    if v and v.meta and v.data and dirtyDict[v.data.eventKey] == nil then
      self.data = v.data
      self.dataFull = v
      iconPath = v.meta.icon
      break
    end
  end
  if self.data == nil then
    self.dataList = {}
    self:SetActive(false)
    return
  end
  self:SetActive(true)
  if not string.IsNullOrEmpty(iconPath) then
    self.icon:LoadSprite(iconPath)
  end
  self:RefreshCameraPoint()
end

return WorldBattleGuideManager
