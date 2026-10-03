local UILWMailDetailEpidemicBattleResult = BaseClass("UILWMailDetailEpidemicBattleResult", UIBaseContainer)
local base = UIBaseContainer
local MailDetailEpidemicBattleItem = require("UI.UILWMail.UILWMailMain.Component.MailDetailEpidemicBattleItem")
local MailDetailEpidemicRankItem = require("UI.UILWMail.UILWMailMain.Component.MailDetailEpidemicRankItem")
local UIEBR_VsInfo = require("UI.UIActivityCenterTable.Component.ActEpidemic.BattleResult.Component.UIEBR_VsInfo")
local rapidjson = require("rapidjson")

function UILWMailDetailEpidemicBattleResult:OnCreate()
  base.OnCreate(self)
  self.dateTimeText = self:AddComponent(UIText, "Title/DateText")
  self.titleText = self:AddComponent(UIText, "Title/MailContent/DetailTitle")
  self.subTitleText = self:AddComponent(UIText, "ScrollView/Viewport/Content/TitleText")
  self.only_my = self:AddComponent(UIToggle, "ScrollView/Viewport/Content/TitleText/OnlyMy")
  self.only_my:SetActive(true)
  self.only_my:SetIsOn(false)
  self.only_my:SetOnValueChanged(function(_)
    self:RefreshRankList()
  end)
  self.text = self:AddComponent(UITextMeshProUGUIEx, "ScrollView/Viewport/Content/TitleText/OnlyMy/Text")
  self.text:SetLocalText("361058")
  self.title1Text = self:AddComponent(UIText, "ScrollView/Viewport/Content/Banner1/title1")
  self.title2Text = self:AddComponent(UIText, "ScrollView/Viewport/Content/Banner1/title2")
  self.title1Text:SetLocalText("458062")
  self.title2Text:SetLocalText("458063")
  self.expireTimeText = self:AddComponent(UIText, "DetailTimeBg/DetailTime")
  self.expireTimeBtn = self:AddComponent(UIButton, "DetailTimeBg/DetailTime/InfoBtn")
  self.expireTimeBtn:SetOnClick(function()
  end)
  self.mvpBanner = self:AddComponent(UIBaseContainer, "ScrollView/Viewport/Content/Banner1")
  self.battleItems = {}
  for i = 1, 4 do
    self.battleItems[i] = self:AddComponent(MailDetailEpidemicBattleItem, "ScrollView/Viewport/Content/BattleStateList/Item" .. i)
  end
  self.vsInfo = self:AddComponent(UIEBR_VsInfo, "ScrollView/Viewport/Content/VsInfo")
  self.rankBanner = self:AddComponent(UIBaseContainer, "ScrollView/Viewport/Content/Banner2")
  self.toggles = {}
  self.curIdx = 1
  for i = 1, 4 do
    local toggle = self:AddComponent(UIToggle, "ScrollView/Viewport/Content/Banner2/Toggle" .. i)
    if i == 1 then
      toggle:SetIsOn(true)
    end
    toggle:SetOnValueChanged(function(tf)
      if tf then
        self.curIdx = i
        self:RefreshRankList()
      end
    end)
    self.toggles[i] = toggle
  end
  self.rankItem = self.transform:Find("ScrollView/Viewport/Content/PersonalRankList/RankItem").gameObject
  self.rankItem:GameObjectCreatePool()
  self.rankItem:SetActive(false)
  self.rankContent = self:AddComponent(UIBaseContainer, "ScrollView/Viewport/Content/PersonalRankList")
  self.rankContent:SetActive(true)
  self.rankItems = {}
end

function UILWMailDetailEpidemicBattleResult:OnDestroy()
  self.rankContent:RemoveComponents(MailDetailEpidemicRankItem)
  self.rankItem.gameObject:GameObjectRecycleAll()
  self.rankContent = nil
  self.rankItem = nil
  self.rankItems = {}
  self.battleItems = {}
  self.toggles = {}
  self.curIdx = 1
  base.OnDestroy(self)
end

function UILWMailDetailEpidemicBattleResult:RefreshContent()
  self.mailUid = self.view.ctrl:GetCurrentMail()
  self.mailData = self.view.ctrl:GetCurrentMailData()
  local _strTitle = MailShowHelper.GetMainTitle(self.mailData)
  self.titleText:SetText(_strTitle)
  local _strContents = self.mailData:GetMailMessage()
  self.subTitleText:SetText(_strContents)
  local _strCreateTime = MailShowHelper.GetAbstractCreateTime(self.mailData)
  self.dateTimeText:SetText(_strCreateTime)
  self.expireTimeText:SetText(_strCreateTime)
  local msg = rapidjson.decode(self.mailData.contents)
  self.data = msg ~= nil and msg.obj or nil
  if self.data == nil then
    return
  end
  self.vsInfo:SetData(self.data)
  local mvp = self.data.mvp or {}
  local haveFlag = 0 < #mvp
  self.mvpBanner:SetActive(haveFlag)
  for i, item in ipairs(self.battleItems) do
    item:SetData(mvp[i])
  end
  self:RefreshRankList()
end

local function SortList1(a, b)
  if a.score ~= b.score then
    return a.score > b.score
  end
  return a.uid > b.uid
end

local function SortList2(a, b)
  if a.battleScore ~= b.battleScore then
    return a.battleScore > b.battleScore
  end
  return a.uid > b.uid
end

local function SortList3(a, b)
  if a.cooperationScore ~= b.cooperationScore then
    return a.cooperationScore > b.cooperationScore
  end
  return a.uid > b.uid
end

local function SortList4(a, b)
  if a.tacticsScore ~= b.tacticsScore then
    return a.tacticsScore > b.tacticsScore
  end
  return a.uid > b.uid
end

function UILWMailDetailEpidemicBattleResult:RefreshRankList()
  local list = self.data ~= nil and self.data.ranks or nil
  local haveFlag = not table.IsNullOrEmpty(list)
  self.rankBanner:SetActive(haveFlag)
  if not haveFlag then
    return
  end
  if self.curIdx == 1 then
    table.sort(list, SortList1)
  elseif self.curIdx == 2 then
    table.sort(list, SortList2)
  elseif self.curIdx == 3 then
    table.sort(list, SortList3)
  elseif self.curIdx == 4 then
    table.sort(list, SortList4)
  end
  local realList = {}
  local onlyShowMyAl = self.only_my:GetIsOn()
  local myAlId = LuaEntry.Player:GetAllianceUid()
  for i, v in ipairs(list) do
    v.rank = i
    if not onlyShowMyAl or v.allianceId == myAlId then
      table.insert(realList, v)
    end
  end
  local lItem = #self.rankItems
  local lList = #realList
  local max = math.max(lItem, lList)
  for i = 1, max do
    local item = self.rankItems[i]
    if i <= lList then
      if item == nil then
        local obj = self.rankItem:GameObjectSpawn(self.rankContent.transform)
        obj.name = "RankItem" .. i
        item = self.rankContent:AddComponent(MailDetailEpidemicRankItem, obj.name)
        self.rankItems[i] = item
      end
      item:SetActive(true)
      item:SetData(realList[i], self.curIdx)
    elseif item then
      item:SetActive(false)
    end
  end
end

return UILWMailDetailEpidemicBattleResult
