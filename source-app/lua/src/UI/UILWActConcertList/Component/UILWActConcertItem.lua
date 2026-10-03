local UILWActConcertItem = BaseClass("UILWActConcertItem", UIBaseContainer)
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

function UILWActConcertItem:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
end

function UILWActConcertItem:OnDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UILWActConcertItem:ComponentDefine()
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

function UILWActConcertItem:ComponentDestroy()
  self.bg = nil
  self.player_head = nil
  self.player_level_text = nil
  self.player_gender_icon = nil
  self.player_name_text = nil
  self.reward_icon = nil
  self.like_icon = nil
end

function UILWActConcertItem:ReInit(data, activityId)
  self.infoData = data
  self.activityId = activityId
  self.data = data.info
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
  local leftTime = self.infoData.layer
  local maxNum = DataCenter.ActConcertDataManager:GetMaxStatus(self.activityId)
  local curNum = maxNum - leftTime
  self.have_get_txt:SetText(string.format("<color=#099b4a>%s</color>/%s", curNum, maxNum))
  self.tips_text:SetLocalText("activity_concert_3")
end

function UILWActConcertItem:OnGoBtnClick()
  local pointId = self.infoData.pointId
  if pointId and tonumber(pointId) == -1 then
    UIUtil.ShowTipsId("activity_concert_4")
    return
  end
  GoToUtil.CloseAllWindows()
  GoToUtil.MoveToWorldPoint(pointId, SceneManagerSceneID.World)
end

function UILWActConcertItem:OnLikeBtnClick()
  local playerUid = self.data.uid
  InteractiveUtil.TryThumbsUp(playerUid, InteractiveUtil.ThumbsUpType.ActConcert, "PlayerDetailMain", function()
    UIUtil.ShowTipsId("activity_sports_uitips_021")
  end, self.infoData.partyId)
end

function UILWActConcertItem:UpdateTimeView()
  if self.infoData == nil then
    return
  end
  local curTime = UITimeManager:GetInstance():GetServerTime()
  local leftTime = self.infoData.expireTime - curTime
  if leftTime <= 0 then
    Logger.LogError("UILWActConcertItem:UpdateTimeView leftTime <= 0, expireTime: " .. self.infoData.expireTime .. " curTime: " .. curTime)
    DataCenter.ActConcertDataManager:RemoveConcertFromList(self.infoData.partyId)
    return
  end
  local countDownTimeStr = UITimeManager:GetInstance():MilliSecondToFmtString(leftTime)
  self.time_txt:SetText(countDownTimeStr)
end

function UILWActConcertItem:SetRewardIcon()
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

return UILWActConcertItem
