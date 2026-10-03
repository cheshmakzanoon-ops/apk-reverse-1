local UILWSeasonCityAttachmentDetailView = BaseClass("UILWSeasonCityAttachmentDetailView", UIBaseView)
local base = UIBaseView
local panel_path = "panel"
local dialog_title_text_path = "PopUpTitle/Common_img_title/titleText"
local close_btn_path = "PopUpTitle/CloseBtn"

function UILWSeasonCityAttachmentDetailView:OnCreate()
  base.OnCreate(self)
  local buildId = self:GetUserData()
  self.buildId = toInt(buildId)
  self:ComponentDefine()
  self:UpdateData()
end

function UILWSeasonCityAttachmentDetailView:OnDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UILWSeasonCityAttachmentDetailView:ComponentDefine()
  self.dialog_title_text = self:AddComponent(UIText, dialog_title_text_path)
  self.close_btn = self:AddComponent(UIButton, close_btn_path)
  self.close_btn:SetOnClick(BindCallback(self.ctrl, self.ctrl.CloseSelf))
  self.close_btn1 = self:AddComponent(UIButton, panel_path)
  self.close_btn1:SetOnClick(BindCallback(self.ctrl, self.ctrl.CloseSelf))
  self.icon = self:AddComponent(UIRawImage, "PopUpTitle/bg/icon")
  self.title = self:AddComponent(UITextMeshProUGUIEx, "PopUpTitle/bg/title")
  self.res_num = self:AddComponent(UITextMeshProUGUIEx, "PopUpTitle/bg/GameObject/ResNum")
  self.res_value = self:AddComponent(UITextMeshProUGUIEx, "PopUpTitle/bg/GameObject/ResValue")
  self.mem_num = self:AddComponent(UITextMeshProUGUIEx, "PopUpTitle/bg/GameObject/MemNum")
  self.mem_value = self:AddComponent(UITextMeshProUGUIEx, "PopUpTitle/bg/GameObject/MemValue")
  self.content = self:AddComponent(UIBaseContainer, "PopUpTitle/ScrollView/Viewport/Content")
  self.theEffectItem = self.transform:Find("PopUpTitle/ScrollView/Viewport/Content/effectText").gameObject
  self.theEffectItem:GameObjectCreatePool()
end

function UILWSeasonCityAttachmentDetailView:ComponentDestroy()
  self.content:RemoveComponents(UITextMeshProUGUIEx)
  self.theEffectItem:GameObjectRecycleAll()
  self.btn_back = nil
  self.icon = nil
  self.title = nil
  self.res_num = nil
  self.res_value = nil
  self.mem_num = nil
  self.mem_value = nil
  self.content = nil
  self.effect_text = nil
end

function UILWSeasonCityAttachmentDetailView:UpdateData()
  local cfg = DataCenter.SeasonFarmerTemplateManager:GetBuildTemplateById(self.buildId)
  self.cfg = cfg
  self.dialog_title_text:SetLocalText("100092")
  self.icon:LoadSprite(cfg.icon)
  self.title:SetLocalText(cfg.name)
  self.res_num:SetLocalText("season_builders_alliance_UI_63")
  self.res_value:SetText(string.GetFormattedSeparatorNum(cfg.cost))
  self.mem_num:SetLocalText("season_builders_alliance_UI_64")
  self.mem_value:SetText(string.GetFormattedSeparatorNum(cfg.persons_num))
  self.content:RemoveComponents(UITextMeshProUGUIEx)
  self.theEffectItem:GameObjectRecycleAll()
  if cfg.desc_1 then
    local goItem, theItem
    local effectList = string.split(cfg.desc_1, "|")
    local paramList = string.split(cfg.desc_1_para or "", "|")
    for k, v in ipairs(effectList) do
      goItem = self.theEffectItem:GameObjectSpawn(self.content.transform)
      goItem.name = "item_" .. k
      goItem:SetActive(true)
      theItem = self.content:AddComponent(UITextMeshProUGUIEx, goItem.name)
      theItem:SetLocalText(v, paramList[k] or "")
    end
  end
  CS.UnityEngine.UI.LayoutRebuilder.ForceRebuildLayoutImmediate(self.content.transform)
end

return UILWSeasonCityAttachmentDetailView
