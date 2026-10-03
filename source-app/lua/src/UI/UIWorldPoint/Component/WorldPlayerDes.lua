local WorldPlayerDes = BaseClass("WorldPlayerDes", UIAsyncContainer)
local base = UIAsyncContainer
local Localization = CS.GameEntry.Localization
local SeasonFrozenStatus = require("UI.UIWorldPoint.Component.SeasonFrozenStatus")
local ActGiftGivingContent = require("UI.UIWorldPoint.Component.ActGiftGivingContent")
local MeteoriteStates = require("UI.UIWorldPoint.Component.MeteoriteStates")
local ActValentineSendGiftContent = require("UI.UIWorldPoint.Component.ActValentineSendGiftContent")
local SeasonCallbackInfo = require("UI.LWSeason.LWSeasonMain.Component.SeasonCallback.SeasonCallbackInfo")
local MusicFestival2025Content = require("UI.UIWorldPoint.Component.MusicFestival2025Content")
local BirthdayBtnItem = require("UI.LWPlayerInfo.UILWPlayerDetail.Component.Bottom.Btns.BirthdayBtnItem")
local MapStickerSendContent = require("UI.UIWorldPoint.Component.MapStickerSendContent")
local lua_path_assistance = "UI.UIWorldPoint.Component.UIWorldPointNewOtherPlayerInfoAssistanceComp"
local player_obj_path = "info/playerObj"
local build_obj_path = "info/buildObj"
local headBg_path = "info/headObj/UIPlayerHead"
local player_head_path = "info/headObj/UIPlayerHead"
local player_head_img_path = "info/headObj/UIPlayerHead/HeadIcon"
local power_des_path = "info/playerObj/PowerContent/powerDes"
local power_num_path = "info/playerObj/PowerContent/powerNum"
local kill_des_path = "info/playerObj/KillContent/killDes"
local kill_num_path = "info/playerObj/KillContent/killNum"
local alliance_des_path = "info/playerObj/AllyContent/AlliDes"
local alliance_num_path = "info/playerObj/AllyContent/AlliName"
local birthday_icon_path = "info/headObj/birthdayIcon"
local name_txt_path = "info/buildObj/TextName"
local slider_path = "info/buildObj/Slider"
local num_path = "info/buildObj/Txt_CollectNum"
local time_path = "info/buildObj/Txt_CollectTime"
local l_w_btn_info_path = "info/buildObj/LW_Btn_Info"
local specialContent_path = "specialContent"
local specialDesTxt_path = "specialContent/specialDesTxt"
local specialDesImg_path = "specialContent/specialDesImg"
local specialTimeTip_path = "specialContent/specialTimeTip"
local specialTimeTxt_path = "specialContent/specialTimeTip/specialTimeTxt"
local thumbs_up_path = "NormalContent/Like"
local normal_content_path = "NormalContent"
local thumbs_reward_flag_path = "NormalContent/Like/rewardFlag"
local firework_path = "NormalContent/Firework"
local firework_txt_path = "NormalContent/Firework/TextName"
local firework_count_path = "NormalContent/Firework/FireworkCountBG/FireworkCount"
local queue_btn_path = "NormalContent/Firework/queueBtn"
local queue_txt_path = "NormalContent/Firework/queueTxt"
local icon_path = "NormalContent/Like/bg/icon"
local like_txt_path = "NormalContent/Like/likeTxt"
local temperature_path = "temperature"
local temperature_bg_path = "temperature/icon/temperatureBg"
local temperature_value_path = "temperature/icon/temperatureValue"
local season_frozen_tips_path = "seasonFrozenTips"
local UISeasonCallbackInfoPath = "temperature/bg/UISeasonCallbackInfo"
local act_gift_giving_content_path = "actGiftGivingContent"
local act_valentine_content_path = "actValentineContent"
local meteorite_states_obj_path = "meteoriteStatesObj"
local assistance_root_path = "assistanceRoot"
local music_festival2025_content_path = "musicFestival2025Content"
local map_sticker_send_content_path = "MapStickerSendContent"

local function OnCreate(self)
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

local function OnDestroy(self)
  self:DestroyBirthdayBtn()
  self:ComponentDestroy()
  self:DataDestroy()
  base.OnDestroy(self)
end

local function OnEnable(self)
  base.OnEnable(self)
  self.l_w_btn_info:SetActive(false)
end

local function OnDisable(self)
  self:DeleteTimer()
  base.OnDisable(self)
end

function WorldPlayerDes:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.PlayerMessageInfo, self.UpdatePlayerHead)
  self:AddUIListener(EventId.LWQueryThumbsInfoUpdate, self.RefreshRewardFlag)
  self:AddUIListener(EventId.OnThumbUpSuccess, self.OnThumbUpSuccess)
  self:AddUIListener(EventId.BirthdayThumbsUpSuccess, self.OnBirthdayThumbUpSuccess)
  self:AddUIListener(EventId.UIRefreshAssistanceDetailInfo, self.OnAssistanceDetailInfo)
  self:AddUIListener(EventId.FocusPointChanged, self.OnAssistanceDetailInfo)
  self:AddUIListener(EventId.BirthdayThumbsUpAniFin, self.OnBirthdayThumbsUpAniFin)
