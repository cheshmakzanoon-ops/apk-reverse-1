local BuildResourceGetBubble = BaseClass("BuildResourceGetBubble")
local ResourceManager = CS.GameEntry.Resource
local precess_path = "Go/Bg/Precess"
local bg_path = "Go/Bg"
local trigger_path = "Go/Trigger"
local icon_path = "Go/Bg/Icon"
local icon_go_path = "Go"
local obj_path = ""
local FixNormalAnimTime = 0.1
local ClickDuringTime = 0.5
local fullEffectPath = "Assets/_Art/Effect/prefab/ui/VFX_ziyuanshouqu_glow_loop.prefab"
local AnimName = {
  Enter = "EnterBubble",
  Hide = "HideBubble",
  Normal = "NormalBubble",
  ResourceItem = "goodsBubble",
  Default = "Default"
}
local maxWidthValue = 2.2
local maxHeightValue = 2.3
local PerRefreshTime = 30

function BuildResourceGetBubble:OnCreate(go)
  if go ~= nil then
    self.request = go
    self.gameObject = go.gameObject
    self.transform = go.gameObject.transform
  end
  self:DataDefine()
end

function BuildResourceGetBubble:OnDestroy()
  self:ComponentDestroy()
  self:DataDestroy()
end

function BuildResourceGetBubble:ComponentDefine()
  if not self.defend then
    self.icon_go = self.transform:Find(icon_go_path):GetComponent(typeof(CS.SimpleAnimation))
    self.icon_sprite = self.transform:Find(icon_path):GetComponent(typeof(CS.SpriteMeshRenderer))
    self.bg_color = self.transform:Find(bg_path):GetComponent(typeof(CS.SpriteMeshRenderer))
    self.bg = self.transform:Find(trigger_path):GetComponent(typeof(CS.TouchObjectEventTrigger))
    self.bg_color:Set_color_a(1.0)
    self.icon_sprite:Set_color_a(1.0)
    self.obj = self.transform:Find(obj_path):GetComponent(typeof(typeof(CS.UnityEngine.Transform)))
    self.precess = self.transform:Find(precess_path):GetComponent(typeof(CS.UnityEngine.SpriteRenderer))
    
    function self.bg.onPointerClick()
      self:OnClick()
    end
    
    function self.bg.onPointerDown()
      self:OnPointerDown()
    end
    
    function self.bg.onPointerUp()
      self:OnPointerUp()
    end
    
    self.defend = true
  end
end

function BuildResourceGetBubble:ComponentDestroy()
  self.bg.onPointerClick = nil
  self.bg.onPointerDown = nil
  self.bg.onPointerUp = nil
end

function BuildResourceGetBubble:DataDefine()
  self.param = nil
  self.defend = false
  self.curValue = 0
  self.unavailableTime = 0
  self.lastCollectTime = 0
  self.collectSpeed = 0
  self.collectMax = 0
  self.precessSize = Vector2.New(0, 0)
  self.produceEndTime = 0
  self.animationAlreadyShow = false
  self.isShow = false
  self.cdTimer = nil
  self.oldParam = nil
  self.tween = nil
  
  function self.fix_bug_timer_action(temp)
    self:FixBugTimeCallBack()
  end
  
  function self.click_cd_timer_callback(temp)
    self:ClickCdTimerCallBack()
  end
  
  self.heightDeltaPos = Vector3.New(0, 0, 0)
  self.state = nil
end

function BuildResourceGetBubble:DataDestroy()
  self:ClearAllEffectAndTimer()
  self.param = nil
  self.defend = false
  self.curValue = 0
  self.unavailableTime = 0
  self.lastCollectTime = 0
  self.collectSpeed = 0
  self.collectMax = 0
  self.produceEndTime = 0
  self.fix_bug_timer_action = nil
  self.click_cd_timer_callback = nil
end

function BuildResourceGetBubble:ReInit(param)
  self.oldParam = self.param
  self.param = param
  self:ComponentDefine()
  self:ShowPanel()
  self:ShowResFullEffect()
end

