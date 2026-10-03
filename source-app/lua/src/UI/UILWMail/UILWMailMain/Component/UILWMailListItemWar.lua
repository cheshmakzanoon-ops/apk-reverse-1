local UILWMailListItemWar = BaseClass("UILWMailListItemWar", UIBaseContainer)
local base = UIBaseContainer
local UIGray = CS.UIGray
local Localization = CS.GameEntry.Localization
local read_img_path = "BgRead"
local name_txt_path = "TitleTxt"
local des_txt_path = "SubTitleTxt"
local time_txt_path = "TimeText"
local gift_img_path = "Gift"
local red_point_path = "RedPoint"
local btn_path = "ClickButton"
local loading_txt_path = "LoadingTxt"

function UILWMailListItemWar:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function UILWMailListItemWar:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UILWMailListItemWar:ComponentDefine()
  self.readBg = self:AddComponent(UIBaseContainer, read_img_path)
  self.targetIcon = self:AddComponent(UIImage, "targetIcon")
  self.winIcon = self:AddComponent(UIImage, "winIcon")
  self.bg = self:AddComponent(UIImage, "Bg")
  self.nameText = self:AddComponent(UIText, name_txt_path)
  self.desText = self:AddComponent(UIText, des_txt_path)
  self.timeText = self:AddComponent(UIText, time_txt_path)
  self.giftIcon = self:AddComponent(UIBaseContainer, gift_img_path)
  self.redPoint = self:AddComponent(UIBaseContainer, red_point_path)
  self.reportLoading = self:AddComponent(UIText, loading_txt_path)
  self.clickBtn = self:AddComponent(UIButton, btn_path)
  self.clickBtn:SetOnClick(function()
    self:OnMailClick()
  end)
end

function UILWMailListItemWar:ComponentDestroy()
  self.readBg = nil
  self.targetIcon = nil
  self.winIcon = nil
  self.nameText = nil
  self.desText = nil
  self.timeText = nil
  self.giftIcon = nil
  self.redPoint = nil
  self.clickBtn = nil
end

function UILWMailListItemWar:DataDefine()
  self.mailData = {}
  self.mailUid = nil
  self.loadingTimer = nil
end

function UILWMailListItemWar:DataDestroy()
  self.mailData = nil
  self.mailUid = nil
  self:ClearTimer()
end

function UILWMailListItemWar:OnEnable()
  base.OnEnable(self)
end

function UILWMailListItemWar:OnDisable()
  base.OnDisable(self)
end

function UILWMailListItemWar:OnAddListener()
  base.OnAddListener(self)
end

function UILWMailListItemWar:OnRemoveListener()
  base.OnRemoveListener(self)
end

function UILWMailListItemWar:SetData(params)
  self.params = params
  self.mailData = params.mail_data
  if not self.mailData then
    return
  end
  self.mailUid = self.mailData.uid
  if not self.mailUid then
    return
  end
  self:SetLoadingState()
  self:RefreshText()
  self:RefreshIcon()
  self:RefreshRedPoint()
  self:RefreshTimer()
  if self.mailData:IsBattleReportMailType() and not self.mailData:IsBattleReportIntegrity() then
    self.mailData:OnMailIntegrityExecute(function(mailInfo)
      if self.view and self.mailData.uid == mailInfo.uid then
        self:SetData(params)
      end
    end)
  end
end

function UILWMailListItemWar:OnLoading()
end

function UILWMailListItemWar:GetLoadingState()
  if self.mailData and self.mailData:IsBattleReportMailType() and not self.mailData:IsBattleReportIntegrity() then
    return true
  end
  return false
end

function UILWMailListItemWar:RefreshTimer()
  self:ClearTimer()
  if self:GetLoadingState() then
    self.loadingTimer = TimerManager:GetInstance():GetTimer(1, self.OnLoading, self, false, false, false)
    self.loadingTimer:Start()
  end
end

function UILWMailListItemWar:ClearTimer()
  if self.loadingTimer ~= nil then
    self.loadingTimer:Stop()
    self.loadingTimer = nil
  end
end

function UILWMailListItemWar:SetLoadingState()
  local state = self:GetLoadingState()
  self.reportLoading:SetActive(state)
  self.nameText:SetActive(not state)
  self.desText:SetActive(not state)
  self.timeText:SetActive(not state)
  self.targetIcon:SetActive(not state)
  self.winIcon:SetActive(not state)
end

function UILWMailListItemWar:RefreshRedPoint()
  local un_read = self.mailData.status ~= 1
  local has_reward = self.mailData.rewardStatus == 0
  self.readBg:SetActive(not un_read)
  self.giftIcon:SetActive(has_reward)
  if has_reward then
    self.redPoint:SetActive(false)
  else
    self.redPoint:SetActive(un_read)
  end
  local ext = self.mailData:GetMailExt()
  if self.mailData.status == 0 and ext and ext.IsMyProtectCity and ext:IsMyProtectCity() then
    self.view:NeedAskForPushPermission("ASK_FOR_PUSH_by_BE_ATTACKED")
  end
end

