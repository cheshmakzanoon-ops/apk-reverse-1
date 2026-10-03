local base = UIBaseContainer
local GreenAllianceCityItem = BaseClass("GreenAllianceCityItem", base)
local bgImg_path = "bg"
local title_path = "title"
local position_path = "pos"
local cityIcon_path = "iconRoot/cityIcon"
local desc_path = "desc"
local gotoBtn_path = "gotoBtn"
local gotoBtnText_path = "gotoBtn/ConfirmBtnText"
local posGotoBtn_path = "pos/posGoto"
local finished_path = "iconRoot/finished"
local rate_path = "iconRoot/rate"

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
  self.bgImg = self:AddComponent(UIImage, bgImg_path)
  self.title = self:AddComponent(UIText, title_path)
  self.position = self:AddComponent(UIText, position_path)
  self.cityIcon = self:AddComponent(UIImage, cityIcon_path)
  self.desc = self:AddComponent(UIText, desc_path)
  self.gotoBtn = self:AddComponent(UIButton, gotoBtn_path)
  self.gotoBtnText = self:AddComponent(UIText, gotoBtnText_path)
  self.posGotoBtn = self:AddComponent(UIButton, posGotoBtn_path)
  self.finished = self:AddComponent(UIBaseContainer, finished_path)
  self.rate = self:AddComponent(UIText, rate_path)
  self.gotoBtn:SetOnClick(function()
    self:Jump()
  end)
  self.posGotoBtn:SetOnClick(function()
    self:Jump()
  end)
  self.gotoBtnText:SetLocalText("season_s2_ice_supplies_21")
end

local function ComponentDestroy(self)
  self.bgImg = nil
  self.title = nil
  self.position = nil
  self.cityIcon = nil
  self.desc = nil
  self.gotoBtn = nil
  self.gotoBtnText = nil
  self.posGotoBtn = nil
  self.finished = nil
  self.rate = nil
end

local function DataDefine(self)
end

local function DataDestroy(self)
end

function GreenAllianceCityItem:ReInit(index, data)
  self.data = data
  self.cityData = self.data and DataCenter.WorldAllianceCityDataManager:GetMyAlCityInfo(self.data.cityId)
  self.cityConfig = DataCenter.AllianceCityTemplateManager:GetTemplate(self.data.cityId)
  if not self.cityData or not self.cityConfig then
    return
  end
  local strName = self.cityData:GetName()
  local lv = CS.GameEntry.Localization:GetString("300665", self.cityConfig.level)
  self.title:SetText(string.format("%s %s", lv, strName))
  self.cityIcon:LoadSprite(self.cityConfig:GetIconPath(false))
  self.position:SetText("<u>X:" .. self.cityConfig.pos.x .. " Y:" .. self.cityConfig.pos.y .. "</u>")
  self.desc:SetLocalText("season_oasis_UI_5", self.data.suppliesNum)
  local greenRate = self.data.greenRate * 100
  self.rate:SetText(string.format("%0.1f%%", greenRate))
  if greenRate >= DataCenter.SeasonGreenManager.cityGreenCondition then
    self.rate:SetColorRGBA(0.372549, 0.9372549, 0.5294118, 1)
    self.finished:SetActive(true)
  else
    self.rate:SetColorRGBA(1, 1, 1, 1)
    self.finished:SetActive(false)
  end
end

function GreenAllianceCityItem:Jump()
  if not self.cityData or not self.cityConfig then
    return
  end
  GoToUtil.CloseAllWindows()
  local v3 = SceneUtils.TileToWorld(self.cityConfig.pos, ForceChangeScene.World)
  GoToUtil.GotoWorldPos(v3, CS.SceneManager.World.InitZoom, LookAtFocusTime)
end

GreenAllianceCityItem.OnCreate = OnCreate
GreenAllianceCityItem.OnDestroy = OnDestroy
GreenAllianceCityItem.OnEnable = OnEnable
GreenAllianceCityItem.OnDisable = OnDisable
GreenAllianceCityItem.ComponentDefine = ComponentDefine
GreenAllianceCityItem.ComponentDestroy = ComponentDestroy
GreenAllianceCityItem.DataDefine = DataDefine
GreenAllianceCityItem.DataDestroy = DataDestroy
return GreenAllianceCityItem