function BuildResourceGetBubble:ShowPanel()
  self.state = nil
  if self.oldParam == nil or self.param.bgName ~= self.oldParam.bgName then
    if self.param.bgName ~= nil then
      self.bg_color.gameObject:SetActive(true)
      self.bg_color:LoadSprite(self.param.bgName)
    else
      self.bg_color.gameObject:SetActive(false)
    end
  end
  if self.oldParam == nil or self.param.iconName ~= self.oldParam.iconName then
    if self.param.iconName ~= nil and self.param.iconName:sub(-1) ~= "/" then
      self.icon_sprite.gameObject:SetActive(true)
      UIUtil.LoadSpriteRenderAuto(self.icon_sprite, self.param.iconName)
    else
      self.icon_sprite.gameObject:SetActive(false)
    end
  end
  if (self.oldParam == nil or self.param.bgScale ~= self.oldParam.bgScale) and self.param.bgScale ~= nil and self.bg_color ~= nil then
    local v = self.param.bgScale
    self.bg_color.transform:Set_localScale(v.x, v.y, v.z)
  end
  if (self.oldParam == nil or self.param.iconScale ~= self.oldParam.iconScale) and self.param.iconScale ~= nil and self.icon_sprite ~= nil then
    local v = self.param.iconScale
    self.icon_sprite.transform:Set_localScale(v.x, v.y, v.z)
  end
  if (self.oldParam == nil or self.param.pos ~= self.oldParam.pos or self.oldParam.modelHeight ~= self.param.modelHeight) and self.param.pos ~= nil then
    self:UpdatePosition(self.param.pos)
  end
  self.unavailableTime = self.param.unavailableTime
  self.lastCollectTime = self.param.lastCollectTime
  self.produceEndTime = self.param.produceEndTime
  self.collectSpeed = self.param.collectSpeed
  self.collectMax = self.param.collectMax
  self.precessSize.x = maxWidthValue
  self.precessSize.y = maxHeightValue
  self:Refresh()
  self:RefreshState()
  self:AddFixBugTimer()
end

function BuildResourceGetBubble:UpdatePosition(index)
  self.heightDeltaPos.y = self.param.modelHeight
  self:SetPosition(BuildingUtils.GetBuildModelCenterVec(index, self.param.tileX, self.param.tileY) + self.heightDeltaPos)
end

function BuildResourceGetBubble:SetPosition(value)
  self.transform:Set_position(value.x, value.y, value.z)
end

function BuildResourceGetBubble:OnClick()
  if self.cdTimer ~= nil then
    return
  end
  if not CS.SceneManager.World:CanUseInput() then
    return
  end
  if self.param.callBack ~= nil then
    self.param.callBack(self.param)
    self:AddClickCdTimer()
  end
end

function BuildResourceGetBubble:OnPointerDown()
  if self.tween ~= nil then
    self.tween:Kill()
  end
  self.tween = self.transform:DOScale(ResetScale * 0.8, 0.1)
end

function BuildResourceGetBubble:OnPointerUp()
  if self.tween ~= nil then
    self.tween:Kill()
  end
  self.tween = self.transform:DOScale(ResetScale, 0.1)
end

function BuildResourceGetBubble:RefreshState()
  if (self.oldParam == nil or self.param.state ~= self.oldParam.state) and self.state ~= self.param.state then
    self.state = self.param.state
  end
end

function BuildResourceGetBubble:GetBubblePosition()
  if self.icon_sprite ~= nil then
    return self.icon_sprite.transform.position
  elseif self.bg ~= nil then
    return self.bg.transform.position
  end
  return ResetPosition
end

function BuildResourceGetBubble:GetBubbleObj(isIgnore)
  if isIgnore then
    return self.obj
  end
  if self.bg ~= nil then
    return self.bg
  elseif self.icon_sprite ~= nil then
    return self.icon_sprite
  end
  return self.icon_go
end

function BuildResourceGetBubble:ShowFullEffect()
  if self.fullEffect == nil then
    self.fullEffect = ResourceManager:InstantiateAsync(fullEffectPath)
    self.fullEffect:completed("+", function()
      if self.fullEffect.isError then
        return
      end
      self.fullEffect.gameObject:SetActive(true)
      local go_rt = self.fullEffect.gameObject.transform
      go_rt:SetParent(self.bg_color.gameObject.transform, false)
      go_rt:Set_localScale(1.5, 1.5, 1.5)
      go_rt:Set_localPosition(0, 0, 0)
    end)
  end
