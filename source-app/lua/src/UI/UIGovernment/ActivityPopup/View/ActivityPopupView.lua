local ActivityPopupView = BaseClass("ActivityPopupView", UIBaseView)
local base = UIBaseView
local Localization = CS.GameEntry.Localization
local image_king_path = "ImageKing"
local btn_back2_path = "BtnBack2"
local btn_back_path = "BtnBack"
local btn_go_path = "ImageKing/bot/BtnGo"
local go_text_path = "ImageKing/bot/BtnGo/GoText"
local text_path = "ImageKing/bot/wave/Text"
local wave_path = "ImageKing/bot/wave"
local tipTxt_path = "ImageKing/bot/tip/tipTxt"
local tip_path = "ImageKing/bot/tip"
local king_path = "ImageKing/king"
local king_player_path = "ImageKing/king/player"
local king_gender_icon1_path = "ImageKing/king/NameText/GenderIcon1"
local king_gender_icon2_path = "ImageKing/king/NameText/GenderIcon2"
local king_name_text_path = "ImageKing/king/NameText"
local king_power_text_path = "ImageKing/king/PowerText"

function ActivityPopupView:OnCreate()
  base.OnCreate(self)
  local param = self:GetUserData()
  self.param = param
  self:ComponentDefine()
end

function ActivityPopupView:OnDestroy()
  local count = toInt(Setting:GetPrivateInt(TodayNoSecondConfirmType.KingActivity, 0))
  Setting:SetPrivateInt(TodayNoSecondConfirmType.KingActivity, count + 1)
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function ActivityPopupView:ComponentDefine()
  self.image_king = self:AddComponent(UIBaseContainer, image_king_path)
  self.text = self:AddComponent(UIText, text_path)
  self.waveRoot = self:AddComponent(UIRawImage, wave_path)
  self.go_text = self:AddComponent(UIText, go_text_path)
  self.btn_back = self:AddComponent(UIButton, btn_back_path)
  self.btn_go = self:AddComponent(UIButton, btn_go_path)
  self.btn_back2 = self:AddComponent(UIButton, btn_back2_path)
  self.btn_back:SetOnClick(BindCallback(self.ctrl, self.ctrl.CloseSelf))
  self.btn_back2:SetOnClick(BindCallback(self.ctrl, self.ctrl.CloseSelf))
  self.king_root = self:AddComponent(UIImage, king_path)
  self.text:SetLocalText("457042")
  self.go_text:SetLocalText("457043")
  self.tipTxt = self:AddComponent(UITextMeshProUGUIEx, tipTxt_path)
  self.tip = self:AddComponent(UIBaseComponent, tip_path)
  self.tip:SetActive(false)
  self.startTimestamp = nil
  local seasonId = SeasonUtil.GetSeason()
  local seasonType = SeasonUtil.GetSeasonType(false, false, ServerEnum.Source)
  local seasonSubdivisionType = SeasonUtil.GetSeasonType(false, true, ServerEnum.Source)
  if seasonType == SeasonMapType.Nothing and DataCenter.GovernmentManager:GetCurRound() > 1 then
    local now = UITimeManager:GetInstance():GetServerTime()
    local start = DataCenter.GovernmentManager.activityServerData.fightStartTime
    if now < start then
      self.startTimestamp = start
      self.tip:SetActive(true)
      self:Update1000MS()
    end
  end
  self.btn_back:SetActive(seasonType ~= SeasonMapType.NineNation)
  self.btn_back2:SetActive(seasonType == SeasonMapType.NineNation)
  if seasonType == SeasonMapType.Mummy then
    local effectPath = "Assets/Main/SeasonRes/S3/Prefabs/UI/LWSeason3/Component/Season3KingImage.prefab"
    self.season_bg_effect = UIAsyncNode.New("Season3KingImage", self.image_king.transform, effectPath, function(go)
      if IsNotNull(go) then
        local _t = go.transform
        _t:Set_localPosition(0, 187, 0)
        _t:SetAsFirstSibling()
      end
    end)
  elseif seasonType == SeasonMapType.Snow then
    local effectPath = "Assets/Main/Prefabs/UI/UIGovernment/Component/SeasonKingImage2.prefab"
    self.season_bg_effect = UIAsyncNode.New("Season2KingImage", self.image_king.transform, effectPath, function(go)
      if IsNotNull(go) then
        local _t = go.transform
        _t:Set_localPosition(0.5, 101, 0)
        _t:SetAsFirstSibling()
      end
    end)
  elseif seasonType == SeasonMapType.CityStronghold then
    local config = DataCenter.SeasonDataManager:GetPlayerCurrentSeasonConfig()
    if config and seasonId == 1 and config.season_icon == "Mjc_saiji2_zhujiemian_cion_new" then
      local effectPath = "Assets/Main/Prefabs/UI/UIGovernment/Component/SeasonKingImage1New.prefab"
      self.season_bg_effect = UIAsyncNode.New("Season1KingImage", self.image_king.transform, effectPath, function(go)
        if IsNotNull(go) then
          local _t = go.transform
          _t:Set_localPosition(1.5, 0, 0)
          _t:SetAsFirstSibling()
        end
      end)
    else
      local effectPath = "Assets/Main/Prefabs/UI/UIGovernment/Component/SeasonKingImage1.prefab"
      self.season_bg_effect = UIAsyncNode.New("Season1KingImage", self.image_king.transform, effectPath, function(go)
        if IsNotNull(go) then
          local _t = go.transform
          _t:Set_localPosition(0, -17, 0)
          _t:SetAsFirstSibling()
        end
      end)
    end
  elseif seasonType == SeasonMapType.Darkness then
    local effectPath = "Assets/Main/SeasonRes/S4/Prefabs/UI/Component/Season4KingImageNew.prefab"
    self.season_bg_effect = UIAsyncNode.New("Season4KingImage", self.image_king.transform, effectPath, function(go)
      if IsNotNull(go) then
        local _t = go.transform
        _t:Set_localPosition(0.5, 99, 0)
        _t:SetAsFirstSibling()
      end
    end)
    self.text:SetText("")
  elseif seasonType == SeasonMapType.NineNation then
    if seasonSubdivisionType == SeasonMapType.NineNationRainforest then
      local effectPath = "Assets/Main/SeasonRes/S6/Prefabs/UI/Component/Season6KingImageSource.prefab"
      self.season_bg_effect = UIAsyncNode.New("Season6KingSource", self.image_king.transform, effectPath, function(go)
        if IsNotNull(go) then
          local _t = go.transform
          _t:Set_localPosition(0.5, 55, 0)
          _t:SetAsFirstSibling()
        end
      end)
    else
      local effectPath = "Assets/Main/SeasonRes/S5/Prefabs/UI/Component/Season5KingImageSource.prefab"
      self.season_bg_effect = UIAsyncNode.New("Season5KingSource", self.image_king.transform, effectPath, function(go)
        if IsNotNull(go) then
          local _t = go.transform
          _t:Set_localPosition(0.5, 55, 0)
          _t:SetAsFirstSibling()
        end
      end)
    end
    self.text:SetText("")
    self.waveRoot:SetEnable(false)
  else
    local effectPath = "Assets/Main/Prefabs/UI/UIGovernment/Component/DefaultKingImage.prefab"
    self.season_bg_effect = UIAsyncNode.New("TheKingImage", self.image_king.transform, effectPath, function(go)
      if IsNotNull(go) then
        local _t = go.transform
        _t:Set_localPosition(0, 0, 0)
        _t:SetAsFirstSibling()
      end
    end)
  end
  if self.param == true then
    self.btn_go:SetOnClick(function()
      local sourceServerId = LuaEntry.Player:GetSourceServerId()
      local kingCityId, kingCityPosIndex = SeasonUtil.GetKingCityId(sourceServerId)
      local v3 = SceneUtils.TileIndexToWorld(kingCityPosIndex, ForceChangeScene.World)
      GoToUtil.CloseAllWindows()
      GoToUtil.GotoWorldPos(v3, CS.SceneManager.World.InitZoom, nil, nil, sourceServerId)
    end)
    local curPresident = DataCenter.GovernmentManager:GetCurPresident()
    if curPresident == nil then
      self.image_king:SetLocalPositionXYZ(0, 50, 0)
      self.king_root:SetActive(false)
      return
    end
    self.image_king:SetLocalPositionXYZ(0, -20, 0)
    self.king_root:SetActive(true)
    self.king_player = self:AddComponent(UICommonHead, king_player_path)
    self.king_gender_icon1 = self:AddComponent(UIImage, king_gender_icon1_path)
    self.king_gender_icon2 = self:AddComponent(UIImage, king_gender_icon2_path)
    self.king_name_text = self:AddComponent(UIText, king_name_text_path)
    self.king_power_text = self:AddComponent(UIText, king_power_text_path)
    local presidentName
    if string.IsNullOrEmpty(curPresident.allianceAbbr) then
      presidentName = Localization:GetString("science_condition", curPresident.level, curPresident.name)
    else
      presidentName = Localization:GetString("science_condition", curPresident.level, "[" .. curPresident.allianceAbbr .. "]" .. curPresident.name)
    end
    self.king_player:SetEnableClickShowInfo(true)
    self.king_name_text:SetText(presidentName)
    self.king_player:SetHead(curPresident.uid, curPresident.pic, curPresident.picVer, nil, curPresident:GetHeadBgImg())
    self.king_gender_icon1:SetActive(curPresident.gender == 1)
    self.king_gender_icon2:SetActive(curPresident.gender == 2)
    self.king_power_text:SetLocalText(100392, string.GetFormattedSeperatorNum(curPresident.power))
    CS.GameEntry.Setting:SetPrivateBool("OpenedKingOccupyPopup", true)
  else
    self.image_king:SetLocalPositionXYZ(0, 50, 0)
    self.king_root:SetActive(false)
    self.btn_go:SetOnClick(function()
      UIManager:GetInstance():DestroyWindow(UIWindowNames.UIGovernmentActivityPopup)
      UIUtil.ShowGovernmentActivityMain()
    end)
  end
end

function ActivityPopupView:ComponentDestroy()
  if self.season_bg_effect then
    self.season_bg_effect:Delete()
    self.season_bg_effect = nil
  end
  self.btn_back = nil
  self.btn_back2 = nil
end

function ActivityPopupView:Update1000MS()
  if self.startTimestamp then
    local delta = self.startTimestamp - UITimeManager:GetInstance():GetServerTime()
    if 0 < delta then
      local deltaStr = UITimeManager:GetInstance():MilliSecondToFmtStringWithoutDay(delta)
      self.tipTxt:SetLocalText("Thone_tips1001", deltaStr)
    else
      self.startTimestamp = nil
    end
  end
end

return ActivityPopupView