end

function WorldPlayerDes:OnRemoveListener()
  self:RemoveUIListener(EventId.PlayerMessageInfo, self.UpdatePlayerHead)
  self:RemoveUIListener(EventId.LWQueryThumbsInfoUpdate, self.RefreshRewardFlag)
  self:RemoveUIListener(EventId.OnThumbUpSuccess, self.OnThumbUpSuccess)
  self:RemoveUIListener(EventId.BirthdayThumbsUpSuccess, self.OnBirthdayThumbUpSuccess)
  self:RemoveUIListener(EventId.UIRefreshAssistanceDetailInfo, self.OnAssistanceDetailInfo)
  self:RemoveUIListener(EventId.FocusPointChanged, self.OnAssistanceDetailInfo)
  self:RemoveUIListener(EventId.BirthdayThumbsUpAniFin, self.OnBirthdayThumbsUpAniFin)
  base.OnRemoveListener(self)
end

local function ComponentDefine(self)
  self.player_obj = self:AddComponent(UIBaseContainer, player_obj_path)
  self.build_obj = self:AddComponent(UIAnimator, build_obj_path)
  self.player_head = self:AddComponent(UICommonHead, player_head_path)
  self.player_head_img = self:AddComponent(CircleImage, player_head_img_path)
  self.playerHeadBg = self:AddComponent(UIButton, headBg_path)
  self.playerHeadBg:SetOnClick(function()
    DataCenter.LWSoundManager:PlayEffect(SoundAssetId.SFX_UI_General_Click_1st)
    self:OnClickHead()
  end)
  self.power_des = self:AddComponent(UIText, power_des_path)
  self.power_num = self:AddComponent(UIText, power_num_path)
  self.kill_des = self:AddComponent(UIText, kill_des_path)
  self.kill_num = self:AddComponent(UIText, kill_num_path)
  self.alliance_des = self:AddComponent(UIText, alliance_des_path)
  self.alliance_num = self:AddComponent(UIText, alliance_num_path)
  self.name_txt = self:AddComponent(UIText, name_txt_path)
  self.collectNum_txt = self:AddComponent(UIText, num_path)
  self.l_w_btn_info = self:AddComponent(UIButton, l_w_btn_info_path)
  self.l_w_btn_info:SetOnClick(function()
    local content = Localization:GetString("world_tip10007")
    UIUtil.ShowBubbleTips(content, self.l_w_btn_info.transform.position, 0, -30, -20)
  end)
  self.l_w_btn_info:SetActive(false)
  self.collectTime_txt = self:AddComponent(UIText, time_path)
  self.slider = self:AddComponent(UISlider, slider_path)
  self.power_des:SetLocalText(GameDialogDefine.POWER)
  self.kill_des:SetLocalText(GameDialogDefine.KILL_NUM)
  self.alliance_des:SetLocalText(GameDialogDefine.ALLIANCE)
  self.specialContent = self:AddComponent(UIBaseContainer, specialContent_path)
  self.specialDesTxt = self:AddComponent(UIText, specialDesTxt_path)
  self.specialDesImg = self:AddComponent(UIImage, specialDesImg_path)
  self.specialTimeTip = self:AddComponent(UIText, specialTimeTip_path)
  self.specialTimeTxt = self:AddComponent(UIText, specialTimeTxt_path)
  self.specialContent:SetActive(false)
  if WorldBattleUtil.EnableShowWorldAssistanceInfo() then
    self.dCompAssistance = UIAsyncLoaderBridge.New(self, "dCompAssistance", self.transform:Find(assistance_root_path), UIAssets.UIWorldPointComp_PlayerAssistanceComp, lua_path_assistance, true)
  end
  self.normalRoot = self:AddComponent(UIBaseContainer, normal_content_path)
  self.thumbsUpRoot = self:AddComponent(UIButton, thumbs_up_path)
  self.thumbsUpRoot:SetOnClick(function()
    local thePlayerUid = self.view.ctrl.ownerUid
    if thePlayerUid then
      DataCenter.LWSoundManager:PlayEffect(SoundAssetId.SFX_UI_General_Click_1st)
      local thumbsUpType = InteractiveUtil.ThumbsUpType.CityInfo
      local identifier = "WorldPlayerDes"
      local userinfo = ChatInterface.getUserData(thePlayerUid, true)
      if userinfo ~= nil then
        local isShowBirthdayIcon = DataCenter.BirthdayDataManager:GetIsShowBirthdayIconByUserInfo(userinfo)
        if isShowBirthdayIcon and not DataCenter.BirthdayDataManager:GetIsHaveBirthdayHistoriey(userinfo.uid) then
          thumbsUpType = InteractiveUtil.ThumbsUpType.BirthdayInformation
        end
      end
      InteractiveUtil.TryThumbsUp(thePlayerUid, thumbsUpType, identifier, function()
      end)
    end
  end)
  self.thumbsUpRoot:SetActive(false)
  self.thumbsRewardFlag = self:AddComponent(UIImage, thumbs_reward_flag_path)
  self.icon = self:AddComponent(UIImage, icon_path)
  self.iconRoot = self:AddComponent(UIBaseContainer, icon_path)
  self.fireworkRoot = self:AddComponent(UIButton, firework_path)
  self.fireworkTxt = self:AddComponent(UITextMeshProUGUIEx, firework_txt_path)
  self.fireworkTxt:SetLocalText("firework_interface_1004")
  self.fireworkRoot:SetOnClick(function()
    DataCenter.LWFireworkManager:UseFireworkItem(self.view.ctrl.ownerUid)
  end)
  self.fireworkRoot:SetActive(false)
  self.fireworkCount = self:AddComponent(UITextMeshProUGUIEx, firework_count_path)
  self.queue_btn = self:AddComponent(UIButton, queue_btn_path)
  self.queue_btn:SetOnClick(function()
    local param = {}
    param.type = "desc"
    param.title = ""
    param.desc = "firework_tips_1011"
    param.alignObject = self.queue_btn
    UIManager:GetInstance():OpenWindow(UIWindowNames.UIItemTips, {anim = true}, param)
  end)
  self.queue_txt = self:AddComponent(UITextMeshProUGUIEx, queue_txt_path)
  self.temperature = self:AddComponent(UIBaseContainer, temperature_path)
  self.temperature_bg = self:AddComponent(UIImage, temperature_bg_path)
  self.temperature_value = self:AddComponent(UITextMeshProUGUIEx, temperature_value_path)
  self.temperature:SetActive(false)
  self.season_frozen_tips = self:AddComponent(SeasonFrozenStatus, season_frozen_tips_path)
  self.season_frozen_tips:SetActive(false)
  self.seasonCallbackInfo = self:AddComponent(SeasonCallbackInfo, UISeasonCallbackInfoPath)
  if self.seasonCallbackInfo then
    self.seasonCallbackInfo:SetActive(false)
  end
  self.act_gift_giving_content = self:AddComponent(ActGiftGivingContent, act_gift_giving_content_path)
  self.act_gift_giving_content:SetActive(false)
  self.meteoriteState = self:AddComponent(MeteoriteStates, meteorite_states_obj_path)
  self.meteoriteState:SetActive(false)
  self.actValentineContent = self:AddComponent(ActValentineSendGiftContent, act_valentine_content_path)
  self.actValentineContent:SetActive(false)
  self.music_festival2025_content = self:AddComponent(MusicFestival2025Content, music_festival2025_content_path)
  self.music_festival2025_content:SetActive(false)
  self.birthday_icon = self:AddComponent(UIImage, birthday_icon_path)
  self.like_txt = self:AddComponent(UITextMeshProUGUIEx, like_txt_path)
  self.map_sticker_send_content = self:AddComponent(MapStickerSendContent, map_sticker_send_content_path)
  self.map_sticker_send_content:SetActive(false)
