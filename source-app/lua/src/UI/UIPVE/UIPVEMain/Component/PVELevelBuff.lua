local PVELevelBuff = BaseClass("PVELevelBuff", UIBaseContainer)
local base = UIBaseContainer
local UIPveBuffCell = require("UI.UIPVE.UIPVEMain.Component.UIPveBuffCell")

local function OnCreate(self)
  base.OnCreate(self)
  self:DataDefine()
  self:ComponentDefine()
  self:ReInit()
end

local function OnDestroy(self)
  self:ComponentDestroy()
  self:DataDestroy()
  base.OnDestroy(self)
end

local function ComponentDefine(self)
end

local function ComponentDestroy(self)
end

local function DataDefine(self)
  self.buff = {}
end

local function DataDestroy(self)
  self.buff = nil
end

local function OnEnable(self)
  base.OnEnable(self)
end

local function OnDisable(self)
  base.OnDisable(self)
end

local function OnAddListener(self)
  base.OnAddListener(self)
end

local function OnRemoveListener(self)
  base.OnRemoveListener(self)
end

local function ReInit(self)
  local list = DataCenter.BattleLevel:GetAllBuff()
  for k, v in ipairs(list) do
    if v.time_type == PveBuffTimeType.Time then
      self:AddOneBuff(v.id)
    end
  end
end

local function AddOneBuff(self, id)
  local buffData = DataCenter.BattleLevel:GetBuffById(id)
  if buffData ~= nil then
    if self.buff[id] == nil then
      local param = {}
      param.endTime = buffData.endTime
      param.id = id
      self.buff[id] = {}
      self.buff[id].param = param
      self.buff[id].req = self:GameObjectInstantiateAsync(UIAssets.UIPveBuffCell, function(request)
        if request.isError then
          return
        end
        local go = request.gameObject
        go:SetActive(true)
        go.transform:SetParent(self.transform)
        go.transform:Set_localScale(ResetScale.x, ResetScale.y, ResetScale.z)
        local nameStr = tostring(NameCount)
        go.name = nameStr
        NameCount = NameCount + 1
        self.buff[id].model = self:AddComponent(UIPveBuffCell, nameStr)
        self.buff[id].model:ReInit(self.buff[id].param)
      end)
    elseif self.buff[id].model ~= nil then
      self.buff[id].model:ChangeTime(buffData.endTime)
    else
      self.buff[id].param.endTime = buffData.endTime
    end
  end
end

local function RemoveOneBuff(self, id)
  if self.buff[id] ~= nil and self.buff[id].req ~= nil then
    self.buff[id].req:Destroy()
    self.buff[id] = nil
  end
end

local function Update(self)
  local curTime = UITimeManager:GetInstance():GetServerTime()
  for k, v in pairs(self.buff) do
    if v.model ~= nil then
      v.model:RefreshNum(curTime)
    end
  end
end

PVELevelBuff.OnCreate = OnCreate
PVELevelBuff.OnDestroy = OnDestroy
PVELevelBuff.ComponentDefine = ComponentDefine
PVELevelBuff.ComponentDestroy = ComponentDestroy
PVELevelBuff.DataDefine = DataDefine
PVELevelBuff.DataDestroy = DataDestroy
PVELevelBuff.OnEnable = OnEnable
PVELevelBuff.OnDisable = OnDisable
PVELevelBuff.OnAddListener = OnAddListener
PVELevelBuff.OnRemoveListener = OnRemoveListener
PVELevelBuff.Update = Update
PVELevelBuff.AddOneBuff = AddOneBuff
PVELevelBuff.RemoveOneBuff = RemoveOneBuff
PVELevelBuff.ReInit = ReInit
return PVELevelBuff
