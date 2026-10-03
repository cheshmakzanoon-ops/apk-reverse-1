local base = require("Scene.WorldBuildHeadUI.WorldBattleFieldBuildUIBase")
local WorldEpidemicBuildUI = BaseClass("WorldEpidemicBuildUI", base)
local Localization = CS.GameEntry.Localization
local ResourceManager = CS.GameEntry.Resource
local UITimeMgr = UITimeManager:GetInstance()
local TemplateMgr = DataCenter.EpidemicBuildTemplateMgr
local ActMgr = DataCenter.ActEpidemicZoneManager

function WorldEpidemicBuildUI:OnCreate(go)
  base.OnCreate(self, go)
  self.SP_ID = DataCenter.EpidemicBuildTemplateMgr.BUILD_SCORE_ID
  self.lastBuffEndTime = nil
end

function WorldEpidemicBuildUI:OnDestroy()
  self:HidePowerTowerEff()
  self:DestroyTimer()
  base.OnDestroy(self)
end

function WorldEpidemicBuildUI:RefreshHead()
  self:ReInitInfo()
  local detailInfo = self.detailInfo
  if detailInfo == nil then
    return
  end
  self:UpdateHead()
end

function WorldEpidemicBuildUI:UpdateHead()
  local detailInfo = self.detailInfo
  self.safeEndTime = nil
  if detailInfo == nil then
    self.pointRoot.gameObject:SetActive(false)
    self.safeRoot.gameObject:SetActive(false)
    self.top_head.gameObject:SetActive(false)
    self.tip_a_root.gameObject:SetActive(false)
    return
  end
  local state = detailInfo.State
  local tipV, topV, pointV, safeV = false, false, false, false
  if self.buildId == self.SP_ID then
    tipV = true
    self.tip_a_text.text = string.GetFormattedGoldNum(math.floor(detailInfo.Score or 0))
  elseif state == EpidemicBuildState.Normal and detailInfo.Role == EpidemicZoneRole.Default then
    pointV = true
    self.point_text.text = string.format("+%d/s", self.config ~= nil and self.config.point_produce_per_second or 0)
    self.point_text.color32 = WorldWhiteColor32
  else
    topV = true
    local bUp = false
    local score = string.GetFormattedGoldNum(math.floor(detailInfo.OverflowScore or 0))
    local bestMarch, topInfo = ActMgr:GetBuildBestMarch(detailInfo.Uuid)
    if bestMarch then
      self.head_def.gameObject:SetActive(false)
      self.head_icon:SetData(bestMarch.ownerUid, bestMarch.pic, bestMarch.picVer)
      local x, _, z = self.head_icon.transform:Get_localPosition()
      self.head_icon.transform:Set_localPosition(x, 0.3, z)
      local curHp = topInfo.curHp or 0
      local maxHp = topInfo.totalHp or curHp
      local hpPercent = 0 < maxHp and curHp / maxHp or 0
      self.top_progress.gameObject:SetActive(true)
      self:UpdateHp(hpPercent)
    else
      local x, _, z = self.head_icon.transform:Get_localPosition()
      self.head_icon.transform:Set_localPosition(x, 0.15, z)
      self.head_def.gameObject:SetActive(true)
      self.top_progress.gameObject:SetActive(false)
    end
    self.point_text.text = score
    self.point_text.color32 = bUp and WorldGreenColor32 or WorldWhiteColor32
    local myRole = ActMgr:GetCurRole()
    self:UpdateHeadSp(myRole == detailInfo.Role)
    local curSec = UITimeMgr:GetServerSeconds()
    local occupyTime = detailInfo.OccupyTime or 0
    local safe_point_duration = self.config ~= nil and self.config.safe_point_duration or 0
    if curSec < occupyTime + safe_point_duration then
      safeV = true
      self.safe_text.text = string.format("+%d/s", self.config ~= nil and self.config.point_produce_per_second or 0)
      self.safeEndTime = occupyTime + safe_point_duration
      self:TimerAction()
      self:AddTimer()
    else
      pointV = true
    end
  end
  self.tip_a_root.gameObject:SetActive(tipV)
  self.top_head.gameObject:SetActive(topV)
  self.pointRoot.gameObject:SetActive(pointV)
  self.safeRoot.gameObject:SetActive(safeV)
  if tipV then
    self:FixPos(self.tip_a_text, self.tip_a_img, self.tip_a_bg_img, 0.3, 0.25)
  end
  if pointV then
    self:FixPos(self.point_text, self.point_flag, nil, 0, 0.2, -0.1)
  end
  if safeV then
    self:FixPos(self.safe_text, self.safe_flag, nil, 0, 0.2, -0.1)
  end
