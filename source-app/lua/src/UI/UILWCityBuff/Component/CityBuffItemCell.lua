local CityBuffItemCell = BaseClass("CityBuffItemCell", UIBaseContainer)
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization
local UnityRectTransform = typeof(CS.UnityEngine.RectTransform)
local item_icon_path = "UICommonResItem/clickBtn/ItemIcon"
local title_txt_path = "Text_title"
local des_txt_Path = "Text_des"
local slider_txt_Path = "Progress/TimeSliderText"
local slider_Path = "Progress/TimeSlider"
local sliderParent_Path = "Progress"
local common_bg_path = "Common_bg"
local info_btn_path = "InfoBtn"
local text_from_path = "Text_from"
local u_i_player_head_path = "UIPlayerHead"
local like_btn_path = "likeBtn"
local click_btn_path = "UICommonResItem/clickBtn"

function CityBuffItemCell:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
end

function CityBuffItemCell:OnDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function CityBuffItemCell:ComponentDefine()
  self.like_btn = self:AddComponent(UIButton, like_btn_path)
  self.ui_player_head = self:AddComponent(UICommonHead, u_i_player_head_path)
  self.info_btn = self:AddComponent(UIButton, info_btn_path)
  self.common_bg = self:AddComponent(UIImage, common_bg_path)
  self.item_icon = self:AddComponent(UIImage, item_icon_path)
  self.title_txt = self:AddComponent(UIText, title_txt_path)
  self.des_txt = self:AddComponent(UIText, des_txt_Path)
  self.text_from = self:AddComponent(UITextMeshProUGUIEx, text_from_path)
  self.sliderParent = self:AddComponent(UIBaseContainer, sliderParent_Path)
  self.slider_txt = self:AddComponent(UIText, slider_txt_Path)
  self.slider = self:AddComponent(UISlider, slider_Path)
  self.des_rectTransform = self.transform:Find(des_txt_Path):GetComponent(UnityRectTransform)
  self.click_btn = self:AddComponent(UIButton, click_btn_path)
  self.click_btn:SetOnClick(Bind(self, self.OnClickItemIcon))
  
  function self.timer_action()
    self:RefreshTime()
  end
  
  self.info_btn:SetOnClick(function()
    if self.specialGlobalStatus and self.specialGlobalStatus.reason == FetchGlobalStateReason.Season6CampDestroy then
      self:ShowSeasonCampDestroyZoneDetail()
    elseif self.camp_info_flag ~= nil then
      local campId = DataCenter.SeasonFactionWarDataManager.myCampId
      local buffList = DataCenter.CampScienceDataManager:GetSeasonCampBuffsByCampAndType(campId, self.camp_info_flag)
      local curBuff = DataCenter.CampScienceDataManager:GetCampScienceBuffByType(toInt(self.camp_info_flag))
      UIManager:GetInstance():OpenWindow(UIWindowNames.UICampEffectOverviewPreview, {anim = true}, buffList, curBuff)
    elseif self.attachmentDataList and self.effectId and self.effectValue then
      UIManager:GetInstance():OpenWindow(UIWindowNames.UILWCityBuffSource, {anim = false}, self.attachmentDataList)
    else
      DataCenter.LWSoundManager:PlayEffect(SoundAssetId.SFX_UI_General_Click_1st)
      self:OnDetailBtnClick()
    end
  end)
  self.like_btn:SetOnClick(function()
    if self.lightPlayerUid then
      DataCenter.LWSoundManager:PlayEffect(SoundAssetId.SFX_UI_General_Click_1st)
      InteractiveUtil.TryThumbsUp(self.lightPlayerUid, InteractiveUtil.ThumbsUpType.LightMe, "LightMe", function()
        UIUtil.ShowTipsId("champion_duel_tips1172")
      end)
    end
  end)
  self.info_btn:SetActive(false)
  self.like_btn:SetActive(false)
  self.slider:SetActive(true)
  self.virusLastEndTime = nil
  self.item_icon:SetSizeDeltaXY(100, 100)
  self:SetItemIconScale(1)
  self.ui_player_head:SetActive(false)
  self.ui_player_head:SetEnableClickShowInfo(true, true)
  self.attachmentDataList = nil
  self.specialGlobalStatus = nil
  self.camp_info_flag = nil
