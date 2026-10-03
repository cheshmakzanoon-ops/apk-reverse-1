local UINpcTalkBubbleHeroEntrust = BaseClass("UINpcTalkBubbleHeroEntrust", UIBaseContainer)
local base = UIBaseContainer
local UINpcTalkBubbleHeroEntrustCell = require("UI.UICityScene.UINpcTalkLayer.Component.UINpcTalkBubbleHeroEntrustCell")
local this_path = ""

function UINpcTalkBubbleHeroEntrust:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function UINpcTalkBubbleHeroEntrust:OnDestroy()
  self:ComponentDestroy()
  self:DataDestroy()
  base.OnDestroy(self)
end

function UINpcTalkBubbleHeroEntrust:ComponentDefine()
  self.btn = self:AddComponent(UIButton, this_path)
  self.btn:SetOnClick(function()
    self:OnBtnClick()
  end)
end

function UINpcTalkBubbleHeroEntrust:ComponentDestroy()
  self.btn = nil
end

function UINpcTalkBubbleHeroEntrust:DataDefine()
  self.param = {}
  self.offset = nil
  self.cells = {}
end

function UINpcTalkBubbleHeroEntrust:DataDestroy()
  self.param = {}
  self.offset = nil
  self.cells = {}
end

function UINpcTalkBubbleHeroEntrust:OnEnable()
  base.OnEnable(self)
end

function UINpcTalkBubbleHeroEntrust:OnDisable()
  base.OnDisable(self)
end

function UINpcTalkBubbleHeroEntrust:OnAddListener()
  base.OnAddListener(self)
end

function UINpcTalkBubbleHeroEntrust:OnRemoveListener()
  base.OnRemoveListener(self)
end

function UINpcTalkBubbleHeroEntrust:ReInit(param)
  self.param = param
  if param.offset == nil then
    self.offset = Vector3.zero
  else
    self.offset = param.offset
  end
  self:ShowCells()
  self:UpdatePos()
end

function UINpcTalkBubbleHeroEntrust:UpdatePos()
  if self.param.target ~= nil then
    local targetPosition = self.param.target.position + self.offset
    local screenPoint
    if DataCenter.BattleLevel:IsInBattleLevel() then
      screenPoint = DataCenter.BattleLevel:WorldToScreenPoint(targetPosition)
    else
      screenPoint = CS.SceneManager.World:WorldToScreenPoint(targetPosition)
    end
    self.btn.transform.position = screenPoint
  end
end

function UINpcTalkBubbleHeroEntrust:OnBtnClick()
  DataCenter.LWSoundManager:PlayEffect(SoundAssetId.SFX_UI_General_Click_1st)
  UIManager:GetInstance():OpenWindow(UIWindowNames.UIHeroEntrust, self.param.id)
end

function UINpcTalkBubbleHeroEntrust:ShowCells()
  for k, v in ipairs(self.cells) do
    v:SetActive(false)
  end
  self.cells = {}
  local template = DataCenter.HeroEntrustTemplateManager:GetHeroEntrustTemplate(self.param.id)
  if template ~= nil then
    for k, v in ipairs(template.need) do
      local param = {}
      param.id = self.param.id
      param.index = k
      param.needType = v.needType
      param.needId = v.needId
      param.count = v.count
      self:GameObjectInstantiateAsync(UIAssets.UINpcTalkBubbleHeroEntrustCell, function(request)
        if request.isError then
          return
        end
        local go = request.gameObject
        go:SetActive(true)
        go.transform:SetParent(self.btn.transform)
        go.transform:Set_localScale(ResetScale.x, ResetScale.y, ResetScale.z)
        local nameStr = tostring(NameCount)
        go.name = nameStr
        NameCount = NameCount + 1
        local model = self.btn:AddComponent(UINpcTalkBubbleHeroEntrustCell, nameStr)
        model:ReInit(param)
        self.cells[k] = model
      end)
    end
  end
end

function UINpcTalkBubbleHeroEntrust:Refresh()
  for k, v in ipairs(self.cells) do
    v:Refresh()
  end
end

return UINpcTalkBubbleHeroEntrust
