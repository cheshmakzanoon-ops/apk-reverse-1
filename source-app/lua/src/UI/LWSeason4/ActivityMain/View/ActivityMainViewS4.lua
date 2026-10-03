local ActivityMainViewS4 = BaseClass("ActivityMainViewS4", UIBaseView)
local base = UIBaseView
local Localization = CS.GameEntry.Localization
local DetailItem = require("UI.UIGovernment.ActivityMain.Component.ActivityMainItem")
local title_path = "Root/Tips/BaseInfo/title"
local btn_go_path = "Root/Tips/Down/BtnGo"
local btn_rule_path = "Root/Tips/Down/BtnRule"
local btn_power_path = "Root/Tips/Down/BtnPower"
local btn_government_path = "Root/Tips/Down/BtnGovernment"
local btn_reward_path = "Root/Tips/Down/BtnReward"
local text_title_path = "Root/TopBar/TextTitle"
local btn_person_path = "Root/BottomBar/BtnPerson"
local btn_back_path = "Root/BottomBar/BtnBack"
local time_bg_path = "Root/Tips/BaseInfo/TimeBg"
local remain_time_path = "Root/Tips/BaseInfo/TimeBg/remainTime"
local info_btn_path = "Root/Tips/BaseInfo/InfoBtn"
local bg_path = "Root/Tips/season4"
local open_path = "Root/Tips/Open"
local effect_path = "Root/Tips/bg/effect"
local over_path = "Root/Tips/Over"
local red_point_path = "Root/BottomBar/BtnPerson/RedPoint"
local desc_btn_path = "Root/Tips/BaseInfo/DescBtn"
local desc_text_path = "Root/Tips/BaseInfo/DescBtn/DescIcon/DescText"

function ActivityMainViewS4:OnCreate()
  base.OnCreate(self)
  local param = self:GetUserData()
  self.param = param
  local actList = DataCenter.ActivityListDataManager:GetActivityDataByType(EnumActivity.KingActivity.Type)
  if actList and 0 < #actList then
    self.activityData = actList[1]
  else
    self.activityData = nil
  end
  local activityServerData = DataCenter.GovernmentManager.activityServerData
  self.activityServerData = activityServerData
  self:ComponentDefine()
  self:UpdateData()
  self:Update1000MS()
  DataCenter.GovernmentManager:GetKingInfo(LuaEntry.Player:GetSelfServerId())
end

function ActivityMainViewS4:OnDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function ActivityMainViewS4:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.KingdomActivityUpdate, self.UpdateData)
  self:AddUIListener(EventId.KingOccupyProgressRefresh, self.ShowKingOccupyProgress)
  self:AddUIListener(EventId.OnPassDay, self.OnPassDay)
end

function ActivityMainViewS4:OnRemoveListener()
  self:RemoveUIListener(EventId.KingdomActivityUpdate, self.UpdateData)
  self:RemoveUIListener(EventId.KingOccupyProgressRefresh, self.ShowKingOccupyProgress)
  self:RemoveUIListener(EventId.OnPassDay, self.OnPassDay)
  base.OnRemoveListener(self)
end

function ActivityMainViewS4:ComponentDefine()
  self.btn_back = self:AddComponent(UIButton, btn_back_path)
  self.btn_back:SetOnClick(BindCallback(self.ctrl, self.ctrl.CloseSelf))
  self.RootNotOpen = self:AddComponent(UIImage, bg_path)
  self.RootOpen = self:AddComponent(UIBaseContainer, open_path)
  self.dialog_title = self:AddComponent(UIText, text_title_path)
  self.title = self:AddComponent(UIText, title_path)
  self.remain_time = self:AddComponent(UIText, remain_time_path)
  self.info_btn = self:AddComponent(UIButton, info_btn_path)
  self.btn_go = self:AddComponent(UIButton, btn_go_path)
  self.btn_rule = self:AddComponent(UIButton, btn_rule_path)
  self.btn_power = self:AddComponent(UIButton, btn_power_path)
  self.btn_government = self:AddComponent(UIButton, btn_government_path)
  self.btn_reward = self:AddComponent(UIButton, btn_reward_path)
  self.btn_person = self:AddComponent(UIButton, btn_person_path)
  self.time_bg = self:AddComponent(UIImage, time_bg_path)
  self.RootOver = self:AddComponent(UIBaseContainer, over_path)
  self.desc_btn = self:AddComponent(UIButton, desc_btn_path)
  self.desc_text = self:AddComponent(UIText, desc_text_path)
  self.desc_btn:SetOnClick(function()
    self:OnDescBtnClick()
  end)
  self.desc_text:SetLocalText("gogncheng_liantu_tips1001")
  self.info_btn:SetOnClick(function()
    self:OnInfoBtnClick()
  end)
  self.btn_rule:SetOnClick(function()
    self:OnInfoBtnClick()
  end)
  self.btn_power:SetOnClick(function()
    UIUtil.ShowTipsId(457061)
  end)
  self.btn_government:SetOnClick(function()
    UIManager:GetInstance():OpenWindow(UIWindowNames.UIGovernmentOfficial)
  end)
  self.btn_reward:SetOnClick(function()
    UIManager:GetInstance():OpenWindow(UIWindowNames.UIGovernmentEncourage)
  end)
  self.btn_person:SetOnClick(function()
    UIManager:GetInstance():OpenWindow(UIWindowNames.UIGovernmentPersonalTarget)
  end)
  self.btn_go:SetOnClick(function()
    local v3 = SceneUtils.TileToWorld({x = 499, y = 497}, ForceChangeScene.World)
    GoToUtil.CloseAllWindows()
    GoToUtil.GotoWorldPos(v3, CS.SceneManager.World.InitZoom, nil, nil, LuaEntry.Player:GetSelfServerId())
  end)
  self.red_point = self:AddComponent(UIImage, red_point_path)
  self.red_point:SetActive(self:hasPersonalTargetFinish())
  self.dialog_title:SetLocalText("457042")
