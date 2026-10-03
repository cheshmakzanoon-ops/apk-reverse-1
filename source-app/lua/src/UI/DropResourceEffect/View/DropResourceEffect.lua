local DropResourceEffect = BaseClass("DropResourceEffect")
local icon_path = "icon"

local function OnCreate(self, go)
  if go ~= nil then
    self.request = go
    self.gameObject = go.gameObject
    self.transform = go.gameObject.transform
  end
  self:ComponentDefine()
  self:DataDefine()
end

local function OnDestroy(self)
  self:ComponentDestroy()
  self:DataDestroy()
end

local function ComponentDefine(self)
  self.icon_img = self.transform:Find(icon_path):GetComponent(typeof(CS.UnityEngine.UI.Image))
  self.animator = self.transform:Find(icon_path):GetComponent(typeof(CS.UnityEngine.Animator))
end

local function ComponentDestroy(self)
  self.icon_img = nil
  self.animator = nil
end

local function DataDefine(self)
  self.param = nil
  
  function self.__update_handle()
    self:Update()
  end
  
  UpdateManager:GetInstance():AddUpdate(self.__update_handle)
  self.isDoAnim = false
  self.curTime = 0
end

local function DataDestroy(self)
  self.param = nil
  UpdateManager:GetInstance():RemoveUpdate(self.__update_handle)
  self.__update_handle = nil
  self.isDoAnim = nil
  self.curTime = nil
end

local function ReInit(self, param)
  self.param = param
  self:ShowPanel()
end

local function ShowPanel(self)
  self.icon_img:LoadSprite(self.param.icon)
  self.gameObject.transform.position = self.param.pos
  self.curTime = 0
  self.endTime = self.animator:GetFloat("DuringTime")
  self.animator:Play("farm_item_drop_play", 0, 0)
  self.isDoAnim = true
end

local function Update(self)
  if self.isDoAnim then
    self.curTime = self.curTime + Time.deltaTime
    if self.curTime > self.endTime then
      self.isDoAnim = nil
      DataCenter.DropResourceEffectManager:RemoveOneEffect(self.param)
    end
  end
end

DropResourceEffect.OnCreate = OnCreate
DropResourceEffect.OnDestroy = OnDestroy
DropResourceEffect.ComponentDefine = ComponentDefine
DropResourceEffect.ComponentDestroy = ComponentDestroy
DropResourceEffect.DataDefine = DataDefine
DropResourceEffect.DataDestroy = DataDestroy
DropResourceEffect.ReInit = ReInit
DropResourceEffect.ShowPanel = ShowPanel
DropResourceEffect.Update = Update
return DropResourceEffect
