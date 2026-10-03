local base = UIButton
local LWSeasonUpgradeLog = BaseClass("LWSeasonUpgradeLog", base)

function LWSeasonUpgradeLog:OnCreate()
  base.OnCreate(self)
  self.icon_upgrade_log = self:AddComponent(UIImage, "IconUpgradeLog")
  self:SetOnClick(Bind(self, self.OnClickedUpgradeLog))
end

function LWSeasonUpgradeLog:OnDestroy()
  if ComponentIsValid(self.icon_upgrade_log) then
    TweenUtil.Kill(self.icon_upgrade_log.transform)
  end
  self.icon_upgrade_log = nil
  base.OnDestroy(self)
end

function LWSeasonUpgradeLog:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.LWSeasonUpgradeLogClosed, self.OnUpgradeLogClosed)
end

function LWSeasonUpgradeLog:OnRemoveListener()
  self:RemoveUIListener(EventId.LWSeasonUpgradeLogClosed, self.OnUpgradeLogClosed)
  base.OnRemoveListener(self)
end

function LWSeasonUpgradeLog:RefreshSeasonUpgradeState()
  self.papaPlayerFace = nil
  if not self.icon_upgrade_log or not SeasonUtil.IsInSeason(true) then
    self:SetActive(false)
    return
  end
  local mgr = DataCenter.SeasonUpgradeLogManager
  local logs = mgr:GetCurrentUpgradeLog()
  if logs and 0 < #logs then
    self:SetActive(true)
    self.icon_upgrade_log:SetLocalScaleXYZ(1, 1, 1)
    self.papaPlayerFace = mgr:CheckHasNew()
    if self.papaPlayerFace then
      self:OpenSeasonUpgradeLogPanel(self.papaPlayerFace)
    end
  else
    self:SetActive(false)
  end
end

function LWSeasonUpgradeLog:OnClickedUpgradeLog()
  self:OpenSeasonUpgradeLogPanel(false)
end

function LWSeasonUpgradeLog:OpenSeasonUpgradeLogPanel(papaPlayerFace)
  local server, season = DataCenter.SeasonUpgradeLogManager:GetCurrentServerAndSeason()
  UIManager:GetInstance():OpenWindow(UIWindowNames.UILWSeasonUpgradeLog, {anim = true}, {
    season = season,
    server = server,
    papaPlayerFace = papaPlayerFace
  })
end

function LWSeasonUpgradeLog:OnUpgradeLogClosed()
  if self.papaPlayerFace then
    if ComponentIsValid(self.icon_upgrade_log) then
      TweenUtil.PlayAnimCollectUI(self.icon_upgrade_log.transform, 1.2, 1, 0.3, 0.1, 0.5, 0.2)
    end
    self.papaPlayerFace = nil
  end
end

return LWSeasonUpgradeLog
