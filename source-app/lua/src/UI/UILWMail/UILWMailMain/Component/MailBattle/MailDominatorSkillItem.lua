local MailDominatorSkillItem = BaseClass("MailDominatorSkillItem", UIBaseContainer)
local base = UIBaseContainer
local UIHeroSkillStar = require("UI.UILWHero.UIHeroDetailPanel.Component.UIHeroSkillStar")

local function OnCreate(self)
  base.OnCreate(self)
  self:ComponentDefine()
end

local function OnDestroy(self)
  self:RemoveStars()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

local function ComponentDefine(self)
  self.icon = self:AddComponent(UIImage, "icon_img")
  self.stars = self:AddComponent(UIBaseContainer, "stars")
  self.lv_txt = self:AddComponent(UIText, "lv_txt")
  self.lock_content = self:AddComponent(UIBaseContainer, "lockContent")
end

local function ComponentDestroy(self)
  self.icon = nil
  self.stars = nil
  self.lv_txt = nil
end

local function SetData(self, skillInfo)
  if not skillInfo then
    self:SetActive(false)
    return
  end
  self:SetActive(true)
  local path = skillInfo.skillTemplateData.icon
  self.icon:LoadSprite(path)
  if skillInfo:IsReachGroupMaxLevel() then
    self.lv_txt:SetLocalText("110000")
  else
    self.lv_txt:SetText(string.format("Lv.%d", skillInfo:GetLevel()))
  end
  self:RefreshStars(skillInfo:GetStar())
  self.lock_content:SetActive(not skillInfo:IsUnlock())
end

local STAR_PATH = "Assets/Main/Prefabs/UI/LWMail/MailBattle/dominator/StarTemplate.prefab"

local function RefreshStars(self, starCount)
  if self.starCount and self.starCount == starCount then
    return
  end
  self:RemoveStars()
  local showStarCount = math.min(starCount, 5)
  local leftWindow = math.max(0, starCount - 5)
  for i = 1, showStarCount do
    local viewStarIndex = leftWindow + i
    local starReq = self:GameObjectInstantiateAsync(STAR_PATH, function(req)
      local obj = req.gameObject
      if IsNull(obj) then
        return
      end
      local transform = obj.transform
      transform:SetParent(self.stars.transform, false)
      transform:Set_localScale(1, 1, 1)
      local name = string.format("star_%s", i)
      obj.name = name
      local comp = self.stars:AddComponent(UIHeroSkillStar, name)
      comp:SetActive(true)
      comp:SetFilled(true)
      comp:SetStarIndex(viewStarIndex)
    end)
    if not self.starReqs then
      self.starReqs = {}
    end
    table.insert(self.starReqs, starReq)
  end
end

local function RemoveStars(self)
  if self.starReqs then
    self.stars:RemoveComponents(UIHeroSkillStar)
    for i = 1, #self.starReqs do
      self:GameObjectDestroy(self.starReqs[i])
    end
    self.starReqs = nil
  end
end

MailDominatorSkillItem.OnCreate = OnCreate
MailDominatorSkillItem.OnDestroy = OnDestroy
MailDominatorSkillItem.OnEnable = OnEnable
MailDominatorSkillItem.OnDisable = OnDisable
MailDominatorSkillItem.ComponentDefine = ComponentDefine
MailDominatorSkillItem.ComponentDestroy = ComponentDestroy
MailDominatorSkillItem.SetData = SetData
MailDominatorSkillItem.RefreshStars = RefreshStars
MailDominatorSkillItem.RemoveStars = RemoveStars
return MailDominatorSkillItem