end

local function ComponentDestroy(self)
  self.btn = nil
  self.btnImage = nil
  self.specialContent = nil
  self.specialDesTxt = nil
  self.specialDesImg = nil
  self.specialTimeTip = nil
  self.specialTimeTxt = nil
  self.temperature = nil
  self.temperature_bg = nil
  self.temperature_value = nil
  self.season_frozen_tips = nil
  self.act_gift_giving_content = nil
  self.actValentineContent = nil
  self.birthday_icon = nil
  self.icon = nil
  self.like_txt = nil
  self.map_sticker_send_content = nil
  if self.dCompAssistance then
    self.dCompAssistance:Delete()
    self.dCompAssistance = nil
  end
end

local function DataDefine(self)
  self.data = nil
  self.isRuins = false
  
  function self.timer_action(temp)
    self:RefreshTime()
  end
  
  self.isDetectCollect = false
  self.detectExpireTime = 0
end

local function DataDestroy(self)
  self.isRuins = nil
  self.data = nil
end

function WorldPlayerDes:UpdatePlayerHead(uid)
  if uid == self.view.ctrl.ownerUid then
    local userinfo = ChatInterface.getUserData(uid, true)
    if userinfo ~= nil then
      local userPic = userinfo.headPic or ""
      local userPicVer = userinfo.headPicVer or 0
      self.player_head:ShowLoadingAinmation()
      self.player_head:SetCustomLoadCallback(function()
        self.player_head:HideLoadingAinmation()
      end)
      self.player_head:SetData(uid, userPic, userPicVer, nil, userinfo:GetHeadBgImg())
      self:RefreshBirthdayView()
    end
  end
end

function WorldPlayerDes:UpdateFireworkQueue()
  local player = LuaEntry.Player
  local isSelf = player.uid == self.view.ctrl.ownerUid
  local isInSameAlliance = self.view.ctrl.isAlliance
  if isSelf or isInSameAlliance then
    local isFiring = DataCenter.LWFireworkManager:IsFiringByUid(self.view.ctrl.ownerUid)
    self.queue_btn:SetActive(isFiring)
    self.queue_txt:SetActive(isFiring)
    if isFiring then
      self.queue_txt:SetText(DataCenter.LWFireworkManager:GetQueueCountByUid(self.view.ctrl.ownerUid))
    end
  end
