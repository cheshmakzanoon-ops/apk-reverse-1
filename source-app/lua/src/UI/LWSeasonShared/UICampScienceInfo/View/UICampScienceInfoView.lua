local base = UIBaseView
local UICampScienceInfoView = BaseClass("UICampScienceInfoView", base)
local CampScienceIconInfo = require("UI.LWSeasonShared.UICampScienceInfo.Component.CampScienceIconInfo")
local btn_panel_path = "UICommonPopUpTitle/panel"
local txt_titleText_path = "UICommonPopUpTitle/Common_img_title/titleText"
local btn_CloseBtn_path = "UICommonPopUpTitle/CloseBtn"
local anim_MiddleBg_path = "BgGo/MiddleBg"
local cg_BuildInfo_path = "BgGo/MiddleBg/BuildInfo"

function UICampScienceInfoView:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self.scienceData = self:GetUserData()
  self:OnUpdateView()
  if CS.CommonUtils.IsDebug() or CS.UnityEngine.Application.isEditor then
    Logger.Log("[CampScience] effectId" .. self.scienceData.para1)
    Logger.Log("[CampScience] effectId" .. self.scienceData.camp_map_effect)
  end
end

function UICampScienceInfoView:OnDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UICampScienceInfoView:ComponentDefine()
  self.btn_panel = self:AddComponent(UIButton, btn_panel_path)
  self.txt_titleText = self:AddComponent(UIText, txt_titleText_path)
  self.btn_CloseBtn = self:AddComponent(UIButton, btn_CloseBtn_path)
  self.anim_MiddleBg = self:AddComponent(UIAnimator, anim_MiddleBg_path)
  self.cg_BuildInfo = self:AddComponent(UICanvasGroup, cg_BuildInfo_path)
  self.btn_panel:SetOnClick(function()
    self.ctrl:CloseSelf()
  end)
  self.btn_CloseBtn:SetOnClick(function()
    self.ctrl:CloseSelf()
  end)
  self.build_info = self:AddComponent(CampScienceIconInfo, cg_BuildInfo_path)
  self.cg_BuildInfo:SetAlpha(1)
  self.cg_BuildInfo.transform:Set_localPosition(ResetPosition.x, ResetPosition.y, ResetPosition.z)
  self.cg_BuildInfo:SetActive(false)
end

function UICampScienceInfoView:ComponentDestroy()
  self.btn_panel = nil
  self.txt_titleText = nil
  self.btn_CloseBtn = nil
  self.anim_MiddleBg = nil
  self.cg_BuildInfo = nil
  self.build_info = nil
end

function UICampScienceInfoView:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.UpdateSelfCampScienceInfo, self.OnUpdateView)
  self:AddUIListener(EventId.UpdateCampScienceList, self.OnUpdateView)
end

function UICampScienceInfoView:OnRemoveListener()
  base.OnRemoveListener(self)
  self:RemoveUIListener(EventId.UpdateSelfCampScienceInfo, self.OnUpdateView)
  self:RemoveUIListener(EventId.UpdateCampScienceList, self.OnUpdateView)
end

function UICampScienceInfoView:OnUpdateView()
  self.scienceData = DataCenter.CampScienceDataManager:GetOneCampScienceById(self.scienceData.scienceId)
  if self.scienceData ~= nil then
    self.build_info:RefreshData(self.scienceData)
    self.build_info:SetActive(true)
  else
    self.build_info:SetActive(false)
  end
end

return UICampScienceInfoView
