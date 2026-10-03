local base = UIAsyncContainer
local UIActEpidemicMainCompFighting = BaseClass("UIActEpidemicMainCompFighting", base)
local Localization = CS.GameEntry.Localization

local function OnCreate(self, mainView)
  base.OnCreate(self)
  self.mainView = mainView
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
end

local function ComponentDefine(self)
  self.textTmpTitle = self:AddComponent(UITextMeshProUGUIEx, "tmpTitle")
  self.textTmpCountdown = self:AddComponent(UITextMeshProUGUIEx, "tmpCountdown")
  self.imgFlag00 = self:AddComponent(UIImage, "left/imgFlag00")
  self.textTmpAllianceName00 = self:AddComponent(UITextMeshProUGUIEx, "left/tmpAllianceName00")
  self.textTmpScore0 = self:AddComponent(UITextMeshProUGUIEx, "left/tmpScore0")
  self.textTmpMember0 = self:AddComponent(UITextMeshProUGUIEx, "left/tmpMember0")
  self.imgScore0 = self:AddComponent(UIImage, "left/tmpScore0/imgScore0")
  self.imgFlag10 = self:AddComponent(UIImage, "right/imgFlag10")
  self.imgFlag11 = self:AddComponent(UIImage, "right/imgFlag11")
  self.textTmpAllianceName10 = self:AddComponent(UITextMeshProUGUIEx, "right/tmpAllianceName10")
  self.textTmpAllianceName11 = self:AddComponent(UITextMeshProUGUIEx, "right/tmpAllianceName11")
  self.imgScore1 = self:AddComponent(UIImage, "right/tmpScore1/imgScore1")
  self.textTmpScore1 = self:AddComponent(UITextMeshProUGUIEx, "right/tmpScore1")
  self.textTmpMember1 = self:AddComponent(UITextMeshProUGUIEx, "right/tmpMember1")
  self.compLeft = self:AddComponent(UIBaseComponent, "left")
  self.compRight = self:AddComponent(UIBaseComponent, "right")
  self.roleRenderers = {}
  self.roleRenderers[1] = {
    name = self.textTmpAllianceName00,
    flag = self.imgFlag00
  }
  self.roleRenderers[2] = {
    name = self.textTmpAllianceName10,
    flag = self.imgFlag10
  }
  self.roleRenderers[3] = {
    name = self.textTmpAllianceName11,
    flag = self.imgFlag11
  }
  self.currentGroup = nil
  self.lastRequestTime = 0
end

local function ComponentDestroy(self)
  self.textTmpTitle = nil
  self.textTmpCountdown = nil
  self.imgFlag00 = nil
  self.textTmpAllianceName00 = nil
  self.textTmpScore0 = nil
  self.textTmpMember0 = nil
  self.imgScore0 = nil
  self.imgFlag10 = nil
  self.imgFlag11 = nil
  self.textTmpAllianceName10 = nil
  self.textTmpAllianceName11 = nil
  self.imgScore1 = nil
  self.textTmpScore1 = nil
  self.textTmpMember1 = nil
  self.compLeft = nil
  self.compRight = nil
  self.roleRenderers = nil
  self.currentGroup = nil
end

local function DataDefine(self)
end

local function DataDestroy(self)
end

local function OnAddListener(self)
  base.OnAddListener(self)
  self:AddUIListener(EventId.EpidemicActBattleScoreUpdate, self.RefreshScore)
end

local function OnRemoveListener(self)
  self:RemoveUIListener(EventId.EpidemicActBattleScoreUpdate, self.RefreshScore)
  base.OnRemoveListener(self)
end

function UIActEpidemicMainCompFighting:Show()
  self:SetActive(true)
  if not self:AsyncLoadDone() then
    return
  end
  local currentGroup = self.mainView:GetGroupIndex()
  if currentGroup ~= self.currentGroup then
    self.currentGroup = currentGroup
    local roles = self.mainView and self.mainView:GetCurrentGroupRoles() or nil
    if not roles or #roles <= 0 then
      self:SetEmpty()
      return
    end
    self.compLeft:SetActive(true)
    self.compRight:SetActive(true)
    local _ = {}
    if roles then
      for k, v in ipairs(roles) do
        _[v.side] = v
      end
    end
    for k, v in ipairs(self.roleRenderers) do
      local roleInfo = _[k]
      local name = v.name
      local flag = v.flag
      local flagIcon = roleInfo and roleInfo.icon or 0
      if roleInfo then
        name:SetActive(true)
        name:SetText(string.format("[%s]", roleInfo.abbr or ""))
        name:SetColor(roleInfo.oneself and ActEpidemicUtils.GetMyColor() or ActEpidemicUtils.GetOtherColor())
      else
        name:SetActive(false)
      end
      flag:SetActive(true)
      flag:LoadSpriteAuto(string.format(AL_FLAG_SPRITE_PATH, flagIcon))
    end
  end
  self:RequestScore()
  self:RefreshCountdown()
  self:RefreshScoreAndMembers()
  local currentState = self.mainView:GetCurrentActStage()
  if currentState == EpidemicZoneStage.Prepare then
    self.textTmpTitle:SetLocalText("YiBianJinQu_event_tips_5")
  elseif currentState == EpidemicZoneStage.Battle then
    self.textTmpTitle:SetLocalText("YiBianJinQu_event_tips_6")
  end
