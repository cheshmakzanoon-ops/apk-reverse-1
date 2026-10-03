local p_text_title_path = "Root/bg/title/Common_img_title/p_text_title"
local p_btn_blur_path = "p_btn_blur"
local p_btn_close_path = "Root/bg/title/p_btn_close"
local p_text_desc_top_path = "Root/bg/content/p_text_desc_top"
local p_go_select_left_path = "Root/bg/content/option_left/p_go_select_left"
local p_btn_select_left_path = "Root/bg/content/option_left/p_btn_select_left"
local p_go_select_right_path = "Root/bg/content/option_right/p_go_select_right"
local p_btn_select_right_path = "Root/bg/content/option_right/p_btn_select_right"
local p_content_btn_path = "Root/bg/p_content_btn"
local p_btn_select_path = "Root/bg/p_content_btn/p_btn_select"
local p_text_btn_select_path = "Root/bg/p_content_btn/p_btn_select/base/p_text_btn_select"
local base = UIBaseView
local S6SelectCampSelectView = BaseClass("S6SelectCampSelectView", UIBaseView)

function S6SelectCampSelectView:ComponentDefine()
  self.p_text_title = self:AddComponent(UITextMeshProUGUIEx, p_text_title_path)
  self.p_btn_blur = self:AddComponent(UIButton, p_btn_blur_path)
  self.p_btn_blur:SetOnClick(BindCallback(self, self.OnCloseClicked))
  self.p_btn_close = self:AddComponent(UIButton, p_btn_close_path)
  self.p_btn_close:SetOnClick(BindCallback(self, self.OnCloseClicked))
  self.p_content_btn = self:AddComponent(UIBaseContainer, p_content_btn_path)
  self.p_btn_select = self:AddComponent(UIButton, p_btn_select_path)
  self.p_btn_select:SetOnClick(BindCallback(self, self.OnSelectClicked))
  self.p_text_btn_select = self:AddComponent(UITextMeshProUGUIEx, p_text_btn_select_path)
  self.p_text_desc_top = self:AddComponent(UITextMeshProUGUIEx, p_text_desc_top_path)
  self.p_go_select_left = self:AddComponent(UIImage, p_go_select_left_path)
  self.p_btn_select_left = self:AddComponent(UIButton, p_btn_select_left_path)
  self.p_btn_select_left:SetOnClick(BindCallback(self, self.OnLeftClicked))
  self.p_go_select_right = self:AddComponent(UIImage, p_go_select_right_path)
  self.p_btn_select_right = self:AddComponent(UIButton, p_btn_select_right_path)
  self.p_btn_select_right:SetOnClick(BindCallback(self, self.OnRightClicked))
end

function S6SelectCampSelectView:ComponentDestroy()
  self.p_text_title = nil
  self.p_btn_blur = nil
  self.p_btn_close = nil
  self.p_text_desc_top = nil
  self.p_go_select_left = nil
  self.p_btn_select_left = nil
  self.p_go_select_right = nil
  self.p_btn_select_right = nil
  self.p_content_btn = nil
  self.p_btn_select = nil
  self.p_text_btn_select = nil
end

function S6SelectCampSelectView:DataDefine()
end

function S6SelectCampSelectView:DataDestroy()
  self.Data = nil
end

function S6SelectCampSelectView:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
  self:ReInit(self:GetUserData())
end

function S6SelectCampSelectView:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function S6SelectCampSelectView:OnAddListener()
  base.OnAddListener(self)
end

function S6SelectCampSelectView:OnRemoveListener()
  base.OnRemoveListener(self)
end

function S6SelectCampSelectView:ReInit(data)
  if self:InitData(data) then
    self:InitUi()
  end
end

function S6SelectCampSelectView:InitData(data)
  if data ~= nil then
    self.Data = data
    self.InfoData = DataCenter.SeasonSelectCampManager.InfoData
    if self.InfoData ~= nil then
      self.MyCampData = self.InfoData:GetMyCampData()
      if self.MyCampData ~= nil then
        self.LastSelectId = self.MyCampData.SelectId
        self.CurSelect = -1
        return true
      end
    end
  end
  return false
end

function S6SelectCampSelectView:InitUi()
  self.p_text_title:SetText(self.Data.Title)
  local leftServerStr = table.concat(self.InfoData:GetCampDataByPos(1):GetServerStrList(), ",")
  local rightServerStr = table.concat(self.InfoData:GetCampDataByPos(2):GetServerStrList(), ",")
  self.p_text_desc_top:SetLocalText("season_s6_activity_1200080_desc03", rightServerStr, leftServerStr)
  if self.Data.ViewMode then
    self.p_content_btn:SetActive(false)
    self:SetSelect(0)
  else
    local selectId = checknumber(self.MyCampData.SelectId)
    local btnKey = 0 < selectId and "season_s6_activity_1200080_btn_04" or "season_s6_activity_1200080_btn_03"
    self.p_text_btn_select:SetLocalText(btnKey)
    self.p_content_btn:SetActive(true)
    self:SetSelect(selectId)
  end
  CS.UnityEngine.UI.LayoutRebuilder.ForceRebuildLayoutImmediate(self.p_content_btn.transform)
end

function S6SelectCampSelectView:SetSelect(selectId)
  if self.CurSelect == selectId then
    return
  end
  self.CurSelect = selectId
  self.p_go_select_left:SetActive(self.CurSelect == 1)
  self.p_go_select_right:SetActive(self.CurSelect == 2)
  local same = self.CurSelect == self.LastSelectId
  CS.UIGray.SetGray(self.p_btn_select.transform, same, true)
end

function S6SelectCampSelectView:OnBtnPBlurClick()
  self.ctrl:CloseSelf()
end

function S6SelectCampSelectView:OnCloseClicked()
  self.ctrl:CloseSelf()
end

function S6SelectCampSelectView:OnLeftClicked()
  if self.Data ~= nil and not self.Data.ViewMode then
    self:SetSelect(1)
  end
end

function S6SelectCampSelectView:OnRightClicked()
  if self.Data ~= nil and not self.Data.ViewMode then
    self:SetSelect(2)
  end
end

function S6SelectCampSelectView:OnSelectClicked()
  if self.Data ~= nil and not self.Data.ViewMode then
    self.ctrl:SendSelectCamp(self.CurSelect)
  end
end

return S6SelectCampSelectView
