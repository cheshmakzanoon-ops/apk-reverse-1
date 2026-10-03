local UILWActDetectTreasureALPanelPlayerItemRender = BaseClass("UILWActDetectTreasureALPanelPlayerItemRender", UIBaseContainer)
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization
local bg_path = "Bg"
local player_head_path = "HeadContent/PlayerHead"
local player_level_text_path = "HorLayout/PlayerLevelText"
local player_gender_icon_path = "HorLayout/PlayerGenderIcon"
local player_name_text_path = "HorLayout/PlayerNameText"
local time_txt_path = "HeadContent/timeContent/timeTxt"
local tips_text_path = "TipsText"
local have_get_txt_path = "haveGetTxt"
local go_btn_path = "GoBtn"
local like_btn_path = "LikeBtn"
local reward_icon_path = "HeadContent/rewardIcon"
local like_icon_path = "LikeBtn/likeIcon"

function UILWActDetectTreasureALPanelPlayerItemRender:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
end

function UILWActDetectTreasureALPanelPlayerItemRender:OnDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UILWActDetectTreasureALPanelPlayerItemRender:ComponentDefine()
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
  self.like_btn = self:AddComponent(UIButton, like_btn_path)
  self.reward_icon = self:AddComponent(UIImage, reward_icon_path)
  self.go_btn:SetOnClick(function()
    self:OnGoBtnClick()
  end)
  self.like_btn:SetOnClick(function()
    self:OnLikeBtnClick()
  end)
  self.like_icon = self:AddComponent(UIRawImage, like_icon_path)
end

function UILWActDetectTreasureALPanelPlayerItemRender:ComponentDestroy()
  self.bg = nil
  self.player_head = nil
  self.player_level_text = nil
  self.player_gender_icon = nil
  self.player_name_text = nil
  self.reward_icon = nil
  self.like_icon = nil
end

function UILWActDetectTreasureALPanelPlayerItemRender:ReInit(data, activityId)
  self.infoData = data
  self.activityId = activityId
  self.data = data.playerInfo
  self.player_head:SetHeadAndFrame(self.data.uid, self.data.pic, self.data.picver, nil, self.data.headSkinId, self.data.headSkinET)
  local lvNum = 0
  if self.data.level then
    lvNum = self.data.level
  end
  if self.data.uid == LuaEntry.Player.uid then
    self.player_name_text:SetLocalText("activity_sports_uitips_030")
    self.player_level_text:SetText("")
    self.player_gender_icon:SetActive(false)
  else
    self.player_name_text:SetText(self.data.name)
    self.player_level_text:SetLocalText(GameDialogDefine.LEVEL_NUMBER, lvNum)
    if self.data.gender == 0 or self.data.gender == 3 then
      self.player_gender_icon:SetActive(false)
    else
      self.player_gender_icon:SetActive(true)
      local gender_img_path = "Assets/Main/Sprites/UI/UILWAlliance/"
      self.player_gender_icon:LoadSprite(gender_img_path .. (self.data.gender == 2 and "cfm_lianmeng_tubiao_nv" or "cfm_lianmeng_tubiao_nan"))
    end
  end
  if self.infoData.state == TreasureState.Complete then
    local curNum = self.infoData.receivedNum
    local maxNum = self.infoData.maxReceivedNum
    self.have_get_txt:SetText(string.format("<color=#099b4a>%s</color>/%s", curNum, maxNum))
  else
    self.have_get_txt:SetText("")
  end
  local stateTxt = ""
  if self.infoData.state == TreasureState.Complete then
    if self.infoData.receiveState and 0 < self.infoData.receiveState then
      stateTxt = "371068"
    else
      stateTxt = "activity_wajueji_27000_tips9"
    end
  elseif self.infoData.state == TreasureState.Digging then
    stateTxt = "activity_wajueji_27000_tips2"
  else
    stateTxt = "activity_wajueji_27000_tips8"
  end
  self.tips_text:SetLocalText(stateTxt)
  if self.infoData.state == TreasureState.Complete and self.infoData.receiveState and 0 < self.infoData.receiveState then
    self.tips_text:SetColor(Color.New(0.45098039215686275, 0.40784313725490196, 0.38823529411764707, 1))
  else
    self.tips_text:SetColor(Color.New(0.03529411764705882, 0.6078431372549019, 0.2901960784313726, 1))
  end
  local activityInfo = DataCenter.ActivityListDataManager:GetActivityDataById(self.activityId)
  local paraTemp = DataCenter.ActMonopolyDataManager:GetMonopolyParaTempById(activityInfo.richman_para)
  if not string.IsNullOrEmpty(paraTemp.para14) then
    local showData = string.split(paraTemp.para14, "|")
    if #showData == 5 then
      local path = string.format(UIAssets.UIActMonopolyTexturePath, showData[2])
      self.like_icon:LoadSprite(path)
      self.like_icon:SetNativeSize()
      path = string.format(UIAssets.UIActDetectTreasureSpritePath, showData[5])
      if self.data.uid == LuaEntry.Player.uid then
        self.bg:SetColorRGBA(0.79, 0.93, 0.6, 1)
        self.bg:LoadSprite("Assets/Main/Sprites/UI/LWCommon/Sprite/cfm_tongyong_erji_dichen_yuanjiao_4.png")
      else
        self.bg:SetColorRGBA(1, 1, 1, 1)
        self.bg:LoadSprite(path)
      end
    end
  end
  self:SetRewardIcon()
  self:UpdateTimeView()
