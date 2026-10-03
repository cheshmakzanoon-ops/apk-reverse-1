local base = require("UI.UILWHero.UIHeroSimpleTip.View.UIArrowTipBase")
local UIFirstPayHeroTipView = BaseClass("UIFirstPayHeroTipView", base)
local Localization = CS.GameEntry.Localization
local UIHeroCellSmall = require("UI.UIHero2.Common.UIHeroCellSmall")
local UIHeroSkillItem = require("UI.UILWHero.UIHeroDetailPanel.Component.UIHeroSkillItem")
local PropItem = require("UI.UIFirstPayHeroTip.Component.PropItem")
local HeroUtils = require("UI.UIHero2.HeroUtils")
local SkillInfo = require("DataCenter.HeroData.SkillInfo")
local UIHeroSkillItemPrefabPath = "Assets/Main/Prefabs/UI/UIFirstPay/FirstPayHeroTipSkillItem.prefab"

function UIFirstPayHeroTipView:ComponentDefine()
  base.ComponentDefine(self)
  self.viewSkin = self:AddComponent(UIViewSkinBridge, "")
  self.compHeroCell = self.viewSkin:AddComponent(self, UIBaseComponent, 1)
  self.textHeroNickNameTxt = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 2)
  self.textHeroNameTxt = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 3)
  self.imgHeroJobIcon = self.viewSkin:AddComponent(self, UIImage, 4)
  self.imgHeroTypeIcon = self.viewSkin:AddComponent(self, UIImage, 5)
  self.textTip1Txt = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 6)
  self.compProps = self.viewSkin:AddComponent(self, UIBaseContainer, 7)
  self.compSkills = self.viewSkin:AddComponent(self, UIBaseContainer, 8)
  self.compSelectedSkillDetail = self.viewSkin:AddComponent(self, UIBaseComponent, 9)
  self.textSkillNameTxt = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 10)
  self.textSkillCDTxt = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 11)
  self.descTxt = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 12)
  self.scrollRectDescContent = self.viewSkin:AddComponent(self, UIScrollRect, 13)
  self.compSkillContainer = self.viewSkin:AddComponent(self, UILayoutElement, 14)
  if self.descTxt and self.descTxt.OnPointerClick then
    self.descTxt:OnPointerClick(function(eventData)
      if not eventData then
        return
      end
      local clickPos = eventData.position
      local linkId = self.descTxt:TryGetPointerClickLinkID(clickPos)
      if string.IsNullOrEmpty(linkId) then
        return
      end
      local param = DataCenter.ArrowTipParamManager:Get(ArrowTipEnumtype.Type.HeroSimpleTip)
      param.title = nil
      param.content = UIUtil.GetString("", linkId)
      param.screenPos = clickPos
      param.yPosFix = -40
      param.width = 400
      param.bgColor = Color.New(0.2392, 0.2627, 0.3568, 1)
      param.descTxtColor = WhiteColor
      param.showArrow = false
      param.preferTop = true
      UIManager:GetInstance():OpenWindow(UIWindowNames.UIHeroSimpleTip, {anim = true}, param)
    end)
  end
end

function UIFirstPayHeroTipView:ComponentDestroy()
  self.viewSkin = nil
  self.compHeroCell = nil
  self.textHeroNickNameTxt = nil
  self.textHeroNameTxt = nil
  self.imgHeroJobIcon = nil
  self.imgHeroTypeIcon = nil
  self.textTip1Txt = nil
  self.compProps = nil
  self.compSkills = nil
  self.compSelectedSkillDetail = nil
  self.textSkillNameTxt = nil
  self.textSkillCDTxt = nil
  self.descTxt = nil
  self.scrollRectDescContent = nil
  self.compSkillContainer = nil
end

