local Logger = require("Framework.Logger.Logger")
local SceneBuildTimeTipCircle = BaseClass("SceneBuildTimeTipCircle")
local slider_path = "GameObject/PosGo/Slider"
local icon_path = "GameObject/PosGo/Icon"
local timeText_path = "GameObject/PosGo/timeBg/time"
local pos_go_path = "GameObject/PosGo"

function SceneBuildTimeTipCircle:OnCreate(go)
  if go ~= nil then
    self.request = go
    self.gameObject = go.gameObject
    self.transform = go.gameObject.transform
  end
  self.pyramidNormalSpeedUpShowDelay = 1.5
  self.pyramidRollCountdownShowDelay = 1
  self.currentValue = 0
  self.time = 2
  self.tempTime = 2
  self.effectTime = 2
  self.endtime = 0
  self.startTime = 0
  self:ComponentDefine()
  self:DataDefine()
end

function SceneBuildTimeTipCircle:OnDestroy()
  self:ComponentDestroy()
  self:DataDestroy()
end

function SceneBuildTimeTipCircle:ComponentDefine()
  self.slider = self.transform:Find(slider_path):GetComponent(typeof(CS.UnityEngine.SpriteRenderer))
  self.icon = self.transform:Find(icon_path):GetComponent(typeof(CS.UnityEngine.SpriteRenderer))
  self.ChangeSceneCircleSlider = self.transform:GetComponent(typeof(CS.ChangeSceneCircleSlider))
  self.anim = self.transform:GetComponent(typeof(CS.SimpleAnimation))
  self.timeText = self.transform:Find(timeText_path):GetComponent(typeof(CS.SuperTextMesh))
  self.pos_go = self.transform:Find(pos_go_path)
end

function SceneBuildTimeTipCircle:ComponentDestroy()
  self.slider = nil
  self.icon = nil
  self.ChangeSceneCircleSlider = nil
  self.anim = nil
  self.timeText = nil
  self.pos_go = nil
end

function SceneBuildTimeTipCircle:PlayAnim(animName)
  if IsNotNull(self.anim) then
    if self.anim.enabled == false then
      Logger.LogError("[SceneBuildTimeTipCircle] PlayAnim anim is disabled!")
      self.anim.enabled = true
    end
    if self.anim:IsPlaying(animName) then
      self.anim:Rewind(animName)
    else
      self.anim:Play(animName)
    end
  else
    Logger.LogWarning("[SceneBuildTimeTipCircle] PlayAnim anim\231\187\132\228\187\182 \228\184\186\231\169\186")
  end
end

function SceneBuildTimeTipCircle:DataDefine()
  self.param = nil
  self.curPosition = nil
  self.index = nil
  self.timer = nil
  
  function self.timer_action(temp)
    self:TimeRefresh()
  end
  
  function self.speedTimerAction()
    self:SpeedUpAnim()
  end
end

function SceneBuildTimeTipCircle:DataDestroy()
  if self.param ~= nil and self.param.buildId == BuildingTypes.FUN_BUILD_BUSINESS_CENTER then
    self.param = nil
    EventManager:GetInstance():Broadcast(EventId.RefreshResidentOrder)
  end
  self.param = nil
  self.curPosition = nil
  self.index = nil
  self.timer_action = nil
  self:DeleteTime()
  if self.tween then
    self.tween:Kill()
    self.tween = nil
  end
end

function SceneBuildTimeTipCircle:ReInit(paramList)
  local param = paramList[1]
  self.param = param
  self:RefreshActive(true)
  self:ShowPanel()
  self:AddTime()
end

function SceneBuildTimeTipCircle:ShowPanel()
  if self.param.iconName == nil then
    self.icon.gameObject:SetActive(false)
  else
    self.icon:LoadSprite(self.param.iconName)
    if self.param.iconScale == nil then
      self.icon.transform:Set_localScale(ResetScale.x, ResetScale.y, ResetScale.z)
    else
      self.icon.transform.localScale = self.param.iconScale
    end
    self.icon.gameObject:SetActive(true)
  end
  if self.param.pos ~= nil then
    self:UpdatePosition(self.param.pos)
  end
  self:RefreshSliderInterVal()
  self:PlayAppearAnim()
end

function SceneBuildTimeTipCircle:RefreshSliderInterVal()
  if self.param.endTime ~= nil and self.param.startTime ~= nil then
    self.ChangeSceneCircleSlider:Init(self.param.startTime, self.param.endTime)
  end
end

