local UIVipExtendCitySkinDetailShowView = BaseClass("UIVipExtendCitySkinDetailShowView", UIBaseView)
local base = UIBaseView
local Localization = CS.GameEntry.Localization
local UIDecorationMainCity = require("UI.UIDecoration.UIDecorationMain.Component.UIDecorationMainCity")
local bg_path = "bg"
local making_root_path = "makingRoot"
local complete_root_path = "completeRoot"
local u_i_player_head_path = "UIPlayerHead"
local city_name_path = "cityName"
local player_name_path = "playerName"
local desc_path = "descScrollView/Viewport/desc"
local city_render_texture_path = "completeRoot/cityRenderTexture"

function UIVipExtendCitySkinDetailShowView:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
  self:OnReInit()
end

function UIVipExtendCitySkinDetailShowView:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UIVipExtendCitySkinDetailShowView:ComponentDefine()
  self.city_name = self:AddComponent(UITextMeshProUGUIEx, city_name_path)
  self.making_root = self:AddComponent(UIBaseContainer, making_root_path)
  self.complete_root = self:AddComponent(UIBaseContainer, complete_root_path)
  self.compUIPlayerHead = self:AddComponent(UICommonHead, u_i_player_head_path)
  self.player_name = self:AddComponent(UITextMeshProUGUIEx, player_name_path)
  self.desc = self:AddComponent(UITextMeshProUGUIEx, desc_path)
  self.city_render_texture = self:AddComponent(UIDecorationMainCity, city_render_texture_path)
  self.city_render_texture:SetRtFormat(CS.UnityEngine.RenderTextureFormat.ARGBHalf)
  self.city_render_texture:SetActive(false)
  self.bg = self:AddComponent(UIButton, bg_path)
  self.bg:SetOnClick(function()
    self.ctrl:CloseSelf()
  end)
end

function UIVipExtendCitySkinDetailShowView:ComponentDestroy()
  self.compUIPlayerHead = nil
  self.city_name = nil
  self.making_root = nil
  self.complete_root = nil
  self.bg = nil
  self.player_name = nil
  self.desc = nil
end

function UIVipExtendCitySkinDetailShowView:DataDefine()
end

function UIVipExtendCitySkinDetailShowView:DataDestroy()
end

function UIVipExtendCitySkinDetailShowView:OnAddListener()
  base.OnAddListener(self)
end

function UIVipExtendCitySkinDetailShowView:OnRemoveListener()
  base.OnRemoveListener(self)
end

function UIVipExtendCitySkinDetailShowView:OnReInit()
  self.skinInfo = self:GetUserData()
  self:Refresh()
end

function UIVipExtendCitySkinDetailShowView:Refresh()
  if not self.skinInfo then
    return
  end
  local playerId = self.skinInfo.playerInfo.uid == "" and self.skinInfo.playerId or self.skinInfo.playerInfo.uid
  local isMyself = playerId == LuaEntry.Player.uid
  if isMyself then
    self.skinInfo = DataCenter.VipExtendManager:GetMyselfSkinInfo()
  end
  self.compUIPlayerHead:SetData("", "player_head_3", 0)
  if self.skinInfo.anonymity == nil or self.skinInfo.anonymity == 0 then
    if isMyself then
      self.compUIPlayerHead:SetAsMyself()
    else
      self.compUIPlayerHead:SetData(self.skinInfo.playerInfo.uid, self.skinInfo.playerInfo.pic, self.skinInfo.playerInfo.picver)
    end
    self.player_name:SetText(UIUtil.FormatServerAllianceName(self.skinInfo.playerInfo.serverId, self.skinInfo.playerInfo.abbr, self.skinInfo.playerInfo.name))
  elseif self.skinInfo.anonymity == 1 then
    self.player_name:SetText(UIUtil.FormatServerAllianceName(0, "", Localization:GetString("vip_base_skin_anonymous_name")))
  elseif self.skinInfo.anonymity == 100 then
    self.player_name:SetText(UIUtil.FormatServerAllianceName(0, "", Localization:GetString("vip_base_skin_anonymous_name")))
  end
  self.making_root.gameObject:SetActive(self.skinInfo.displayType == 1)
  self.complete_root.gameObject:SetActive(self.skinInfo.displayType == 2 or self.skinInfo.displayType == 3)
  local skinId = tonumber(self.skinInfo.displayPara2)
  local skinData = DataCenter.DecorationDataManager:GetSkinDataById(skinId)
  local skinTemplate = DataCenter.DecorationTemplateManager:GetTemplate(skinId)
  if self.skinInfo.displayType == 2 or self.skinInfo.displayType == 3 then
    local rtData = {}
    rtData.decorationId = tonumber(self.skinInfo.displayPara2)
    self.city_render_texture:ReInit(rtData)
  end
  if skinTemplate ~= nil and not string.IsNullOrEmpty(skinTemplate.name) then
    self.city_name:SetLocalText(skinTemplate.name)
  else
    self.city_name:SetLocalText("decoration_name16003")
  end
  if not string.IsNullOrEmpty(self.skinInfo.displayPara3) then
    self.desc:SetLocalText(self.skinInfo.displayPara3)
  else
    self.desc:SetLocalText("decoration_desc16003")
  end
  CS.UnityEngine.UI.LayoutRebuilder.ForceRebuildLayoutImmediate(self.desc.rectTransform)
end

return UIVipExtendCitySkinDetailShowView