function UIFirstPayHeroTipView:RefreshSkills(heroInfo)
  if not heroInfo or heroInfo == 0 then
    return
  end
  if self.compSkills and self.compSkills.components then
    self.compSkills:Walk(function(comp)
      if comp and comp.SetActive then
        comp:SetActive(false)
      end
    end)
  end
  self._skillItems = self._skillItems or {}
  if not heroInfo then
    return
  end
  local skills = {}
  for slotIndex = 1, 4 do
    local sd = heroInfo:GetHeroSkillBySlotIndex(slotIndex)
    if sd then
      table.insert(skills, sd)
    end
  end
  for i, sd in ipairs(skills) do
    local name = string.format("SkillItem_%d", i)
    local req = self:GameObjectInstantiateAsync(UIHeroSkillItemPrefabPath)
    req:completed("+", function()
      if req.isError or IsNull(req.gameObject) or IsNull(self.compSkills) then
        return
      end
      local go = req.gameObject
      go.name = name
      local transform = go.transform
      transform:SetParent(self.compSkills.transform)
      transform:Set_localScale(0.67424, 0.67424, 0.67424)
      transform:Set_localPosition(0, 0, 0)
      local item = self.compSkills:AddComponent(UIHeroSkillItem, name)
      item:SetData(sd, {
        showSkillName = false,
        showSkillLevel = true,
        showLock = false,
        showRedPoint = false,
        showStar = true,
        showSkillMaxLevel = false
      }, function(skillData, skillItem)
        if self and self.OnSkillTemplateClick and skillData then
          self:OnSkillTemplateClick(skillData:GetId(), skillData:GetLevel(), skillData.addMaxLv or 0, skillItem)
        end
      end)
      table.insert(self._skillItems, item)
    end)
  end
end

function UIFirstPayHeroTipView:OnSkillTemplateClick(skillId, level, addMaxLv, skillItem)
  local isSame = self._selectedSkillId == skillId
  if self._selectedSkillItem and self._selectedSkillItem.SetSelected then
    self._selectedSkillItem:SetSelected(false)
  end
  self._selectedSkillItem = skillItem
  if self._selectedSkillItem and self._selectedSkillItem.SetSelected then
    self._selectedSkillItem:SetSelected(true)
  end
  self._selectedSkillId = skillId
  if not isSame then
    PostEventLog.Track(PostEventLog.Defines.on_firstpay_herotip_chooseskill, {
      type = tostring(skillId)
    })
  end
  self._tmpSkillInfo = self._tmpSkillInfo or SkillInfo.New()
  local skillInfo = self._tmpSkillInfo
  skillInfo:CreateFromTemplate(skillId, true, level or 1)
  if self.textSkillNameTxt then
    self.textSkillNameTxt:SetText(skillInfo:GetName())
  end
  local cdText = ""
  local castType = skillInfo:GetSkillDisplayCastType()
  if castType == SkillCastType.AutoAttack or castType == SkillCastType.Active then
    local cd = skillInfo:GetCoolDownTime(nil)
    cdText = string.format("CD:<color=#0C9C4A>%.2fs</color>", cd)
  end
  if self.textSkillCDTxt then
    self.textSkillCDTxt:SetText(cdText)
  end
  local desc = skillInfo:GetDesc(false, "#0C9C4A")
  desc = string.gsub(desc, "#5FEF87", "#0C9C4A")
  desc = string.gsub(desc, "#5fef87", "#0C9C4A")
  desc = string.gsub(desc, "#5FEF87FF", "#0C9C4AFF")
  desc = string.gsub(desc, "#5fef87ff", "#0C9C4AFF")
  if self.descTxt then
    self.descTxt:SetText(desc)
  end
  if self.compSelectedSkillDetail then
    self.compSelectedSkillDetail:SetActive(true)
    self.compSkillContainer:SetPreferredHeight(285)
    if self.ReAlign then
      self:ReAlign()
    end
  end
  if self.scrollRectDescContent and self.scrollRectDescContent.SetVerticalNormalizedPosition then
    self.scrollRectDescContent:SetVerticalNormalizedPosition(1)
  end
end

