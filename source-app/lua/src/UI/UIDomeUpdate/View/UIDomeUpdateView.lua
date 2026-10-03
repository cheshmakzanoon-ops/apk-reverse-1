local UIDomeUpdateView = BaseClass("UIDomeUpdateView", UIBaseView)
local base = UIBaseView
local Localization = CS.GameEntry.Localization
local title_path = "title_main"
local return_btn_path = "panel"
local close_btn_path = "CloseBtn"
local enter_btn_path = "BtnGo/RightBtn"
local cancel_btn_path = "BtnGo/LeftBtn"

local function OnCreate(self)
  base.OnCreate(self)
  self.buildUuid = tonumber(self:GetUserData())
  self.close_btn = self:AddComponent(UIButton, close_btn_path)
  self.return_btn = self:AddComponent(UIButton, return_btn_path)
  self.enter_btn = self:AddComponent(UIButton, enter_btn_path)
  self.enter_btn:SetOnClick(function()
    DataCenter.LWSoundManager:PlayEffect(SoundAssetId.SFX_UI_General_Click_1st)
    self:OnAddClick()
  end)
  self.cancel_btn = self:AddComponent(UIButton, cancel_btn_path)
  self.cancel_btn:SetOnClick(function()
    self.ctrl:CloseSelf()
    GoToUtil.GotoPos(CS.SceneManager.World.CurTarget, CS.SceneManager.World.InitZoom, LookAtFocusTime)
  end)
  self.close_btn:SetOnClick(function()
    self.ctrl:CloseSelf()
    GoToUtil.GotoPos(CS.SceneManager.World.CurTarget, CS.SceneManager.World.InitZoom, LookAtFocusTime)
  end)
  self.return_btn:SetOnClick(function()
    self.ctrl:CloseSelf()
    GoToUtil.GotoPos(CS.SceneManager.World.CurTarget, CS.SceneManager.World.InitZoom, LookAtFocusTime)
  end)
end

local function OnDestroy(self)
  self.close_btn = nil
  self.return_btn = nil
  self.enter_btn = nil
  self.cancel_btn = nil
  base.OnDestroy(self)
end

local function OnEnable(self)
  base.OnEnable(self)
end

local function OnDisable(self)
  base.OnDisable(self)
end

local function RefreshData(self)
  self.title:SetLocalText(GameDialogDefine.BUY)
  self.tips_txt:SetLocalText(120030)
  self.btn_des:SetLocalText(GameDialogDefine.CONFIRM)
  self.btn_num:SetText(math.floor(DataCenter.FactoryDataManager:GetAddPlanZoneCost()))
end

local function OnAddClick(self)
  CS.FreeBuildingExpendDomeMessage.Instance:Send()
  DataCenter.BuildBubbleManager:DeleteOneBuildBubble(self.buildUuid)
  self.ctrl:CloseSelf()
end

UIDomeUpdateView.OnCreate = OnCreate
UIDomeUpdateView.OnDestroy = OnDestroy
UIDomeUpdateView.OnEnable = OnEnable
UIDomeUpdateView.OnDisable = OnDisable
UIDomeUpdateView.RefreshData = RefreshData
UIDomeUpdateView.OnAddClick = OnAddClick
return UIDomeUpdateView
