local UIKillZombieBoxUpgradeView = BaseClass("UIKillZombieBoxUpgradeView", UIBaseView)
local UIKillZombieBoxModelPanel = require("UI.KillZombie.BoxUpgrade.Component.UIKillZombieBoxModelPanel")
local UIKillZombieBoxItem = require("UI.KillZombie.BoxUpgrade.Component.UIKillZombieBoxItem")
local UIKillZombieBoxResItem = require("UI.KillZombie.BoxUpgrade.Component.UIKillZombieBoxResItem")
local base = UIBaseView
local Localization = CS.GameEntry.Localization
local Setting = CS.GameEntry.Setting
local PanelType = {View = 0, Open = 1}
local level_icon_path = "Root/TopRoot/TitleRoot/LevelIcon"
local u_i_player_head_path = "Root/TopRoot/TitleRoot/UIPlayerHead"
local player_name_text_path = "Root/TopRoot/TitleRoot/PlayerNameText"
local title_root_path = "Root/TopRoot/TitleRoot"
local click_path = "Root/Click"
local skip_btn_path = "Root/BottomRoot/SkipBtn"
local box_item_path = "Root/BoxListRoot/ListScroll/Content/BoxItem"
local content_path = "Root/BoxListRoot/ListScroll/Content"
local list_scroll_path = "Root/BoxListRoot/ListScroll"
local ANTI_TIE_POINT_INTERVAL = 500
local MOVE_OFFSET = -160

local function OnCreate(self)
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
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
  if self.content then
    self.content:SetAnchoredPositionXY(0, 0)
  end
end

local function ComponentDefine(self)
  self.modelPanel = self:AddComponent(UIKillZombieBoxModelPanel, "Root/CenterRoot/BoxRoot")
  self.textTitle = self:AddComponent(UITextMeshProUGUIEx, "Root/CenterRoot/TitleText")
  self.textTitle:SetLocalText("challenge_zombie_box_title")
  self.textHint = self:AddComponent(UITextMeshProUGUIEx, "Root/CenterRoot/HintText")
  self.resItem = self:AddComponent(UIKillZombieBoxResItem, "Root/TopRoot/ResItem")
  self.btnBack = self:AddComponent(UIButton, "Root/BottomRoot/BackBtn")
  self.btnBack:SetOnClick(BindCallback(self, self.OnBtnBackClick))
  self.btnShare = self:AddComponent(UIButton, "Root/BottomRoot/ShareBtn")
  self.btnShare:SetOnClick(BindCallback(self, self.OnBtnShareClick))
  self.level_icon = self:AddComponent(UIImage, level_icon_path)
  self.u_i_player_head = self:AddComponent(UICommonHead, u_i_player_head_path)
  self.u_i_player_head:SetEnableClickShowInfo(false)
  self.player_name_text = self:AddComponent(UITextMeshProUGUIEx, player_name_text_path)
  self.title_root = self:AddComponent(UIBaseContainer, title_root_path)
  self.click = self:AddComponent(UIButton, click_path)
  self.click:SetOnClick(BindCallback(self, self.OnEmptyClick))
  self.skip_btn = self:AddComponent(UIButton, skip_btn_path)
  self.skip_btn:SetOnClick(BindCallback(self, self.OnSkipBtnClick))
  self.box_item = self.transform:Find(box_item_path).gameObject
  self.box_item:GameObjectCreatePool()
  self.content = self:AddComponent(UIBaseContainer, content_path)
  self.list_scroll = self:AddComponent(UIScrollRect, list_scroll_path)
end

local function ComponentDestroy(self)
  self.content:SetAnchoredPositionXY(0, 0)
  self:ClearTween()
  self.modelPanel = nil
  self.textTitle = nil
  self.textHint = nil
  self.resItem = nil
  self.btnBack = nil
  self.btnShare = nil
  self.level_icon = nil
  self.u_i_player_head = nil
  self.player_name_text = nil
  self.title_root = nil
  self.click = nil
  self.skip_btn = nil
  self.box_item:GameObjectRecycleAll()
  self.box_item = nil
  self.content = nil
  self.list_scroll = nil
end

