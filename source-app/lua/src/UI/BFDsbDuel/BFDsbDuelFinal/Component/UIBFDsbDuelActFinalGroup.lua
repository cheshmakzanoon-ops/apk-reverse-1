local base = UIBaseContainer
local UIBFDsbDuelActFinalGroup = BaseClass("UIBFDsbDuelActFinalGroup", UIBaseContainer)
local Localization = CS.GameEntry.Localization
local UIBFDsbDuelActFinalGroupItem = require("UI.BFDsbDuel.BFDsbDuelFinal.Component.UIBFDsbDuelActFinalGroupItem")

function UIBFDsbDuelActFinalGroup:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function UIBFDsbDuelActFinalGroup:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UIBFDsbDuelActFinalGroup:ComponentDefine()
  self.viewSkin = self:AddComponent(UIViewSkinBridge, "")
  self.textRank = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 1)
  self.compListContent = self.viewSkin:AddComponent(self, UIBaseContainer, 2)
end

function UIBFDsbDuelActFinalGroup:ComponentDestroy()
  self.viewSkin = nil
  self.textRank = nil
  self.compListContent = nil
end

function UIBFDsbDuelActFinalGroup:DataDefine()
  self.itemList = {}
end

function UIBFDsbDuelActFinalGroup:DataDestroy()
  self.itemList = nil
end

function UIBFDsbDuelActFinalGroup:OnAddListener()
  base.OnAddListener(self)
end

function UIBFDsbDuelActFinalGroup:OnRemoveListener()
  base.OnRemoveListener(self)
end

function UIBFDsbDuelActFinalGroup:SetData(data)
  self.data = data
  local count = #data
  self:SetActive(0 < count)
  if 0 < count then
    self.textRank:SetText(Localization:GetString("dsb_duel_guide_tips_1025", string.format("%d-%d", self.data[1].rank, self.data[count].rank)))
    for i = 1, count do
      if self.itemList[i] then
        if self.itemList[i]:AsyncLoadDone() then
          self.itemList[i]:SetActive(true)
          self.itemList[i]:SetData(self.data[i])
        end
      else
        local luaPath = "UI.BFDsbDuel.BFDsbDuelFinal.Component.UIBFDsbDuelActFinalGroupItem"
        local prefabPath = "Assets/Main/Prefabs/UI/BF_Dsb_Duel/Act/Final/UIBFDsbDuelActFinalGroupItem.prefab"
        local refData = self.data[i]
        self.itemList[i] = UIBaseComponent.LoadComponentAsync(self, luaPath, prefabPath, self.compListContent, function(holder, go, item)
          item:SetData(refData)
        end)
      end
    end
    for i = count + 1, #self.itemList do
      self.itemList[i]:SetActive(false)
    end
  end
end

return UIBFDsbDuelActFinalGroup
