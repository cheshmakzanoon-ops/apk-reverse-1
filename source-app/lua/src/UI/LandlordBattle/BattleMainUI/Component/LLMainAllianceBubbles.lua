local LLMainAllianceBubbles = BaseClass("LLMainAllianceBubbles", UIBaseContainer)
local base = UIBaseContainer
local BubblesPath = {
  [MainAlBubbleType.Alert] = {
    luaPath = "UI.UIAlliance.UIAllianceWarMainTable.Component.LWAlAlertBubbleTip",
    uiPath = "AlertBubbleTip"
  },
  [MainAlBubbleType.Help] = {
    luaPath = "UI.UILWAlliance.UILWAlHelp.Component.UILWAlBubbleTip",
    uiPath = "HelpBubbleTip"
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

function LLMainAllianceBubbles:OnCreate()
  base.OnCreate(self)
  self:DataDefine()
  self:ComponentDefine()
end

function LLMainAllianceBubbles:OnDestroy()
  self:ComponentDestroy()
  self:DataDestroy()
  base.OnDestroy(self)
end

function LLMainAllianceBubbles:OnEnable()
  base.OnEnable(self)
end

function LLMainAllianceBubbles:OnDisable()
  base.OnDisable(self)
end

function LLMainAllianceBubbles:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.RefreshMainAlEvent, self.OnRefreshShow)
  self:AddUIListener(EventId.AllianceQuitOK, self.OnRefreshShow)
end

function LLMainAllianceBubbles:OnRemoveListener()
  self:RemoveUIListener(EventId.RefreshMainAlEvent, self.OnRefreshShow)
  self:RemoveUIListener(EventId.AllianceQuitOK, self.OnRefreshShow)
  base.OnRemoveListener(self)
end

function LLMainAllianceBubbles:DataDefine()
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

function LLMainAllianceBubbles:DataDestroy()
  self.descend = nil
  self.isShow = nil
end

function LLMainAllianceBubbles:ComponentDefine()
  self.bubbles = {}
  for _, type in pairs(self.descend) do
    local path = BubblesPath[type]
    if path then
      self.bubbles[type] = self:AddComponent(require(path.luaPath), path.uiPath)
    end
  end
end

function LLMainAllianceBubbles:ComponentDestroy()
  self.bubbles = nil
end

function LLMainAllianceBubbles:TrySetShow(type, bool)
  if self.isShow[type] ~= bool then
    self.isShow[type] = bool
    self.isDirty = true
  end
end

function LLMainAllianceBubbles:Update()
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

function LLMainAllianceBubbles:SetShow(type, bool)
  if self.bubbles[type] then
    self.bubbles[type]:SetShow(bool)
  end
end

function LLMainAllianceBubbles:OnRefreshShow()
  for _, v in pairs(self.bubbles) do
    v:OnRefreshShow()
  end
end

return LLMainAllianceBubbles