local function DataDefine(self)
  self.shareCd = LuaEntry.DataConfig:TryGetNum("advanced_challenge", "k3", 0)
  self.itemList = {}
  self.items = {}
  self.index = 0
  self.isFinish = nil
  self.isWaiting = nil
  self.clickTime = nil
  self.count = nil
  self.resNum = nil
  self.uid = nil
  self.bossId = nil
  self.maxQuality = nil
  self.rewardList = nil
  self.lastQuality = 0
  self.maxIndex = 0
  local param = self:GetUserData()
  self.param = param
  if param then
    self:InitData(param)
  end
end

local function DataDestroy(self)
  self.shareCd = nil
  self.isFinish = nil
  self.isWaiting = nil
  self.index = nil
  self.itemList = nil
  self.items = nil
  self.clickTime = nil
  self.count = nil
  self.resNum = nil
  self.uid = nil
  self.bossId = nil
  self.maxQuality = nil
  self.rewardList = nil
  self.lastQuality = nil
  self.param = nil
  self.maxIndex = nil
end

local function OnAddListener(self)
  base.OnAddListener(self)
  self:AddUIListener(EventId.ChallengeZombieGetWorldBoxReward, self.GetRewardPanel)
  self:AddUIListener(EventId.ChallengeZombieViewWorldBoxReward, self.ViewPanel)
end

local function OnRemoveListener(self)
  self:RemoveUIListener(EventId.ChallengeZombieGetWorldBoxReward, self.GetRewardPanel)
  self:RemoveUIListener(EventId.ChallengeZombieViewWorldBoxReward, self.ViewPanel)
  base.OnRemoveListener(self)
end

local function InitData(self, data)
  if data then
    local uid = data.uid
    if uid == nil then
      self.ctrl:CloseSelf()
      return
    end
    local panelType = data.panelType or PanelType.View
    self.panelType = panelType
    if panelType == PanelType.View then
      self.textHint:SetActive(false)
      self.resItem:SetActive(false)
      self.btnShare:SetActive(uid == LuaEntry.Player:GetUid())
      self.skip_btn:SetActive(false)
      self.title_root:SetActive(true)
      self.isFinish = true
      self.list_scroll:SetEnable(true)
      SFSNetwork.SendMessage(MsgDefines.AllianceChallengeNewRewardView, uid)
    elseif panelType == PanelType.Open then
      self.textHint:SetLocalText("challenge_zombie_box_open_click")
      self.textHint:SetActive(true)
      self.resItem:SetActive(true)
      self.btnShare:SetActive(false)
      self.title_root:SetActive(false)
      self.isFinish = false
      self.isWaiting = false
      self.list_scroll:SetEnable(false)
      local itemId = LuaEntry.DataConfig:TryGetStr("advanced_challenge", "k9", "")
      self.resNum = self.resItem:Init(itemId) or 0
      self.skip_btn:SetActive(self.resNum > 0)
      SFSNetwork.SendMessage(MsgDefines.AllianceChallengeNewRewardGet)
    end
  end
end

local function InitBoxList(self, bossId, dataList)
  if bossId == nil or bossId == 0 then
    self.ctrl:CloseSelf()
    return
  end
  self.bossId = bossId
  local template = DataCenter.AdvancedChallengeBossTemplateManager:GetTemplate(bossId)
  if template == nil then
    self.ctrl:CloseSelf()
    return
  end
  local count = 0
  local personalBoxArr = template.player_progress_special
  if personalBoxArr then
    for i, v in ipairs(personalBoxArr) do
      count = count + v
    end
  end
  local allBoxArr = template.alliance_progress_special
  if allBoxArr then
    for i, v in ipairs(allBoxArr) do
      count = count + v
    end
  end
  self.count = count
  self:InitList(dataList)
end

local function GetRewardPanel(self, message)
  if message == nil then
    self.ctrl:CloseSelf()
    return
  end
  local errorCode = message.errorCode
  if errorCode ~= nil then
    UIUtil.ShowTipsId(errorCode)
    self.ctrl:CloseSelf()
    return
  end
  local rewardList = message.rewardList
  local newAlData = DataCenter.ActivityKillZombieManager.newAlData
  local bossId = newAlData and newAlData.bossId
  if bossId == nil or bossId == 0 then
    self.ctrl:CloseSelf()
    return
  end
  self:InitBoxList(bossId, rewardList)
  local result = {}
  local count = 0
  local maxQuality = 1
  if rewardList then
    count = #rewardList
    maxQuality = rewardList[count].boxQuality
    for _, v in ipairs(rewardList) do
      self:InsertRewardList(result, v)
    end
  end
  self.maxIndex = count
  self.maxQuality = maxQuality
  if self.modelPanel then
    self.modelPanel:InitPanel(1)
  end
  self.rewardList = table.values(result)
