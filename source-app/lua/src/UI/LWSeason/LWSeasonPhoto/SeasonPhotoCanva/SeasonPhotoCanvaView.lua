local base = UIBaseView
local SeasonPhotoCanvaView = BaseClass("SeasonPhotoCanvaView", base)
local SeasonPhotoCanva = require("UI.LWSeason.LWSeasonPhoto.Component.SeasonPhotoCanva")
local btnBack_path = "safeArea/BottomBar/BtnBack"
local txtTitle_path = "safeArea/TopBar/TextTitle"
local bg_path = "ImgBg"
local PhotoCanva_path = "safeArea/SeasonPhotoCanva"
local BtnEdit_path = "safeArea/BottomBar/BtnEdit"
local BtnSave_path = "safeArea/BottomBar/BtnSave"
local ToggleLimit_path = "safeArea/BottomBar/ToggleLimit"
local ShowHead_path = "safeArea/SeasonPhotoHead_1"
local Block_path = "safeArea/Block"

local function OnCreate(self)
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
  self.season, self.allianceId = self:GetUserData()
  self:RefreshView()
  DataCenter.SeasonPhotoManager:ChangeSkin(self, self.season)
  DataCenter.SeasonPhotoTemplateManager:LoadDeco(self, self.bg, bg_path, self.season, "decoPath", function(go, rect)
    rect:SetSizeDeltaXY(0, 0)
  end)
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
  self.BtnSave = self:AddComponent(UIButton, BtnSave_path)
  self.ToggleLimit = self:AddComponent(UIToggle, ToggleLimit_path)
  self.ShowHead = self:AddComponent(UIBaseContainer, ShowHead_path)
  self.Block = self:AddComponent(UIBaseContainer, Block_path)
  self.btnBack:SetOnClick(BindCallback(self.ctrl, self.ctrl.CloseSelf))
  self.PhotoCanva = self:AddComponent(SeasonPhotoCanva, PhotoCanva_path)
  self.BtnSave:SetOnClick(BindCallback(self.PhotoCanva, self.PhotoCanva.UploadPhoto))
  self.BtnEdit:SetOnClick(function()
    if not DataCenter.AllianceBaseDataManager:IsR4orR5() then
      UIUtil.ShowTipsId("season_alliance_photo_tips_20")
      return
    end
    if self.season then
      local data, _, picData = self.PhotoCanva:GetData()
      UIManager:GetInstance():OpenWindow(UIWindowNames.SeasonPhotoCanvaMenuView, {anim = true}, self.season, self.allianceId, picData)
    end
  end)
  self.ToggleLimit:SetOnValueChanged(BindCallback(self, self.ChangeModifyLimit))
  self.Block:SetActive(false)
end

local function ComponentDestroy(self)
  self.PhotoCanva = nil
  self.ShowHeadComp = nil
  self.btnBack = nil
  self.txtTitle = nil
  self.bg = nil
  self.PhotoCanva = nil
  self.BtnEdit = nil
  self.BtnSave = nil
  self.ToggleLimit = nil
  self.ShowHead = nil
  self.Block = nil
end

local function DataDefine(self)
end

local function DataDestroy(self)
end

function SeasonPhotoCanvaView:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.SeasonPhotoRefresh, self.SeasonPhotoRefresh)
  self:AddUIListener(EventId.SeasonPhotoEditChange, self.CheckDirty)
  self:AddUIListener(EventId.SeasonPhotoSetOtherModify, self.SeasonPhotoSetOtherModify)
  self:AddUIListener(EventId.SeasonPhotoAddHead, self.SeasonPhotoAddHead)
  self:AddUIListener(EventId.SeasonPhotoMenuClose, self.SeasonPhotoMenuClose)
end

function SeasonPhotoCanvaView:OnRemoveListener()
  self:RemoveUIListener(EventId.SeasonPhotoRefresh, self.SeasonPhotoRefresh)
  self:RemoveUIListener(EventId.SeasonPhotoEditChange, self.CheckDirty)
  self:RemoveUIListener(EventId.SeasonPhotoSetOtherModify, self.SeasonPhotoSetOtherModify)
  self:RemoveUIListener(EventId.SeasonPhotoAddHead, self.SeasonPhotoAddHead)
  self:RemoveUIListener(EventId.SeasonPhotoMenuClose, self.SeasonPhotoMenuClose)
  base.OnRemoveListener(self)
end

function SeasonPhotoCanvaView:RefreshView()
  self.PhotoCanva:SetPhotoInfo(self.season, self.allianceId, true)
  self.txtTitle:SetLocalText("season_alliance_photo_UI_2")
  self:RefreshToggle(true)
  self:CheckDirty()
end

function SeasonPhotoCanvaView:RefreshToggle(isInit)
  local photoInfo = DataCenter.SeasonPhotoManager:GetSeasonPhotoData(self.season, self.allianceId)
  local selfMember = photoInfo and photoInfo:GetMemberSelf()
  if selfMember then
    self.ToggleLimit:SetIsOnWithoutNotify(selfMember.otherModify)
  end
end

function SeasonPhotoCanvaView:ChangeModifyLimit()
  local photoInfo = DataCenter.SeasonPhotoManager:GetSeasonPhotoData(self.season, self.allianceId)
  local selfMember = photoInfo and photoInfo:GetMemberSelf()
  local curLimit = selfMember and selfMember.otherModify or false
  SFSNetwork.SendMessage(MsgDefines.SeasonPhotoSetOtherModify, self.season, self.allianceId, not curLimit)
end

function SeasonPhotoCanvaView:SeasonPhotoSetOtherModify(id)
  self:RefreshToggle()
end

function SeasonPhotoCanvaView:CheckDirty()
  CS.UIGray.SetGray(self.BtnSave.transform, not self.PhotoCanva:IsPhotoDirty(), true)
end

function SeasonPhotoCanvaView:SeasonPhotoRefresh(target)
  if target ~= self.PhotoCanva then
    return
  end
  self:CheckDirty()
end

function SeasonPhotoCanvaView:SeasonPhotoAddHead(head)
  if not head or not self.ShowHead then
    return
  end
  if not self.ShowHeadComp then
    local SeasonPhotoHead = require("UI.LWSeason.LWSeasonPhoto.Component.SeasonPhotoHead")
    self.ShowHeadComp = self.ShowHead:AddComponent(SeasonPhotoHead, "")
  end
  self.ShowHeadComp:ReInit(0, head.data, head.member)
  self.ShowHeadComp:SetActive(true)
  self.Block:SetActive(true)
  TimerManager:GetInstance():DelayInvoke(function()
    if self.Block then
      self.Block:SetActive(false)
    end
    if self.ShowHeadComp then
      self.ShowHeadComp:SetActive(false)
    end
  end, 4.5)
end

function SeasonPhotoCanvaView:SeasonPhotoMenuClose()
  if self.PhotoCanva then
    self.PhotoCanva:RefreshView()
  end
end

SeasonPhotoCanvaView.OnCreate = OnCreate
SeasonPhotoCanvaView.OnDestroy = OnDestroy
SeasonPhotoCanvaView.OnEnable = OnEnable
SeasonPhotoCanvaView.OnDisable = OnDisable
SeasonPhotoCanvaView.ComponentDefine = ComponentDefine
SeasonPhotoCanvaView.ComponentDestroy = ComponentDestroy
SeasonPhotoCanvaView.DataDefine = DataDefine
SeasonPhotoCanvaView.DataDestroy = DataDestroy
return SeasonPhotoCanvaView
