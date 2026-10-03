local base = require("Scene.WorldBuildHeadUI.WorldBattleFieldBuildUIBase")
local WorldDragonBuildUI = BaseClass("WorldDragonBuildUI", base)
local Localization = CS.GameEntry.Localization

function WorldDragonBuildUI:OnCreate(go)
  base.OnCreate(self, go)
  self.SP_ID = 10110
end

function WorldDragonBuildUI:OnDragonBuildingChange(oldAllianceId, newAllianceId)
  if oldAllianceId == newAllianceId then
    return
  end
  local info = CS.SceneManager.World:GetPointInfo(self.pointId)
  if info ~= nil then
    self:ReInit(self.pointId, info)
  end
end

function WorldDragonBuildUI:OnDragonBuildingTopChange()
  self:UpdateHead()
end

function WorldDragonBuildUI:OnDragonAssistanceMarchPowerChanged()
  self:UpdateHead()
end

function WorldDragonBuildUI:UpdateHead()
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
    self.tip_a_text.text = string.GetFormattedGoldNum(math.floor(self.detailInfo.Score or 0))
  elseif state == 0 then
    pointV = true
    self.point_text.text = string.format("+%d/s", self.config.point_produce_per_second or 0)
    self.point_text.color32 = WorldWhiteColor32
  else
    topV = true
    local nowAId = detailInfo ~= nil and detailInfo.AllianceId or nil
    local bUp = DataCenter.ActDragonManager:GetBuildUpEffInfo(nowAId)
    local score = string.GetFormattedGoldNum(math.floor(detailInfo.OverflowScore or 0))
    local bestMarch, topInfo = DataCenter.ActDragonManager:GetBuildBestMarch(detailInfo.Uuid)
    if bestMarch then
      self.head_def.gameObject:SetActive(false)
      self.head_icon:SetData(bestMarch.ownerUid, bestMarch.pic, bestMarch.picVer)
      self.head_icon:SetData(bestMarch.ownerUid, bestMarch.pic, bestMarch.picVer)
      local x, _, z = self.head_icon.transform:Get_localPosition()
      self.head_icon.transform:Set_localPosition(x, 0.3, z)
      local curHp = topInfo.hp or 0
      local maxHp = topInfo.maxHp or curHp
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
    self:UpdateHeadSp(LuaEntry.Player:GetAllianceUid() == detailInfo.AllianceId)
    local curTime = UITimeManager:GetInstance():GetServerTime()
    local occupyTime = detailInfo.OccupyTime or 0
    local safe_point_duration = (self.config.safe_point_duration or 0) * 1000
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

function WorldDragonBuildUI:InitConfig()
  self.config = DataCenter.DragonBuildTemplateManager:GetTemplate(self.buildId)
end

function WorldDragonBuildUI:UpdateStatus()
  self.endTime = nil
  self.safeEndTime = nil
  self:DeleteTimer()
  self.bottomRoot.gameObject:SetActive(false)
  self.top_head.gameObject:SetActive(false)
  self.tip_a_root.gameObject:SetActive(false)
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
  local statusV = false
  if state == 0 then
    statusV = true
    local curTime = UITimeManager:GetInstance():GetServerTime()
    if curTime < detailInfo.OpenTime then
      self.endTime = detailInfo.OpenTime
    else
      self.status_text.text = Localization:GetString("458194")
    end
  elseif state == 3 then
    statusV = true
    self.status_text.text = Localization:GetString("458223")
  end
  self.statusRoot.gameObject:SetActive(statusV)
  if self.endTime == nil then
    self:HideProtectEffect()
  else
    self:TimerAction()
    self:AddTimer()
    self:ShowProtectEffect()
  end
  if statusV then
    self:FixWidth(self.status_text, self.statusRoot, 0.2)
  end
end

function WorldDragonBuildUI:TimerAction()
  if self.buildId == self.SP_ID or self.config == nil then
    return
  end
  if self.endTime ~= nil then
    local curTime = UITimeManager:GetInstance():GetServerTime()
    local remainTime = self.endTime - curTime
    if 0 < remainTime then
      self.status_text.text = Localization:GetString("458192") .. " " .. UITimeManager:GetInstance():MilliSecondToFmtString(remainTime)
    else
      self.status_text.text = Localization:GetString("458194")
      self.endTime = nil
      self:HideProtectEffect()
    end
  end
  if self.safeEndTime ~= nil then
    local curTime = UITimeManager:GetInstance():GetServerTime()
    local remainTime = self.safeEndTime - curTime
    if 0 < remainTime then
      self.safe_time_text.text = UITimeManager:GetInstance():MilliSecondToFmtString(remainTime)
      local safe_point_duration = (self.config.safe_point_duration or 0) * 1000
      local percent = remainTime / safe_point_duration
      self:UpdateTimer(percent)
    else
      self:UpdateHead()
    end
  end
end

return WorldDragonBuildUI