end

function ActivityMainViewS4:OnPassDay()
  if not DataCenter.ActivityListDataManager:CheckIfActivityOpen(EnumActivity.KingActivity.Type) then
    self.ctrl:CloseSelf()
  end
end

function ActivityMainViewS4:UpdateData()
  local activityServerData = DataCenter.GovernmentManager.activityServerData
  if activityServerData == nil or activityServerData.actFightStep == nil then
    self.RootNotOpen:SetActive(true)
    self.RootOver:SetActive(false)
    self.RootOpen:SetActive(false)
    return
  end
  self.activityServerData = activityServerData
  local actFightStep = self.activityServerData.actFightStep
  self.desc_btn:SetActive(false)
  self.RootNotOpen:SetActive(actFightStep == 0 or actFightStep == 2)
  self.RootOpen:SetActive(actFightStep == 1)
  self.RootOver:SetActive(actFightStep == 2)
  self.btn_go:SetActive(actFightStep ~= 2)
  self.time_bg:SetActive(actFightStep ~= 2)
  local strTitle
  if actFightStep == 0 then
    strTitle = Localization:GetString("457083")
  elseif actFightStep == 1 then
    strTitle = Localization:GetString("457044")
    self:initBattleInfo()
  elseif actFightStep == 2 then
    strTitle = Localization:GetString("457084")
    self:initOverInfo()
  end
  self.title:SetText(strTitle)
end

function ActivityMainViewS4:hasPersonalTargetFinish()
  local kingStageType = 100
  local data = DataCenter.ActivityStageTemplateManager:GetTemplate(kingStageType)
  if data == nil then
    return false
  end
  local taskList = data:GetQuests()
  for _, taskId in pairs(taskList) do
    local taskInfo = DataCenter.TaskManager:FindTaskInfo(taskId)
    if taskInfo then
      local taskState = taskInfo.state
      if taskState == TaskState.CanReceive then
        return true
      end
    end
  end
  return false
end

function ActivityMainViewS4:initBattleInfo()
  local left_icon_path = "Root/Tips/Open/left/left_icon"
  local left_name_path = "Root/Tips/Open/left/left_icon/left_name"
  local right_icon_path = "Root/Tips/Open/right/right_icon"
  local right_name_path = "Root/Tips/Open/right/right_icon/right_name"
  local leader_slider1_path = "Root/Tips/Open/status/leaderSlider1"
  local slider_text1_path = "Root/Tips/Open/status/sliderText1"
  local leader_slider2_path = "Root/Tips/Open/status/leaderSlider2"
  local slider_text2_path = "Root/Tips/Open/status/sliderText2"
  local left_btn_path = "Root/Tips/Open/left/left_btn"
  local right_btn_path = "Root/Tips/Open/right/right_btn"
  if self.left_icon == nil then
    self.left_icon = self:AddComponent(UIImage, left_icon_path)
    self.left_name = self:AddComponent(UIText, left_name_path)
    self.right_icon = self:AddComponent(UIImage, right_icon_path)
    self.right_name = self:AddComponent(UIText, right_name_path)
    self.leader_slider1 = self:AddComponent(UISlider, leader_slider1_path)
    self.slider_text1 = self:AddComponent(UIText, slider_text1_path)
    self.leader_slider2 = self:AddComponent(UISlider, leader_slider2_path)
    self.slider_text2 = self:AddComponent(UIText, slider_text2_path)
    self.left_btn = self:AddComponent(UIButton, left_btn_path)
    self.right_btn = self:AddComponent(UIButton, right_btn_path)
  end
  self:ShowKingOccupyProgress()
  self:Update1000MS()
