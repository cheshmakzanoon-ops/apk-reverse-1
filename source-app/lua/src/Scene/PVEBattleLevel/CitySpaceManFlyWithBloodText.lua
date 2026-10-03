local CitySpaceManFlyWithBloodText = BaseClass("CitySpaceManFlyWithBloodText")
local Const = require("Scene.PVEBattleLevel.Const")
local ModelPath = "Assets/_Art/Effect/prefab/ui/Common/FlyPveResText.prefab"
local MinRange = -20
local MaxRange = 20
local IconWidth = 40
local IconHeight = 40

function CitySpaceManFlyWithBloodText:__init(param)
  self.param = param
  
  function self.fly_callback()
    self:FlyCallback()
  end
  
  self:ReInit()
end

function CitySpaceManFlyWithBloodText:Destroy()
end

function CitySpaceManFlyWithBloodText:ReInit()
  local des = "+" .. self.param.num
  local icon = Const.ResTypeIconPath[self.param.resType] or Const.ResTypeIconPath[Const.CityCutResType.Stone]
  local srcPos
  if self.param.pos then
    srcPos = DataCenter.BattleLevel:WorldToScreenPoint(self.param.pos + Vector3.New(0, 2, 0))
  else
    srcPos = DataCenter.BattleLevel:WorldToScreenPoint(DataCenter.BattleLevel:GetPosition() + Vector3.New(0, 2, 0))
  end
  local node = DataCenter.BattleLevel:GetFlyNode(self.param.resType)
  if node ~= nil then
    local destPos = node.transform.position
    UIUtil.DoFlyCustom(icon, des, 1, srcPos, destPos, IconWidth, IconHeight, self.fly_callback, ModelPath, MinRange, MaxRange)
  end
end

function CitySpaceManFlyWithBloodText:FlyCallback()
  DataCenter.BattleLevel:RemoveOneFlyRes(self.param.id)
end

function CitySpaceManFlyWithBloodText:OnUpdate(curTime)
end

return CitySpaceManFlyWithBloodText