end

function WorldPlayerDes:OnBirthdayThumbsUpAniFin()
  self:RefreshBirthdayView()
end

function WorldPlayerDes:RefreshBirthdayView()
  local uid = self.view.ctrl.ownerUid
  local userinfo = ChatInterface.getUserData(uid, true)
  self.like_txt:SetLocalText("thumbs_up_player_city")
  self.icon:SetEnable(true)
  self:DestroyBirthdayBtn()
  if userinfo ~= nil then
    local isShowBirthdayIcon = DataCenter.BirthdayDataManager:GetIsShowBirthdayIconByUserInfo(userinfo)
    self.birthday_icon:SetActive(isShowBirthdayIcon)
    if isShowBirthdayIcon and not DataCenter.BirthdayDataManager:GetIsHaveBirthdayHistoriey(userinfo.uid) then
      self.like_txt:SetLocalText("birthday_tips_25")
      self:TryShowBirthdayBtn(userinfo)
      self.icon:SetEnable(false)
    else
      self.icon:LoadSprite("Assets/Main/Sprites/UI/LWPlayerInfo/Sprite/New/lrb_gerenxinxi_dianzan.png")
    end
  else
    self.birthday_icon:SetActive(false)
    self.icon:LoadSprite("Assets/Main/Sprites/UI/LWPlayerInfo/Sprite/New/lrb_gerenxinxi_dianzan.png")
  end
end

