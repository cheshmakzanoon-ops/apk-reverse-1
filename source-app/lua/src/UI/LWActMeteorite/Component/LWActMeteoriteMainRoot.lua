local base = require("UI.UIRaceEntrance.Component.ActDownloadNodeBase")
local LWActMeteoriteMainRoot = BaseClass("LWActMeteoriteMainRoot", base)
local Resource = CS.GameEntry.Resource
local LWActMeteoriteSchedule = require("UI.LWActMeteorite.Component.LWActMeteoriteSchedule")
local LWActMeteoriteRank = require("UI.LWActMeteorite.Component.LWActMeteoriteRank")
local center_path = "Center"
local text_coin_path = "Coin/TextCoin"
local base_toggle_path = "TogView/Content/Toggle"
local content_base_path = "Assets/Main/Prefabs/UI/LWUIActMeteorite/%s.prefab"
local contents_info = {
  {
    key = "schedule",
    class = LWActMeteoriteSchedule,
    prefab = "LWActMeteoriteSchedule"
  },
  {
    key = "alliance",
    class = LWActMeteoriteRank,
    prefab = "LWActMeteoriteRank"
  },
  {
    key = "person",
    class = LWActMeteoriteRank,
    prefab = "LWActMeteoriteRank"
  }
}

function LWActMeteoriteMainRoot:OnCreate()
  base.OnCreate(self)
  self.curIdx = 0
  self.contents = {}
  self.requests = {}
  self.toggles = {}
  self.center = self:AddComponent(UIBaseContainer, center_path)
  for i = 1, 3 do
    local toggle = self:AddComponent(UIToggle, base_toggle_path .. i)
    if i == 1 then
      toggle:SetIsOn(true)
    end
    toggle:SetOnValueChanged(function(tf)
      if tf then
        self:SetOnValueChanged(i)
      end
    end)
    self.toggles[i] = toggle
  end
  self.text_coin = self:AddComponent(UIText, text_coin_path)
end

function LWActMeteoriteMainRoot:OnDestroy()
  self:CurContentHide()
  for _, v in pairs(self.requests) do
    v:Destroy()
    v = nil
  end
  self.requests = {}
  self.text_title = nil
  self.btn_back = nil
  self.text_coin = nil
  self.center = nil
  self.contents = {}
  self.toggles = {}
  base.OnDestroy(self)
end

function LWActMeteoriteMainRoot:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.MeteoriteBattleInfoRefresh, self.UpdateData)
  self:AddUIListener(EventId.MeteoriteBattleScoreUpdate, self.UpdateScore)
  self:AddUIListener(EventId.MeteoriteActMainToggleSet, self.JumpToToggle)
  self:AddUIListener(EventId.OnPassDay, self.OnPassDay)
end

function LWActMeteoriteMainRoot:OnRemoveListener()
  self:RemoveUIListener(EventId.MeteoriteBattleInfoRefresh, self.UpdateData)
  self:RemoveUIListener(EventId.MeteoriteBattleScoreUpdate, self.UpdateScore)
  self:RemoveUIListener(EventId.MeteoriteActMainToggleSet, self.JumpToToggle)
  self:RemoveUIListener(EventId.OnPassDay, self.OnPassDay)
  base.OnRemoveListener(self)
end

function LWActMeteoriteMainRoot:GetActType()
  return EnumActivity.ActMeteorite.Type
end

function LWActMeteoriteMainRoot:OnEnterNode()
end

function LWActMeteoriteMainRoot:CurContentHide()
  if self.curContent then
    self.curContent:SetActive(false)
  end
  self.curContent = nil
  self.curIdx = 0
end

function LWActMeteoriteMainRoot:SetOnValueChanged(idx)
  if self.curIdx == idx then
    return
  end
  if idx == 1 then
    DataCenter.ActMeteoriteBattleManager:ReqGetActInfo()
  end
  self:CurContentHide()
  if self.curContent ~= nil then
    self.curContent:SetActive(false)
  end
  local info = contents_info[idx]
  local key = info.key
  self.curContent = self.contents[key]
  self.curIdx = idx
  if self.curContent ~= nil then
    self.curContent:SetActive(true)
    self:UpdateData()
    return
  end
  if self.requests[key] ~= nil then
    return
  end
  local request = Resource:InstantiateAsync(string.format(content_base_path, info.prefab))
  self.requests[key] = request
  request:completed("+", function(req)
    local _go = req.gameObject
    if req.isError or IsNull(_go) then
      req:Destroy()
      self.requests[key] = nil
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
    _go:SetActive(self.curIdx == idx)
    if self.curIdx == idx then
      self.curContent = newContent
      newContent:SetActive(true)
      self:UpdateData()
    end
  end)
end

function LWActMeteoriteMainRoot:UpdateData()
  if self.activityId == nil then
    return
  end
  if self.curContent ~= nil then
    self.curContent:SetData(self.preValue)
    self.preValue = nil
  else
    self.toggles[1]:SetIsOn(true)
    self:SetOnValueChanged(1)
  end
  self:UpdateScore()
end

function LWActMeteoriteMainRoot:UpdateScore()
  local actInfo = DataCenter.ActMeteoriteBattleManager:GetActInfo() or {}
  local score = actInfo.count or 0
  self.text_coin:SetText(string.GetFormattedStr(score))
end

function LWActMeteoriteMainRoot:JumpToToggle(param)
  if type(param) ~= "table" then
    return
  end
  local idx = param.idx
  if type(idx) ~= "number" or idx ~= 1 and idx ~= 2 and idx ~= 3 then
    return
  end
  self.preValue = param.preValue
  self.toggles[idx]:SetIsOn(true)
  self:SetOnValueChanged(idx)
end

function LWActMeteoriteMainRoot:OnPassDay()
  DataCenter.ActMeteoriteBattleManager:ReqGetActInfo()
end

return LWActMeteoriteMainRoot