end

local function ViewPanel(self, message)
  if message == nil then
    self.ctrl:CloseSelf()
    return
  end
  local errorCode = message.errorCode
  if errorCode ~= nil then
    UIUtil.ShowTipsId(errorCode)
    self.ctrl:CloseSelf()
    return
  end
  local rewardList = message.rewardList
  self:InitPlayerData(message.roleInfo)
  local count = 0
  local maxQuality = 0
  if rewardList then
    count = #rewardList
    local maxReward = rewardList[count]
    if maxReward then
      maxQuality = maxReward.boxQuality
      self.maxQuality = maxQuality
    end
  end
  if self.modelPanel then
    if maxQuality == 0 then
      self.modelPanel:InitPanel(1)
    else
      self.modelPanel:ShowBoxOpenPanel(tonumber(maxQuality))
    end
  end
  self.maxIndex = count
  self.maxQuality = maxQuality
  if self.param then
    self:InitBoxList(self.param.bossId, rewardList)
  end
  self.content:SetAnchoredPositionXY(0, 0)
  self:DoLocalMoveAuto(count)
  self:InitBossLevelIcon()
end

local function InitPlayerData(self, param)
  if param then
    local abbr = param.abbr
    local name = param.name
    if name ~= nil and name ~= "" then
      if abbr == nil or abbr == "" then
        self.player_name_text:SetText(name)
      else
        self.player_name_text:SetLocalText(311026, abbr, name)
      end
    end
    self.u_i_player_head:ParseHeadInfo(param)
    self.uid = param.uid
  end
end

local function InitBossLevelIcon(self)
  if self.bossId then
    local template = DataCenter.AdvancedChallengeBossTemplateManager:GetTemplate(self.bossId)
    if template then
      local icon = template.progress_score_icon
      if not string.IsNullOrEmpty(icon) then
        self.level_icon:LoadSprite(icon)
      end
    end
  end
end

local function OpenBoxHandler(self)
  self.isWaiting = true
  if self.maxIndex > 0 and self.modelPanel then
    self.modelPanel:OpenBox(self.maxQuality, function()
      self:ShowRewardGotPanel()
      self.btnShare:SetActive(true)
      self.skip_btn:SetActive(false)
    end)
    self:DoLocalMoveAuto(self.maxIndex)
    if self.itemList then
      for i = 1, self.maxIndex do
        local item = self.itemList[i]
        if item then
          item:PlayBoxOpen()
          item:SetCommonShow(i ~= self.maxIndex)
        end
      end
    end
  end
  if self.resItem then
    self.resItem:RefreshNum(0)
  end
end

local function InsertRewardList(self, list, value)
  if list then
    local param = {
      reward = value.receivedRewardInfo
    }
    DataCenter.RewardManager:AddRewardsAndRes(param)
    local itemList = value and DataCenter.RewardManager:ReturnRewardParamForMessage(value.receivedRewardInfo)
    if itemList then
      for _, v in ipairs(itemList) do
        if v then
          local itemId = v.itemId
          if list[itemId] == nil then
            list[itemId] = v
          else
            local count = list[itemId].count
            list[itemId].count = count + v.count
          end
        end
      end
    end
  end
end

local function ShowRewardGotPanel(self)
  self.isFinish = true
  self.list_scroll:SetEnable(true)
  if not table.IsNullOrEmpty(self.rewardList) then
    local param = {}
    param.title = Localization:GetString("challenge_zombie_box_reward_show")
    param.rewardList = self.rewardList
    UIManager:GetInstance():OpenWindow(UIWindowNames.UIGiftPackageRewardGet, {
      anim = true,
      playEffect = false,
      UIMainAnim = UIMainAnimType.LeftRightBottomHide
    }, param)
  end
end

