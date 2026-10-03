local AirDropGarbage = BaseClass("AirDropGarbage")
local EffectShowDeltaTime = 0
local CloseDeltaTime = 2
local anim_path = "XS_kongtou_jls/XS_kongtou@jls_skin"
local effect_path = "EffectGo"
local AnimName = {
  "fall1",
  "fall2",
  "fall3",
  "fall4",
  "fall5",
  "fall6"
}

function AirDropGarbage:OnCreate(go)
  if go ~= nil then
    self.gameObject = go.gameObject
    self.transform = go.gameObject.transform
  end
  self:ComponentDefine()
  self:DataDefine()
end

function AirDropGarbage:OnDestroy()
  self:ComponentDestroy()
  self:DataDestroy()
end

function AirDropGarbage:ComponentDefine()
  self.anim = self.transform:Find(anim_path):GetComponent(typeof(CS.SimpleAnimation))
  self.effect = self.transform:Find(effect_path)
end

function AirDropGarbage:ComponentDestroy()
  self.anim = nil
  self.effect = nil
  self.gameObject = nil
  self.transform = nil
end

function AirDropGarbage:DataDefine()
  self.param = nil
  self.effectTimer = nil
  self.closeTimer = nil
  self.showTimer = nil
  
  function self.effect_timer_action(temp)
    self:EffectTimeCallBack()
  end
  
  function self.close_timer_action(temp)
    self:CloseTimeCallBack()
  end
  
  function self.show_timer_action(temp)
    self:ShowTimeCallBack()
  end
  
  self.animName = nil
  self.delayTime = 1
end

function AirDropGarbage:DataDestroy()
  self:DeleteEffectTimer()
  self:DeleteShowTimer()
  self:DeleteCloseTimer()
  self.param = nil
  self.effect_timer_action = nil
  self.close_timer_action = nil
  self.show_timer_action = nil
  self.animName = nil
  self.delayTime = 1
end

function AirDropGarbage:ReInit(param)
  self.param = param
  self.effect.gameObject:SetActive(false)
  self.anim.gameObject:SetActive(true)
  self.gameObject:SetActive(false)
  self.animName = AnimName[math.random(1, #AnimName)]
  self.delayTime = math.random()
  self.showTimer = TimerManager:GetInstance():GetTimer(self.delayTime, self.show_timer_action, self, true, false, false)
  self.showTimer:Start()
end

function AirDropGarbage:DeleteEffectTimer()
  if self.effectTimer ~= nil then
    self.effectTimer:Stop()
    self.effectTimer = nil
  end
end

function AirDropGarbage:DeleteCloseTimer()
  if self.closeTimer ~= nil then
    self.closeTimer:Stop()
    self.closeTimer = nil
  end
end

function AirDropGarbage:DeleteShowTimer()
  if self.showTimer ~= nil then
    self.showTimer:Stop()
    self.showTimer = nil
  end
end

function AirDropGarbage:EffectTimeCallBack()
  self:DeleteEffectTimer()
  self.effect.gameObject:SetActive(true)
  self.anim.gameObject:SetActive(false)
  local build = CS.SceneManager.World:GetObjectByPoint(self.param.pointId)
  if build ~= nil then
    build:SetVisible(true)
  end
end

function AirDropGarbage:CloseTimeCallBack()
  self:DeleteCloseTimer()
  DataCenter.AirDropGarbageManager:DestroyAirDrop(self.param.pointId)
end

function AirDropGarbage:ShowTimeCallBack()
  self:DeleteShowTimer()
  self.gameObject:SetActive(true)
  local t = SceneUtils.TileIndexToWorld(self.param.pointId)
  self.gameObject.transform:Set_position(t.x, t.y, t.z)
  if self.animName ~= nil then
    local time = self.anim:GetClipLength(self.animName)
    if time ~= nil and 0 < time then
      self.anim:Play(self.animName)
      self.effectTimer = TimerManager:GetInstance():GetTimer(time + EffectShowDeltaTime, self.effect_timer_action, self, true, false, false)
      self.effectTimer:Start()
      self.closeTimer = TimerManager:GetInstance():GetTimer(time + CloseDeltaTime, self.close_timer_action, self, true, false, false)
      self.closeTimer:Start()
    end
  end
end

return AirDropGarbage