local function RefreshData(self, param)
  self.isRuins = false
  self.isDetectCollect = false
  self.recoverSpeed = LuaEntry.DataConfig:TryGetNum("building_attack", "k2")
  self.data = param
  if self.view.info.isSeasonPlayerBuilding and self.view.info.recoverSpeed then
    self.recoverSpeed = self.view.info.recoverSpeed
  end
  local isFakePlayerDetect = false
  if self.view.ctrl.type == WorldPointUIType.City then
    if self.data and not self.data:IsNormalType() then
      isFakePlayerDetect = true
      local detail = DataCenter.WorldPointDetailManager:GetDetailByPointId(self.view.ctrl.pointId)
      if detail then
        self.player_head_img:LoadSprite(string.format(LoadPath.UIPlayerIcon, detail.pic))
      end
    end
    local showTemperature = false
    local conductor = param.thermalConductor
    if not isFakePlayerDetect and conductor ~= nil and SeasonUtil.IsInSeasonSnowMode() then
      showTemperature = true
      local curTemperature = conductor:GetCurTemperature()
      self.temperature_value:SetText(string.format("%.1f\194\176C", curTemperature))
      self.temperature_bg:SetColor(SeasonUtil.GetTemperatureColor(curTemperature))
    end
    self.temperature:SetActive(showTemperature)
    if not isFakePlayerDetect and SeasonUtil.IsInSeasonSnowMode() then
      self.season_frozen_tips:Refresh(WorldPointUIType.City, param.thermalConductor, nil, self.view.ctrl.uuid)
    end
    self.act_gift_giving_content:SetActive(false)
    if self.data and self.data:IsNormalType() then
      local ownerUid = self.data.ownerUid
      if ownerUid and ownerUid ~= LuaEntry.Player.uid then
        local targetActId, actEndTime = DataCenter.ActGiftGivingDataManager:GetOneOpenActId()
        local isInCrossServer = CrossServerUtil.CheckCrossServerWithWatchAndJoinType()
        if 0 < targetActId and not isInCrossServer then
          self.act_gift_giving_content:SetActive(true)
          self.act_gift_giving_content:Refresh(WorldPointUIType.City, self.view.ctrl.uuid, ownerUid, targetActId, actEndTime)
        end
      end
      local isInMeteoriteBattle = DataCenter.ActMeteoriteBattleManager:IsInMeteoriteBattle()
      if isInMeteoriteBattle then
        self.meteoriteState:SetActive(true)
        self.meteoriteState:Refresh(ownerUid, self.view.ctrl.uuid)
      else
        self.meteoriteState:SetActive(false)
      end
    end
    if self.data and self.data:IsNormalType() then
      local isShow = self:IsShowMusicFestival2025Content(self.data)
      self.music_festival2025_content:SetActive(isShow)
      if isShow then
        self.music_festival2025_content:Refresh(self.data)
      end
    end
  else
    self.temperature:SetActive(false)
  end
  if param.IsWerewolf then
    self.player_head:ShowWerewolf()
    self.alliance_num:SetLocalText(130262)
    self.power_num:SetLocalText(130262)
    self.kill_num:SetLocalText(130262)
  elseif not isFakePlayerDetect then
    local uid = self.view.ctrl.ownerUid
    local userinfo = ChatInterface.getUserData(uid, true)
    if userinfo ~= nil then
      local userPic = userinfo.headPic or ""
      local userPicVer = userinfo.headPicVer or 0
      self.player_head:ShowLoadingAinmation()
      self.player_head:SetCustomLoadCallback(function()
        self.player_head:HideLoadingAinmation()
      end)
      self.player_head:SetData(uid, userPic, userPicVer, nil, userinfo:GetHeadBgImg())
      self:RefreshBirthdayView()
    end
  end
  if self.view.ctrl.type == WorldPointUIType.City then
    self.player_obj:SetActive(true)
    self.build_obj:SetActive(false)
    if LuaEntry.Player.uid ~= self.view.ctrl.ownerUid then
      self.thumbsUpRoot:SetActive(true)
      DataCenter.SeasonCallbackManager:TryQueryThumbsMessage()
      self:RefreshRewardFlag()
      self.map_sticker_send_content:SetActive(false)
    else
      self.thumbsUpRoot:SetActive(false)
      self.map_sticker_send_content:SetActive(true)
      self.map_sticker_send_content:Refresh()
    end
    local player = LuaEntry.Player
    local isSelf = player.uid == self.view.ctrl.ownerUid
    local isInSameAlliance = self.view.ctrl.isAlliance
    local isScienceOpen = DataCenter.AllyDuelScoreGachaManager:IsScienceOpen()
    local hasAnyFireworkGoods = DataCenter.LWFireworkManager:HasAnyFireworkGoods()
    self.fireworkRoot:SetActive((isSelf or isInSameAlliance) and (isScienceOpen or hasAnyFireworkGoods))
    self.normalRoot:SetActive(self.thumbsUpRoot:GetActive() or self.fireworkRoot:GetActive())
    if isSelf or isInSameAlliance then
      local defaultFireworkId = DataCenter.LWFireworkManager:GetDefaultFireworkItemId()
      self.fireworkCount:SetText(DataCenter.ItemData:GetItemCount(defaultFireworkId))
      self:UpdateFireworkQueue()
    end
  else
    self.fireworkRoot:SetActive(false)
    self.player_obj:SetActive(false)
    if self.view.info.isSeasonPlayerBuilding then
      self.build_obj:SetActive(true)
      self.build_obj:Enable(false)
      self.collectNum_txt:SetActive(true)
      self.collectTime_txt:SetActive(false)
    else
      self.build_obj:SetActive(true)
      local bType = self:BCollectArmy()
      if bType then
        self.build_obj:Play("txtchangell", 0, 0)
        if self.data ~= nil then
          self.name_txt:SetText(self.data.resourceName)
          self.slider:SetActive(true)
          self:AddTimer()
          self.endTime = self.data.endTime
          self:RefreshTime()
        else
          self.name_txt:SetText("")
          self.slider:SetActive(false)
          self.collectNum_txt:SetText("")
        end
      else
        self.build_obj:Play("txtChangeNormal", 0, 0)
      end
    end
  end
  self:RefreshTopBg()
  local bType = self:BCollectArmy()
  if bType then
    local info = CS.SceneManager.World:GetResourcePointInfoByIndex(self.data.pointId)
    if info == nil then
      return
    end
    local pointType = info.PointType
    if pointType ~= CS.WorldPointType.WorldResource then
      return
    end
    local infoId = info.id
    local resCfg = DataCenter.GatherResourceTemplateManager:GetTemplate(infoId)
    if resCfg.type == 1 then
      self.specialContent:SetActive(true)
      self.specialDesTxt:SetLocalText("800810", resCfg.detect_show)
      local imgPath = CSharpCallLuaInterface.GetResourceDetectInfoIconBgById(infoId)
      self.specialDesImg:LoadSprite(imgPath)
      self.isDetectCollect = true
      self.detectExpireTime = 0
      local serverData = DataCenter.WorldPointDetailManager:GetDetailByPointId(self.view.ctrl.pointId)
      if serverData then
        self.detectExpireTime = serverData.eventExpireTime
      end
      self.specialTimeTip:SetLocalText(800823)
      self:RefreshTime()
    else
      self.specialContent:SetActive(false)
    end
  end
end

local function DeleteTimer(self)
  if self.timer ~= nil then
    self.timer:Stop()
    self.timer = nil
  end
end

local function AddTimer(self)
  if self.timer == nil then
    self.timer = TimerManager:GetInstance():GetTimer(1, self.timer_action, self, false, false, false)
  end
  self.timer:Start()
end