local function CheckBoxLightOn(self)
  if self.itemList and #self.itemList >= self.maxIndex and self.maxIndex > 0 then
    for i = 1, self.maxIndex do
      local item = self.itemList[i]
      if item then
        item:LightOnTheBox(i == self.maxIndex)
      end
    end
  end
end

local function InitList(self, dataList)
  if self.count > 0 then
    local name
    local maxCount = dataList and #dataList or 0
    for i = 1, self.count do
      local data = i <= maxCount and dataList[i]
      local item = self.box_item.gameObject:GameObjectSpawn(self.content.transform)
      name = tostring(i)
      item.name = name
      local cell = self.content:AddComponent(UIKillZombieBoxItem, name)
      cell:ShowProgressBar(i ~= 1)
      if self.panelType == PanelType.View then
        cell:ShowItemOpen(data)
        cell:SetCommonShow(i ~= self.maxIndex)
      else
        cell:SetData(self.modelPanel.transform, data)
      end
      table.insert(self.itemList, cell)
    end
  end
end

local function OnBtnBackClick(self)
  if self.isWaiting and not self.isFinish then
    return
  end
  if self.isFinish or self.panelType == PanelType.View then
    self.ctrl:CloseSelf()
  elseif self.maxIndex > 0 then
    self:OpenBoxHandler()
  else
    self.ctrl:CloseSelf()
  end
end

local function OnBtnShareClick(self)
  if self.endTs == nil then
    local activityId = DataCenter.ActivityKillZombieManager.activityId
    local activityData = activityId and DataCenter.ActivityListDataManager:GetActivityDataById(activityId)
    self.endTs = activityData and activityData.endTime or 0
  end
  if self.endTs == 0 then
    UIUtil.ShowTipsId("challenge_zombie_share_expired_tips")
    return
  end
  local curTs = UITimeManager:GetInstance():GetServerTime()
  if curTs > self.endTs then
    UIUtil.ShowTipsId("challenge_zombie_share_expired_tips")
    return
  end
  local lastTimeStr = Setting:GetString(SettingKeys.AL_CHALLENGE_BOSS_BOX_SHARE, "")
  if lastTimeStr ~= "" then
    local lastTime = tonumber(lastTimeStr)
    local offset = curTs - lastTime
    offset = math.ceil(offset / 1000)
    if 0 < offset and offset < self.shareCd then
      local context = Localization:GetString("challenge_zombie_box_share", self.shareCd - offset)
      UIUtil.ShowTips(context)
      return
    end
  end
  if self.panelType == PanelType.Open or self.uid == LuaEntry.Player:GetUid() then
    if self.shareParam == nil then
      local shareParam = {}
      shareParam.post = PostType.ALLIANCE_MONSTER_CHALLENGE_NEW_REWARD
      shareParam.param = {}
      shareParam.param.endTs = self.endTs
      shareParam.param.rewardCount = self.maxIndex
      shareParam.param.quality = self.maxQuality
      shareParam.param.bossId = self.bossId
      self.shareParam = shareParam
    end
    UIManager:GetInstance():OpenWindow(UIWindowNames.UIPositionShare, {anim = true}, self.shareParam)
  end
end

local function OnEmptyClick(self)
  if self.isFinish or self.isWaiting then
    return
  end
  if self.panelType == 0 then
    return
  end
  if self.resNum == 0 then
    UIUtil.ShowTipsId("challenge_zombie_not_item")
    return
  end
  if self.itemList == nil then
    if not self.isFinish and not self.isWaiting then
      self:OpenBoxHandler()
    end
    return
  end
  local curTime = UITimeManager:GetInstance():GetServerTime()
  if self.clickTime and curTime < self.clickTime + ANTI_TIE_POINT_INTERVAL then
    return
  end
  if self.maxIndex == 0 or self.index >= self.maxIndex or self.index >= #self.itemList then
    return
  end
  self.index = self.index + 1
  self.clickTime = curTime
  if self.index > 1 then
    local lastItem = self.itemList[self.index - 1]
    if lastItem and lastItem:LightOnTheBox() then
      self:DoLocalMoveAuto(self.index)
    end
  end
  if self.modelPanel then
    local item = self.itemList[self.index]
    if item then
      local quality = item.quality
      self.modelPanel:UpgradeBox(quality, quality > self.lastQuality, function()
        if self and self.itemList and self.index and self.index <= #self.itemList then
          local callback = self.index == self.maxIndex and function()
            self:OpenBoxHandler()
          end or nil
          self:DoLocalMoveAuto(self.index)
          self.itemList[self.index]:DisplayItemUnlock(callback)
          if self.index > 1 then
            self.itemList[self.index - 1]:SetCommonShow(true)
          end
        end
      end)
      self.resItem:RefreshNum(self.maxIndex - self.index)
      self.lastQuality = quality
    end
  end
