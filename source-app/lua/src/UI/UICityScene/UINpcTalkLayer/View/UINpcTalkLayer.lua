local UINpcTalkLayer = BaseClass("UINpcTalkLayer", UIBaseView)
local base = UIBaseView
local UINpcTalkBubble = require("UI.UICityScene.UINpcTalkLayer.Component.UINpcTalkBubble")
local UINpcTalkBubbleHeroEntrust = require("UI.UICityScene.UINpcTalkLayer.Component.UINpcTalkBubbleHeroEntrust")
local content_path = "Content"
local touch_blocker_path = "TouchBlocker"

function UINpcTalkLayer:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
  self:ReInit()
end

function UINpcTalkLayer:OnDestroy()
  self:ComponentDestroy()
  self:DataDestroy()
  base.OnDestroy(self)
end

function UINpcTalkLayer:ComponentDefine()
  self.nodeContent = self:AddComponent(UIBaseContainer, content_path)
  self.touchBlocker = self:AddComponent(UIButton, touch_blocker_path)
  self.touchBlocker:SetOnClick(function()
    self:OnTouchBlockerClick()
  end)
end

function UINpcTalkLayer:ComponentDestroy()
  self.nodeContent = nil
  self.touchBlocker = nil
end

function UINpcTalkLayer:DataDefine()
  self.bubbleDict = {}
  self.blockTime = nil
  self.masterBubble = nil
  self.deleteList = {}
end

function UINpcTalkLayer:DataDestroy()
  self.bubbleDict = {}
  self.blockTime = nil
  self.masterBubble = nil
  self.deleteList = nil
end

function UINpcTalkLayer:OnEnable()
  base.OnEnable(self)
end

function UINpcTalkLayer:OnDisable()
  base.OnDisable(self)
end

function UINpcTalkLayer:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.ShowTalkBubble, self.ShowTalkBubbleSignal)
  self:AddUIListener(EventId.HideTalkBubble, self.HideTalkBubbleSignal)
  self:AddUIListener(EventId.RefreshNpcTalkBubbleActive, self.RefreshNpcTalkBubbleActiveSignal)
end

function UINpcTalkLayer:OnRemoveListener()
  self:RemoveUIListener(EventId.ShowTalkBubble, self.ShowTalkBubbleSignal)
  self:RemoveUIListener(EventId.HideTalkBubble, self.HideTalkBubbleSignal)
  self:RemoveUIListener(EventId.RefreshNpcTalkBubbleActive, self.RefreshNpcTalkBubbleActiveSignal)
  base.OnRemoveListener(self)
end

function UINpcTalkLayer:ReInit()
end

function UINpcTalkLayer:ShowTalkBubbleSignal(param)
  if param ~= nil then
    self:CreateTalkBubble(param)
  end
end

function UINpcTalkLayer:HideTalkBubbleSignal(param)
  if param ~= nil then
    self:RemoveTalkBubble(param.target)
  end
end

function UINpcTalkLayer:CreateTalkBubble(param)
  if param ~= nil then
    local target = param.target
    if target ~= nil then
      do
        local force = (param.force == true or param.force == nil) and true or false
        if force or self.bubbleDict[target] == nil then
          if self.bubbleDict[target] == nil then
            self.bubbleDict[target] = {}
          end
          param.modelName, param.scripName = self:GetModelNameAndScriptNameByTalkType(param.talkType)
          if self.bubbleDict[target].param ~= nil and self.bubbleDict[target].param.modelName ~= param.modelName then
            self:RemoveTalkBubble(target)
          end
          self.bubbleDict[target].param = param
          if self.bubbleDict[target].inst == nil then
            self.bubbleDict[target].inst = self:GameObjectInstantiateAsync(param.modelName, function(request)
              if request.isError then
                return
              end
              local go = request.gameObject
              go:SetActive(true)
              go.transform:SetParent(self.nodeContent.transform)
              go.transform:Set_localScale(ResetScale.x, ResetScale.y, ResetScale.z)
              local nameStr = tostring(NameCount)
              go.name = nameStr
              NameCount = NameCount + 1
              local model = self.nodeContent:AddComponent(self.bubbleDict[target].param.scripName, nameStr)
              if model ~= nil then
                model:ReInit(self.bubbleDict[target].param)
                self.bubbleDict[target].model = model
                self.blockTime = self.bubbleDict[target].param.blockTime
                if self.blockTime ~= nil then
                  self.masterBubble = model
                  self.touchBlocker:SetActive(true)
                end
              end
              if self.bubbleDict[target].param.visible == false then
                go:SetActive(false)
              end
            end)
          elseif self.bubbleDict[target].model ~= nil then
            self.bubbleDict[target].model:ReInit(self.bubbleDict[target].param)
            self.blockTime = self.bubbleDict[target].param.blockTime
            if self.blockTime ~= nil then
              self.masterBubble = self.bubbleDict[target].model
              self.touchBlocker:SetActive(true)
            end
          end
        end
      end
    end
  end
