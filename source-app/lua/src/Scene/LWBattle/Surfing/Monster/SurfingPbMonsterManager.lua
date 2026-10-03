local base = require("Scene.LWBattle.Surfing.Monster.SurfingMonsterManager")
local SurfingPbMonsterManager = BaseClass("SurfingPbMonsterManager", base)
local MonsterBornType = base.MonsterBornType

function SurfingPbMonsterManager:Init(logic)
  base.Init(self, logic)
end

function SurfingPbMonsterManager:Destroy()
  base.Destroy(self)
end

function SurfingPbMonsterManager:CreateFarmMonster(bornMeta)
  local monster
  local type = bornMeta.born.type
  if type <= MonsterBornType.None then
    return
  end
  local mId = bornMeta.born:GetOriMonsterId()
  local param
  local flag = 0
  if type == MonsterBornType.Box or type == MonsterBornType.Buff or type == MonsterBornType.Ally or type == MonsterBornType.RandomBuff then
    flag = self.logic.data:GetNextMonsterId() or 0
  end
  if mId == nil or mId == 0 then
    mId = self.logic:GetSwitchMonsterId()
  else
    local monsterMeta = DataCenter.SurfingMonsterTemplateManager:GetTemplate(mId)
    if monsterMeta == nil then
      return
    end
    if type == MonsterBornType.Box then
      if flag == 0 then
        mId = self.logic:GetSwitchMonsterId()
      end
    elseif type == MonsterBornType.Buff then
      if flag == 0 then
        mId = self.logic:GetSwitchMonsterId()
      end
    elseif type == MonsterBornType.Ally then
      if 0 < flag then
        local bMId = monsterMeta:GetBuff(flag)
        if bMId and 0 < bMId then
          local bMonsterMeta = DataCenter.SurfingMonsterTemplateManager:GetTemplate(bMId)
          if bMonsterMeta then
            param = {monsterId = bMId}
          end
        end
      else
        mId = self.logic:GetSwitchMonsterId()
      end
    elseif type == MonsterBornType.RandomBuff then
      if 0 < flag then
        local bMId = monsterMeta:GetBuff(flag)
        if bMId and 0 < bMId then
          mId = bMId
        end
      else
        mId = self.logic:GetSwitchMonsterId()
      end
    end
  end
  if 0 < mId then
    if param == nil then
      param = {}
    end
    param.triggerLine = bornMeta.triggerLine
    param.triggerLineOffset = bornMeta.triggerLineOffset
    param.stageSceneIndex = bornMeta.stageSceneIndex
    monster = self:CreateMonster(bornMeta.x, bornMeta.y, bornMeta.z, mId, bornMeta.born.id, param)
  end
  return monster
end

return SurfingPbMonsterManager