end

local function OnSkipBtnClick(self)
  if self.isWaiting and not self.isFinish then
    return
  end
  if self.maxIndex > 0 then
    self:OpenBoxHandler()
  end
end

local function DoLocalMoveAuto(self, index)
  if 3 < index and index < self.count - 1 then
    self:DoMoveOutTween(MOVE_OFFSET * CommonUtil.ArabicAutoMirrorFactor() * (index - 3))
  elseif index == self.count - 1 then
    local scrollSizeDelta = self.list_scroll:GetSizeDelta()
    local contentSizeDelta = self.content:GetSizeDelta()
    local x = contentSizeDelta.x - scrollSizeDelta.x
    self:DoMoveOutTween(-x * CommonUtil.ArabicAutoMirrorFactor())
  end
end

local function DoMoveOutTween(self, x)
  self:ClearTween()
  local sequence = DOTween.Sequence()
  sequence:Append(self.content.transform:DOAnchorPosX(x, 0.3):SetEase(CS.DG.Tweening.Ease.OutQuad))
  self.sequence = sequence
end

local function ClearTween(self)
  if IsNotNull(self.sequence) then
    self.sequence:Pause()
    self.sequence:Kill()
    self.sequence = nil
  end
end

UIKillZombieBoxUpgradeView.OnCreate = OnCreate
UIKillZombieBoxUpgradeView.OnDestroy = OnDestroy
UIKillZombieBoxUpgradeView.OnEnable = OnEnable
UIKillZombieBoxUpgradeView.OnDisable = OnDisable
UIKillZombieBoxUpgradeView.ComponentDefine = ComponentDefine
UIKillZombieBoxUpgradeView.ComponentDestroy = ComponentDestroy
UIKillZombieBoxUpgradeView.DataDefine = DataDefine
UIKillZombieBoxUpgradeView.DataDestroy = DataDestroy
UIKillZombieBoxUpgradeView.OnAddListener = OnAddListener
UIKillZombieBoxUpgradeView.OnRemoveListener = OnRemoveListener
UIKillZombieBoxUpgradeView.InitData = InitData
UIKillZombieBoxUpgradeView.InitBoxList = InitBoxList
UIKillZombieBoxUpgradeView.GetRewardPanel = GetRewardPanel
UIKillZombieBoxUpgradeView.ViewPanel = ViewPanel
UIKillZombieBoxUpgradeView.InitPlayerData = InitPlayerData
UIKillZombieBoxUpgradeView.InitBossLevelIcon = InitBossLevelIcon
UIKillZombieBoxUpgradeView.OpenBoxHandler = OpenBoxHandler
UIKillZombieBoxUpgradeView.InsertRewardList = InsertRewardList
UIKillZombieBoxUpgradeView.ShowRewardGotPanel = ShowRewardGotPanel
UIKillZombieBoxUpgradeView.CheckBoxLightOn = CheckBoxLightOn
UIKillZombieBoxUpgradeView.InitList = InitList
UIKillZombieBoxUpgradeView.OnBtnBackClick = OnBtnBackClick
UIKillZombieBoxUpgradeView.OnBtnShareClick = OnBtnShareClick
UIKillZombieBoxUpgradeView.OnEmptyClick = OnEmptyClick
UIKillZombieBoxUpgradeView.OnSkipBtnClick = OnSkipBtnClick
UIKillZombieBoxUpgradeView.DoLocalMoveAuto = DoLocalMoveAuto
UIKillZombieBoxUpgradeView.DoMoveOutTween = DoMoveOutTween
UIKillZombieBoxUpgradeView.ClearTween = ClearTween
return UIKillZombieBoxUpgradeView
