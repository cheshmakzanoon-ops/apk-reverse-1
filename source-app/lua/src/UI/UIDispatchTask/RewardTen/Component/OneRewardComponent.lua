local base = UIBaseContainer
local OneRewardComponent = BaseClass("OneRewardComponent", UIBaseContainer)
local Localization = CS.GameEntry.Localization
local effect_Path = {
  "Assets/_Art_LastWar/Effect/Prefab/UI/ymjd/Eff_ui_ymjd_baoxiangkaiqi2.prefab",
  "Assets/_Art_LastWar/Effect/Prefab/UI/ymjd/Eff_ui_ymjd_baoxiangkaiqi1.prefab",
  "Assets/_Art_LastWar/Effect/Prefab/UI/ymjd/Eff_ui_ymjd_baoxiangkaiqi3.prefab"
}
local animClips = {
  "Eff_ui_ymjddbox2",
  "Eff_ui_ymjddbox1",
  "Eff_ui_ymjddbox3"
}

function OneRewardComponent:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function OneRewardComponent:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function OneRewardComponent:ComponentDefine()
  self.compEffect = self:AddComponent(UIBaseContainer, "")
  self.imgBox1 = self:AddComponent(UIImage, "boxAni/root/Box1")
  self.imgBox2 = self:AddComponent(UIImage, "boxAni/root/Box2")
  self.ani = self:AddComponent(UIAnimator, "boxAni")
  self.ani:Enable(false)
end

function OneRewardComponent:ComponentDestroy()
  self.compEffect = nil
  self.imgBox1 = nil
  self.imgBox2 = nil
  self.animatorEffUiYmjdboxAni = nil
end

function OneRewardComponent:DataDefine()
  self:DeleteTimer()
  self.timer = nil
  
  function self.timer_action(temp)
  end
end

function OneRewardComponent:DataDestroy()
  if self.effectReq then
    self.effectReq:Destroy()
    self.effectReq = nil
  end
  self.timer = nil
  self.timer_action = nil
end

function OneRewardComponent:OnAddListener()
  base.OnAddListener(self)
end

function OneRewardComponent:OnRemoveListener()
  base.OnRemoveListener(self)
end

function OneRewardComponent:DeleteTimer()
  if self.timer ~= nil then
    self.timer:Stop()
    self.timer = nil
  end
end

function OneRewardComponent:AddTimer(time)
  self:DeleteTimer()
  if self.timer == nil then
    self.timer = TimerManager:GetInstance():GetTimer(time, self.timer_action, self, true, false, false)
  end
  self.timer:Start()
end

function OneRewardComponent:UpdateData(data)
  local type = data.type + 1
  self.ani:Enable(true)
  self.ani:Play(animClips[type], 0, 0)
  self.effectReq = self:GameObjectInstantiateAsync(effect_Path[type], function(req)
    if IsNull(req.gameObject) then
      return
    end
    local go = req.gameObject
    local index = type
    local nameStr = "effect" .. index
    go.name = nameStr
    go:SetActive(true)
    local transform = go.transform
    transform:SetParent(self.ani.transform)
    transform:Set_localScale(1, 1, 1)
    transform:Set_pivot(0, 1)
    transform:Set_localPosition(0, 0, 0)
  end)
  self:AddTimer(1.5)
end

return OneRewardComponent
