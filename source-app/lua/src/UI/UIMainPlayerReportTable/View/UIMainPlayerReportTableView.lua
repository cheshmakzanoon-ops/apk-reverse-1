local PlayerResourceReport = require("UI.UIMainPlayerReportTable.Component.PlayerResourceReport")
local PlayerBuildingReport = require("UI.UIMainPlayerReportTable.Component.PlayerBuildingReport")
local UIMainPlayerReportTableView = BaseClass("UIMainPlayerReportTableView", UIBaseView)
local base = UIBaseView
local Localization = CS.GameEntry.Localization
local txt_title_path = "ImgBg/TxtTitle"
local toogle1_path = "ImgBg/Tab/Toggle1"
local toogle2_path = "ImgBg/Tab/Toggle2"
local toogle3_path = "ImgBg/Tab/Toggle3"
local toogle4_path = "ImgBg/Tab/Toggle4"
local toogle5_path = "ImgBg/Tab/Toggle5"
local toogle6_path = "ImgBg/Tab/Toggle6"
local build_obj_path = "ImgBg/GameObject/PlayerBuildingReport"
local resource_obj_path = "ImgBg/GameObject/PlayerResourceReport"
local close_btn_path = "ImgBg/BtnClose"
local return_btn_path = "Panel"

local function OnCreate(self)
  base.OnCreate(self)
  self.ctrl:InitBuildList()
  self.txt_title = self:AddComponent(UIText, txt_title_path)
  self.txt_title:SetLocalText(100021)
  self.build_obj = self:AddComponent(PlayerBuildingReport, build_obj_path)
  self.resource_obj = self:AddComponent(PlayerResourceReport, resource_obj_path)
  self.toogle1 = self:AddComponent(UIToggle, toogle1_path)
  self.toogle1:SetIsOn(true)
  self.toogle1:SetOnValueChanged(function(tf)
    if tf then
      self:ToggleControlBorS()
    end
  end)
  self.toogle1.text = self.toogle1:AddComponent(UIText, "Text")
  self.toogle1.text:SetLocalText(110015)
  self.toogle2 = self:AddComponent(UIToggle, toogle2_path)
  self.toogle2:SetIsOn(false)
  self.toogle2:SetOnValueChanged(function(tf)
    if tf then
      self:ToggleControlBorS()
    end
  end)
  self.toogle2.text = self.toogle2:AddComponent(UIText, "Text")
  self.toogle2.text:SetLocalText(100022)
  self.toogle3 = self:AddComponent(UIToggle, toogle3_path)
  self.toogle3:SetIsOn(false)
  self.toogle3:SetOnValueChanged(function(tf)
    if tf then
      self:ToggleControlBorS()
    end
  end)
  self.toogle3.text = self.toogle3:AddComponent(UIText, "Text")
  self.toogle3.text:SetLocalText(100024)
  self.toogle4 = self:AddComponent(UIToggle, toogle4_path)
  self.toogle4:SetIsOn(false)
  self.toogle4:SetOnValueChanged(function(tf)
    if tf then
      self:ToggleControlBorS()
    end
  end)
  self.toogle4.text = self.toogle4:AddComponent(UIText, "Text")
  self.toogle4.text:SetLocalText(100025)
  self.toogle5 = self:AddComponent(UIToggle, toogle5_path)
  self.toogle5:SetIsOn(false)
  self.toogle5:SetOnValueChanged(function(tf)
    if tf then
      self:ToggleControlBorS()
    end
  end)
  self.toogle5.text = self.toogle5:AddComponent(UIText, "Text")
  self.toogle5.text:SetLocalText(100026)
  self.toogle6 = self:AddComponent(UIToggle, toogle6_path)
  self.toogle6:SetIsOn(false)
  self.toogle6:SetOnValueChanged(function(tf)
    if tf then
      self:ToggleControlBorS()
    end
  end)
  self.toogle6.text = self.toogle6:AddComponent(UIText, "Text")
  self.toogle6.text:SetLocalText(100027)
  self.close_btn = self:AddComponent(UIButton, close_btn_path)
  self.close_btn:SetOnClick(function()
    DataCenter.LWSoundManager:PlayEffect(SoundAssetId.SFX_UI_General_Click_1st)
    self.ctrl:Close()
  end)
  self.return_btn = self:AddComponent(UIButton, return_btn_path)
  self.return_btn:SetOnClick(function()
    self.ctrl:CloseSelf()
  end)
end

local function OnDestroy(self)
  self.txt_title = nil
  self.toogle1.text = nil
  self.toogle1 = nil
  self.toogle2.text = nil
  self.toogle2 = nil
  self.toogle3.text = nil
  self.toogle3 = nil
  self.toogle4.text = nil
  self.toogle4 = nil
  self.toogle5.text = nil
  self.toogle5 = nil
  self.toogle6.text = nil
  self.toogle6 = nil
  self.build_obj = nil
  self.resource_obj = nil
  self.close_btn = nil
  self.return_btn = nil
  base.OnDestroy(self)
end

local function ToggleControlBorS(self)
  self.build_obj:SetActive(self.toogle1:GetIsOn())
  self.resource_obj:SetActive(self.toogle3:GetIsOn())
end

local function OnEnable(self)
  base.OnEnable(self)
  self.ToggleControlBorS(self)
end

local function OnDisable(self)
  base.OnDisable(self)
end

UIMainPlayerReportTableView.OnCreate = OnCreate
UIMainPlayerReportTableView.OnDestroy = OnDestroy
UIMainPlayerReportTableView.ToggleControlBorS = ToggleControlBorS
UIMainPlayerReportTableView.OnEnable = OnEnable
UIMainPlayerReportTableView.OnDisable = OnDisable
return UIMainPlayerReportTableView
