local LWSeasonBossLoginTaskItem = BaseClass("LWSeasonBossLoginTaskItem", UIBaseContainer)
local base = UIBaseContainer
local RewardUtil = require("Util.RewardUtil")
local UIGray = CS.UIGray
local Localization = CS.GameEntry.Localization
local name_text_path = "NormalContent/NameText"
local reward_content_path = "NormalContent/ScrollView/Viewport/RewardContent"
local go_btn_path = "NormalContent/GoBtn"
local btn_text_path = "NormalContent/GoBtn/BtnText"
local finish_path = "NormalContent/finish"
local normal_content_path = "NormalContent"
local lock_content_path = "LockContent"
local cut_down_time_text_path = "LockContent/CutDownTimeText"
local name_bg_path = "NormalContent/NameBg"

function LWSeasonBossLoginTaskItem:OnCreate()
  base.OnCreate(self)
  self.image = self:AddComponent(UIImage, "")
  self.name_text = self:AddComponent(UIText, name_text_path)
  self.content = self:AddComponent(UIBaseContainer, reward_content_path)
  self.go_btn = self:AddComponent(UIButton, go_btn_path)
  self.btn_text = self:AddComponent(UIText, btn_text_path)
  self.finish = self:AddComponent(UIImage, finish_path)
  self.name_bg = self:AddComponent(UIImage, name_bg_path)
  self.go_btn:SetOnClick(function()
    self:OnBtnClick()
  end)
  self.normal_content = self:AddComponent(UIBaseContainer, normal_content_path)
  self.lock_content = self:AddComponent(UIBaseContainer, lock_content_path)
  self.cut_down_time_text = self:AddComponent(UITextMeshProUGUIEx, cut_down_time_text_path)
  self.starImg = self:AddComponent(UIImage, "NormalContent/StarImg")
  self.itemList = {}
  self.itemReqs = {}
end

function LWSeasonBossLoginTaskItem:OnDestroy()
  self:ClearContent()
  self.image = nil
  self.normal_content = nil
  self.lock_content = nil
  self.cut_down_time_text = nil
  self.starImg = nil
  self.name_bg = nil
  base.OnDestroy(self)
end

function LWSeasonBossLoginTaskItem:OnEnable()
  base.OnEnable(self)
  self:AddUIListener(EventId.OnActBossRewardRefresh, self.UpdateData)
end

function LWSeasonBossLoginTaskItem:OnDisable()
  self:RemoveUIListener(EventId.OnActBossRewardRefresh, self.UpdateData)
  base.OnDisable(self)
end

function LWSeasonBossLoginTaskItem:Update1000MS()
  if self.isFake then
    self:RefreshCutDownTime()
  end
end

function LWSeasonBossLoginTaskItem:ClearContent()
  if table.count(self.itemList) > 0 then
    self.content:RemoveComponents(UICommonResItem)
    self.itemList = nil
  end
  if 0 < table.count(self.itemReqs) then
    for _, req in pairs(self.itemReqs) do
      if req ~= nil then
        self:GameObjectDestroy(req)
      end
    end
    self.itemReqs = nil
  end
end

function LWSeasonBossLoginTaskItem:UpdateData(taskId, taskState)
  if self.taskInfo ~= nil and self.taskId == taskId then
    local tempType = {}
    EventManager:GetInstance():Broadcast(EventId.RefreshTopResByPickUp, tempType)
    for i, v in ipairs(self.taskInfo.reward) do
      local rewardType = v.rewardType
      local itemId = v.itemId
      local pic = RewardUtil.GetPic(v.rewardType, itemId)
      local img = self.showList[i].iconImg
      if pic ~= "" and not IsNull(img) then
        UIUtil.DoFly(tonumber(rewardType), 3, pic, img.transform.position, Vector3.New(0, 0, 0))
      end
    end
    self.taskInfo.state = taskState
    EventManager:GetInstance():Broadcast(EventId.OnClaimRewardEffFinish)
    self.go_btn:SetActive(false)
    self.finish:SetActive(true)
  end
