local base = UIBaseContainer
local DiggingMapBrick = BaseClass("DiggingMapBrick", base)
local icon_path = "Icon"
local btn_path = "Icon"
local mask_path = "Mask"
local effectOpen_path = "effectOpen"
local effectHammer_path = "effectHammer"
local __IconList = {
  "ljq_saijis3_yindiannaqiongsi_zhuankuai_01",
  "ljq_saijis3_yindiannaqiongsi_zhuankuai_02",
  "ljq_saijis3_yindiannaqiongsi_zhuankuai_03",
  "ljq_saijis3_yindiannaqiongsi_zhuankuai_04"
}

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
  if self.effectOpen and self.effectOpen.transform.parent ~= self.transform then
    self.effectOpen.transform:SetParent(self.transform)
  end
  base.OnDisable(self)
end

local function ComponentDefine(self)
  self.icon = self:AddComponent(UIImage, icon_path)
  self.btn = self:AddComponent(UIButton, btn_path)
  self.mask = self:AddComponent(UIBaseContainer, mask_path)
  self.btn:SetOnClick(BindCallback(self, self.OnClick))
end

local function ComponentDestroy(self)
  self.icon = nil
  self.btn = nil
  self.mask = nil
end

local function DataDefine(self)
  self.callback = nil
end

local function DataDestroy(self)
end

function DiggingMapBrick:ReInit(index, mapData, brickDic, scale)
  self.index = index
  self.data = mapData
  self.isOpen = brickDic ~= nil
  self.scale = scale or 1
  self:SetLock(false)
  if self.isOpen then
    self.icon:SetActive(false)
    self.mask:SetActive(false)
    return
  end
  self:OnClose()
end

function DiggingMapBrick:SetOnClick(target, callback)
  self.callback = BindCallback(target, callback)
end

function DiggingMapBrick:SetLock(isLock)
  self.isLock = isLock
  self.icon:SetRaycastTarget(not isLock)
end

function DiggingMapBrick:OnOpen()
  if self.isOpen then
    return
  end
  self.isOpen = true
  self:PlayOpenEffect()
end

function DiggingMapBrick:PlayOpenEffect()
  self.icon:SetActive(false)
  self.mask:SetActive(false)
  if self.scale then
    if not self.effectOpen then
      self.effectOpen = self:AddComponent(UIVfx, effectOpen_path, VfxAssets.DigTreasureBrickOpen)
    end
    if self.effectOpen.transform.parent ~= self.transform.parent then
      self.effectOpen.transform:SetParent(self.transform.parent)
    end
    self.effectOpen:SetLocalScaleXYZ(self.scale * 0.7, self.scale * 0.7, 1)
  end
  self.effectOpen:Replay()
  self.isOpen = true
end

function DiggingMapBrick:OnClose()
  self.isOpen = false
  self.icon:SetActive(true)
  self.mask:SetActive(true)
  self.icon:SetLocalPositionXYZ(0, 0, 0)
end

function DiggingMapBrick:OnClick(notCheck)
  if not (not self.isLock and self.data) or self.brickInfo then
    return
  end
  if self.callback and not notCheck then
    self.callback(self.index, self.transform.position)
    return
  end
  if not DataCenter.DigTreasureManager:OpenBrick(self.data.uuid, self.index) then
    self:Shake()
  else
    self:PlayOpenEffect()
  end
end

function DiggingMapBrick:Shake()
  local trans = self.icon.transform
  local sequence = DOTween.Sequence()
  local duration = 0.08
  local scale = 5
  for i = 1, 3 do
    sequence:Append(trans:DOLocalMoveX(scale, duration))
    sequence:Append(trans:DOLocalMoveX(-scale, duration))
    scale = scale - 0.9
    duration = duration - 0.01
  end
  sequence:Append(trans:DOLocalMoveX(0, duration))
end

DiggingMapBrick.OnCreate = OnCreate
DiggingMapBrick.OnDestroy = OnDestroy
DiggingMapBrick.OnEnable = OnEnable
DiggingMapBrick.OnDisable = OnDisable
DiggingMapBrick.ComponentDefine = ComponentDefine
DiggingMapBrick.ComponentDestroy = ComponentDestroy
DiggingMapBrick.DataDefine = DataDefine
DiggingMapBrick.DataDestroy = DataDestroy
return DiggingMapBrick
