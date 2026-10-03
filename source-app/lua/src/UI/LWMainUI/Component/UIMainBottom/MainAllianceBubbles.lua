local MainAllianceBubbles = BaseClass("MainAllianceBubbles", UIBaseContainer)
local base = UIBaseContainer
local BubblesPath = {
  [MainAlBubbleType.Alert] = {
    luaPath = "UI.UIAlliance.UIAllianceWarMainTable.Component.LWAlAlertBubbleTip",
    uiPath = "AlertBubbleTip"
  },
  [MainAlBubbleType.Help] = {
    luaPath = "UI.UILWAlliance.UILWAlHelp.Component.UILWAlBubbleTip",
    uiPath = "HelpBubbleTip"
  },
  [MainAlBubbleType.Join] = {
    luaPath = "UI.LWMainUI.Component.UIMainBottom.UILWAl1stJoinNode",
    uiPath = "UILWAl1stJoinNode"
  },
  [MainAlBubbleType.Science] = {
    luaPath = "UI.LWMainUI.Component.UIMainBottom.UILWAlScienceRecommendNode",
    uiPath = "UILWAlScienceRecommendNode"
  },
  [MainAlBubbleType.Invite] = {
    luaPath = "UI.LWMainUI.Component.UIMainBottom.UILWAlSwitchJobNode",
    uiPath = "UILWAlInviteNode"
  },
  [MainAlBubbleType.Declare] = {
    luaPath = "UI.LWMainUI.Component.UIMainBottom.UILWAlDeclareWarNode",
    uiPath = "UILWAlDeclareWarNode"
  },
  [MainAlBubbleType.Star] = {
    luaPath = "UI.LWMainUI.Component.UIMainBottom.UIAlStarBubbleNode",
    uiPath = "UIAlStarBubbleNode"
  },
  [MainAlBubbleType.War] = {
    luaPath = "UI.UILWAlliance.UILWAlHelp.Component.UIAlWarBubbleNode",
    uiPath = "UIAlWarBubbleNode"
  },
  [MainAlBubbleType.Friends] = {
    luaPath = "UI.LWSeason6.MakeFriends.UILWSeasonMakeFriendsMainUI.Component.AllianceFriendsBubbleTips",
    uiPath = ""
  },
  [MainAlBubbleType.R4Recommend] = {
    luaPath = "UI.LWMainUI.Component.UIMainBottom.UIAlR4RecommendNode",
    uiPath = "UIAlR4RecommendNode"
  },
  [MainAlBubbleType.S0AllianceBoss] = {
    luaPath = "UI.LWMainUI.Component.UIMainBottom.UIS0AllianceBossNode",
    uiPath = "UIS0AllianceBossNode"
  }
}
local BubblesPathABTest = {
  [MainAlBubbleType.Gift] = {
    luaPath = "UI.UILWAlliance.UILWAlHelp.Component.UILWAlGiftTipNode",
    uiPath = "UILWAlGiftTipNode"
  },
  [MainAlBubbleType.FirstShow] = {
    luaPath = "UI.UILWAlliance.UILWAlHelp.Component.UILWAlFirstShowNode",
    uiPath = "UILWAlFirstShowNode"
  }
}

function MainAllianceBubbles:OnCreate()
  base.OnCreate(self)
  self:DataDefine()
  self:ComponentDefine()
end

function MainAllianceBubbles:OnDestroy()
  self:ComponentDestroy()
  self:DataDestroy()
  base.OnDestroy(self)
end

function MainAllianceBubbles:OnEnable()
  base.OnEnable(self)
end

function MainAllianceBubbles:OnDisable()
  base.OnDisable(self)
end

function MainAllianceBubbles:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.RefreshMainAlEvent, self.OnRefreshShow)
  self:AddUIListener(EventId.AllianceQuitOK, self.OnRefreshShow)
end

function MainAllianceBubbles:OnRemoveListener()
  self:RemoveUIListener(EventId.RefreshMainAlEvent, self.OnRefreshShow)
  self:RemoveUIListener(EventId.AllianceQuitOK, self.OnRefreshShow)
  base.OnRemoveListener(self)
end

function MainAllianceBubbles:DataDefine()
  self.isShow = {}
  local config = {}
  LocalController:instance():visitTable(TableName.Alliance_Bubble_Notice, function(id, lineData)
    if lineData and lineData.open == 1 then
      table.insert(config, {
        type = lineData.type,
        weight = lineData.weight
      })
    end
  end)
  table.sort(config, function(a, b)
    return a.weight > b.weight
  end)
  self.descend = {}
  for i, v in ipairs(config) do
    table.insert(self.descend, v.type)
  end
end

function MainAllianceBubbles:DataDestroy()
  self.descend = nil
  self.isShow = nil
end

function MainAllianceBubbles:ComponentDefine()
  self.bubbles = {}
  for _, type in pairs(self.descend) do
    local path = BubblesPath[type]
    if path then
      self.bubbles[type] = self:AddComponent(require(path.luaPath), path.uiPath)
    end
  end
end

function MainAllianceBubbles:ComponentDestroy()
  self.bubbles = nil
end

function MainAllianceBubbles:TrySetShow(type, bool)
  if self.isShow[type] ~= bool then
    self.isShow[type] = bool
    self.isDirty = true
  end
end

function MainAllianceBubbles:Update()
  if not self.isDirty then
    return
  end
  self.isDirty = false
  local realShow
  for _, v in ipairs(self.descend) do
    if realShow then
      self:SetShow(v, false)
    elseif self.isShow[v] then
      realShow = v
      self:SetShow(v, true)
    else
      self:SetShow(v, false)
    end
  end
end

function MainAllianceBubbles:SetShow(type, bool)
  if self.bubbles[type] then
    self.bubbles[type]:SetShow(bool)
  end
end

function MainAllianceBubbles:OnRefreshShow()
  for _, v in pairs(self.bubbles) do
    v:OnRefreshShow()
  end
end

return MainAllianceBubbles
