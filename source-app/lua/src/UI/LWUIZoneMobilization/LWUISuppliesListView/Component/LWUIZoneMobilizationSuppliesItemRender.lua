local base = UIBaseContainer
local LWUIZoneMobilizationSuppliesItemRender = BaseClass("LWUIZoneMobilizationSuppliesItemRender", base)
local Localization = CS.GameEntry.Localization
local discovererNameText_path = "DiscovererNameText"
local nameText_path = "NameText"
local countText_path = "NameText/CountText"
local gotoBtn_path = "GoToBtn"
local gotoBtnText_path = "GoToBtn/GotoBtnText"
local bg_path = "Bg1"
local playerHeadObj_path = "UIPlayerHead"
local posText_path = "PosText"
local icon_path = "Icon"
local time_text_path = "TimeText"
local ICON_PATH = "Assets/Main/Sprites/UI/LWUIZoneMobilization/%s.png"

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
  self.discovererNameText = self:AddComponent(UIText, discovererNameText_path)
  self.nameText = self:AddComponent(UIText, nameText_path)
  self.countText = self:AddComponent(UIText, countText_path)
  self.gotoBtn = self:AddComponent(UIButton, gotoBtn_path)
  self.gotoBtnText = self:AddComponent(UIText, gotoBtnText_path)
  self.bg = self:AddComponent(UIImage, bg_path)
  self.playerHeadObj = self:AddComponent(UICommonHead, playerHeadObj_path)
  self.playerHeadObj:SetEnableClickShowInfo(true, true)
  self.posText = self:AddComponent(UITextMeshProUGUIEx, posText_path)
  self.gotoBtn:SetOnClick(function()
    if self.suppliesData then
      self.suppliesData:GoToSuppliesPoints()
    end
  end)
  self.posText:OnPointerClick(function(eventData)
    if self.suppliesData then
      self.suppliesData:GoToSuppliesPoints()
    end
  end)
  self.icon = self:AddComponent(UIImage, icon_path)
  self.time_text = self:AddComponent(UITextMeshProUGUIEx, time_text_path)
end

local function ComponentDestroy(self)
  self.discovererNameText = nil
  self.nameText = nil
  self.countText = nil
  self.gotoBtn = nil
  self.gotoBtnText = nil
  self.bg = nil
  self.playerHeadObj = nil
  self.posText = nil
  self.icon = nil
  self.time_text = nil
end

local function DataDefine(self)
end

local function DataDestroy(self)
end

local function InitData(self, suppliesData)
  self.suppliesData = suppliesData
  local discovererInfo = suppliesData.discovererInfo
  self.playerHeadObj:SetData(discovererInfo.uid, discovererInfo.pic, discovererInfo.picVer, nil, discovererInfo:GetHeadBgImg())
  local pos = SceneUtils.IndexToTilePos(self.suppliesData.pointId, ForceChangeScene.World)
  local posStr = "<u>[" .. Localization:GetString(GameDialogDefine.SHOW_POS, pos.x, pos.y) .. "]</u>"
  self.posText:SetText(posStr)
  self.discovererNameText:SetText(UIUtil.FormatAllianceAndName(discovererInfo.alAbbr, discovererInfo.name))
  self.nameText:SetText(self.suppliesData:GetSuppliesName())
  local stringFormat = self.suppliesData.rewardNum >= ZoneMobilizationSuppliesMaxCount and "<color=#F53C3D>%d</color>/%d" or "<color=#0aa032>%d</color>/%d"
  self.countText:SetText(string.format(stringFormat, self.suppliesData.rewardNum, ZoneMobilizationSuppliesMaxCount))
  local isGray = suppliesData.rewarded or self.suppliesData.rewardNum >= ZoneMobilizationSuppliesMaxCount
  self.bg:LoadSprite(isGray and "Assets/Main/Sprites/UI/LWUIZoneMobilization/wxy_xiusai_wuziliebiaodi_02.png" or "Assets/Main/Sprites/UI/LWUIZoneMobilization/wxy_xiusai_wuziliebiaodi_01.png")
  CS.UIGray.SetGray(self.gotoBtn.transform, isGray, not isGray)
  if isGray then
    self.gotoBtnText:SetLocalText(self.suppliesData.rewarded and "zone_mobilization_donated_claimed" or "zone_mobilization_donated_claimed_end")
  else
    self.gotoBtnText:SetLocalText("zone_mobilization_donated_goto")
  end
  local cfgId = suppliesData.cfgId
  local line = LocalController:instance():getLine(TableName.LWIceSupplies, cfgId)
  if line then
    local type = line.type == 6 and 0 or 1
    local iconPath = DataCenter.LWZoneMobilizationManager:GetResourceIcon(type)
    self.icon:LoadSprite(string.format(ICON_PATH, iconPath))
  end
  self.expireTime = suppliesData.expireTime
  if 0 >= self.expireTime then
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
      self.time_text:SetText("")
    end
  else
    self.time_text:SetText("")
  end
end

LWUIZoneMobilizationSuppliesItemRender.OnCreate = OnCreate
LWUIZoneMobilizationSuppliesItemRender.OnDestroy = OnDestroy
LWUIZoneMobilizationSuppliesItemRender.OnEnable = OnEnable
LWUIZoneMobilizationSuppliesItemRender.OnDisable = OnDisable
LWUIZoneMobilizationSuppliesItemRender.ComponentDefine = ComponentDefine
LWUIZoneMobilizationSuppliesItemRender.ComponentDestroy = ComponentDestroy
LWUIZoneMobilizationSuppliesItemRender.DataDefine = DataDefine
LWUIZoneMobilizationSuppliesItemRender.DataDestroy = DataDestroy
LWUIZoneMobilizationSuppliesItemRender.InitData = InitData
LWUIZoneMobilizationSuppliesItemRender.Update1000MS = Update1000MS
return LWUIZoneMobilizationSuppliesItemRender
