local UILWSeasonSettleTimeTipsS5View = BaseClass("UILWSeasonSettleTimeTipsS5View", UIBaseView)
local base = UIBaseView
local Localization = CS.GameEntry.Localization
local panel_path = "panel"
local close_btn_path = "PopUpTitle/CloseBtn"
local content_path = "PopUpTitle/ScrollView/Viewport/Content"
local title_text_path = "PopUpTitle/ScrollView/Viewport/Content/titleText"
local desc_text_path = "PopUpTitle/ScrollView/Viewport/Content/descText"
local btn_go_path = "PopUpTitle/BtnGo"
local btn_text_path = "PopUpTitle/BtnGo/BtnText"
local bg_path = "PopUpTitle/bg"

function UILWSeasonSettleTimeTipsS5View:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:UpdateData()
  UIUtil.GetMonthActiveCount("SeasonSettleTips", true)
  self.btn_go:SetOnClick(function()
    UIManager:GetInstance():DestroyWindow(UIWindowNames.UILWSeasonSettleTimeTipsS5)
    UIManager:GetInstance():OpenWindow(UIWindowNames.UILWSeasonRank, {anim = true, hideTop = true})
  end)
end

function UILWSeasonSettleTimeTipsS5View:OnDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UILWSeasonSettleTimeTipsS5View:ComponentDefine()
  self.close_btn1 = self:AddComponent(UIButton, panel_path)
  self.close_btn1:SetOnClick(BindCallback(self.ctrl, self.ctrl.CloseSelf))
  self.close_btn = self:AddComponent(UIButton, close_btn_path)
  self.close_btn:SetOnClick(BindCallback(self.ctrl, self.ctrl.CloseSelf))
  self.content = self:AddComponent(UIBaseContainer, content_path)
  self.title_text = self:AddComponent(UIText, title_text_path)
  self.desc_text = self:AddComponent(UIText, desc_text_path)
  self.btn_go = self:AddComponent(UIButton, btn_go_path)
  self.btn_text = self:AddComponent(UITextMeshProUGUIEx, btn_text_path)
  self.bg = self:AddComponent(UIRawImage, bg_path)
end

function UILWSeasonSettleTimeTipsS5View:ComponentDestroy()
  self:CleanTween()
  if self.effectNode then
    self.effectNode:Delete()
    self.effectNode = nil
  end
  self.btn_back = nil
  self.close_btn = nil
  self.content = nil
  self.title_text = nil
  self.desc_text = nil
  self.btn_go = nil
  self.btn_text = nil
  self.bg = nil
end

function UILWSeasonSettleTimeTipsS5View:CleanTween()
  if self.tween ~= nil then
    self.tween:Kill()
  end
  self.tween = nil
end

function UILWSeasonSettleTimeTipsS5View:UpdateData()
  local infoPlayer = DataCenter.SeasonDataManager:GetUserSeasonInfo()
  if infoPlayer and infoPlayer:InSettleTime() then
    local theSeasonType = infoPlayer:GetServerType()
    local world_skin = infoPlayer:GetSkinTemplate()
    if world_skin ~= nil and not string.IsNullOrEmpty(world_skin.finish_tittle) and not string.IsNullOrEmpty(world_skin.finish_info) then
      local dialogStr = Localization:GetString(world_skin.finish_info)
      self.title_text:SetLocalText(world_skin.finish_tittle)
      self.desc_text:SetLocalText(world_skin.finish_info)
      self.btn_text:SetLocalText("450118")
      self.tween = self.desc_text:DOText(dialogStr, 5):OnComplete(function()
        self.tween = nil
        if ComponentIsValid(self.title_text) then
          CS.UnityEngine.UI.LayoutRebuilder.ForceRebuildLayoutImmediate(self.title_text.rectTransform)
        end
        if ComponentIsValid(self.desc_text) then
          CS.UnityEngine.UI.LayoutRebuilder.ForceRebuildLayoutImmediate(self.desc_text.rectTransform)
        end
        if ComponentIsValid(self.content) then
          CS.UnityEngine.UI.LayoutRebuilder.ForceRebuildLayoutImmediate(self.content.rectTransform)
        end
      end)
      if theSeasonType == SeasonMapType.NineNation then
        local effectPath = "Assets/Main/SeasonRes/S5/Prefabs/VX/Eff_UI_SeasonSettleTimeTips_bg.prefab"
        self.bg:SetColorRGBA(1, 1, 1, 0)
        self.effectNode = UIAsyncNode.New("eff_bg", self.bg.transform, effectPath, function(go)
          if IsNotNull(go) then
            go.transform:Set_localPosition(0, 0, 0)
          end
        end)
      else
        local finish_bg = world_skin.finish_bg
        if string.IsNullOrEmpty(finish_bg) then
          finish_bg = "Assets/Main/SeasonRes/S5/Textures/Activity/Bg/ljq_s5_jiesuan.png"
        end
        self.bg:SetColorRGBA(1, 1, 1, 1)
        self.bg:LoadSpriteAsync(finish_bg)
      end
    end
  end
  CS.UnityEngine.UI.LayoutRebuilder.ForceRebuildLayoutImmediate(self.title_text.rectTransform)
  CS.UnityEngine.UI.LayoutRebuilder.ForceRebuildLayoutImmediate(self.desc_text.rectTransform)
  CS.UnityEngine.UI.LayoutRebuilder.ForceRebuildLayoutImmediate(self.content.rectTransform)
end

return UILWSeasonSettleTimeTipsS5View
