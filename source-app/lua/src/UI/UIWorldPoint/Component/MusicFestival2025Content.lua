local MusicFestival2025Content = BaseClass("MusicFestival2025Content", UIBaseContainer)
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization
local RewardItem = require("UI.UIWorldPoint.Component.WorldPointRewardItem")
local partyBgpath = "Assets/Main/Sprites/UI/ActMusicFestival2025WorldShow/wxy_yinyuejie_paidui_tipsdi.png"
local partySphereBgpath = "Assets/Main/Sprites/UI/ActMusicFestival2025WorldShow/wxy_yinyuejie_paidui_tipsdi1.png"
local partySphereIconPath = "Assets/Main/Sprites/UI/ActMusicFestival2025WorldShow/wxy_yinyuejie_paidui_tipsqiu.png"
local partySphereStarPath = "Assets/Main/Sprites/UI/ActMusicFestival2025WorldShow/wxy_yinyuejie_paidui_tipsxingxing.png"
local playing_party_path = "playingParty"
local playing_party_bg_path = "playingParty/partySphereBg"
local party_desc_path = "playingParty/partyDesc"
local party_sphere_icon_path = "playingParty/partySphereIcon"
local party_sphere_star_path = "playingParty/partySphereStar"
local party_detail_path = "playingParty/partyDetail"
local reward_desc_path = "partyRewards/rewardDesc"
local end_time_path = "partyRewards/endTime"
local content_path = "partyRewards/ScrollView/Viewport/Content"

function MusicFestival2025Content:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
end

function MusicFestival2025Content:OnDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function MusicFestival2025Content:ComponentDefine()
  self.root = self:AddComponent(UIBaseContainer, "")
  self.playing_party = self:AddComponent(UIImage, playing_party_path)
  self.playing_party_bg = self:AddComponent(UIImage, playing_party_bg_path)
  self.party_sphere_icon = self:AddComponent(UIImage, party_sphere_icon_path)
  self.party_sphere_star = self:AddComponent(UIImage, party_sphere_star_path)
  self.party_desc = self:AddComponent(UITextMeshProUGUIEx, party_desc_path)
  self.reward_desc = self:AddComponent(UITextMeshProUGUIEx, reward_desc_path)
  self.end_time = self:AddComponent(UITextMeshProUGUIEx, end_time_path)
  self.content = self:AddComponent(UIBaseContainer, content_path)
  self.party_detail = self:AddComponent(UIButton, party_detail_path)
  self.party_detail:SetOnClick(function()
    self:OnBtnDetail()
  end)
end

function MusicFestival2025Content:ComponentDestroy()
  self.playing_party = nil
  self.playing_party_bg = nil
  self.party_desc = nil
  self.party_sphere_icon = nil
  self.party_sphere_star = nil
  self.party_detail = nil
  self.reward_desc = nil
  self.end_time = nil
  self.content = nil
end

function MusicFestival2025Content:OnAddListener()
  base.OnAddListener(self)
end

function MusicFestival2025Content:OnRemoveListener()
  base.OnRemoveListener(self)
end

function MusicFestival2025Content:Refresh(data)
  self.data = data
  self.expiredTime, self.statusId, self.pointIndex, self.remainingNum = self:GetShowMusicFestival2025Data(self.data)
  self:SetImgAndText()
  self:Update1000MS()
  self:ShowReward()
end

function MusicFestival2025Content:SetImgAndText()
  self.playing_party:LoadSprite(partyBgpath)
  self.playing_party_bg:LoadSprite(partySphereBgpath)
  self.party_sphere_icon:LoadSprite(partySphereIconPath)
  self.party_sphere_star:LoadSprite(partySphereStarPath)
  self.party_desc:SetText(Localization:GetString("activity_concert_26"))
  self.reward_desc:SetText(Localization:GetString("activity_concert_27"))
end

function MusicFestival2025Content:Update1000MS()
  if self.expiredTime == nil then
    return
  end
  local curTime = UITimeManager:GetInstance():GetServerTime()
  local leftTime = self.expiredTime - curTime
  if leftTime < 0 then
    leftTime = 0
    self:SetActive(false)
  end
  local countDownTimeStr = UITimeManager:GetInstance():MilliSecondToFmtString(leftTime)
  self.end_time:SetText(Localization:GetString("activity_concert_28", countDownTimeStr))
end

function MusicFestival2025Content:ShowReward()
  self.concertConfig = DataCenter.ActConcertDataManager:GetConcertConfigByStatusId(self.statusId)
  local bubbleReward = self.concertConfig.bubble_reward
  if string.IsNullOrEmpty(bubbleReward) then
    Logger.LogError("\233\159\179\228\185\144\232\138\130  \233\133\141\231\189\174\232\175\187\229\143\150\233\148\153\232\175\175")
    return
  end
  local line = LocalController:instance():getLine(TableName.RewardConfig, bubbleReward)
  if line == nil then
    Logger.LogError("\233\159\179\228\185\144\232\138\130  \233\133\141\231\189\174\232\175\187\229\143\150\233\148\153\232\175\175")
    return result
  end
  self:SetAllCellDestroy()
  self.showRewardDataList = {}
  local itemValues = line:getValue("item") or ""
  local numValues = line:getValue("num") or ""
  if not string.IsNullOrEmpty(itemValues) and not string.IsNullOrEmpty(numValues) then
    local ids = string.split(itemValues, ";")
    local nums = string.split(numValues, ";")
    if ids ~= nil and 0 < #ids then
      for i, id in pairs(ids) do
        local oneData = {}
        oneData.itemId = id
        oneData.count = nums[i] or 0
        oneData.rewardType = RewardType.GOODS
        table.insert(self.showRewardDataList, oneData)
      end
    end
  end
  self:AddRewardToContainer(self.showRewardDataList, self.content)