local function RefreshTime(self)
  local curTime = UITimeManager:GetInstance():GetServerTime()
  if self.view.ctrl == nil then
    return
  end
  local bType = self:BCollectArmy()
  if bType then
    if self.data == nil then
      return
    end
    if self.data.gatherMarchUuid == nil then
      return
    end
    local deltaTime = self.endTime - curTime
    local maxTime = self.endTime - self.data.startTime
    if 0 < deltaTime then
      local maxLoot = math.floor(maxTime * 0.001 * self.data.collectSpd)
      self.collectNum_txt:SetText(Localization:GetString("300642") .. ": " .. math.floor((maxTime - deltaTime) * 0.001 * self.data.collectSpd) .. "/" .. maxLoot)
      local resData = DataCenter.WorldPointDetailManager:GetDetailByPointId(self.view.ctrl.pointId)
      if resData and resData.remainRes and maxLoot + 100 < resData.remainRes then
        self.l_w_btn_info:SetActive(true)
      end
      self.collectTime_txt:SetText(Localization:GetString("300641") .. ": " .. UITimeManager:GetInstance():MilliSecondToFmtString(deltaTime))
      local tempValue = math.min(1 - deltaTime / math.max(maxTime, 1), 1)
      self.slider:SetValue(tempValue)
    else
      self.slider:SetValue(1)
      self.collectNum_txt:SetText("")
      self.collectTime_txt:SetText("")
      self.view.ctrl:CloseSelf(true)
    end
  elseif self.view.ctrl.type == WorldPointUIType.Build then
    if self.serverData == nil or self.serverData.curHp == nil or self.serverData.maxHp == nil or self.serverData.maxHp == 0 then
      self.collectNum_txt:SetText("0/0")
      self.slider:SetValue(0)
      return
    end
    local maxHp = string.GetFormattedSeparatorNum(math.floor(self.serverData.maxHp))
    if self.serverData.maxHp and self.serverData.curHp and self.serverData.curHp < self.serverData.maxHp then
      local deltaTime = curTime / 1000 - self.serverData.lastHpTime
      if 0 < self.serverData.maxHp then
        if self.isRuins == true then
          self.collectNum_txt:SetText("0/" .. string.GetFormattedSeparatorNum(math.floor(self.serverData.maxHp)))
          self.slider:SetValue(0)
        else
          local realBlood = math.min(deltaTime * self.recoverSpeed + self.serverData.curHp, self.serverData.maxHp)
          local percent = math.min(realBlood / self.serverData.maxHp, 1)
          self.collectNum_txt:SetText(string.GetFormattedSeparatorNum(math.floor(realBlood)) .. "/" .. maxHp)
          self.slider:SetValue(percent)
        end
      else
        self.collectNum_txt:SetText("0/0")
        self.slider:SetValue(0)
      end
    else
      self.collectNum_txt:SetText(maxHp .. "/" .. maxHp)
      self.slider:SetValue(1)
    end
  end
  if self.isDetectCollect then
    if self.detectExpireTime == 0 then
      local serverData = DataCenter.WorldPointDetailManager:GetDetailByPointId(self.view.ctrl.pointId)
      if serverData then
        self.detectExpireTime = serverData.eventExpireTime
      end
    end
    local remainTime = self.detectExpireTime - curTime
    if remainTime < 0 then
      remainTime = 0
    end
    local timeStr = UITimeManager:GetInstance():MilliSecondToFmtString(remainTime)
    self.specialTimeTxt:SetText(timeStr)
  end
end

