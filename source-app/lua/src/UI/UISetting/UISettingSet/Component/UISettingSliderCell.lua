local UISettingSliderCell = BaseClass("UISettingSliderCell", UIBaseContainer)
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization
local Setting = CS.GameEntry.Setting
local worldScene = CS.SceneManager.World
local GameQualitySettings = require("Util.GameQualitySettings")
local Param = DataClass("Param", ParamData)
local ParamData = {
  setType
}
local push_img_path = "PushImg"
local push_name_path = "PushName"
local push_des_path = "PushDes"
local push_des_path2 = "PushDes2"
local slider_path = "Slider"
local btn_path = "SwitchBtn"

local function OnCreate(self)
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

local function OnDestroy(self)
  self:ComponentDestroy()
  self:DataDestroy()
  base.OnDestroy(self)
end

local function OnEnable(self)
  base.OnEnable(self)
end

local function OnDisable(self)
  base.OnDisable(self)
end

local function ComponentDefine(self)
  self.push_img = self:AddComponent(UIImage, push_img_path)
  self.push_name = self:AddComponent(UIText, push_name_path)
  self.push_des = self:AddComponent(UIText, push_des_path)
  self.push_des2 = self:AddComponent(UIText, push_des_path2)
  if Config.IsPC() then
    self.push_des2:SetActive(true)
    self.push_des2:SetText("")
  else
    self.push_des2:SetActive(false)
  end
  self.slider = self:AddComponent(UISlider, slider_path)
  self.btn = self:AddComponent(UIButton, btn_path)
  self.btn:SetOnClick(function()
    DataCenter.LWSoundManager:PlayEffect(SoundAssetId.SFX_UI_General_Click_1st)
    self:OnBtnClick()
  end)
  self.slider2 = self:AddComponent(UISlider, "Slider2")
  self.slider2:SetOnValueChanged(function(value)
    self:OnSliderValueChanged(value)
  end)
  self.status_image = self:AddComponent(UIImage, "ImageStatus")
  self.unity_LayoutElement = self.gameObject:GetComponent(typeof(CS.UnityEngine.UI.LayoutElement))
  self.unity_LayoutElement.preferredHeight = 96
end

local function ComponentDestroy(self)
  self.push_img = nil
  self.push_name = nil
  self.push_des = nil
  self.slider = nil
  self.btn = nil
  self.slider2 = nil
  self.status_image = nil
  self.unity_LayoutElement = nil
  self.push_des2 = nil
end

local function DataDefine(self)
  self.param = {}
  self.isOn = nil
end

local function DataDestroy(self)
  self.param = nil
  self.isOn = nil
end

local function ReInit(self, param)
  self.param = param
  self:SetName()
  self:SetIsOn()
  self:SetIcon()
  self:SetSlider()
end