end

function ActivityMainViewS4:ShowKingOccupyProgress()
  if self.left_icon == nil or self.left_name == nil then
    return
  end
  local loginServerId = LuaEntry.Player:GetSelfServerId()
  local fightInfo = DataCenter.GovernmentManager:GetKingOccupyList(loginServerId)
  if fightInfo == nil then
    self.left_icon:SetActive(false)
    self.leader_slider1:SetValue(0)
    self.slider_text1:SetText("0%")
    self.left_name:SetText("")
    self.right_icon:SetActive(false)
    self.leader_slider2:SetValue(0)
    self.slider_text2:SetText("0%")
    self.right_name:SetText("")
  else
    local maxPoint = SeasonUtil.GetPresidentOccupationRate("k2", 28800)
    local addSpeed = SeasonUtil.GetPresidentOccupationRate("k1", 1)
    local player1 = fightInfo[1]
    local player2 = fightInfo[2]
    if player1 ~= nil then
      if player1.abbr == nil or player1.abbr == "" then
        self.left_name:SetText(player1.name)
      else
        self.left_name:SetText("[" .. player1.abbr .. "] " .. player1.name)
      end
      if player1.icon ~= nil and player1.icon ~= "" then
        self.left_icon:SetActive(true)
        self.left_icon:LoadSprite(string.format(AL_FLAG_SPRITE_PATH, tostring(player1.icon)))
      end
      self.leader_slider1:SetValue(player1.point / maxPoint)
      self.slider_text1:SetText(string.format("%.2f", player1.point * 100 / maxPoint) .. "%")
      self.player1 = player1
      local allianceId = player1.aId
      self.left_btn:SetOnClick(function()
        self:OnAllianceDetailClick(allianceId)
      end)
    else
      self.left_icon:SetActive(false)
      self.leader_slider1:SetValue(0)
      self.slider_text1:SetText("0%")
      self.left_name:SetText("")
    end
    if player2 ~= nil then
      if player2.abbr == nil or player2.abbr == "" then
        self.right_name:SetText(player2.name)
      else
        self.right_name:SetText("[" .. player2.abbr .. "] " .. player2.name)
      end
      if player2.icon ~= nil and player2.icon ~= "" then
        self.right_icon:SetActive(true)
        self.right_icon:LoadSprite(string.format(AL_FLAG_SPRITE_PATH, tostring(player2.icon)))
      end
      self.leader_slider2:SetValue(player2.point / maxPoint)
      self.slider_text2:SetText(string.format("%.2f", player2.point * 100 / maxPoint) .. "%")
      self.player2 = player2
      local allianceId = player2.aId
      self.right_btn:SetOnClick(function()
        self:OnAllianceDetailClick(allianceId)
      end)
    else
      self.right_icon:SetActive(false)
      self.leader_slider2:SetValue(0)
      self.slider_text2:SetText("0%")
      self.right_name:SetText("")
    end
    self.king_occupy_point_max = maxPoint
    self.king_occupy_point_speed = addSpeed
  end
end

