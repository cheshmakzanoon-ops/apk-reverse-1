local UIFormationSoldierChooseView = BaseClass("UIFormationSoldierChooseView", UIBaseView)
local base = UIBaseView
local Localization = CS.GameEntry.Localization
local return_btn_path = "Panel"
local content_path = "ScrollView/Viewport/Content"
local soldier_num_path = "troopIcon/soldierNum"
local one_key_btn_path = "onekeyBtn"
local save_btn_path = "saveBtn"
local save_txt_path = "saveBtn/saveText"
local one_key_txt_path = "onekeyBtn/onekeyTxt"

local function OnCreate(self)
  base.OnCreate(self)
  self.ctrl:InitData(self:GetUserData())
  self.return_btn = self:AddComponent(UIButton, return_btn_path)
  self.return_btn:SetOnClick(function()
    self.ctrl:CloseSelf()
  end)
  self.content = self:AddComponent(UIBaseContainer, content_path)
  self.army_num = self:AddComponent(UIText, soldier_num_path)
  self.one_key_btn = self:AddComponent(UIButton, one_key_btn_path)
  self.one_key_btn:SetOnClick(function()
    DataCenter.LWSoundManager:PlayEffect(SoundAssetId.SFX_UI_General_Click_1st)
    if self.oneKeyFill then
      self.ctrl:OnOneKeyFillClick()
    else
      self.ctrl:OnOneKeyClearClick()
    end
    self:UpdateArmyContent()
  end)
  self.one_key_txt = self:AddComponent(UIText, one_key_txt_path)
  self.save_btn = self:AddComponent(UIButton, save_btn_path)
  self.save_btn:SetOnClick(function()
    DataCenter.LWSoundManager:PlayEffect(SoundAssetId.SFX_UI_General_Click_1st)
    self.ctrl:OnSaveClick()
  end)
  self.save_txt = self:AddComponent(UIText, save_txt_path)
  self.save_txt:SetLocalText(300055)
end

local function OnDestroy(self)
  self.return_btn = nil
  self.content = nil
  self.army_num = nil
  self.one_key_btn = nil
  self.save_btn = nil
  base.OnDestroy(self)
end

local function InitView(self)
  self:UpdateArmyContent()
end

local function ClearContent(self)
  self.model = {}
end

local function UpdateArmyContent(self)
end

local function UpdateViewState(self)
  local maxSoldier = self.ctrl:GetMaxSoldier()
  local currentTotal = self.ctrl:GetTotalSoldierNum()
  self.oneKeyFill = maxSoldier > currentTotal
  if self.oneKeyFill then
    self.one_key_txt:SetText("MAX")
  else
    self.one_key_txt:SetText("CLEAR")
  end
  self.army_num:SetText(string.GetFormattedSeperatorNum(math.floor(currentTotal)) .. " / " .. string.GetFormattedSeperatorNum(math.floor(maxSoldier)))
end

local function OnEnable(self)
  base.OnEnable(self)
  self:InitView()
end

local function OnDisable(self)
  base.OnDisable(self)
end

UIFormationSoldierChooseView.OnCreate = OnCreate
UIFormationSoldierChooseView.OnDestroy = OnDestroy
UIFormationSoldierChooseView.OnEnable = OnEnable
UIFormationSoldierChooseView.OnDisable = OnDisable
UIFormationSoldierChooseView.InitView = InitView
UIFormationSoldierChooseView.UpdateArmyContent = UpdateArmyContent
UIFormationSoldierChooseView.UpdateViewState = UpdateViewState
UIFormationSoldierChooseView.ClearContent = ClearContent
return UIFormationSoldierChooseView
