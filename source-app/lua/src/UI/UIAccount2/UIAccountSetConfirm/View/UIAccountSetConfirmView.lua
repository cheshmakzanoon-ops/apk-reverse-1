local UIAccountSetConfirmView = BaseClass("UIAccountSetConfirmView", UIBaseView)
local base = UIBaseView
local Localization = CS.GameEntry.Localization

local function OnCreate(self)
  base.OnCreate(self)
  self.param = self:GetUserData()
  self:ComponentDefine()
  self:RefreshView()
end

local function OnDestroy(self)
  self:ComponentDestroy()
  base.OnDestroy(self)
end

local function ComponentDefine(self)
  self.btnClose = self:AddComponent(UIButton, "UIAccountPopUpTitle/CloseBtn")
  self.btnClose:SetOnClick(BindCallback(self.ctrl, self.ctrl.CloseSelf))
  self.textTitle = self:AddComponent(UIText, "UIAccountPopUpTitle/titleText")
  self.des = self:AddComponent(UIText, "Root/ContentTxt")
  self.btnConfirm = self:AddComponent(UIButton, "Root/BtnConfirm")
  self.btnConfirm:SetOnClick(BindCallback(self, self.OnBtnConfirmClick))
  self.btnCancel = self:AddComponent(UIButton, "Root/BtnCancel")
  self.btnCancel:SetOnClick(BindCallback(self, self.OnBtnCancelClick))
  self.icon = self:AddComponent(UICommonHead, "Root/UIPlayerHead")
  self.nameTxt = self:AddComponent(UIText, "Root/NameTxt")
end

local function ComponentDestroy(self)
  self.btnClose = nil
  self.textTitle = nil
  self.des = nil
  self.btnConfirm = nil
  self.btnCancel = nil
  self.icon = nil
  self.nameTxt = nil
end

local function RefreshView(self)
  if self.param == nil then
    return
  end
  local titleStr = ""
  if self.param.title then
    titleStr = self.param.title
  end
  self.textTitle:SetText(titleStr)
  local contentStr = ""
  if self.param.content then
    contentStr = self.param.content
  end
  self.des:SetText(contentStr)
  local uid = DataCenter.PlayerInfoDataManager:GetSelfUid()
  local pic = LuaEntry.Player:GetPic()
  local picVer = LuaEntry.Player:GetValue("picVer")
  local headBg = LuaEntry.Player:GetHeadBgImg()
  local name = LuaEntry.Player:GetName()
  self.icon:SetData(uid, pic, picVer, nil, headBg)
  self.nameTxt:SetText(name)
end

local function OnBtnConfirmClick(self)
  if self.param == nil then
    return
  end
  if DataCenter.AllianceBaseDataManager:IsR5() then
    UIManager:GetInstance():OpenWindow(UIWindowNames.UIAccountIsR5Confirm)
  else
    local confirmFunc = self.param.confirmFunc
    if confirmFunc then
      confirmFunc(self.param)
    end
  end
  self.ctrl:CloseSelf()
end

local function OnBtnCancelClick(self)
  self.ctrl:CloseSelf()
end

UIAccountSetConfirmView.OnCreate = OnCreate
UIAccountSetConfirmView.OnDestroy = OnDestroy
UIAccountSetConfirmView.ComponentDefine = ComponentDefine
UIAccountSetConfirmView.ComponentDestroy = ComponentDestroy
UIAccountSetConfirmView.RefreshView = RefreshView
UIAccountSetConfirmView.OnBtnConfirmClick = OnBtnConfirmClick
UIAccountSetConfirmView.OnBtnCancelClick = OnBtnCancelClick
return UIAccountSetConfirmView
