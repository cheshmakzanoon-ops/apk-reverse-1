local base = UIBaseContainer
local LWUIZoneMobilizationResItemRender = BaseClass("LWUIZoneMobilizationResItemRender", base)
local Localization = CS.GameEntry.Localization
local gotoBtn_path = "GoToBtn"
local gotoBtnText_path = "GoToBtn/GotoBtnText"
local posText_path = "PosText"
local icon_path = "content/Icon"
local time_text_path = "TimeText"
local slider_path = "content/specialObj/Slider"
local rest_num_path = "content/specialObj/restNum"
local level_text_path = "LevelText"
local bg_small_path = "content/BgSmall"
local bg_big_path = "content/BgBig"

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
  self.gotoBtn = self:AddComponent(UIButton, gotoBtn_path)
  self.gotoBtnText = self:AddComponent(UIText, gotoBtnText_path)
  self.posText = self:AddComponent(UITextMeshProUGUIEx, posText_path)
  self.gotoBtn:SetOnClick(function()
    self:GotoWorldPos()
  end)
  self.posText:OnPointerClick(function(eventData)
    self:GotoWorldPos()
  end)
  self.icon = self:AddComponent(UIImage, icon_path)
  self.time_text = self:AddComponent(UITextMeshProUGUIEx, time_text_path)
  self.slider = self:AddComponent(UISlider, slider_path)
  self.rest_num = self:AddComponent(UITextMeshProUGUIEx, rest_num_path)
  self.level_text = self:AddComponent(UITextMeshProUGUIEx, level_text_path)
  self.bg_small = self:AddComponent(UIImage, bg_small_path)
  self.bg_small:SetActive(false)
  self.bg_big = self:AddComponent(UIImage, bg_big_path)
  self.bg_big:SetActive(false)
end

local function ComponentDestroy(self)
  self.gotoBtn = nil
  self.gotoBtnText = nil
  self.posText = nil
  self.icon = nil
  self.time_text = nil
  self.slider = nil
  self.rest_num = nil
  self.level_text = nil
  self.bg_small = nil
  self.bg_big = nil
end

local function DataDefine(self)
  self.pointId = nil
end

local function DataDestroy(self)
  self.pointId = nil
end

local function InitData(self, suppliesData)
  self.suppliesData = suppliesData
  if not suppliesData then
    return
  end
  self.pointId = suppliesData.pointId
  local pos = SceneUtils.IndexToTilePos(suppliesData.pointId, ForceChangeScene.World)
  local posStr = "<u>[" .. Localization:GetString(GameDialogDefine.SHOW_POS, pos.x, pos.y) .. "]</u>"
  self.posText:SetText(posStr)
  self.gotoBtnText:SetLocalText("zone_mobilization_donated_goto")
  local cfgId = suppliesData.allianceResBuildId
  local line = LocalController:instance():tryGetLine(TableName.AllianceMine, cfgId)
  if line then
    local special_flag = line.special_flag
    if tonumber(special_flag) == 1 then
      self.bg_small:SetActive(true)
      self.bg_big:SetActive(false)
    else
      self.bg_small:SetActive(false)
      self.bg_big:SetActive(true)
    end
    self.icon:LoadSprite(string.format(LoadPath.ItemPath, line.icon))
    self.level_text:SetText("Lv." .. line.city_level)
    local maxNum = line.reserve
    local remainNum = suppliesData.remainNum
    local progress = Mathf.Clamp01(remainNum / maxNum)
    self.slider:SetValue(progress)
    self.rest_num:SetText(string.GetFormattedSeperatorNum(remainNum))
  end
  self.expireTime = suppliesData.expireTime
  if self.expireTime <= 0 then
    self.time_text:SetText("")
  end
end

local function Update1000MS(self)
  if self.expireTime > 0 then
    local curTs = UITimeManager:GetInstance():GetServerTime()
    local remain = self.expireTime - curTs
    if 0 < remain then
      local timeStr = UITimeManager:GetInstance():MilliSecondToFmtString(remain)
      self.time_text:SetText(timeStr)
    else
      self.time_text:SetText()
    end
  else
    self.time_text:SetText("")
  end
end

local function GotoWorldPos(self)
  if self.pointId then
    local point = self.pointId
    GoToUtil.CloseAllWindows()
    local sourceServerId = LuaEntry.Player:GetSourceServerId()
    local worldPosition = SceneUtils.TileIndexToWorld(point, ForceChangeScene.World, sourceServerId)
    GoToUtil.GotoWorldPos(worldPosition, CS.SceneManager.World.InitZoom, LookAtFocusTime, function()
    end, sourceServerId)
  end
end

LWUIZoneMobilizationResItemRender.OnCreate = OnCreate
LWUIZoneMobilizationResItemRender.OnDestroy = OnDestroy
LWUIZoneMobilizationResItemRender.OnEnable = OnEnable
LWUIZoneMobilizationResItemRender.OnDisable = OnDisable
LWUIZoneMobilizationResItemRender.ComponentDefine = ComponentDefine
LWUIZoneMobilizationResItemRender.ComponentDestroy = ComponentDestroy
LWUIZoneMobilizationResItemRender.DataDefine = DataDefine
LWUIZoneMobilizationResItemRender.DataDestroy = DataDestroy
LWUIZoneMobilizationResItemRender.InitData = InitData
LWUIZoneMobilizationResItemRender.Update1000MS = Update1000MS
LWUIZoneMobilizationResItemRender.GotoWorldPos = GotoWorldPos
return LWUIZoneMobilizationResItemRender