function SceneBuildTimeTipCircle:AddSpeedUpTime_Pyramid()
  if self.pyramidNormalSpeedUpShowTimer ~= nil then
    self.pyramidNormalSpeedUpShowTimer:Stop()
    self.pyramidNormalSpeedUpShowTimer = nil
  end
  if self.pyramidRollCountdownShowTimer ~= nil then
    self.pyramidRollCountdownShowTimer:Stop()
    self.pyramidRollCountdownShowTimer = nil
  end
  self.effectTime = LuaEntry.Effect:GetGameEffect(EffectDefine.LW_BUILDSPEEDUP_WORKER) * 1000
  local buildCurLevelTemplate = DataCenter.BuildTemplateManager:GetBuildingLevelTemplate(self.param.buildId, self.param.level)
  if buildCurLevelTemplate == nil then
    return
  end
  local buildInternal = buildCurLevelTemplate.time * 1000 or 0
  local speedUpTime = UITimeManager:GetInstance():MilliSecondToFmtString(buildInternal)
  self.timeText.text = speedUpTime
  local startTime = self.param.startTime + self.effectTime
  local cdReduceTime = self.param.endTime - self.param.startTime
  local endTime = startTime + (buildInternal - cdReduceTime)
  self:InitdNormalSpeedUpSceneCircleSlider()
  self.pyramidRollCountdownShowTimer = TimerManager:GetInstance():DelayInvoke(function()
    local function RollCountdownCallback(x)
      if self.timeText and self.timeText.text then
        local spendTime = UITimeManager:GetInstance():MilliSecondToFmtString(buildInternal - (x - startTime))
        
        self.timeText.text = spendTime
      end
    end
    
    if self.tween then
      self.tween:Kill()
      self.tween = nil
    end
    self.tween = DOTween.To(RollCountdownCallback, startTime, endTime, self.pyramidNormalSpeedUpShowDelay)
  end, self.pyramidRollCountdownShowDelay)
  self.pyramidNormalSpeedUpShowTimer = TimerManager:GetInstance():DelayInvoke(function()
    self:NormalSpeedUp()
  end, self.pyramidNormalSpeedUpShowDelay + 0.5)
end

function SceneBuildTimeTipCircle:InitdNormalSpeedUpSceneCircleSlider()
  local curTime = UITimeManager:GetInstance():GetServerTime()
  self.effectTime = LuaEntry.Effect:GetGameEffect(EffectDefine.LW_BUILDSPEEDUP_WORKER) * 1000
  self.currentValue = self.param.endTime + self.effectTime - curTime
  self.tempTime = self.effectTime + 2000
  self.startTime = self.param.startTime + self.effectTime
  self.endtime = self.param.endTime + self.effectTime
  self.currentValue = self.currentValue - self.tempTime * 0.2 / 2
  self.endtime = self.endtime - self.effectTime * 0.1
  self.startTime = self.startTime - self.effectTime * 0.1
  self.ChangeSceneCircleSlider:Init(self.startTime, self.endtime)
end

function SceneBuildTimeTipCircle:SpeedUp()
  if self.timer then
    self.timer:Stop()
    self.timer = nil
  end
  self:PlayAnim("SceneBuildTimeTipCircle_defaultshow")
  local isExistSpeedUpBuilding = DataCenter.ExchangeSpecialManager:IsExistSpeedUpBuilding(ItemSpdMenu.ItemSpdMenu_City)
  if isExistSpeedUpBuilding then
    self:AddSpeedUpTime_Pyramid()
  else
    self:NormalSpeedUp()
  end
end

function SceneBuildTimeTipCircle:NormalSpeedUp()
  self:AddSpeedUpTime()
  self.endDelay = TimerManager:GetInstance():DelayInvoke(function()
    if self.speedTime ~= nil then
      self.speedTime:Stop()
      self.speedTime = nil
    end
    self:TimeRefresh()
    self:AddTime()
  end, 2)
end

function SceneBuildTimeTipCircle:PlayAppearAnim()
  local curTime = UITimeManager:GetInstance():GetServerTime()
  local leftTime = self.param.endTime - curTime
  local time = LuaEntry.Effect:GetGameEffect(EffectDefine.LW_BUILDSPEEDUP_WORKER) * 1000
  if time < 0 then
    time = 0
  end
  local passedTime = curTime - self.param.startTime - time
  if self.param.buildId == BuildingTypes.APS_BUILD_WORMHOLE_SUB or self.param.buildId == BuildingTypes.WORM_HOLE_CROSS then
    self:AddTime()
    if passedTime < 1000 then
      self:PlayAnim("SceneBuildTimeTipCircle_defaultshow")
    else
      self:PlayAnim("SceneBuildTimeTipCircle_defaultshow")
    end
  elseif passedTime < 1000 then
    self.timeText.text = UITimeManager:GetInstance():MilliSecondToFmtString(leftTime)
    self.anim.gameObject:SetActive(false)
    TimerManager:GetInstance():DelayInvoke(function()
      if not IsNull(self.anim) then
        self.anim.gameObject:SetActive(true)
        if self.param.level == 0 then
          self:PlayAnim("SceneBuildTimeTipCircle_defaultshow")
        elseif 0 < time and self.param.buildTimeType ~= BuildTimeType.BuildTime_Injuries and self.param.buildTimeType ~= BuildTimeType.BuildTime_Science then
          self:SpeedUp()
        else
          self:PlayAnim("SceneBuildTimeTipCircle_defaultshow")
        end
      else
        Logger.LogWarning("[SceneBuildTimeTipCircle] passedTime < 1000 \228\189\134\230\152\175anim \228\184\186\231\169\186")
      end
    end, 0.1)
  else
    self:PlayAnim("SceneBuildTimeTipCircle_defaultshow")
  end