function ActivityMainViewS4:initOverInfo()
  local no_king_path = "Root/Tips/Over/no_king"
  local king_path = "Root/Tips/Over/king"
  local player_path = "Root/Tips/Over/king/player"
  local gender_icon1_path = "Root/Tips/Over/king/GenderIcon1"
  local gender_icon2_path = "Root/Tips/Over/king/GenderIcon2"
  local name_text_path = "Root/Tips/Over/king/NameText"
  local power_text_path = "Root/Tips/Over/king/PowerText"
  local country_path = "Root/Tips/Over/king/country"
  local btn2_path = "Root/Tips/Over/king/btn2"
  if self.no_king == nil then
    self.no_king = self:AddComponent(UIImage, no_king_path)
    self.king = self:AddComponent(UIImage, king_path)
    self.king_player = self:AddComponent(UICommonHead, player_path)
    self.king_gender_icon1 = self:AddComponent(UIImage, gender_icon1_path)
    self.king_gender_icon2 = self:AddComponent(UIImage, gender_icon2_path)
    self.king_name_text = self:AddComponent(UIText, name_text_path)
    self.king_power_text = self:AddComponent(UIText, power_text_path)
    self.king_country = self:AddComponent(UIImage, country_path)
    self.king_btn2 = self:AddComponent(UIButton, btn2_path)
    self.king_btn2:SetOnClick(function()
      UIManager:GetInstance():OpenWindow(UIWindowNames.UIGovernmentPresidentBuff, {anim = true}, 0)
    end)
  end
  self.king_player:SetEnableClickShowInfo(true)
  local curPresident = DataCenter.GovernmentManager:GetCurPresident()
  if curPresident == nil then
    if LuaEntry.Player:IsPresident() then
      local player = LuaEntry.Player
      self.king_player:SetHead(player.uid, player.pic, player.picVer, nil, player:GetHeadBgImg())
      self.king_name_text:SetLocalText("science_condition", player.level, LuaEntry.Player:GetFullName())
      self.king_power_text:SetLocalText(100392, string.GetFormattedSeperatorNum(player.power))
      local template = DataCenter.NationTemplateManager:GetNationTemplate(player.country)
      if template then
        self.king_country:LoadSprite(template:GetNationFlagPath())
      end
      curPresident = player
    end
  else
    local presidentName
    if string.IsNullOrEmpty(curPresident.allianceAbbr) then
      presidentName = Localization:GetString("science_condition", curPresident.level, curPresident.name)
    else
      presidentName = Localization:GetString("science_condition", curPresident.level, "[" .. curPresident.allianceAbbr .. "]" .. curPresident.name)
    end
    self.king_name_text:SetText(presidentName)
    self.king_player:SetHead(curPresident.uid, curPresident.pic, curPresident.picVer, nil, curPresident:GetHeadBgImg())
    self.king_power_text:SetLocalText(100392, string.GetFormattedSeperatorNum(curPresident.power))
    local template = DataCenter.NationTemplateManager:GetNationTemplate(curPresident.country)
    if template then
      self.king_country:LoadSprite(template:GetNationFlagPath())
    end
  end
  self.no_king:SetActive(curPresident == nil)
  self.king:SetActive(curPresident ~= nil)
end

function ActivityMainViewS4:ComponentDestroy()
  self.btn_back = nil
  self.desc_btn = nil
  self.desc_text = nil
end

function ActivityMainViewS4:SetOnTop()
end

function ActivityMainViewS4:Update1000MS()
  if self.activityData ~= nil then
    local curTime = UITimeManager:GetInstance():GetServerTime()
    local endTime = self.activityData.endTime
    if self.activityServerData.actFightStep == 0 and self.activityServerData.fightStartTime ~= nil then
      endTime = self.activityServerData.fightStartTime
    elseif self.activityServerData.actFightStep == 1 and self.activityServerData.fightEndTime ~= nil then
      endTime = self.activityServerData.fightEndTime
      if self.player1 ~= nil and self.player1.startTime ~= nil then
        local point = (curTime - self.player1.startTime) * 0.001 * self.king_occupy_point_speed + self.player1.point
        if point < self.king_occupy_point_max then
          self.leader_slider1:SetValue(point / self.king_occupy_point_max)
          self.slider_text1:SetText(string.format("%.2f", point * 100 / self.king_occupy_point_max) .. "%")
        else
          self.leader_slider1:SetValue(1)
          self.slider_text1:SetText("100%")
        end
      end
      if self.player2 ~= nil and self.player2.startTime ~= nil then
        local point = (curTime - self.player2.startTime) * 0.001 * self.king_occupy_point_speed + self.player2.point
        if point < self.king_occupy_point_max then
          self.leader_slider2:SetValue(point / self.king_occupy_point_max)
          self.slider_text2:SetText(string.format("%.2f", point * 100 / self.king_occupy_point_max) .. "%")
        else
          self.leader_slider2:SetValue(1)
          self.slider_text2:SetText("100%")
        end
      end
    elseif self.activityServerData.actFightStep == 2 then
      endTime = self.activityData.endTime
    end
    local remainTime = endTime - curTime
    if 0 < remainTime then
      self.remain_time:SetText(UITimeManager:GetInstance():MilliSecondToFmtString(remainTime))
    else
      self.remain_time:SetText("00:00:00")
    end
  end
end

function ActivityMainViewS4:OnDescBtnClick()
  UIManager:GetInstance():OpenWindow(UIWindowNames.UILWWorldTip, {anim = false}, 2)
end

function ActivityMainViewS4:OnInfoBtnClick()
  if self.activityData ~= nil and self.activityData.story ~= nil then
    local param = {}
    param.activityId = self.activityId
    param.activityRulesStr = Localization:GetString(self.activityData.story)
    UIManager:GetInstance():OpenWindow(UIWindowNames.UIActivityDetailPopup, {anim = true}, param)
  end
end

function ActivityMainViewS4:OnAllianceDetailClick(allianceId)
  UIUtil.TryShowAllianceInfo(nil, allianceId, nil)
end

return ActivityMainViewS4
