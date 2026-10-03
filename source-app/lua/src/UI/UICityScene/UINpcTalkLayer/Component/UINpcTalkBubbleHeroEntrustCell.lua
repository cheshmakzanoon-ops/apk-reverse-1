local UINpcTalkBubbleHeroEntrustCell = BaseClass("UINpcTalkBubbleHeroEntrustCell", UIBaseContainer)
local base = UIBaseContainer
local this_path = ""
local submit_go_path = "SubmitGo"

function UINpcTalkBubbleHeroEntrustCell:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function UINpcTalkBubbleHeroEntrustCell:OnDestroy()
  self:ComponentDestroy()
  self:DataDestroy()
  base.OnDestroy(self)
end

function UINpcTalkBubbleHeroEntrustCell:ComponentDefine()
  self.icon = self:AddComponent(UIImage, this_path)
  self.submit_go = self:AddComponent(UIBaseContainer, submit_go_path)
end

function UINpcTalkBubbleHeroEntrustCell:ComponentDestroy()
  self.icon = nil
  self.submit_go = nil
end

function UINpcTalkBubbleHeroEntrustCell:DataDefine()
  self.param = {}
end

function UINpcTalkBubbleHeroEntrustCell:DataDestroy()
  self.param = {}
end

function UINpcTalkBubbleHeroEntrustCell:OnEnable()
  base.OnEnable(self)
end

function UINpcTalkBubbleHeroEntrustCell:OnDisable()
  base.OnDisable(self)
end

function UINpcTalkBubbleHeroEntrustCell:OnAddListener()
  base.OnAddListener(self)
end

function UINpcTalkBubbleHeroEntrustCell:OnRemoveListener()
  base.OnRemoveListener(self)
end

function UINpcTalkBubbleHeroEntrustCell:ReInit(param)
  self.param = param
  if param.needType == HeroEntrustNeedType.ResourceItem then
    local template = DataCenter.ResourceItemDataManager:GetResourceItemTemplate(param.needId)
    if template ~= nil then
      self.icon:LoadSprite(string.format(LoadPath.ItemPath, template.pic))
    end
  elseif param.needType == HeroEntrustNeedType.Resource then
    self.icon:LoadSprite(DataCenter.ResourceManager:GetResourceIconByType(param.needId))
  elseif param.needType == HeroEntrustNeedType.Goods then
    local template = DataCenter.ItemTemplateManager:GetItemTemplate(param.needId)
    if template ~= nil then
      self.icon:LoadSprite(string.format(LoadPath.ItemPath, template.icon))
    end
  end
  self:Refresh()
end

function UINpcTalkBubbleHeroEntrustCell:Refresh()
  local isComplete = DataCenter.HeroEntrustManager:IsCompleteByIndex(self.param.id, self.param.index)
  self.submit_go:SetActive(isComplete)
end

return UINpcTalkBubbleHeroEntrustCell