end

function CityBuffItemCell:ComponentDestroy()
  self.attachmentDataList = nil
  self.ui_player_head = nil
  self.cell_btn = nil
  self.item_icon = nil
  self.title_txt = nil
  self.des_txt = nil
  self.des_rectTransform = nil
  self.text_from = nil
  self.slider_txt = nil
  self.slider = nil
  self.timer_action = nil
  self.param = nil
  self.virusLastEndTime = nil
  self.like_btn = nil
  self.effectId = nil
  self.effectValue = nil
  self.specialGlobalStatus = nil
  self.camp_info_flag = nil
  self.click_btn = nil
end

function CityBuffItemCell:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.GetKingdomPositionCountDown, self.RefreshOfficialPositionBuffCell)
end

function CityBuffItemCell:OnRemoveListener()
  base.OnRemoveListener(self)
  self:RemoveUIListener(EventId.GetKingdomPositionCountDown, self.RefreshOfficialPositionBuffCell)
end

function CityBuffItemCell:OnDetailBtnClick()
  if self.param and self.param.meta and self.param.meta.info then
    local msg = Localization:GetString(self.param.meta.info)
    UIUtil.ShowDetail(msg, nil, nil, true, true)
  end
end

function CityBuffItemCell:SetStatus(param)
  self.param = param
  if self.param ~= nil then
    local statusId = param.id
    local statusFrom = LuaEntry.Effect:GetStatusFrom(statusId)
    if statusFrom then
      self.des_rectTransform:Set_sizeDelta_y(61.5526)
      self.text_from:SetActive(true)
      self.text_from:SetLocalText("decoration_skill_desc4", statusFrom.fromName)
    else
      self.des_rectTransform:Set_sizeDelta_y(105)
      self.text_from:SetActive(false)
    end
    local layer = LuaEntry.Effect:GetStatusLayer(statusId)
    if 0 < layer and (statusId == EffectDefine.SEASON_MUMMY_Status_Id_CURSE2 or statusId == EffectDefine.SEASON_MUMMY_Status_Id_CURSE3) then
      local description = Localization:GetString(param.meta.description)
      local num = string.match(description, "([0-9]+)")
      local strNew, count = string.gsub(description, "([0-9]+)", toInt(num) * layer)
      if count == 1 then
        self.des_txt:SetText(strNew)
      else
        self.des_txt:SetLocalText(param.meta.description)
      end
    elseif 0 < layer and statusId == LLConst.IronCurtainStatusId then
      self.des_txt:SetLocalText(param.meta.description, param.meta.effect_num, param.meta.time)
    else
      self.des_txt:SetText(DataCenter.StatusManager:GetDescByStatusId(statusId))
    end
    self.item_icon:LoadSprite(param.meta.icon)
    local StatusEffect = LocalController:instance():tryGetLine(TableName.StatusEffect, param.meta.id)
    local hasVirus, theEffectId = SeasonUtil.HasVirus()
    if param.meta.id == 700102 or StatusEffect ~= nil and toInt(StatusEffect.father_status) == 700102 then
      hasVirus = true
      theEffectId = 700102
    end
    if hasVirus and (param.meta.id == theEffectId or StatusEffect ~= nil and toInt(StatusEffect.father_status) == theEffectId) then
      local VirusLayer = LuaEntry.Player.VirusLayer
      self.title_txt:SetLocalText(param.meta.name, VirusLayer)
      if param.meta.id == theEffectId then
        if param.endTime then
          self.virusNum, self.virusEndTime, self.virusLastEndTime = SeasonUtil.CalcVirusLevel(VirusLayer, param.endTime)
        end
      elseif StatusEffect ~= nil then
        local value = StatusEffect["level_" .. VirusLayer]
        if value then
          local theId, theValue, theDesc = string.match(value, "([^|]+)|([^|]+)|([^|]+)")
          if theId and theValue and theDesc then
            self.des_txt:SetLocalText(param.meta.description, theDesc)
          end
          if param.endTime then
            local virusLifeTime = toInt(GetTableData(TableName.StatusTab, CityState.VirusCity, "time", 300))
            for level = 1, 300 do
              local key = "level_" .. level
              if StatusEffect[key] ~= nil and StatusEffect[key] ~= "" then
                if VirusLayer > level then
                  self.virusLastEndTime = param.endTime + (VirusLayer - level) * virusLifeTime * 1000
                end
                break
              end
            end
          end
        else
          self.virusLastEndTime = 0
        end
      end
      self.common_bg:SetColorRGBA255(255, 196, 196)
      self.info_btn:SetActive(true)
      self.slider:SetActive(false)
    else
      self.common_bg:SetColorRGBA255(255, 255, 255)
      self.title_txt:SetLocalText(param.meta.name)
      self.slider:SetActive(true)
      if param.meta == nil or string.IsNullOrEmpty(param.meta.info) then
        self.info_btn:SetActive(false)
      else
        self.info_btn:SetActive(true)
      end
    end
    if not string.IsNullOrEmpty(param.meta.skill_id) then
      local skill_id = tonumber(param.meta.skill_id) or 0
      if 0 < skill_id then
        local skillTemp = DataCenter.DecorationSkillTemplateManager:GetTemplate(skill_id)
        if skillTemp then
          self.des_txt:SetLocalText(param.meta.description, skillTemp:GetDescParams())
        end
      end
    end
    if param.endTime and param.totalTime and param.totalTime ~= IntMaxValue * 1000 then
      self.endTime = self.virusLastEndTime or param.endTime
      self.totalTime = param.totalTime
      self:Update1000MS()
      self.sliderParent:SetActive(true)
    else
      self.sliderParent:SetActive(false)
    end
    if param.color then
      self.common_bg:SetColor(param.color)
    end
  end