local function OnBtnClick(self)
  self.isOn = not self.isOn
  self:SetIsOn()
  if self.param.setType == SettingSetType.Effect then
    if self.isOn then
      Setting:SetBool(SettingKeys.EFFECT_MUSIC_ON, true)
      DataCenter.LWSoundManager:SetEffectMute(false)
      if Config.IsPC() then
        self.push_des:SetText("")
      else
        self.push_des:SetLocalText(280022)
      end
      UIUtil.ShowTipsId(280022)
    else
      Setting:SetBool(SettingKeys.EFFECT_MUSIC_ON, false)
      DataCenter.LWSoundManager:SetEffectMute(true)
      if Config.IsPC() then
        self.push_des:SetText("")
      else
        self.push_des:SetLocalText(280019)
      end
      UIUtil.ShowTipsId(280019)
    end
    DataCenter.LWSoundManager:SetSoundEffectOnOff(self.isOn)
  elseif self.param.setType == SettingSetType.Sound then
    if self.isOn then
      Setting:SetBool(SettingKeys.BG_MUSIC_ON, true)
      DataCenter.LWSoundManager:SetMusicMute(false)
      if Config.IsPC() then
        self.push_des:SetText("")
      else
        self.push_des:SetLocalText(280021)
      end
      UIUtil.ShowTipsId(280021)
    else
      Setting:SetBool(SettingKeys.BG_MUSIC_ON, false)
      DataCenter.LWSoundManager:SetMusicMute(true)
      if Config.IsPC() then
        self.push_des:SetText("")
      else
        self.push_des:SetLocalText(280018)
      end
      UIUtil.ShowTipsId(280018)
    end
  elseif self.param.setType == SettingSetType.envSound then
    if self.isOn then
      Setting:SetBool(SettingKeys.ENV_SOUND_ON, true)
      DataCenter.LWSoundManager:SetEnvSoundMute(false)
      if Config.IsPC() then
        self.push_des:SetText("")
      else
        self.push_des:SetLocalText("sound_setting_amb_on")
      end
      UIUtil.ShowTipsId("sound_setting_amb_on")
    else
      Setting:SetBool(SettingKeys.ENV_SOUND_ON, false)
      DataCenter.LWSoundManager:SetEnvSoundMute(true)
      if Config.IsPC() then
        self.push_des:SetText("")
      else
        self.push_des:SetLocalText("sound_setting_amb_off")
      end
      UIUtil.ShowTipsId("sound_setting_amb_off")
    end
  elseif self.param.setType == SettingSetType.Diamond then
    if self.isOn then
      SFSNetwork.SendMessage(MsgDefines.UserSetting, UserSettingKey.DIAMOND_USAGE_REMINDER, "1")
      self.push_des:SetLocalText(129077)
      UIUtil.ShowTipsId(129077)
    else
      SFSNetwork.SendMessage(MsgDefines.UserSetting, UserSettingKey.DIAMOND_USAGE_REMINDER, "0")
      self.push_des:SetLocalText(129078)
      UIUtil.ShowTipsId(129078)
    end
  elseif self.param.setType == SettingSetType.Task then
    if self.isOn then
      Setting:SetBool(SettingKeys.TASK_TIPS_ON, true)
      UIUtil.ShowTipsId(280023)
    else
      Setting:SetBool(SettingKeys.TASK_TIPS_ON, false)
      UIUtil.ShowTipsId(280020)
    end
  elseif self.param.setType == SettingSetType.Question then
    if self.isOn then
      Setting:SetBool(SettingKeys.TOUCH_SP_FUN, true)
      UIUtil.ShowTipsId(120068)
    else
      Setting:SetBool(SettingKeys.TOUCH_SP_FUN, false)
      UIUtil.ShowTipsId(120067)
    end
  elseif self.param.setType == SettingSetType.Position then
    if self.isOn then
      Setting:SetBool(SettingKeys.COORDINATE_ON_SHOW, true)
      UIUtil.ShowTipsId(120068)
    else
      Setting:SetBool(SettingKeys.COORDINATE_ON_SHOW, false)
      UIUtil.ShowTipsId(120067)
    end
  elseif self.param.setType == SettingSetType.DebugChooseServer then
    if self.isOn then
      Setting:SetBool(SettingKeys.SHOW_DEBUG_CHOOSE_SERVER, true)
      UIUtil.ShowTipsId(120068)
    else
      Setting:SetBool(SettingKeys.SHOW_DEBUG_CHOOSE_SERVER, false)
      UIUtil.ShowTipsId(120067)
    end
  elseif self.param.setType == SettingSetType.SceneParticles then
    if self.isOn then
      Setting:SetBool(SettingKeys.SCENE_PARTICLES, true)
      UIUtil.ShowTipsId(120068)
    else
      Setting:SetBool(SettingKeys.SCENE_PARTICLES, false)
      UIUtil.ShowTipsId(120067)
    end
  elseif self.param.setType == SettingSetType.Surface then
    if self.isOn then
      Setting:SetBool(SettingKeys.SCENE_SURFACE, true)
      UIUtil.ShowTipsId(120068)
    else
      Setting:SetBool(SettingKeys.SCENE_SURFACE, false)
      UIUtil.ShowTipsId(120067)
    end
    if worldScene then
      worldScene:ProfileToggleTerrain()
    end
  elseif self.param.setType == SettingSetType.Build then
    if self.isOn then
      Setting:SetBool(SettingKeys.SCENE_BUILD, true)
      UIUtil.ShowTipsId(120068)
    else
      Setting:SetBool(SettingKeys.SCENE_BUILD, false)
      UIUtil.ShowTipsId(120067)
    end
    if worldScene then
      worldScene:ProfileToggleBuilding()
    end
  elseif self.param.setType == SettingSetType.Decorations then
    if self.isOn then
      Setting:SetBool(SettingKeys.SCENE_DECORATIONS, true)
      UIUtil.ShowTipsId(120068)
    else
      Setting:SetBool(SettingKeys.SCENE_DECORATIONS, false)
      UIUtil.ShowTipsId(120067)
    end
    if worldScene then
      worldScene:ProfileToggleStatic()
    end
  elseif self.param.setType == SettingSetType.Monster then
    if self.isOn then
      Setting:SetBool(SettingKeys.SCENE_MONSTER, true)
      UIUtil.ShowTipsId(120068)
    else
      Setting:SetBool(SettingKeys.SCENE_MONSTER, false)
      UIUtil.ShowTipsId(120067)
    end
    if worldScene then
      worldScene:ProfileToggleMarch()
    end
    if self.isOn then
      UIManager:GetInstance():DestroyWindowByLayer(UILayer.Normal)
    end
  elseif self.param.setType == SettingSetType.ShowFarm then
    if self.isOn then
      Setting:SetPrivateBool("SHOW_FARM", true)
      UIUtil.ShowTipsId(120068)
    else
      Setting:SetPrivateBool("SHOW_FARM", false)
      UIUtil.ShowTipsId(120067)
    end
    EventManager:GetInstance():Broadcast(EventId.ChangeShowFarmState)
  elseif self.param.setType == SettingSetType.ShowAnimal then
    if self.isOn then
      Setting:SetPrivateBool("SHOW_ANIMAL", true)
      UIUtil.ShowTipsId(120068)
    else
      Setting:SetPrivateBool("SHOW_ANIMAL", false)
      UIUtil.ShowTipsId(120067)
    end
    EventManager:GetInstance():Broadcast(EventId.ChangeShowAnimalState)
  elseif self.param.setType == SettingSetType.SendNotice then
  elseif self.param.setType == SettingSetType.SkyBox then
    if self.isOn then
      UIUtil.ShowTipsId(120068)
    else
      UIUtil.ShowTipsId(120067)
    end
    if worldScene then
      worldScene:ProfileToggleHeightFog()
    end
  elseif self.param.setType == SettingSetType.Vibrate then
    if self.isOn then
      self.push_des:SetLocalText(208221)
      UIUtil.ShowTipsId(120068)
      Setting:SetBool(SettingKeys.VIBRATE, true)
      CS.MoreMountains.NiceVibrations.MMVibrationManager.SetHapticsActive(true)
    else
      self.push_des:SetLocalText(208220)
      UIUtil.ShowTipsId(120067)
      Setting:SetBool(SettingKeys.VIBRATE, false)
      CS.MoreMountains.NiceVibrations.MMVibrationManager.SetHapticsActive(false)
    end
    PostEventLog.Track(PostEventLog.Defines.UserSetting, {
      event_type = self.param.setType,
      result = self.isOn
    })
  elseif self.param.setType == SettingSetType.PowerSaving then
    if self.isOn then
      GameQualitySettings.EnablePowerSavingMode(true)
      self.push_des:SetLocalText(800834)
      UIUtil.ShowTipsId(800834)
    else
      GameQualitySettings.EnablePowerSavingMode(false)
      self.push_des:SetLocalText(800835)
      UIUtil.ShowTipsId(800835)
    end
  elseif self.param.setType == SettingSetType.ShowVipLevel then
    SFSNetwork.SendMessage(MsgDefines.LWSaveShowVipLevelSettings, self.isOn and 0 or 1)
    local selfChatUserInfo = ChatInterface.getUserData(LuaEntry.Player.uid)
    if selfChatUserInfo then
      local number = self.isOn and 0 or 1
      selfChatUserInfo.showVipLevel = number
      if ChatInterface.GetisTestUid(LuaEntry.Player.uid) then
        Logger.LogError("vipShow Change  ---->  isVipShow:  " .. number)
      end
    end
    UIUtil.ShowTipsId(self.isOn and 120068 or 120067)
    self.push_des:SetLocalText(self.isOn and 120068 or 120067)
    EventManager:GetInstance():Broadcast(EventId.ChatUserInfoUpdate, LuaEntry.Player.uid)
  elseif self.param.setType == SettingSetType.PvpAlert then
    if self.isOn then
      self.push_des:SetLocalText("system_settings_02")
      UIUtil.ShowTipsId("system_settings_02")
      Setting:SetBool(SettingKeys.PVPALERT, true)
    else
      self.push_des:SetLocalText("system_settings_03")
      UIUtil.ShowTipsId("system_settings_03")
      Setting:SetBool(SettingKeys.PVPALERT, false)
    end
  elseif self.param.setType == SettingSetType.BuildFinishRemind then
    if self.isOn then
      self.push_des:SetLocalText("building_completion_switch_on")
      UIUtil.ShowTipsId("building_completion_switch_on")
      SFSNetwork.SendMessage(MsgDefines.UserSetting, UserSettingKey.FINISH_BUILDING_RECEIVE_REMINDER, "1")
    else
      self.push_des:SetLocalText("building_completion_switch_off")
      UIUtil.ShowTipsId("building_completion_switch_off")
      SFSNetwork.SendMessage(MsgDefines.UserSetting, UserSettingKey.FINISH_BUILDING_RECEIVE_REMINDER, "0")
    end
  elseif self.param.setType == SettingSetType.GetPersonDuelScoreTip then
    if self.isOn then
      self.push_des:SetLocalText("setting_getDuelScore_armrace_on")
      UIUtil.ShowTipsId("setting_getDuelScore_armrace_on")
      Setting:SetBool(SettingKeys.GETDUELSCORE_PERSON, true)
    else
      self.push_des:SetLocalText("setting_getDuelScore_armrace_off")
      UIUtil.ShowTipsId("setting_getDuelScore_armrace_off")
      Setting:SetBool(SettingKeys.GETDUELSCORE_PERSON, false)
    end
  elseif self.param.setType == SettingSetType.RecruitCardRewardGet then
    if self.isOn then
      self.push_des:SetLocalText("draw_num_tips_control_3")
      UIUtil.ShowTipsId("draw_num_tips_control_3")
      Setting:SetBool(SettingKeys.RECRUIT_CARD_REWARD_GET, true)
    else
      self.push_des:SetLocalText("draw_num_tips_control_4")
      UIUtil.ShowTipsId("draw_num_tips_control_4")
      Setting:SetBool(SettingKeys.RECRUIT_CARD_REWARD_GET, false)
    end
  elseif self.param.setType == SettingSetType.GetAllyDuelScoreTip then
    if self.isOn then
      self.push_des:SetLocalText("setting_getDuelScore_duel_on")
      UIUtil.ShowTipsId("setting_getDuelScore_duel_on")
      Setting:SetBool(SettingKeys.GETDUELSCORE_ALLY, true)
    else
      self.push_des:SetLocalText("setting_getDuelScore_duel_off")
      UIUtil.ShowTipsId("setting_getDuelScore_duel_off")
      Setting:SetBool(SettingKeys.GETDUELSCORE_ALLY, false)
    end
  elseif self.param.setType == SettingSetType.ShakeCollectRes then
    if self.isOn then
      self.push_des:SetLocalText("setting_shakeCollect_on")
      UIUtil.ShowTipsId("setting_shakeCollect_on")
      Setting:SetBool(SettingKeys.SHAKE_COLLECT_RES, true)
    else
      self.push_des:SetLocalText("setting_shakeCollect_off")
      UIUtil.ShowTipsId("setting_shakeCollect_off")
      Setting:SetBool(SettingKeys.SHAKE_COLLECT_RES, false)
    end
    EventManager:GetInstance():Broadcast(EventId.RefreshShakeCollectResSetting, self.isOn)
    self.holder:RefreshCells()
    EventManager:GetInstance():Broadcast(EventId.RefreshOneKeyCollectResSetting)
  elseif self.param.setType == SettingSetType.OneKeyCollectRes then
    if self.isOn then
      self.push_des:SetLocalText("setting_shakeCollect_click_on")
      UIUtil.ShowTipsId("setting_shakeCollect_click_on")
      Setting:SetBool(SettingKeys.ONE_KEY_COLLECT_RES, true)
    else
      self.push_des:SetLocalText("setting_shakeCollect_click_off")
      UIUtil.ShowTipsId("setting_shakeCollect_click_off")
      Setting:SetBool(SettingKeys.ONE_KEY_COLLECT_RES, false)
    end
    EventManager:GetInstance():Broadcast(EventId.RefreshOneKeyCollectResSetting)
  elseif self.param.setType == SettingSetType.FullScreen then
    if Config.IsPC() then
      if self.isOn then
        CS.WindowFullScreen.SetFullScreen()
        Setting:SetBool(SettingKeys.FULL_SCREEN_ON, true)
      else
        CS.WindowFullScreen.ResetFullScreen()
        Setting:SetBool(SettingKeys.FULL_SCREEN_ON, false)
      end
    end
  elseif self.param.setType == SettingSetType.ShakeCollectTruckRes then
    if self.isOn then
      self.push_des:SetLocalText("shake_collec_armed_on")
      UIUtil.ShowTipsId("shake_collec_armed_on")
      Setting:SetBool(SettingKeys.SHAKE_COLLECT_TRUCK_RES, true)
    else
      self.push_des:SetLocalText("shake_collec_armed_off")
      UIUtil.ShowTipsId("shake_collec_armed_off")
      Setting:SetBool(SettingKeys.SHAKE_COLLECT_TRUCK_RES, false)
    end
    EventManager:GetInstance():Broadcast(EventId.RefreshShakeCollectTruckResSetting, self.isOn)
  elseif self.param.setType == SettingSetType.UseSeasonBGM then
    if self.isOn then
      Setting:SetBool(SettingKeys.USE_SEASON_BGM, true)
      CommonUtil.PlayGameBgMusic()
      self.push_des:SetLocalText("setting_season_bgm_desc01")
      UIUtil.ShowTipsId(120068)
    else
      Setting:SetBool(SettingKeys.USE_SEASON_BGM, false)
      CommonUtil.PlayGameBgMusic()
      self.push_des:SetLocalText("setting_season_bgm_desc02")
      UIUtil.ShowTipsId(120067)
    end
  elseif self.param.setType == SettingSetType.BackGesture then
    if self.isOn then
      self.push_des:SetLocalText("setting_BackGesture_on")
      UIUtil.ShowTipsId("setting_BackGesture_on")
      DataCenter.BackGestureManager:SetSwitch(true)
    else
      self.push_des:SetLocalText("setting_BackGesture_off")
      UIUtil.ShowTipsId("setting_BackGesture_off")
      DataCenter.BackGestureManager:SetSwitch(false)
    end
    DataCenter.BackGestureManager:ChangeSwitchState(self.isOn)
  elseif self.param.setType == SettingSetType.PowerUpBannerDetail then
    if self.isOn then
      Setting:SetBool(SettingKeys.POWER_UP_BANNER_DETAIL, true)
      self.push_des:SetLocalText("power_pop_up_switch_on_desc")
      UIUtil.ShowTipsId("power_pop_up_switch_on_desc")
    else
      Setting:SetBool(SettingKeys.POWER_UP_BANNER_DETAIL, false)
      self.push_des:SetLocalText("power_pop_up_switch_off_desc")
      UIUtil.ShowTipsId("power_pop_up_switch_off_desc")
    end
  elseif self.param.setType == SettingSetType.ShowOfficialEffect then
    if self.isOn then
      self.push_des:SetLocalText("world_officer_switch_desc_on")
      UIUtil.ShowTipsId("world_officer_switch_desc_on")
      SFSNetwork.SendMessage(MsgDefines.UserSetting, UserSettingKey.SHOW_OFFICIAL_EFFECT, "1")
    else
      self.push_des:SetLocalText("world_officer_switch_desc_off")
      UIUtil.ShowTipsId("world_officer_switch_desc_off")
      SFSNetwork.SendMessage(MsgDefines.UserSetting, UserSettingKey.SHOW_OFFICIAL_EFFECT, "0")
    end
  end
