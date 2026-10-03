local HeatSourceCell = BaseClass("HeatSourceCell", UIBaseContainer)
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization
local icon_path = "icon"
local title_path = "title"
local desc_path = "desc"
local temp_path = "temp"

function HeatSourceCell:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
end

function HeatSourceCell:OnDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function HeatSourceCell:OnAddListener()
  base.OnAddListener(self)
end

function HeatSourceCell:OnRemoveListener()
  base.OnRemoveListener(self)
end

function HeatSourceCell:ComponentDefine()
  self.icon = self:AddComponent(UIImage, icon_path)
  self.title = self:AddComponent(UITextMeshProUGUIEx, title_path)
  self.desc = self:AddComponent(UITextMeshProUGUIEx, desc_path)
  self.temp = self:AddComponent(UITextMeshProUGUIEx, temp_path)
  self.bg = self:AddComponent(UIImage, "")
end

function HeatSourceCell:ComponentDestroy()
end

function HeatSourceCell:SetData(heatSource)
  local configId = heatSource.cfgId
  local config = DataCenter.HeatSourceTemplateManager:GetTemplate(configId)
  if config then
    self.icon:LoadSpriteAuto(config.icon)
    if config.type == HeatSourceType.PersonalStove then
      local state = DataCenter.BuildManager:GetFurnaceStateAndTemp()
      local title = Localization:GetString(config.name, config.level) .. " : " .. Localization:GetString(config:GetLangKeyByState(state))
      self.title:SetText(title)
    elseif config.type == HeatSourceType.AllianceStove then
      if heatSource.state and heatSource.abbr then
        local title = UIUtil.FormatAllianceAndName(heatSource.abbr, Localization:GetString(config.name, config.level)) .. " : " .. Localization:GetString(config:GetLangKeyByState(heatSource.state))
        self.title:SetText(title)
      end
    elseif config.type == HeatSourceType.City then
      local state = config:GetStateByTemperature(heatSource.temperature)
      local stateLangKey = config:GetLangKeyByState(state)
      local title
      if string.IsNullOrEmpty(stateLangKey) then
        title = Localization:GetString(config.name, config.level)
      else
        title = Localization:GetString(config.name, config.level) .. " : " .. Localization:GetString(stateLangKey)
      end
      self.title:SetText(title)
    else
      self.title:SetLocalText(config.name, config.level)
    end
    self.desc:SetLocalText(config.desc)
    self.temp:SetLocalText("season_s2_common_temperature", string.format("%.1f", heatSource.temperature))
    local textColor = heatSource.temperature > 0 and Color(0.53, 0.29, 0.1, 1) or Color(0.2, 0.35, 0.64, 1)
    local bgPath = heatSource.temperature > 0 and "Assets/Main/Sprites/UI/UITemperature/mjc_s2_wendu_poplist1_2.png" or "Assets/Main/Sprites/UI/UITemperature/mjc_s2_wendu_poplist1_1.png"
    self.title:SetColor(textColor)
    self.desc:SetColor(textColor)
    self.temp:SetColor(textColor)
    self.bg:LoadSprite(bgPath)
  end
end

return HeatSourceCell