end

function CityBuffItemCell:SetWarFlag(param)
  self.param = param
  if self.param ~= nil then
    self.common_bg:SetColorRGBA255(255, 255, 255)
    self.title_txt:SetLocalText(param.meta.name)
    self.info_btn:SetActive(false)
    self.des_txt:SetLocalText(param.meta.description, SafeUnpack(param.meta.des_value))
    self.item_icon:LoadSprite(param.meta.icon)
    if param.endTime and param.meta.life_time then
      self.endTime = param.endTime
      self.totalTime = param.meta.life_time * 1000
      self:Update1000MS()
      self.sliderParent:SetActive(true)
    else
      self.sliderParent:SetActive(false)
    end
    if self.param.releaseName then
      self.text_from:SetActive(true)
      self.text_from:SetLocalText("decoration_skill_desc4", self.param.releaseName)
    else
      self.text_from:SetActive(false)
    end
  end
end

function CityBuffItemCell:SetDragonEffect(effectInfo)
  self.sliderParent:SetActive(false)
  if effectInfo == nil then
    self.text_from:SetActive(false)
    self.endTime = nil
    self.totalTime = nil
  elseif effectInfo.template ~= nil then
    local template = effectInfo.template
    self.common_bg:SetColorRGBA255(255, 255, 255)
    self.title_txt:SetLocalText(template.nameID or template.name)
    if (effectInfo.bfType == BattleFieldType.EpidemicZone or effectInfo.bfType == BattleFieldType.DsbDuel) and template.getDesc then
      self.des_txt:SetText(template:getDesc())
    else
      self.des_txt:SetLocalText(template.descID or template.desc, effectInfo.value)
    end
    self.item_icon:LoadSprite(template.effect_icon or template.icon)
    self.info_btn:SetActive(false)
    self.endTime = effectInfo.expireTime
    self.totalTime = template.duration_time
  elseif effectInfo.id ~= nil then
    effectInfo = DataCenter.DragonBuildTemplateManager:GetEffectInfo(effectInfo.id)
    if effectInfo then
      self.common_bg:SetColorRGBA255(255, 255, 255)
      self.title_txt:SetLocalText(effectInfo.nameID)
      self.des_txt:SetLocalText(effectInfo.descID)
      self.item_icon:LoadSprite(effectInfo.effect_icon)
      self.info_btn:SetActive(false)
    end
    self.text_from:SetActive(false)
  end