end

function WorldEpidemicBuildUI:InitConfig()
  self.config = TemplateMgr:GetTemplate(self.buildId)
end

function WorldEpidemicBuildUI:UpdateStatus()
  self.endTime = nil
  self.safeEndTime = nil
  self.buffEndTime = nil
  self:DeleteTimer()
  self.bottomRoot.gameObject:SetActive(false)
  self.top_head.gameObject:SetActive(false)
  self.tip_a_root.gameObject:SetActive(false)
  self.middle_root.gameObject:SetActive(false)
  local detailInfo = self.detailInfo
  if detailInfo == nil then
    return
  end
  local state = detailInfo.State
  self.bottomRoot.gameObject:SetActive(true)
  self:UpdateHead()
  if self.buildId == self.SP_ID then
    self.statusRoot.gameObject:SetActive(false)
    return
  end
  self.statusRoot.gameObject:SetActive(true)
  if state == EpidemicBuildState.Normal then
    local curTime = UITimeMgr:GetServerSeconds()
    if curTime < detailInfo.OpenTime then
      self.endTime = detailInfo.OpenTime
    else
      self.status_text.text = Localization:GetString("458194")
    end
  else
    self.status_text.text = Localization:GetString("458223")
    if self:CheckPowerTowerEff() then
      self:ShowPowerTowerEff()
    elseif self.powerTowerEff then
      self.powerTowerEff:SetActive(false)
    end
  end
  local statusM = false
  if self.endTime == nil and TemplateMgr:IsBuff(self.buildId) then
    statusM = true
    local buffTemplate = ActMgr:GetTemplateBuffById(detailInfo.BuffId)
    if buffTemplate ~= nil and not string.IsNullOrEmpty(buffTemplate.icon) then
      self.middle_icon:LoadSpriteAuto(buffTemplate.icon)
      self.middle_icon.size = Vector2.New(0.85, 0.85)
    end
    self.buffEndTime = detailInfo.BuffEndTime
    if self.buffEndTime > 100 and self.buffEndTime ~= self.lastBuffEndTime then
      do
        local curMs = UITimeManager:GetInstance():GetServerTime()
        local remainTime = self.buffEndTime * 1000 - curMs
        if remainTime < 1000 and 0 <= remainTime then
          self.lastBuffEndTime = self.buffEndTime
          self:DestroyTimer()
          self.delayTimer = TimerManager:GetInstance():DelayInvoke(function()
            self.delayTimer = nil
            self:ShowBuffEffect(buffTemplate.active_effect)
          end, remainTime / 1000)
        end
      end
    end
  end
  self.middle_root.gameObject:SetActive(statusM)
  if self.endTime == nil then
    self:HideProtectEffect()
  else
    self:ShowProtectEffect()
  end
  if self.endTime ~= nil or self.buffEndTime ~= nil then
    self:TimerAction()
    self:AddTimer()
  end
  self:FixWidth(self.status_text, self.statusRoot, 0.2)
end

function WorldEpidemicBuildUI:DestroyTimer()
  if self.delayTimer then
    self.delayTimer:Stop()
    self.delayTimer = nil
  end
end