local function UpdateInfo(self, data, pointData)
  self.serverData = data
  self.playerData = nil
  if not self.data then
    self.data = pointData
  end
  if LuaEntry.Player.uid == self.view.ctrl.ownerUid then
    self.thumbsUpRoot:SetActive(false)
    self.map_sticker_send_content:SetActive(true)
    self.map_sticker_send_content:Refresh()
  else
    self.map_sticker_send_content:SetActive(false)
  end
  if self.view.ctrl.type == WorldPointUIType.City then
    if self.data and self.data.IsWerewolf then
      return
    end
    local playerData = self.serverData.playerData
    if playerData then
      self.playerData = playerData
      self.alliance_num:SetText(UIUtil.FormatAllianceAndName(playerData.alAbbr, playerData.allianceName))
      self.power_num:SetText(string.GetFormattedSeperatorNum(math.floor(playerData.power or 0)))
      self.kill_num:SetText(string.GetFormattedSeperatorNum(math.floor(playerData.armyKill or 0)))
      if self.seasonCallbackInfo and SeasonUtil.IsInSeason() then
        local callbackData = DataCenter.SeasonCallbackManager:GetFirstData(SeasonCallbackType.Base)
        local skinId = callbackData and callbackData:GetFirstCallbackId()
        local isUnlock = self.data and skinId == self.data.skinId or DataCenter.DecorationDataManager:IsOtherUnlock(skinId, playerData.disPlaySkinArr)
        self.seasonCallbackInfo:TrySetItemById(SeasonCallbackType.Base, isUnlock and skinId, true)
      end
      self.actValentineContent:SetActive(false)
      if self.data then
        if not self.data.IsNormalType then
          Logger.LogError(string.format("UIAsyncLoaderBridgeException.WorldPlayerDes.UpdateInfo  pointType=%s", self.data.pointType))
        elseif self.data:IsNormalType() then
          local ownerUid = self.data.ownerUid
          if ownerUid and ownerUid ~= LuaEntry.Player.uid then
            local targetActId = playerData.activityId
            if 0 < targetActId and playerData.srcServer and playerData.srcServer == LuaEntry.Player:GetSourceServerId() then
              self.actValentineContent:SetActive(true)
              self.actValentineContent:Refresh(WorldPointUIType.City, self.view.ctrl.uuid, ownerUid, targetActId)
            end
          end
        end
      end
      if self.dCompAssistance then
        if playerData.assistanceList then
          if 0 < #playerData.assistanceList then
            self.dCompAssistance:SetActive(true)
            self.dCompAssistance:Setup({
              isCity = false,
              pointId = self.view.ctrl.pointId,
              assistanceList = playerData.assistanceList,
              maxMember = playerData.maxAssistance,
              totalPower = playerData.assistanceTotalPower,
              memberCount = playerData.currAssistance,
              limit = 5
            })
          else
            self.dCompAssistance:SetActive(false)
          end
        else
          self.dCompAssistance:SetActive(false)
        end
      end
    else
      self.alliance_num:SetText("-")
      self.power_num:SetText("-")
      self.kill_num:SetText("-")
      if self.dCompAssistance then
        self.dCompAssistance:SetActive(false)
      end
    end
    if self.view.ctrl.type == WorldPointUIType.City and self.data and self.data.IsNormalType and not self.data:IsNormalType() then
      local detail = DataCenter.WorldPointDetailManager:GetDetailByPointId(self.view.ctrl.pointId)
      if detail then
        self.player_head_img:LoadSprite(string.format(LoadPath.UIPlayerIcon, detail.pic))
      end
    end
  elseif self.view.ctrl.type == WorldPointUIType.Build then
    local info = CS.SceneManager.World:GetPointInfoByUuid(self.view.ctrl.uuid)
    local buildId
    if info then
      cast(info, typeof(CS.BuildPointInfo))
      if info then
        buildId = info.itemId
        if 0 < info.destroyStartTime then
          self.isRuins = true
        end
      end
    end
    local name = Localization:GetString(self.serverData.name)
    if buildId then
      local buildTemplate = DataCenter.BuildTemplateManager:GetBuildingDesTemplate(buildId)
      if buildTemplate then
        local buildZoneName = BuildZoneName[buildTemplate.zoneType]
        if buildZoneName then
          name = name .. " (" .. Localization:GetString(buildZoneName) .. ")"
        end
      end
    end
    if self.isRuins then
      name = name .. " (" .. Localization:GetString("104202") .. ")"
    end
    self.name_txt:SetText(name)
    if self.serverData.maxHp and self.serverData.curHp and self.serverData.curHp < self.serverData.maxHp then
      self:AddTimer()
    end
    self:RefreshTime()
  elseif self.view.ctrl.type == WorldPointUIType.Road then
    self.name_txt:SetLocalText(self.serverData.name)
    if 0 < self.serverData.maxHp then
      self.collectNum_txt:SetText(string.GetFormattedSeperatorNum(math.floor(self.serverData.curHp)) .. "/" .. string.GetFormattedSeperatorNum(math.floor(self.serverData.maxHp)))
      local percent = math.min(self.serverData.curHp / self.serverData.maxHp, 1)
      self.slider:SetValue(percent)
    else
      self.collectNum_txt:SetText("0/0")
      self.slider:SetValue(0)
    end
  end
  self:RefreshTopBg()
end

local function GetName(self)
  local bType = self:BCollectArmy()
  if bType then
    return self.data and self.data.resourceName or ""
  else
    return self.serverData and self.serverData.name or ""
  end
end

local function OnClickHead(self)
  if self.data and self.data.IsWerewolf then
    UIUtil.ShowTipsId("season_s4_activity_1200011_desc7")
    return
  end
  if self.view.ctrl.ownerUid ~= nil and self.view.ctrl.ownerUid ~= "" then
    self.view.ctrl:CloseSelf()
    UIManager:GetInstance():OpenWindow(UIWindowNames.UILWPlayerDetail, {
      anim = true,
      UIMainAnim = UIMainAnimType.AllHide
    }, self.view.ctrl.ownerUid)
  end
end

function WorldPlayerDes:GetPlayerIconPos()
  return self.player_head_img
end

function WorldPlayerDes:GetFireworkBtnPos()
  return self.fireworkRoot
end

function WorldPlayerDes:Update1000MS()
  if self.data and self.temperature:GetActive() then
    local conductor = self.data.thermalConductor
    if conductor ~= nil then
      local curTemperature = conductor:GetCurTemperature()
      self.temperature_value:SetText(string.format("%.1f\194\176C", curTemperature))
      self.temperature_bg:SetColor(SeasonUtil.GetTemperatureColor(curTemperature))
    end
  end
  self:UpdateFireworkQueue()
end

function WorldPlayerDes:RefreshRewardFlag()
  local showRewardFlag, data = DataCenter.SeasonCallbackManager:IfShowThumbsInfo(self.view.ctrl.ownerUid, self.data.skinId)
  self.thumbsRewardFlag:SetActive(showRewardFlag)
  if showRewardFlag and data then
    self.thumbsRewardFlag:LoadSprite(data.icon)
  end
end

local function BCollectArmy(self)
  local bType = self.view.ctrl.type == WorldPointUIType.CollectArmy
  if self.view.ctrl.type == WorldPointUIType.EpidemicBuild and not string.IsNullOrEmpty(self.data and self.data.gatherUUID or nil) then
    bType = true
  end
  return bType
end

