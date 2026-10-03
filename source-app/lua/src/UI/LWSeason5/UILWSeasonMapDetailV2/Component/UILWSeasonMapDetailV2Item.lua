local UILWSeasonMapDetailV2Item = BaseClass("UILWSeasonMapDetailV2Item", UIToggle)
local base = UIToggle

function UILWSeasonMapDetailV2Item:OnCreate()
  base.OnCreate(self)
  self.infoRoot = self:AddComponent(UIImage, "info")
  self.king_badges = self:AddComponent(UIImage, "info/icon")
  self.selectBig = self:AddComponent(UIImage, "selectBig")
  self.name = self:AddComponent(UITextMeshProUGUIEx, "info/name")
  self:SetOnValueChanged(function(tf)
    self:UpdateColor(tf)
  end)
  self.selectBig:SetActive(false)
end

function UILWSeasonMapDetailV2Item:OnDestroy()
  base.OnDestroy(self)
end

function UILWSeasonMapDetailV2Item:UpdateColor(tf)
  if self.serverId == self.mySourceServerId then
    self.name:SetColorHex("#61EF88")
  elseif tf then
    self.name:SetColorHex("#FDC939")
  else
    self.name:SetColorHex("#FFFFFF")
  end
end

function UILWSeasonMapDetailV2Item:ReInit(theMapIndex, serverId, info, mySourceServerId)
  self.theMapIndex = theMapIndex
  self.serverId = serverId
  self.info = info
  self.mySourceServerId = mySourceServerId
  if serverId == nil or serverId == 0 then
    self.name:SetText("#???")
    self.king_badges:LoadSprite("Assets/Main/Sprites/ItemIcons/lrb_zhanqvduijue_tubiao_fuwuqi00.png")
  else
    self.name:SetText("#" .. serverId)
    if serverId == mySourceServerId then
      self.name:SetColorHex("#61EF88")
    end
    if theMapIndex == 5 then
      local kingCfg = DataCenter.AllianceCityTemplateManager:GetKingCityData(serverId)
      if kingCfg and kingCfg.lod_icon ~= nil and kingCfg.lod_icon ~= "" then
        self.king_badges:LoadSprite(kingCfg.lod_icon)
      else
        self.king_badges:LoadSprite("Assets/Main/Sprites/ItemIcons/lrb_zhanqvduijue_tubiao_fuwuqi02.png")
      end
    else
      local badgesIconPath = DataCenter.ZoneWarManager:GetKingdomBadgesIconPath(serverId)
      self.king_badges:LoadSprite(badgesIconPath)
    end
  end
  CS.UnityEngine.UI.LayoutRebuilder.ForceRebuildLayoutImmediate(self.infoRoot.rectTransform)
end

function UILWSeasonMapDetailV2Item:SetSelectMode(mode)
  if mode == 1 then
    self:SetIsOn(false)
    self:UpdateColor(self.theMapIndex ~= 5)
    self.selectBig:SetActive(self.theMapIndex ~= 5)
  elseif mode == 2 then
    self:SetIsOn(self.theMapIndex == 5)
    self:UpdateColor(self.theMapIndex == 5)
    self.selectBig:SetActive(false)
  elseif mode == 3 then
    self:SetIsOn(false)
    self:UpdateColor(false)
    self.selectBig:SetActive(false)
  elseif mode == 4 then
    self:SetIsOn(self.theMapIndex ~= 5)
    self:UpdateColor(self.theMapIndex ~= 5)
    self.selectBig:SetActive(false)
  end
end

return UILWSeasonMapDetailV2Item
