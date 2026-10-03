local UIChampionDuelBattleLogGroup = BaseClass("UIChampionDuelBattleLogGroup", UIBaseContainer)
local base = UIBaseContainer
local UIChampionDuelBattleLogItem = require("UI.UIChampionDuel.BattleLog.Component.UIChampionDuelBattleLogItem")
local type_path = "Type"
local text_type_path = "Type/TypeText"
local top_path = "Top"
local btn_top_path = "Top/Btn"
local img_arrow_path = "Top/Btn/Arrow"
local text_score_path = "Top/ScoreText"
local text_name_left_path = "Top/NameLeft"
local text_name_right_path = "Top/NameRight"
local content_path = "ListContent"
local ARROW_DOWN_RES_PATH = "Assets/Main/Sprites/UI/UILWAlliance/cfm_lianmeng_anniu_xiala_1.png"
local ARROW_UP_RES_PATH = "Assets/Main/Sprites/UI/UILWAlliance/cfm_lianmeng_anniu_xiala_2.png"

function UIChampionDuelBattleLogGroup:OnCreate()
  base.OnCreate(self)
  self.baseItem = nil
  self.items = {}
  self.type_group = self:AddComponent(UIBaseContainer, type_path)
  self.text_type = self:AddComponent(UIText, text_type_path)
  self.top = self:AddComponent(UIBaseContainer, top_path)
  self.btn_top = self:AddComponent(UIButton, btn_top_path)
  self.btn_top:SetOnClick(BindCallback(self, self.OnTopClick))
  self.img_arrow = self:AddComponent(UIImage, img_arrow_path)
  self.text_score = self:AddComponent(UIText, text_score_path)
  self.text_name_left = self:AddComponent(UIText, text_name_left_path)
  self.text_name_right = self:AddComponent(UIText, text_name_right_path)
  self.content = self:AddComponent(UIBaseContainer, content_path)
end

function UIChampionDuelBattleLogGroup:OnDestroy()
  if self.content then
    self.content:RemoveComponents(UIChampionDuelBattleLogItem)
    for _, v in ipairs(self.content.transform) do
      if v ~= nil then
        CS.UnityEngine.GameObject.Destroy(v.gameObject)
      end
    end
  end
  self.items = {}
  self.baseItem = nil
  self.type_group = nil
  self.text_type = nil
  self.top = nil
  self.btn_top = nil
  self.img_arrow = nil
  self.text_score = nil
  self.text_name_left = nil
  self.text_name_right = nil
  self.content = nil
  base.OnDestroy(self)
end

function UIChampionDuelBattleLogGroup:ReInit(logs, item, targetUid, bNewType, cb)
  if table.IsNullOrEmpty(logs) then
    self:SetActive(false)
    return
  end
  self:SetActive(true)
  self.logs = logs
  self.baseItem = item
  self.targetUid = targetUid
  self.cb = cb
  self.showList = false
  local firstLog = logs[1]
  local stageId = firstLog.stageId
  self.type_group:SetActive(bNewType)
  if bNewType then
    local keyStr = DataCenter.ChampionDuelManager:GetStageStrKey(stageId)
    self.text_type:SetLocalText(keyStr)
  end
  if stageId == ChampionDuelState.PreStage then
    self.top:SetActive(false)
    self:OnTopClick()
    return
  end
  self.top:SetActive(true)
  local scoreL = 0
  local scoreR = 0
  for _, log in ipairs(logs) do
    if log.isWin then
      scoreL = scoreL + 1
    else
      scoreR = scoreR + 1
    end
  end
  local myUid = firstLog.my ~= nil and firstLog.my.uid or nil
  local bSelf = firstLog.attacker == myUid
  local bWin = firstLog.isWin
  if not bSelf then
    bWin = not firstLog.isWin
  end
  local leftInfo = bSelf and firstLog.my or firstLog.target
  local rightInfo = bSelf and firstLog.target or firstLog.my
  if not bSelf then
    local tmpScore = scoreL
    scoreL = scoreR
    scoreR = tmpScore
  end
  self.text_score:SetText(CommonUtil.IsArabicAutoMirrorOpen() and scoreR .. ":" .. scoreL or scoreL .. ":" .. scoreR)
  leftInfo:SetNameShow(self.text_name_left)
  rightInfo:SetNameShow(self.text_name_right)
  self.img_arrow:LoadSpriteAuto(ARROW_DOWN_RES_PATH)
  self.content:SetActive(false)
end

function UIChampionDuelBattleLogGroup:RefreshList()
  local maxNum = math.max(#self.logs, self.content.transform.childCount)
  for i = 1, maxNum do
    local info = self.logs[i]
    local name = "item" .. i
    local cell = self.content.transform:Find(name)
    local item = self.content:GetComponent(name, UIChampionDuelBattleLogItem)
    if info ~= nil then
      if cell == nil then
        cell = self.baseItem:GameObjectSpawn(self.content.transform)
        cell.name = name
      end
      if item == nil then
        item = self.content:AddComponent(UIChampionDuelBattleLogItem, name)
      end
      item:SetActive(true)
      item:ReInit(info, self.targetUid)
    elseif item ~= nil then
      item:SetActive(false)
    end
  end
end

function UIChampionDuelBattleLogGroup:OnTopClick()
  self.showList = not self.showList
  self.content:SetActive(self.showList)
  local path = self.showList and ARROW_UP_RES_PATH or ARROW_DOWN_RES_PATH
  self.img_arrow:LoadSpriteAuto(path)
  if self.showList then
    self:RefreshList()
  end
  CS.UnityEngine.UI.LayoutRebuilder.ForceRebuildLayoutImmediate(self.content.rectTransform)
  CS.UnityEngine.UI.LayoutRebuilder.ForceRebuildLayoutImmediate(self.rectTransform)
  if self.showList and self.cb then
    self.cb()
  end
end

return UIChampionDuelBattleLogGroup
