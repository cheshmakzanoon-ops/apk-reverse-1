local UIActValentineChampionDisplayView = BaseClass("UIActValentineChampionDisplayView", UIBaseView)
local UICommonHead = require("Framework.UI.Component.UICommonHead")
local StarInfoItem = require("UI.UIActivityCenterTable.Component.UIActValentine.Component.ValentineStarItemComponent")
local base = UIBaseView
local Localization = CS.GameEntry.Localization
local click_btn_path = "Root/ClickBtn"
local confirm_btn_path = "Root/BottonArea/ConfirmBtn"
local like_btn_path = "Root/BottonArea/LikeBtn"
local u_i_common_res_item_path = "Root/RewardInfo/Scroll View/Viewport/Content/UICommonResItem"
local u_i_player_head_path = "Root/RankInfo/ChampionInfo/UIPlayerHead"
local player_name_text_path = "Root/RankInfo/ChampionInfo/PlayerNameText"
local content_path = "Root/RewardInfo/Scroll View/Viewport/Content"
local champion_btn_path = "Root/BottonArea/ChampionBtn"
local u_i_act_valentine_stage01_ioop_path = "Root/DuanWei/UIActValentineStage0%s_ioop"
local rank_text_path = "Root/RankInfo/RankText"
local valentine_star_item_path = "Root/RankInfo/StarInfo/ValentineStarItem"
local reward_title_text_path = "Root/RewardInfo/RewardTitleText"
local title_text_path = "Root/Cup_Root/TitleText"
local ShowState = {ShowCup = 1, ShowChampion = 2}

local function OnCreate(self)
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
  local param = self:GetUserData()
  self.activityId = param.activityId
  self.reward = param.reward
  self.championInfo = param.championInfo
  self.day = param.day or 0
  self.exp = param.exp or 0
  self:ReInit()
end

local function OnDestroy(self)
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

local function OnEnable(self)
  base.OnEnable(self)
end

local function OnDisable(self)
  base.OnDisable(self)
  if self.showRankSoundHandle then
    DataCenter.LWSoundManager:StopSound(self.showRankSoundHandle)
    self.showRankSoundHandle = nil
  end
end

local function ComponentDefine(self)
  self.simpleAni = self:AddComponent(UISimpleAnimation, "")
  self.fullScreenClickBtn = self:AddComponent(UIButton, click_btn_path)
  self.fullScreenClickBtn:SetOnClick(function()
    self:OnFullScreenClickBtn()
  end)
  self.confirmBtn = self:AddComponent(UIButton, confirm_btn_path)
  self.confirmBtn:SetOnClick(function()
    self:OnConfirmBtnClick()
  end)
  self.likeBtn = self:AddComponent(UIButton, like_btn_path)
  self.likeBtn:SetOnClick(function()
    self:OnLikeBtnClick()
  end)
  self.championBtn = self:AddComponent(UIButton, champion_btn_path)
  self.championBtn:SetOnClick(function()
    self:OnChampionBtnClick()
  end)
  self.rewardItemObj = self:AddComponent(UIBaseContainer, u_i_common_res_item_path)
  self.rewardItemObj.gameObject:GameObjectCreatePool()
  self.playerHead = self:AddComponent(UICommonHead, u_i_player_head_path)
  self.playerNameText = self:AddComponent(UIText, player_name_text_path)
  self.rewardContent = self:AddComponent(UIBaseContainer, content_path)
  self.timer = nil
  self.rankIconList = {}
  for i = 1, 5 do
    local path = string.format(u_i_act_valentine_stage01_ioop_path, i)
    local rankObj = self:AddComponent(UIBaseContainer, path)
    self.rankIconList[i] = rankObj
  end
  self.rankTitleText = self:AddComponent(UIText, rank_text_path)
  self.starItem = self:AddComponent(StarInfoItem, valentine_star_item_path)
  self.rewardTitleText = self:AddComponent(UIText, reward_title_text_path)
  self.titleText = self:AddComponent(UIText, title_text_path)
end

local function ComponentDestroy(self)
  self:StopAllTimer()
  self.rewardItemObj.gameObject:GameObjectRecycleAll()
  self.rankIconList = nil
end

local function DataDefine(self)
  self.curState = ShowState.ShowChampion
end

local function DataDestroy(self)
  self.curState = nil
end

local function OnAddListener(self)
  base.OnAddListener(self)
end

local function OnRemoveListener(self)
  base.OnRemoveListener(self)
end

function UIActValentineChampionDisplayView:ReInit()
  self.fullScreenClickBtn:SetActive(true)
  self.titleText:SetLocalText("activity_99136_62", self.day)
  self:ChangeState(ShowState.ShowCup)
  self:RefreshView()
end

