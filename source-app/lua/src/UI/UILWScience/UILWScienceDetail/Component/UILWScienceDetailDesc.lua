local UILWScienceDetailDesc = BaseClass("UILWScienceDetailDesc", UITextMeshProUGUIEx)
local base = UITextMeshProUGUIEx
local Localization = CS.GameEntry.Localization

local function OnCreate(self)
  base.OnCreate(self)
  self.param = nil
  if not IsNull(self.unity_tmpro) then
    function self.unity_tmpro.onPointerClick(eventData)
      self:OnPointerClick(eventData)
    end
  end
end

local function OnDestroy(self)
  self.param = nil
  base.OnDestroy(self)
end

local BG_COLOR = Color.New(1, 1, 1, 1)

function UILWScienceDetailDesc:OnPointerClick(eventData)
  if not eventData then
    return
  end
  local clickPos = eventData.position
  local linkId = self:TryGetPointerClickLinkID(clickPos)
  if string.IsNullOrEmpty(linkId) then
    return
  end
  if self.param and self.param.descType == ScienceDetailDescType.TacticalWeaponSkillStarUp then
    local weaponInfo = DataCenter.TacticalWeaponManager:GetFirstWeaponInfo()
    if weaponInfo then
      local skillInfos = weaponInfo:GetSkillInfos()
      local skillInfo
      if not table.IsNullOrEmpty(skillInfos) then
        skillInfo = skillInfos[1]
      end
      if skillInfo then
        clickPos.y = clickPos.y - 10
        if self.param.level > 0 then
          local titleText = Localization:GetString("tech_skill_preview_desc_1")
          UIManager:GetInstance():OpenWindow(UIWindowNames.UILWTacticalWeaponSkillDetailScienceDetail, {anim = true}, skillInfo, nil, clickPos, titleText)
        else
          local nextStar = skillInfo:GetStar() + 1
          if nextStar <= skillInfo:GetMaxStar() then
            local starUpSkillTemplate = DataCenter.HeroSkillTemplateManager:GetTemplateByGroupIdAndStar(skillInfo:GetGroupId(), nextStar)
            if starUpSkillTemplate then
              local nextSkillInfo = SkillInfo.New()
              nextSkillInfo:CreateFromTemplate(starUpSkillTemplate.id, true, skillInfo.level, nextStar)
              local titleText = Localization:GetString("tech_skill_preview_desc_2")
              UIManager:GetInstance():OpenWindow(UIWindowNames.UILWTacticalWeaponSkillDetailScienceDetail, {anim = true}, nextSkillInfo, nil, clickPos, titleText)
            end
          end
        end
      end
    end
  else
    local param = DataCenter.ArrowTipParamManager:Get(ArrowTipEnumtype.Type.HeroSimpleTip)
    param.title = nil
    if self.param and self.param.contentParam then
      param.content = UIUtil.GetString("", linkId, SafeUnpack(self.param.contentParam))
    else
      param.content = UIUtil.GetString("", linkId)
    end
    param.screenPos = clickPos
    param.yPosFix = self.param and self.param.yPosFix or -40
    param.width = self.param and self.param.width or 400
    param.bgColor = BG_COLOR
    param.descTxtColor = BlackColor
    param.showArrow = false
    param.preferTop = true
    UIManager:GetInstance():OpenWindow(UIWindowNames.UIHeroSimpleTip, {anim = true}, param)
  end
end

function UILWScienceDetailDesc:SetTextAndParam(text, param)
  self:SetText(text)
  self.param = param
end

UILWScienceDetailDesc.OnCreate = OnCreate
UILWScienceDetailDesc.OnDestroy = OnDestroy
return UILWScienceDetailDesc
