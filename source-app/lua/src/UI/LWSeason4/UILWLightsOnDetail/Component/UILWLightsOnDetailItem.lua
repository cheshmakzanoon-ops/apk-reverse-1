local UILWLightsOnDetailItem = BaseClass("UILWLightsOnDetailItem", UIBaseContainer)
local base = UIBaseContainer
local BuffIcon = require("UI.LWMainUI.Component.UIMainLeft.BuffIcon")
local text_level_path = "TextLevel"
local text_speed_path = "TextSpeed"
local text_size_path = "TextSize"
local text_unlock_path = "TextUnlock"
local list_buff_path = "ListBuff"
local buff_icon1_path = "ListBuff/BuffIcon1"
local buff_icon2_path = "ListBuff/BuffIcon2"
local buff_icon3_path = "ListBuff/BuffIcon3"
local buff_icon4_path = "ListBuff/BuffIcon4"

function UILWLightsOnDetailItem:OnCreate()
  base.OnCreate(self)
  self.text_level = self:AddComponent(UITextMeshProUGUIEx, text_level_path)
  self.text_speed = self:AddComponent(UITextMeshProUGUIEx, text_speed_path)
  self.text_size = self:AddComponent(UITextMeshProUGUIEx, text_size_path)
  self.text_unlock = self:AddComponent(UITextMeshProUGUIEx, text_unlock_path)
  self.list_buff = self:AddComponent(UIBaseContainer, list_buff_path)
  self.buff_icon1 = self:AddComponent(BuffIcon, buff_icon1_path)
  self.buff_icon2 = self:AddComponent(BuffIcon, buff_icon2_path)
  self.buff_icon3 = self:AddComponent(BuffIcon, buff_icon3_path)
  self.buff_icon4 = self:AddComponent(BuffIcon, buff_icon4_path)
end

function UILWLightsOnDetailItem:OnDestroy()
  self.text_level = nil
  self.text_speed = nil
  self.text_size = nil
  self.text_unlock = nil
  self.list_buff = nil
  self.buff_icon1 = nil
  self.buff_icon2 = nil
  self.buff_icon3 = nil
  self.buff_icon4 = nil
  base.OnDestroy(self)
end

local function OnBuffIconClick(cell)
  if ComponentIsValid(cell) then
    local data = cell.param
    if data and data.meta then
      local param = {}
      param.type = "nameDesc"
      param.title = data.meta.name
      param.desc = data.meta.description
      param.isLocal = false
      param.alignObject = cell
      UIManager:GetInstance():OpenWindow(UIWindowNames.UIItemTips, {anim = true}, param)
    end
  end
end

function UILWLightsOnDetailItem:ReInit(brightnessLevel)
  local cfg = LocalController:instance():getLine(TableName.LW_LIGHTS_ON_S4, brightnessLevel)
  if cfg then
    local buff_add = DataCenter.SeasonLightDataManager:GetBloodyNightElectricityUseBuff()
    local statusStr = cfg.status
    if string.IsNullOrEmpty(statusStr) then
      self.buff_icon1:SetActive(false)
      self.buff_icon2:SetActive(false)
      self.buff_icon3:SetActive(false)
      self.buff_icon4:SetActive(false)
    else
      local statusList = string.split_ss_array(statusStr, ";")
      local statusCount = #statusList
      self.buff_icon1:SetActive(0 < statusCount)
      self.buff_icon2:SetActive(1 < statusCount)
      self.buff_icon3:SetActive(2 < statusCount)
      self.buff_icon4:SetActive(3 < statusCount)
      for index, stateId in ipairs(statusList) do
        local stateMeta = LocalController:instance():getLine(TableName.StatusTab, stateId)
        if stateMeta and not string.IsNullOrEmpty(stateMeta.icon) and 0 < index and index < 5 then
          self["buff_icon" .. index]:ReInit({meta = stateMeta, OnClick = OnBuffIconClick})
        end
      end
    end
    local lightSize = toInt(cfg.size) * 2 + 1
    self.text_level:SetText("L" .. brightnessLevel)
    self.text_speed:SetText(UIUtil.GetMinuteSpeedStr((toInt(cfg.electricity_use) + buff_add) * -60))
    self.text_size:SetText(lightSize .. "\195\151" .. lightSize)
    self.text_unlock:SetText(tostring(DataCenter.SeasonPowerWorkerManager:GetBrightnessNeedBuildLevel(brightnessLevel)))
  end
end

return UILWLightsOnDetailItem
