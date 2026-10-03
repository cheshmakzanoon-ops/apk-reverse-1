local UILWMailDetailScout = BaseClass("UILWMailDetailScout", UIBaseContainer)
local base = UIBaseContainer
local MailBattleParseHelper = require("DataCenter.MailData.MailBattleParseHelper")
local MailDetailScoutResourceItem = require("UI.UILWMail.UILWMailMain.Component.MailDetailScoutResourceItem")
local MailScoutDetailHelper = require("DataCenter.MailData.MailScoutDetailHelper")
local Localization = CS.GameEntry.Localization
local rapidjson = require("rapidjson")
local MailScoutPageToggle = require("UI.UILWMail.UILWMailMain.Component.MailScout.MailScoutPageToggle")
local PAGE_TYPES = {
  HERO = 1,
  DEVELOP = 2,
  SOLDIER = 3
}
local PAGE_CONFIG = {
  [PAGE_TYPES.HERO] = {
    title = "scout_report_panel_name_1",
    prefab = "Assets/Main/Prefabs/UI/LWMail/MailScout/MailScoutHeroPage.prefab",
    cls = "UI.UILWMail.UILWMailMain.Component.MailScout.MailScoutHeroPage"
  },
  [PAGE_TYPES.DEVELOP] = {
    title = "scout_report_panel_name_2",
    prefab = "Assets/Main/Prefabs/UI/LWMail/MailScout/MailScoutDevelopPage.prefab",
    cls = "UI.UILWMail.UILWMailMain.Component.MailScout.MailScoutDevelopPage"
  },
  [PAGE_TYPES.SOLDIER] = {
    title = "scout_report_panel_name_3",
    prefab = "Assets/Main/Prefabs/UI/LWMail/MailScout/MailScoutSoldierPage.prefab",
    cls = "UI.UILWMail.UILWMailMain.Component.MailScout.MailScoutSoldierPage"
  }
}
local Reward_Item_Path = "Assets/Main/Prefabs/UI/LWMail/MailDetailScoutResourceItem.prefab"

function UILWMailDetailScout:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function UILWMailDetailScout:OnDestroy()
  self:ClearPageToggles()
  self:ClearPages()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UILWMailDetailScout:DataDefine()
  self.mailUid = {}
  self.mailData = {}
  self.pageToggleReqs = {}
  self.pageToggles = {}
  self.pageReqs = {}
  self.pages = {}
end

function UILWMailDetailScout:DataDestroy()
  self.mailUid = nil
  self.mailData = nil
  self.pageToggleReqs = nil
  self.pageToggles = nil
  self.pageReqs = nil
  self.pages = nil
end

function UILWMailDetailScout:OnEnable()
  base.OnEnable(self)
end

function UILWMailDetailScout:OnDisable()
  base.OnDisable(self)
end

function UILWMailDetailScout:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.PlayerMessageInfo, self.OnPlayerMessageInfo)
end

function UILWMailDetailScout:OnRemoveListener()
  base.OnRemoveListener(self)
  self:RemoveUIListener(EventId.PlayerMessageInfo, self.OnPlayerMessageInfo)
end

function UILWMailDetailScout:OnPlayerMessageInfo(uid)
  if self.mailData and uid == self.mailData.toUser then
    self:RefreshContent()
  end
end

