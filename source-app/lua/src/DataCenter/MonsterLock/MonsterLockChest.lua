local MonsterLockChest = BaseClass("MonsterLockChest")
local ModelType = {Chest = 1, Soldier = 2}

local function __init(self)
  self.id = 0
  self.data = nil
  self.req = nil
  self.onClick = nil
end

local function __delete(self)
  self.id = nil
  self.data = nil
  self.req = nil
  self.onClick = nil
end

local function OnCreate(self, modelType)
  self.gameObject = self.req.gameObject
  self.transform = self.gameObject.transform
  self.trigger = self.gameObject:GetComponent(typeof(CS.TouchObjectEventTrigger))
  
  function self.trigger.onPointerClick()
    self:OnClick()
  end
  
  self.modelType = modelType
  if modelType == ModelType.Chest then
  elseif modelType == ModelType.Soldier then
    local anim = self.transform:Find("Model/A_soldier_jqb01_01/A_soldie@jqb_skin"):GetComponent(typeof(CS.SimpleAnimation))
    anim:Play("birth")
    anim:PlayQueued("idle")
  end
end

local function OnDestroy(self)
  self.gameObject = nil
  self.transform = nil
  if self.trigger ~= nil then
    self.trigger.onPointerClick = nil
    self.trigger = nil
  end
  if self.req ~= nil then
    self.req:Destroy()
    self.req = nil
  end
  self.modelType = nil
end

local function Init(self, id)
  self.id = id
  self.data = DataCenter.MonsterLockDataManager:GetMonsterData(id)
end

local function SetReq(self, req)
  self.req = req
end

local function SetOnClick(self, onClick)
  self.onClick = onClick
end

local function OnClick(self)
  if self.onClick then
    self.onClick()
  end
end

local function SetActive(self, active)
  self.gameObject:SetActive(active)
end

local function GetGameObject(self)
  return self.gameObject
end

MonsterLockChest.__init = __init
MonsterLockChest.__delete = __delete
MonsterLockChest.OnCreate = OnCreate
MonsterLockChest.OnDestroy = OnDestroy
MonsterLockChest.Init = Init
MonsterLockChest.SetReq = SetReq
MonsterLockChest.SetOnClick = SetOnClick
MonsterLockChest.OnClick = OnClick
MonsterLockChest.SetActive = SetActive
MonsterLockChest.GetGameObject = GetGameObject
return MonsterLockChest
