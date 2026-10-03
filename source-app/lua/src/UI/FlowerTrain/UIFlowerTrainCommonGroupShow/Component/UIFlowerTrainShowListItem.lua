local UIFlowerTrainShowListItem = BaseClass("UIFlowerTrainShowListItem", UIBaseContainer)
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization
local BaseSingleFlowerTrainData = require("DataCenter.FlowerTrain.Data.BaseSingleFlowerTrainData")
local GOTO_FLOWER_TRAIN_CONFIRM = "GOTO_FLOWER_TRAIN_CONFIRM"
local womenIconPath = "Assets/Main/Sprites/UI/UILWAlliance/cfm_lianmeng_tubiao_nv.png"
local manIconPath = "Assets/Main/Sprites/UI/UILWAlliance/cfm_lianmeng_tubiao_nan.png"
local bg_path = "Bg"
local player_head_path = "HeadContent/PlayerHead"
local player_level_text_path = "HorLayout/PlayerLevelText"
local player_gender_icon_path = "HorLayout/PlayerGenderIcon"
local player_name_text_path = "HorLayout/PlayerNameText"
local time_txt_path = "HeadContent/timeContent/timeTxt"
local tips_text_path = "TipsText"
local have_get_txt_path = "haveGetTxt"
local go_btn_path = "GoBtn"
local get_btn_path = "GetBtn"
local like_btn_path = "LikeBtn"
local reward_icon_path = "HeadContent/rewardIcon"
local like_icon_path = "LikeBtn/likeIcon"
local heat_icon_path = "HeatIcon"
local heat_txt_path = "HeatIcon/HeatTxt"

function UIFlowerTrainShowListItem:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:AddUIListener(EventId.GetNewUserInfoSucc, self.RefreshUserInfo)
end

function UIFlowerTrainShowListItem:OnDestroy()
  self:RemoveUIListener(EventId.GetNewUserInfoSucc, self.RefreshUserInfo)
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UIFlowerTrainShowListItem:ComponentDefine()
  self.bg = self:AddComponent(UIImage, bg_path)
  self.player_head = self:AddComponent(UICommonHead, player_head_path)
  self.player_level_text = self:AddComponent(UITextMeshProUGUIEx, player_level_text_path)
  self.player_gender_icon = self:AddComponent(UIImage, player_gender_icon_path)
  self.player_name_text = self:AddComponent(UITextMeshProUGUIEx, player_name_text_path)
  self.player_head:SetEnableClickShowInfo(true, true)
  self.time_txt = self:AddComponent(UITextMeshProUGUIEx, time_txt_path)
  self.tips_text = self:AddComponent(UITextMeshProUGUIEx, tips_text_path)
  self.have_get_txt = self:AddComponent(UITextMeshProUGUIEx, have_get_txt_path)
  self.go_btn = self:AddComponent(UIButton, go_btn_path)
  self.get_btn = self:AddComponent(UIButton, get_btn_path)
  self.like_btn = self:AddComponent(UIButton, like_btn_path)
  self.heat_icon = self:AddComponent(UIImage, heat_icon_path)
  self.heat_txt = self:AddComponent(UITextMeshProUGUIEx, heat_txt_path)
  self.reward_icon = self:AddComponent(UIImage, reward_icon_path)
  self.go_btn:SetOnClick(function()
    self:OnGoBtnClick()
  end)
  self.get_btn:SetOnClick(function()
    self:OnGetBtnClick()
  end)
  self.like_btn:SetOnClick(function()
    self:OnLikeBtnClick()
  end)
  self.like_icon = self:AddComponent(UIRawImage, like_icon_path)
end

function UIFlowerTrainShowListItem:ComponentDestroy()
  self.bg = nil
  self.player_head = nil
  self.player_level_text = nil
  self.player_gender_icon = nil
  self.player_name_text = nil
  self.reward_icon = nil
  self.like_icon = nil
  self.heat_icon = nil
  self.heat_txt = nil
  self.get_btn = nil