end

function CityBuffItemCell:SetTemperatureBuff(tempBuff)
  self.sliderParent:SetActive(false)
  self.common_bg:SetColorRGBA255(255, 255, 255)
  self.title_txt:SetText(tempBuff.name)
  self.des_txt:SetText(tempBuff.desc)
  self.item_icon:LoadSprite(tempBuff.icon)
  self.info_btn:SetActive(false)
  self.text_from:SetActive(false)
end

function CityBuffItemCell:SetResistanceBuff()
  self.sliderParent:SetActive(false)
  self.common_bg:SetColorRGBA255(255, 255, 255)
  self.title_txt:SetLocalText("alliance_science_name011")
  self.des_txt:SetLocalText("season_trends_info002")
  self.item_icon:LoadSprite("Assets/Main/Sprites/UI/LWCommon/Sprite/zyf_saijikaifa_dangqiankangxing_icon.png")
  self.info_btn:SetActive(false)
  self.text_from:SetActive(true)
  local msg = Localization:GetString("season_tiles_popui_info010")
  local count = string.GetFormattedSeparatorNum(SeasonUtil.GetSelfSeasonResistanceValue())
  self.text_from:SetText(msg .. " " .. count)
end

function CityBuffItemCell:SetSeasonFarmerBuff(effectId, effectValue, effectName, effectDesc, effectIcon, stateMeta, attachmentInfo)
  self.sliderParent:SetActive(false)
  if not stateMeta or string.IsNullOrEmpty(stateMeta.color) then
    self.common_bg:SetColorHex("#ffffff")
  else
    self.common_bg:SetColorHex(stateMeta.color)
  end
  self.title_txt:SetLocalText(effectName)
  self.des_txt:SetLocalText(effectDesc)
  self.item_icon:LoadSprite(effectIcon)
  if stateMeta == nil or string.IsNullOrEmpty(stateMeta.info) then
    self.info_btn:SetActive(false)
    self.param = nil
  else
    self.info_btn:SetActive(true)
    self.param = {meta = stateMeta}
  end
  self.text_from:SetActive(false)
  self.effectId = effectId
  self.effectValue = effectValue
  if attachmentInfo then
    local dataList = {}
    for k, v in ipairs(attachmentInfo) do
      if v and v.effect then
        for _effectId, _effectValue in pairs(v.effect) do
          if _effectId == effectId then
            table.insert(dataList, v)
          end
        end
      end
    end
    if table.count(dataList) > 0 then
      self.info_btn:SetActive(true)
      self.attachmentDataList = dataList
    end
  end
end

function CityBuffItemCell:RefreshSpecialRenderer(globalStatus)
  self.specialGlobalStatus = globalStatus
  if self.specialGlobalStatus and self.specialGlobalStatus.reason == FetchGlobalStateReason.Season6CampDestroy then
    self.info_btn:SetActive(true)
  end
end

function CityBuffItemCell:SetCustomCampScienceInfoClick(info_flag)
  self.camp_info_flag = info_flag
  if self.camp_info_flag ~= nil then
    self.info_btn:SetActive(true)
  end
end

function CityBuffItemCell:SetLandlordBuff(effectName, effectDesc, effectIcon, stateMeta)
  self.sliderParent:SetActive(false)
  if not stateMeta or string.IsNullOrEmpty(stateMeta.color) then
    self.common_bg:SetColorHex("#ffffff")
  else
    self.common_bg:SetColorHex(stateMeta.color)
  end
  self.title_txt:SetLocalText(effectName)
  self.des_txt:SetText(effectDesc)
  self.item_icon:LoadSprite(effectIcon)
  if stateMeta == nil or string.IsNullOrEmpty(stateMeta.info) then
    self.info_btn:SetActive(false)
    self.param = nil
  else
    self.info_btn:SetActive(true)
    self.param = {meta = stateMeta}
  end
  self.text_from:SetActive(false)
end

