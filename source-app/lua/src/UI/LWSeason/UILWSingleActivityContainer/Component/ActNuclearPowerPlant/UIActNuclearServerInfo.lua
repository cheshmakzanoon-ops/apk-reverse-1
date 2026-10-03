local base = UIBaseContainer
local UIActNuclearServerInfo = BaseClass("UIActNuclearServerInfo", base)
local Localization = CS.GameEntry.Localization
local serverSprite_path = "serverSprite"
local buildCount_path = "buildTimeDes"
local progress_path = "progressArea/progress/serverProgressFront"
local serverProgressValue_path = "progressArea/progress/serverProgressValueDes"
local buildPoint_path = "serverPoint"
local nameInfo_path = "nameInfo"
local clickServer_path = "serverPoint"

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
  self.serverSprite = self:AddComponent(UIImage, serverSprite_path)
  self.buildCount = self:AddComponent(UIText, buildCount_path)
  self.progress = self:AddComponent(UIBaseContainer, progress_path)
  self.serverProgressValue = self:AddComponent(UIText, serverProgressValue_path)
  self.buildPoint = self:AddComponent(UIText, buildPoint_path)
  self.nameInfo = self:AddComponent(UIText, nameInfo_path)
  self.clickServer = self:AddComponent(UIButton, clickServer_path)
  self.clickServer:SetSafeClickMode(true)
  self.clickServer:SetOnClick(function()
    self:ClickServerBtn()
  end)
end

local function ComponentDestroy(self)
  self.serverSprite = nil
  self.buildCount = nil
  self.progress = nil
  self.serverProgressValue = nil
  self.buildPoint = nil
  self.nameInfo = nil
  self.clickServer = nil
end

local function DataDefine(self)
end

local function DataDestroy(self)
end

function UIActNuclearServerInfo:SetData(data)
  local maxScore = DataCenter.SeasonNuclearPowerPlantDataManager:GetScoreMax()
  if data then
    local r = data.score / maxScore
    if 1 < r then
      r = 1
    end
    self.progress:SetLocalScaleXYZ(r, 1, 1)
    r = r * 100
    r = math.floor(r * 100) / 100
    self.serverProgressValue:SetText(tostring(r) .. "%")
  else
    self.progress:SetLocalScaleXYZ(0, 1, 1)
    self.serverProgressValue:SetText("0%")
  end
  local remainTime = DataCenter.SeasonNuclearPowerPlantDataManager:GetBuildNuclearFurnaceTime()
  self.buildCount:SetText(Localization:GetString("season_s2_activity_1000047_description_44", remainTime))
  local sourceServerId = DataCenter.SeasonNuclearPowerPlantDataManager:GetActivityLegalServerId()
  local kingCityId, kingCityPosIndex = SeasonUtil.GetKingCityId(sourceServerId)
  local myCityPos = SceneUtils.IndexToTilePos(kingCityPosIndex, ForceChangeScene.World)
  local pointStr = string.format("#%s X:%s Y:%s", sourceServerId, myCityPos.x, myCityPos.y)
  self.buildPoint:SetText(pointStr)
  local template = DataCenter.AllianceCityTemplateManager:GetTemplate(kingCityId, sourceServerId)
  if template then
    local name = Localization:GetString(template.name)
    local cityInfo = DataCenter.WorldAllianceCityDataManager:GetAllianceCityDataByCityId(kingCityId)
    if cityInfo and cityInfo.abbr ~= nil and cityInfo.abbr ~= "" then
      name = UIUtil.FormatAllianceAndName(cityInfo.abbr, name)
    end
    self.nameInfo:SetText(name)
  else
    self.nameInfo:SetText("")
  end
end

function UIActNuclearServerInfo:ClickServerBtn()
  GoToUtil.CloseAllWindows()
  local sourceServerId = DataCenter.SeasonNuclearPowerPlantDataManager:GetActivityLegalServerId()
  local kingCityId, kingCityPosIndex = SeasonUtil.GetKingCityId(sourceServerId)
  GoToUtil.MoveToWorldPointAndOpen(kingCityPosIndex, nil, nil, sourceServerId)
end

UIActNuclearServerInfo.OnCreate = OnCreate
UIActNuclearServerInfo.OnDestroy = OnDestroy
UIActNuclearServerInfo.OnEnable = OnEnable
UIActNuclearServerInfo.OnDisable = OnDisable
UIActNuclearServerInfo.ComponentDefine = ComponentDefine
UIActNuclearServerInfo.ComponentDestroy = ComponentDestroy
UIActNuclearServerInfo.DataDefine = DataDefine
UIActNuclearServerInfo.DataDestroy = DataDestroy
return UIActNuclearServerInfo
