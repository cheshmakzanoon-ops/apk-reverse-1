local UIPVEBattleBuffItem = BaseClass("UIPVEBattleBuffItem", UIBaseContainer)
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization
local this_path = ""
local bg_path = "Bg"
local txt_path = "Txt"
local icon_path = "Icon"
local count_bg_path = "CountBg"
local count_path = "CountBg/Count"

local function OnCreate(self)
  base.OnCreate(self)
  self:DataDefine()
  self:ComponentDefine()
end

local function OnDestroy(self)
  self:ComponentDestroy()
  self:DataDestroy()
  base.OnDestroy(self)
end

local function ComponentDefine(self)
  self.btn = self:AddComponent(UIButton, this_path)
  self.btn:SetOnClick(function()
    self:OnClick()
  end)
  self.bg_image = self:AddComponent(UIImage, bg_path)
  self.txt = self:AddComponent(UIText, txt_path)
  self.icon_image = self:AddComponent(UIImage, icon_path)
  self.count_bg_go = self:AddComponent(UIBaseContainer, count_bg_path)
  self.count_text = self:AddComponent(UIText, count_path)
end

local function ComponentDestroy(self)
  self.btn = nil
  self.bg_image = nil
  self.txt = nil
  self.icon_image = nil
  self.count_bg_go = nil
  self.count_text = nil
end

local function DataDefine(self)
  self.data = nil
  self.descStr = ""
  self.valStr = ""
end

local function DataDestroy(self)
  self.data = nil
  self.descStr = nil
  self.valStr = nil
end

local function OnEnable(self)
  base.OnEnable(self)
end

local function OnDisable(self)
  base.OnDisable(self)
end

local function SetData(self, data)
  self.data = data
  local desc = GetTableData(TableName.EffectNumDesc, data.buff, "des")
  local descStr = Localization:GetString(desc)
  local valStr = CommonUtil.GetValueWithLocalType(data.val, data.localType)
  self.txt:SetText(valStr)
  self.icon_image:LoadSprite(string.format(LoadPath.UIPveBattleBuff, data.icon))
  self.descStr = descStr
  self.valStr = valStr
  if data.timeType == BattleBuffTimeType.Normal then
    self.bg_image:SetFillAmount(1)
    self.count_bg_go:SetActive(false)
  elseif data.timeType == BattleBuffTimeType.Battle then
    self.bg_image:SetFillAmount(1)
    self.count_bg_go:SetActive(true)
    self.count_text:SetText(data.total - data.usedCount)
  elseif data.timeType == BattleBuffTimeType.Time then
    local curTime = UITimeManager:GetInstance():GetServerTime()
    self.restTime = total * 1000 - (curTime - data.startTime)
    self:OnUpdate(0)
    self.count_bg_go:SetActive(false)
  end
end

local function OnUpdate(self, deltaTime)
  if self.data.timeType == BattleBuffTimeType.Time then
    self.restTime = self.restTime - deltaTime
    if self.restTime >= 0 then
      local percent = self.restTime / (self.data.total * 1000)
      self.bg_image:SetFillAmount(percent)
    else
      EventManager:GetInstance():Broadcast(EventId.PveBattleBuffRefresh)
    end
  end
end

local function OnClick(self)
  local param = {}
  param.itemName = ""
  param.itemDesc = self.descStr .. " " .. self.valStr
  param.alignObject = self
  param.isLocal = true
  param.showArrow = false
  UIManager:GetInstance():OpenWindow(UIWindowNames.UIItemTips, {anim = true}, param)
end

UIPVEBattleBuffItem.OnCreate = OnCreate
UIPVEBattleBuffItem.OnDestroy = OnDestroy
UIPVEBattleBuffItem.ComponentDefine = ComponentDefine
UIPVEBattleBuffItem.ComponentDestroy = ComponentDestroy
UIPVEBattleBuffItem.DataDefine = DataDefine
UIPVEBattleBuffItem.DataDestroy = DataDestroy
UIPVEBattleBuffItem.OnEnable = OnEnable
UIPVEBattleBuffItem.OnDisable = OnDisable
UIPVEBattleBuffItem.SetData = SetData
UIPVEBattleBuffItem.OnUpdate = OnUpdate
UIPVEBattleBuffItem.OnClick = OnClick
return UIPVEBattleBuffItem
