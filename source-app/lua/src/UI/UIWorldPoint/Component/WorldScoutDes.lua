local WorldScoutDes = BaseClass("WorldScoutDes", UIAsyncContainer)
local base = UIAsyncContainer
local Localization = CS.GameEntry.Localization
local rapidjson = require("rapidjson")

function WorldScoutDes:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function WorldScoutDes:OnDestroy()
  self:ComponentDestroy()
  self:DataDestroy()
  base.OnDestroy(self)
end

function WorldScoutDes:OnEnable()
  base.OnEnable(self)
end

function WorldScoutDes:OnDisable()
  self:DeleteTimer()
  base.OnDisable(self)
end

function WorldScoutDes:ComponentDefine()
  self.txtTips = self:AddComponent(UIText, "Content/rewardContent/txt_tips")
  self.txtStartTime = self:AddComponent(UIText, "Content/txt_start_time")
  self.txtEndTime = self:AddComponent(UIText, "Content/txt_end_time")
  self.bg = self:AddComponent(UIBaseContainer, "bg")
  self.lineContent = self:AddComponent(UIBaseContainer, "Content/LineContent")
  self.troopPowerContent = self:AddComponent(UIBaseContainer, "Content/troopPowerContent")
  self.troopText = self:AddComponent(UIText, "Content/troopPowerContent/troopIcon/troopText")
  self.powerText = self:AddComponent(UIText, "Content/troopPowerContent/powerIcon/powerText")
  self.detailBtn = self:AddComponent(UIButton, "Content/rewardContent/detailBtn")
  self.detailBtn:SetOnClick(function()
    if self.mailUuid then
      DataCenter.MailDataManager:GetMailInfoByIdInDB(self.mailUuid, function(mailData)
        if mailData then
          UIManager:GetInstance():OpenWindow(UIWindowNames.UILWMailMain, {anim = false}, UIMailOpenType.Detail, self.mailUuid, "WorldPointScout", self.view.ctrl.pointId)
        else
          SFSNetwork.SendMessage(MsgDefines.MailGet, self.mailUuid, "", self.toUser)
        end
      end)
    end
  end)
  self.rewardContent = self:AddComponent(UIBaseContainer, "Content/rewardContent/reward/Viewport/Content")
  self.rewardReqs = {}
end

function WorldScoutDes:ComponentDestroy()
  UIUtil.ClearReward(self.rewardContent, self.rewardReqs)
  self.txtTips = nil
  self.txtStartTime = nil
  self.txtEndTime = nil
  self.rewardReqs = nil
  self.rewardContent = nil
  self.troopText = nil
  self.powerText = nil
end

function WorldScoutDes:DataDefine()
  self.data = nil
  
  function self.timer_action(temp)
    self:RefreshTime()
  end
  
  self.endTime = 0
  self.isUpdate = false
end

function WorldScoutDes:DataDestroy()
  self.data = nil
end

function WorldScoutDes:RefreshData(data)
  self.data = data
  local alData = DataCenter.AllianceBaseDataManager:GetAllianceBaseData()
  if alData then
    if string.IsNullOrEmpty(alData.abbr) then
      self.txtTips:SetText("")
    else
      self.txtTips:SetText("[" .. alData.abbr .. "]")
    end
  else
    self.txtTips:SetText("")
  end
  self.txtStartTime:SetText(UITimeManager:GetInstance():TimeStampToTimeForLocal(self.data.endTime))
  self.isUpdate = false
  local cur_time = UITimeManager:GetInstance():GetServerTime()
  if cur_time < self.data.endTime then
    self.isUpdate = true
    self.endTime = self.data.endTime
    self:AddTimer()
    self:RefreshTime()
  end
  local reward_data = rapidjson.decode(self.data.scoutData) or {}
  local rewards = {}
  if reward_data and reward_data.data then
    for _, v in pairs(reward_data.data) do
      local reward = {}
      reward.type = RewardType.RESOURCE
      reward.value = {}
      reward.value.id = v.id
      if v.newValue then
        reward.value.num = tonumber(v.newValue)
      else
        reward.value.num = v.value
      end
      table.insert(rewards, reward)
    end
    local isShowTroopAndPower = true
    if self.view.ctrl.type == WorldPointUIType.City and self.view.info.pointData.specialType == CS.Protobuf.SpecialType.DetectEvent then
      isShowTroopAndPower = false
    end
    self.troopPowerContent:SetActive(isShowTroopAndPower)
    self.lineContent:SetActive(isShowTroopAndPower)
    self.detailBtn:SetActive(isShowTroopAndPower)
    self.bg.transform:Set_sizeDelta(500, isShowTroopAndPower and 220 or 110)
    self.mailUuid = reward_data.mailUuid
    self.toUser = reward_data.mailToUser
    if reward_data.defendSize then
      self.troopText:SetText(reward_data.defendSize)
    end
    if reward_data.defendTotalPower then
      self.powerText:SetText(string.GetFormattedStr2(reward_data.defendTotalPower))
    end
  end
  UIUtil.RefreshReward(self.rewardContent, self.rewardReqs, rewards)
end

function WorldScoutDes:DeleteTimer()
  if self.timer ~= nil then
    self.timer:Stop()
    self.timer = nil
  end
end

function WorldScoutDes:AddTimer()
  if self.timer == nil then
    self.timer = TimerManager:GetInstance():GetTimer(1, self.timer_action, self, false, false, false)
  end
  self.timer:Start()
end

function WorldScoutDes:RefreshTime()
  if self.isUpdate == true then
    local curTime = UITimeManager:GetInstance():GetServerTime()
    local deltaTime = self.endTime - curTime
    if 0 < deltaTime then
      self.txtEndTime:SetText(UITimeManager:GetInstance():MilliSecondToFmtString(deltaTime))
    end
  end
end

return WorldScoutDes
