local base = UIButton
local CityAttachmentBuildItem = BaseClass("CityAttachmentBuildItem", base)

function CityAttachmentBuildItem:OnCreate()
  base.OnCreate(self)
  self.grayMask = self:AddComponent(UIRawImage, "ExpBg")
  self.icon = self:AddComponent(UIRawImage, "icon")
  self.btn_text = self:AddComponent(UITextMeshProUGUIEx, "BtnText")
  self.build_icon = self:AddComponent(UIImage, "buildIcon")
  self.exp_text = self:AddComponent(UITextMeshProUGUIEx, "ExpText")
  self:SetOnClick(function()
    if self.slotIndex and self.pointData and self.pointData.cityId then
      local cfg = DataCenter.SeasonFarmerTemplateManager:GetCityAttachmentTemplate(self.pointData.cityId)
      UIManager:GetInstance():OpenWindow(UIWindowNames.UILWSeasonAttachmentBuildDetail, {anim = true}, self.slotIndex, self.buildCfg, cfg, self.slotHasFirst)
    elseif self.buildCfg then
      local param = {}
      param.type = "desc"
      param.title = ""
      param.desc = self.buildCfg:GetDesc()
      param.isLocal = true
      param.alignObject = self.icon
      UIManager:GetInstance():OpenWindow(UIWindowNames.UIItemTips, {anim = true}, param)
    end
  end)
end

function CityAttachmentBuildItem:OnDestroy()
  self.icon = nil
  self.btn_text = nil
  self.build_icon = nil
  self.exp_text = nil
  base.OnDestroy(self)
end

function CityAttachmentBuildItem:RefreshData(slotIndex, pointData, buildCfg, serverData, slotHasFirst)
  self.slotIndex = slotIndex
  self.buildCfg = buildCfg
  self.pointData = pointData
  self.slotHasFirst = slotHasFirst or false
  if serverData == nil then
    self:LoadSprite("Assets/Main/Sprites/UI/LWCommon/Sprite/cfm_tongyong_daojukuang_1.png")
    self.btn_text:SetLocalText("372138")
    self.build_icon:SetActive(false)
    self.exp_text:SetActive(false)
    self.grayMask:SetActive(true)
    self.icon:LoadSprite(buildCfg.iconSmall)
  else
    if serverData.state == 0 then
      self.build_icon:SetActive(true)
      self.exp_text:SetActive(true)
      self.grayMask:SetActive(true)
      self.exp_text:SetText(string.percentage(serverData.exp, buildCfg.cost))
    else
      self.grayMask:SetActive(false)
      self.build_icon:SetActive(false)
      self.exp_text:SetActive(false)
    end
    self.icon:LoadSprite(buildCfg.icon)
    self:LoadSprite("Assets/Main/Sprites/UI/LWCommon/Sprite/cfm_tongyong_daojukuang_3.png")
    if serverData and serverData.allianceAbbr then
      self.btn_text:SetText("[" .. serverData.allianceAbbr .. "]")
    elseif buildCfg then
      self.btn_text:SetLocalText(buildCfg.name)
    end
  end
end

return CityAttachmentBuildItem