function UILWMailListItemWar:RefreshIcon()
  local win_icon_path
  local target_icon_path = "Assets/Main/Sprites/UI/UILWMail/zyf_jijieyoujian_zhencha.png"
  local isPassive = false
  local mailType = self.mailData.type
  if IsMailScoutType(mailType) or mailType == MailType.LW_SEASON_SCOUT_MAIL then
  elseif MailShowHelper.IsSeasonBattleMail(mailType) then
    local data = self.mailData:GetMailExt()
    if data.isDefend then
      isPassive = true
    end
    if data.selfWin then
      win_icon_path = "Assets/Main/Sprites/UI/UILWMail/zyf_youjian_victory.png"
    else
      win_icon_path = "Assets/Main/Sprites/UI/UILWMail/zyf_youjian_defeat.png"
    end
    local player = data.player
    if player and 1 < #player then
      local thePlayer = player[2]
      if thePlayer.armyType == MailTargetType.SeasonDesert then
        target_icon_path = thePlayer.pic
      elseif thePlayer.armyType == MailTargetType.SeasonBuilding then
        target_icon_path = thePlayer.pic
      elseif thePlayer.armyType == MailTargetType.SeasonCenter then
        target_icon_path = thePlayer.pic
      elseif thePlayer.armyType == MailTargetType.Army then
        target_icon_path = "Assets/Main/Sprites/UI/UILWMail/lyp_jijieyoujian_xiaoguai.png"
      end
    end
  elseif IsMailBeScoutType(mailType) then
    isPassive = true
  elseif mailType == MailType.HOSPITAL_FULL then
    isPassive = true
    target_icon_path = "Assets/Main/Sprites/UI/UILWMail/zyf_youjian_yiyuan_icon.png"
  elseif IsMailNewFightType(mailType) then
    local data = self.mailData:GetMailExt()
    if data.isDefend then
      isPassive = true
    end
    if data.selfWin then
      win_icon_path = "Assets/Main/Sprites/UI/UILWMail/zyf_youjian_victory.png"
    else
      win_icon_path = "Assets/Main/Sprites/UI/UILWMail/zyf_youjian_defeat.png"
    end
    if data.allianceCityInfo then
      target_icon_path = "Assets/Main/Sprites/UI/UILWMail/lyp_jijieyoujian_chengshi.png"
    elseif data.battleType and data.battleType == MailBattleReportType.CROSS_ARENA then
      target_icon_path = "Assets/Main/Sprites/UI/UILWMail/lrb_zhanbao_jingjichang.png"
    else
      target_icon_path = "Assets/Main/Sprites/UI/UILWMail/lyp_jijieyoujian_wanjiacheng.png"
    end
  elseif self.mailData.type == MailType.FIGHT_MONSTER or self.mailData.type == MailType.RUNNING_BOSS_ATTACK_CITY or self.mailData.type == MailType.RUNNING_MUMMY_ATTACK_CITY or self.mailData.type == MailType.LW_ZOMBIE_RUSH_BOSS_ATTACK_CITY or self.mailData.type == MailType.ALLIANCE_BOSS_SAND_ATTACK_CITY or self.mailData.type == MailType.BLOOD_QUEEN_MONSTER_ATTACK_CITY then
    local data = self.mailData:GetMailExt()
    if data.selfWin then
      win_icon_path = "Assets/Main/Sprites/UI/UILWMail/zyf_youjian_victory.png"
    else
      win_icon_path = "Assets/Main/Sprites/UI/UILWMail/zyf_youjian_defeat.png"
    end
    if data.isMuster then
      target_icon_path = "Assets/Main/Sprites/UI/UILWMail/lyp_jijieyoujian_boss.png"
    else
      target_icon_path = "Assets/Main/Sprites/UI/UILWMail/lyp_jijieyoujian_xiaoguai.png"
    end
    if data.battleType then
      if data.battleType == MailBattleReportType.ActBoss or data.battleType == MailBattleReportType.ACT_BERSERK_BOSS or data.battleType == MailBattleReportType.CITY_BATTLE_S1_REST_ATTACK_MONSTER then
        win_icon_path = "Assets/Main/Sprites/UI/UILWMail/zyf_youjian_victory.png"
        target_icon_path = "Assets/Main/Sprites/UI/UILWMail/zyf_shijieboss_boss_red.png"
      elseif data.battleType == MailBattleReportType.ALLIANCE_BOSS or data.battleType == MailBattleReportType.ALLIANCE_BOSS_S0 then
        win_icon_path = "Assets/Main/Sprites/UI/UILWMail/zyf_youjian_victory.png"
        target_icon_path = "Assets/Main/Sprites/UI/UILWMail/zyf_sangshitiaozhan_youjianicon.png"
      elseif data.battleType == MailBattleReportType.ALLIANCE_MONSTER_CHALLENGE_KIROV then
        win_icon_path = "Assets/Main/Sprites/UI/UILWMail/zyf_youjian_victory.png"
        target_icon_path = "Assets/Main/Sprites/UI/UILWMail/lyp_jijieyoujian_boss.png"
      end
    end
  elseif self.mailData.type == MailType.LW_SEASON_REWARD_MAIL then
    local un_read = self.mailData.status ~= 1
    if un_read then
      target_icon_path = "Assets/Main/Sprites/UI/UILWMail/lt_youjian_xin_guan.png"
    else
      target_icon_path = "Assets/Main/Sprites/UI/UILWMail/lt_youjian_xin_kai.png"
    end
    win_icon_path = nil
  elseif self.mailData.type == MailType.HUNTER_ACTIVITY_LIFE_REWARD then
    local un_read = self.mailData.status ~= 1
    if un_read then
      target_icon_path = "Assets/Main/Sprites/UI/UILWMail/lt_youjian_xin_guan.png"
    else
      target_icon_path = "Assets/Main/Sprites/UI/UILWMail/lt_youjian_xin_kai.png"
    end
    win_icon_path = nil
  elseif self.mailData.type == MailType.HUNTER_ACTIVITY_RANK_REWARD then
    local un_read = self.mailData.status ~= 1
    if un_read then
      target_icon_path = "Assets/Main/Sprites/UI/UILWMail/lt_youjian_xin_guan.png"
    else
      target_icon_path = "Assets/Main/Sprites/UI/UILWMail/lt_youjian_xin_kai.png"
    end
    win_icon_path = nil
  elseif mailType == MailType.LANDMINE then
    local data = self.mailData:GetMailExt()
    local meta = DataCenter.WorldTriggerTemplateManager:GetMeta(data.cfgId)
    target_icon_path = meta.grayIcon
    win_icon_path = not data:IsPassive() and "Assets/Main/Sprites/UI/UILWMail/zyf_youjian_victory.png"
  elseif mailType == MailType.DISGUISE_ATTACK then
    target_icon_path = "Assets/Main/Sprites/UI/UIMastery/mjc_S3_weizhuangxingjun.png"
  elseif self.mailData.type == MailType.LW_SEASON_BREAK_ICE_MAIL then
    local data = self.mailData:GetMailExt()
    isPassive = data:IsEnemy()
    target_icon_path = "Assets/Main/Sprites/UI/UILWMail/lt_youjian_tubiao05.png"
  elseif self.mailData.type == MailType.LW_SEASON_WEATHER_MAIL then
    local data = self.mailData:GetMailExt()
    local icon = data and data:GetWeatherIcon()
    if not string.IsNullOrEmpty(icon) then
      target_icon_path = icon
    end
  elseif self.mailData.type == MailType.ATTACK_RUIN_BUILDING then
    target_icon_path = "Assets/Main/Sprites/UI/UILWMail/mjc_youjian_chaichufeixu.png"
  elseif self.mailData.type == MailType.LW_METEORITE_KNOCKOUT_SMALL then
    target_icon_path = "Assets/Main/Sprites/UI/UILWMail/mjc_youjian_yunshi.png"
    win_icon_path = nil
  elseif self.mailData.type == MailType.SEASON_BANK then
    target_icon_path = "Assets/Main/SeasonRes/S5/Textures/Bank/zxl_zhanbao_cunqian.png"
    win_icon_path = nil
  elseif self.mailData.type == MailType.ROB_BANK_MAIL then
    target_icon_path = "Assets/Main/SeasonRes/S5/Sprites/Bank/zxl_zhanbao_baoxianxiang.png"
    win_icon_path = nil
  end
  if self.mailData:HasMummyJoin() then
    target_icon_path = "Assets/Main/SeasonRes/Shared/Sprites/LWCommon/ljq_zhanbao_munaiyi.png"
  end
  local bg_path = "Assets/Main/Sprites/UI/UILWMail/"
  self.bg:LoadSprite(bg_path .. (isPassive and "zyf_youjian_tiao_1.png" or "zyf_youjian_tiao_2.png"))
  if target_icon_path then
    self.targetIcon:LoadSpriteAuto(target_icon_path)
  else
    self.targetIcon:SetActive(false)
  end
  if win_icon_path then
    self.winIcon:SetActive(true)
    self.winIcon:LoadSprite(win_icon_path)
    self.winIcon:SetNativeSize()
  else
    self.winIcon:SetActive(false)
  end
end

function UILWMailListItemWar:RefreshText()
  local mainTitle = MailShowHelper.GetMainTitle(self.mailData)
  mainTitle = MailShowHelper.GetTextWithHighlight(mainTitle, self.params.filter or "")
  self.nameText:SetText(mainTitle)
  local subTitle = MailShowHelper.GetMailSubTitle(self.mailData)
  subTitle = MailShowHelper.GetTextWithHighlight(subTitle, self.params.filter or "")
  self.desText:SetText(subTitle)
  local createTime = MailShowHelper.GetRelativeCreateTime(self.mailData)
  self.timeText:SetText(createTime)
end

function UILWMailListItemWar:OnMailClick()
  if self:GetLoadingState() then
    self.mailData:DownloadBattleReport(true)
    return
  end
  DataCenter.MailDataManager:ClearShareList()
  self.view.ctrl:SetCurrentView(3)
  self.view.ctrl:SetCurrentMail(self.mailUid)
  self.view.ctrl:ReadCurrentMail()
  self.view:ContentTrans()
end

return UILWMailListItemWar
