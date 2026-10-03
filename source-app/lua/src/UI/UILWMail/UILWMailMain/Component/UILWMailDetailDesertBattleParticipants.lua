local UILWMailDetailDesertBattleParticipants = BaseClass("UILWMailDetailDesertBattleParticipants", UIBaseContainer)
local base = UIBaseContainer
local MailDetailDesertBattlePeopleItem = require("UI.UILWMail.UILWMailMain.Component.MailDetailDesertBattlePeopleItem")
local MailParticipantsData = require("DataCenter.ActDragonManager.MailParticipantsData")
local rapidjson = require("rapidjson")
local Localization = CS.GameEntry.Localization

function UILWMailDetailDesertBattleParticipants:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function UILWMailDetailDesertBattleParticipants:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UILWMailDetailDesertBattleParticipants:DataDefine()
end

function UILWMailDetailDesertBattleParticipants:DataDestroy()
end

function UILWMailDetailDesertBattleParticipants:OnEnable()
  base.OnEnable(self)
end

function UILWMailDetailDesertBattleParticipants:OnDisable()
  base.OnDisable(self)
end

function UILWMailDetailDesertBattleParticipants:OnAddListener()
  base.OnAddListener(self)
end

function UILWMailDetailDesertBattleParticipants:OnRemoveListener()
  base.OnRemoveListener(self)
end

function UILWMailDetailDesertBattleParticipants:ComponentDefine()
  self.dateTimeText = self:AddComponent(UIText, "Title/DateText")
  self.titleText = self:AddComponent(UIText, "Title/MailContent/TitleText")
  self.subTitleText = self:AddComponent(UIText, "ScrollView/Viewport/Content/SubTitleText")
  self.title1Text = self:AddComponent(UIText, "ScrollView/Viewport/Content/Banner1/title1")
  self.title2Text = self:AddComponent(UIText, "ScrollView/Viewport/Content/Banner2/title2")
  self.expireTimeText = self:AddComponent(UIText, "DetailTimeBg/DetailTime")
  self.expireTimeBtn = self:AddComponent(UIButton, "DetailTimeBg/DetailTime/InfoBtn")
  self.expireTimeBtn:SetOnClick(function()
  end)
  self.rankItem = self.transform:Find("ScrollView/Viewport/Content/PersonList1/MailDetailDesertBattlePeopleItem").gameObject
  self.rankItem:GameObjectCreatePool()
  self.rankItem:SetActive(false)
  self.rankContent1 = self:AddComponent(UIBaseContainer, "ScrollView/Viewport/Content/PersonList1")
  self.rankContent1:SetActive(true)
  self.rankContent2 = self:AddComponent(UIBaseContainer, "ScrollView/Viewport/Content/PersonList2")
  self.rankContent2:SetActive(true)
  self.rankListOpenBtn1 = self:AddComponent(UIButton, "ScrollView/Viewport/Content/Banner1/OpenBtn1")
  self.rankListOpenBtn1:SetOnClick(function()
    local curActive = self.rankContent1:GetActive()
    self.rankContent1:SetActive(not curActive)
    self.rankListOpenBtn1:LoadSprite(curActive and "Assets/Main/Sprites/UI/UILWAlliance/cfm_lianmeng_anniu_xiala_2.png" or "Assets/Main/Sprites/UI/UILWAlliance/cfm_lianmeng_anniu_xiala_1.png")
  end)
  self.rankListOpenBtn2 = self:AddComponent(UIButton, "ScrollView/Viewport/Content/Banner2/OpenBtn2")
  self.rankListOpenBtn2:SetOnClick(function()
    local curActive = self.rankContent2:GetActive()
    self.rankContent2:SetActive(not curActive)
    self.rankListOpenBtn2:LoadSprite(curActive and "Assets/Main/Sprites/UI/UILWAlliance/cfm_lianmeng_anniu_xiala_2.png" or "Assets/Main/Sprites/UI/UILWAlliance/cfm_lianmeng_anniu_xiala_1.png")
  end)
