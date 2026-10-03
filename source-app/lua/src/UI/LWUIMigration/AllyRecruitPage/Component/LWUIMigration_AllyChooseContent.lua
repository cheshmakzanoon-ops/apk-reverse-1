local base = UIAsyncContainer
local LWUIMigration_AllyChooseContent = BaseClass("LWUIMigration_AllyChooseContent", base)
local Localization = CS.GameEntry.Localization
local LWUIMigration_AllyTagItem = require("UI.LWUIMigration.AllyRecruitPage.Component.LWUIMigration_AllyTagItem")

function LWUIMigration_AllyChooseContent:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function LWUIMigration_AllyChooseContent:OnDestroy()
  self:ClearTagItemReq()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function LWUIMigration_AllyChooseContent:ComponentDefine()
  self.viewSkin = self:AddComponent(UIViewSkinBridge, "")
  self.compTagContent = self.viewSkin:AddComponent(self, UIBaseContainer, 1)
  self.textTips = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 2)
  self.compFavorItemTag = self.viewSkin:AddComponent(self, LWUIMigration_AllyTagItem, 3)
  self.compLanguageItemTag = self.viewSkin:AddComponent(self, LWUIMigration_AllyTagItem, 4)
end

function LWUIMigration_AllyChooseContent:ComponentDestroy()
  self.viewSkin = nil
  self.compTagContent = nil
  self.textTips = nil
  self.compFavorItemTag = nil
  self.compLanguageItemTag = nil
end

function LWUIMigration_AllyChooseContent:DataDefine()
end

function LWUIMigration_AllyChooseContent:DataDestroy()
end

function LWUIMigration_AllyChooseContent:OnAddListener()
  base.OnAddListener(self)
end

function LWUIMigration_AllyChooseContent:OnRemoveListener()
  base.OnRemoveListener(self)
end

function LWUIMigration_AllyChooseContent:InitTags()
  self.tagsInit = true
  local tableData = {}
  LocalController:instance():visitTable(TableName.LW_Migration_Alliance_Tag, function(id, lineData)
    local data = {
      id = id,
      searchTag = self.filterData.searchTag,
      type = ActMigrationAllianceTagType.Normal
    }
    table.insert(tableData, data)
  end)
  self:ClearTagItemReq()
  for k, v in ipairs(tableData) do
    self.tagItemReq[k] = self:GameObjectInstantiateAsync(UIAssets.UIMigrationAllianceTagItem, function(request)
      if request.isError then
        return
      end
      local go = request.gameObject
      go.gameObject:SetActive(true)
      go.transform:SetParent(self.compTagContent.transform)
      go.transform:Set_localScale(ResetScale.x, ResetScale.y, ResetScale.z)
      go.name = k
      local cell = self.compTagContent:AddComponent(LWUIMigration_AllyTagItem, go.name)
      cell:SetData(tableData[k])
    end)
  end
end

function LWUIMigration_AllyChooseContent:ShowTags(filterData)
  self.filterData = filterData
  if not self.tagsInit then
    self:InitTags()
  end
  self.compFavorItemTag:SetData({
    type = ActMigrationAllianceTagType.Favor,
    isOn = filterData.saveTag
  })
  self.compLanguageItemTag:SetData({
    type = ActMigrationAllianceTagType.Language,
    lang = filterData.searchLanguageId,
    isOn = filterData.saveLang
  })
end

function LWUIMigration_AllyChooseContent:ClearTagItemReq()
  if self.tagItemReq then
    for k, v in ipairs(self.tagItemReq) do
      self:GameObjectDestroy(v)
    end
  end
  self.tagItemReq = {}
  self.compTagContent:RemoveComponents(LWUIMigration_AllyTagItem)
end

return LWUIMigration_AllyChooseContent