end

function BuildResourceGetBubble:Refresh()
  local now = UITimeManager:GetInstance():GetServerTime()
  if self.unavailableTime > 0 and now > self.unavailableTime then
    now = self.unavailableTime
  end
  if 0 < self.produceEndTime and now > self.produceEndTime then
    now = self.produceEndTime
  end
  self.curValue = (now - self.lastCollectTime) * self.collectSpeed / self.collectMax
  if self.curValue > 1 then
    self.curValue = 1
  end
  self.precessSize.y = self.curValue * maxHeightValue
  self:RefreshPrecess()
  self:RefreshState()
end

function BuildResourceGetBubble:RefreshPrecess()
  self.precess.size = self.precessSize
end

function BuildResourceGetBubble:ShowResFullEffect()
  local buildingData = DataCenter.BuildManager:GetBuildingDataByUuid(self.param.uuid)
  local percent = buildingData:GetResourcePercent()
  if 1 <= percent then
    self:ShowFullEffect()
    EventManager:GetInstance():Broadcast(EventId.ResourceFull, self.param.resourceType)
  else
    self:ClearFullEffect()
  end
end

function BuildResourceGetBubble:ClearFullEffect()
  if self.fullEffect ~= nil then
    self.fullEffect:Destroy()
    self.fullEffect = nil
  end
end

function BuildResourceGetBubble:Show()
  if self.icon_go ~= nil then
    if self.isShow == true then
      self.icon_go:Play(AnimName.Normal)
    else
      self.icon_go:Play(AnimName.Enter)
      self.icon_go:PlayQueued(AnimName.Normal)
      self.isShow = true
    end
  end
end

function BuildResourceGetBubble:Hide()
  if self.isShow == false then
    return
  end
  if self.icon_go ~= nil then
    self.icon_go:Play(AnimName.Hide)
  end
  self.isShow = false
end

function BuildResourceGetBubble:ToFree()
  if self.icon_go ~= nil then
    self.icon_go:Play(AnimName.Default)
  end
  self.oldParam = self.param
  self.animationAlreadyShow = false
  self:ClearAllEffectAndTimer()
end

function BuildResourceGetBubble:AddFixBugTimer()
  if self.fixBugTimer == nil then
    self.fixBugTimer = TimerManager:GetInstance():GetTimer(FixNormalAnimTime, self.fix_bug_timer_action, self, true, false, false)
  end
  self.fixBugTimer:Start()
end

function BuildResourceGetBubble:DeleteFixBugTimer()
  if self.fixBugTimer ~= nil then
    self.fixBugTimer:Stop()
    self.fixBugTimer = nil
  end
end

function BuildResourceGetBubble:FixBugTimeCallBack()
  self:DeleteFixBugTimer()
  self.transform:Set_localScale(ResetScale.x, ResetScale.y, ResetScale.z)
  if self.icon_go ~= nil and self.animationAlreadyShow == false then
    self.animationAlreadyShow = true
    self.icon_go:Play(AnimName.Enter)
    self.icon_go:PlayQueued(AnimName.Normal)
  end
end

function BuildResourceGetBubble:AddClickCdTimer()
  if self.cdTimer == nil then
    self.cdTimer = TimerManager:GetInstance():GetTimer(ClickDuringTime, self.click_cd_timer_callback, self, true, false, false)
  end
  self.cdTimer:Start()
end

function BuildResourceGetBubble:DeleteClickCdTimer()
  if self.cdTimer ~= nil then
    self.cdTimer:Stop()
    self.cdTimer = nil
  end
end

function BuildResourceGetBubble:ClickCdTimerCallBack()
  self:DeleteClickCdTimer()
end

function BuildResourceGetBubble:ClearAllEffectAndTimer()
  self:DeleteClickCdTimer()
  self:DeleteFixBugTimer()
  self:ClearFullEffect()
end

return BuildResourceGetBubble