end

function UILWActDetectTreasureALPanelPlayerItemRender:OnGoBtnClick()
  local pointId = self.infoData.point
  local uuid = self.infoData.uuid
  GoToUtil.CloseAllWindows()
  GoToUtil.GotoWorldPos(SceneUtils.TileIndexToWorld(pointId, ForceChangeScene.World), CS.SceneManager.World.InitZoom, nil, nil, self.infoData.serverId)
  PostEventLog.Track(PostEventLog.Defines.ActMonopolyActRadarTreasureGotoBtnClick, {
    eventId = self.infoData.eventId,
    activityId = self.activityId,
    uid = self.infoData.playerInfo.uid
  })
end

function UILWActDetectTreasureALPanelPlayerItemRender:OnLikeBtnClick()
  local playerUid = self.infoData.playerInfo.uid
  local radarUid = self.infoData.uuid
  local eventId = self.infoData.eventId
  InteractiveUtil.TryThumbsUp(playerUid, InteractiveUtil.ThumbsUpType.ActRadarTreasure, tostring(eventId), function()
    UIUtil.ShowTipsId("activity_sports_uitips_021")
  end, tostring(radarUid))
end

function UILWActDetectTreasureALPanelPlayerItemRender:UpdateTimeView()
  if self.infoData == nil then
    return
  end
  local curTime = UITimeManager:GetInstance():GetServerTime()
  local leftTime = self.infoData.endTime - curTime
  if leftTime < 0 then
    leftTime = 0
  end
  local countDownTimeStr = UITimeManager:GetInstance():MilliSecondToFmtString(leftTime)
  self.time_txt:SetText(countDownTimeStr)
end

function UILWActDetectTreasureALPanelPlayerItemRender:SetRewardIcon()
  local activityInfo = DataCenter.ActivityListDataManager:GetActivityDataById(self.activityId)
  if activityInfo == nil then
    return
  end
  local activityDetailData = DataCenter.ActMonopolyDataManager:GetActData(self.activityId)
  if activityDetailData == nil then
    return
  end
  local paraTemp = DataCenter.ActMonopolyDataManager:GetMonopolyParaTempById(activityInfo.richman_para)
  if paraTemp == nil then
    return
  end
  local iconPath = string.format(LoadPath.ItemPath, paraTemp.gold_icon)
  self.reward_icon:LoadSprite(iconPath)
end

return UILWActDetectTreasureALPanelPlayerItemRender