function WorldPlayerDes:PlayerHeadClickGuide(callback)
  if callback then
    callback(self:GetPlayerIconPos())
  end
end

function WorldPlayerDes:FireworkBtnClickGuide(callback)
  TimerManager:GetInstance():DelayInvoke(function()
    if callback and self.transform then
      callback(self:GetFireworkBtnPos())
    end
  end, 0.5)
end

function WorldPlayerDes:OnAssistanceDetailInfo(pointId)
  pointId = pointId and tonumber(pointId)
  if pointId and pointId == self.view.ctrl.pointId then
    self.view.ctrl:RequestWorldPointDetail()
  end
end

function WorldPlayerDes:OnThumbUpSuccess(message)
  if message and message.result and message.type == InteractiveUtil.ThumbsUpType.CityInfo then
    local showRewardFlag, data = DataCenter.SeasonCallbackManager:IfShowThumbsInfo(self.view.ctrl.ownerUid, self.data.skinId)
    if showRewardFlag then
      local thumbsUpInfoObj = LuaEntry.Player.thumbsUpInfoObj
      if not thumbsUpInfoObj then
        return
      end
      local cur = thumbsUpInfoObj.callBackRewardNum or 0
      local max = tonumber(LuaEntry.DataConfig:GetValue("callback_like_reward_daily_limit", "k1") or 10)
      if cur >= max then
        UIUtil.ShowTips(Localization:GetString("season_s4_callback_tips_2", cur, max))
      end
    end
  end
  UIManager.Instance:DestroyWindow(UIWindowNames.UIWorldPoint)
end

function WorldPlayerDes:OnBirthdayThumbUpSuccess(message)
end

function WorldPlayerDes:IsShowMusicFestival2025Content(data)
  local status = data.status
  if status == nil then
    return false
  end
  if BattleFieldUtil.InBattleField() then
    return false
  end
  for i = 1, status.Count do
    local v = status[i - 1]
    local id = v.Id
    local expireTime = v.ExpireTime
    local statueType2 = DataCenter.StatusManager:GetStatusType2(id)
    if statueType2 == StatusType2.MusicFestival2025_RewardBubble then
      local curTime = UITimeManager:GetInstance():GetServerTime()
      if expireTime < curTime then
        return false
      end
      local remainingNum = v.Layer
      if 0 < remainingNum then
        return true
      end
    end
  end
  return false
end

function WorldPlayerDes:TryShowBirthdayBtn(data)
  local btnPrefabPath = "Assets/Main/Prefabs/UI/LWPlayerInfo/PlayerDetailBtnPrefab/birthdayBtn.prefab"
  self.prefabBirthdayBtnReq = self:GameObjectInstantiateAsync(btnPrefabPath, function(request)
    if request.isError then
      return
    end
    local go = request.gameObject
    go.transform:SetParent(self.iconRoot.transform)
    go.transform:Set_localScale(0.6, 0.6, 0.6)
    go.transform:Set_localPosition(ResetPosition.x, ResetPosition.y, ResetPosition.z)
    local btnItem = self.iconRoot:AddComponent(BirthdayBtnItem, go)
    btnItem:SetData(data)
    btnItem:SetActive(true)
  end)
end

function WorldPlayerDes:DestroyBirthdayBtn()
  self.iconRoot:RemoveComponents(BirthdayBtnItem)
  if self.prefabBirthdayBtnReq then
    self:GameObjectDestroy(self.prefabBirthdayBtnReq)
    self.prefabBirthdayBtnReq = nil
  end
end

function WorldPlayerDes:RefreshTopBg()
  if not self.view then
    return
  end
  if BattleFieldUtil.InBattleField(BattleFieldType.DsbDuel) then
    local allianceId = (not self.playerData or not self.playerData.allianceId) and self.data and self.data.allianceId
    local color = BattlefieldDsbDuelUtils.GetColorByAllianceId(allianceId, true)
    local sp = color and color.spPlayerTopBg
    if not sp then
      self.view:SetTopBg()
    else
      self.view:SetTopBg(string.format(LoadPath.LWBattleFieldDsbDuelWorldPath, sp))
    end
  else
    self.view:SetTopBg()
  end
end

WorldPlayerDes.GetName = GetName
WorldPlayerDes.OnCreate = OnCreate
WorldPlayerDes.OnDestroy = OnDestroy
WorldPlayerDes.OnEnable = OnEnable
WorldPlayerDes.OnDisable = OnDisable
WorldPlayerDes.ComponentDefine = ComponentDefine
WorldPlayerDes.ComponentDestroy = ComponentDestroy
WorldPlayerDes.DataDefine = DataDefine
WorldPlayerDes.DataDestroy = DataDestroy
WorldPlayerDes.AddTimer = AddTimer
WorldPlayerDes.DeleteTimer = DeleteTimer
WorldPlayerDes.RefreshTime = RefreshTime
WorldPlayerDes.RefreshData = RefreshData
WorldPlayerDes.UpdateInfo = UpdateInfo
WorldPlayerDes.OnClickHead = OnClickHead
WorldPlayerDes.BCollectArmy = BCollectArmy
return WorldPlayerDes
