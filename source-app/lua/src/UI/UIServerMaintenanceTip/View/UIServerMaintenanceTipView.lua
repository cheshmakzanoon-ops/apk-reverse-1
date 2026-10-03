local UIServerMaintenanceTipView = BaseClass("UIServerMaintenanceTipView", UIBaseView)
local base = UIBaseView
local title_path = "Layout/UICommonPopBg/TitleTxt"
local return_btn_path = "panel"
local close_btn_path = "Layout/UICommonPopBg/CloseBtn"
local tips_txt_path = "Layout/DesName"
local btn_1_path = "Layout/BtnGo/LeftBtn"
local btn_1_txt_path = "Layout/BtnGo/LeftBtn/LeftBtnName"
local btn_2_path = "Layout/BtnGo/RightBtn"
local btn_2_txt_path = "Layout/BtnGo/RightBtn/RightBtnName"
local common_pop_bg_path = "Layout/UICommonPopBg"
local time_root_path = "Layout/timeRoot"
local time_path = "Layout/timeRoot/time"

function UIServerMaintenanceTipView:OnCreate()
  base.OnCreate(self)
  self.common_pop_bg = self:AddComponent(UIBaseContainer, common_pop_bg_path)
  self.title = self:AddComponent(UIText, title_path)
  self.tips_txt = self:AddComponent(UIText, tips_txt_path)
  self.time_root = self:AddComponent(UIBaseContainer, time_root_path)
  self.time_txt = self:AddComponent(UIText, time_path)
  self.btn_1 = self:AddComponent(UIButton, btn_1_path)
  self.btn_1_txt = self:AddComponent(UIText, btn_1_txt_path)
  self.btn_2 = self:AddComponent(UIButton, btn_2_path)
  self.btn_2_txt = self:AddComponent(UIText, btn_2_txt_path)
  self.close_btn = self:AddComponent(UIButton, close_btn_path)
  self.return_btn = self:AddComponent(UIButton, return_btn_path)
  self.content = self:AddComponent(UIHorizontalOrVerticalLayoutGroup, "Layout")
  self.btn_1:SetOnClick(function()
    local param = self.param
    self.ctrl:CloseSelf()
    if param and param.funNG then
      pcall(param.funNG)
    end
  end)
  self.btn_2:SetOnClick(function()
    local param = self.param
    self.ctrl:CloseSelf()
    if param and param.funOK then
      pcall(param.funOK)
    end
  end)
  self.close_btn:SetOnClick(function()
    local param = self.param
    self.ctrl:CloseSelf()
    if param and param.funClose then
      pcall(param.funClose)
    end
  end)
  self.return_btn:SetOnClick(function()
    local param = self.param
    self.ctrl:CloseSelf()
    if param and param.funClose then
      pcall(param.funClose)
    end
  end)
end

function UIServerMaintenanceTipView:OnDestroy()
  self.common_pop_bg = nil
  self.time_root = nil
  base.OnDestroy(self)
end

function UIServerMaintenanceTipView:OnEnable()
  base.OnEnable(self)
  self:RefreshData()
end

function UIServerMaintenanceTipView:OnDisable()
  base.OnDisable(self)
end

function UIServerMaintenanceTipView:Update100MS()
  if self.param ~= nil and self.param.time ~= nil and self.param.time ~= 0 then
    local now = UITimeManager:GetInstance():GetServerTime()
    local remainTime = self.param.time - now
    if 0 < remainTime then
      local remainTimeStr = UITimeManager:GetInstance():MilliSecondToFmtString(remainTime)
      self.time_txt:SetText(remainTimeStr)
    else
      self.param.time = nil
      self.time_root:SetActive(false)
    end
  end
end

function UIServerMaintenanceTipView:RefreshData()
  local param = self:GetUserData()
  self.param = param
  if param == nil then
    self.title:SetLocalText(100378)
    self.tips_txt:SetLocalText("login_err_tips_maintenance_new")
    self.btn_1:SetActive(false)
    self.btn_2:SetActive(false)
    self.time_root:SetActive(false)
  else
    self.title:SetLocalText(param.title or 100378)
    self.tips_txt:SetText(param.desc)
    self.btn_1:SetActive(param.funNG ~= nil or param.showCancelBtn)
    self.btn_2:SetActive(param.funOK ~= nil)
    if param.textOK then
      self.btn_2_txt:SetLocalText(param.textOK)
    else
      self.btn_2_txt:SetLocalText(GameDialogDefine.CONFIRM)
    end
    if param.textNG then
      self.btn_1_txt:SetLocalText(param.textNG)
    else
      self.btn_1_txt:SetLocalText(GameDialogDefine.CANCEL)
    end
    self.time_root:SetActive(self.param.time ~= nil and self.param.time ~= 0)
    self:Update100MS()
  end
  CS.UnityEngine.UI.LayoutRebuilder.ForceRebuildLayoutImmediate(self.tips_txt.transform)
  CS.UnityEngine.UI.LayoutRebuilder.ForceRebuildLayoutImmediate(self.content.transform)
  CS.UnityEngine.UI.LayoutRebuilder.ForceRebuildLayoutImmediate(self.common_pop_bg.transform)
end

return UIServerMaintenanceTipView