end

local function SetName(self)
  if self.param.setType == SettingSetType.Effect then
    self.push_name:SetLocalText(280035)
    self.isOn = Setting:GetBool(SettingKeys.EFFECT_MUSIC_ON, true)
    if Config.IsPC() then
      self.push_des:SetText("")
    elseif self.isOn then
      self.push_des:SetLocalText(280022)
    else
      self.push_des:SetLocalText(280019)
    end
  elseif self.param.setType == SettingSetType.Sound then
    self.push_name:SetLocalText(110111)
    self.isOn = Setting:GetBool(SettingKeys.BG_MUSIC_ON, true)
    if Config.IsPC() then
      self.push_des:SetText("")
    elseif self.isOn then
      self.push_des:SetLocalText(280021)
    else
      self.push_des:SetLocalText(280018)
    end
  elseif self.param.setType == SettingSetType.Diamond then
    self.push_name:SetLocalText(129075)
    self.isOn = LuaEntry.Player:GetUserSetting(UserSettingKey.DIAMOND_USAGE_REMINDER) == "1"
    if self.isOn then
      self.push_des:SetLocalText(129077)
    else
      self.push_des:SetLocalText(129078)
    end
  elseif self.param.setType == SettingSetType.Task then
    self.push_name:SetLocalText(280017)
    self.push_des:SetLocalText(280016)
    self.isOn = Setting:GetBool(SettingKeys.TASK_TIPS_ON, true)
  elseif self.param.setType == SettingSetType.Question then
    self.push_name:SetLocalText(390524)
    self.push_des:SetLocalText(390525)
    self.isOn = Setting:GetBool(SettingKeys.TOUCH_SP_FUN, true)
  elseif self.param.setType == SettingSetType.Position then
    self.push_name:SetLocalText(390058)
    self.push_des:SetLocalText(110091)
    self.isOn = Setting:GetBool(SettingKeys.COORDINATE_ON_SHOW, true)
  elseif self.param.setType == SettingSetType.DebugChooseServer then
    self.push_name:SetText(Localization:GetString("ES100013"))
    self.push_des:SetText(Localization:GetString("ES100013"))
    self.isOn = Setting:GetBool(SettingKeys.SHOW_DEBUG_CHOOSE_SERVER, true)
  elseif self.param.setType == SettingSetType.SceneParticles then
    self.push_name:SetLocalText(280009)
    self.push_des:SetLocalText(280007)
    self.isOn = Setting:GetBool(SettingKeys.SCENE_PARTICLES, true)
  elseif self.param.setType == SettingSetType.Surface then
    self.push_name:SetLocalText(100256)
    self.push_des:SetLocalText(280007)
    if worldScene then
      self.isOn = worldScene:GetProfileTerrainSwitch()
    end
  elseif self.param.setType == SettingSetType.Build then
    self.push_name:SetLocalText(100441)
    self.push_des:SetLocalText(280007)
    if worldScene then
      self.isOn = worldScene:GetProfileBuildingSwitch()
    end
  elseif self.param.setType == SettingSetType.Decorations then
    self.push_name:SetLocalText(100440)
    self.push_des:SetLocalText(280007)
    if worldScene then
      self.isOn = worldScene:GetProfileStaticSwitch()
    end
  elseif self.param.setType == SettingSetType.Monster then
    self.push_name:SetLocalText(280005)
    self.push_des:SetLocalText(280007)
    if worldScene then
      self.isOn = worldScene:GetGraphySwitch()
    end
  elseif self.param.setType == SettingSetType.ShowAnimal then
    self.push_name:SetText("show animal")
    self.push_des:SetText("")
    self.isOn = Setting:GetPrivateBool("SHOW_ANIMAL", true)
  elseif self.param.setType == SettingSetType.SendNotice then
    self.push_name:SetText("SendNotice")
    self.push_des:SetText("")
    self.isOn = false
  elseif self.param.setType == SettingSetType.ShowFarm then
    self.push_name:SetText("show farm")
    self.push_des:SetText("")
    self.isOn = Setting:GetPrivateBool("SHOW_FARM", true)
  elseif self.param.setType == SettingSetType.SkyBox then
    self.push_name:SetLocalText(100104)
    self.push_des:SetLocalText(280007)
    if worldScene then
      self.isOn = worldScene:GetHeightFogSwitch()
    end
  elseif self.param.setType == SettingSetType.Vibrate then
    self.push_name:SetLocalText(208219)
    self.isOn = Setting:GetBool(SettingKeys.VIBRATE, true)
    if self.isOn then
      self.push_des:SetLocalText(208221)
    else
      self.push_des:SetLocalText(208220)
    end
  elseif self.param.setType == SettingSetType.PowerSaving then
    self.push_name:SetLocalText(800833)
    self.isOn = GameQualitySettings.IsPowerSavingMode()
    if self.isOn then
      self.push_des:SetLocalText(800834)
    else
      self.push_des:SetLocalText(800835)
    end
  elseif self.param.setType == SettingSetType.ShowVipLevel then
    self.push_name:SetLocalText(2900035)
    local selfChatUserInfo = ChatInterface.getUserData(LuaEntry.Player.uid)
    self.isOn = not selfChatUserInfo or not selfChatUserInfo.showVipLevel or selfChatUserInfo.showVipLevel <= 0
    self.push_des:SetLocalText(self.isOn and 120068 or 120067)
  elseif self.param.setType == SettingSetType.PvpAlert then
    self.push_name:SetLocalText("system_settings_01")
    self.isOn = Setting:GetBool(SettingKeys.PVPALERT, true)
    if self.isOn then
      self.push_des:SetLocalText("system_settings_02")
    else
      self.push_des:SetLocalText("system_settings_03")
    end
  elseif self.param.setType == SettingSetType.BuildFinishRemind then
    self.push_name:SetLocalText("building_completion_switch")
    self.isOn = LuaEntry.Player:GetUserSetting(UserSettingKey.FINISH_BUILDING_RECEIVE_REMINDER) == "1"
    if self.isOn then
      self.push_des:SetLocalText("building_completion_switch_on")
    else
      self.push_des:SetLocalText("building_completion_switch_off")
    end
  elseif self.param.setType == SettingSetType.GetPersonDuelScoreTip then
    self.push_name:SetLocalText("setting_getDuelScore_armrace_title")
    self.isOn = Setting:GetBool(SettingKeys.GETDUELSCORE_PERSON, true)
    if self.isOn then
      self.push_des:SetLocalText("setting_getDuelScore_armrace_on")
    else
      self.push_des:SetLocalText("setting_getDuelScore_armrace_off")
    end
  elseif self.param.setType == SettingSetType.RecruitCardRewardGet then
    self.push_name:SetLocalText("draw_num_tips_control_1")
    self.isOn = Setting:GetBool(SettingKeys.RECRUIT_CARD_REWARD_GET, true)
    if self.isOn then
      self.push_des:SetLocalText("draw_num_tips_control_3")
    else
      self.push_des:SetLocalText("draw_num_tips_control_4")
    end
    self.unity_LayoutElement.preferredHeight = 130
    local levelLimit = LuaEntry.DataConfig:TryGetNum("draw_num_show_control", "k1", 20)
    self.push_des2:SetLocalText("draw_num_tips_control_2", levelLimit)
    self.push_des2:SetActive(true)
  elseif self.param.setType == SettingSetType.GetAllyDuelScoreTip then
    self.push_name:SetLocalText("setting_getDuelScore_duel_title")
    self.isOn = Setting:GetBool(SettingKeys.GETDUELSCORE_ALLY, true)
    if self.isOn then
      self.push_des:SetLocalText("setting_getDuelScore_duel_on")
    else
      self.push_des:SetLocalText("setting_getDuelScore_duel_off")
    end
  elseif self.param.setType == SettingSetType.ShakeCollectRes then
    self.push_name:SetLocalText("setting_shakeCollect_title")
    self.isOn = Setting:GetBool(SettingKeys.SHAKE_COLLECT_RES, true)
    if self.isOn then
      self.push_des:SetLocalText("setting_shakeCollect_on")
    else
      self.push_des:SetLocalText("setting_shakeCollect_off")
    end
    if Config.IsPC() then
      self.unity_LayoutElement.preferredHeight = 141
      self.push_des2:SetLocalText("pc_shake_tips_01")
    end
  elseif self.param.setType == SettingSetType.OneKeyCollectRes then
    self.push_name:SetLocalText("setting_shakeCollect_click")
    self.isOn = Setting:GetBool(SettingKeys.ONE_KEY_COLLECT_RES, false)
    if self.isOn then
      self.push_des:SetLocalText("setting_shakeCollect_click_on")
    else
      self.push_des:SetLocalText("setting_shakeCollect_click_off")
    end
  elseif self.param.setType == SettingSetType.FullScreen then
    self.push_name:SetLocalText("pc_screen_setting_02")
    self.isOn = Setting:GetBool(SettingKeys.FULL_SCREEN_ON, false)
    self.push_des:SetText("")
  elseif self.param.setType == SettingSetType.ShakeCollectTruckRes then
    self.push_name:SetLocalText("shake_collec_armed_title")
    self.isOn = Setting:GetBool(SettingKeys.SHAKE_COLLECT_TRUCK_RES, false)
    if self.isOn then
      self.push_des:SetLocalText("shake_collec_armed_on")
    else
      self.push_des:SetLocalText("shake_collec_armed_off")
    end
  elseif self.param.setType == SettingSetType.UseSeasonBGM then
    self.push_name:SetLocalText("setting_season_bgm_onoff")
    self.isOn = Setting:GetBool(SettingKeys.USE_SEASON_BGM, true)
    if self.isOn then
      self.push_des:SetLocalText("setting_season_bgm_desc01")
    else
      self.push_des:SetLocalText("setting_season_bgm_desc02")
    end
  elseif self.param.setType == SettingSetType.BackGesture then
    self.push_name:SetLocalText("setting_BackGesture_title")
    self.isOn = DataCenter.BackGestureManager:GetSwitch()
    if self.isOn then
      self.push_des:SetLocalText("setting_BackGesture_on")
    else
      self.push_des:SetLocalText("setting_BackGesture_off")
    end
  elseif self.param.setType == SettingSetType.envSound then
    self.push_name:SetLocalText("sound_setting_amb_title")
    self.isOn = Setting:GetBool(SettingKeys.ENV_SOUND_ON, true)
    if Config.IsPC() then
      self.push_des:SetText("")
    elseif self.isOn then
      self.push_des:SetLocalText("sound_setting_amb_on")
    else
      self.push_des:SetLocalText("sound_setting_amb_off")
    end
  elseif self.param.setType == SettingSetType.PowerUpBannerDetail then
    self.push_name:SetLocalText("power_pop_up_switch_name")
    self.isOn = Setting:GetBool(SettingKeys.POWER_UP_BANNER_DETAIL, false)
    if self.isOn then
      self.push_des:SetLocalText("power_pop_up_switch_on_desc")
    else
      self.push_des:SetLocalText("power_pop_up_switch_off_desc")
    end
  elseif self.param.setType == SettingSetType.ShowOfficialEffect then
    self.push_name:SetLocalText("world_officer_switch")
    local settingValue = LuaEntry.Player:GetUserSetting(UserSettingKey.SHOW_OFFICIAL_EFFECT)
    self.isOn = settingValue == "1"
    if self.isOn then
      self.push_des:SetLocalText("world_officer_switch_desc_on")
    else
      self.push_des:SetLocalText("world_officer_switch_desc_off")
    end
  end
  if Config.IsPC() then
    self.slider:SetActive(self.param.setType ~= SettingSetType.Effect and self.param.setType ~= SettingSetType.Sound and self.param.setType ~= SettingSetType.envSound)
  end