function UILWMailDetailScout:ComponentDefine()
  self.coordinateText = self:AddComponent(UIText, "scroll/viewport/content/top/CoordinateText")
  self.coordinateBtn = self:AddComponent(UIButton, "scroll/viewport/content/top/CoordinateText")
  self.coordinateBtn:SetOnClick(function()
    self:OnJumpClick2()
  end)
  self.coordinateText1 = self:AddComponent(UIText, "scroll/viewport/content/top/CoordinateText1")
  self.coordinateBtn1 = self:AddComponent(UIButton, "scroll/viewport/content/top/CoordinateText1")
  self.coordinateBtn1:SetOnClick(function()
    self:OnJumpClick1()
  end)
  self.coordinateText2 = self:AddComponent(UIText, "scroll/viewport/content/top/CoordinateText2")
  self.coordinateBtn2 = self:AddComponent(UIButton, "scroll/viewport/content/top/CoordinateText2")
  self.coordinateBtn2:SetOnClick(function()
    self:OnJumpClick2()
  end)
  self.timeText = self:AddComponent(UIText, "scroll/viewport/content/top/TimeText")
  self.head1 = self:AddComponent(UICommonHead, "scroll/viewport/content/top/head1")
  self.head2 = self:AddComponent(UICommonHead, "scroll/viewport/content/top/head2")
  self.playerName1 = self:AddComponent(UIText, "scroll/viewport/content/top/PlayerName1")
  self.playerName2 = self:AddComponent(UIText, "scroll/viewport/content/top/PlayerName2")
  self.beScoutTip1 = self:AddComponent(UIText, "scroll/viewport/content/bottom/Tip1")
  self.scoutText2 = self:AddComponent(UIText, "scroll/viewport/content/top/ScoutText2")
  self.beScoutText2 = self:AddComponent(UIText, "scroll/viewport/content/top/BeScoutText2")
  self.scoutTip2 = self:AddComponent(UIText, "scroll/viewport/content/top/Tip2")
  self.resText = self:AddComponent(UIText, "scroll/viewport/content/bottom/ResBg2/resTxtLayout/ResText")
  self.resBg = self:AddComponent(UIBaseComponent, "scroll/viewport/content/bottom/ResBg2")
  self.rewardContent = self:AddComponent(UIBaseContainer, "scroll/viewport/content/bottom/ResBg2/ResScroll/Viewport/Content")
  self.rewardReqs = {}
  self.pageToggleRootContainer = self:AddComponent(UIBaseContainer, "scroll/viewport/content/bottom/ToggleView")
  self.pageToggleContainer = self:AddComponent(UIBaseContainer, "scroll/viewport/content/bottom/ToggleView/Viewport/ToggleGroup")
  self.pageContainer = self:AddComponent(UIBaseContainer, "scroll/viewport/content/bottom/Pages")
  self.scoutLv = self:AddComponent(UIButton, "scroll/viewport/content/top/scoutLv")
  self.scoutLv:SetOnClick(function()
    UIUtil.ShowDetail(Localization:GetString("scout_report_panel_detail_2"), Localization:GetString("scout_report_panel_detail_1"))
  end)
  self.scoutLv_txt = self:AddComponent(UIText, "scroll/viewport/content/top/scoutLv/scoutLv_txt")
end

function UILWMailDetailScout:ComponentDestroy()
  self:ClearResourceItem()
  self.coordinateText = nil
  self.timeText = nil
  self.player_head1 = nil
  self.player_head2 = nil
  self.playerName1 = nil
  self.playerName2 = nil
  self.resText = nil
  self.heroCells = nil
  self.rewardItem = nil
  self.rewardContent = nil
  self.pageToggleContainer = nil
  self.pageToggleRootContainer = nil
end

function UILWMailDetailScout:ClearResourceItem()
  self.rewardContent:RemoveComponents(MailDetailScoutResourceItem)
  if self.rewardReqs then
    for k, v in pairs(self.rewardReqs) do
      if v ~= nil then
        self:GameObjectDestroy(v)
      end
    end
    self.rewardReqs = nil
  end
end

