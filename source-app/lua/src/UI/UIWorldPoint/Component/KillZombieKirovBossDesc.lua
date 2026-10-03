local KillZombieKirovBossDesc = BaseClass("KillZombieKirovBossDesc", UIBaseContainer)
local KillZombieActivityALKirovReward = require("UI.UIActivityCenterTable.Component.KillZombie.AllianceKirov.KillZombieActivityALKirovReward")
local Localization = CS.GameEntry.Localization
local base = UIBaseContainer
local btn_detail_path = "Top/btn_detail"
local name_text_path = "Top/NameText"
local btn_share_season_path = "Top/btns/Btn_share_season"
local btn_mark_season_path = "Top/btns/Btn_mark_season"
local possi_text_path = "RewardInfo/possi_text"
local al_challenge_progress_group_path = "info/AlChallengeProgressGroup"
local hint_text_path = "down/HintText"
local simple_tip_path = "down/simple_tip"
local time_label_path = "down/timeLabel"
local divide_path = "info/divide"
local boss_status_info_path = "BossStatusInfo"
local spe_head_path = "BossStatusInfo/SpeHead"
local tips_text_path = "BossStatusInfo/TipsText"
local time_text_path = "BossStatusInfo/TimeText"
local content_path = "RewardInfo/RewardScroll/Content"
local u_i_common_res_item_path = "RewardInfo/UICommonResItem"
local alliance_text_path = "Top/AllianceText"

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
  self:AddTimer()
end

local function OnDisable(self)
  base.OnDisable(self)
  self:RemoveTimer()
end

local function ComponentDefine(self)
  self.btn_detail = self:AddComponent(UIButton, btn_detail_path)
  self.btn_detail:SetOnClick(function()
    DataCenter.LWSoundManager:PlayEffect(SoundAssetId.SFX_UI_General_Click_1st)
    self:OnDetailClick()
  end)
  self.name_text = self:AddComponent(UITextMeshProUGUIEx, name_text_path)
  self.btn_share_season = self:AddComponent(UIButton, btn_share_season_path)
  self.btn_share_season:SetOnClick(function()
    DataCenter.LWSoundManager:PlayEffect(SoundAssetId.SFX_UI_General_Click_1st)
    self.view:OnShareClick()
  end)
  self.btn_mark_season = self:AddComponent(UIButton, btn_mark_season_path)
  self.btn_mark_season:SetOnClick(function()
    DataCenter.LWSoundManager:PlayEffect(SoundAssetId.SFX_UI_General_Click_1st)
    self.view:OnMarkClick()
  end)
  self.boss_status_info = self:AddComponent(UIImage, boss_status_info_path)
  self.possi_text = self:AddComponent(UITextMeshProUGUIEx, possi_text_path)
  self.al_challenge_progress_group = self:AddComponent(KillZombieActivityALKirovReward, al_challenge_progress_group_path)
  self.divide = self:AddComponent(UIRawImage, divide_path)
  self.hint_text = self:AddComponent(UITextMeshProUGUIEx, hint_text_path)
  self.simple_tip = self:AddComponent(UITextMeshProUGUIEx, simple_tip_path)
  self.time_label = self:AddComponent(UITextMeshProUGUIEx, time_label_path)
  self.spe_head = self:AddComponent(UICommonHead, spe_head_path)
  self.tips_text = self:AddComponent(UITextMeshProUGUIEx, tips_text_path)
  self.time_text = self:AddComponent(UITextMeshProUGUIEx, time_text_path)
  self.reward_item = self.transform:Find(u_i_common_res_item_path).gameObject
  self.reward_item:GameObjectCreatePool()
  self.content = self:AddComponent(UIBaseContainer, content_path)
  self.alliance_text = self:AddComponent(UITextMeshProUGUIEx, alliance_text_path)
end