end

function UIFlowerTrainShowListItem:ReInit(data, activityId, actBanquetId)
  self.infoData = data
  self.activityId = activityId
  self.actBanquetId = actBanquetId
  self.trainData = BaseSingleFlowerTrainData.New()
  self.trainData:UpdateData(data)
  self.data = data
  self:RefreshUserInfo(data.uid)
  local curTime = UITimeManager:GetInstance():GetServerTime()
  local isShowGet = data.uid == LuaEntry.Player.uid and curTime > data.arriveTime
  self.get_btn:SetActive(isShowGet)
  self.go_btn:SetActive(not isShowGet)
  local path = self.trainData:GetExpFireImgPath()
  self.heat_icon:LoadSpriteAsync(path)
  local curTotalExp = self.trainData:GetCurTotalExp()
  self.heat_txt:SetText(curTotalExp)
  self.have_get_txt:SetText("")
  self.like_btn:SetActive(data.uid ~= LuaEntry.Player.uid)
  local treasure_para = ""
  local actBanquet = DataCenter.ActivityPartyNewTemplateManager:GetActBanquetTemplate(self.actBanquetId)
  if actBanquet ~= nil then
    treasure_para = actBanquet.treasure_para
  end
  local paraTemp = string.split(treasure_para, "|")
  if paraTemp and paraTemp[4] then
    local path = string.format(UIAssets.UIActMonopolyTexturePath, paraTemp[4])
    self.like_icon:LoadSprite(path)
    self.like_icon:SetNativeSize()
  end
  if paraTemp and paraTemp[7] then
    local path = string.format(UIAssets.UIActDetectTreasureSpritePath, paraTemp[7])
    if self.data.uid == LuaEntry.Player.uid then
      self.bg:SetColorRGBA(0.79, 0.93, 0.6, 1)
      self.bg:LoadSprite("Assets/Main/Sprites/UI/LWCommon/Sprite/cfm_tongyong_erji_dichen_yuanjiao_4.png")
    else
      self.bg:SetColorRGBA(1, 1, 1, 1)
      self.bg:LoadSprite(path)
    end
  end
  self:SetRewardIcon()
  self:UpdateTimeView()
end

function UIFlowerTrainShowListItem:RefreshUserInfo(uid)
  if self.data == nil then
    return
  end
  if uid ~= self.data.uid then
    return
  end
  local user = UIUtil.GetPlayerInfoShowByUid(uid)
  if user == nil then
    return
  end
  local showName = DataCenter.PlayerInfoDataManager:GetRemarkOrRealName(user.uid, user.name)
  user.frameBg = user.headBg
  self.player_head:ParseHeadInfo(user)
  self.player_head:SetEnableClickShowInfo(true, true)
  self.player_name_text:SetText(UIUtil.FormatAllianceAndName(user.abbr, showName))
  local lvNum = 0
  if user.level then
    lvNum = user.level
  end
  self.player_level_text:SetLocalText(GameDialogDefine.LEVEL_NUMBER, lvNum)
  if user.gender == 1 then
    self.player_gender_icon:SetActive(true)
    self.player_gender_icon:LoadSprite(manIconPath)
  elseif user.gender == 2 then
    self.player_gender_icon:SetActive(true)
    self.player_gender_icon:LoadSprite(womenIconPath)
  else
    self.player_gender_icon:SetActive(false)
  end
end

