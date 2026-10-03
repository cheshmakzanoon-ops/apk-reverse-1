local base = require("Scene.WorldBuildHeadUI.WorldBattleFieldBuildUIBase")
local WorldWinterStormBuildUI = BaseClass("WorldWinterStormBuildUI", base)
local Localization = CS.GameEntry.Localization
local MyAbs = math.abs

function WorldWinterStormBuildUI:RefreshHead()
  self:ReInitInfo()
  local detailInfo = self.detailInfo
  if detailInfo == nil then
    return
  end
  local mySide = DataCenter.ActWinterStormManager:GetMySide()
  local side = detailInfo.Side
  if side ~= 0 then
    side = side == mySide and 2 or 1
  end
  if self.config and self.config:IsBuild() then
    local score = DataCenter.ActWinterStormManager:GetBuildScore(self.buildUUID)
    self:UpdateHead(side, score)
  else
    self:UpdateHead(side, self.config and self.config.point_init or 0)
  end
end

function WorldWinterStormBuildUI:UpdateHead(side, score)
  self.pointRoot.gameObject:SetActive(true)
  self.safeRoot.gameObject:SetActive(false)
  local topV = false
  if side ~= 0 then
    topV = true
    local info = DataCenter.ActWinterStormManager:GetBuildBestMarch(self.buildUUID)
    local ownerUid = info ~= nil and info.uid or nil
    local teamArr = DataCenter.ActWinterStormManager:GetTeamArr(ownerUid)
    if teamArr ~= nil then
      self.head_def.gameObject:SetActive(false)
      self.head_icon:SetData(teamArr.uid, teamArr.head, teamArr.frame)
      local x, _, z = self.head_icon.transform:Get_localPosition()
      self.head_icon.transform:Set_localPosition(x, 0.3, z)
      self.top_progress.gameObject:SetActive(true)
      local hpPercent = info ~= nil and info.totalHp and 0 < info.totalHp and info.currentHp / info.totalHp or 1
      self:UpdateHp(hpPercent)
    else
      local x, _, z = self.head_icon.transform:Get_localPosition()
      self.head_icon.transform:Set_localPosition(x, 0.15, z)
      self.head_def.gameObject:SetActive(true)
      self.top_progress.gameObject:SetActive(false)
    end
    if self.config and self.config:IsBuild() then
      self.point_text.text = score
    else
      self.point_text.text = "+" .. score
    end
    self:UpdateHeadSp(side == 2, true)
  else
    self.point_text.text = string.format("+%d/s", self.config and self.config.point_produce_per_second or 0)
  end
  self:FixPos(self.point_text, self.point_flag, nil, 0.3, 0.25)
  return topV
end

function WorldWinterStormBuildUI:UpdateLastOccupy(detailInfo)
  local lastOccupyTime = detailInfo.LastOccupyTime
  if lastOccupyTime == nil or lastOccupyTime == 0 then
    return false
  end
  if detailInfo.State ~= WinterEntityState.Waiting then
    return false
  end
  if self.config then
    local tmpNum = MyAbs(lastOccupyTime)
    self.middle_text.text = self.config.occupy_time - tmpNum .. "s"
  end
  return true
end

function WorldWinterStormBuildUI:ShowTopNum(topV)
  if self.config == nil or self.config:IsBuild() or topV then
    return
  end
  local str = ""
  if self.config:IsBuild() then
    str = string.format("+%d/s", self.config.point_produce_per_second)
  elseif self.config:IsScoreBox() then
    local score = DataCenter.ActWinterStormManager:GetBuildScore(self.buildUUID)
    str = "+" .. score
  else
    str = "+" .. self.config.point_init
  end
  self.tip_a_root.gameObject:SetActive(true)
  self.tip_a_text.text = str
  self:FixPos(self.tip_a_text, self.tip_a_img, self.tip_a_bg_img, 0.3, 0.25)
end

function WorldWinterStormBuildUI:InitConfig()
  self.config = DataCenter.WinterStormTemplateManager:GetTemplate(self.buildId)
end

function WorldWinterStormBuildUI:UpdateStatus()
  local detailInfo = self.detailInfo
  self.endTime = nil
  self.bottomRoot.gameObject:SetActive(false)
  self.statusRoot.gameObject:SetActive(false)
  self.middle_text.gameObject:SetActive(false)
  self.top_head.gameObject:SetActive(false)
  self.tip_a_root.gameObject:SetActive(false)
  if detailInfo == nil then
    return
  end
  local mySide = DataCenter.ActWinterStormManager:GetMySide()
  local state = detailInfo.State
  local side = detailInfo.Side
  if side ~= 0 then
    side = side == mySide and 2 or 1
  end
  local bottomV = false
  local statusV = false
  local middleV = false
  local score
  if self.config and self.config:IsBuild() then
    bottomV = true
    if state == WinterEntityState.Occupied then
      score = DataCenter.ActWinterStormManager:GetBuildScore(self.buildUUID)
    elseif state == WinterEntityState.Fixing then
      local openTime = detailInfo.OpenTime
      if openTime ~= nil and 0 < openTime then
        statusV = true
        self.endTime = detailInfo.OpenTime
      end
    end
  else
    if state == WinterEntityState.Normal and side == 0 and self:UpdateLastOccupy(detailInfo, mySide) then
      middleV = true
    end
    if side ~= 0 then
      local efTime = detailInfo.EventFinishTime
      if efTime ~= nil and 0 < efTime then
        self.endTime = efTime
        middleV = true
      end
    end
    score = self.config and self.config.point_init or 0
  end
  local topV = self:UpdateHead(side, score)
  self.top_head.gameObject:SetActive(topV)
  self:ShowTopNum(topV)
  self.bottomRoot.gameObject:SetActive(bottomV)
  self.statusRoot.gameObject:SetActive(statusV)
  self.middle_text.gameObject:SetActive(middleV)
  if self.endTime == nil then
    self:TimerAction()
    self:AddTimer()
  end
  if self.detailInfo.State ~= WinterEntityState.Fixing then
    self:HideProtectEffect()
  else
    self:ShowProtectEffect()
  end
  if statusV then
    self:FixWidth(self.status_text, self.statusRoot, 0.4)
  end
end

function WorldWinterStormBuildUI:TimerAction()
  if self.endTime == nil then
    self.status_text.text = ""
    return
  end
  local curTime = UITimeManager:GetInstance():GetServerSeconds()
  local remainTime = self.endTime - curTime
  if 0 < remainTime then
    if self.config and self.config:IsBuild() then
      local str = UITimeManager:GetInstance():SecondToFmtStringWithoutHour(remainTime)
      if self.detailInfo.State == WinterEntityState.Fixing then
        str = Localization:GetString("winter_battlefield_entity_fix_tip1001") .. str
      elseif self.config.type == DataCenter.WinterStormTemplateManager:GetCenterType() then
        str = Localization:GetString("winter_battlefield_entity_fix_tip1002") .. str
      end
      self.status_text.text = str
    elseif self.detailInfo.State == WinterEntityState.Waiting or self.detailInfo.State == WinterEntityState.Occupying then
      self.middle_text.gameObject:TryActive(true)
      self.middle_text.text = remainTime .. "s"
    end
  end
end

function WorldWinterStormBuildUI:BSelf()
  if self.detailInfo == nil then
    return false
  end
  local curSide = self.detailInfo.Side
  local mySide = DataCenter.ActWinterStormManager:GetMySide()
  return curSide == mySide
end

return WorldWinterStormBuildUI
