local SkyBattleResourceLackView = BaseClass("SkyBattleResourceLackView", UIBaseView)
local base = UIBaseView
local Localization = CS.GameEntry.Localization
local LWResourceLackCell = require("UI.LWResourceLack.Res.Component.LWResourceLackCell")

function SkyBattleResourceLackView:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
  self:ReInit()
end

function SkyBattleResourceLackView:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function SkyBattleResourceLackView:ComponentDefine()
  self.viewSkin = self:AddComponent(UIViewSkinBridge, "")
  self.textTitle = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 1)
  self.btnClose = self.viewSkin:AddComponent(self, UIButton, 2)
  self.btnClose:SetOnClick(function()
    self:OnBtnCloseClick()
  end)
  self.textResourceTitle = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 3)
  self.sliderResourceBar = self.viewSkin:AddComponent(self, UISlider, 4)
  self.textResourceBar = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 5)
  self.imgResourceBarIcon = self.viewSkin:AddComponent(self, UIImage, 6)
  self.compContent = self.viewSkin:AddComponent(self, UIBaseContainer, 7)
end

function SkyBattleResourceLackView:ComponentDestroy()
  self:ClearList()
  self.viewSkin = nil
  self.textTitle = nil
  self.btnClose = nil
  self.textResourceTitle = nil
  self.sliderResourceBar = nil
  self.textResourceBar = nil
  self.imgResourceBarIcon = nil
  self.compContent = nil
end

function SkyBattleResourceLackView:DataDefine()
  self.data = self:GetUserData()
  self.data.id = tonumber(self.data.id)
end

function SkyBattleResourceLackView:DataDestroy()
  self.data = nil
end

function SkyBattleResourceLackView:OnAddListener()
  base.OnAddListener(self)
end

function SkyBattleResourceLackView:OnRemoveListener()
  base.OnRemoveListener(self)
end

function SkyBattleResourceLackView:ReInit()
  self:RefreshBar()
  self:RefreshContent()
end

function SkyBattleResourceLackView:RefreshBar()
  self.imgResourceBarIcon:LoadSprite(DataCenter.LWSkyBattleGrowthChapterManager:GetResourceIconByType(self.data.resType))
  local have = DataCenter.LWSkyBattleGrowthChapterManager.userInfo and DataCenter.LWSkyBattleGrowthChapterManager.userInfo.coin or 0
  local need = self.data.need
  self.textResourceBar:SetText(string.GetFormattedSeperatorNum(have) .. "/" .. string.GetFormattedSeperatorNum(need))
  self.sliderResourceBar:SetValue(have / need)
  local showNum = Mathf.Max(0, need - have)
  local resTypeKey = DataCenter.LWSkyBattleGrowthChapterManager:GetResourceNameByType(self.data.resType)
  self.textResourceTitle:SetText(string.format(Localization:GetString("450011", string.GetFormattedSeperatorNum(showNum), resTypeKey and Localization:GetString(resTypeKey) or "")))
end

function SkyBattleResourceLackView:RefreshContent()
  local resType = self.data.resType
  local templates = DataCenter.LWResourceLackManager:GetResourceWay(resType)
  local need = self.data.need
  local tempDataList
  if not table.IsNullOrEmpty(templates) then
    tempDataList = LWResourceLackUtil:FilterResourceTemplates(templates, need)
  end
  if not tempDataList or #tempDataList == 0 then
    return
  end
  table.sort(tempDataList, function(a, b)
    return a.order < b.order
  end)
  self.dataList = tempDataList
  self.newCells = self.newCells or {}
  self.dataList = self.dataList or {}
  for k, v in ipairs(self.dataList) do
    local data = v
    local index = k
    local cellData = self.newCells[index]
    if data then
      if cellData then
        if cellData.cell then
          self:TryRefreshCell(index, cellData.cell)
        end
      else
        self:CreateCell(index)
      end
    end
  end
  for k, v in pairs(self.newCells) do
    if v.cell and k > #self.dataList then
      v.cell:SetActive(false)
    end
  end
end

function SkyBattleResourceLackView:CreateCell(index)
  local _ = {}
  _.index = index
  _.cell = nil
  _.request = nil
  self.newCells[index] = _
  _.request = self:GameObjectInstantiateAsync(UIAssets.LWLackResourceItem, function(request)
    if request.isError then
      return
    end
    local go = request.gameObject
    go:SetActive(true)
    go.transform:SetParent(self.compContent.transform)
    go.transform:Set_localScale(ResetScale.x, ResetScale.y, ResetScale.z)
    local nameStr = string.format("LWResourceLackCell_%s", _.index)
    go.name = nameStr
    local cell = self.compContent:AddComponent(LWResourceLackCell, nameStr)
    _.cell = cell
    cell:Init()
    self:TryRefreshCell(_.index, cell)
  end)
end

function SkyBattleResourceLackView:TryRefreshCell(index, cell)
  if not cell then
    return
  end
  local data = self.dataList and self.dataList[index]
  if data then
    cell:Refresh(false, data, self.ctrl, self.data)
    cell:SetActive(true)
  else
    cell:SetActive(false)
  end
end

function SkyBattleResourceLackView:ClearList()
  if self.newCells then
    self.compContent:RemoveComponents(LWResourceLackCell)
    for k, v in pairs(self.newCells) do
      if v.request then
        self:GameObjectDestroy(v.request)
      end
    end
    self.newCells = nil
  end
end

function SkyBattleResourceLackView:OnBtnCloseClick()
  self.ctrl:CloseSelf()
end

return SkyBattleResourceLackView
