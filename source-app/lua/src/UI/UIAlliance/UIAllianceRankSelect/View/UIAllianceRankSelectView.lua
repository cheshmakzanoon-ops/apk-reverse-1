local UIAllianceRankSelectView = BaseClass("UIAllianceRankSelectView", UIBaseView)
local base = UIBaseView
local Localization = CS.GameEntry.Localization
local title_path = "ImgBg/TxtTitle"
local btn_group_path = "ImgBg/checkObj"
local set_txt_path = "ImgBg/setBtn/setText"
local rank1_toggle_path = "ImgBg/checkObj/item1"
local rank2_toggle_path = "ImgBg/checkObj/item2"
local rank3_toggle_path = "ImgBg/checkObj/item3"
local rank4_toggle_path = "ImgBg/checkObj/item4"
local set_btn_path = "ImgBg/setBtn"
local return_btn_path = "Panel"
local close_btn_path = "ImgBg/BtnClose"

local function OnCreate(self)
  base.OnCreate(self)
  local selfRank, uid, showRankNum = self:GetUserData()
  self.selfRank = tonumber(selfRank)
  self.uid = tostring(uid)
  self.index = self.selfRank
  self.title = self:AddComponent(UIText, title_path)
  self.title:SetLocalText(390877)
  self.rank1_toggle = self:AddComponent(UIToggle, rank1_toggle_path)
  self.rank1_toggle:SetActive(1 <= showRankNum)
  self.rank1_toggle:SetIsOn(self.selfRank == 1)
  self.rank1_toggle:SetOnValueChanged(function(tf)
    if tf then
      self:ToggleControlBorS()
    end
  end)
  self.rank2_toggle = self:AddComponent(UIToggle, rank2_toggle_path)
  self.rank2_toggle:SetActive(2 <= showRankNum)
  self.rank2_toggle:SetIsOn(self.selfRank == 2)
  self.rank2_toggle:SetOnValueChanged(function(tf)
    if tf then
      self:ToggleControlBorS()
    end
  end)
  self.rank3_toggle = self:AddComponent(UIToggle, rank3_toggle_path)
  self.rank3_toggle:SetActive(3 <= showRankNum)
  self.rank3_toggle:SetIsOn(self.selfRank == 3)
  self.rank3_toggle:SetOnValueChanged(function(tf)
    if tf then
      self:ToggleControlBorS()
    end
  end)
  self.rank4_toggle = self:AddComponent(UIToggle, rank4_toggle_path)
  self.rank4_toggle:SetActive(4 <= showRankNum)
  self.rank4_toggle:SetIsOn(self.selfRank == 4)
  self.rank4_toggle:SetOnValueChanged(function(tf)
    if tf then
      self:ToggleControlBorS()
    end
  end)
  self.set_btn = self:AddComponent(UIButton, set_btn_path)
  self.set_btn:SetOnClick(function()
    DataCenter.LWSoundManager:PlayEffect(SoundAssetId.SFX_UI_General_Click_1st)
    self:OnSetClick()
  end)
  self.set_txt = self:AddComponent(UIText, set_txt_path)
  self.set_txt:SetLocalText(110006)
  self.close_btn = self:AddComponent(UIButton, close_btn_path)
  self.close_btn:SetOnClick(function()
    self.ctrl:CloseSelf()
  end)
  self.return_btn = self:AddComponent(UIButton, return_btn_path)
  self.return_btn:SetOnClick(function()
    self.ctrl:CloseSelf()
  end)
end

local function OnDestroy(self)
  self.selfRank = nil
  self.officialNum = nil
  self.uid = nil
  self.title = nil
  self.image1 = nil
  self.image2 = nil
  self.image3 = nil
  self.image4 = nil
  self.btn1 = nil
  self.btn2 = nil
  self.btn3 = nil
  self.btn4 = nil
  self.btn_group = nil
  self.set_btn = nil
  self.set_txt = nil
  self.return_btn = nil
  base.OnDestroy(self)
end

local function OnEnable(self)
  base.OnEnable(self)
end

local function OnDisable(self)
  base.OnDisable(self)
end

local function OnSetClick(self)
  if self.index == 4 then
    local list = DataCenter.AllianceMemberDataManager:GetAllianceMemberListByRank(self.index)
    local k1 = LuaEntry.DataConfig:TryGetNum("alliance_player_limit", "k1")
    if k1 <= #list then
      UIUtil.ShowTipsId(390878)
      return
    end
  end
  self.ctrl:OnSetRank(self.uid, self.index)
end

local function ToggleControlBorS(self)
  if self.rank1_toggle:GetIsOn() then
    self.index = 1
  elseif self.rank2_toggle:GetIsOn() then
    self.index = 2
  elseif self.rank3_toggle:GetIsOn() then
    self.index = 3
  elseif self.rank4_toggle:GetIsOn() then
    self.index = 4
  end
end

UIAllianceRankSelectView.OnCreate = OnCreate
UIAllianceRankSelectView.OnDestroy = OnDestroy
UIAllianceRankSelectView.OnEnable = OnEnable
UIAllianceRankSelectView.OnDisable = OnDisable
UIAllianceRankSelectView.OnSetClick = OnSetClick
UIAllianceRankSelectView.ToggleControlBorS = ToggleControlBorS
return UIAllianceRankSelectView
