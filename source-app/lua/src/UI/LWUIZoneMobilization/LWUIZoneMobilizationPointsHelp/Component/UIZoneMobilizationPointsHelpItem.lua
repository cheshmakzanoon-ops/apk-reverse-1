local UIZoneMobilizationPointsHelpItem = BaseClass("UIZoneMobilizationPointsHelpItem", UIBaseContainer)
local base = UIBaseContainer
local LevelIconPath = "Assets/Main/Sprites/UI/LWUIZoneMobilization/%s.png"
local level_icon_path = "LevelIcon"
local bg_path = "Bg"

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
end

local function OnDisable(self)
  base.OnDisable(self)
end

local function ComponentDefine(self)
  self.level_icon = self:AddComponent(UIImage, level_icon_path)
  self.textNeedPoint = self:AddComponent(UIText, "NeedPointText")
  self.textHp = self:AddComponent(UIText, "HpText")
  self.textDamage = self:AddComponent(UIText, "DamageText")
  self.bg = self:AddComponent(UIBaseContainer, bg_path)
end

local function ComponentDestroy(self)
  self.level_icon = nil
  self.textNeedPoint = nil
  self.textHp = nil
  self.textDamage = nil
  self.bg = nil
end

local function DataDefine(self)
end

local function DataDestroy(self)
end

local function SetData(self, bossId, score, isRed)
  if bossId then
    local bossData = LocalController:instance():getLine(TableName.ZoneMobilizationBoss, bossId)
    if bossData then
      self.textDamage:SetText(bossData:getValue("para1"))
      self.textHp:SetText(bossData:getValue("rallyboss_hp"))
      local icons = bossData:getValue("progress_score_icon", "")
      if not string.IsNullOrEmpty(icons) then
        local iconArr = string.split(icons, "|")
        local index = isRed and 2 or 1
        if iconArr and index <= #iconArr then
          self.level_icon:LoadSprite(string.format(LevelIconPath, iconArr[index]))
        end
      end
    end
  end
  if score then
    self.textNeedPoint:SetText(score)
  end
end

local function SetBgShow(self, active)
  self.bg:SetActive(active)
end

UIZoneMobilizationPointsHelpItem.OnCreate = OnCreate
UIZoneMobilizationPointsHelpItem.OnDestroy = OnDestroy
UIZoneMobilizationPointsHelpItem.OnEnable = OnEnable
UIZoneMobilizationPointsHelpItem.OnDisable = OnDisable
UIZoneMobilizationPointsHelpItem.ComponentDefine = ComponentDefine
UIZoneMobilizationPointsHelpItem.ComponentDestroy = ComponentDestroy
UIZoneMobilizationPointsHelpItem.DataDefine = DataDefine
UIZoneMobilizationPointsHelpItem.DataDestroy = DataDestroy
UIZoneMobilizationPointsHelpItem.SetData = SetData
UIZoneMobilizationPointsHelpItem.SetBgShow = SetBgShow
return UIZoneMobilizationPointsHelpItem