local function ComponentDestroy(self)
  self.btn_detail = nil
  self.name_text = nil
  self.btn_share_season = nil
  self.btn_mark_season = nil
  self.boss_status_info = nil
  self.possi_text = nil
  self.al_challenge_progress_group = nil
  self.divide = nil
  self.hint_text = nil
  self.simple_tip = nil
  self.time_label = nil
  self.spe_head = nil
  self.tips_text = nil
  self.time_text = nil
  self.content:RemoveComponents(UICommonResItem)
  self.reward_item:GameObjectRecycleAll()
  self.reward_item = nil
  self.alliance_text = nil
end

local function DataDefine(self)
  local power = LuaEntry.DataConfig:TryGetNum("advanced_challenge", "k5", 0)
  self.simple_tip:SetText(tostring(power))
  self.possi_text:SetLocalText("challenge_zombie_reward_show")
  self.itemList = {}
  self.weaknessEndTime = nil
end

local function DataDestroy(self)
  self.power = nil
  self.itemList = nil
  self.weaknessEndTime = nil
end

local function OnAddListener(self)
  base.OnAddListener(self)
  self:AddUIListener(EventId.ChallengeZombieBossMarchInfoRefresh, self.RefreshItem)
end

local function OnRemoveListener(self)
  self:RemoveUIListener(EventId.ChallengeZombieBossMarchInfoRefresh, self.RefreshItem)
  base.OnRemoveListener(self)
end

local function RemoveTimer(self)
  if self.timer ~= nil then
    self.timer:Stop()
    self.timer = nil
  end
end

local function AddTimer(self)
  if self.timer == nil then
    self.timer = TimerManager:GetInstance():GetTimer(1, BindCallback(self, self.RefreshTime), self, false, false, false)
  end
  self.timer:Start()
end

local function RefreshTime(self)
  if self.endTime and self.endTime > 0 then
    local curTs = UITimeManager:GetInstance():GetServerTime()
    local remain = self.endTime - curTs
    if 0 < remain then
      self.time_label:SetText(UITimeManager:GetInstance():MilliSecondToFmtString(remain))
    else
      self.time_label:SetText("")
    end
  end
  if self.weaknessEndTime and 0 < self.weaknessEndTime then
    local curTs = UITimeManager:GetInstance():GetServerTime()
    local remain = self.weaknessEndTime - curTs
    if 0 < remain then
      self.time_text:SetText(UITimeManager:GetInstance():MilliSecondToFmtString(remain))
    else
      self.time_text:SetText("")
    end
  end
end

local function OnDetailClick(self)
  if self.info == nil or self.ctrl.type == WorldPointUIType.KillZombieKirovBoss then
  end
end

local function RefreshData(self, data)
  if data then
    self:RefreshItem(data.uuid)
    local rewardList = data.rewardStr
    self:RefreshRewardList(rewardList)
    local desc = Localization:GetString(data.name)
    self.name_text:SetText("Lv." .. data.level .. " " .. desc)
    self.alliance_text:SetLocalText("challenge_zombie_box_title_alliance", data.allianceAbbr, data.allianceName)
  end
end

local function RefreshItem(self, uuid)
  if uuid then
    self.boss_status_info:SetActive(false)
    local marchInfo = CS.SceneManager.World:GetMarch(uuid)
    if marchInfo then
      local challengeInfo = marchInfo and marchInfo.allianceChallengeInfo
      if challengeInfo then
        self.endTime = challengeInfo.endTime or 0
        local bossId = GetTableData(TableName.activity_challenge_zombie, challengeInfo.configId, "advanced_challenge_boss")
        local template = DataCenter.AdvancedChallengeBossTemplateManager:GetTemplate(bossId)
        local monsterId = template and template.world_monster
        local power = GetTableData(TableName.Monster, monsterId, "recommend_power")
        self.hint_text:SetLocalText("challenge_zombie_recommend_power", power)
        if challengeInfo.configId and bossId then
          self.divide:SetActive(false)
          self.al_challenge_progress_group:RefreshView(bossId, nil, challengeInfo.allianceDamage)
        end
        if challengeInfo.curStatus == ChallengeZombieAlBossStatus.Weakness then
          if monsterId then
            local picName = GetTableData(TableName.Monster, monsterId, "pic_name")
            picName = LoadPath.HeroIconsSmallPath .. picName .. ".png"
            self.spe_head:SetHead("", picName, "")
          end
          self.boss_status_info:SetActive(true)
          local allianceDamageMax = challengeInfo.allianceDamageMax
          if allianceDamageMax then
            self.weaknessEndTime = self.endTime
            self.tips_text:SetLocalText("challenge_zombie_boss_state_stun")
          else
            self.weaknessEndTime = challengeInfo.statusEndTime
            local name = Localization:GetString("challenge_zombie_box_title_alliance", challengeInfo.abbr, challengeInfo.name)
            self.tips_text:SetLocalText("challenge_zombie_boss_state_weaken", name)
          end
        else
          self.boss_status_info:SetActive(false)
          self.weaknessEndTime = 0
        end
      end
    end
  end
