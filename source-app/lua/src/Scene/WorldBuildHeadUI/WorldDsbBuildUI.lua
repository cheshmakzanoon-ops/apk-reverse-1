local base = require("Scene.WorldBuildHeadUI.WorldBattleFieldBuildUIBase")
local WorldDsbBuildUI = BaseClass("WorldDsbBuildUI", base)
local Localization = CS.GameEntry.Localization
local SP_PATH_NOBODY = string.format(LoadPath.LWBattleFieldDsbDuelPath, "lrb_zhanchangjifen_wurenzhanling.png")
local ResourceManager = CS.GameEntry.Resource

function WorldDsbBuildUI:OnCreate(go)
  base.OnCreate(self, go)
  self.SP_ID = 10110
  self.head_none:LoadSpriteAuto(SP_PATH_NOBODY)
  self.lastBuffEndTime = nil
end

function WorldDsbBuildUI:OnDestroy()
  base.OnDestroy(self)
  self:DestroyTimer()
end

function WorldDsbBuildUI:OnDragonBuildingChange(oldAllianceId, newAllianceId)
end

function WorldDsbBuildUI:OnDragonBuildingTopChange()
  self:UpdateHead()
end

function WorldDsbBuildUI:OnDragonAssistanceMarchPowerChanged()
  self:UpdateHead()
end

function WorldDsbBuildUI:UpdateHead()
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
  local role = detailInfo.Role
  local myRole = BattlefieldDsbDuelUtils.GetMyRoleId()
  local tipV, topV, pointV, safeV = false, false, false, false
  local locked = false
  local curTime = UITimeManager:GetInstance():GetServerSeconds()
  locked = state == BattlefieldBuildState.Normal and curTime < detailInfo.OpenTime
  if self.config and self.config:IsScoreBox() then
    tipV = true
    self.tip_a_text.text = string.GetFormattedGoldNum(math.floor(self.detailInfo.Score or 0))
  elseif locked then
    pointV = true
    self.point_text.text = string.format("+%d/s", self.config.point_produce_per_second or 0)
    self.point_text.color32 = WorldWhiteColor32
  else
    topV = true
    local bUp = role == myRole and self.mgr:GetBuildUpEffInfo()
    local score = string.GetFormattedGoldNum(math.floor(detailInfo.OverflowScore or 0))
    local bestMarch, topInfo = self.mgr:GetBuildBestMarch(detailInfo.Uuid)
    if bestMarch then
      self.head_def.gameObject:SetActive(false)
      self.head_icon:SetData(bestMarch.ownerUid, bestMarch.pic, bestMarch.picVer)
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
    self:UpdateHeadSp(role)
    local curTime = UITimeManager:GetInstance():GetServerSeconds()
    local occupyTime = detailInfo.OccupyTime or 0
    local safe_point_duration = self.config.safe_point_duration or 0
    if curTime < occupyTime + safe_point_duration then
      safeV = true
      self.safe_text.text = string.format("+%d/s", self.config.point_produce_per_second or 0)
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

function WorldDsbBuildUI:UpdateHeadSp(role)
  local color = BattlefieldDsbDuelUtils.GetColorByRoleType(role, true)
  local pathHeadBg, pathArrow, pathPointBg, barBg
  if not color then
    return
  else
    pathHeadBg = color.battlefieldHeadBg
    pathArrow = color.battlefieldHeadArrow
    pathPointBg = color.battlefieldPointBg
    barBg = color.battlefieldProgressBar
  end
  self.top_bg:LoadSpriteAuto(string.format(LoadPath.LWBattleFieldDsbDuelWorldPath, pathHeadBg))
  if self.pointRoot.gameObject.activeSelf then
    self.pointRoot:LoadSpriteAuto(string.format(LoadPath.LWBattleFieldDsbDuelWorldPath, pathPointBg))
  end
  if self.safeRoot.gameObject.activeSelf then
    self.safe_progress:LoadSpriteAuto(string.format(LoadPath.LWBattleFieldDsbDuelWorldPath, barBg))
  end
  self.top_arrow:LoadSpriteAuto(string.format(LoadPath.LWBattleFieldDsbDuelWorldPath, pathArrow))
end

function WorldDsbBuildUI:InitConfig()
  self.config = BattleFieldUtil.GetBattlefieldBuildTemplate(self.buildId)
  self.mgr = BattleFieldUtil.GetMgrActive()
  self.templateMgr = BattleFieldUtil.GetTemplateMgrActive()