end

local function SetIsOn(self)
  if self.isOn then
    self.slider:SetValue(1)
  else
    self.slider:SetValue(0)
  end
  if Config.IsPC() and (self.param.setType == SettingSetType.Effect or self.param.setType == SettingSetType.Sound or self.param.setType == SettingSetType.envSound) then
    self.status_image:SetActive(true)
    if self.isOn then
      self.status_image:LoadSprite("Assets/Main/Sprites/UI/UISet/New/wxy_shezhi_yixiao02")
    else
      self.status_image:LoadSprite("Assets/Main/Sprites/UI/UISet/New/wxy_shezhi_yixiao01")
    end
  else
    self.status_image:SetActive(false)
  end
end

local function SetIcon(self)
  local imgPath = ""
  if self.param.setType == SettingSetType.Effect then
    imgPath = "Assets/Main/Sprites/UI/UISet/New/zyf_shezhi_icon_1.png"
  elseif self.param.setType == SettingSetType.Sound then
    imgPath = "Assets/Main/Sprites/UI/UISet/New/zyf_shezhi_icon_2.png"
  elseif self.param.setType == SettingSetType.Vibrate then
    imgPath = "Assets/Main/Sprites/UI/UISet/New/zyf_shezhi_icon_3.png"
  elseif self.param.setType == SettingSetType.Diamond then
    imgPath = "Assets/Main/Sprites/UI/UISet/New/zyf_shezhi_icon_4.png"
  elseif self.param.setType == SettingSetType.ShowVipLevel then
    imgPath = "Assets/Main/Sprites/UI/UISet/New/zyf_shezhi_icon_7.png"
  elseif self.param.setType == SettingSetType.PowerSaving then
    imgPath = "Assets/Main/Sprites/UI/UISet/New/zyf_shezhi_icon_6.png"
  elseif self.param.setType == SettingSetType.PvpAlert then
    imgPath = "Assets/Main/Sprites/UI/UISet/New/zyf_shezhi_icon_8.png"
  elseif self.param.setType == SettingSetType.BuildFinishRemind then
    imgPath = "Assets/Main/Sprites/UI/UISet/New/zyf_shezhi_icon_9.png"
  elseif self.param.setType == SettingSetType.GetPersonDuelScoreTip then
    imgPath = "Assets/Main/Sprites/UI/UISet/New/zyf_shezhi_icon_10.png"
  elseif self.param.setType == SettingSetType.GetAllyDuelScoreTip then
    imgPath = "Assets/Main/Sprites/UI/UISet/New/zyf_shezhi_icon_11.png"
  elseif self.param.setType == SettingSetType.ShakeCollectRes or self.param.setType == SettingSetType.ShakeCollectTruckRes then
    imgPath = "Assets/Main/Sprites/UI/UISet/New/zyf_shezhi_icon_12.png"
  elseif self.param.setType == SettingSetType.FullScreen then
    imgPath = "Assets/Main/Sprites/UI/UISet/New/zyf_pc_quanpingmoshishezhi_icon.png"
  elseif self.param.setType == SettingSetType.RecruitCardRewardGet then
    imgPath = "Assets/Main/Sprites/UI/UISet/New/zyf_zhaomuquan_icon.png"
  elseif self.param.setType == SettingSetType.UseSeasonBGM then
    imgPath = "Assets/Main/Sprites/UI/UISet/New/zyf_shezhi_icon_2.png"
  elseif self.param.setType == SettingSetType.BackGesture then
    imgPath = "Assets/Main/Sprites/UI/UISet/New/zyf_shezhi_icon_13.png"
  elseif self.param.setType == SettingSetType.envSound then
    imgPath = "Assets/Main/Sprites/UI/UISet/New/zyf_shezhi_icon_huanjingyinliang.png"
  elseif self.param.setType == SettingSetType.PowerUpBannerDetail then
    imgPath = "Assets/Main/Sprites/UI/UISet/New/mjc_zlts_shezhi_zhanli_icon.png"
  elseif self.param.setType == SettingSetType.ShowOfficialEffect then
    imgPath = "Assets/Main/Sprites/UI/UISet/New/zyf_shezhi_icon_yincangguanzhi.png"
  end
  if string.IsNullOrEmpty(imgPath) then
    self.push_img:SetActive(false)
    return
  end
  self.push_img:SetActive(true)
  self.push_img:LoadSprite(imgPath)
  self.push_img:SetNativeSize()
