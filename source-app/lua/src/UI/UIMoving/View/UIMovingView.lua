local UIMovingView = BaseClass("UIMovingView", UIBaseView)
local base = UIBaseView
local btn_path = "panel"
local des_path = "Text_Des"

local function OnCreate(self)
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
  self:ReInit()
end

local function OnDestroy(self)
  self:ComponentDestroy()
  self:DataDestroy()
  EventManager:GetInstance():Broadcast(EventId.OnCloseUIMovingView, false)
  base.OnDestroy(self)
end

local function ComponentDefine(self)
  self.txt = self:AddComponent(UITextMeshProUGUIEx, des_path)
  self.btn = self:AddComponent(UIButton, btn_path)
  self.btn:SetOnClick(function()
    self:OnBtnClick()
  end)
  local toServerId = self:GetUserData()
  if toInt(toServerId) > 0 then
    local loginServerId = LuaEntry.Player:GetSelfServerId()
    self.txt:SetLocalText("s5_allianceflag_tips02", loginServerId, toServerId)
  else
    self.txt:SetLocalText(121270)
  end
end

local function ComponentDestroy(self)
  self.btn = nil
end

local function DataDefine(self)
  self.clickTime = 0
end

local function DataDestroy(self)
  self.clickTime = nil
end

local function OnEnable(self)
  base.OnEnable(self)
end

local function OnDisable(self)
  base.OnDisable(self)
end

local function ReInit(self)
  self.clickTime = 0
end

local function OnBtnClick(self)
  self.clickTime = self.clickTime + 1
  if self.clickTime >= GuideClickAutoStopTime then
    self.clickTime = 0
    self.ctrl:CloseSelf()
  end
end

local function CloseSignal(self, data)
  self.ctrl:CloseSelf()
end

UIMovingView.OnCreate = OnCreate
UIMovingView.OnDestroy = OnDestroy
UIMovingView.OnEnable = OnEnable
UIMovingView.OnDisable = OnDisable
UIMovingView.ComponentDefine = ComponentDefine
UIMovingView.ComponentDestroy = ComponentDestroy
UIMovingView.DataDefine = DataDefine
UIMovingView.DataDestroy = DataDestroy
UIMovingView.ReInit = ReInit
UIMovingView.OnBtnClick = OnBtnClick
UIMovingView.CloseSignal = CloseSignal
return UIMovingView