function UILWMailDetailScout:RefreshContent()
  self.mailUid = self.view.ctrl:GetCurrentMail()
  self.mailData = self.view.ctrl:GetCurrentMailData()
  local _strTime = MailShowHelper.GetAbstractCreateTime(self.mailData)
  self.timeText:SetText(_strTime)
  local data
  self.head1.frameBg:SetActive(true)
  self.head2.frameBg:SetActive(true)
  local showResBg = false
  if IsMailScoutType(self.mailData.type) or self.mailData.type == MailType.LW_SEASON_SCOUT_MAIL then
    self.isScout = true
    data = self.mailData:GetMailExt():GetExtData()
    self.data = data
    self.mailExt = self.mailData:GetMailExt()
    local targetInfo = MailScoutDetailHelper:HandleTargetInfo(data, data.targetType)
    self.location2 = targetInfo.location
    self.serverId2 = targetInfo.serverId
    local targetName = targetInfo.nameNeedLocal and Localization:GetString(targetInfo.name) or DataCenter.PlayerInfoDataManager:GetRemarkOrRealName(targetInfo.uid, targetInfo.name)
    if targetInfo.isWerewolf then
      self.head2:ShowWerewolf()
    elseif targetInfo.headIcon then
      self.head2:SetHead(nil, targetInfo.headIcon)
    else
      self.head2:SetHead(targetInfo.uid, targetInfo.pic, targetInfo.picVer, nil, targetInfo.headFramePath)
    end
    self.head2:SetEnableClickShowInfo(targetInfo.enableClickInfo, true)
    self.head2.frameBg:SetActive(not targetInfo.hideBg)
    self.playerName2:SetText(targetName)
    local enemyWorldId = MailScoutDetailHelper:GetWorldId(self.data)
    if targetInfo.hasReward and enemyWorldId == 0 then
      local rewards = {}
      for k, v in pairs(data.resource.data) do
        local reward = {}
        reward.type = RewardType.RESOURCE
        reward.value = {}
        reward.value.id = v.id.value
        if v.newValue and v.newValue.value then
          reward.value.num = v.newValue.value
        else
          reward.value.num = v.value.value
        end
        table.insert(rewards, reward)
      end
      if data.targetType == ScoutMailTargetType.TRAIN then
        for k, v in pairs(data.resource.extraGoods) do
          table.insert(rewards, v)
        end
      end
      self:ClearResourceItem()
      self.rewardReqs = {}
      if not table.IsNullOrEmpty(rewards) then
        local rewardsParam = DataCenter.RewardManager:ReturnRewardParamForMessage(rewards) or {}
        for k, v in ipairs(rewardsParam) do
          self.rewardReqs[k] = self:GameObjectInstantiateAsync(Reward_Item_Path, function(request)
            if request.isError then
              return
            end
            local go = request.gameObject
            local trans = go.transform
            trans:SetParent(self.rewardContent.transform)
            trans:Set_localScale(ResetScale.x, ResetScale.y, ResetScale.z)
            local nameStr = tostring(NameCount)
            go.name = nameStr
            NameCount = NameCount + 1
            local cell = self.rewardContent:AddComponent(MailDetailScoutResourceItem, nameStr)
            cell:RefreshData(rewardsParam[k])
          end)
        end
        showResBg = true
      end
    end
    if self.mailData.toUser and self.mailData.toUser == LuaEntry.Player:GetUid() then
      self.head1:SetHead(LuaEntry.Player:GetUid(), LuaEntry.Player:GetPic(), LuaEntry.Player.picVer, nil, LuaEntry.Player:GetHeadBgImg())
      self.playerName1:SetText(LuaEntry.Player:GetName())
      self.head1:SetEnableClickShowInfo(true, true)
    else
      local userInfo = ChatManager2:GetInstance().User:getChatUserInfo(self.mailData.toUser)
      if userInfo then
        self.head1:SetHead(userInfo.uid, userInfo.headPic, userInfo.headPicVer, nil, userInfo:GetHeadBgImg())
        self.head1:SetEnableClickShowInfo(true, true)
        self.playerName1:SetText(userInfo.userName)
      end
    end
    self.coordinateText1:SetText("")
    self.coordinateText2:SetText(self.view.ctrl:FormatCoordinateText(self.location2, self.serverId2))
    if 0 < self.data.version and data.targetType == ScoutMailTargetType.MAIN_BUILDING then
      self.scoutLv:SetActive(true)
      self.scoutLv_txt:SetText("Lv" .. self.mailExt.scoutLv)
      if 0 < self.data.hideCount then
        self.scoutTip2:SetLocalText("scout_report_panel_detail_4", "", "", targetName, self.data.hideCount)
      else
        self.scoutTip2:SetLocalText("scout_report_panel_detail_3", "", "", targetName)
      end
    else
      self.scoutLv:SetActive(false)
      self.scoutTip2:SetLocalText(GameDialogDefine.MAIL_SCOUT_ALERT_TIPS, "", "", targetName)
    end
  elseif IsMailBeScoutType(self.mailData.type) then
    self.isScout = false
    data = rapidjson.decode(self.mailData.contents)
    data = data.b
    self.data = data
    for k, v in pairs(data.content.dialog.params) do
      if v.color and v.color == "RED" then
        self.location1 = Vector2.New(v.point.x, v.point.y)
        self.serverId1 = v.point.server or v.sourceServerId
        self.worldId1 = v.point.worldId or 0
      elseif v.color and v.color == "GREEN" then
        self.location2 = Vector2.New(v.point.x, v.point.y)
        self.serverId2 = v.point.server or v.sourceServerId
        self.worldId2 = v.point.worldId or 0
      end
    end
    self.coordinateText1:SetText(self.view.ctrl:FormatCoordinateText(self.location1, self.serverId1))
    self.coordinateText2:SetText(self.view.ctrl:FormatCoordinateText(self.location2, self.serverId2))
    local framePath = DataCenter.DecorationDataManager:GetHeadFrame(data.userInfo.headSkinId, 0, false)
    local name1 = ""
    if MailBattleParseHelper.IsWerewolf(data.userInfo) then
      self.head1:ShowWerewolf()
      self.playerName1:SetLocalText(GameDialogDefine.WEREWOLF)
    else
      self.head1:SetHead(data.userInfo.uid, data.userInfo.pic, data.userInfo.picVer, nil, framePath)
      local alAbbr1 = ""
      if data.userInfo.abbr and not string.IsNullOrEmpty(data.userInfo.abbr) then
        alAbbr1 = "[" .. data.userInfo.abbr .. "]"
      end
      name1 = alAbbr1 .. data.userInfo.name
      self.playerName1:SetText(name1)
    end
    self.head1:SetEnableClickShowInfo(true, true)
    self.head2:SetHead(LuaEntry.Player:GetUid(), LuaEntry.Player:GetPic(), LuaEntry.Player.picVer, nil, LuaEntry.Player:GetHeadBgImg())
    self.head2:SetEnableClickShowInfo(true, true)
    self.playerName2:SetText(LuaEntry.Player:GetName())
    self.beScoutTip1:SetLocalText(GameDialogDefine.MAIL_BE_SCOUT_ALERT_TIPS, "", "", name1)
    self.scoutTip2:SetText("")
    self.scoutLv:SetActive(false)
  end
  self.coordinateText:SetText(self.view.ctrl:FormatCoordinateText(self.location2, self.serverId2))
  self.beScoutTip1:SetActive(not self.isScout)
  self.resBg:SetActive(showResBg)
  self.pageToggleRootContainer:SetActive(self.isScout)
  self.pageContainer:SetActive(self.isScout)
  if showResBg then
    self.resText:SetLocalText(GameDialogDefine.MAIL_SCOUT_RES_CAN_LOOT)
  end
  self:RefreshShowToggle()