end

function MusicFestival2025Content:SetAllCellDestroy()
  self.content:RemoveComponents(RewardItem)
  if self.model ~= nil then
    for k, v in pairs(self.model) do
      if v then
        for key, value in pairs(v) do
          if v ~= nil then
            self:GameObjectDestroy(value)
          end
        end
      end
    end
  end
  self.model = {}
end

function MusicFestival2025Content:AddRewardToContainer(list, container)
  if list ~= nil and container then
    container:RemoveComponents(RewardItem)
    if self.model[container] then
      for _, v in pairs(self.model[container]) do
        if v ~= nil then
          v:Destroy()
        end
      end
    end
    self.model = {}
    self.model[container] = {}
    local num = 0
    for i = 1, table.length(list) do
      num = num + 1
      self.model[container][i] = self:GameObjectInstantiateAsync(UIAssets.WorldPointRewardItem, function(request)
        if request.isError then
          return
        end
        local go = request.gameObject
        go.gameObject:SetActive(true)
        go.transform:SetParent(container.transform)
        go.transform:Set_localScale(ResetScale.x, ResetScale.y, ResetScale.z)
        go.transform:Set_sizeDelta(150, 150)
        go.transform:Set_pivot(0, 1)
        local nameStr = tostring(NameCount)
        go.name = nameStr
        NameCount = NameCount + 1
        local cell = container:AddComponent(RewardItem, nameStr)
        cell:RefreshData(list[i], self.view.ctrl.type)
      end)
    end
  end
end

function MusicFestival2025Content:GetShowMusicFestival2025Data(data)
  if IsNull(data) then
    return nil
  end
  local status = data.status
  if status == nil then
    return nil
  end
  for i = 1, status.Count do
    local v = status[i - 1]
    local id = v.Id
    local expireTime = v.ExpireTime
    local statueType2 = DataCenter.StatusManager:GetStatusType2(id)
    if statueType2 == StatusType2.MusicFestival2025_RewardBubble then
      return expireTime, id, data.pointIndex, v.Layer
    end
  end
  Logger.LogError("\233\159\179\228\185\144\232\138\130  MusicFestival2025Content \230\149\176\230\141\174\229\136\157\229\167\139\229\140\150\229\164\177\232\180\165")
  return nil
end

function MusicFestival2025Content:IsShowMusicFestival2025Content(data)
  local status = data.status
  if status == nil then
    return false
  end
  if BattleFieldUtil.InBattleField() then
    return false
  end
  for i = 1, status.Count do
    local v = status[i - 1]
    local id = v.Id
    local expireTime = v.ExpireTime
    local statueType2 = DataCenter.StatusManager:GetStatusType2(id)
    if statueType2 == StatusType2.MusicFestival2025_RewardBubble then
      local curTime = UITimeManager:GetInstance():GetServerTime()
      if expireTime < curTime then
        return false
      end
      local remainingNum = v.Layer
      if 0 < remainingNum then
        return true
      end
    end
  end
  return false
end

function MusicFestival2025Content:OnBtnDetail()
  local curServerId = LuaEntry.Player:GetCurServerId()
  local info = CS.SceneManager.World:GetPointInfo(self.pointIndex)
  if info == nil then
    return
  else
    curServerId = info.serverId
  end
  local mySourceServerId = LuaEntry.Player:GetSourceServerId()
  if curServerId ~= nil and curServerId ~= mySourceServerId then
    UIUtil.ShowTipsId("activity_concert_67")
    return
  end
  local isShow = self:IsShowMusicFestival2025Content(info)
  if isShow then
    local maxClaimCount = self:GetMaxClaimCount(self.statusId)
    local param = {
      concertConfig = self.concertConfig,
      ownerUid = self.view.ctrl.ownerUid,
      expiredTime = self.expiredTime,
      statusId = self.statusId,
      remainingNum = self.remainingNum,
      maxClaimCount = maxClaimCount
    }
    UIManager:GetInstance():OpenWindow(UIWindowNames.UILWActConcertRewardRecord, {anim = true}, param)
  else
    UIUtil.ShowTipsId("activity_concert_2_3")
  end
end

function MusicFestival2025Content:GetMaxClaimCount(statusId)
  local statusInfo = LocalController:instance():getLine(TableName.StatusTab, tonumber(statusId))
  if statusInfo == nil or not statusInfo.max_layer then
    Logger.LogError("\233\159\179\228\185\144\232\138\130  \233\133\141\231\189\174\232\175\187\229\143\150\233\148\153\232\175\175")
  end
  return tonumber(statusInfo.max_layer)
end

return MusicFestival2025Content
