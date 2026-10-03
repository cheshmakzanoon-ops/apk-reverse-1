local LightHouseActive = BaseClass("LightHouseActive", UIAsyncContainer)
local base = UIAsyncContainer
local UIGray = CS.UIGray
local Localization = CS.GameEntry.Localization
local icon_build_txt_path = "icon_build/icon_build_txt"
local icon_worker_path = "bg/icon_worker"
local icon_worker_txt_path = "bg/icon_worker_txt"
local active_btn_path = "activeBtn"
local btn_active_des_path = "activeBtn/BtnActiveDes"

function LightHouseActive:OnCreate()
  base.OnCreate(self)
  self.icon_build_txt = self:AddComponent(UITextMeshProUGUIEx, icon_build_txt_path)
  self.icon_worker = self:AddComponent(UIImage, icon_worker_path)
  self.icon_worker_txt = self:AddComponent(UITextMeshProUGUIEx, icon_worker_txt_path)
  self.active_btn = self:AddComponent(UIButton, active_btn_path)
  self.btn_active_des = self:AddComponent(UITextMeshProUGUIEx, btn_active_des_path)
  self.active_btn:SetOnClick(function()
    SFSNetwork.SendMessage(MsgDefines.ActiveLightHouseS4)
  end)
  local factoryCount = DataCenter.SeasonPowerWorkerManager:GetPowerWorkerCount()
  self.icon_worker_txt:SetText("\195\151" .. factoryCount)
  self.icon_build_txt:SetLocalText("season_s4_building_ui_info09")
  self.btn_active_des:SetLocalText("season_s4_building_ui_info10")
end

function LightHouseActive:OnDestroy()
  self.icon_build_txt = nil
  self.icon_worker = nil
  self.icon_worker_txt = nil
  self.active_btn = nil
  self.btn_active_des = nil
  base.OnDestroy(self)
end

return LightHouseActive
