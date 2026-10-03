local base = require("Scene.Monopoly.Base.BaseObstacle")
local BattleObstacleBase = BaseClass("BattleObstacleBase", base)
local Const = require("Scene.Monopoly.Const")
local Resource = CS.GameEntry.Resource

function BattleObstacleBase:__delete()
  if self.obstacleRes then
    self.obstacleRes:Destroy()
    self.obstacleRes = nil
  end
  if self.placeality then
    self.placeality:Delete()
    self.placeality = nil
  end
  if self.battleRes then
    self.battleRes:Destroy()
    self.battleRes = nil
  end
  if self.delay then
    self.delay:Stop()
    self.delay = nil
  end
end

function BattleObstacleBase:ShowObstacleCallBack()
  base.ShowObstacleCallBack(self)
end

function BattleObstacleBase:EventEnd()
end

function BattleObstacleBase:OnEventEnd()
  if self.obstacleRes == nil then
    self:CreatedModel(function()
      self:OnModelCreate()
    end)
    return
  end
  self:OnModelCreate()
end

function BattleObstacleBase:OnModelCreate()
  if self.data.soundId and self.data.soundId > 0 then
    DataCenter.LWSoundManager:PlaySound(self.data.soundId, false)
  end
  self:PlayAnim(Const.animNames.dead)
  if self.battleEffectRes then
    self.battleEffectRes:Destroy()
  end
  if self.tileEffectRes then
    self.tileEffectRes:Destroy()
  end
  if not IsNull(self.modelTrigger) then
    self.modelTrigger.onPointerClick = nil
    self.modelTrigger = nil
  end
  if self.placeality then
    self.placeality:ClearTrigger()
  end
  if self.simpleAnim then
    local timer = self.simpleAnim:GetClipLength(Const.animNames.dead)
    self.delay = TimerManager:GetInstance():DelayInvoke(function()
      self:LoadBattleRes()
    end, timer)
  else
    self:LoadBattleRes()
  end
end

function BattleObstacleBase:LoadBattleRes()
  self.battleRes = Resource:InstantiateAsync(Const.battleDeadEffectPath)
  self.battleRes:completed("+", function(req)
    if not req then
      return
    end
    if self.obstacleRes then
      self.obstacleRes:Destroy()
      self.obstacleRes = nil
    end
    if self.data and self.data.state == MonopolyPlacealityType.Leave then
      self.battleRes:Destroy()
      self.battleRes = nil
      return
    end
    self:Morph()
    self.placeality:ShowMoveEffect()
    if self.transform == nil then
      return
    end
    req.gameObject.transform:Set_position(self.transform.position.x, self.transform.position.y + 1, self.transform.position.z)
    if self.data then
      local pos = self.data:GetCenterWorldPos()
      req.gameObject.transform:Set_position(pos.x, pos.y + 1, pos.z)
      local curId = DataCenter.MonopolyManager.player and DataCenter.MonopolyManager.player.curId or 0
      local selfId = self.data.id
      if selfId == curId then
        if self.data.plot_after ~= nil and not string.IsNullOrEmpty(self.data.plot_after) then
          EventManager:GetInstance():Broadcast(EventId.PlayPlotGroup, {
            plotGroupId = tonumber(self.data.plot_after),
            hideMainUI = true
          })
        else
          DataCenter.MonopolyManager:PlayerGo()
        end
      elseif curId > selfId then
        self:ChangeState(MonopolyPlacealityType.Occupy)
      end
    end
  end)
end

function BattleObstacleBase:Fire()
end

function BattleObstacleBase:Occupy()
  base.Occupy(self)
  if self.battleRes then
    self.battleRes:Destroy()
    self.battleRes = nil
  end
end

return BattleObstacleBase