end

function UILWMailDetailScout:OnJumpClick2()
  if self.location2 ~= nil then
    self.view.ctrl:OnJumpClick(self.location2.x, self.location2.y, self.serverId2)
  end
end

function UILWMailDetailScout:OnJumpClick1()
  if self.location1 ~= nil then
    self.view.ctrl:OnJumpClick(self.location1.x, self.location1.y, self.serverId1)
  end
end

function UILWMailDetailScout:ClearPageToggles()
  if self.pageToggleReqs then
    self.pageToggleContainer:RemoveComponents(MailScoutPageToggle)
    for _, req in pairs(self.pageToggleReqs) do
      self:GameObjectDestroy(req)
    end
    self.pageToggleReqs = {}
    self.pageToggles = {}
  end
end

function UILWMailDetailScout:ClearPages()
  if self.pageReqs then
    self.pageContainer:RemoveAllComponentes()
    for _, req in pairs(self.pageReqs) do
      self:GameObjectDestroy(req)
    end
    self.pageReqs = {}
    self.pages = {}
  end
  self.selectedPageType = nil
end

function UILWMailDetailScout:RefreshShowToggle()
  self.showToggles = {}
  if IsMailScoutType(self.mailData.type) or self.mailData.type == MailType.LW_SEASON_SCOUT_MAIL then
    table.insert(self.showToggles, PAGE_TYPES.HERO)
    if self.data.version > 0 and self.data.targetType == ScoutMailTargetType.MAIN_BUILDING then
      if self.mailExt.scoutLv >= ScoutLevel.HonorWallPower and self.data.armyProcess ~= nil then
        table.insert(self.showToggles, PAGE_TYPES.DEVELOP)
      end
      if self.mailExt.scoutLv >= ScoutLevel.InCitySoldierCount then
        table.insert(self.showToggles, PAGE_TYPES.SOLDIER)
      end
    end
  end
  self:ClearPageToggles()
  self:ClearPages()
  if #self.showToggles == 0 then
    return
  end
  self:GotoPage(self.showToggles[1])
  for i, pageType in ipairs(self.showToggles) do
    local req = self:GameObjectInstantiateAsync("Assets/Main/Prefabs/UI/LWMail/MailScout/MailScoutPageToggle.prefab", function(req)
      local obj = req.gameObject
      if IsNull(obj) then
        return
      end
      local transform = obj.transform
      transform:SetParent(self.pageToggleContainer.transform, false)
      transform.localScale = Vector3.one
      transform:Set_pivot(0.5, 0.5)
      transform.localPosition = Vector3.zero
      local name = string.format("MailScoutPageToggle%s", i)
      obj.name = name
      local toggle = self.pageToggleContainer:AddComponent(MailScoutPageToggle, name)
      local config = PAGE_CONFIG[pageType]
      local name = ""
      if config then
        name = config.title
      end
      toggle:SetData(name, pageType, function(type)
        self:OnPageToggleClick(type)
      end)
      toggle:SetSelected(pageType == self.selectedPageType)
      self.pageToggles[pageType] = toggle
    end)
    table.insert(self.pageToggleReqs, req)
  end
