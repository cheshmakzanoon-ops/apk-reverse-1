local base = UIBaseView
local SeasonPhotoMessageShareView = BaseClass("SeasonPhotoMessageShareView", base)
local SeasonPhotoMessage = require("UI.LWSeason.LWSeasonPhoto.Component.SeasonPhotoMessage")
local btnBack_path = "safeArea/BottomBar/BtnBack"
local txtTitle_path = "safeArea/TopBar/TextTitle"
local photoMessage_path = "safeArea/SeasonPhotoMessage"
local TextName_path = "safeArea/TextName"

local function OnCreate(self)
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
  self.season, self.allianceId = self:GetUserData()
  if not self:RefreshView() then
    DataCenter.SeasonPhotoManager:RequestSeasonPhotoOneView(self.season, self.allianceId)
  end
  DataCenter.SeasonPhotoManager:ChangeSkin(self, self.season)
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
  self.photoMessage = self:AddComponent(UIBaseContainer, photoMessage_path)
  self.TextName = self:AddComponent(UIText, TextName_path)
  self.btnBack:SetOnClick(BindCallback(self.ctrl, self.ctrl.CloseSelf))
  self.PhotoMessage = self:AddComponent(SeasonPhotoMessage, photoMessage_path)
end

local function ComponentDestroy(self)
  self.btnBack = nil
  self.txtTitle = nil
  self.photoMessage = nil
  self.TextName = nil
end

local function DataDefine(self)
end

local function DataDestroy(self)
end

function SeasonPhotoMessageShareView:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.SeasonPhotoOneView, self.OnSeasonPhotoOneView)
end

function SeasonPhotoMessageShareView:OnRemoveListener()
  self:RemoveUIListener(EventId.SeasonPhotoOneView, self.OnSeasonPhotoOneView)
  base.OnRemoveListener(self)
end

function SeasonPhotoMessageShareView:RefreshView()
  self.PhotoMessage:SetPhotoInfo(self.season, self.allianceId)
  self.txtTitle:SetLocalText("season_alliance_photo_UI_35")
  return self:RefreshInfo()
end

function SeasonPhotoMessageShareView:RefreshInfo()
  local photoInfo, userSettleRecord = DataCenter.SeasonPhotoManager:GetSeasonPhotoData(self.season, self.allianceId)
  if photoInfo then
    self.TextName:SetText(string.format("#%d [%s] %s", photoInfo.serverId, photoInfo.abbr, photoInfo.allianceName))
  else
    self.TextName:SetText("")
  end
  return photoInfo, userSettleRecord
end

function SeasonPhotoMessageShareView:OnSeasonPhotoOneView(userData)
  if userData.season ~= self.season or userData.allianceId ~= self.allianceId then
    return
  end
  self:RefreshInfo()
end

SeasonPhotoMessageShareView.OnCreate = OnCreate
SeasonPhotoMessageShareView.OnDestroy = OnDestroy
SeasonPhotoMessageShareView.OnEnable = OnEnable
SeasonPhotoMessageShareView.OnDisable = OnDisable
SeasonPhotoMessageShareView.ComponentDefine = ComponentDefine
SeasonPhotoMessageShareView.ComponentDestroy = ComponentDestroy
SeasonPhotoMessageShareView.DataDefine = DataDefine
SeasonPhotoMessageShareView.DataDestroy = DataDestroy
return SeasonPhotoMessageShareView