end

function UIActEpidemicMainCompFighting:SetEmpty()
  self.compLeft:SetActive(false)
  self.compRight:SetActive(false)
  for k, v in ipairs(self.roleRenderers) do
    local name = v.name
    local flag = v.flag
    name:SetActive(false)
    flag:SetActive(false)
  end
end

function UIActEpidemicMainCompFighting:Hide()
  self:SetActive(false)
  if not self:AsyncLoadDone() then
    return
  end
end

local autoRequestGap = 10

function UIActEpidemicMainCompFighting:Update1000MS()
  if self.timeUpdate then
    self:RefreshCountdown()
    local currentTimeSec = UITimeManager:GetInstance():GetServerSeconds()
    if currentTimeSec - self.lastRequestTime > autoRequestGap then
      self:RequestScore()
    end
  end
end

function UIActEpidemicMainCompFighting:RefreshCountdown()
  local curTime = UITimeManager:GetInstance():GetServerTime()
  local actInfo = ActEpidemicUtils.GetActInfo()
  local remainMs = 0
  if actInfo == nil then
    remainMs = 0
  else
    local endTime = actInfo.stageEndTime * 1000
    remainMs = endTime - curTime
  end
  if remainMs <= 0 then
    self.timeUpdate = false
    self.textTmpCountdown:SetText("-")
    self:RequestScore()
  else
    local txt = UITimeManager:GetInstance():MilliSecondToFmtString(remainMs)
    self.timeUpdate = true
    self.textTmpCountdown:SetText(txt)
  end
end

function UIActEpidemicMainCompFighting:RefreshScoreAndMembers()
  self.textTmpScore0:SetText(0)
  self.textTmpScore1:SetText(0)
  local _, memberLimit = DataCenter.ActEpidemicZoneManager:GetBattleMemberLimitCount()
  self.textTmpMember0:SetText(string.format("%s/%s", 0, memberLimit))
  self.textTmpMember1:SetText(string.format("%s/%s", 0, memberLimit * 2))
end

function UIActEpidemicMainCompFighting:RefreshScore()
  local groupInfo = ActEpidemicUtils.GetGroup(self.currentGroup)
  if not groupInfo then
    self.compLeft:SetActive(false)
    self.compRight:SetActive(false)
    return
  end
  self.compLeft:SetActive(true)
  self.compRight:SetActive(true)
  local _, memberLimit = DataCenter.ActEpidemicZoneManager:GetBattleMemberLimitCount()
  local lord = groupInfo.lordBattleInfo
  local farm = groupInfo.farmerBattleInfo
  self.textTmpScore0:SetText(string.GetFormattedStr(lord and lord.score or 0))
  self.textTmpScore1:SetText(string.GetFormattedStr(farm and farm.score or 0))
  self.textTmpMember0:SetText(string.format("%s/%s", lord and lord.count or 0, memberLimit))
  self.textTmpMember1:SetText(string.format("%s/%s", farm and farm.count or 0, memberLimit * 2))
end

function UIActEpidemicMainCompFighting:RequestScore()
  local stage = self.mainView:GetCurrentActStage()
  if stage ~= EpidemicZoneStage.Battle then
    return
  end
  DataCenter.ActEpidemicZoneManager:ReqBattleScore(self.currentGroup)
  self.lastRequestTime = UITimeManager:GetInstance():GetServerSeconds()
end

UIActEpidemicMainCompFighting.OnCreate = OnCreate
UIActEpidemicMainCompFighting.OnDestroy = OnDestroy
UIActEpidemicMainCompFighting.OnEnable = OnEnable
UIActEpidemicMainCompFighting.OnDisable = OnDisable
UIActEpidemicMainCompFighting.ComponentDefine = ComponentDefine
UIActEpidemicMainCompFighting.ComponentDestroy = ComponentDestroy
UIActEpidemicMainCompFighting.DataDefine = DataDefine
UIActEpidemicMainCompFighting.DataDestroy = DataDestroy
UIActEpidemicMainCompFighting.OnAddListener = OnAddListener
UIActEpidemicMainCompFighting.OnRemoveListener = OnRemoveListener
return UIActEpidemicMainCompFighting
