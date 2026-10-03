local UIHeroSkillDesc = BaseClass("UIHeroSkillDesc", UITextMeshProUGUIEx)
local base = UITextMeshProUGUIEx

local function OnCreate(self)
  base.OnCreate(self)
  if not IsNull(self.unity_tmpro) then
    function self.unity_tmpro.onPointerClick(eventData)
      self:OnPointerClick(eventData)
    end
  end
end

local function OnDestroy(self)
  base.OnDestroy(self)
end

local BG_COLOR = Color.New(0.2392, 0.2627, 0.3568, 1)

function UIHeroSkillDesc:OnPointerClick(eventData)
  if not eventData then
    return
  end
  local clickPos = eventData.position
  local linkId = self:TryGetPointerClickLinkID(clickPos)
  if string.IsNullOrEmpty(linkId) then
    return
  end
  local param = DataCenter.ArrowTipParamManager:Get(ArrowTipEnumtype.Type.HeroSimpleTip)
  param.title = nil
  param.content = UIUtil.GetString("", linkId)
  param.screenPos = clickPos
  param.yPosFix = -40
  param.width = 400
  param.bgColor = BG_COLOR
  param.descTxtColor = WhiteColor
  param.showArrow = false
  param.preferTop = true
  UIManager:GetInstance():OpenWindow(UIWindowNames.UIHeroSimpleTip, {anim = true}, param)
end

UIHeroSkillDesc.OnCreate = OnCreate
UIHeroSkillDesc.OnDestroy = OnDestroy
return UIHeroSkillDesc
