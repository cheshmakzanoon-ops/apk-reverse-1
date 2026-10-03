local UILWMailDetailDesertBattleResult = BaseClass("UILWMailDetailDesertBattleResult", UIBaseContainer)
local base = UIBaseContainer
local SingleAllyItem = require("UI.UIActivityCenterTable.Component.DesertBattle.BattleResult.Component.SingleAllyItem")
local MailDetailDesertBattleItem = require("UI.UILWMail.UILWMailMain.Component.MailDetailDesertBattleItem")
local MailDetailDesertRankItem = require("UI.UILWMail.UILWMailMain.Component.MailDetailDesertRankItem")
local rapidjson = require("rapidjson")
local MailResultData = require("DataCenter.ActDragonManager.MailResultData")
local Localization = CS.GameEntry.Localization

function UILWMailDetailDesertBattleResult:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function UILWMailDetailDesertBattleResult:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UILWMailDetailDesertBattleResult:DataDefine()
end

function UILWMailDetailDesertBattleResult:DataDestroy()
end

function UILWMailDetailDesertBattleResult:OnEnable()
  base.OnEnable(self)
end

function UILWMailDetailDesertBattleResult:OnDisable()
  base.OnDisable(self)
end

function UILWMailDetailDesertBattleResult:OnAddListener()
  base.OnAddListener(self)
end

function UILWMailDetailDesertBattleResult:OnRemoveListener()
  base.OnRemoveListener(self)
end

function UILWMailDetailDesertBattleResult:ComponentDefine()
  self.dateTimeText = self:AddComponent(UIText, "Title/DateText")
  self.titleText = self:AddComponent(UIText, "Title/MailContent/DetailTitle")
  self.subTitleText = self:AddComponent(UIText, "ScrollView/Viewport/Content/TitleText")
  self.winGo = self:AddComponent(UIBaseContainer, "ScrollView/Viewport/Content/Ally/WinImg")
  self.loseGo = self:AddComponent(UIBaseContainer, "ScrollView/Viewport/Content/Ally/LoseText")
  self.title1Text = self:AddComponent(UIText, "ScrollView/Viewport/Content/Banner1/title1")
  self.title2Text = self:AddComponent(UIText, "ScrollView/Viewport/Content/Banner1/title2")
  self.title3Text = self:AddComponent(UIText, "ScrollView/Viewport/Content/Banner2/title3")
  self.title1Text:SetText(Localization:GetString("458062"))
  self.title2Text:SetText(Localization:GetString("458063"))
  self.title3Text:SetText(Localization:GetString("458036"))
  self.expireTimeText = self:AddComponent(UIText, "DetailTimeBg/DetailTime")
  self.expireTimeBtn = self:AddComponent(UIButton, "DetailTimeBg/DetailTime/InfoBtn")
  self.expireTimeBtn:SetOnClick(function()
  end)
  self.mvpBanner = self:AddComponent(UIBaseContainer, "ScrollView/Viewport/Content/Banner1")
  self.battleItems = {}
  for i = 1, 5 do
    self.battleItems[i] = self:AddComponent(MailDetailDesertBattleItem, "ScrollView/Viewport/Content/BattleStateList/MailDetailDesertBattleItem" .. i)
  end
  self.singleAllyItems = {}
  for i = 1, 2 do
    self.singleAllyItems[i] = self:AddComponent(SingleAllyItem, "ScrollView/Viewport/Content/Ally/Ally" .. i)
  end
  self.rankBanner = self:AddComponent(UIBaseContainer, "ScrollView/Viewport/Content/Banner2")
  self.rankItem = self.transform:Find("ScrollView/Viewport/Content/PersonalRankList/MailDetailDesertRankItem").gameObject
  self.rankItem:GameObjectCreatePool()
  self.rankItem:SetActive(false)
  self.rankContent = self:AddComponent(UIBaseContainer, "ScrollView/Viewport/Content/PersonalRankList")
  self.rankContent:SetActive(true)
  self.rankListOpenBtn = self:AddComponent(UIButton, "ScrollView/Viewport/Content/Banner2/OpenBtn")
  self.rankListOpenBtn:SetOnClick(function()
    local curActive = self.rankContent:GetActive()
    self.rankContent:SetActive(not curActive)
    self.rankListOpenBtn:LoadSprite(curActive and "Assets/Main/Sprites/UI/UILWAlliance/cfm_lianmeng_anniu_xiala_2.png" or "Assets/Main/Sprites/UI/UILWAlliance/cfm_lianmeng_anniu_xiala_1.png")
  end)
