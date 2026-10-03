local base = require("Scene.LWBattle.Buff.BuffBase")
local BuffAbsorbItem = BaseClass("BuffAbsorbItem", base)

function BuffAbsorbItem:__init(logic, mgr, unit, meta, id, param)
  self.logic = logic
  self.mgr = mgr
  self.unit = unit
  self.meta = meta
  self.id = id
  self.target = param
end

function BuffAbsorbItem:__delete()
  self:Destroy()
end

function BuffAbsorbItem:Destroy()
  base.Destroy(self)
  self.target = nil
end

function BuffAbsorbItem:OnUpdate()
  local showList = DataCenter.LWBattleManager.logic.monsterMgr:GetMonsters()
  if showList then
    for k, monster in pairs(showList) do
      if monster and monster.gameObject and monster.triggerMeta then
        local posX1, posY1, posZ1 = self.unit.gameObject.transform:Get_position()
        local posX2, posY2, posZ2 = monster.gameObject.transform:Get_position()
        local p_x = math.abs(posX1 - posX2)
        local p_z = math.abs(posZ1 - posZ2)
        local dis = p_x + p_z
        if dis < 5 then
          local pos = Vector2.Lerp(Vector2.New(posX2, posZ2), Vector2.New(posX1, posZ1), (1 - dis / 5) * Time.deltaTime * 20)
          monster.gameObject.transform:Set_position(pos.x, posY2, pos.y)
        end
      end
    end
  end
end

function BuffAbsorbItem:OnStart()
end

function BuffAbsorbItem:OnEnd()
end

return BuffAbsorbItem