function UIActValentineChampionDisplayView:RefreshView()
  self.rData = DataCenter.ValentineDataManager:GetActivityReceiveData(self.activityId)
  if not self.rData then
    return
  end
  if self.championInfo then
    self.playerHead:ParseHeadInfo(self.championInfo)
    self.playerNameText:SetText(self.championInfo.name)
    self:RefreshBtnState()
  end
  self:RefreshRankInfo()
  self:RefreshRewardInfo()
end

function UIActValentineChampionDisplayView:RefreshBtnState()
  local selfUid = LuaEntry.Player.uid
  local isSelfChampion = selfUid == self.championInfo.uid
  if isSelfChampion then
    self.rewardTitleText:SetLocalText("activity_99136_68")
  else
    self.rewardTitleText:SetLocalText("activity_99136_64")
  end
  self.championBtn:SetActive(isSelfChampion)
  self.confirmBtn:SetActive(not isSelfChampion)
  self.likeBtn:SetActive(not isSelfChampion)
end

function UIActValentineChampionDisplayView:RefreshRankInfo()
  local rankData = self.rData:GetRankDataByExp(self.exp)
  if not rankData then
    return
  end
  for k, v in pairs(self.rankIconList) do
    v:SetActive(k == rankData.type)
  end
  self.rankTitleText:SetLocalText(rankData.key_big)
  self.starItem:RefreshByActivityAndRankData(self.activityId, self.exp)
end

function UIActValentineChampionDisplayView:RefreshRewardInfo()
  self.rewardItemObj.gameObject:GameObjectRecycleAll()
  if not self.reward then
    return
  end
  for _, v in ipairs(self.reward) do
    local gameObject = self.rewardItemObj.gameObject:GameObjectSpawn(self.rewardContent.transform)
    local name = "item_" .. NameCount
    gameObject.name = name
    NameCount = NameCount + 1
    local rewardItem = self.rewardContent:AddComponent(UICommonResItem, name)
    rewardItem:ParseInfo(v)
  end
end

function UIActValentineChampionDisplayView:ChangeState(state)
  if state == ShowState.ShowCup then
    self:PlayAni("FadeIn")
  else
    self.fullScreenClickBtn:SetActive(false)
    self:PlayAni("Play")
    if self.showRankSoundHandle then
      DataCenter.LWSoundManager:StopSound(self.showRankSoundHandle)
      self.showRankSoundHandle = nil
    end
    self.showRankSoundHandle = DataCenter.LWSoundManager:PlaySound(202641, false)
  end
  self.curState = state
end

function UIActValentineChampionDisplayView:OnFullScreenClickBtn()
  if self.timer then
    return
  end
  if self.curState == ShowState.ShowCup then
    self:ChangeState(ShowState.ShowChampion)
  end
end

function UIActValentineChampionDisplayView:OnConfirmBtnClick()
  self:ReceiveRewardAndCloseWindow()
end

function UIActValentineChampionDisplayView:OnLikeBtnClick()
  if self.championInfo and not string.IsNullOrEmpty(self.championInfo.uid) then
    InteractiveUtil.TryThumbsUp(self.championInfo.uid, InteractiveUtil.ThumbsUpType.PlayerInfo, "NotAutoSendGift", function()
    end)
  end
  self:ReceiveRewardAndCloseWindow()
end

function UIActValentineChampionDisplayView:OnChampionBtnClick()
  self:ReceiveRewardAndCloseWindow()
end

function UIActValentineChampionDisplayView:ReceiveRewardAndCloseWindow()
  self.ctrl:CloseSelf()
  SFSNetwork.SendMessage(MsgDefines.ValentineReceiveDayReward, self.activityId, self.day)
end

function UIActValentineChampionDisplayView:PlayAni(aniName)
  self:StopAllTimer()
  local ret, time = self.simpleAni:PlayAnimationReturnTime(aniName)
  if ret then
    self.timer = TimerManager:GetInstance():DelayInvoke(function()
      self.timer = nil
    end, 1.5)
  end
end

function UIActValentineChampionDisplayView:StopAllTimer()
  if self.timer then
    self.timer:Stop()
    self.timer = nil
  end
end

UIActValentineChampionDisplayView.OnCreate = OnCreate
UIActValentineChampionDisplayView.OnDestroy = OnDestroy
UIActValentineChampionDisplayView.OnEnable = OnEnable
UIActValentineChampionDisplayView.OnDisable = OnDisable
UIActValentineChampionDisplayView.ComponentDefine = ComponentDefine
UIActValentineChampionDisplayView.ComponentDestroy = ComponentDestroy
UIActValentineChampionDisplayView.DataDefine = DataDefine
UIActValentineChampionDisplayView.DataDestroy = DataDestroy
UIActValentineChampionDisplayView.OnAddListener = OnAddListener
UIActValentineChampionDisplayView.OnRemoveListener = OnRemoveListener
return UIActValentineChampionDisplayView