end

function SceneBuildTimeTipCircle:UpdatePosition(index)
  if self.index ~= index then
    self.index = index
    local theType = ForceChangeScene.City
    if SceneUtils.GetIsInWorld() then
      theType = ForceChangeScene.World
    end
    if self.param and self.param.buildId and SeasonUtil.IsSeasonPlayerBuilding(self.param.buildId) then
      theType = ForceChangeScene.World
    end
    self.transform.position = BuildingUtils.GetBuildModelCenterVec(index, self.param.tileX, self.param.tileY, theType)
  end
end

function SceneBuildTimeTipCircle:RefreshActive(isActive)
  self.pos_go.gameObject:SetActive(isActive)
end

function SceneBuildTimeTipCircle:AddTime()
  if self.timer == nil then
    self.timer = TimerManager:GetInstance():GetTimer(1, self.timer_action, self, false, false, false)
  end
  self.timer:Start()
end

function SceneBuildTimeTipCircle:SpeedUpAnim()
  self.currentValue = self.currentValue - self.tempTime * 0.2 / 2
  self.endtime = self.endtime - self.effectTime * 0.1
  self.startTime = self.startTime - self.effectTime * 0.1
  local speedUpTime = UITimeManager:GetInstance():MilliSecondToFmtString(self.currentValue)
  if not self.timeText or IsNull(self.timeText) then
    return
  end
  self.timeText.text = speedUpTime
  self.ChangeSceneCircleSlider:Init(self.startTime, self.endtime)
end

function SceneBuildTimeTipCircle:RefreshTotalTime()
  local speedUpTime = UITimeManager:GetInstance():MilliSecondToFmtString(self.currentValue)
  if not self.timeText or IsNull(self.timeText) then
    return
  end
  self.timeText.text = speedUpTime
  self.ChangeSceneCircleSlider:Init(self.startTime, self.endtime)
end

function SceneBuildTimeTipCircle:AddSpeedUpTime()
  if self.speedTime ~= nil then
    self.speedTime:Stop()
    self.speedTime = nil
  end
  local curTime = UITimeManager:GetInstance():GetServerTime()
  self.effectTime = LuaEntry.Effect:GetGameEffect(EffectDefine.LW_BUILDSPEEDUP_WORKER) * 1000
  self.currentValue = self.param.endTime + self.effectTime - curTime
  self.tempTime = self.effectTime + 2000
  self.startTime = self.param.startTime + self.effectTime
  self.endtime = self.param.endTime + self.effectTime
  self.speedTime = TimerManager:GetInstance():GetTimer(1, self.speedTimerAction, self, false, false, false)
  self.speedTime:Start()
  self:RefreshTotalTime()
end

function SceneBuildTimeTipCircle:TimeRefresh()
  if self and self.param and self.param.endTime and not IsNull(self.timeText) then
    local curTime = UITimeManager:GetInstance():GetServerTime()
    local leftTime = self.param.endTime - curTime
    if leftTime <= 0 then
      local bUuid = self.param.bUuid
      self:DeleteTime()
      DataCenter.BuildTimeManager:DeleteOneBuildTime(bUuid)
      DataCenter.WorldBuildTimeManager:DeleteOneBuildTime(bUuid)
      return
    end
    self.timeText.text = UITimeManager:GetInstance():MilliSecondToFmtString(leftTime)
  end
end

function SceneBuildTimeTipCircle:DeleteTime()
  if self.timer ~= nil then
    self.timer:Stop()
    self.timer = nil
  end
  if self.endDelay ~= nil then
    self.endDelay:Stop()
    self.endDelay = nil
  end
  if self.speedTime then
    self.speedTime:Stop()
    self.speedTime = nil
  end
  if self.pyramidNormalSpeedUpShowTimer ~= nil then
    self.pyramidNormalSpeedUpShowTimer:Stop()
    self.pyramidNormalSpeedUpShowTimer = nil
  end
  if self.pyramidRollCountdownShowTimer ~= nil then
    self.pyramidRollCountdownShowTimer:Stop()
    self.pyramidRollCountdownShowTimer = nil
  end
end

function SceneBuildTimeTipCircle:CheckIfTimeTipExist(paramList)
  if paramList and 0 < #paramList then
    local tempParam = paramList[1]
    if tempParam and self.param.model == tempParam.model then
      return true
    end
  end
  return false
end

return SceneBuildTimeTipCircle
