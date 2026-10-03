local LWActMeteoriteSchedule = BaseClass("LWActMeteoriteSchedule", UIBaseContainer)
local base = UIBaseContainer
local Resource = CS.GameEntry.Resource
local LWActMeteoriteNews = require("UI.LWActMeteorite.Component.Schedule.LWActMeteoriteNews")
local LWActMeteoriteBattle = require("UI.LWActMeteorite.Component.Schedule.LWActMeteoriteBattle")
local LWActMeteoriteShow = require("UI.LWActMeteorite.Component.Schedule.LWActMeteoriteShow")
local LWActMeteoriteReward = require("UI.LWActMeteorite.Component.Schedule.LWActMeteoriteReward")
local LWActMeteoriteStateDi = require("UI.LWActMeteorite.Component.Schedule.LWActMeteoriteStateDi")
local center_path = "Center"
local reward_path = "Reward"
local content_path = "State/Content"
local state_di1_path = "State/StateDi1"
local state_di2_path = "State/StateDi2"
local btn_info_path = "State/BtnInfo"
local content_base_path = "Assets/Main/Prefabs/UI/LWUIActMeteorite/%s.prefab"
local contents_info = {
  {
    key = "news",
    class = LWActMeteoriteNews,
    prefab = "LWActMeteoriteNews"
  },
  {
    key = "battle",
    class = LWActMeteoriteBattle,
    prefab = "LWActMeteoriteBattle"
  },
  {
    key = "show",
    class = LWActMeteoriteShow,
    prefab = "LWActMeteoriteShow"
  }
}

function LWActMeteoriteSchedule:OnCreate()
  base.OnCreate(self)
  self.states = {}
  self.contents = {}
  self.requests = {}
  self.center = self:AddComponent(UIBaseContainer, center_path)
  self.reward = self:AddComponent(LWActMeteoriteReward, reward_path)
  self.stateGroup = self:AddComponent(UIBaseContainer, content_path)
  self.state_di1 = self.transform:Find(state_di1_path).gameObject
  self.state_di1:GameObjectCreatePool()
  self.state_di2 = self.transform:Find(state_di2_path).gameObject
  self.state_di2:GameObjectCreatePool()
  local mgr = DataCenter.ActMeteoriteBattleManager
  local stages = mgr:GetStages()
  local cnt = #stages - 1
  for i = 1, cnt do
    local goItem
    if i == 1 or i == cnt then
      goItem = self.state_di1:GameObjectSpawn(self.stateGroup.transform)
    else
      goItem = self.state_di2:GameObjectSpawn(self.stateGroup.transform)
    end
    goItem.name = "state" .. i
    goItem:SetActive(true)
    local di = self.stateGroup:AddComponent(LWActMeteoriteStateDi, goItem.name)
    self.states[i] = di
    di:SetLocalScaleXYZ(i == cnt and -1 or 1, 1, 1)
  end
  self.btn_info = self:AddComponent(UIButton, btn_info_path)
  self.btn_info:SetOnClick(function()
    DataCenter.LWSoundManager:PlayEffect(SoundAssetId.SFX_UI_General_Click_1st)
    UIManager:GetInstance():OpenWindow(UIWindowNames.LWActMeteoriteGuide)
  end)
end

function LWActMeteoriteSchedule:OnDestroy()
  for _, v in pairs(self.requests) do
    v:Destroy()
    v = nil
  end
  self.state_di1:GameObjectRecycleAll()
  self.state_di2:GameObjectRecycleAll()
  for _, v in ipairs(self.stateGroup.transform) do
    if v ~= nil then
      CS.UnityEngine.GameObject.Destroy(v.gameObject)
    end
  end
  self.center = nil
  self.reward = nil
  self.stateGroup = nil
  self.state_di1 = nil
  self.state_di2 = nil
  self.btn_info = nil
  self.states = {}
  self.requests = {}
  self.contents = {}
  base.OnDestroy(self)
end

function LWActMeteoriteSchedule:SetData()
  local mgr = DataCenter.ActMeteoriteBattleManager
  local actInfo = mgr:GetActInfo()
  local stage = actInfo ~= nil and actInfo.stage or MeteoriteState.MATCH
  local keyIdx = 0
  if stage ~= MeteoriteState.MATCH then
    if stage == MeteoriteState.PREVIEW and mgr:CheckShowNews() then
      keyIdx = 1
    elseif stage == MeteoriteState.SHOW then
      keyIdx = 3
    elseif stage == MeteoriteState.PREVIEW or stage == MeteoriteState.REST or stage == MeteoriteState.GRAB then
      keyIdx = 2
    end
  end
  local showFlag = 1 < keyIdx
  self.stateGroup.transform.parent.gameObject:SetActive(showFlag)
  self.reward:SetActive(showFlag)
  if showFlag then
    local stages = mgr:GetStages()
    local stageId = mgr:GetCurStageId()
    for i, di in ipairs(self.states) do
      di:SetData(i, stageId, stages[i])
    end
    self.reward:SetData()
  end
  if self.curContent then
    self.curContent:SetActive(false)
  end
  self.curContent = nil
  local info = contents_info[keyIdx]
  local key = info ~= nil and info.key or nil
  self.curKey = key
  self:CreateContent(info, function(newContent)
    newContent:SetActive(self.curKey == key)
    if newContent:GetActive() then
      self.curContent = newContent
      newContent:SetData(self)
    end
  end)
  if actInfo == nil then
    DataCenter.ActMeteoriteBattleManager:ReqGetActInfo()
  end
end

function LWActMeteoriteSchedule:CreateContent(info, cb)
  if info == nil then
    return
  end
  local key = info.key
  local content = self.contents[key]
  if content ~= nil then
    if cb then
      cb(content)
    end
    return
  end
  if self.requests[key] ~= nil then
    return
  end
  local request = Resource:InstantiateAsync(string.format(content_base_path, info.prefab))
  self.requests[key] = request
  request:completed("+", function(req)
    local _go = req.gameObject
    if IsNull(_go) then
      return
    end
    CommonUtil.CallAutoArabicMirrorManually(req)
    _go.name = key
    local pTF = _go.transform
    pTF:SetParent(self.center.transform)
    pTF:Set_localScale(1, 1, 1)
    pTF:Set_localPosition(0, 0, 0)
    local newContent = self.center:AddComponent(info.class, key)
    local rect = self.center.rectTransform.rect
    newContent.rectTransform:Set_sizeDelta(rect.width, rect.height)
    newContent.rectTransform:ForceUpdateRectTransforms()
    self.contents[key] = newContent
    if cb then
      cb(newContent)
    else
      newContent:SetActive(false)
    end
  end)
end

return LWActMeteoriteSchedule
