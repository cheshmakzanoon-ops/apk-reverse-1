local UIMonsterInvasionRecordItem = BaseClass("UIMonsterInvasionRecordItem", UIBaseContainer)
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization
local UIGray = CS.UIGray
local text_path = "text"
local uiPlayerHead_path = "headContent/UIPlayerHead/HeadIcon"
local timeText_path = "timeText"
local RecordType = {
  Call = 1,
  Reward = 2,
  SummonAisilla = 3,
  KillAisilla = 4,
  MissAisilla = 5
}

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

local function ComponentDefine(self)
  self.text = self:AddComponent(UIText, text_path)
  self.uiPlayerHead = self:AddComponent(UIPlayerHead, uiPlayerHead_path)
  self.timeText = self:AddComponent(UIText, timeText_path)
end

local function ComponentDestroy(self)
  self.text = nil
  self.uiPlayerHead = nil
  self.timeText = nil
end

local function DataDefine(self)
end

local function DataDestroy(self)
end

local function SetData(self, data, actId)
  self.data = data
  local name = DataCenter.PlayerInfoDataManager:GetRemarkOrRealName(self.data.uid, self.data.name)
  if not string.IsNullOrEmpty(self.data.abbr) then
    name = string.format("[%s] %s", self.data.abbr, name)
  end
  local monsterId = self.data.monsterId
  local monsterLv = GetTableData(LuaEntry.Player:GetABTestTableName(TableName.Monster), monsterId, "level")
  local showStr = ""
  local type = self.data.type or 0
  if type == RecordType.Call then
    local name = self.data.name
    if not string.IsNullOrEmpty(self.data.abbr) then
      name = string.format("[%s] %s", self.data.abbr, name)
    end
    local killCount = self.data.killCount
    showStr = Localization:GetString("2901024", name, killCount, monsterLv)
  elseif type == RecordType.Reward then
    local name = self.data.name
    if not string.IsNullOrEmpty(self.data.abbr) then
      name = string.format("[%s] %s", self.data.abbr, name)
    end
    showStr = Localization:GetString("2901036", name)
  elseif type == RecordType.SummonAisilla then
    local name = self.data.name
    if not string.IsNullOrEmpty(self.data.abbr) then
      name = string.format("[%s] %s", self.data.abbr, name)
    end
    showStr = Localization:GetString("activity_godzilla_start_r4_record", name)
  elseif type == RecordType.KillAisilla then
    showStr = Localization:GetString("activity_godzilla_down_record")
  elseif type == RecordType.MissAisilla then
    showStr = Localization:GetString("activity_godzilla_lose_record")
  end
  self.text:SetText(showStr)
  self.uiPlayerHead:SetData(self.data.uid, self.data.pic, self.data.picVer)
  local time = self.data.ct
  local curTime = UITimeManager:GetInstance():GetServerTime()
  local deltaTime = curTime - time
  local timeStr = UIUtil.GetDeltaTimeTimeStr(deltaTime)
  self.timeText:SetText(timeStr)
end

UIMonsterInvasionRecordItem.OnCreate = OnCreate
UIMonsterInvasionRecordItem.OnDestroy = OnDestroy
UIMonsterInvasionRecordItem.ComponentDefine = ComponentDefine
UIMonsterInvasionRecordItem.ComponentDestroy = ComponentDestroy
UIMonsterInvasionRecordItem.DataDefine = DataDefine
UIMonsterInvasionRecordItem.DataDestroy = DataDestroy
UIMonsterInvasionRecordItem.SetData = SetData
return UIMonsterInvasionRecordItem