end

local function SetSlider(self)
  if not Config.IsPC() then
    self.slider2:SetActive(false)
    return
  end
  if self.param.setType == SettingSetType.Effect then
    self.slider2:SetActive(true)
    local volumeNumEffect = Setting:GetFloat(SettingKeys.EFFECT_VOLUME, 1)
    self.slider2:SetValue(volumeNumEffect)
  elseif self.param.setType == SettingSetType.Sound then
    self.slider2:SetActive(true)
    local volumeNumMusic = Setting:GetFloat(SettingKeys.MUSIC_VOLUME, 1)
    self.slider2:SetValue(volumeNumMusic)
  elseif self.param.setType == SettingSetType.envSound then
    self.slider2:SetActive(true)
    local volumeNumEnvSound = Setting:GetFloat(SettingKeys.ENV_SOUND_VOLUME, 1)
    self.slider2:SetValue(volumeNumEnvSound)
  else
    self.slider2:SetActive(false)
  end
end

local function OnSliderValueChanged(self, val)
  if not Config.IsPC() then
    return
  end
  if self.param.setType == SettingSetType.Effect then
    Setting:SetFloat(SettingKeys.EFFECT_VOLUME, val)
    DataCenter.LWSoundManager:ChangeEffectVolumeRatio(val)
  elseif self.param.setType == SettingSetType.Sound then
    Setting:SetFloat(SettingKeys.MUSIC_VOLUME, val)
    DataCenter.LWSoundManager:ChangeMusicVolumeRatio(val)
  elseif self.param.setType == SettingSetType.envSound then
    Setting:SetFloat(SettingKeys.ENV_SOUND_VOLUME, val)
    DataCenter.LWSoundManager:ChangeEvnSoundVolumeRatio(val)
  end
end

UISettingSliderCell.OnCreate = OnCreate
UISettingSliderCell.OnDestroy = OnDestroy
UISettingSliderCell.Param = Param
UISettingSliderCell.OnEnable = OnEnable
UISettingSliderCell.OnDisable = OnDisable
UISettingSliderCell.ComponentDefine = ComponentDefine
UISettingSliderCell.ComponentDestroy = ComponentDestroy
UISettingSliderCell.DataDefine = DataDefine
UISettingSliderCell.DataDestroy = DataDestroy
UISettingSliderCell.ReInit = ReInit
UISettingSliderCell.OnBtnClick = OnBtnClick
UISettingSliderCell.SetName = SetName
UISettingSliderCell.SetIsOn = SetIsOn
UISettingSliderCell.SetIcon = SetIcon
UISettingSliderCell.SetSlider = SetSlider
UISettingSliderCell.OnSliderValueChanged = OnSliderValueChanged
return UISettingSliderCell
