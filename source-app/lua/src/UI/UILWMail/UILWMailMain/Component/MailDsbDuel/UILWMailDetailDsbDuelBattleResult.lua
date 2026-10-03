local UILWMailDetailDsbDuelBattleResult = BaseClass("UILWMailDetailDsbDuelBattleResult", UIBaseContainer)
local base = UIBaseContainer
local SingleAllyItem = require("UI.UILWMail.UILWMailMain.Component.MailDsbDuel.UIBFDsbDuelActMailAllianceItem")
local UIBFDsbDuelActMailMvpItem = require("UI.UILWMail.UILWMailMain.Component.MailDsbDuel.UIBFDsbDuelActMailMvpItem")
local MailDetailDesertRankItem = require("UI.UILWMail.UILWMailMain.Component.MailDetailDesertRankItem")
local rapidjson = require("rapidjson")
local BattlefieldDsbDuelMailResultData = require("DataCenter.BattlefieldDsbDuel.BattlefieldDsbDuelMailResultData")
local Localization = CS.GameEntry.Localization

function UILWMailDetailDsbDuelBattleResult:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function UILWMailDetailDsbDuelBattleResult:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UILWMailDetailDsbDuelBattleResult:DataDefine()
end

function UILWMailDetailDsbDuelBattleResult:DataDestroy()
end

function UILWMailDetailDsbDuelBattleResult:OnEnable()
  base.OnEnable(self)
end

function UILWMailDetailDsbDuelBattleResult:OnDisable()
  base.OnDisable(self)
end

function UILWMailDetailDsbDuelBattleResult:OnAddListener()
  base.OnAddListener(self)
end

function UILWMailDetailDsbDuelBattleResult:OnRemoveListener()
  base.OnRemoveListener(self)
end

function UILWMailDetailDsbDuelBattleResult:ComponentDefine()
  self.titleText = self:AddComponent(UIText, "Title/MailContent/DetailTitle")
  self.subTitleText = self:AddComponent(UIText, "ScrollView/Viewport/Content/TitleText")
  self.title2Text = self:AddComponent(UIText, "ScrollView/Viewport/Content/Banner1/title2")
  self.title3Text = self:AddComponent(UIText, "ScrollView/Viewport/Content/Banner2/title3")
  self.title2Text:SetText(Localization:GetString("458062"))
  self.title3Text:SetText(Localization:GetString("458036"))
  self.expireTimeText = self:AddComponent(UIText, "DetailTimeBg/DetailTime")
  self.expireTimeBtn = self:AddComponent(UIButton, "DetailTimeBg/DetailTime/InfoBtn")
  self.expireTimeBtn:SetOnClick(function()
  end)
  self.mvpBanner = self:AddComponent(UIBaseContainer, "ScrollView/Viewport/Content/Banner1")
  self.battleItems = {}
  for i = 1, 4 do
    self.battleItems[i] = self:AddComponent(UIBFDsbDuelActMailMvpItem, "ScrollView/Viewport/Content/BattleStateList/MailDetailDesertBattleItem" .. i)
  end
  self.singleAllyItems = {}
  for i = 1, 4 do
    self.singleAllyItems[i] = self:AddComponent(SingleAllyItem, "ScrollView/Viewport/Content/AllianceContent/AllianceItem" .. i)
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

function UILWMailDetailDsbDuelBattleResult:ComponentDestroy()
  self.rankContent:RemoveComponents(MailDetailDesertRankItem)
  self.rankItem.gameObject:GameObjectRecycleAll()
  self.battleItems = {}
  self.singleAllyItems = {}
  self.rankContent = nil
  self.rankItem = nil
  self.expireTimeBtn = nil
  self.expireTimeText = nil
  self.rankListOpenBtn = nil
  self.title2Text = nil
  self.title3Text = nil
  self.titleText = nil
  self.subTitleText = nil
end

function UILWMailDetailDsbDuelBattleResult:RefreshContent()
  self.mailUid = self.view.ctrl:GetCurrentMail()
  self.mailData = self.view.ctrl:GetCurrentMailData()
  local _strTitle = MailShowHelper.GetMainTitle(self.mailData)
  self.titleText:SetText(_strTitle)
  local _strContents = self.mailData:GetMailMessage()
  self.subTitleText:SetText(_strContents)
  local _strCreateTime = MailShowHelper.GetAbstractCreateTime(self.mailData)
  self.expireTimeText:SetText(_strCreateTime)
  local msg = rapidjson.decode(self.mailData.contents)
  self.data = BattlefieldDsbDuelMailResultData.New()
  self.data:ParseData(msg.obj)
  self:RefreshView()
end

function UILWMailDetailDsbDuelBattleResult:GetAlByRank(rank)
  if self.data.allyList then
    for _, v in ipairs(self.data.allyList) do
      if v.rank == rank then
        return v
      end
    end
  end
  return BattlefieldDsbConst.EmptyRole
end

function UILWMailDetailDsbDuelBattleResult:RefreshView()
  for i, v in ipairs(self.singleAllyItems) do
    local data = self:GetAlByRank(i)
    v:SetData(data)
  end
  if self.data then
    local battleItemsTable
    battleItemsTable = {}
    if self.data.firstMvp then
      table.insert(battleItemsTable, {
        statisticName = Localization:GetString("YiBianJinQu_battle_result_tips_6"),
        score = self.data.firstMvp.score,
        playerInfo = self.data.firstMvp
      })
    end
    if self.data.battleMvp then
      table.insert(battleItemsTable, {
        statisticName = Localization:GetString("YiBianJinQu_battle_result_tips_7"),
        score = self.data.battleMvp.score,
        playerInfo = self.data.battleMvp
      })
    end
    if self.data.cooperationMvp then
      table.insert(battleItemsTable, {
        statisticName = Localization:GetString("YiBianJinQu_battle_result_tips_8"),
        score = self.data.cooperationMvp.score,
        playerInfo = self.data.cooperationMvp
      })
    end
    if self.data.tacticsMvp then
      table.insert(battleItemsTable, {
        statisticName = Localization:GetString("YiBianJinQu_battle_result_tips_9"),
        score = self.data.tacticsMvp.score,
        playerInfo = self.data.tacticsMvp
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

function UILWMailDetailDsbDuelBattleResult:RefreshRankList()
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

return UILWMailDetailDsbDuelBattleResult
