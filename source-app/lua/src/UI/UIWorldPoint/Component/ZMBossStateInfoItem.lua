local ZMBossStateInfoItem = BaseClass("ZMBossStateInfoItem", UIBaseContainer)
local base = UIBaseContainer
local shield_slider_path = "ShieldSlider"
local frenzy_slider_path = "FrenzySlider"
local shield_icon_path = "ShieldSlider/ShieldIcon"
local frenzy_icon_path = "FrenzySlider/FrenzyIcon"
local BossState = {
  None = 0,
  Normal = 1,
  Shield = 2,
  Frenzy = 4
}

local function OnCreate(self)
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

local function OnDestroy(self)
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

local function OnEnable(self)
  base.OnEnable(self)
  self:AddTimer()
end

local function OnDisable(self)
  base.OnDisable(self)
  self:RemoveTimer()
end

local function ComponentDefine(self)
  self.root = self:AddComponent(UIBaseContainer, "")
  self.tipsText = self:AddComponent(UIText, "TipsText")
  self.shieldHpSlider = self:AddComponent(UISlider, "ShieldSlider/ShieldHpSlider")
  self.frenzySlider = self:AddComponent(UISlider, "FrenzySlider/FrenzySlider")
  self.shield_slider_node = self:AddComponent(UIBaseContainer, shield_slider_path)
  self.frenzy_slider_node = self:AddComponent(UIBaseContainer, frenzy_slider_path)
  self.shield_icon = self:AddComponent(UIImage, shield_icon_path)
  self.frenzy_icon = self:AddComponent(UIImage, frenzy_icon_path)
end

local function ComponentDestroy(self)
  self.root = nil
  self.tipsText = nil
  self.shieldHpSlider = nil
  self.frenzySlider = nil
  self.shield_slider_node = nil
  self.frenzy_slider_node = nil
  self.shield_icon = nil
  self.frenzy_icon = nil
end

local function DataDefine(self)
end

local function DataDestroy(self)
end

local function OnAddListener(self)
  base.OnAddListener(self)
  self:AddUIListener(EventId.OnZoneMobilizationBossMarchInfoChanged, self.RefreshItem)
end

local function OnRemoveListener(self)
  self:RemoveUIListener(EventId.OnZoneMobilizationBossMarchInfoChanged, self.RefreshItem)
  base.OnRemoveListener(self)
end

function ZMBossStateInfoItem:RefreshData(uuid)
  if uuid then
    local marchData = CS.SceneManager.World:GetMarch(uuid)
    if marchData then
      local zMBossInfo = marchData.zMBossInfo
      self.zMBossInfo = zMBossInfo
      local state = self:GetCurState()
      self.state = state
      self:RefreshCont(state)
      self.shield_icon:LoadSprite(string.format(LoadPath.LWUIZoneMobilizationSpritePath, "zyf_jiluofu_fangyu_icon"))
      self.frenzy_icon:LoadSprite(string.format(LoadPath.LWUIZoneMobilizationSpritePath, "zyf_jiluofu_kuangbao_icon"))
      return
    end
  end
  self.root:SetActive(false)
end

function ZMBossStateInfoItem:RefreshItem(uuid)
  if uuid then
    local marchData = CS.SceneManager.World:GetMarch(uuid)
    if marchData then
      local zMBossInfo = marchData.zMBossInfo
      self.zMBossInfo = zMBossInfo
      local state = self:GetCurState()
      if self.state ~= state then
        self.state = state
        self:RefreshCont(state)
      elseif state == BossState.Normal | BossState.Shield or state == BossState.Normal | BossState.Shield | BossState.Frenzy then
        self:RefreshShieldHpSlider(zMBossInfo)
      end
      return
    end
  end
  self.root:SetActive(false)
end

