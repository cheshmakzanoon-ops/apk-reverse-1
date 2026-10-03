local base = UIBaseContainer
local SeasonCampDestroyBattleTimeSlot = BaseClass("SeasonCampDestroyBattleTimeSlot", UIBaseContainer)
local p_go_rotation_path = "p_go_rotation"
local p_img_out_war_time_path = "p_go_rotation/p_img_out_war_time"
local p_trans_out_war_time_vfx_root_path = "p_go_rotation/p_trans_out_war_time_vfx_root"
local p_img_out_war_time_icon_path = "p_img_out_war_time_icon"

function SeasonCampDestroyBattleTimeSlot:ComponentDefine()
  self.p_go_rotation = self:AddComponent(UIBaseContainer, p_go_rotation_path)
  self.p_img_out_war_time = self:AddComponent(UIImage, p_img_out_war_time_path)
  self.p_trans_out_war_time_vfx_root = self:AddComponent(UIBaseContainer, p_trans_out_war_time_vfx_root_path)
  self.p_img_out_war_time_icon = self:AddComponent(UIImage, p_img_out_war_time_icon_path)
end

function SeasonCampDestroyBattleTimeSlot:ComponentDestroy()
  self.p_go_rotation = nil
  self.p_img_out_war_time = nil
  self.p_trans_out_war_time_vfx_root = nil
  self.p_img_out_war_time_icon = nil
end

function SeasonCampDestroyBattleTimeSlot:DataDefine()
  DataCenter.SeasonCampDestroyManager:GetWarTimeConfigs()
end

function SeasonCampDestroyBattleTimeSlot:DataDestroy()
end

function SeasonCampDestroyBattleTimeSlot:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function SeasonCampDestroyBattleTimeSlot:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function SeasonCampDestroyBattleTimeSlot:OnAddListener()
  base.OnAddListener(self)
end

function SeasonCampDestroyBattleTimeSlot:OnRemoveListener()
  base.OnRemoveListener(self)
end

function SeasonCampDestroyBattleTimeSlot:ReInit(data)
  if self:InitData(data) then
    self:InitUi()
  end
end

function SeasonCampDestroyBattleTimeSlot:InitData(data)
  if data ~= nil then
    self.Data = data
    self.Angle = self.Data.WarTimeConfigData.StartTime / OneDayTime * 360 + 180
    local myTimeData = DataCenter.SeasonCampDestroyManager:GetMyAllianceWarTimeData()
    self.MyTimeIndex = myTimeData ~= nil and myTimeData.TimeIndex or 0
    return true
  end
  return false
end

function SeasonCampDestroyBattleTimeSlot:InitUi()
  self.p_go_rotation:SetEulerAnglesXYZ(0, 0, -self.Angle)
  self.p_img_out_war_time:LoadSpriteAsync(self:GetImg())
  self.p_img_out_war_time_icon:LoadSpriteAsync(self:GetImgIcon())
end

function SeasonCampDestroyBattleTimeSlot:GetImg()
  if self.MyTimeIndex == self.Data.WarTimeConfigData.Index then
    return "Assets/Main/SeasonRes/S5/Sprites/DeclareCityS5/mjc_S5_ZQXZ_shijian_02_2lv.png"
  else
    return "Assets/Main/SeasonRes/S5/Sprites/DeclareCityS5/mjc_S5_ZQXZ_shijian_02_2hong.png"
  end
end

function SeasonCampDestroyBattleTimeSlot:GetImgIcon()
  if self.MyTimeIndex == self.Data.WarTimeConfigData.Index then
    return "Assets/Main/SeasonRes/S5/Sprites/DeclareCityS5/mjc_S5_ZQXZ_icon_mianzhan.png"
  else
    return "Assets/Main/SeasonRes/S5/Sprites/DeclareCityS5/mjc_S5_ZQXZ_icon_kaizhan.png"
  end
end

return SeasonCampDestroyBattleTimeSlot
