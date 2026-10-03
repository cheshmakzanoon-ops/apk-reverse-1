local PveDropBuff = BaseClass("PveDropBuff")
local EnterBubbleDistance = 1.5

function PveDropBuff:OnCreate(go)
  if go ~= nil then
    self.request = go
    self.gameObject = go.gameObject
    self.transform = go.gameObject.transform
  end
  self:ComponentDefine()
  self:DataDefine()
end

function PveDropBuff:OnDestroy()
  self:ComponentDestroy()
  self:DataDestroy()
end

function PveDropBuff:ComponentDefine()
  self.anim = self.transform:GetComponentInChildren(typeof(CS.SimpleAnimation), true)
end

function PveDropBuff:ComponentDestroy()
  self.anim = nil
  self.gameObject = nil
  self.transform = nil
end

function PveDropBuff:DataDefine()
  self.param = nil
end

function PveDropBuff:DataDestroy()
  self.param = nil
end

function PveDropBuff:ReInit(param)
  self.param = param
  self.transform.position = self.param.position
end

function PveDropBuff:OnPlayerMoveSignal(pos)
  local distance = Vector3.Distance(pos, self.param.position)
  if distance <= EnterBubbleDistance then
    DataCenter.BattleLevel:AddBuffById(self.param.buffId)
    DataCenter.BattleLevel:RemoveOneDropBuff(self.param.id)
  end
end

return PveDropBuff
