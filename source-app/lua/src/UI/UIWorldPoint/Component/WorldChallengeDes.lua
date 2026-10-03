local RewardItem = require("UI.UIWorldPoint.Component.WorldPointRewardItem")
local WorldChallengeDes = BaseClass("WorldChallengeDes", UIBaseContainer)
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization
local main_obj_path = "BuildInfo"
local des_obj_path = "BuildDetails"
local content_path = "BuildInfo/ScrollView/Viewport/Content"
local time_obj_path = "BuildInfo/time"
local time_txt_path = "BuildInfo/time/timeLabel"
local tips_path = "BuildInfo/tips"
local challenge_txt_path = "BuildInfo/tips/Rect_Challenge/Txt_Challenge"
local challengeName_txt_path = "BuildInfo/tips/Rect_Challenge/Txt_ChallengeName"
local challengeType_txt_path = "BuildInfo/tips/Rect_ChallengeType/Txt_ChallengeType"
local challengeTypeName_txt_path = "BuildInfo/tips/Rect_ChallengeType/Txt_ChallengeTypeName"
local des_txt_path = "BuildDetails/desTxt"
local power_rect_path = "BuildInfo/powerRecommend"
local power_txt_path = "BuildInfo/powerRecommend/Recommend_Power"
local animator_path = ""

local function OnCreate(self)
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

local function OnDestroy(self)
  self:ComponentDestroy()
  self:DataDestroy()
  base.OnDestroy(self)
end

local function OnEnable(self)
  base.OnEnable(self)
end

local function OnDisable(self)
  self:OnReturnClick()
  self:DeleteTimer()
  base.OnDisable(self)
end

local function ComponentDefine(self)
  self.animator = self:AddComponent(UIAnimator, animator_path)
  self.main_obj = self:AddComponent(UIBaseContainer, main_obj_path)
  self.des_obj = self:AddComponent(UIBaseContainer, des_obj_path)
  self.main_obj_canvas = self:AddComponent(UICanvasGroup, main_obj_path)
  self.des_obj_canvas = self:AddComponent(UICanvasGroup, des_obj_path)
  self.main_obj_canvas:SetAlpha(1)
  self.des_obj_canvas:SetAlpha(1)
  self.content = self:AddComponent(UIBaseContainer, content_path)
  self.time_obj = self:AddComponent(UIBaseContainer, time_obj_path)
  self.time_txt = self:AddComponent(UIText, time_txt_path)
  self._challenge_txt = self:AddComponent(UIText, challenge_txt_path)
  self._challengeName_txt = self:AddComponent(UIText, challengeName_txt_path)
  self._challengeType_txt = self:AddComponent(UIText, challengeType_txt_path)
  self._challengeTypeName_txt = self:AddComponent(UIText, challengeTypeName_txt_path)
  self.des_txt = self:AddComponent(UIText, des_txt_path)
  self.power_rect = self:AddComponent(UIBaseContainer, power_rect_path)
  self.power_txt = self:AddComponent(UIText, power_txt_path)
  self.tips_path = self:AddComponent(UIBaseContainer, tips_path)
end

local function ComponentDestroy(self)
  self.btn = nil
  self.btnImage = nil
  self.power_txt = nil
  self.power_rect = nil
end

local function DataDefine(self)
  self.data = nil
  
  function self.timer_action(temp)
    self:RefreshTime()
  end
end

local function DataDestroy(self)
  self.data = nil
end

local function SetAllCellDestroy(self)
  self.content:RemoveComponents(RewardItem)
  if self.model ~= nil then
    for k, v in pairs(self.model) do
      if v ~= nil then
        self:GameObjectDestroy(v)
      end
    end
  end
  self.model = {}
end

local function RefreshData(self, param)
  self.data = param
  self.tips_path:SetActive(true)
  self.power_rect:SetActive(false)
  self.time_obj:SetActive(true)
  self._challenge_txt:SetLocalText(372428)
  self._challengeName_txt:SetText(self.data.ownerName)
  self._challengeType_txt:SetLocalText(372429)
  if param.callHelp == 0 then
    self._challengeTypeName_txt:SetLocalText(372430)
  else
    self._challengeTypeName_txt:SetLocalText(372431)
  end
  self:AddTimer()
  self:RefreshTime()
  CS.UnityEngine.UI.LayoutRebuilder.ForceRebuildLayoutImmediate(self.tips_path.rectTransform)
  self:SetAllCellDestroy()
  local list = self.data.rewardStr
  if list ~= nil then
    local num = 0
    for i = 1, table.length(list) do
      num = num + 1
      self.model[i] = self:GameObjectInstantiateAsync(UIAssets.WorldPointRewardItem, function(request)
        if request.isError then
          return
        end
        local go = request.gameObject
        go.gameObject:SetActive(true)
        go.transform:SetParent(self.content.transform)
        go.transform:Set_localScale(ResetScale.x, ResetScale.y, ResetScale.z)
        local nameStr = tostring(NameCount)
        go.name = nameStr
        NameCount = NameCount + 1
        local cell = self.content:AddComponent(RewardItem, nameStr)
        cell:RefreshData(list[i], self.view.ctrl.type)
      end)
    end
  end
end

local function DeleteTimer(self)
  if self.timer ~= nil then
    self.timer:Stop()
    self.timer = nil
  end
end

local function AddTimer(self)
  if self.timer == nil then
    self.timer = TimerManager:GetInstance():GetTimer(1, self.timer_action, self, false, false, false)
  end
  self.timer:Start()
end

local function RefreshTime(self)
  if self.data == nil then
    return
  end
  local curTime = UITimeManager:GetInstance():GetServerTime()
  local deltaTime = self.data.refreshTime - curTime
  if self.data ~= nil and 0 < deltaTime then
    self.time_txt:SetText(UITimeManager:GetInstance():MilliSecondToFmtString(deltaTime))
  else
    self.time_obj:SetActive(false)
    self.time_txt:SetText("")
    self:DeleteTimer()
  end
end

local function OnInfoClick(self)
  self.animator:Enable(true)
  self.animator:Play("switchEnter", 0, 0)
end

local function OnReturnClick(self)
  self.animator:Enable(true)
  self.animator:Play("switchOut", 0, 0)
end

WorldChallengeDes.OnCreate = OnCreate
WorldChallengeDes.OnDestroy = OnDestroy
WorldChallengeDes.OnEnable = OnEnable
WorldChallengeDes.OnDisable = OnDisable
WorldChallengeDes.ComponentDefine = ComponentDefine
WorldChallengeDes.ComponentDestroy = ComponentDestroy
WorldChallengeDes.DataDefine = DataDefine
WorldChallengeDes.DataDestroy = DataDestroy
WorldChallengeDes.AddTimer = AddTimer
WorldChallengeDes.DeleteTimer = DeleteTimer
WorldChallengeDes.RefreshTime = RefreshTime
WorldChallengeDes.RefreshData = RefreshData
WorldChallengeDes.SetAllCellDestroy = SetAllCellDestroy
WorldChallengeDes.OnReturnClick = OnReturnClick
WorldChallengeDes.OnInfoClick = OnInfoClick
return WorldChallengeDes
