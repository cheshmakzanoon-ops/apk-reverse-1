local Resource = CS.GameEntry.Resource
local Const = require("Scene.LWBattle.Const")
local doorOpChar = {
  "+",
  "-",
  "x",
  "\195\183",
  ""
}
local DoorLevelOffsetMin = 5
local XOffset = 3
local PASS_VFX = "Assets/Main/Prefabs/LWCountBattle/Doors/VfxPassDoor.prefab"
local MultipleParkourDoor = BaseClass("MultipleParkourDoor")

function MultipleParkourDoor:__init(pos, level, index, option, value, layout, resPath, levelMaxMap, mgr, mapId, totalLevel, mapIndex, last, rightOption)
  self.pos = pos
  self.level = level
  self.index = index
  self.option = option
  self.value = value
  self.layout = layout
  self.resPath = resPath
  self.levelMaxMap = levelMaxMap
  self.mgr = mgr
  self.mapId = mapId
  self.totalLevel = totalLevel
  self.mapIndex = mapIndex
  self.passed = false
  self.lastIndex = false
  self.last = last
  self.rightOption = rightOption
  self.posZ = self.pos.z
  local doorOffset = DoorLevelOffsetMin
  if self.mgr.doorTemplate then
    doorOffset = self.mgr.doorTemplate.door_space
  end
  self.doorOffset = doorOffset
end

function MultipleParkourDoor:__delete()
  if self.handle then
    self.handle:Destroy()
    self.handle = nil
  end
end

function MultipleParkourDoor:InitData()
  local levelMax = self.levelMaxMap[self.totalLevel]
  local zOff = levelMax - self.index
  self.lastIndex = zOff == 0
  local xOff = 0
  if self.layout == Const.MultipleParkourDoorLayout.Left then
    xOff = -XOffset
  elseif self.layout == Const.MultipleParkourDoorLayout.Right then
    xOff = XOffset
  end
  self.pos = Vector3.New(self.pos.x + xOff, self.pos.y, self.pos.z - zOff * self.doorOffset)
  self.posZ = self.pos.z
end

function MultipleParkourDoor:Load()
  if self.handle then
    return
  end
  self.handle = Resource:InstantiateAsync(self.resPath)
  self.handle:completed("+", function(handle)
    self.gameObject = handle.gameObject
    self.transform = self.gameObject.transform
    self.transform:Set_position(self.pos.x, self.pos.y, self.pos.z)
    self.textMesh = self.gameObject:GetComponentInChildren(typeof(CS.SuperTextMesh))
    if self.textMesh then
      self.textMesh.text = doorOpChar[self.option] .. " " .. self.value
    end
  end)
end

function MultipleParkourDoor:TryParse(teamZ, lastZ)
  if self.passed then
    return false
  end
  if teamZ < self.posZ or lastZ > self.posZ then
    return false
  end
  return true
end

function MultipleParkourDoor:OnPassed()
  self.passed = true
  if self.layout == self.mgr.mySelected then
    self.mgr:ShowEffectObj(PASS_VFX, self.pos, nil, 3)
  end
end

return MultipleParkourDoor