end

function LWSeasonBossLoginTaskItem:ReInit(tabIndex, activityId, taskId, taskInfo, isFake)
  self.activityId = activityId
  self.tabIndex = tabIndex
  self.taskId = taskId
  self.taskInfo = taskInfo
  self.isFake = isFake
  self.normal_content:SetActive(not self.isFake)
  self.lock_content:SetActive(self.isFake)
  self.sendMsgMark = false
  if self.isFake then
    self:RefreshCutDownTime()
    return
  end
  if self.tabIndex == 1 then
    self:ReRankInit(taskInfo)
  else
    self:RefreshReward(taskInfo.reward)
    local damageNeedStr = string.GetFormattedSeperatorNum(taskInfo.damage)
    local damageNowStr = string.GetFormattedSeperatorNum(DataCenter.ActBossDataManager.maxDamage)
    local taskNameStr = Localization:GetString(taskInfo.desc, DataCenter.ActBossDataManager.bossName, damageNeedStr)
    if self.tabIndex == 3 then
      damageNowStr = string.GetFormattedSeperatorNum(DataCenter.LWSeasonBossLoginDataManager.maxDamage)
      local config = DataCenter.LWSeasonBossLoginDataManager:GetConfigData()
      if config ~= nil then
        local bossName = GetTableData(LuaEntry.Player:GetABTestTableName(TableName.Monster), config.boss_id_new, "name")
        taskNameStr = Localization:GetString(taskInfo.desc, Localization:GetString(bossName), damageNeedStr)
      end
    end
    if self.tabIndex == 1 then
      self.name_text:SetText(taskNameStr .. " (" .. damageNowStr .. "/" .. damageNeedStr .. ")")
    else
      self.name_text:SetText(taskNameStr .. [[

(]] .. damageNowStr .. "/" .. damageNeedStr .. ")")
    end
  end
  local taskState = taskInfo.state
  if taskState == TaskState.Received then
    self.go_btn:SetActive(false)
    self.finish:SetActive(true)
    self.image:LoadSprite("Assets/Main/Sprites/UI/UIActivityWorldBoss/wxy_bossshanghai_chenjiu01.png")
  elseif taskState == TaskState.CanReceive then
    self.go_btn:SetActive(true)
    self.finish:SetActive(false)
    self.btn_text:SetLocalText("457010")
    UIGray.SetGray(self.go_btn.transform, false, true)
    self.image:LoadSprite("Assets/Main/Sprites/UI/UIActivityWorldBoss/wxy_bossshanghai_chenjiu02.png")
  else
    self.go_btn:SetActive(true)
    self.finish:SetActive(false)
    self.btn_text:SetLocalText("457010")
    UIGray.SetGray(self.go_btn.transform, true, false)
    self.image:LoadSprite("Assets/Main/Sprites/UI/UIActivityWorldBoss/wxy_bossshanghai_chenjiu01.png")
  end
  if self.tabIndex == 1 then
    self.image:LoadSprite("Assets/Main/SeasonRes/S1/Sprites/S1_Pre_Activity/FX_common_40xp.png")
    self.name_bg:SetActive(true)
    self.image:SetColorHex("#CAC0BD")
  else
    self.name_bg:SetActive(false)
    self.image:SetColorHex("#FFFFFF")
  end
  if self.taskInfo then
    if self.taskInfo.progressSpecial and self.taskInfo.progressSpecial == 0 then
      self.starImg:SetActive(true)
    else
      self.starImg:SetActive(false)
    end
  end
end

function LWSeasonBossLoginTaskItem:ReRankInit(taskInfo)
  local taskNameStr = Localization:GetString("activity_s1pre_boss_atk_reward_desc", taskInfo.times)
  local damageNowStr = DataCenter.LWSeasonBossLoginDataManager:GetAttackTimes()
  self.name_text:SetText(taskNameStr .. " (" .. damageNowStr .. "/" .. taskInfo.times .. ")")
  self:RefreshReward(taskInfo.rewards)
  taskInfo.state = DataCenter.LWSeasonBossLoginDataManager:GetRankRewardState(taskInfo.times)
end

function LWSeasonBossLoginTaskItem:RefreshReward(rewardList)
  self.showList = rewardList
  if rewardList == nil then
    for i = 1, #self.itemList do
      local go = self.itemGoList[i]
      if go then
        go:SetActive(false)
      end
    end
    return
  end
  local rewardCount = #rewardList
  local itemCount = #self.itemList
  local itemReqCount = #self.itemReqs
  local count = Mathf.Min(rewardCount, itemCount)
  for i = 1, count do
    local item = self.itemList[i]
    local data = rewardList[i]
    data.rewardType = data.rewardType or data.type
    if type(data.value) == "number" then
      data.count = data.value
    else
      data.itemId = data.itemId
      if data.itemId == nil and data.value ~= nil then
        data.itemId = data.value.id
      end
      data.count = data.count or data.value.num
    end
    item:ReInit(data)
    item.iconImg = item.transform:Find("clickBtn/ItemIcon")
    item:SetActive(true)
  end
  for i = count + 1, itemCount do
    local item = self.itemList[i]
    if item then
      item:SetActive(false)
    end
  end
  for i = itemReqCount + 1, rewardCount do
    self.itemReqs[i] = self:GameObjectInstantiateAsync(UIAssets.UICommonResItem, function(req)
      if req.isError then
        return
      end
      local scale = 1
      local item = req.gameObject
      item.name = "item_" .. i
      item.transform:SetParent(self.content.transform)
      item.transform:Set_sizeDelta(84, 87)
      item.transform:Set_localScale(scale, scale, 1)
      local cell = self.content:AddComponent(UICommonResItem, item.name)
      self.itemList[i] = cell
      if self.showList == nil or self.showList[i] == nil then
        item:SetActive(false)
        return
      end
      local data = self.showList[i]
      data.rewardType = data.rewardType or data.type
      if type(data.value) == "number" then
        data.count = data.value
      else
        data.itemId = data.itemId
        if data.itemId == nil and data.value ~= nil then
          data.itemId = data.value.id
        end
        data.count = data.count or data.value.num
      end
      cell:SetActive(true)
      cell:ReInit(data)
      cell.iconImg = cell.transform:Find("clickBtn/ItemIcon")
    end)
  end
end

function LWSeasonBossLoginTaskItem:OnBtnClick()
  if self.tabIndex == 1 then
    SFSNetwork.SendMessage(MsgDefines.TaskSeasonVirusAttackTime, tonumber(self.taskInfo.times))
  elseif self.tabIndex == 2 then
    SFSNetwork.SendMessage(MsgDefines.UserGetActBossAchievementReward, tostring(self.activityId), tonumber(self.taskId))
  elseif self.tabIndex == 3 then
    SFSNetwork.SendMessage(MsgDefines.TakeSeasonVirusAchievementTask, tonumber(self.taskId))
  end
end

function LWSeasonBossLoginTaskItem:RefreshCutDownTime()
  if self.taskInfo ~= nil then
    local curTime = UITimeManager:GetInstance():GetServerTime()
    local surplusTime = self.taskInfo.damageShowTime - curTime
    if 0 < surplusTime then
      local timeStr = Localization:GetString("worldboss_tips_01", UITimeManager:GetInstance():MilliSecondToFmtString(surplusTime))
      self.cut_down_time_text:SetText(timeStr)
    else
      local timeStr = Localization:GetString("worldboss_tips_01", UITimeManager:GetInstance():MilliSecondToFmtString(0))
      self.cut_down_time_text:SetText(timeStr)
      if not self.sendMsgMark then
        self.sendMsgMark = true
        self.view:OnRefreshWorldBossAchievementShowInfoView()
      end
    end
  end
end

return LWSeasonBossLoginTaskItem
