local UINpcTalkBubble = BaseClass("UINpcTalkBubble", UIBaseContainer)
local base = UIBaseContainer
local this_path = ""
local text_des_path = "TextDes"

function UINpcTalkBubble:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function UINpcTalkBubble:OnDestroy()
  self:ComponentDestroy()
  self:DataDestroy()
  base.OnDestroy(self)
end

function UINpcTalkBubble:ComponentDefine()
  self.imgBg = self:AddComponent(UIBaseContainer, this_path)
  self.textDesc = self:AddComponent(UIText, text_des_path)
end

function UINpcTalkBubble:ComponentDestroy()
  self.imgBg = nil
  self.textDesc = nil
end

function UINpcTalkBubble:DataDefine()
  self.param = {}
  self.offset = nil
end

function UINpcTalkBubble:DataDestroy()
  self.param = {}
  self.offset = nil
end

function UINpcTalkBubble:OnEnable()
  base.OnEnable(self)
end

function UINpcTalkBubble:OnDisable()
  base.OnDisable(self)
end

function UINpcTalkBubble:OnAddListener()
  base.OnAddListener(self)
end

function UINpcTalkBubble:OnRemoveListener()
  base.OnRemoveListener(self)
end

function UINpcTalkBubble:ReInit(param)
  self.param = param
  if param.dialogId == nil then
    self.textDesc:SetText("")
  elseif type(param.dialogId) == "number" then
    self.textDesc:SetLocalText(param.dialogId)
  else
    self.textDesc:SetText(param.dialogId)
  end
  if param.offset == nil then
    self.offset = Vector3.zero
  else
    self.offset = param.offset
  end
  self:UpdatePos()
end

function UINpcTalkBubble:UpdatePos()
  if self.param.target ~= nil then
    local targetPosition = self.param.target.position + self.offset
    local screenPoint
    if DataCenter.BattleLevel:IsInBattleLevel() then
      screenPoint = DataCenter.BattleLevel:WorldToScreenPoint(targetPosition)
    else
      screenPoint = CS.SceneManager.World:WorldToScreenPoint(targetPosition)
    end
    self.imgBg.transform.position = screenPoint
  end
end

return UINpcTalkBubble
