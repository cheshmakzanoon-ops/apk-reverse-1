local UIPositionTipView = BaseClass("UIPositionTipView", UIBaseView)
local base = UIBaseView
local Localization = CS.GameEntry.Localization
local return_btn_path = "Panel"
local bg_path = "ImgBg/bg"
local server_input_path = "ImgBg/serverInputField"
local server_txt_path = "ImgBg/serverDesText"
local x_input_path = "ImgBg/xInputField"
local x_input_placeholder_path = "ImgBg/xInputField/xPlaceholder"
local x_txt_path = "ImgBg/xDesField"
local y_input_path = "ImgBg/yInputField"
local y_input_placeholder_path = "ImgBg/yInputField/yPlaceholder"
local y_txt_path = "ImgBg/yDesField"
local btn_path = "ImgBg/jumpBtn"
local search_path = "ImgBg/searchBtn"
local search_txt_path = "ImgBg/searchBtn/searchText"
local favorite_path = "ImgBg/favoriteBtn"
local favorite_txt_path = "ImgBg/favoriteBtn/favoriteText"

local function OnCreate(self)
  base.OnCreate(self)
  self.return_btn = self:AddComponent(UIButton, return_btn_path)
  self.return_btn:SetOnClick(function()
    self.ctrl:CloseSelf()
  end)
  self.server_input = self:AddComponent(UIInput, server_input_path)
  self.server_input:SetOnEndEdit(function(value)
    self:IptOnServerValueChange(value)
  end)
  self.server_txt = self:AddComponent(UIText, server_txt_path)
  self.server_txt:SetLocalText(280068)
  self.x_input = self:AddComponent(UIInput, x_input_path)
  self.x_input:SetOnEndEdit(function(value)
    self:IptOnXValueChange(value)
  end)
  self.x_input_placeholder = self:AddComponent(UIText, x_input_placeholder_path)
  self.x_input_placeholder:SetText("")
  self.y_input = self:AddComponent(UIInput, y_input_path)
  self.y_input:SetOnEndEdit(function(value)
    self:IptOnYValueChange(value)
  end)
  self.y_input_placeholder = self:AddComponent(UIText, y_input_placeholder_path)
  self.y_input_placeholder:SetText("")
  self.btn = self:AddComponent(UIButton, btn_path)
  self.btn:SetOnClick(function()
    DataCenter.LWSoundManager:PlayEffect(SoundAssetId.SFX_UI_General_Click_1st)
    self:OnClickJump()
  end)
  self.btn_search = self:AddComponent(UIButton, search_path)
  self.btn_search:SetOnClick(function()
    DataCenter.LWSoundManager:PlayEffect(SoundAssetId.SFX_UI_General_Click_1st)
    self:OnClickSearch()
  end)
  self.btn_search_txt = self:AddComponent(UIText, search_txt_path)
  self.btn_search_txt:SetLocalText(GameDialogDefine.SEARCHING_MONSTER)
  self.btn_favorite = self:AddComponent(UIButton, favorite_path)
  self.btn_favorite:SetOnClick(function()
    DataCenter.LWSoundManager:PlayEffect(SoundAssetId.SFX_UI_General_Click_1st)
    self:OnClickFavorite()
  end)
  self.btn_favorite_txt = self:AddComponent(UIText, favorite_txt_path)
  self.btn_favorite_txt:SetLocalText(100188)
  self.server = -1
  self.x = -1
  self.y = -1
end

local function OnDestroy(self)
  self.server_input = nil
  self.server_txt = nil
  self.x_input = nil
  self.y_input = nil
  self.btn = nil
  self.btn_search = nil
  self.btn_search_txt = nil
  self.btn_favorite = nil
  self.btn_favorite_txt = nil
  self.server = nil
  self.x = nil
  self.y = nil
  base.OnDestroy(self)
end

local function OnEnable(self)
  base.OnEnable(self)
  self:InitState()
end

local function OnDisable(self)
  base.OnDisable(self)
end

local function InitState(self)
  local data = self.ctrl:GetCurrentState()
  self.server = data.serverId
  self.x = data.x
  self.y = data.y
  self.server_input:SetText(self.server)
  self.x_input:SetText("")
  self.y_input:SetText("")
end

local function IptOnServerValueChange(self, value)
  self.server = tonumber(value)
end

local function IptOnXValueChange(self, value)
  self.x = tonumber(value)
end

local function IptOnYValueChange(self, value)
  self.y = tonumber(value)
end

local function OnClickJump(self)
  if self.ctrl:CheckCanGo(self.server, self.x, self.y) == false then
    UIUtil.ShowTips(Localization:GetString(CS.GameDialogDefine.OUT_UNLOCK_RANGE_REASON, CS.SceneManager.World.CurTileCountXMin, CS.SceneManager.World.CurTileCountYMin, CS.SceneManager.World.CurTileCountXMax, CS.SceneManager.World.CurTileCountYMax))
  else
    self.ctrl:OnJumpClick(self.server, self.x, self.y)
  end
end

local function OnClickSearch(self)
  GoToUtil.GotoOpenView(UIWindowNames.UISearch)
end

local function OnClickFavorite(self)
  GoToUtil.GotoOpenView(UIWindowNames.UIPositionFavorite)
end

UIPositionTipView.OnCreate = OnCreate
UIPositionTipView.OnDestroy = OnDestroy
UIPositionTipView.InitState = InitState
UIPositionTipView.OnEnable = OnEnable
UIPositionTipView.OnDisable = OnDisable
UIPositionTipView.IptOnServerValueChange = IptOnServerValueChange
UIPositionTipView.IptOnXValueChange = IptOnXValueChange
UIPositionTipView.IptOnYValueChange = IptOnYValueChange
UIPositionTipView.OnClickJump = OnClickJump
UIPositionTipView.OnClickSearch = OnClickSearch
UIPositionTipView.OnClickFavorite = OnClickFavorite
return UIPositionTipView
