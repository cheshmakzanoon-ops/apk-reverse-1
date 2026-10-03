local DecorationBookPropertyItem = BaseClass("DecorationBookPropertyItem", UIBaseContainer)
local DecorationBookPropertySubItem = require("UI.LWDecorationBookProperty.Component.DecorationBookPropertySubItem")
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization
local self_path = ""
local content_path = "Content"
local lv_path = "Lv"

function DecorationBookPropertyItem:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function DecorationBookPropertyItem:OnDestroy()
  self:SetAllCellDestroy()
  self:ComponentDestroy()
  self:DataDestroy()
  base.OnDestroy(self)
end

function DecorationBookPropertyItem:ComponentDefine()
  self.content = self:AddComponent(UIBaseContainer, content_path)
  self.lvText = self:AddComponent(UIText, lv_path)
  self.bg = self:AddComponent(UIImage, self_path)
end

function DecorationBookPropertyItem:ComponentDestroy()
  self.content = nil
  self.lvText = nil
end

function DecorationBookPropertyItem:DataDefine()
end

function DecorationBookPropertyItem:DataDestroy()
end

function DecorationBookPropertyItem:SetData(data, index)
  self.data = data
  local isCurLevel = false
  local buildData = DataCenter.BuildManager:GetMaxLvBuildDataByBuildId(self.data.baseBuildingId, true)
  if buildData ~= nil and buildData.level == self.data.level then
    isCurLevel = true
  end
  if isCurLevel then
    self.bg:SetColorRGBA255(221, 242, 186, 255)
  elseif index % 2 == 1 then
    self.bg:SetColorRGBA255(236, 230, 230, 255)
  else
    self.bg:SetColor(WhiteColor)
  end
  local bgEnable = isCurLevel or index % 2 == 1
  self.bg:SetEnable(bgEnable)
  if isCurLevel then
    self.lvText:SetText(Localization:GetString("season_mastery_163", self.data.level) .. " " .. Localization:GetString("optional_box_desc10"))
    self.lvText:SetColorRGBA255(45, 69, 6, 255)
  else
    self.lvText:SetText(Localization:GetString("season_mastery_163", self.data.level))
    self.lvText:SetColorRGBA255(42, 40, 48, 255)
  end
  self.propertyList = self.data.propertyList
  self:SetAllCellDestroy()
  if self.propertyList ~= nil then
    local num = 0
    for i = 1, table.length(self.propertyList) do
      num = num + 1
      self.model[i] = self:GameObjectInstantiateAsync(UIAssets.UIDecorationBookPropertySubItem, function(request)
        if request.isError then
          return
        end
        local go = request.gameObject
        go.gameObject:SetActive(true)
        go.transform:SetParent(self.content.transform)
        go.transform:Set_localScale(ResetScale.x, ResetScale.y, ResetScale.z)
        local nameStr = tostring(NameCount)
        go.name = nameStr
        NameCount = NameCount + 1
        local cell = self.content:AddComponent(DecorationBookPropertySubItem, nameStr)
        local desc, value = WorkerUtil.GetEffectText(self.propertyList[i].effectId, self.propertyList[i].value, true)
        local oneData = {
          name = desc,
          value = value,
          isCurLevel = isCurLevel
        }
        cell:SetData(oneData)
      end)
    end
  end
end

function DecorationBookPropertyItem:SetAllCellDestroy()
  self.content:RemoveComponents(DecorationBookPropertySubItem)
  if self.model ~= nil then
    for k, v in pairs(self.model) do
      if v ~= nil then
        self:GameObjectDestroy(v)
      end
    end
  end
  self.model = {}
end

return DecorationBookPropertyItem
