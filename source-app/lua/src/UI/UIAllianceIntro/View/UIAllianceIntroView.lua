local base = UIBaseView
local UIAllianceIntroView = BaseClass("UIAllianceIntroView", base)
local Localization = CS.GameEntry.Localization
local title_path = "UICommonPopUpTitle/Common_img_title/titleText"
local goal_path = "offset/Goal"
local tip1_path = "offset/tips/star1/tip1"
local tip2_path = "offset/tips/star2/tip2"
local tip3_path = "offset/tips/star3/tip3"
local tip4_path = "offset/tips/star4/tip4"
local joinBtn_path = "offset/joinBtn"
local joinBtnTxt_path = "offset/joinBtn/joinBtnTxt"
local createBtn_path = "offset/createBtn"
local createBtnTxt_path = "offset/createBtn/createBtnTxt"
local closeBtn_path = "UICommonPopUpTitle/CloseBtn"

local function OnCreate(self)
  base.OnCreate(self)
  self:ComponentDefine()
  self:ReInit()
end

local function OnDestroy(self)
  self:ComponentDestroy()
  base.OnDestroy(self)
end

local function ComponentDefine(self)
  self.titleN = self:AddComponent(UIText, title_path)
  self.titleN:SetLocalText(390002)
  self.goalN = self:AddComponent(UIText, goal_path)
  self.goalN:SetLocalText(390850)
  self.tip1N = self:AddComponent(UIText, tip1_path)
  self.tip1N:SetLocalText(390851)
  self.tip2N = self:AddComponent(UIText, tip2_path)
  self.tip2N:SetLocalText(390852)
  self.tip3N = self:AddComponent(UIText, tip3_path)
  self.tip3N:SetLocalText(390853)
  self.tip4N = self:AddComponent(UIText, tip4_path)
  self.tip4N:SetLocalText(390853)
  self.tip4N:SetActive(false)
  self.joinBtnN = self:AddComponent(UIButton, joinBtn_path)
  self.joinBtnN:SetOnClick(function()
    self:OnClickJoinBtn()
  end)
  self.joinBtnTxtN = self:AddComponent(UIText, joinBtnTxt_path)
  self.joinBtnTxtN:SetLocalText(110037)
  self.createBtnN = self:AddComponent(UIButton, createBtn_path)
  self.createBtnN:SetOnClick(function()
    self:OnClickCreateBtn()
  end)
  self.createBtnTxtN = self:AddComponent(UIText, createBtnTxt_path)
  self.createBtnTxtN:SetLocalText(100645)
  self.closeBtnN = self:AddComponent(UIButton, closeBtn_path)
  self.closeBtnN:SetOnClick(function()
    self:OnClickCloseBtn()
  end)
end

local function ComponentDestroy(self)
  self.goalN = nil
  self.tip1N = nil
  self.tip2N = nil
  self.tip3N = nil
  self.tip4N = nil
  self.joinBtnN = nil
  self.joinBtnTxtN = nil
  self.createBtnN = nil
  self.createBtnTxtN = nil
  self.closeBtnN = nil
end

local function ReInit(self)
  local isArrow = self:GetUserData()
  if isArrow then
    local param = {}
    param.position = self.joinBtnN.transform.position
    param.arrowType = ArrowType.Capacity
    param.positionType = PositionType.Screen
    DataCenter.ArrowManager:ShowArrow(param)
  end
end

local function OnClickCreateBtn(self)
  self.ctrl:OnClickCreateBtn()
end

local function OnClickJoinBtn(self)
  self.ctrl:OnClickJoinBtn()
end

local function OnClickCloseBtn(self)
  self.ctrl:CloseSelf()
end

UIAllianceIntroView.OnCreate = OnCreate
UIAllianceIntroView.OnDestroy = OnDestroy
UIAllianceIntroView.ComponentDefine = ComponentDefine
UIAllianceIntroView.ReInit = ReInit
UIAllianceIntroView.ComponentDestroy = ComponentDestroy
UIAllianceIntroView.OnClickCreateBtn = OnClickCreateBtn
UIAllianceIntroView.OnClickJoinBtn = OnClickJoinBtn
UIAllianceIntroView.OnClickCloseBtn = OnClickCloseBtn
return UIAllianceIntroView