end

function UILWMailDetailDesertBattleParticipants:ComponentDestroy()
  self.rankContent1:RemoveComponents(MailDetailDesertBattlePeopleItem)
  self.rankContent2:RemoveComponents(MailDetailDesertBattlePeopleItem)
  self.rankContent1 = nil
  self.rankContent2 = nil
  self.rankItem = nil
  self.expireTimeBtn = nil
  self.expireTimeText = nil
  self.rankListOpenBtn1 = nil
  self.rankListOpenBtn2 = nil
  self.title1Text = nil
  self.title2Text = nil
  self.titleText = nil
  self.subTitleText = nil
  self.dateTimeText = nil
end

function UILWMailDetailDesertBattleParticipants:RefreshContent()
  self.mailUid = self.view.ctrl:GetCurrentMail()
  self.mailData = self.view.ctrl:GetCurrentMailData()
  local _strTitle = MailShowHelper.GetMainTitle(self.mailData)
  self.titleText:SetText(_strTitle)
  local _strContents = self.mailData:GetMailMessage()
  self.subTitleText:SetText(_strContents)
  local _strCreateTime = MailShowHelper.GetAbstractCreateTime(self.mailData)
  self.dateTimeText:SetText(_strCreateTime)
  self.dateTimeText:SetActive(false)
  local _strExpireTime = MailShowHelper.GetAbstractExpireTime(self.mailData)
  self.expireTimeText:SetText(_strCreateTime)
  local msg = rapidjson.decode(self.mailData.contents)
  self.data = MailParticipantsData.New()
  self.data:ParseData(msg.obj)
  self:RefreshView()
end

function UILWMailDetailDesertBattleParticipants:RefreshView()
  local maxNumMain = LuaEntry.DataConfig:TryGetNum("dragon_battle_base", "k4", 20)
  local maxNumSub = LuaEntry.DataConfig:TryGetNum("dragon_battle_base", "k5", 20)
  local name1 = {
    Localization:GetString("458002"),
    ": ",
    #self.data.allyBattlePlayerList,
    "/",
    maxNumMain
  }
  self.title1Text:SetText(table.concat(name1))
  local name2 = {
    Localization:GetString("458003"),
    ": ",
    #self.data.allyBattleSubPlayerList,
    "/",
    maxNumSub
  }
  self.title2Text:SetText(table.concat(name2))
  self:RefreshRankList()
end

function UILWMailDetailDesertBattleParticipants:RefreshRankList()
  self.rankContent1:RemoveComponents(MailDetailDesertBattlePeopleItem)
  self.rankContent2:RemoveComponents(MailDetailDesertBattlePeopleItem)
  self.rankItem.gameObject:GameObjectRecycleAll()
  local data = self.data
  local itemCount = 0
  if data.allyBattlePlayerList and 0 < #data.allyBattlePlayerList then
    for i = 1, #data.allyBattlePlayerList do
      itemCount = itemCount + 1
      local item = self.rankItem:GameObjectSpawn(self.rankContent1.transform)
      item.name = "RankItem" .. itemCount
      local obj = self.rankContent1:AddComponent(MailDetailDesertBattlePeopleItem, item.name)
      obj:SetData(data.allyBattlePlayerList[i])
    end
  end
  if data.allyBattleSubPlayerList and 0 < #data.allyBattleSubPlayerList then
    for i = 1, #data.allyBattleSubPlayerList do
      itemCount = itemCount + 1
      local item = self.rankItem:GameObjectSpawn(self.rankContent2.transform)
      item.name = "RankItem" .. itemCount
      local obj = self.rankContent2:AddComponent(MailDetailDesertBattlePeopleItem, item.name)
      obj:SetData(data.allyBattleSubPlayerList[i])
    end
  end
end

return UILWMailDetailDesertBattleParticipants