function CityBuffItemCell:SetSeasonDarknessBuff(stateMeta, lightStatus, effectName, effectDesc, effectIcon, stateMeta)
  self.sliderParent:SetActive(false)
  self.common_bg:SetColorHex("#ffffff")
  self.title_txt:SetLocalText(effectName)
  if lightStatus and lightStatus.lightPeople then
    self.des_txt:SetLocalText(effectDesc, " " .. lightStatus.lightPeople)
  elseif lightStatus and lightStatus.layer then
    self.des_txt:SetLocalText(effectDesc, " " .. lightStatus.layer)
  else
    self.des_txt:SetLocalText(effectDesc, " ???")
  end
  if stateMeta == nil or string.IsNullOrEmpty(stateMeta.info) then
    self.info_btn:SetActive(false)
    self.param = nil
  else
    self.info_btn:SetActive(true)
    self.param = {meta = stateMeta}
  end
  self.text_from:SetActive(false)
  if lightStatus and lightStatus.lightPlayer then
    local lightPlayer = lightStatus.lightPlayer
    local str = UIUtil.FormatAllianceAndName(lightPlayer.abbr, lightPlayer.name)
    local lightLevel = toInt(lightPlayer.lightLevel)
    self.lightPlayerUid = lightPlayer.uid
    self.title_txt:SetText(string.format("%s (L%s)", Localization:GetString("season_s4_light_on_ui_title08"), lightLevel))
    self.des_txt:SetText(Localization:GetString(effectDesc, "") .. " " .. str)
    self.ui_player_head:SetActive(true)
    self.ui_player_head:ParseHeadInfo(lightStatus.lightPlayer)
    self.like_btn:SetActive(self.lightPlayerUid ~= nil)
  else
    self.ui_player_head:SetActive(false)
    self.item_icon:LoadSprite(effectIcon)
    self.like_btn:SetActive(false)
  end
end

function CityBuffItemCell:SetOfficialPositionBuff(data, scale)
  self.param = data
  if self.param ~= nil then
    self.common_bg:SetColorRGBA255(255, 255, 255)
    self.title_txt:SetText(self.param.name)
    self.des_txt:SetText(self.param.desc)
    self.item_icon:LoadSprite(self.param.icon)
    self.info_btn:SetActive(false)
    self.text_from:SetActive(false)
    self.item_icon:SetNativeSize()
    self:SetItemIconScale(scale)
    self:RefreshOfficialPositionBuffCountDown()
  end
end

function CityBuffItemCell:RefreshOfficialPositionBuffCountDown()
  local isOpen = DataCenter.GovernmentManager:CheckKingdomPositionCountDownIsOpen()
  local countdown = DataCenter.GovernmentManager:GetKingdomPositionCountDown()
  if 0 < countdown and isOpen then
    local startTime = DataCenter.GovernmentManager:GetKingdomPositionStartTime()
    self.endTime = countdown
    self.totalTime = countdown - startTime
    self:Update1000MS()
    self.sliderParent:SetActive(true)
  else
    self.sliderParent:SetActive(false)
  end
end

function CityBuffItemCell:RefreshOfficialPositionBuffCell()
  if self.param and self.param.isOfficialPositionBuff then
    self:RefreshOfficialPositionBuffCountDown()
  end
end

function CityBuffItemCell:SetCampScienceBuff(data, scale)
  self.param = data
  if self.param ~= nil then
    self.common_bg:SetColorRGBA255(255, 255, 255)
    self.title_txt:SetText(self.param.name)
    self.des_txt:SetText(self.param.desc)
    self.item_icon:LoadSprite(self.param.icon)
    self.info_btn:SetActive(true)
    self.text_from:SetActive(false)
    self.item_icon:SetNativeSize()
    self.sliderParent:SetActive(false)
    self:SetItemIconScale(scale)
  end
end