end

local function RefreshRewardList(self, rewardList)
  if rewardList then
    local showList = {}
    for _, v in ipairs(rewardList) do
      if v then
        local item = {
          rewardType = v.rewardType,
          itemId = v.itemId,
          count = v.count
        }
        table.insert(showList, item)
      end
    end
    self:RefreshReward(showList)
  end
end

local function RefreshReward(self, rewardList)
  if not table.IsNullOrEmpty(rewardList) then
    if self.itemList and #self.itemList > 0 then
      local itemCount = #self.itemList
      local index = 0
      for i, v in ipairs(rewardList) do
        if i > itemCount then
          local item = self.reward_item:GameObjectSpawn(self.content.transform)
          local name = tostring(i)
          item.name = name
          local cell = self.content:AddComponent(UICommonResItem, name)
          cell:ReInit(v)
          cell:SetActive(true)
          table.insert(self.itemList, cell)
        else
          local cell = self.itemList[i]
          if cell then
            cell:ReInit(v)
            cell:SetActive(true)
          end
        end
        index = i
      end
      if itemCount > index then
        for i = index + 1, itemCount do
          local cell = self.itemList[i]
          if cell then
            cell:SetActive(false)
          end
        end
      end
    else
      self:InitList(rewardList)
    end
  end
end

local function InitList(self, rewardList)
  if rewardList then
    local name
    for i, v in ipairs(rewardList) do
      local item = self.reward_item.gameObject:GameObjectSpawn(self.content.transform)
      name = tostring(i)
      item.name = name
      local cell = self.content:AddComponent(UICommonResItem, name)
      cell:ReInit(v)
      table.insert(self.itemList, cell)
    end
  end
end

KillZombieKirovBossDesc.OnCreate = OnCreate
KillZombieKirovBossDesc.OnDestroy = OnDestroy
KillZombieKirovBossDesc.OnEnable = OnEnable
KillZombieKirovBossDesc.OnDisable = OnDisable
KillZombieKirovBossDesc.ComponentDefine = ComponentDefine
KillZombieKirovBossDesc.ComponentDestroy = ComponentDestroy
KillZombieKirovBossDesc.DataDefine = DataDefine
KillZombieKirovBossDesc.DataDestroy = DataDestroy
KillZombieKirovBossDesc.OnAddListener = OnAddListener
KillZombieKirovBossDesc.OnRemoveListener = OnRemoveListener
KillZombieKirovBossDesc.AddTimer = AddTimer
KillZombieKirovBossDesc.RemoveTimer = RemoveTimer
KillZombieKirovBossDesc.RefreshTime = RefreshTime
KillZombieKirovBossDesc.OnDetailClick = OnDetailClick
KillZombieKirovBossDesc.RefreshData = RefreshData
KillZombieKirovBossDesc.RefreshRewardList = RefreshRewardList
KillZombieKirovBossDesc.RefreshReward = RefreshReward
KillZombieKirovBossDesc.InitList = InitList
KillZombieKirovBossDesc.RefreshItem = RefreshItem
return KillZombieKirovBossDesc
