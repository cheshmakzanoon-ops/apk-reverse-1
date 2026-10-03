local EnergyBarCell = BaseClass("EnergyBarCell", UIBaseContainer)
local base = UIBaseContainer
local Resource = CS.GameEntry.Resource
local UnityRectTransform = typeof(CS.UnityEngine.RectTransform)
local Const = require("Scene.LWBattle.Const")
local ControlPointOffset = Vector3.New(-100, 100, 0)
local SEGMENT_COUNT = 20
local MinRange = -10.0
local MaxRange = 10.0
local path = "Assets/Main/Prefabs/LWBattle/EnergyBar.prefab"
local effectPath = "Assets/_Art_LastWar/Effect/Prefab/UI/Power_add/Eff_ui_power_trail.prefab"
local content_path = "Content"
local bg_path = "Content/bg"
local fg1_path = "Content/fg1"
local fg2_path = "Content/fg2"
local fg3_path = "Content/fg3"

function EnergyBarCell:__init()
  self.energy = 0
end

function EnergyBarCell:__delete()
  self:OnDestroy()
  if self.req then
    self.req:Destroy()
    self.req = nil
  end
  self:ClearEffect()
  self.target = nil
end

function EnergyBarCell:ClearEffect()
  if self.tween then
    self.tween:Kill()
    self.tween = nil
  end
  if self.request then
    self.request:Destroy()
    self.request = nil
  end
  if self.delay then
    self.delay:Stop()
    self.delay = nil
  end
  if self.delay2 then
    self.delay2:Stop()
    self.delay2 = nil
  end
end

function EnergyBarCell:Load(owner, transform, height)
  self.owner = owner
  self.target = transform
  self.height = height
  self.camera = CS.UnityEngine.Camera.main
  self.myWorldPos = Vector3.zero
  self.req = Resource:InstantiateAsync(path)
  self.req:completed("+", function(req)
    local go = req.gameObject
    local CanvasNormal = UIManager:GetInstance():GetLayer(UILayer.Scene.Name).gameObject
    go.transform:SetParent(CanvasNormal.transform)
    self.gameObject = go
    self.transform = go.transform
    self.transform:Set_localScale(ResetScale.x, ResetScale.y, ResetScale.z)
    self.transformValid = true
    self.__var_arg = self.gameObject
    self:OnCreate()
  end)
end

function EnergyBarCell:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
end

function EnergyBarCell:OnDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function EnergyBarCell:ComponentDefine()
  self.content = self:AddComponent(UIBaseContainer, content_path)
  self.bg = self:AddComponent(UIImage, bg_path)
  self.fg1 = self:AddComponent(UIImage, fg1_path)
  self.fg2 = self:AddComponent(UIImage, fg2_path)
  self.fg3 = self:AddComponent(UIImage, fg3_path)
  self.energyList = {}
  table.insert(self.energyList, self.fg1)
  table.insert(self.energyList, self.fg2)
  table.insert(self.energyList, self.fg3)
  self.energyCount = 3
  self:SetEnergy(self.energy)
end

function EnergyBarCell:SetEnergy(count, fromPos)
  if not self.transformValid then
    self.energy = count
    return
  end
  if fromPos then
    local startPos = PosConverse.WorldToScreenPos(fromPos, CS.UnityEngine.Camera.main)
    local uiPos = PosConverse.ScreenToUIPos(self.rectTransform, startPos)
    local endPos = Vector3.New(-50, 0, 0)
    self:FlyEffect(Vector3.New(uiPos.x, uiPos.y, 0), endPos, count)
  else
    for i = 1, self.energyCount do
      self.energyList[i]:SetActive(count >= i)
    end
  end
end

function EnergyBarCell:Update()
  if self.transformValid then
    self:UpdatePos()
  end
end

function EnergyBarCell:UpdatePos()
  if self.target == nil then
    return
  end
  self.myWorldPos.x, self.myWorldPos.y, self.myWorldPos.z = self.target:Get_position()
  self.myWorldPos.y = self.myWorldPos.y + self.height
  self.transform.position = CS.CSUtils.WorldPositionToUISpacePosition(self.myWorldPos)
end

function EnergyBarCell:ComponentDestroy()
  self.content = nil
  self.bg = nil
  self.fg1 = nil
  self.fg2 = nil
  self.fg3 = nil
  self.gameObject = nil
  self.transform = nil
  self.transformValid = true
end

local function CalculateCubicBezierPointFor2C(t, p0, p1, p2)
  local u = 1 - t
  local tt = t * t
  local uu = u * u
  local p = uu * p0
  p = p + 2 * u * t * p1
  p = p + tt * p2
  return p
end

function EnergyBarCell:FlyEffect(from, to, count)
  self:ClearEffect()
  local request = Resource:InstantiateAsync(effectPath)
  self.request = request
  request:completed("+", function()
    if request.isError then
      return
    end
    local tf = request.gameObject.transform
    tf:Set_localScale(ResetScale.x, ResetScale.y, ResetScale.z)
    tf:SetParent(self.transform)
    tf:Set_localPosition(from.x, from.y, from.z)
    local controlPos = (from + to) * 0.5 + ControlPointOffset + Vector3.New(math.random(MinRange, MaxRange), math.random(MinRange, MaxRange), 0)
    if self.paths == nil then
      self.paths = CS.System.Array.CreateInstance(typeof(CS.UnityEngine.Vector3), SEGMENT_COUNT)
    end
    for i = 1, SEGMENT_COUNT do
      local t = i / SEGMENT_COUNT
      local pixel = CalculateCubicBezierPointFor2C(t, from, controlPos, to)
      self.paths[i - 1] = pixel
    end
    self.tween = tf:DOLocalPath(self.paths, 1):SetEase(CS.DG.Tweening.Ease.InCubic)
    
    function self.tween.onComplete()
      self.tween = nil
    end
    
    self.delay = TimerManager:GetInstance():DelayInvoke(function()
      self.delay = nil
      if self.tween then
        self.tween:Kill()
        self.tween = nil
      end
      if self.request then
        self.request:Destroy()
        self.request = nil
      end
      if self.owner and self.owner.ShowEnergyEffect then
        self.owner:ShowEnergyEffect()
      end
    end, 1)
    self.delay2 = TimerManager:GetInstance():DelayInvoke(function()
      self:SetEnergy(count)
    end, 1.5)
  end)
end

return EnergyBarCell
