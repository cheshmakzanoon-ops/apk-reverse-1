local base = require("Scene.LWBattle.Surfing.Monster.MonsterImpl.SurfingObj")
local SurfingBoxObj = BaseClass("SurfingBoxObj", base)

function SurfingBoxObj:Init(logic, mgr, x, y, z, monsterMeta, bornId, param, oriId)
  base.Init(self, logic, mgr, x, y, z, monsterMeta, bornId, param, oriId)
  self._showStaticEffect = true
end

function SurfingBoxObj:ShowStaticEffect()
  if self.logic.ignoreSpectacularEffect then
    return
  end
  if IsNotNull(self.transform) then
    local pos = self.logic.staticEffectCommonPos
    if self.effectParent == nil then
      pos.x = self.curWorldPos.x
      pos.y = self.curWorldPos.y
      pos.z = self.curWorldPos.z
    else
      pos.x = 0
      pos.y = 0
      pos.z = 0
    end
    self.staticEffectId = self.logic:ShowEffectObj("Assets/Main/Prefabs/LWBattle/Surfing/Effect/Eff_s_s4_running_shine.prefab", pos, nil, -1, self.effectParent)
  end
end

function SurfingBoxObj:OnCollide(target)
  DataCenter.LWSoundManager:PlaySound(SoundAssetId.SFX_Battle_Surfing_Item, false)
  local para = {}
  local param1 = self.monsterMeta.para1
  if param1 and 0 < #param1 then
    local goodsId = tonumber(param1[1]) or 0
    para.goodsId = goodsId
    local goodsCount = tonumber(param1[2])
    para.goodsCount = goodsCount
    EventManager:GetInstance():Broadcast(EventId.OnPVEBattleGetGoods, para)
    DataCenter.LWBattleManager:GetCurBattleLogic():RecordGoods(SurfingGoodsType.Box, goodsId, goodsCount)
    target:ShowUnitEffect(SurfingUnitEffectType.GotProps)
    if self.logic then
      self.logic:UpdateRemainBox()
    end
  end
  base.OnCollide(self, target)
end

return SurfingBoxObj
