local LFChampionBattleBettingrecordItem = BaseClass("LFChampionBattleBettingrecordItem", UIBaseContainer)
local base = UIBaseContainer
local stateTxt_path = "stateTxt"
local head_path = "Player1/playerHeadBtn/leftHeadImg/UIPlayerHead/HeadIcon"
local serverTxt_path = "Player1/playerHeadBtn/serverTxt"
local nameTxt_path = "Player1/playerHeadBtn/nameTxt"
local numTxt_path = "Player1/numTxt"
local oddsTxt_path = "Player1/oddsTxt"
local timeTxt_path = "Player1/timeTxt"

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
  self.stateTxt = self:AddComponent(UIText, stateTxt_path)
  self.head = self:AddComponent(UIPlayerHead, head_path)
  self.serverTxt = self:AddComponent(UIText, serverTxt_path)
  self.nameTxt = self:AddComponent(UIText, nameTxt_path)
  self.numTxt = self:AddComponent(UIText, numTxt_path)
  self.oddsTxt = self:AddComponent(UIText, oddsTxt_path)
  self.timeTxt = self:AddComponent(UIText, timeTxt_path)
end

local function DataDefine(self)
end

local function ComponentDestroy(self)
  self.stateTxt = nil
  self.head = nil
  self.serverTxt = nil
  self.nameTxt = nil
  self.numTxt = nil
  self.oddsTxt = nil
  self.timeTxt = nil
end

local function DataDestroy(self)
end

local function SetData(self, data)
  local player = data.playerInfo
  if player ~= nil then
    self.head:SetData(player.uid, player.pic, player.picver)
    local abbr = " "
    if not string.IsNullOrEmpty(player.abbr) then
      abbr = "[" .. player.abbr .. "]"
    end
    self.serverTxt:SetText("#" .. player.serverId .. abbr)
    self.nameTxt:SetText(player.name)
  end
  if data.state == 0 then
    self.stateTxt:SetLocalText(312091)
  elseif data.state == 1 then
    self.stateTxt:SetLocalText(312092)
  end
  self.numTxt:SetText(string.GetFormattedThousandthStr(data.oneBetCount))
  self.oddsTxt:SetText(string.format("%.2f", data.odds))
  self.timeTxt:SetText(UITimeManager:GetInstance():TimeStampToTimeForLocal(data.time))
end

LFChampionBattleBettingrecordItem.OnCreate = OnCreate
LFChampionBattleBettingrecordItem.OnDestroy = OnDestroy
LFChampionBattleBettingrecordItem.ComponentDefine = ComponentDefine
LFChampionBattleBettingrecordItem.DataDefine = DataDefine
LFChampionBattleBettingrecordItem.ComponentDestroy = ComponentDestroy
LFChampionBattleBettingrecordItem.DataDestroy = DataDestroy
LFChampionBattleBettingrecordItem.SetData = SetData
return LFChampionBattleBettingrecordItem