end

function UILWMailDetailDesertBattleResult:ComponentDestroy()
  self.rankContent:RemoveComponents(MailDetailDesertRankItem)
  self.rankItem.gameObject:GameObjectRecycleAll()
  self.battleItems = {}
  self.singleAllyItems = {}
  self.rankContent = nil
  self.rankItem = nil
  self.expireTimeBtn = nil
  self.expireTimeText = nil
  self.rankListOpenBtn = nil
  self.title1Text = nil
  self.title2Text = nil
  self.title3Text = nil
  self.titleText = nil
  self.subTitleText = nil
  self.winGo = nil
  self.loseGo = nil
  self.dateTimeText = nil
end

function UILWMailDetailDesertBattleResult:RefreshContent()
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
  self.data = MailResultData.New()
  self.data:ParseData(msg.obj)
  self:RefreshView()
end

function UILWMailDetailDesertBattleResult:RefreshView()
  if self.data.result then
    self.winGo:SetActive(self.data.result == 1)
    self.loseGo:SetActive(self.data.result == 0)
  end
  if self.data.allyList then
    for k, v in pairs(self.data.allyList) do
      local allyData = {
        allyPoint = v.score,
        name = v.name,
        icon = v.icon,
        abbr = v.abbr,
        serverId = v.serverId
      }
      if v.alId == LuaEntry.Player.allianceId then
        self.singleAllyItems[1]:SetData(allyData)
      else
        self.singleAllyItems[2]:SetData(allyData)
      end
    end
  end
  if self.data then
    local battleItemsTable
    battleItemsTable = {}
    if self.data.occupyScoreMvp and 0 < toInt(self.data.occupyScoreMvp.score) then
      table.insert(battleItemsTable, {
        statisticName = Localization:GetString("458259"),
        score = self.data.occupyScoreMvp.score,
        playerInfo = self.data.occupyScoreMvp
      })
    end
    if self.data.collectScoreMvp and 0 < toInt(self.data.collectScoreMvp.score) then
      table.insert(battleItemsTable, {
        statisticName = Localization:GetString("458260"),
        score = self.data.collectScoreMvp.score,
        playerInfo = self.data.collectScoreMvp
      })
    end
    if self.data.brokeScoreMvp and 0 < toInt(self.data.brokeScoreMvp.score) then
      table.insert(battleItemsTable, {
        statisticName = Localization:GetString("458261"),
        score = self.data.brokeScoreMvp.score,
        playerInfo = self.data.brokeScoreMvp
      })
    end
    if self.data.killScoreMvp and 0 < toInt(self.data.killScoreMvp.score) then
      table.insert(battleItemsTable, {
        statisticName = Localization:GetString("458262"),
        score = self.data.killScoreMvp.score,
        playerInfo = self.data.killScoreMvp
      })
    end
    local cnt = self.data.rankList and #self.data.rankList or 0
    if 0 < cnt then
      local totalScoreMvp = self.data.rankList[1]
      table.insert(battleItemsTable, 1, {
        statisticName = Localization:GetString("Desert_strom_tips1053"),
        score = totalScoreMvp.score,
        playerInfo = totalScoreMvp
      })
    end
    for i, item in ipairs(self.battleItems) do
      if battleItemsTable[i] then
        item:SetActive(true)
        item:SetData(battleItemsTable[i])
      else
        item:SetActive(false)
      end
    end
    self.mvpBanner:SetActive(0 < #battleItemsTable)
  end
  self:RefreshRankList()
end

function UILWMailDetailDesertBattleResult:RefreshRankList()
  self.rankContent:RemoveComponents(MailDetailDesertRankItem)
  self.rankItem.gameObject:GameObjectRecycleAll()
  local data = self.data
  local haveItem = data.rankList ~= nil and #data.rankList > 0
  self.rankBanner:SetActive(haveItem)
  if haveItem then
    local itemCount = 0
    for i = 1, #data.rankList do
      itemCount = itemCount + 1
      local item = self.rankItem:GameObjectSpawn(self.rankContent.transform)
      item.name = "RankItem" .. itemCount
      local obj = self.rankContent:AddComponent(MailDetailDesertRankItem, item.name)
      obj:SetData(data.rankList[i])
    end
  end
end

return UILWMailDetailDesertBattleResult
