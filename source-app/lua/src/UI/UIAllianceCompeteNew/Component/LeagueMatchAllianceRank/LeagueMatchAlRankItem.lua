local LeagueMatchAlRankItem = BaseClass("LeagueMatchAlRankItem", UIBaseContainer)
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization
local AllianceFlagItem = require("UI.UIAlliance.UIAllianceFlag.Component.AllianceFlagItem")
local position_path = "position"
local rankImg_path = "third"
local alName_path = "name"
local result_path = "result"
local allianceFlag_path = "AllianceFlag"
local bgImg_path = ""
local allianceBtn_path = "allianceBtn"

local function OnCreate(self)
  base.OnCreate(self)
  self:DataDefine()
  self:ComponentDefine()
end

local function OnDestroy(self)
  self:ComponentDestroy()
  self:DataDestroy()
  base.OnDestroy(self)
end

local function ComponentDefine(self)
  self.positionN = self:AddComponent(UIText, position_path)
  self.rankImgN = self:AddComponent(UIImage, rankImg_path)
  self.alNameN = self:AddComponent(UIText, alName_path)
  self.resultTbN = {}
  for i = 1, 4 do
    local result = self:AddComponent(UIBaseContainer, result_path .. i)
    local result_win = result:AddComponent(UIText, "win")
    result_win:SetLocalText(390186)
    local result_lose = result:AddComponent(UIText, "lose")
    result_lose:SetLocalText(390187)
    local result_processing = result:AddComponent(UIText, "processing")
    result_processing:SetLocalText(302049)
    local result_unopen = result:AddComponent(UIText, "unopen")
    result_unopen:SetLocalText(372853)
    local resultTb = {
      result_win,
      result_lose,
      result_processing,
      result_unopen
    }
    table.insert(self.resultTbN, resultTb)
  end
  self.allianceFlagN = self:AddComponent(AllianceFlagItem, allianceFlag_path)
  self.bgImgN = self:AddComponent(UIImage, bgImg_path)
  self.allianceBtnN = self:AddComponent(UIButton, allianceBtn_path)
  self.allianceBtnN:SetOnClick(function()
    self:OnClickAllianceFlagBtn()
  end)
end

local function ComponentDestroy(self)
  self.positionN = nil
  self.alNameN = nil
  self.resultTbN = nil
end

local function DataDefine(self)
  self.allianceInfo = nil
end

local function DataDestroy(self)
  self.allianceInfo = nil
end

local function OnAddListener(self)
  base.OnAddListener(self)
end

local function OnRemoveListener(self)
  base.OnRemoveListener(self)
end

local function SetItem(self, allianceInfo)
  self.allianceInfo = allianceInfo
  if tonumber(allianceInfo.rank) <= 3 then
    self.rankImgN:SetActive(true)
    self.rankImgN:LoadSprite("Assets/Main/Sprites/UI/UIRank/lyp_huodong_zqzhg_paihangbang_" .. allianceInfo.rank)
    self.positionN:SetText("")
  else
    self.positionN:SetText(allianceInfo.rank)
    self.rankImgN:SetActive(false)
  end
  if allianceInfo.allianceId == LuaEntry.Player.allianceId then
    self.bgImgN:LoadSprite("Assets/Main/Sprites/UI/LWCommon/Sprite/Common_bg_item_supple3.png")
  else
    self.bgImgN:LoadSprite("Assets/Main/Sprites/UI/LWCommon/Sprite/Common_bg_item_supple.png")
  end
  if allianceInfo.fake == 1 then
    self.alNameN:SetLocalText(312059)
  else
    self.alNameN:SetText("#" .. allianceInfo.serverId .. " [" .. allianceInfo.abbr .. "] ")
  end
  local arr = string.IsNullOrEmpty(allianceInfo.roundResult) and {} or string.split(allianceInfo.roundResult, ";")
  for i, v in ipairs(self.resultTbN) do
    local r = 4
    if i <= #arr then
      r = arr[i] == "1" and 1 or 2
    else
      local curTime = UITimeManager:GetInstance():GetServerTime()
      local weekday = UITimeManager:GetInstance():GetWeekdayIndex(curTime)
      if weekday ~= 7 and i == #arr + 1 then
        r = 3
      end
    end
    for m, txt in ipairs(v) do
      txt:SetActive(m == r)
    end
  end
  self.allianceFlagN:SetData(allianceInfo.icon)
end

local function OnClickAllianceFlagBtn(self)
  UIManager:GetInstance():OpenWindow(UIWindowNames.UIAllianceDetail, {anim = true}, self.allianceInfo.name, self.allianceInfo.allianceId)
end

LeagueMatchAlRankItem.OnCreate = OnCreate
LeagueMatchAlRankItem.OnDestroy = OnDestroy
LeagueMatchAlRankItem.ComponentDefine = ComponentDefine
LeagueMatchAlRankItem.ComponentDestroy = ComponentDestroy
LeagueMatchAlRankItem.DataDefine = DataDefine
LeagueMatchAlRankItem.DataDestroy = DataDestroy
LeagueMatchAlRankItem.OnAddListener = OnAddListener
LeagueMatchAlRankItem.OnRemoveListener = OnRemoveListener
LeagueMatchAlRankItem.SetItem = SetItem
LeagueMatchAlRankItem.RefreshAll = RefreshAll
LeagueMatchAlRankItem.OnClickAllianceFlagBtn = OnClickAllianceFlagBtn
return LeagueMatchAlRankItem