end

function UINpcTalkLayer:RemoveTalkBubble(target)
  if target ~= nil and self.bubbleDict[target] ~= nil then
    if self.bubbleDict[target].model ~= nil then
      if self.masterBubble ~= nil and self.masterBubble == self.bubbleDict[target].model then
        self.blockTime = nil
        self.masterBubble = nil
        self.touchBlocker:SetActive(false)
      end
      self.nodeContent:RemoveComponent(self.bubbleDict[target].model.gameObject.name, self.bubbleDict[target].scripName)
      self.bubbleDict[target].model:OnDestroy()
    end
    if self.bubbleDict[target].inst ~= nil then
      self.bubbleDict[target].inst:Destroy()
    end
    self.bubbleDict[target] = nil
  end
end

function UINpcTalkLayer:GetModelNameAndScriptNameByTalkType(talkType)
  if talkType == NpcTalkType.Left then
    return UIAssets.UINpcTalkBubbleLeft, UINpcTalkBubble
  elseif talkType == NpcTalkType.Right then
    return UIAssets.UINpcTalkBubbleRight, UINpcTalkBubble
  elseif talkType == NpcTalkType.HeroEntrust then
    return UIAssets.UINpcTalkBubbleHeroEntrust, UINpcTalkBubbleHeroEntrust
  end
  return UIAssets.UINpcTalkBubbleRight, UINpcTalkBubble
end

function UINpcTalkLayer:TickDuration(deltaTime)
  table.clear(self.deleteList)
  for k, v in pairs(self.bubbleDict) do
    if v.model ~= nil and v.param.duration ~= nil then
      if v.param.duration <= 0 then
        table.insert(self.deleteList, k)
      else
        v.param.duration = v.param.duration - deltaTime
      end
    end
  end
  for _, target in pairs(self.deleteList) do
    self:RemoveTalkBubble(target)
  end
end

function UINpcTalkLayer:Update()
  local deltaTime = Time.deltaTime
  if self.blockTime ~= nil and self.blockTime > 0 then
    self.blockTime = self.blockTime - deltaTime
  end
  self:TickDuration(deltaTime)
  for k, v in pairs(self.bubbleDict) do
    if v.model ~= nil and v.model.activeSelf then
      v.model:UpdatePos()
    end
  end
end

function UINpcTalkLayer:OnTouchBlockerClick()
  if (self.blockTime == nil or self.blockTime <= 0) and self.masterBubble ~= nil then
    self:RemoveTalkBubble(self.masterBubble.target)
    DataCenter.GuideManager:DoNext()
  end
end

function UINpcTalkLayer:RefreshNpcTalkBubbleActiveSignal(param)
  if param ~= nil then
    for k, v in pairs(self.bubbleDict) do
      if v.param.target == param.target then
        v.param.visible = param.visible
        if v.model ~= nil then
          v.model:SetActive(param.visible)
        end
      end
    end
  end
end

function UINpcTalkLayer:RefreshHeroEntrustSignal(id)
  for k, v in pairs(self.bubbleDict) do
    if v.model ~= nil then
      v.model:Refresh()
    end
  end
end

return UINpcTalkLayer
