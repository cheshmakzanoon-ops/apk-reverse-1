local CityZombieMgr = BaseClass("CityZombieMgr")
local ZombieArea = require("Scene.CityZombie.ZombieArea")

function CityZombieMgr:__init()
  self.zombiAreaDict = {}
  self:AddListener()
  self:AddUpdateTimer()
end

function CityZombieMgr:__delete()
  self:RemoveUpdateTimer()
  self:RemoveListener()
  self:Destroy()
end

function CityZombieMgr:Destroy()
  for _, v in pairs(self.zombiAreaDict) do
    v:Destroy()
  end
  self.zombiAreaDict = {}
end

function CityZombieMgr:Startup()
end

function CityZombieMgr:AddListener()
  if self.onLoadZombieArea == nil then
    function self.onLoadZombieArea(area_id)
      self:OnLoadZombieArea(area_id)
    end
  end
  if self.onUnloadZombieArea == nil then
    function self.onUnloadZombieArea(area_id)
      self:OnUnloadZombieArea(area_id)
    end
  end
end

function CityZombieMgr:RemoveListener()
  if self.onLoadZombieArea ~= nil then
    self.onLoadZombieArea = nil
  end
  if self.onUnloadZombieArea ~= nil then
    self.onUnloadZombieArea = nil
  end
end

function CityZombieMgr:OnLoadZombieArea(area_id)
  if self.zombiAreaDict[area_id] == nil then
    self.zombiAreaDict[area_id] = ZombieArea.New(area_id)
  else
    self.zombiAreaDict[area_id]:Load()
  end
end

function CityZombieMgr:OnUnloadZombieArea(area_id)
  if self.zombiAreaDict[area_id] then
    self.zombiAreaDict[area_id]:Unload()
  end
end

function CityZombieMgr:AddUpdateTimer()
  if self.updateTimer == nil then
    function self.updateTimer()
      self:OnUpdate()
    end
    
    UpdateManager:GetInstance():AddUpdate(self.updateTimer)
  end
  if self.updateSecTimer == nil then
    self.updateSecTimer = TimerManager:GetInstance():GetTimer(1, self.OnUpdateSec, self, false, false, false)
    self.updateSecTimer:Start()
  end
end

function CityZombieMgr:RemoveUpdateTimer()
  if self.updateTimer then
    UpdateManager:GetInstance():RemoveUpdate(self.updateTimer)
    self.updateTimer = nil
  end
  if self.updateSecTimer then
    self.updateSecTimer:Stop()
    self.updateSecTimer = nil
  end
end

function CityZombieMgr:OnUpdate()
end

function CityZombieMgr:OnUpdateSec()
end

return CityZombieMgr
