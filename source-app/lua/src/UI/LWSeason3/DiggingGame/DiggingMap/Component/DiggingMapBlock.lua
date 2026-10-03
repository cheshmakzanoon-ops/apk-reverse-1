local base = UIBaseContainer
local DiggingMapBlock = BaseClass("DiggingMapBlock", base)
local icon_path = "Icon"
local effectGet_path = "Icon"

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
  if self.reqContent then
    self.reqContent:Destroy()
    self.reqContent = nil
  end
  base.OnDisable(self)
end

local function ComponentDefine(self)
  self.icon = self:AddComponent(UIRawImage, icon_path)
  self.effectGet = self:AddComponent(UIBaseContainer, effectGet_path)
end

local function ComponentDestroy(self)
  self.icon = nil
  self.effectGet = nil
end

local function DataDefine(self)
end

local function DataDestroy(self)
end

function DiggingMapBlock:ReInit(blockInfo, x, y, gridSize, scale)
  self.blockInfo = blockInfo
  self:SetAnchoredPositionXY(x, y)
  self:RefreshIcon(gridSize, scale)
end

function DiggingMapBlock:OnOpen(blockInfo)
  self.blockInfo = blockInfo
  if self.blockInfo and self.blockInfo.get then
    self:RefreshIcon()
    self:ShowGetAnim(self.blockInfo)
  end
end

function DiggingMapBlock:RefreshIcon(gridSize, scale)
  local config = self.blockInfo and DataCenter.DiggingDataTemplateManager:GetConfigDataBlock(self.blockInfo.bid)
  if not config then
    return
  end
  if gridSize then
    self:SetSizeDeltaXY(config.size_width * gridSize, config.size_height * gridSize)
  end
  if scale then
    self.icon:SetLocalScaleXYZ(scale * 0.42, scale * 0.42, 1)
  end
  self.icon:LoadSprite(self.blockInfo.get and config.appearance_shadow or config.appearance)
  self.icon:SetSizeDeltaXY(DataCenter.DiggingDataManager:GetBlockSize(config.size_width), DataCenter.DiggingDataManager:GetBlockSize(config.size_height))
end

function DiggingMapBlock:ShowGetAnim(blockInfo)
  local config = blockInfo and DataCenter.DiggingDataTemplateManager:GetConfigDataBlock(blockInfo.bid)
  if not config or string.IsNullOrEmpty(config.appearance_mat) then
    if self.treasureItem then
      self.treasureItem:SetActive(false)
    end
    return
  end
  if self.treasureItem then
    self.treasureItem:SetActive(false)
    self.treasureItem:ReInit(blockInfo)
    self.treasureItem:SetActive(true)
  else
    if self.reqContent then
      return
    end
    local path = "Assets/Main/SeasonRes/S3/Prefabs/UI/LWSeason3/SeasonActivity/DiggingGame/Component/DiggingTreasure.prefab"
    local script = require("UI.LWSeason3.DiggingGame.DiggingMap.Component.DiggingTreasure")
    self.reqContent = self:GameObjectInstantiateAsync(path, function(request)
      if request.isError then
        return
      end
      local go = request.gameObject
      go.transform:SetParent(self.effectGet.transform)
      go.transform:Set_localScale(ResetScale.x, ResetScale.y, ResetScale.z)
      go.transform:Set_localPosition(ResetPosition.x, ResetPosition.y, ResetPosition.z)
      go.transform:SetParent(self.transform.parent.parent)
      self.treasureItem = self.effectGet:AddComponent(script, go)
      self.treasureItem:ReInit(blockInfo)
      self.treasureItem:SetActive(true)
    end)
  end
end

DiggingMapBlock.OnCreate = OnCreate
DiggingMapBlock.OnDestroy = OnDestroy
DiggingMapBlock.OnEnable = OnEnable
DiggingMapBlock.OnDisable = OnDisable
DiggingMapBlock.ComponentDefine = ComponentDefine
DiggingMapBlock.ComponentDestroy = ComponentDestroy
DiggingMapBlock.DataDefine = DataDefine
DiggingMapBlock.DataDestroy = DataDestroy
return DiggingMapBlock
