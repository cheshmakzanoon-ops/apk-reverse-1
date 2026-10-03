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
  self.bShow = true
end

local function OnDisable(self)
  if self.reqContent then
    self.reqContent:Destroy()
    self.reqContent = nil
  end
  self.bShow = false
  base.OnDisable(self)
end

local function ComponentDefine(self)
  self.icon = self:AddComponent(UIImage, icon_path)
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
  if self.blockInfo then
    self.config = DataCenter.DiggingDataTemplateManager:GetConfigDataBlock(self.blockInfo.bid)
  end
  self:SetAnchoredPositionXY(x, y)
  self:RefreshIcon(gridSize, scale)
end

function DiggingMapBlock:OnOpen(blockInfo)
  self.blockInfo = blockInfo
  if self.blockInfo and self.blockInfo.get then
    if not self:IsRewardBlock() then
      self:RefreshIcon()
    else
      TimerManager:GetInstance():DelayInvoke(function()
        self:RefreshIcon()
      end, 1)
    end
    self:ShowGetAnim(self.blockInfo)
  end
end

function DiggingMapBlock:RefreshIcon(gridSize, scale)
  if not self.config or not self.icon then
    return
  end
  if gridSize then
    self:SetSizeDeltaXY(self.config.size_width * gridSize, self.config.size_height * gridSize)
  end
  if scale then
    if self:IsRewardBlock() then
      self.icon:SetLocalScaleXYZ(scale * 0.35, scale * 0.35, 1)
    else
      self.icon:SetLocalScaleXYZ(scale * 0.53, scale * 0.53, 1)
    end
  end
  if self.blockInfo.get then
    self.icon:SetActive(false)
  else
    if self:IsRewardBlock() and self.blockInfo.rewardInfo and #self.blockInfo.rewardInfo ~= 0 then
      local sPicPath = DataCenter.RewardManager:GetPicByType(self.blockInfo.rewardInfo[1].type, self.blockInfo.rewardInfo[1].value.id)
      self.icon:LoadSprite(sPicPath)
    else
      self.icon:LoadSprite(self.config.appearance)
    end
    self.icon:SetNativeSize()
    self.icon:SetActive(true)
  end
end

function DiggingMapBlock:ShowGetAnim(blockInfo)
  if self.config.type == DigTreasureBlockType.Reward then
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
    local path = "Assets/Main/Prefabs/UI/DigTreasure/DiggingTreasure.prefab"
    local script = require("UI.DigTreasure.Component.DiggingMap.DigTreasureObj")
    self.reqContent = self:GameObjectInstantiateAsync(path, function(request)
      if request.isError then
        return
      end
      if IsNull(self.gameObject) or not self.bShow then
        if self.reqContent then
          self.reqContent:Destroy()
          self.reqContent = nil
        end
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

function DiggingMapBlock:HideIcon(nDelayTime)
  if not nDelayTime then
    self.icon:SetActive(false)
  else
    TimerManager:GetInstance():DelayInvoke(function()
      if self.icon and self:IsRewardBlock() then
        self.icon:SetActive(false)
      end
    end, nDelayTime)
  end
end

function DiggingMapBlock:IsRewardBlock()
  if not self.config then
    return false
  end
  return self.config.type and self.config.type == DigTreasureBlockType.Reward
end

function DiggingMapBlock:GetIconTrans()
  return self.icon.transform
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
