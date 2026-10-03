local base = UIBaseContainer
local T11SoldierSelectSkillComponent = BaseClass("T11SoldierSelectSkillComponent", UIBaseContainer)
local M = T11SoldierSelectSkillComponent
local T11SoldierSkillItemComponent = require("UI.T11Common.T11SoldierSkillItemComponent")
local skillPath = "Assets/Main/Prefabs/UI/T11/T11Common/T11SoldierSkillItem_SelectSoldier_2.prefab"

function M:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function M:OnDestroy()
  self:ClearScroll()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function M:ComponentDefine()
  self.viewSkin = self:AddComponent(UIViewSkinBridge, "")
  self.compSkillItem = self.viewSkin:AddComponent(self, T11SoldierSkillItemComponent, 1)
  self.textSkillName = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 2)
  self.textSkillDesc = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 3)
  self.textSoldierSKillListTitle = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 4)
  self.compList = self.viewSkin:AddComponent(self, UIBaseContainer, 5)
end

function M:ComponentDestroy()
  self.compSkillItem = nil
  self.textSkillName = nil
  self.textSkillDesc = nil
  self.textSoldierSKillListTitle = nil
  self.compList = nil
end

function M:DataDefine()
  self.ctrl = nil
  self.soldierASkillInfos = nil
  self.soldierBSkillInfos = nil
  self.skillRequestList = {}
  self.skillNodeList = {}
end

function M:DataDestroy()
  self.ctrl = nil
  self.soldierASkillInfos = nil
  self.soldierBSkillInfos = nil
  self.skillRequestList = nil
  self.skillNodeList = nil
end

function M:OnAddListener()
  base.OnAddListener(self)
end

function M:OnRemoveListener()
  base.OnRemoveListener(self)
end

function M:Init(ctrl)
  self.ctrl = ctrl
  self:ClearScroll()
  self.textSoldierSKillListTitle:SetLocalText("soldier_eleven_army_skill")
end

function M:GetSKillInfos(curSelect)
  local skillInfos
  if curSelect == T11SoldierType.T11SoldierTypeA then
    if not self.soldierASkillInfos then
      self.soldierASkillInfos = self.ctrl:GetAllSkillsInfo(curSelect)
    end
    skillInfos = self.soldierASkillInfos
  end
  if curSelect == T11SoldierType.T11SoldierTypeB then
    if not self.soldierBSkillInfos then
      self.soldierBSkillInfos = self.ctrl:GetAllSkillsInfo(curSelect)
    end
    skillInfos = self.soldierBSkillInfos
  end
  if not skillInfos then
    Logger.LogError("skillInfos is nil")
    return
  end
  return skillInfos.initSkillInfo, skillInfos.otherSkillInoList
end

function M:RefreshSkillList(curSelect)
  local initSkillInfo, skillInfos = self:GetSKillInfos(curSelect)
  self.compSkillItem:Init(initSkillInfo)
  self.textSkillName:SetLocalText(initSkillInfo.name)
  self.textSkillDesc:SetLocalText(initSkillInfo.desc)
  self:RefreshSkillNode(skillInfos)
end

function M:RefreshSkillNode(skillInfos)
  if not self.skillNodeList or table.length(self.skillNodeList) == 0 then
    for i = 1, table.length(skillInfos) do
      self.skillRequestList[i] = self:GameObjectInstantiateAsync(skillPath, function(request)
        if request.isError then
          return
        end
        local go = request.gameObject
        go.gameObject:SetActive(true)
        go.transform:SetParent(self.compList.transform)
        go.transform:Set_localScale(1, 1, 1)
        go.name = "item" .. i
        local cell = self.compList:AddComponent(T11SoldierSkillItemComponent, go.name)
        cell:Init(skillInfos[i], true)
        table.insert(self.skillNodeList, cell)
      end)
    end
  else
    for k, v in pairs(self.skillNodeList) do
      if v ~= nil then
        v:Init(skillInfos[k], true)
      end
    end
  end
end

function M:ClearScroll()
  self.compList:RemoveComponents(T11SoldierSkillItemComponent)
  if self.skillRequestList ~= nil then
    for _, v in pairs(self.skillRequestList) do
      if v ~= nil then
        self:GameObjectDestroy(v)
      end
    end
  end
  self.skillRequestList = {}
  self.skillNodeList = {}
end

return T11SoldierSelectSkillComponent
