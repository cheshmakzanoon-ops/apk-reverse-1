local UILWSeasonMilitaryCenterWorkItem = BaseClass("UILWSeasonMilitaryCenterWorkItem", UIBaseContainer)
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization

function UILWSeasonMilitaryCenterWorkItem:OnCreate()
  base.OnCreate(self)
  self.bg = self:AddComponent(UIImage, "bg")
  self.build_icon = self:AddComponent(UIButton, "build_icon")
  self.res_item = self:AddComponent(UICommonResItem, "ResItem")
  self.icon = self:AddComponent(UIImage, "icon")
  self.name = self:AddComponent(UITextMeshProUGUIEx, "name")
  self.value = self:AddComponent(UITextMeshProUGUIEx, "value")
  self.btn_tip = self:AddComponent(UIButton, "icon")
  self.btn_tip:SetOnClick(function()
    if self.res_desc_str then
      local param = {}
      param.type = "nameDesc"
      param.title = self.res_name_str
      param.desc = self.res_desc_str
      param.isLocal = true
      param.alignObject = self.icon
      UIManager:GetInstance():OpenWindow(UIWindowNames.UIItemTips, {anim = true}, param)
    end
  end)
  self.build_icon:SetOnClick(function()
    if self.meta then
      local param = {}
      param.type = "nameDesc"
      param.title = Localization:GetString(self.meta.name)
      param.desc = Localization:GetString(self.meta.desc)
      param.isLocal = true
      param.alignObject = self.build_icon
      UIManager:GetInstance():OpenWindow(UIWindowNames.UIItemTips, {anim = true}, param)
    end
  end)
end

function UILWSeasonMilitaryCenterWorkItem:OnDestroy()
  self.bg = nil
  self.res_item = nil
  self.icon = nil
  self.name = nil
  self.value = nil
  base.OnDestroy(self)
end

function UILWSeasonMilitaryCenterWorkItem:ReInit(level, buildId, theBuild)
  self.res_item:SetActive(false)
  local meta = DataCenter.AllianceMineManager:GetAllianceMineTemplate(buildId)
  if meta ~= nil then
    self.meta = meta
    self.res_desc_str = nil
    self.build_icon:LoadSprite(meta:GetCircleIconPath())
    if theBuild == nil then
      self.name:SetText(Localization:GetString(meta.name))
      self.value:SetLocalText("season_s3_alliance_building_ui07", level or "30")
      self.icon:SetActive(false)
      self.res_item:SetActive(false)
    elseif theBuild.status == AllianceMineStatus.Build then
      self.name:SetText(Localization:GetString(meta.name))
      self.value:SetLocalText("season_s3_alliance_building_ui05")
      self.icon:SetActive(false)
      self.res_item:SetActive(false)
    elseif theBuild.status == AllianceMineStatus.Ruin then
      self.name:SetText(Localization:GetString(meta.name))
      self.value:SetLocalText("season_s3_alliance_building_ui06")
      self.icon:SetActive(false)
      self.res_item:SetActive(false)
    elseif theBuild.status == AllianceMineStatus.Normal and not theBuild:Injuried() then
      local speedHour = 0
      local resIconPath
      local theProduceInfo = meta:GetProduceInfo()
      for k, v in pairs(theProduceInfo) do
        if v.ResType then
          speedHour = toInt(v.ResValue) * SEASON_MUMMY_RES_TIME_SCALE
          resIconPath = DataCenter.ResourceManager:GetResourceIconByType(v.ResType)
          self.res_name_str = DataCenter.ResourceManager:GetResourceNameByType(v.ResType)
          self.res_desc_str = DataCenter.ResourceManager:GetResourceDescByType(v.ResType)
          self.res_item:SetActive(false)
          break
        elseif v.itemId then
          local itemId = v.itemId
          speedHour = toInt(v.itemCount) * SEASON_MUMMY_RES_TIME_SCALE
          resIconPath = nil
          self.res_item:SetActive(true)
          self.res_item:ReInit({
            rewardType = RewardType.GOODS,
            itemId = v.itemId,
            enableClick = true,
            hideHaveCountShow = true,
            clickCallBack = function()
              local goods = DataCenter.ItemTemplateManager:GetItemTemplate(itemId)
              if goods ~= nil then
                local param = {}
                param.type = "nameDesc"
                param.title = goods:GetName()
                param.desc = Localization:GetString(goods.description)
                param.isLocal = true
                param.alignObject = self.res_item
                UIManager:GetInstance():OpenWindow(UIWindowNames.UIItemTips, {anim = true}, param)
              end
            end
          })
          break
        end
      end
      if resIconPath == nil then
        self.icon:SetActive(false)
      else
        self.icon:SetActive(true)
        self.icon:LoadSprite(resIconPath)
      end
      local infoPlayer = DataCenter.SeasonDataManager:GetUserSeasonInfo()
      if infoPlayer and infoPlayer:InSettleTime() then
        self.name:SetText(Localization:GetString(meta.name))
        self.value:SetLocalText("season_s3_alliance_building_ui08")
      else
        self.name:SetText(Localization:GetString(meta.name) .. Localization:GetString("season_s3_alliance_building_ui09"))
        self.value:SetText("+" .. speedHour .. "/h")
      end
    else
      local infoPlayer = DataCenter.SeasonDataManager:GetUserSeasonInfo()
      if infoPlayer and infoPlayer:InSettleTime() then
        self.name:SetText(Localization:GetString(meta.name))
        self.value:SetLocalText("season_s3_alliance_building_ui08")
      else
        self.name:SetText(Localization:GetString(meta.name))
        self.value:SetLocalText("season_s3_alliance_building_ui08")
      end
      self.icon:SetActive(false)
      self.res_item:SetActive(false)
    end
  else
    self:SetActive(false)
  end
end

return UILWSeasonMilitaryCenterWorkItem
