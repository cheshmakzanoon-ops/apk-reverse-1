local LWEffectOverviewCanFoldItemTitle = BaseClass("LWEffectOverviewCanFoldItemTitle", UIBaseContainer)
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization
local UILWScienceDetailDesc = require("UI/UILWScience/UILWScienceDetail/Component/UILWScienceDetailDesc")
local icon_path = "Content/iconContent/icon"
local empty_content_path = "Content/emptyContent"
local button_content_path = "Content/buttonContent"
local button_img_path = "Content/buttonContent/buttonImg"

function LWEffectOverviewCanFoldItemTitle:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function LWEffectOverviewCanFoldItemTitle:OnDestroy()
  self:ComponentDestroy()
  self:DataDestroy()
  base.OnDestroy(self)
end

function LWEffectOverviewCanFoldItemTitle:ComponentDefine()
  self.name = self:AddComponent(UILWScienceDetailDesc, "Content/name")
  self.value = self:AddComponent(UIText, "Content/value")
  self.icon = self:AddComponent(UIImage, icon_path)
  self.empty_content = self:AddComponent(UIBaseContainer, empty_content_path)
  self.button_content = self:AddComponent(UIBaseContainer, button_content_path)
  self.button_img = self:AddComponent(UIImage, button_img_path)
end

function LWEffectOverviewCanFoldItemTitle:ComponentDestroy()
  self.name = nil
  self.value = nil
  self.icon = nil
  self.empty_content = nil
  self.button_content = nil
  self.button_img = nil
end

function LWEffectOverviewCanFoldItemTitle:DataDefine()
end

function LWEffectOverviewCanFoldItemTitle:DataDestroy()
end

function LWEffectOverviewCanFoldItemTitle:Refresh(data)
  self.data = data
  self.icon.gameObject:SetActive(false)
  local template = DataCenter.LWEffectOverviewManager:GetTemplate(self.data.id)
  if template then
    if table.count(template.effectSourceList) then
      local effectIdList = template:GetEffectIdListByEffectSourceType(template.effectSourceList[1])
      if table.count(effectIdList) > 0 then
        local totalValue = self.data:GetAllTotalValue()
        local describe, text = WorkerUtil.GetEffectText(effectIdList[1], totalValue, true)
        self.value:SetText(text)
      end
    end
    
    local function ProcessDesc(desc)
      local modifiedText = string.gsub(desc, "<link=", string.format("<color=%s><u><link=", "#FFAC40"))
      modifiedText = string.gsub(modifiedText, "</link>", "</link></u></color>")
      return modifiedText
    end
    
    local des = template.name
    des = Localization:GetString(des)
    des = ProcessDesc(des)
    self.name:SetText(des)
  end
  local effectSourceList = DataCenter.LWEffectOverviewManager:GetUnlockEffectSourceList(self.data.id)
  if 0 < #effectSourceList then
    self.empty_content:SetActive(false)
    self.button_content:SetActive(true)
    if self.data.isShowDetail then
      self.button_img:LoadSprite("Assets/Main/Sprites/UI/LWCommon/Sprite/cfm_lianmeng_anniu_xiala_1.png")
    else
      self.button_img:LoadSprite("Assets/Main/Sprites/UI/LWCommon/Sprite/cfm_lianmeng_anniu_xiala_2.png")
    end
  else
    self.empty_content:SetActive(true)
    self.button_content:SetActive(false)
  end
end

return LWEffectOverviewCanFoldItemTitle