function CityBuffItemCell:SetSandWormWrapBuff(isChomper)
  local isWrap, expireTime, totalTime
  totalTime = 36000000
  if isChomper then
    isWrap, expireTime = DataCenter.JungleTrialDataManager:IsMyBaseSwallow()
    self.title_txt:SetLocalText("season6_piranha_swallow_state_name")
    self.des_txt:SetLocalText("season6_piranha_swallow_state_desc")
    self.item_icon:LoadSprite("Assets/Main/SeasonRes/S6/Sprites/JungleTrial/zxl_s6shirenhua_touxiang.png")
    local _, chomperId = DataCenter.JungleTrialDataManager:IsChomper()
    local monsterTemplate = DataCenter.MonsterTemplateManager:GetMonsterTemplate(chomperId)
    if monsterTemplate then
      totalTime = monsterTemplate.expire * 60000
    end
  else
    isWrap, expireTime = DataCenter.SandWormHuntDataManager:IsMyBaseWormWrap()
    self.title_txt:SetLocalText("season_activity_1000069_desc09")
    self.des_txt:SetLocalText("season_activity_1000069_desc33")
    self.item_icon:LoadSprite("Assets/Main/SeasonRes/S3/Sprites/Sandworm/mjc_S3_sc_zhuye_icon.png")
  end
  local now = UITimeManager:GetInstance():GetServerTime()
  if expireTime > now then
    self.endTime = expireTime
    self.totalTime = totalTime
    self.sliderParent:SetActive(true)
  else
    self.endTime = nil
    self.totalTime = nil
    self.sliderParent:SetActive(false)
  end
  self.common_bg:SetColorRGBA255(255, 255, 255)
  self.info_btn:SetActive(false)
  self.text_from:SetActive(false)
  self:Update1000MS()
end

function CityBuffItemCell:SetWallBar(data)
  self.title_txt:SetLocalText("season_mastery_s6_buff_5_limit")
  self.des_txt:SetLocalText("season_mastery_s6_buff_6_limit")
  self.item_icon:LoadSprite(data.icon)
  local now = UITimeManager:GetInstance():GetServerTime()
  if now < data.expireTime then
    self.endTime = data.expireTime
    self.totalTime = data.totalTime
    self.sliderParent:SetActive(true)
  else
    self.endTime = nil
    self.totalTime = nil
    self.sliderParent:SetActive(false)
  end
  self.common_bg:SetColorRGBA255(255, 255, 255)
  self.info_btn:SetActive(false)
  self.text_from:SetActive(false)
  self:Update1000MS()
end

function CityBuffItemCell:SetItemIconScale(scale)
  self.item_icon:SetLocalScaleXYZ(scale, scale, scale)
end

function CityBuffItemCell:Update1000MS()
  if self.endTime and self.totalTime then
    local now = UITimeManager:GetInstance():GetServerTime()
    local leftTime = self.endTime - now
    if leftTime <= 0 then
      self.sliderParent:SetActive(false)
    else
      self.slider_txt:SetText(UITimeManager:GetInstance():MilliSecondToFmtString(leftTime))
      local percent = leftTime / math.max(1, self.totalTime)
      self.slider:SetValue(percent)
    end
  end
end

function CityBuffItemCell:SetCollectLimtFlag(param)
  self.param = param
  if self.param ~= nil then
    self.common_bg:SetColorRGBA255(255, 255, 255)
    self.title_txt:SetText(param.name)
    self.info_btn:SetActive(false)
    self.des_rectTransform:Set_sizeDelta_y(105)
    self.text_from:SetActive(false)
    self.des_txt:SetText(param.desc)
    self.item_icon:LoadSprite(param.icon)
    self.item_icon:SetSizeDeltaXY(80, 80)
    if param.endTime and param.totalTime then
      self.endTime = param.endTime
      self.totalTime = param.totalTime
      self:Update1000MS()
      self.sliderParent:SetActive(true)
    else
      self.sliderParent:SetActive(false)
    end
  end
end

function CityBuffItemCell:OnClickItemIcon()
  self:ShowSeasonCampDestroyZoneDetail()
end

function CityBuffItemCell:ShowSeasonCampDestroyZoneDetail()
  if self.specialGlobalStatus and self.specialGlobalStatus.reason == FetchGlobalStateReason.Season6CampDestroy then
    local serverInfo = DataCenter.SeasonCampDestroyManager:GetServerInfoById(LuaEntry.Player:GetSelfServerId())
    if serverInfo then
      UIUtil.OpenAuto(UIWindowNames.SeasonCampDestroyZoneDetail, serverInfo)
    end
  end
end

return CityBuffItemCell