function UIFirstPayHeroTipView:RefreshProps(heroInfo)
  if not heroInfo or heroInfo == 0 then
    return
  end
  local atk, def, army, hp = 0, 0, 0, 0
  if heroInfo then
    atk = heroInfo:GetAtk() or 0
    def = heroInfo:GetDef() or 0
    army = heroInfo:GetSoldierCapacity() or 0
    hp = heroInfo:GetMaxHp() or 0
  end
  local atkName = "100150"
  local hpName = "100153"
  local defName = "130066"
  local armyName = "211245"
  self._propItems = self._propItems or {}
  
  local function addProp(nameKey, value)
    local item = self.compProps:LoadComponentAsync(PropItem, PropItem.PrefabPath, self.compProps)
    if item then
      item:SetName(string.format("Prop_%s", tostring(nameKey)))
      item:SetData(nameKey, value)
      table.insert(self._propItems, item)
    end
  end
  
  addProp(atkName, math.floor(tonumber(atk) or 0))
  addProp(hpName, math.floor(tonumber(hp) or 0))
  addProp(defName, math.floor(tonumber(def) or 0))
  addProp(armyName, math.floor(tonumber(army) or 0))
end

function UIFirstPayHeroTipView:RefreshShow()
  base.RefreshShow(self)
  local p = self.param or {}
  local heroId = tonumber(p.heroId) or 0
  if heroId == 0 then
    return
  end
  local heroTemplate = DataCenter.HeroTemplateManager:GetTemplate(heroId)
  if not heroTemplate then
    return
  end
  self.heroTemplateData = HeroInfo.New()
  self.heroTemplateData:UpdateFromTemplate(heroId, p.heroLv, p.heroRank, IntMaxValue)
  self._selectedSkillItem = nil
  self._selectedSkillId = nil
  if self.compSelectedSkillDetail then
    self.compSelectedSkillDetail:SetActive(false)
    self.compSkillContainer:SetPreferredHeight(97)
    if self.ReAlign then
      self:ReAlign()
    end
  end
  if self.textHeroNickNameTxt then
    self.textHeroNickNameTxt:SetLocalText(heroTemplate.nickName)
  end
  if self.textHeroNameTxt then
    self.textHeroNameTxt:SetLocalText(heroTemplate.name)
  end
  if not self._heroCell and not self.heroReq then
    local parent = self.compHeroCell
    local view = self
    self.heroReq = self:GameObjectInstantiateAsync(UIAssets.UIHeroCellSmall, function(req)
      if req.isError or IsNull(req.gameObject) or IsNull(view.compHeroCell) then
        return
      end
      local go = req.gameObject
      go:SetActive(true)
      go.transform:SetParent(view.compHeroCell.transform)
      go.transform:Reset()
      go.name = "UIHeroCellSmall"
      view._heroCell = view:AddComponent(UIHeroCellSmall, go.gameObject)
      if view._heroCell then
        view._heroCell:InitWithConfigId(heroId, nil, p.heroLv, p.heroRank)
        view._heroCell:ToggleLevel(false)
        view._heroCell:SetRank(0)
        view._heroCell:ToggleRank(false)
        view._heroCell:ToggleJob(false)
        if view._heroCell.img_type then
          view._heroCell.img_type:SetEnable(false)
        end
      end
    end)
  end
  if self._heroCell then
    self._heroCell:InitWithConfigId(heroId, nil, p.heroLv, p.heroRank)
    self._heroCell:ToggleLevel(false)
    self._heroCell:SetRank(0)
    self._heroCell:ToggleRank(false)
    self._heroCell:ToggleJob(false)
    if self._heroCell.img_type then
      self._heroCell.img_type:SetEnable(false)
    end
  end
  if self.imgHeroJobIcon then
    self.imgHeroJobIcon:LoadSprite(HeroUtils.GetHeroJobIcon(heroTemplate.job, 2))
  end
  if self.imgHeroTypeIcon then
    self.imgHeroTypeIcon:LoadSprite(HeroUtils.GetHeroTypeIcon(heroTemplate.type, false))
  end
  self:RefreshProps(self.heroTemplateData)
  self:RefreshSkills(self.heroTemplateData)
  CS.UnityEngine.UI.LayoutRebuilder.ForceRebuildLayoutImmediate(self.bgRoot.transform)
end

return UIFirstPayHeroTipView
