local ZombieArea = BaseClass("ZombieArea")
local GameObject = CS.UnityEngine.GameObject
local CityZombie = require("Scene.CityZombie.CityZombie")

function ZombieArea:__init(area_id)
  self.gameObject = nil
  self.transform = nil
  self.areaId = area_id
  self.isShow = false
  self.zombieList = {}
  self:Create()
end

function ZombieArea:Destroy()
  for _, v in ipairs(self.zombieList) do
    v:Destroy()
  end
  self.zombieList = {}
  self.transform = nil
  self.gameObject = nil
  self.areaId = nil
  self.isShow = false
end

function ZombieArea:NewArea(go_area)
  self.gameObject = go_area
  self.transform = go_area.transform
  self.boxCollider = self.transform:Find("Cube"):GetComponent(typeof(CS.UnityEngine.BoxCollider))
end

function ZombieArea:Create()
  local goArea = GameObject.Find("City/Static/ZombieArea" .. self.areaId)
  if not IsNull(goArea) then
    self:NewArea(goArea)
    local param = {}
    param.id = 1
    param.parent = self.transform
    table.insert(self.zombieList, CityZombie.New(param))
  end
  self.isShow = true
end

function ZombieArea:Load()
  local goArea = GameObject.Find("City/Static/ZombieArea" .. self.areaId)
  local goChildCount = goArea.transform.childCount
  if not IsNull(goArea) and goChildCount <= 1 then
    self:NewArea(goArea)
    for i, v in ipairs(self.zombieList) do
      local param = {}
      param.id = i
      param.parent = self.transform
      v:Reload(param)
    end
  end
  self.isShow = true
end

function ZombieArea:Unload()
  self.isShow = false
end

function ZombieArea:OnUpdate()
  if not self.isShow then
    return
  end
  for _, zombie in ipairs(self.zombieList) do
    zombie:OnUpdate()
  end
end

function ZombieArea:OnUpdateSec()
  if not self.isShow then
    return
  end
  for _, zombie in ipairs(self.zombieList) do
    zombie:OnUpdateSec()
  end
end

return ZombieArea