local function RefreshCont(self, state)
  local show = false
  local contextId = ""
  if state == BossState.Normal | BossState.Frenzy then
    show = true
    self.frenzy_slider_node:SetActive(true)
    self.shield_slider_node:SetActive(false)
    contextId = "zone_mobilization_shield"
  elseif state == BossState.Normal | BossState.Shield then
    show = true
    self.frenzy_slider_node:SetActive(false)
    self.shield_slider_node:SetActive(true)
    contextId = "zone_mobilization_frenzy"
  elseif state == BossState.Normal | BossState.Shield | BossState.Frenzy then
    show = true
    self.frenzy_slider_node:SetActive(true)
    self.shield_slider_node:SetActive(true)
    contextId = "zone_mobilization_frenzy"
  end
  self.root:SetActive(show)
  self.tipsText:SetLocalText(contextId)
  if show then
    local curTs = UITimeManager:GetInstance():GetServerTime()
    self:RefreshShieldHpSlider(self.zMBossInfo)
    self:RefreshFrenzySlider(curTs)
  end
end

local function RefreshShieldHpSlider(self, zMBossInfo)
  if zMBossInfo then
    local sliderValue = 0
    local shieldHp = zMBossInfo.shieldHp
    local shieldMaxHp = zMBossInfo.shieldMaxHp
    if shieldHp <= shieldMaxHp and 0 < shieldMaxHp then
      sliderValue = shieldHp / shieldMaxHp
      self.shieldHpSlider:SetValue(sliderValue)
    end
  end
end

local function RefreshFrenzySlider(self, curTs)
  if self.zMBossInfo and curTs then
    local sliderValue = 1
    local frenzyEndTime = self.zMBossInfo.frenzyEndTime
    local frenzyDuration = self.zMBossInfo.frenzyDuration * 1000
    if curTs <= frenzyEndTime and 0 < frenzyEndTime then
      sliderValue = (frenzyEndTime - curTs) / frenzyDuration
      self.frenzySlider:SetValue(sliderValue)
    end
  end
end

local function RemoveTimer(self)
  if self.timer ~= nil then
    self.timer:Stop()
    self.timer = nil
  end
end

local function AddTimer(self)
  if self.timer == nil then
    self.timer = TimerManager:GetInstance():GetTimer(1, BindCallback(self, self.RefreshTime), self, false, false, false)
  end
  self.timer:Start()
end

local function RefreshTime(self)
  if self.state == BossState.Normal | BossState.Frenzy or self.state == BossState.Normal | BossState.Shield | BossState.Frenzy then
    local curTs = UITimeManager:GetInstance():GetServerTime()
    self:RefreshFrenzySlider(curTs)
  end
end

local function GetCurState(self)
  if self.zMBossInfo then
    local shieldHp = self.zMBossInfo.shieldHp
    local shieldEndTime = self.zMBossInfo.shieldEndTime
    local frenzyEndTime = self.zMBossInfo.frenzyEndTime
    local state1 = 0 < shieldEndTime and 0 < shieldHp and BossState.Shield or 0
    local state2 = 0 < frenzyEndTime and BossState.Frenzy or 0
    local state = state1 | state2
    local stageType = DataCenter.LWZoneMobilizationManager:GetStageType(self.zMBossInfo.stage)
    local state3 = stageType == ZoneMobilizationStageType.Battle and BossState.Normal or BossState.None
    state = state | state3
    return state
  end
end

ZMBossStateInfoItem.OnCreate = OnCreate
ZMBossStateInfoItem.OnDestroy = OnDestroy
ZMBossStateInfoItem.OnEnable = OnEnable
ZMBossStateInfoItem.OnDisable = OnDisable
ZMBossStateInfoItem.ComponentDefine = ComponentDefine
ZMBossStateInfoItem.ComponentDestroy = ComponentDestroy
ZMBossStateInfoItem.DataDefine = DataDefine
ZMBossStateInfoItem.DataDestroy = DataDestroy
ZMBossStateInfoItem.OnAddListener = OnAddListener
ZMBossStateInfoItem.OnRemoveListener = OnRemoveListener
ZMBossStateInfoItem.RefreshShieldHpSlider = RefreshShieldHpSlider
ZMBossStateInfoItem.RefreshFrenzySlider = RefreshFrenzySlider
ZMBossStateInfoItem.AddTimer = AddTimer
ZMBossStateInfoItem.RemoveTimer = RemoveTimer
ZMBossStateInfoItem.RefreshTime = RefreshTime
ZMBossStateInfoItem.GetCurState = GetCurState
ZMBossStateInfoItem.RefreshCont = RefreshCont
return ZMBossStateInfoItem
