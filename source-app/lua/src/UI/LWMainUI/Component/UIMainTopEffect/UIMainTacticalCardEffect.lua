local UIMainTacticalCardEffect = BaseClass("UIMainTacticalCardEffect", UIBaseContainer)
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization

function UIMainTacticalCardEffect:OnCreate()
  base.OnCreate(self)
  self.stayVfx = self:AddComponent(UIBaseContainer, "stayVfx")
  self.onceVfx = self:AddComponent(UIBaseContainer, "onceVfx")
  self.triggerVfxReqDic = {}
  self.vfxLoopParamList = {}
  self.vfxLoopParamDic = {}
  self.onceVfxTimers = {}
end

function UIMainTacticalCardEffect:OnDestroy()
  self:Clear()
  self.stayVfx = nil
  self.onceVfx = nil
  base.OnDestroy(self)
end

function UIMainTacticalCardEffect:Clear()
  Logger.LogCustom("=================> UIMainTacticalCardEffect:Clear()")
  self:StopLoopVfxTimer()
  self:StopLoopParamTimer()
  self:DeleteLoopVfxPrefab()
  self:DeleteTriggerVfxPrefab()
  if self.onceVfxTimers then
    for i, v in ipairs(self.onceVfxTimers) do
      if v then
        v:Stop()
      end
    end
    table.clear(self.onceVfxTimers)
  end
  if self.triggerVfxReqDic then
    for i, v in pairs(self.triggerVfxReqDic) do
      if v then
        v:Destroy()
      end
    end
    table.clear(self.triggerVfxReqDic)
  end
  table.clear(self.vfxLoopParamList)
  table.clear(self.vfxLoopParamDic)
  self.loopIndex = nil
end

function UIMainTacticalCardEffect:OnTCCardSkillUse(skillInfo)
  if not skillInfo then
    return
  end
  local template = DataCenter.TacticalCardDataManager:GetSkillTemplateData(skillInfo.cardSkillId)
  if not template then
    return
  end
  if not (template.effect == 1 and template.effect_para1) or 1 > #template.effect_para1 then
    return
  end
  local statusId = tonumber(template.effect_para1[1])
  local statusTemplate = LocalController:instance():getLine(TableName.StatusTab, statusId)
  local buffData = DataCenter.StatusManager:GetBuff(statusId)
  if buffData == nil then
    Logger.LogError("\232\191\153\230\156\137\228\184\170buff\228\184\162\228\186\134\239\188\159\239\188\159\239\188\159 ")
    return
  end
  if self.triggerVfxReqDic[template.ui_special_effect] then
    return
  end
  local onceParam = {}
  onceParam.path = template.ui_special_effect
  onceParam.duration = 1.5
  self.triggerVfxReqDic[template.ui_special_effect] = self:LoadVfx(onceParam.path, self.onceVfx.transform, function(gameObject)
    self:PlayTriggerVfx(onceParam.path, gameObject)
    self:PushScreenLoopVfx(statusTemplate, buffData)
    local timer = TimerManager:GetInstance():DelayInvoke(function()
      self:DeleteTriggerVfxPrefab(template.ui_special_effect)
    end, onceParam.duration)
    table.insert(self.onceVfxTimers, timer)
  end)
end

function UIMainTacticalCardEffect:PlayTriggerVfx(path, gameObject)
  local vfxCpts = gameObject:GetComponentsInChildren(typeof(CS.UnityEngine.ParticleSystem))
  if IsNull(vfxCpts) then
    Logger.LogError(" ParticleSystem is Not Find!!!!   asset:" .. path)
    return
  end
  local animationCpt = gameObject:GetComponent(typeof(CS.SimpleAnimation))
  if IsNull(animationCpt) then
    Logger.LogError(" SimpleAnimation is Not Find!!!!   asset:" .. path)
    return
  end
  gameObject:SetActive(true)
  if Config.IsPC() then
    animationCpt:Play("pc")
  else
    animationCpt:Play("Default")
  end
  self:PlayVfx(vfxCpts)
end

function UIMainTacticalCardEffect:PushScreenLoopVfx(statusTemplate, buffData)
  if not self.vfxLoopParamDic or not self.vfxLoopParamList then
    return
  end
  if string.IsNullOrEmpty(statusTemplate.card_screen_effect) then
    return
  end
  local duration = LuaEntry.DataConfig:TryGetNum("battle_card_param", "k17", 5)
  local loopParam = {}
  loopParam.duration = duration
  loopParam.color = statusTemplate.card_screen_effect
  loopParam.id = statusTemplate.id
  loopParam.endTime = buffData.endTime
  local isExist = self.vfxLoopParamDic[loopParam.color]
  if isExist then
    for i, v in ipairs(self.vfxLoopParamList) do
      if v.color == loopParam.color then
        if loopParam.endTime > v.endTime then
          v.id = loopParam.id
          v.endTime = loopParam.endTime
        end
        break
      end
    end
  else
    self.vfxLoopParamDic[loopParam.color] = true
    table.insert(self.vfxLoopParamList, loopParam)
  end
  self:CreateLoopVfxPrefab()
end

function UIMainTacticalCardEffect:StartLoopVfxTimer()
  local delta = LuaEntry.DataConfig:TryGetNum("battle_card_param", "k17", 5)
  self.loopVfxTimer = TimerManager:GetInstance():GetTimer(delta, self.OnLoopVfxTick, self, false, false, false)
  self.loopVfxTimer:Start()
  self:OnLoopVfxTick()
end

function UIMainTacticalCardEffect:StopLoopVfxTimer()
  if self.loopVfxTimer ~= nil then
    self.loopVfxTimer:Stop()
    self.loopVfxTimer = nil
  end
