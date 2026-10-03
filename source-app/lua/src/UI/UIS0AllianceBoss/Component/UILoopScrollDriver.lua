local base = UIBaseContainer
local UILoopScrollDriver = BaseClass("UILoopScrollDriver", UIBaseContainer)
local UILoopScrollTextVer = require("UI.UIS0AllianceBoss.Component.UILoopScrollTextVer")
local Localization = CS.GameEntry.Localization
local txt_item_path = "txt_item"

function UILoopScrollDriver:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function UILoopScrollDriver:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UILoopScrollDriver:ComponentDefine()
  self.viewSkin = self:AddComponent(UIViewSkinBridge, "")
  self.btnClick = self.viewSkin:AddComponent(self, UIButton, 1)
  self.btnClick:SetOnClick(function()
    self:OnBtnClickClick()
  end)
  self.textTxtNone = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 2)
  self.compContent = self.viewSkin:AddComponent(self, UIBaseContainer, 3)
  self.theItemPool = self.transform:Find(txt_item_path).gameObject
  self.theItemPool:GameObjectCreatePool()
  self.itemes = {}
end

function UILoopScrollDriver:ComponentDestroy()
  self.compContent:RemoveComponents(UITextMeshProUGUIEx)
  self.theItemPool:GameObjectRecycleAll()
  self.itemes = nil
  self.viewSkin = nil
  self.btnClick = nil
  self.textTxtNone = nil
  self.compContent = nil
end

function UILoopScrollDriver:DataDefine()
  self.scrollTextVer = UILoopScrollTextVer.New()
  self.itemList = {}
  self.trueItemList = {}
  self.noInfo = nil
end

function UILoopScrollDriver:DataDestroy()
  self.dataList = nil
  self.scrollTextVer:Delete()
  self.scrollTextVer = nil
  self.itemList = nil
  self.trueItemList = nil
  self.noInfo = nil
end

function UILoopScrollDriver:OnAddListener()
  base.OnAddListener(self)
end

function UILoopScrollDriver:OnRemoveListener()
  base.OnRemoveListener(self)
end

function UILoopScrollDriver:InitItem(showCrit)
  local noInfo = true
  if showCrit then
    local donateList = DataCenter.S0AllianceBossDataManager.donateList
    if donateList and 0 < #donateList then
      self.compContent:SetActive(true)
      self.dataList = donateList
      self:RefreshItems()
      noInfo = false
      self.scrollTextVer:InitCom(1, 76)
      self.scrollTextVer:BindItems(self.trueItemList, self.compContent)
      self.scrollTextVer:Refresh()
    end
  end
  self.textTxtNone:SetActive(noInfo)
  if noInfo then
    self:ClearTextVerTimer()
    self.compContent:SetActive(false)
    self.textTxtNone:SetLocalText("zone_mobilization_donated_no_data")
  end
  self.noInfo = noInfo
end

function UILoopScrollDriver:RefreshItems()
  if self.dataList then
    table.clear(self.trueItemList)
    if self.itemList and #self.itemList > 0 then
      local itemCount = #self.itemList
      local index = 0
      for i, v in ipairs(self.dataList) do
        if i > itemCount then
          local item = self.theItemPool:GameObjectSpawn(self.compContent.transform)
          local name = tostring(i)
          item.name = name
          local cell = self.compContent:AddComponent(UITextMeshProUGUIEx, name)
          cell:SetText(self:GetContext(v))
          cell:SetActive(true)
          table.insert(self.itemList, cell)
          table.insert(self.trueItemList, cell)
        else
          local cell = self.itemList[i]
          if cell then
            cell:SetText(self:GetContext(v))
            cell:SetActive(true)
            table.insert(self.trueItemList, cell)
          end
        end
        index = i
      end
      if itemCount > index then
        for i = index + 1, itemCount do
          local cell = self.itemList[i]
          if cell then
            cell:SetActive(false)
          end
        end
      end
    else
      local name
      for i, v in ipairs(self.dataList) do
        local item = self.theItemPool:GameObjectSpawn(self.compContent.transform)
        name = tostring(i)
        item.name = name
        local cell = self.compContent:AddComponent(UITextMeshProUGUIEx, name)
        cell:SetText(self:GetContext(v))
        table.insert(self.itemList, cell)
        table.insert(self.trueItemList, cell)
      end
    end
  end
end

function UILoopScrollDriver:GetContext(info)
  if info then
    if info.multi >= 10 then
      return Localization:GetString("s0_alliance_boss_donate_crit_color", info.name, info.multi)
    end
    return Localization:GetString("s0_alliance_boss_donate_crit", info.name, info.multi)
  end
end

function UILoopScrollDriver:OnBtnClickClick()
  if self.noInfo then
    UIUtil.ShowTipsId("s0_alliance_boss_donate_nodata_tips")
    return
  end
  UIManager:GetInstance():OpenWindow(UIWindowNames.UIS0AllianceBossBuildRecord)
end

function UILoopScrollDriver:ClearTextVerTimer()
  if self.scrollTextVer then
    self.scrollTextVer:RemoveTimer()
  end
end

return UILoopScrollDriver