end

function WorldDsbBuildUI:IsScorePoint()
  return self.config and self.config:IsScoreBox()
end

function WorldDsbBuildUI:UpdateStatus()
  self.endTime = nil
  self.safeEndTime = nil
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
  if self:IsScorePoint() then
    self.statusRoot.gameObject:SetActive(false)
    return
  end
  local statusV = false
  if state == BattlefieldBuildState.Normal then
    statusV = true
    local curTime = UITimeManager:GetInstance():GetServerSeconds()
    if curTime < detailInfo.OpenTime then
      self.endTime = detailInfo.OpenTime
    else
      self.status_text.text = Localization:GetString("458194")
    end
  elseif state == BattlefieldBuildState.Occupied then
    statusV = true
    self.status_text.text = Localization:GetString("458223")
  end
  self:UpdateBuff(detailInfo)
  self.statusRoot.gameObject:SetActive(statusV)
  if self.endTime == nil then
    self:HideProtectEffect()
  else
    self:ShowProtectEffect()
  end
  if self.endTime ~= nil or self.buffEndTime ~= nil then
    self:TimerAction()
    self:AddTimer()
  end
  if statusV then
    self:FixWidth(self.status_text, self.statusRoot, 0.2)
  end
end

function WorldDsbBuildUI:DestroyTimer()
  if self.delayTimer then
    self.delayTimer:Stop()
    self.delayTimer = nil
  end
end

function WorldDsbBuildUI:UpdateBuff(detailInfo)
  local statusM = false
  if self.endTime == nil and self.config and self.config:IsBuff() then
    statusM = true
    local buffTemplate = self.templateMgr:GetBuffTemplate(detailInfo.BuffId)
    if buffTemplate ~= nil and not string.IsNullOrEmpty(buffTemplate.icon) then
      self.middle_icon:LoadSpriteAuto(buffTemplate.icon)
      self.middle_icon.size = Vector2.New(0.85, 0.85)
    end
    self.buffEndTime = detailInfo.BuffEndTime or 0
    if self.buffEndTime > 100 and self.buffEndTime ~= self.lastBuffEndTime then
      do
        local curMs = UITimeManager:GetInstance():GetServerTime()
        local remainTime = self.buffEndTime * 1000 - curMs
        if remainTime < 1000 and 0 <= remainTime then
          self.lastBuffEndTime = self.buffEndTime
          self:DestroyTimer()
          self.delayTimer = TimerManager:GetInstance():DelayInvoke(function()
            self:ShowBuffEffect(buffTemplate.active_effect)
          end, remainTime / 1000)
        end
      end
    end
  end
  self.middle_root.gameObject:SetActive(statusM)
end

function WorldDsbBuildUI:ShowBuffEffect(active_effect)
  self:DestroyTimer()
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

function WorldDsbBuildUI:TimerAction()
  if self:IsScorePoint() then
    return
  end
  if self.endTime ~= nil then
    local curTime = UITimeManager:GetInstance():GetServerSeconds()
    local remainTime = self.endTime - curTime
    if 0 < remainTime then
      self.status_text.text = Localization:GetString("458192") .. " " .. UITimeManager:GetInstance():MilliSecondToFmtStringWithoutHour(remainTime * 1000)
    else
      self.status_text.text = Localization:GetString("458194")
      self.endTime = nil
      self:HideProtectEffect()
    end
  end
  if self.safeEndTime ~= nil then
    local curTime = UITimeManager:GetInstance():GetServerSeconds()
    local remainTime = self.safeEndTime - curTime
    if 0 < remainTime then
      self.safe_time_text.text = UITimeManager:GetInstance():MilliSecondToFmtStringWithoutHour(remainTime * 1000)
      local safe_point_duration = self.config.safe_point_duration or 0
      local percent = remainTime / safe_point_duration
      self:UpdateTimer(percent)
    else
      self:UpdateHead()
    end
  end
  if self.buffEndTime ~= nil and self.config and self.config:IsBuff() then
    local curSec = UITimeManager:GetInstance():GetServerSeconds()
    local remainTime = math.max(self.buffEndTime - curSec, 0)
    self.middle_icon_text.text = UITimeManager:GetInstance():SecondToFmtStringWithoutHour(remainTime)
  end
end

function WorldDsbBuildUI:OnRoleChanged(role)
  self:UpdateHead()
end

return WorldDsbBuildUI