end

function UIMainTacticalCardEffect:StopLoopParamTimer()
  if self.loopParamTimer then
    self.loopParamTimer:Stop()
    self.loopParamTimer = nil
  end
end

function UIMainTacticalCardEffect:OnLoopVfxTick()
  if not self.vfxLoopParamList then
    return
  end
  local dirty = false
  local now = UITimeManager:GetInstance():GetServerTime()
  for i, v in ipairs(self.vfxLoopParamList) do
    if v and now >= v.endTime then
      self.vfxLoopParamDic[v.color] = nil
      dirty = true
    end
  end
  if dirty then
    local count = #self.vfxLoopParamList
    for i = count, 1, -1 do
      local param = self.vfxLoopParamList[i]
      if param and not self.vfxLoopParamDic[param.color] then
        table.remove(self.vfxLoopParamList, i)
      end
    end
  end
  if #self.vfxLoopParamList == 0 then
    self:StopLoopVfxTimer()
    self:StopLoopParamTimer()
    self:DeleteLoopVfxPrefab()
  else
    self:UpdateLoopVfx(now)
  end
end

function UIMainTacticalCardEffect:UpdateLoopVfx(nowTime)
  if not self.loopVfxGameObject or not self.loopVfxImageCpt then
    return
  end
  self.loopVfxGameObject:SetActive(true)
  if self.loopIndex == nil then
    self.loopIndex = 1
  end
  local param = self.vfxLoopParamList[self.loopIndex]
  if not param then
    self.loopIndex = self.loopIndex % #self.vfxLoopParamList + 1
    self:UpdateLoopVfx(nowTime)
    return
  end
  local delta = LuaEntry.DataConfig:TryGetNum("battle_card_param", "k17", 1.5)
  if param.lastPlayTime and delta > nowTime - param.lastPlayTime then
    return
  end
  param.lastPlayTime = nowTime
  self.loopIndex = self.loopIndex % #self.vfxLoopParamList + 1
  local r, g, b, a = self.loopVfxImageCpt:Get_color()
  local configColor = UIUtil.HexToColor(param.color)
  self.loopVfxImageCpt:Set_color(configColor.r, configColor.g, configColor.b, a)
end

function UIMainTacticalCardEffect:CreateLoopVfxPrefab()
  if self.loopVfxReq then
    return
  end
  local path = LuaEntry.DataConfig:TryGetStr("battle_card_param", "k15")
  self.loopVfxReq = self:LoadVfx(path, self.stayVfx.transform, function(gameObject)
    local vfxCpts = gameObject:GetComponentsInChildren(typeof(CS.UnityEngine.ParticleSystem))
    if IsNull(vfxCpts) then
      Logger.LogError(" ParticleSystem is Not Find!!!!   asset:" .. path)
      return
    end
    local imageCpt = gameObject:GetComponent(typeof(CS.UnityEngine.UI.Image))
    if IsNull(imageCpt) then
      Logger.LogError("image is Not Find!!!!   asset:" .. path)
      return
    end
    gameObject:SetActive(false)
    self.loopVfxGameObject = gameObject
    self.loopVfxImageCpt = imageCpt
    self:StartLoopVfxTimer()
  end)
end

function UIMainTacticalCardEffect:DeleteTriggerVfxPrefab(path)
  if self.triggerVfxReqDic[path] then
    self.triggerVfxReqDic[path]:Destroy()
    self.triggerVfxReqDic[path] = nil
  end
end

function UIMainTacticalCardEffect:DeleteLoopVfxPrefab()
  self.loopVfxGameObject = nil
  self.loopVfxImageCpt = nil
  if self.loopVfxReq then
    self.loopVfxReq:Destroy()
    self.loopVfxReq = nil
  end
end

function UIMainTacticalCardEffect:PlayLoopVfx()
  if not self.vfxLoopParamList or #self.vfxLoopParamList == 0 then
    return
  end
  if not self.loopVfxGameObject or not self.loopVfxImageCpt then
    return
  end
  self.loopVfxGameObject:SetActive(true)
  if self.loopIndex == nil then
    self.loopIndex = 1
  end
  local item = self.vfxLoopParamList[self.loopIndex]
  self.loopIndex = self.loopIndex % #self.vfxLoopParamList + 1
  local r, g, b, a = self.loopVfxImageCpt:Get_color()
  local configColor = UIUtil.HexToColor(item.color)
  self.loopVfxImageCpt:Set_color(configColor.r, configColor.g, configColor.b, a)
  self.loopParamTimer = TimerManager:GetInstance():DelayInvoke(function()
    self:PlayLoopVfx()
  end, item.duration)
end

function UIMainTacticalCardEffect:LoadVfx(path, parent, callback)
  local req = self:GameObjectInstantiateAsync(path, function(request)
    local gameObject = request.gameObject
    if gameObject == nil then
      return
    end
    gameObject:SetActive(false)
    gameObject.transform:SetParent(parent)
    gameObject.transform:Set_localPosition(0, 0, 0)
    gameObject.transform:Set_localEulerAngles(0, 0, 0)
    gameObject.transform:Set_localScale(1, 1, 1)
    local rectTransform = gameObject:GetComponent(typeof(CS.UnityEngine.RectTransform))
    rectTransform:Set_offsetMin(0, 0)
    rectTransform:Set_offsetMax(0, 0)
    if callback then
      callback(gameObject)
    end
  end)
  return req
end

function UIMainTacticalCardEffect:PlayVfx(cpts)
  for i = 0, cpts.Length - 1 do
    cpts[i]:Play()
  end
end

return UIMainTacticalCardEffect
