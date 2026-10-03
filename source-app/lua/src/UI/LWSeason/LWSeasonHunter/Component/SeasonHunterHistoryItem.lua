local base = UIBaseContainer
local SeasonHunterHistoryItem = BaseClass("SeasonHunterHistoryItem", base)
local SeasonHunterHistoryDetailItem = require("UI.LWSeason.LWSeasonHunter.Component.SeasonHunterHistoryDetailItem")
local Localization = CS.GameEntry.Localization
local time_path = "bg/Txt_Time"
local duration_path = "bg/Txt_Duration"
local kill_path = "bg/Txt_Kill"
local score_path = "bg/Txt_Score"
local rank_path = "bg/Txt_Rank"
local win_path = "bg/Result_Win"
local lose_path = "bg/Result_Lose"
local btnBg_path = "bg"
local imgBg_path = "bg"
local content_path = "Content"
local arrow_path = "bg/Arrow"

local function OnCreate(self)
  base.OnCreate(self)
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
  self.time = self:AddComponent(UIText, time_path)
  self.duration = self:AddComponent(UIText, duration_path)
  self.kill = self:AddComponent(UIText, kill_path)
  self.score = self:AddComponent(UIText, score_path)
  self.rank = self:AddComponent(UIText, rank_path)
  self.win = self:AddComponent(UIBaseContainer, win_path)
  self.lose = self:AddComponent(UIBaseContainer, lose_path)
  self.btnBg = self:AddComponent(UIButton, btnBg_path)
  self.imgBg = self:AddComponent(UIImage, imgBg_path)
  self.content = self:AddComponent(UIBaseContainer, content_path)
  self.arrow = self:AddComponent(UIImage, arrow_path)
  self.btnBg:SetOnClick(function()
    self:OnClickDetail()
  end)
  self.layoutElement = self:AddComponent(UILayoutElement, "")
  self.sizeW, self.sizeH = self:GetSizeDeltaXY()
end

local function ComponentDestroy(self)
  self:ClearList()
  self.time = nil
  self.duration = nil
  self.kill = nil
  self.score = nil
  self.rank = nil
  self.win = nil
  self.lose = nil
  self.btnBg = nil
  self.imgBg = nil
  self.content = nil
  self.arrow = nil
end

local function DataDefine(self)
end

local function DataDestroy(self)
end

function SeasonHunterHistoryItem:ReInit(index, data, callback, callbackOwner)
  self.index = index
  self.data = data
  self.callback = callback
  self.callbackOwner = callbackOwner
  self.time:SetText(UITimeManager:GetInstance():TimeStampToTimeForServer(data.time))
  self.duration:SetText(Localization:GetString("season_s4_activity_1200011_desc42", UITimeManager:GetInstance():MilliSecondToFmtString(data.lifeTime)))
  self.kill:SetText(Localization:GetString("season_s4_activity_1200011_desc43", data.killNum))
  self.score:SetText(Localization:GetString("season_s4_activity_1200011_desc44", data.score))
  self.rank:SetText(Localization:GetString("season_s4_activity_1200011_desc45", data.rank))
  if data.state == 1 then
    self.win:SetActive(true)
    self.lose:SetActive(false)
    self.imgBg:LoadSprite(string.format(LoadPath.UISeason4Path, "Hunter/ljq_s4_xueselieren_kuang_04.png"))
  else
    self.win:SetActive(false)
    self.lose:SetActive(true)
    self.imgBg:LoadSprite(string.format(LoadPath.UISeason4Path, "Hunter/ljq_s4_xueselieren_kuang_03.png"))
  end
  self:OnClickDetail(self.data.isOpened)
end

function SeasonHunterHistoryItem:OnClickDetail(value)
  local isChange = false
  if value == nil then
    value = not self.data.isOpened
  end
  if self.data.isOpened ~= value then
    isChange = true
  end
  self.data.isOpened = value
  if value then
    self:RefreshList()
    self.arrow:LoadSprite(string.format(LoadPath.CommonNewPath, "cfm_lianmeng_anniu_xiala_1.png"))
  else
    self:ClearList()
    self.arrow:LoadSprite(string.format(LoadPath.CommonNewPath, "cfm_lianmeng_anniu_xiala_2.png"))
  end
  local count = self.model and #self.model or 0
  local totalSize = count * 143 + self.sizeH
  self:SetSizeDeltaXY(self.sizeW, totalSize)
  self.layoutElement:SetMinHeight(totalSize)
  self.layoutElement:SetPreferredHeight(totalSize)
  if isChange and self.callback then
    self.callback(self.callbackOwner, self.index)
  end
end

function SeasonHunterHistoryItem:ClearList()
  if self.model then
    self.content:RemoveComponents(SeasonHunterHistoryDetailItem)
    for k, v in pairs(self.model) do
      if v then
        self:GameObjectDestroy(v)
      end
    end
    self.model = nil
  end
end

function SeasonHunterHistoryItem:RefreshList()
  self:ClearList()
  self.model = {}
  local count = self.data.list and #self.data.list or 0
  for i = 1, count do
    self.model[i] = self:GameObjectInstantiateAsync(UIAssets.UISeasonHunterHistoryDetailItem, function(request)
      if request.isError then
        return
      end
      local go = request.gameObject
      local trans = go.transform
      trans:SetParent(self.content.transform)
      trans:Set_localScale(ResetScale.x, ResetScale.y, ResetScale.z)
      go.name = "item" .. i
      local cell = self.content:AddComponent(SeasonHunterHistoryDetailItem, go.name)
      cell:ReInit(i, self.data.list[i])
    end)
  end
end

SeasonHunterHistoryItem.OnCreate = OnCreate
SeasonHunterHistoryItem.OnDestroy = OnDestroy
SeasonHunterHistoryItem.OnEnable = OnEnable
SeasonHunterHistoryItem.OnDisable = OnDisable
SeasonHunterHistoryItem.ComponentDefine = ComponentDefine
SeasonHunterHistoryItem.ComponentDestroy = ComponentDestroy
SeasonHunterHistoryItem.DataDefine = DataDefine
SeasonHunterHistoryItem.DataDestroy = DataDestroy
return SeasonHunterHistoryItem
