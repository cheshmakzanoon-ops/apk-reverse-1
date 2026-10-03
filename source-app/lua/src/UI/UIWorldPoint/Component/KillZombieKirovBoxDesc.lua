local KillZombieKirovBoxDesc = BaseClass("KillZombieKirovBoxDesc", UIBaseContainer)
local KillZombieActivityALKirovReward = require("UI.UIActivityCenterTable.Component.KillZombie.AllianceKirov.KillZombieActivityALKirovReward")
local base = UIBaseContainer
local tonumber = _ENV.tonumber
local btn_detail_path = "Top/btn_detail"
local name_text_path = "Top/NameText"
local btn_share_season_path = "Top/btns/Btn_share_season"
local btn_mark_season_path = "Top/btns/Btn_mark_season"
local possi_text_path = "RewardInfo/possi_text"
local al_challenge_progress_group_path = "info/AlChallengeProgressGroup"
local time_label_path = "Top/TimeRoot/Bg/timeLabel"
local divide_path = "info/divide"
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
  self.possi_text = self:AddComponent(UITextMeshProUGUIEx, possi_text_path)
  self.al_challenge_progress_group = self:AddComponent(KillZombieActivityALKirovReward, al_challenge_progress_group_path)
  self.divide = self:AddComponent(UIRawImage, divide_path)
  self.time_label = self:AddComponent(UITextMeshProUGUIEx, time_label_path)
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
  self.possi_text = nil
  self.al_challenge_progress_group = nil
  self.divide = nil
  self.time_label = nil
  self.content:RemoveComponents(UICommonResItem)
  self.reward_item:GameObjectRecycleAll()
  self.reward_item = nil
  self.alliance_text = nil
end

local function DataDefine(self)
  self.possi_text:SetLocalText("challenge_zombie_reward_show")
  self.itemList = {}
end

local function DataDestroy(self)
  self.power = nil
  self.itemList = nil
end

local function OnAddListener(self)
  base.OnAddListener(self)
end

local function OnRemoveListener(self)
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
end

local function OnDetailClick(self)
  if self.info == nil or self.ctrl.type == WorldPointUIType.KillZombieKirovBoss then
  end
end

local function RefreshData(self, data)
  if data then
    local info = CS.SceneManager.World:GetPointInfoByUuid(data.uuid)
    if info and info.treasurePointInfo then
      local treasurePointInfo = info.treasurePointInfo
      if treasurePointInfo then
        self.endTime = treasurePointInfo.endTime or 0
        if treasurePointInfo.configId and 0 < treasurePointInfo.configId then
          local bossId = GetTableData(TableName.activity_challenge_zombie, treasurePointInfo.configId, "advanced_challenge_boss")
          if not string.IsNullOrEmpty(bossId) then
            self.divide:SetActive(false)
            self.al_challenge_progress_group:RefreshView(bossId, nil, treasurePointInfo.allianceDamage)
            local template = DataCenter.AdvancedChallengeBossTemplateManager:GetTemplate(bossId)
            local rewardStr = template and template.box_reward_show
            self:RefreshRewardList(rewardStr)
          end
        end
        self.alliance_text:SetLocalText("challenge_zombie_box_title_alliance", treasurePointInfo.allianceAbbr, treasurePointInfo.allianceName)
      end
    end
    self.name_text:SetLocalText(data.name)
  end
end

local function RefreshRewardList(self, rewardStr)
  if not string.IsNullOrEmpty(rewardStr) then
    local groupArr = string.split(rewardStr, "|")
    local showList = {}
    for _, v in ipairs(groupArr) do
      if v then
        local arr = string.split(v, ";")
        if arr and 3 <= #arr then
          local item = {
            rewardType = tonumber(arr[2]),
            itemId = tonumber(arr[1]),
            count = tonumber(arr[3])
          }
          table.insert(showList, item)
        end
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

KillZombieKirovBoxDesc.OnCreate = OnCreate
KillZombieKirovBoxDesc.OnDestroy = OnDestroy
KillZombieKirovBoxDesc.OnEnable = OnEnable
KillZombieKirovBoxDesc.OnDisable = OnDisable
KillZombieKirovBoxDesc.ComponentDefine = ComponentDefine
KillZombieKirovBoxDesc.ComponentDestroy = ComponentDestroy
KillZombieKirovBoxDesc.DataDefine = DataDefine
KillZombieKirovBoxDesc.DataDestroy = DataDestroy
KillZombieKirovBoxDesc.OnAddListener = OnAddListener
KillZombieKirovBoxDesc.OnRemoveListener = OnRemoveListener
KillZombieKirovBoxDesc.AddTimer = AddTimer
KillZombieKirovBoxDesc.RemoveTimer = RemoveTimer
KillZombieKirovBoxDesc.RefreshTime = RefreshTime
KillZombieKirovBoxDesc.OnDetailClick = OnDetailClick
KillZombieKirovBoxDesc.RefreshData = RefreshData
KillZombieKirovBoxDesc.RefreshRewardList = RefreshRewardList
KillZombieKirovBoxDesc.RefreshReward = RefreshReward
KillZombieKirovBoxDesc.InitList = InitList
return KillZombieKirovBoxDesc
