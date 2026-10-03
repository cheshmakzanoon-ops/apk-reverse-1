local UIZoneMobilizationNameItem = BaseClass("UIZoneMobilizationNameItem", UIBaseContainer)
local base = UIBaseContainer
local LevelIconPath = "Assets/Main/Sprites/UI/LWUIZoneMobilization/%s.png"
local title_text_path = "TitleText"
local level_icon_path = "LevelIcon"
local red_point_path = "RedPoint"
local DefaultColor = "ffffff"
local RedColor = "f97077"
local eff_ui_zone_icon_loop_path = "LevelIcon/Eff_ui_zone_icon_loop"
local eff_ui_zone_icon_loop_red_path = "LevelIcon/Eff_ui_zone_icon_loop_red"
local eff_ui_zone_icon_switch_path = "Eff_ui_zone_icon_switch"

function UIZoneMobilizationNameItem:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function UIZoneMobilizationNameItem:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UIZoneMobilizationNameItem:ComponentDefine()
  self.title_text = self:AddComponent(UITextMeshProUGUIEx, title_text_path)
  self.level_icon = self:AddComponent(UIImage, level_icon_path)
  self.click = self:AddComponent(UIButton, level_icon_path)
  self.click:SetOnClick(BindCallback(self, self.OnIconClick))
  self.red_point = self:AddComponent(UIImage, red_point_path)
  self.eff_ui_zone_icon_loop = self:AddComponent(UIBaseContainer, eff_ui_zone_icon_loop_path)
  self.eff_ui_zone_icon_loop_red = self:AddComponent(UIBaseContainer, eff_ui_zone_icon_loop_red_path)
  self.eff_ui_zone_icon_switch = self:AddComponent(UIBaseContainer, eff_ui_zone_icon_switch_path)
  self.anim = self:AddComponent(UIAnimator, "")
  self.anim:Enable(false)
end

function UIZoneMobilizationNameItem:ComponentDestroy()
  if self.anim then
    self.anim:Enable(false)
  end
  if self.click then
    self.click:SetEnable(true)
  end
  if self.eff_ui_zone_icon_switch then
    self.eff_ui_zone_icon_switch:SetActive(false)
  end
  self.title_text = nil
  self.level_icon = nil
  self.click = nil
  self.red_point = nil
  self.eff_ui_zone_icon_loop = nil
  self.eff_ui_zone_icon_loop_red = nil
  self.eff_ui_zone_icon_switch = nil
  self.anim = nil
end

function UIZoneMobilizationNameItem:OnAddListener()
  base.OnAddListener(self)
  self:AddListeners()
end

function UIZoneMobilizationNameItem:OnRemoveListener()
  self:RemoveListeners()
  base.OnRemoveListener(self)
end

function UIZoneMobilizationNameItem:AddListeners()
  self:AddUIListener(EventId.GetZoneMobilizationInfoData, self.OnBossIdChanged)
end

function UIZoneMobilizationNameItem:RemoveListeners()
  self:RemoveUIListener(EventId.GetZoneMobilizationInfoData, self.OnBossIdChanged)
end

function UIZoneMobilizationNameItem:DataDefine()
  self.bossId = nil
  self.timer = nil
  self.index = nil
end

function UIZoneMobilizationNameItem:DataDestroy()
  self.bossId = nil
  if self.timer then
    self.timer:Stop()
    self.timer = nil
  end
  if self.animTimer then
    self.animTimer:Stop()
    self.animTimer = nil
  end
  self.index = nil
end

function UIZoneMobilizationNameItem:ReInit(show, bossId, index, server, showRedPoint)
  self.index = index
  if bossId == nil or bossId == 0 then
    show = false
  end
  if show then
    if self.bossId then
      if self.bossId ~= bossId then
        self:RefreshNameText(bossId, index, server)
        self.bossId = bossId
        self:OnBossIdChanged()
      end
    elseif self.bossId ~= bossId then
      self:RefreshNameText(bossId, index, server)
      self.bossId = bossId
      self:RefreshIcon(bossId, index)
    end
  end
  self.anim:SetActive(show)
  self:RefreshRedPoint(showRedPoint)
