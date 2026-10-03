local base = UIBaseContainer
local PlayerHeadContainer = BaseClass("PlayerHeadContainer", base)
local ContainerShowType = {Single = 1, Double = 2}
local Config = {
  ContainerHeight = {
    [ContainerShowType.Single] = 160,
    [ContainerShowType.Double] = 320
  },
  ContainerMaxPlayerNum = {
    [ContainerShowType.Single] = 9,
    [ContainerShowType.Double] = 20
  },
  ContainerLinePlayerNum = {
    [ContainerShowType.Single] = 4,
    [ContainerShowType.Double] = 8
  }
}
local root_path = "root"

local function OnCreate(self)
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

local function OnDestroy(self)
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

local function OnEnable(self)
  base.OnEnable(self)
end

local function OnDisable(self)
  base.OnDisable(self)
end

local function ComponentDefine(self)
  self.root = self:AddComponent(UIBaseContainer, root_path)
  self.container = self:AddComponent(UIGridLayoutGroup, root_path)
end

local function ComponentDestroy(self)
  self.root = nil
  self.container = nil
end

local function DataDefine(self)
end

local function DataDestroy(self)
end

function PlayerHeadContainer:Refresh(playerList, showType, maxPlayerNum_)
  local index, count, container = 0, 0, self.container
  playerList = playerList or {}
  showType = showType or ContainerShowType.Single
  maxPlayerNum_ = maxPlayerNum_ or Config.ContainerMaxPlayerNum[showType]
  if self.last_showType == showType and self.last_maxPlayerNum == maxPlayerNum_ and self.last_playerList == playerList then
    return
  end
  if self.headCellReqs then
    self.container:RemoveComponents(UICommonHead)
    for _, req in pairs(self.headCellReqs) do
      self:GameObjectDestroy(req)
    end
    self.headCellReqs = nil
    self.headCells = nil
  end
  self.headCellReqs = {}
  self.headCells = {}
  for k, v in ipairs(playerList) do
    if count < maxPlayerNum_ then
      self.headCellReqs[k] = self:GameObjectInstantiateAsync(UIAssets.UIPlayerHead, function(req)
        local obj = req.gameObject
        if IsNull(obj) then
          return
        end
        local trans = obj.transform
        trans:SetParent(container.transform)
        trans.localScale = Vector3.one
        trans.localPosition = Vector3.zero
        trans:Set_pivot(0.5, 0.5)
        trans:Set_sizeDelta(100, 100)
        index = index + 1
        local name = string.format("HeadCell%s", index)
        obj.name = name
        local headCell = container:AddComponent(UICommonHead, name)
        headCell:ParseHeadInfo(v)
        headCell:SetEnableClickShowInfo(true, true)
        self.headCells[index] = headCell
      end)
      count = count + 1
    end
  end
  local size, cap = 144, 80
  if count > Config.ContainerLinePlayerNum[showType] then
    if showType == ContainerShowType.Single and count >= Config.ContainerMaxPlayerNum[showType] then
      container:SetCellSize(size, size)
      local total = self:GetSizeDeltaXY()
      local min = size - (total - size) / (maxPlayerNum_ - 1)
      local value = -math.min(size - (total - size) / count, min)
      container:SetCellSpacing(value, 0)
    else
      container:SetCellSize(size, size)
      container:SetCellSpacing(-cap, 0)
    end
  else
    container:SetCellSize(size, size)
    container:SetCellSpacing(0, 0)
  end
  container:SetSizeDeltaY(Config.ContainerHeight[showType])
  self.last_playerList = playerList
  self.last_showType = showType
  self.last_maxPlayerNum = maxPlayerNum_
end

PlayerHeadContainer.OnCreate = OnCreate
PlayerHeadContainer.OnDestroy = OnDestroy
PlayerHeadContainer.OnEnable = OnEnable
PlayerHeadContainer.OnDisable = OnDisable
PlayerHeadContainer.ComponentDefine = ComponentDefine
PlayerHeadContainer.ComponentDestroy = ComponentDestroy
PlayerHeadContainer.DataDefine = DataDefine
PlayerHeadContainer.DataDestroy = DataDestroy
return PlayerHeadContainer
