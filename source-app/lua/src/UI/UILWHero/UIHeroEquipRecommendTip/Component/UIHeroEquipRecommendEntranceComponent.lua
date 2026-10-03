local base = UIBaseContainer
local UIHeroEquipRecommendEntranceComponent = BaseClass("UIHeroEquipRecommendEntranceComponent", UIBaseContainer)
local Localization = CS.GameEntry.Localization

function UIHeroEquipRecommendEntranceComponent:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function UIHeroEquipRecommendEntranceComponent:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UIHeroEquipRecommendEntranceComponent:ComponentDefine()
  self.btnEquipRecommend = self:AddComponent(UIButton, "")
  self.btnEquipRecommend:SetOnClick(function()
    self:OnBtnEquipRecommendClick()
  end)
  self.textEquipRecommend = self:AddComponent(UIText, "EquipRecommendText")
  self.textEquipRecommend:SetLocalText("equip_recommend_desc_1")
  self.compTipsRoot = self:AddComponent(UIBaseContainer, "EquipRecommendRoot")
  self.imgEquipRecommend = self:AddComponent(UIImage, "EquipRecommendIcon")
end

function UIHeroEquipRecommendEntranceComponent:ComponentDestroy()
  self.btnEquipRecommend = nil
  self.textEquipRecommend = nil
  self.compTipsRoot = nil
  self.imgEquipRecommend = nil
end

function UIHeroEquipRecommendEntranceComponent:DataDefine()
end

function UIHeroEquipRecommendEntranceComponent:DataDestroy()
end

function UIHeroEquipRecommendEntranceComponent:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.HeroEquipRecommendSwitchSuccess, self.OnSwitchSuccess)
  self:AddUIListener(EventId.HeroEquipRecommendFunctionOpenChanged, self.OnFunctionOpenChanged)
end

function UIHeroEquipRecommendEntranceComponent:OnRemoveListener()
  self:RemoveUIListener(EventId.HeroEquipRecommendSwitchSuccess, self.OnSwitchSuccess)
  self:RemoveUIListener(EventId.HeroEquipRecommendFunctionOpenChanged, self.OnFunctionOpenChanged)
  base.OnRemoveListener(self)
end

function UIHeroEquipRecommendEntranceComponent:ReInit()
  local isFunctionOpen = DataCenter.EquipRecommendManager:IsFunctionOpen()
  local showSelf = isFunctionOpen
  self.transform.gameObject:SetActive(showSelf)
  if showSelf then
    local curSquadIndex = DataCenter.EquipRecommendManager:GetCurSquadIndex()
    local isOn = curSquadIndex ~= nil and 0 < curSquadIndex
    if isOn then
      self.imgEquipRecommend:LoadSprite("Assets/Main/Sprites/UI/LWHeroRecommend/lrb_zhuangbeituijian_icon_on")
    else
      self.imgEquipRecommend:LoadSprite("Assets/Main/Sprites/UI/LWHeroRecommend/lrb_zhuangbeituijian_icon_off")
    end
  end
end

function UIHeroEquipRecommendEntranceComponent:OnSwitchSuccess()
  self:ReInit(self.squadIndex)
end

function UIHeroEquipRecommendEntranceComponent:OnFunctionOpenChanged()
  self:ReInit(self.squadIndex)
end

function UIHeroEquipRecommendEntranceComponent:OnBtnEquipRecommendClick()
  if not DataCenter.EquipRecommendManager:IsFunctionOpen() then
    return
  end
  local param = {}
  param.alignObject = self.compTipsRoot.transform
  param.yPosFix = 10
  param.squadIndex = self.squadIndex
  param.showArrow = false
  UIManager:GetInstance():OpenWindow(UIWindowNames.UIHeroEquipRecommendTip, {anim = true}, param)
end

return UIHeroEquipRecommendEntranceComponent