function UIFlowerTrainShowListItem:OnGoBtnClick()
  local isInBattleField = BattleFieldUtil.InBattleField()
  if isInBattleField then
    UIUtil.ShowTipsId("activity_treasure_error_alert23")
    return
  end
  local isCrossServer = CrossServerUtil.CheckCrossServerWithWatchAndJoinType()
  if not isCrossServer then
    self:ConfirmGoTo()
    return
  end
  if self:TodayDontShowJumpTipAgain() then
    self:ConfirmGoTo()
    return
  end
  UIUtil.ShowSecondMessageByParam({
    tipText = Localization:GetString("2025halloween_treasure_list_goto1"),
    btnNum = 2,
    showToggle = true,
    toggleText = Localization:GetString("110103"),
    toggleAction = function(isOn)
      if isOn then
        CommonUtil.PlayerPrefsSetString(GOTO_FLOWER_TRAIN_CONFIRM, "")
      else
        CommonUtil.PlayerPrefsSetString(GOTO_FLOWER_TRAIN_CONFIRM, tostring(UITimeManager:GetInstance():GetServerSeconds()))
      end
    end,
    sureAction = function()
      self:ConfirmGoTo()
    end
  })
end

function UIFlowerTrainShowListItem:OnGetBtnClick()
  if self.data == nil then
    return
  end
  if self.data.uuid == nil then
    return
  end
  SFSNetwork.SendMessage(MsgDefines.FlowerTrainReceiveReward, self.data.uuid, 3)
end

function UIFlowerTrainShowListItem:TodayDontShowJumpTipAgain()
  local time = CommonUtil.PlayerPrefsGetString(GOTO_FLOWER_TRAIN_CONFIRM, "")
  if time ~= nil and time ~= "" then
    local now = UITimeManager:GetInstance():GetServerSeconds()
    return UITimeManager:GetInstance():IsSameDayForServer(tonumber(time) or 0, now)
  end
  return false
end

function UIFlowerTrainShowListItem:ConfirmGoTo()
  if not SceneUtils.CheckCanGotoWorld() then
    return
  end
  local marchUuid = self.data.marchUuid
  local worldId = LuaEntry.Player:GetCurWorldId()
  local serverId = self.trainData.serverId or LuaEntry.Player.serverId
  GoToUtil.CloseAllWindows()
  if marchUuid and type(marchUuid) == "number" and 0 < marchUuid then
    SFSNetwork.SendMessage(MsgDefines.GetMarchPos, serverId, worldId, marchUuid, NewMarchType.FLOWER_TRAIN)
  end
end

function UIFlowerTrainShowListItem:OnLikeBtnClick()
  if self.trainData:IsSelfFlowerTrain() then
    UIUtil.ShowTipsId("avatar_tips001")
    return
  end
  local playerUid = tonumber(self.infoData.uid)
  local carUuid = tonumber(self.trainData.uuid)
  SFSNetwork.SendMessage(MsgDefines.FlowerTrainPraise, playerUid, carUuid)
end

function UIFlowerTrainShowListItem:UpdateTimeView()
  if self.infoData == nil then
    return
  end
  local curTime = UITimeManager:GetInstance():GetServerTime()
  local leftTime = self.infoData.arriveTime - curTime
  if leftTime < 0 then
    leftTime = 0
  end
  if leftTime == 0 then
    self.time_txt:SetActive(false)
  else
    self.time_txt:SetActive(true)
    local countDownTimeStr = UITimeManager:GetInstance():MilliSecondToFmtString(leftTime)
    self.time_txt:SetText(countDownTimeStr)
  end
  local now = UITimeManager:GetInstance():GetServerTime()
  local waitingTime = self.trainData:GetNextThrowLvBoxTime()
  if leftTime == 0 then
    self.tips_text:SetLocalText("2025halloween_treasure_list_desc5")
  elseif now < waitingTime then
    local timeStr = UITimeManager:GetInstance():MilliSecondToFmtString(waitingTime - now)
    self.tips_text:SetText(Localization:GetString("2025halloween_treasure_list_desc3", timeStr))
  else
    self.tips_text:SetLocalText("2025halloween_treasure_list_desc2")
  end
end

function UIFlowerTrainShowListItem:SetRewardIcon()
  if self.trainData == nil then
    return
  end
  local iconPath = self.trainData:GetLvImgPath()
  if iconPath == nil then
    return
  end
  self.reward_icon:LoadSprite(iconPath)
end

return UIFlowerTrainShowListItem