function WorldEpidemicBuildUI:ShowBuffEffect(active_effect)
  local path = string.format(LoadPath.LWBattleFieldEpidemicEffectPath, active_effect)
  if not string.endswith(path, ".prefab") then
    path = path .. ".prefab"
  end
  local request = ResourceManager:InstantiateAsync(path)
  request:completed("+", function()
    if request.isError then
      return
    end
    local go = request.gameObject
    go:SetActive(true)
    local tf = go.transform
    tf:SetParent(CS.SceneManager.World.DynamicObjNode)
    tf:Set_localScale(1, 1, 1)
    tf.position = SceneUtils.TileIndexToWorld(self.pointId, ForceChangeScene.World)
    TimerManager:GetInstance():DelayInvoke(function()
      if IsNotNull(go) then
        go:SetActive(false)
      end
      if request ~= nil then
        request:Destroy()
      end
    end, 2)
  end)
end

function WorldEpidemicBuildUI:CheckPowerTowerEff()
  if not TemplateMgr:IsPowerTower(self.buildId) then
    return false
  end
  local detailInfo = self.detailInfo
  if detailInfo == nil or detailInfo.Role ~= EpidemicZoneRole.Lord then
    return false
  end
  return true
end

function WorldEpidemicBuildUI:ShowPowerTowerEff()
  if self.powerTowerEff ~= nil then
    self.powerTowerEff:SetActive(true)
    return
  end
  if self.PowerTowerEffRequest ~= nil then
    return
  end
  local request = ResourceManager:InstantiateAsync(string.format(LoadPath.LWBattleFieldEpidemicEffectPath, "Eff_daditu_anquanqu_hudun_01.prefab"))
  self.PowerTowerEffRequest = request
  request:completed("+", function()
    if request.isError then
      return
    end
    local go = request.gameObject
    self.powerTowerEff = go
    if not self:CheckPowerTowerEff() then
      go:SetActive(false)
      return
    end
    go:SetActive(true)
    local tf = go.transform
    tf:SetParent(CS.SceneManager.World.DynamicObjNode)
    tf:Set_localScale(1.2, 1, 1.2)
    local pos = SceneUtils.TileIndexToWorld(self.pointId, ForceChangeScene.World)
    pos.z = pos.z + 47
    tf.position = pos
  end)
end

function WorldEpidemicBuildUI:HidePowerTowerEff()
  if self.powerTowerEff then
    self.powerTowerEff:SetActive(false)
  end
  local request = self.PowerTowerEffRequest
  if request ~= nil then
    request:Destroy()
    self.PowerTowerEffRequest = nil
  end
  self.powerTowerEff = nil
end

function WorldEpidemicBuildUI:TimerAction()
  if self.buildId == self.SP_ID or self.config == nil then
    return
  end
  if self.endTime ~= nil then
    local curTime = UITimeMgr:GetServerSeconds()
    local remainTime = self.endTime - curTime
    if 0 < remainTime then
      self.status_text.text = Localization:GetString("458192") .. " " .. UITimeMgr:SecondToFmtString(remainTime)
    else
      self.status_text.text = Localization:GetString("458194")
      self.endTime = nil
      self:HideProtectEffect()
    end
  end
  if self.safeEndTime ~= nil then
    local curTime = UITimeMgr:GetServerSeconds()
    local remainTime = self.safeEndTime - curTime
    if 0 < remainTime then
      self.safe_time_text.text = UITimeManager:GetInstance():SecondToFmtString(remainTime)
      local percent = remainTime / self.config.safe_point_duration
      self:UpdateTimer(percent)
    else
      self:UpdateHead()
    end
  end
  if self.buffEndTime ~= nil and TemplateMgr:IsBuff(self.buildId) then
    local curSec = UITimeMgr:GetServerSeconds()
    local remainTime = math.max(self.buffEndTime - curSec, 0)
    self.middle_icon_text.text = UITimeMgr:SecondToFmtString(remainTime)
  end
end

function WorldEpidemicBuildUI:BSelf()
  if self.detailInfo == nil then
    return false
  end
  local curRole = self.detailInfo.Role
  local myRole = ActMgr:GetCurRole()
  return curRole == myRole
end

return WorldEpidemicBuildUI
