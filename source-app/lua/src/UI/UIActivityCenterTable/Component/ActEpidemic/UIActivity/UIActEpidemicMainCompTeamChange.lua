local base = UIAsyncContainer
local UIActEpidemicMainCompTeamChange = BaseClass("UIActEpidemicMainCompTeamChange", base)
local Localization = CS.GameEntry.Localization

local function OnCreate(self, mainView)
  base.OnCreate(self)
  self.mainView = mainView
  self:ComponentDefine()
  self:DataDefine()
  self:Init()
end

local function OnDestroy(self)
  self.mainView = nil
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
  self.compRightNode = self:AddComponent(UIBaseContainer, "RightNode")
  self.btnLeft = self:AddComponent(UIButton, "BtnLeft")
  self.btnLeft:SetOnClick(function()
    self:OnBtnLeftClick()
  end)
  self.compLeftNode = self:AddComponent(UIBaseContainer, "LeftNode")
  self.btnRight = self:AddComponent(UIButton, "BtnRight")
  self.btnRight:SetOnClick(function()
    self:OnBtnRightClick()
  end)
  self.imgMyB = self:AddComponent(UIImage, "ImgMyB")
  self.imgMyA = self:AddComponent(UIImage, "ImgMyA")
  self.compImgBanB = self:AddComponent(UIBaseContainer, "imgBanB")
end

local function ComponentDestroy(self)
  self.compRightNode = nil
  self.btnLeft = nil
  self.compLeftNode = nil
  self.btnRight = nil
  self.imgMyB = nil
  self.imgMyA = nil
  self.compImgBanB = nil
end

local function DataDefine(self)
end

local function DataDestroy(self)
end

local function OnAddListener(self)
  base.OnAddListener(self)
end

local function OnRemoveListener(self)
  base.OnRemoveListener(self)
end

function UIActEpidemicMainCompTeamChange:Init()
  UIUtil.SetTextLit(self.transform, "LabelRight", "YiBianJinQu_event_name_2")
  UIUtil.SetTextLit(self.transform, "LabelLeft", "YiBianJinQu_event_name_2")
  UIUtil.SetTextLit(self.transform, "LeftNode/Label", "YiBianJinQu_event_name_2")
  UIUtil.SetTextLit(self.transform, "RightNode/Label", "YiBianJinQu_event_name_2")
  self:RefreshSelection()
end

function UIActEpidemicMainCompTeamChange:RefreshSelection()
  if not self.mainView then
    return
  end
  local idx = self.mainView:GetGroupIndex()
  self.compLeftNode:SetActive(idx == ActEpidemicUtils.Group1)
  self.compRightNode:SetActive(idx == ActEpidemicUtils.Group2)
end

function UIActEpidemicMainCompTeamChange:OnBtnLeftClick()
  self:TryChangeTeam(ActEpidemicUtils.Group1)
end

function UIActEpidemicMainCompTeamChange:OnBtnRightClick()
  self:TryChangeTeam(ActEpidemicUtils.Group2)
end

function UIActEpidemicMainCompTeamChange:TryChangeTeam(index)
  local info = ActEpidemicUtils.GetActInfo()
  if not info then
    return
  end
  self.mainView:SetGroupIndex(index)
end

local path_main_icon = "zyf_caozuojilu_jinru"
local path_sub_icon = "zyf_caozuojilu_tibu"
local path_ban_icon = "lrb_shamofengbao_jinyong"

function UIActEpidemicMainCompTeamChange:Show()
  self:SetActive(true)
  if not self:AsyncLoadDone() then
    return
  end
  local myInfo = ActEpidemicUtils.GetMyInfo()
  local banTeamB = ActEpidemicUtils.GetTeamBState() == EpidemicZoneSignState.StateBan
  self.compImgBanB:SetActive(banTeamB)
  if myInfo == nil then
    self.imgMyA:SetActive(false)
    self.imgMyB:SetActive(false)
  elseif myInfo.group == ActEpidemicUtils.Group1 then
    self.imgMyA:SetActive(true)
    self.imgMyB:SetActive(false)
    self.imgMyA:LoadSpriteAuto(string.format(LoadPath.LWBattleFieldEpidemicPath, myInfo.state == 1 and path_main_icon or path_sub_icon))
  elseif myInfo.group == ActEpidemicUtils.Group2 then
    self.imgMyA:SetActive(false)
    self.imgMyB:SetActive(not banTeamB)
    self.imgMyB:LoadSpriteAuto(string.format(LoadPath.LWBattleFieldEpidemicPath, myInfo.state == 1 and path_main_icon or path_sub_icon))
  else
    self.imgMyA:SetActive(false)
    self.imgMyB:SetActive(false)
  end
end

function UIActEpidemicMainCompTeamChange:Hide()
  self:SetActive(false)
  if self:AsyncLoadDone() then
    return
  end
end

UIActEpidemicMainCompTeamChange.OnCreate = OnCreate
UIActEpidemicMainCompTeamChange.OnDestroy = OnDestroy
UIActEpidemicMainCompTeamChange.OnEnable = OnEnable
UIActEpidemicMainCompTeamChange.OnDisable = OnDisable
UIActEpidemicMainCompTeamChange.ComponentDefine = ComponentDefine
UIActEpidemicMainCompTeamChange.ComponentDestroy = ComponentDestroy
UIActEpidemicMainCompTeamChange.DataDefine = DataDefine
UIActEpidemicMainCompTeamChange.DataDestroy = DataDestroy
UIActEpidemicMainCompTeamChange.OnAddListener = OnAddListener
UIActEpidemicMainCompTeamChange.OnRemoveListener = OnRemoveListener
return UIActEpidemicMainCompTeamChange
