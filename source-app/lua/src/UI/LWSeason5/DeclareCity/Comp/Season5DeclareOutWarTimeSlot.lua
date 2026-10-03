local base = UIBaseContainer
local Season5DeclareOutWarTimeSlot = BaseClass("Season5DeclareOutWarTimeSlot", UIBaseContainer)
local p_go_rotation_path = "p_go_rotation"
local p_img_out_war_time_path = "p_go_rotation/p_img_out_war_time"
local p_trans_out_war_time_vfx_root_path = "p_go_rotation/p_trans_out_war_time_vfx_root"
local p_img_out_war_time_icon_path = "p_img_out_war_time_icon"
local vfx_prefab_path = "Assets/_Art_LastWar/ArtAssetIncrement/Seasons/S5/Effect/Prefab/Eff_ui_S5_AllianceWar_fight.prefab"

function Season5DeclareOutWarTimeSlot:ComponentDefine()
  self.p_go_rotation = self:AddComponent(UIBaseContainer, p_go_rotation_path)
  self.p_img_out_war_time = self:AddComponent(UIImage, p_img_out_war_time_path)
  self.p_trans_out_war_time_vfx_root = self:AddComponent(UIBaseContainer, p_trans_out_war_time_vfx_root_path)
  self.p_img_out_war_time_icon = self:AddComponent(UIImage, p_img_out_war_time_icon_path)
end

function Season5DeclareOutWarTimeSlot:ComponentDestroy()
  self.p_go_rotation = nil
  self.p_img_out_war_time = nil
  self.p_trans_out_war_time_vfx_root = nil
  self.p_img_out_war_time_icon = nil
end

function Season5DeclareOutWarTimeSlot:DataDefine()
  DataCenter.UILWSeasonAllianceWarTimeManager:GetWarTimeConfigs()
end

function Season5DeclareOutWarTimeSlot:DataDestroy()
end

function Season5DeclareOutWarTimeSlot:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function Season5DeclareOutWarTimeSlot:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function Season5DeclareOutWarTimeSlot:OnAddListener()
  base.OnAddListener(self)
end

function Season5DeclareOutWarTimeSlot:OnRemoveListener()
  base.OnRemoveListener(self)
end

function Season5DeclareOutWarTimeSlot:ReInit(data)
  if self:InitData(data) then
    self:InitUi()
  end
end

function Season5DeclareOutWarTimeSlot:InitData(data)
  if data ~= nil then
    self.Data = data
    self.Angle = 180 - self.Data.WarTimeConfigData.StartTime / OneDayTime * 360
    local myTimeIndex = DataCenter.UILWSeasonAllianceWarTimeManager:GetMyAllianceWarTimeData()
    self.MyTimeIndex = myTimeIndex ~= nil and myTimeIndex.TimeIndex or 0
    return true
  end
  return false
end

function Season5DeclareOutWarTimeSlot:InitUi()
  self.p_go_rotation:SetEulerAnglesXYZ(0, 0, self.Angle)
  self.p_img_out_war_time:LoadSpriteAsync(self:GetImg())
  self.p_img_out_war_time_icon:LoadSpriteAsync(self:GetImgIcon())
end

function Season5DeclareOutWarTimeSlot:GetImg()
  if self.MyTimeIndex == self.Data.WarTimeConfigData.Index then
    return "Assets/Main/SeasonRes/S5/Sprites/DeclareCityS5/mjc_S5_ZQXZ_shijian_02_2lv.png"
  else
    return "Assets/Main/SeasonRes/S5/Sprites/DeclareCityS5/mjc_S5_ZQXZ_shijian_02_2hong.png"
  end
end

function Season5DeclareOutWarTimeSlot:GetImgIcon()
  if self.MyTimeIndex == self.Data.WarTimeConfigData.Index then
    return "Assets/Main/SeasonRes/S5/Sprites/DeclareCityS5/mjc_S5_ZQXZ_icon_mianzhan.png"
  else
    return "Assets/Main/SeasonRes/S5/Sprites/DeclareCityS5/mjc_S5_ZQXZ_icon_kaizhan.png"
  end
end

return Season5DeclareOutWarTimeSlot