end

function UIZoneMobilizationNameItem:RefreshNameText(bossId, index, server)
  index = index or 1
  local color = DefaultColor
  if index == 2 then
    color = RedColor
  end
  self:SetNameText(bossId, server, color)
end

function UIZoneMobilizationNameItem:SetNameText(bossId, serverId, color)
  if bossId then
    local bossData = LocalController:instance():getLine(TableName.ZoneMobilizationBoss, bossId)
    if bossData then
      self.title_text:SetLocalText(bossData:getValue("building_name"))
    end
  end
end

function UIZoneMobilizationNameItem:OnBossIdChanged()
  local oldBossId = DataCenter.LWZoneMobilizationManager.oldBossId
  local bossId = DataCenter.LWZoneMobilizationManager.bossId
  self:RefreshIcon(oldBossId, index)
  if oldBossId ~= bossId then
    self:PlaySwitchAnim()
    if self.timer then
      self.timer:Stop()
      self.timer = nil
    end
    self.timer = TimerManager:GetInstance():DelayInvoke(function()
      self:RefreshIcon(bossId, self.index)
      self.timer:Stop()
      self.timer = nil
    end, 0.3)
    DataCenter.LWZoneMobilizationManager:UpdateOldBossId()
  end
end

function UIZoneMobilizationNameItem:RefreshIcon(bossId, index)
  if bossId and 0 < bossId then
    local bossData = LocalController:instance():getLine(TableName.ZoneMobilizationBoss, bossId)
    if bossData then
      local icons = bossData:getValue("progress_score_icon", "")
      if not string.IsNullOrEmpty(icons) then
        local iconArr = string.split(icons, "|")
        index = index or 1
        if iconArr and index <= #iconArr then
          self.level_icon:LoadSprite(string.format(LevelIconPath, iconArr[index]))
        end
        if index == 1 then
          self.eff_ui_zone_icon_loop:SetActive(true)
          self.eff_ui_zone_icon_loop_red:SetActive(false)
        else
          self.eff_ui_zone_icon_loop:SetActive(false)
          self.eff_ui_zone_icon_loop_red:SetActive(true)
        end
      end
    end
  end
end

function UIZoneMobilizationNameItem:RefreshRedPoint(show)
  show = show and DataCenter.LWZoneMobilizationManager:GetBossLevelRedPoint()
  self.red_point:SetActive(show)
end

function UIZoneMobilizationNameItem:OnIconClick()
  UIManager:GetInstance():OpenWindow(UIWindowNames.UIZoneMobilizationPointsHelp, DataCenter.LWZoneMobilizationManager.stage, self.bossId, self.index == 2)
  DataCenter.LWZoneMobilizationManager:SetBossLevelRedPoint()
  self.red_point:SetActive(false)
end

function UIZoneMobilizationNameItem:PlaySwitchAnim()
  if self.anim then
    self.click:SetEnable(false)
    self.anim:Enable(true)
    self.anim.speed = 1
    self.anim:Play("V_ui_NameGroup_switch", 0, 0)
    self.anim.speed = 0
    if self.animTimer then
      self.animTimer:Stop()
      self.animTimer = nil
    end
    self.animTimer = TimerManager:GetInstance():DelayInvoke(function()
      if self.anim then
        self.anim:Enable(false)
      end
      if self.click then
        self.click:SetEnable(true)
      end
      self.animTimer:Stop()
      self.animTimer = nil
      if self.eff_ui_zone_icon_switch then
        self.eff_ui_zone_icon_switch:SetActive(false)
      end
    end, 1.717)
  end
end

return UIZoneMobilizationNameItem
