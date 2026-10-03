local UIActivityDetailPopupView = BaseClass("UIActivityDetailPopupView", UIBaseView)
local base = UIBaseView
local bg1DefaultPath = "Assets/Main/Sprites/UI/CommonBG/cfm_tongyon_tanchuang_da_diban.png"
local bg2DefaultPath = "Assets/Main/Sprites/UI/CommonBG/cfm_tongyon_tanchuang_erjichen.png"
local activityThemPath = "Assets/Main/Sprites/UI/ActivityThemeSkin/%s"
local contentBodyDefaultColor = Color.New(0.45098039215686275, 0.40784313725490196, 0.38823529411764707, 1.0)
local panel_path = "panel"
local content_text_path = "PopUpTitle/Common_bg_orange2/ContentScroll/Viewport/ContentText"
local title_text_path = "PopUpTitle/Common_img_title/titleText"
local close_btn_path = "PopUpTitle/CloseBtn"
local sub_title_text_path = "PopUpTitle/Common_bg_orange2/SubTitleText"
local common_bg_orange_path = "PopUpTitle/Common_bg_orange"
local common_bg_orange2_path = "PopUpTitle/Common_bg_orange2"
local v_f_x_effect_path = "PopUpTitle/Common_img_title/VFX_effect"

function UIActivityDetailPopupView:OnCreate()
  base.OnCreate(self)
  local param = self:GetUserData()
  self.param = param
  self:ComponentDefine()
  self:RefreshViewPacking()
end

function UIActivityDetailPopupView:OnDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UIActivityDetailPopupView:ComponentDefine()
  self.btnPanel = self:AddComponent(UIButton, panel_path)
  self.btnPanel:SetOnClick(BindCallback(self.ctrl, self.ctrl.CloseSelf))
  self.titleText = self:AddComponent(UIText, title_text_path)
  self.titleText:SetLocalText(self.param.title or 2000047)
  self.activityTitleText = self:AddComponent(UIText, sub_title_text_path)
  if self.param.hideSubTile or string.IsNullOrEmpty(self.param.subTitle) then
    self.activityTitleText:SetActive(false)
  else
    self.activityTitleText:SetActive(true)
    self.activityTitleText:SetLocalText(self.param.subTitle or 2000048)
  end
  self.contentText = self:AddComponent(UIText, content_text_path)
  self.contentText:SetText(self.param.activityRulesStr)
  self.common_bg_orange = self:AddComponent(UIImage, common_bg_orange_path)
  self.common_bg_orange2 = self:AddComponent(UIImage, common_bg_orange2_path)
  self.v_f_x_effect = self:AddComponent(UIVfx, v_f_x_effect_path)
  self.closeBtn = self:AddComponent(UIButton, close_btn_path)
  self.closeBtn:SetOnClick(BindCallback(self.ctrl, self.ctrl.CloseSelf))
end

function UIActivityDetailPopupView:ComponentDestroy()
  self.btnPanel = nil
  self.titleText = nil
  self.contentText = nil
  self.closeBtn = nil
  self.common_bg_orange = nil
  self.common_bg_orange2 = nil
  self.v_f_x_effect:Remove()
  self.v_f_x_effect = nil
end

function UIActivityDetailPopupView:RefreshViewPacking()
  if self.param and self.param.activityId then
    local lineData = LocalController:instance():getLine(TableName.Activity, self.param.activityId)
    if lineData == nil then
      Logger.LogError("Activity GetTemplate lineData is nil id:" .. self.param.activityId)
      return nil
    end
    if string.IsNullOrEmpty(lineData.festival_interface_config) then
      self:SetDefaultPacking()
      return
    end
    self:ModifyPanelPacking(tonumber(lineData.festival_interface_config))
  else
    self:SetDefaultPacking()
  end
end

function UIActivityDetailPopupView:SetDefaultPacking()
  self.common_bg_orange:LoadSprite(bg1DefaultPath)
  self.common_bg_orange2:LoadSprite(bg2DefaultPath)
  self.v_f_x_effect:Remove()
  self.v_f_x_effect:SetActive(false)
  self.contentText:SetColor(contentBodyDefaultColor)
end

function UIActivityDetailPopupView:ModifyPanelPacking(festivalInterfaceCfgId)
  local lineData = LocalController:instance():getLine(TableName.Festival_Interface_Config, festivalInterfaceCfgId)
  if lineData == nil then
    Logger.LogError("Festival_Interface_Config GetTemplate lineData is nil id:" .. festivalInterfaceCfgId)
    return
  end
  if string.IsNullOrEmpty(lineData.board_di) then
    self.common_bg_orange:LoadSprite(bg1DefaultPath)
  else
    self.common_bg_orange:LoadSprite(string.format(activityThemPath, lineData.board_di))
  end
  if string.IsNullOrEmpty(lineData.board_di_text) then
    self.common_bg_orange2:LoadSprite(bg2DefaultPath)
    self.contentText:SetColor(contentBodyDefaultColor)
  else
    local configList = string.split(lineData.board_di_text, "|")
    self.common_bg_orange2:LoadSprite(string.format(activityThemPath, configList[1]))
    local tmpColor255 = string.string2array_i_oneSep(configList[2], ",")
    local targetColor = Color.New(tmpColor255[1] / 255, tmpColor255[2] / 255, tmpColor255[3] / 255, tmpColor255[4] / 255)
    self.contentText:SetColor(targetColor)
  end
  if string.IsNullOrEmpty(lineData.board_prefab) then
    self.v_f_x_effect:SetActive(false)
    self.v_f_x_effect:Remove()
  else
    self.v_f_x_effect:SetActive(true)
    self.v_f_x_effect:PlayByStay(lineData.board_prefab, {isBreak = true})
  end
end

return UIActivityDetailPopupView
