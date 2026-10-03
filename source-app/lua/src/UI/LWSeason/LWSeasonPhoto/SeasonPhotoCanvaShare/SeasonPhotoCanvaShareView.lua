local base = UIBaseView
local SeasonPhotoCanvaShareView = BaseClass("SeasonPhotoCanvaShareView", base)
local SeasonPhotoCanva = require("UI.LWSeason.LWSeasonPhoto.Component.SeasonPhotoCanva")
local btnBack_path = "safeArea/BottomBar/BtnBack"
local txtTitle_path = "safeArea/TopBar/TextTitle"
local bg_path = "ImgBg"
local PhotoCanva_path = "safeArea/SeasonPhotoCanva"
local BtnEdit_path = "safeArea/BottomBar/BtnEdit"
local BtnReport_path = "safeArea/BtnReport"
local flipPage_path = "safeArea/flippage"
local effectBack_path = "EffectBack"
local effectFront_path = "EffectFront"

local function OnCreate(self)
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
  self.season, self.allianceId = self:GetUserData()
  self:RefreshInfo()
  self:RefreshView()
  DataCenter.SeasonPhotoManager:ChangeSkin(self, self.season)
  DataCenter.SeasonPhotoTemplateManager:LoadDeco(self, self.bg, bg_path, self.season, "decoPath", function(go, rect)
    rect:SetSizeDeltaXY(0, 0)
  end)
  DataCenter.SeasonPhotoTemplateManager:LoadDeco(self, self.effectBack, effectBack_path, self.season, "shareEffectBackPath")
  DataCenter.SeasonPhotoTemplateManager:LoadDeco(self, self.effectFront, effectFront_path, self.season, "shareEffectFrontPath")
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
  self.btnBack = self:AddComponent(UIButton, btnBack_path)
  self.txtTitle = self:AddComponent(UIText, txtTitle_path)
  self.bg = self:AddComponent(UIImage, bg_path)
  self.PhotoCanva = self:AddComponent(UIBaseContainer, PhotoCanva_path)
  self.BtnEdit = self:AddComponent(UIButton, BtnEdit_path)
  self.BtnReport = self:AddComponent(UIButton, BtnReport_path)
  self.flipPage = self:AddComponent(UIRawImage, flipPage_path)
  self.effectBack = self:AddComponent(UIBaseContainer, effectBack_path)
  self.effectFront = self:AddComponent(UIBaseContainer, effectFront_path)
  self.btnBack:SetOnClick(BindCallback(self.ctrl, self.ctrl.CloseSelf))
  self.PhotoCanva = self:AddComponent(SeasonPhotoCanva, PhotoCanva_path)
  self.BtnEdit:SetOnClick(function()
    if not DataCenter.SeasonPhotoManager:CanEditPhoto(self.season, self.allianceId, true, true) then
      return
    end
    if self.season then
      UIManager:GetInstance():OpenWindow(UIWindowNames.SeasonPhotoCanva, {anim = true}, self.season, self.allianceId)
    end
  end)
  self.BtnReport:SetOnClick(function()
    self:OnBtnReportSeasonPhotoClick()
  end)
end

local function ComponentDestroy(self)
  self.btnBack = nil
  self.txtTitle = nil
  self.bg = nil
  self.PhotoCanva = nil
  self.BtnEdit = nil
  self.BtnReport = nil
  self.flipPage = nil
  self.effectBack = nil
  self.effectFront = nil
end

local function DataDefine(self)
end

local function DataDestroy(self)
end

function SeasonPhotoCanvaShareView:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.SeasonPhotoRefresh, self.SeasonPhotoRefresh)
end

function SeasonPhotoCanvaShareView:OnRemoveListener()
  self:RemoveUIListener(EventId.SeasonPhotoRefresh, self.SeasonPhotoRefresh)
  base.OnRemoveListener(self)
end

function SeasonPhotoCanvaShareView:RefreshView()
  self.PhotoCanva:SetPhotoInfo(self.season, self.allianceId)
  self.txtTitle:SetLocalText("season_alliance_photo_UI_2")
end

function SeasonPhotoCanvaShareView:RefreshInfo()
  local photoInfo, userRecord = DataCenter.SeasonPhotoManager:GetSeasonPhotoData(self.season, self.allianceId)
  local activityData = userRecord and DataCenter.SeasonPhotoManager:GetSeasonPhotoActivityData(self.season, self.allianceId)
  local canEdit = activityData and photoInfo and photoInfo.allianceId == LuaEntry.Player.allianceId
  self.BtnEdit:SetActive(canEdit)
  self.BtnReport:SetActive(not photoInfo or photoInfo.allianceId ~= LuaEntry.Player.allianceId)
  local borderConfig = photoInfo and photoInfo:GetPhotoBorderConfig() or DataCenter.SeasonPhotoTemplateManager:GetDefaultBorderConfig(self.season)
  if borderConfig and not string.IsNullOrEmpty(borderConfig.resource) then
    self.flipPage:LoadSpriteAsync(borderConfig.resource)
  end
end

function SeasonPhotoCanvaShareView:SeasonPhotoRefresh(target)
  if target ~= self.PhotoCanva then
    return
  end
  self:RefreshInfo()
end

function SeasonPhotoCanvaShareView:OnBtnReportSeasonPhotoClick()
  local photoInfo, userRecord = DataCenter.SeasonPhotoManager:GetSeasonPhotoData(self.season, self.allianceId)
  if not photoInfo then
    return
  end
  local param = {
    type = ReportType.SeasonAlliancePhoto,
    allianceId = photoInfo.allianceId,
    season = photoInfo.season,
    version = photoInfo.picVer,
    picUrl = photoInfo.picData.picUrl,
    title = CS.GameEntry.Localization:GetString("season_alliance_photo_tips_10", string.format("#%d[%s]%s", photoInfo.serverId, photoInfo.abbr, photoInfo.allianceName))
  }
  UIManager:GetInstance():OpenWindow(UIWindowNames.UIChatReportSpecificType, {anim = true}, param)
end

SeasonPhotoCanvaShareView.OnCreate = OnCreate
SeasonPhotoCanvaShareView.OnDestroy = OnDestroy
SeasonPhotoCanvaShareView.OnEnable = OnEnable
SeasonPhotoCanvaShareView.OnDisable = OnDisable
SeasonPhotoCanvaShareView.ComponentDefine = ComponentDefine
SeasonPhotoCanvaShareView.ComponentDestroy = ComponentDestroy
SeasonPhotoCanvaShareView.DataDefine = DataDefine
SeasonPhotoCanvaShareView.DataDestroy = DataDestroy
return SeasonPhotoCanvaShareView
