local UIActEpidemicBattleBuffView = BaseClass("UIActEpidemicBattleBuffView", UIBaseView)
local base = UIBaseView
local RectTransformCSType = typeof(CS.UnityEngine.RectTransform)
local UnityTextMeshProEx = typeof(CS.TextMeshProUGUIEx)
local UnityImage = typeof(CS.UnityEngine.UI.Image)

function UIActEpidemicBattleBuffView:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
  self:RefreshUI()
end

function UIActEpidemicBattleBuffView:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UIActEpidemicBattleBuffView:ComponentDefine()
  self.viewSkin = self:AddComponent(UIViewSkinBridge, "")
  self.btnPanel = self.viewSkin:AddComponent(self, UIButton, 1)
  self.btnPanel:SetOnClick(function()
    self:OnBtnPanelClick()
  end)
  self.textTitle = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 2)
  self.btnClose = self.viewSkin:AddComponent(self, UIButton, 3)
  self.btnClose:SetOnClick(function()
    self:OnBtnCloseClick()
  end)
  self.compContent = self.viewSkin:AddComponent(self, UIBaseComponent, 4)
  self.textDescTitle = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 5)
  self.textDesc = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 6)
  self.compDesc = self.viewSkin:AddComponent(self, UIBaseComponent, 7)
  self.compList = self.viewSkin:AddComponent(self, UIBaseComponent, 8)
  self.textListTitle = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 9)
  self.compListContent = self.viewSkin:AddComponent(self, UIBaseContainer, 10)
  self.compItem = self.viewSkin:AddComponent(self, UIBaseComponent, 11)
  self.textTitle:SetLocalText("YiBianJinQu_rules_title_7")
  self.textDescTitle:SetLocalText("YiBianJinQu_rules_title_11")
  self.textListTitle:SetLocalText("YiBianJinQu_rules_title_12")
end

function UIActEpidemicBattleBuffView:ComponentDestroy()
  self.viewSkin = nil
  self.btnPanel = nil
  self.textTitle = nil
  self.btnClose = nil
  self.compContent = nil
  self.textDescTitle = nil
  self.textDesc = nil
  self.compDesc = nil
  self.compList = nil
  self.textListTitle = nil
  self.compListContent = nil
  self.compItem = nil
end

function UIActEpidemicBattleBuffView:DataDefine()
  self.theItem = self.compItem.gameObject
  self.theItem:GameObjectCreatePool()
  self.template, self.battleType = self:GetUserData()
  self.buffs = self.template.special_effect_para or {}
  self.textDesc:SetLocalText("YiBianJinQu_battle_tips_4", self.template.buff_get_CD)
end

function UIActEpidemicBattleBuffView:DataDestroy()
  for _, v in ipairs(self.compListContent.transform) do
    if v ~= nil then
      CS.UnityEngine.GameObject.Destroy(v.gameObject)
    end
  end
  self.theItem:GameObjectRecycleAll()
end

function UIActEpidemicBattleBuffView:OnAddListener()
  base.OnAddListener(self)
end

function UIActEpidemicBattleBuffView:OnRemoveListener()
  base.OnRemoveListener(self)
end

function UIActEpidemicBattleBuffView:OnBtnPanelClick()
  self.ctrl:CloseSelf()
end

function UIActEpidemicBattleBuffView:OnBtnCloseClick()
  self.ctrl:CloseSelf()
end

function UIActEpidemicBattleBuffView:RefreshUI()
  local mgr
  if self.battleType == BattleFieldType.EpidemicZone then
    mgr = DataCenter.ActEpidemicZoneManager
  elseif self.battleType == BattleFieldType.DsbDuel then
    mgr = BattlefieldDsbDuelUtils.ActInfo
  end
  if mgr then
    for i, v in ipairs(self.buffs) do
      if v ~= nil then
        local goItem = self.theItem:GameObjectSpawn(self.compListContent.transform)
        goItem.name = "time_" .. i
        goItem:SetActive(true)
        local rt = goItem:GetComponent(RectTransformCSType)
        local icon = goItem.transform:Find("ItemIcon"):GetComponent(UnityImage)
        local name = goItem.transform:Find("NameText"):GetComponent(UnityTextMeshProEx)
        local desc = goItem.transform:Find("DescText"):GetComponent(UnityTextMeshProEx)
        local template = mgr:GetTemplateBuffById(v)
        icon:LoadSprite(template.icon)
        name:SetLocalText(template.name)
        if template.getDesc then
          desc.text = template:getDesc()
        else
          desc:SetLocalText(template.desc)
        end
        CS.UnityEngine.UI.LayoutRebuilder.ForceRebuildLayoutImmediate(rt)
      end
    end
    CS.UnityEngine.UI.LayoutRebuilder.ForceRebuildLayoutImmediate(self.compDesc.rectTransform)
    CS.UnityEngine.UI.LayoutRebuilder.ForceRebuildLayoutImmediate(self.compListContent.rectTransform)
    CS.UnityEngine.UI.LayoutRebuilder.ForceRebuildLayoutImmediate(self.compList.rectTransform)
    CS.UnityEngine.UI.LayoutRebuilder.ForceRebuildLayoutImmediate(self.compContent.rectTransform)
  end
end

return UIActEpidemicBattleBuffView