end

function UILWMailDetailScout:GotoPage(gotoType)
  if self.selectedPageType and self.selectedPageType == gotoType then
    return
  end
  self.selectedPageType = gotoType
  
  local function ShowCurPage()
    for type, page in pairs(self.pages) do
      page:SetActive(type == gotoType)
    end
  end
  
  if self.pages[gotoType] then
    ShowCurPage()
  elseif not self.pageReqs[gotoType] then
    local config = PAGE_CONFIG[gotoType]
    if config then
      do
        local req = self:GameObjectInstantiateAsync(config.prefab, function(req)
          local obj = req.gameObject
          if IsNull(obj) then
            return
          end
          local transform = obj.transform
          transform:SetParent(self.pageContainer.transform, false)
          transform.localScale = Vector3.one
          transform.localPosition = Vector3.zero
          local name = string.format("MailScoutPage%s", gotoType)
          obj.name = name
          local cls = require(config.cls)
          local page = self.pageContainer:AddComponent(cls, name)
          page:Refresh(self.mailExt)
          ShowCurPage()
          self.pages[gotoType] = page
        end)
        self.pageReqs[gotoType] = req
      end
    end
  end
  for type, toggle in pairs(self.pageToggles) do
    toggle:SetSelected(type == gotoType)
  end
end

function UILWMailDetailScout:OnPageToggleClick(type)
  self:GotoPage(type)
end

return UILWMailDetailScout
