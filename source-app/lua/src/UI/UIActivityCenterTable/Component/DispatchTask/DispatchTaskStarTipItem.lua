local DispatchTaskStarTipItem = BaseClass("DispatchTaskStarTipItem", UIBaseContainer)
local base = UIBaseContainer
local UnityImage = typeof(CS.UnityEngine.UI.Image)
local task_rate_path = "taskRate"
local task_level_path = "taskLevel"
local starList_path = "star/starList"
local starTemplate_path = "star/starList/starTemplate"
local starTmpStart_path = "star/starList/tmpStart"
local starTmpEnd_path = "star/starList/tmpEnd"

function DispatchTaskStarTipItem:OnCreate()
  base.OnCreate(self)
  self.task_rate = self:AddComponent(UIText, task_rate_path)
  self.task_level = self:AddComponent(UIText, task_level_path)
  self.starList = self:AddComponent(UIBaseContainer, starList_path)
  self.starTmpStart = self:AddComponent(UIBaseContainer, starTmpStart_path)
  self.starTmpEnd = self:AddComponent(UIBaseContainer, starTmpEnd_path)
  self.starTemplate = self.transform:Find(starTemplate_path).gameObject
  self.starTemplate:GameObjectCreatePool()
  self.starTemplate:SetActive(false)
end

function DispatchTaskStarTipItem:OnDestroy()
  self.starTemplate:GameObjectRecycleAll()
  base.OnDestroy(self)
end

function DispatchTaskStarTipItem:ReInit(starLevel)
  self.starTemplate:GameObjectRecycleAll()
  local sprites = DataCenter.ActDispatchTaskDataManager:GetStarSprites(starLevel)
  for i = 1, #sprites do
    local star = self.starTemplate:GameObjectSpawn(self.starList.transform)
    star.name = "star1" .. i
    star:GetComponent(UnityImage):LoadSprite(string.format(LoadPath.LWCommonPath, sprites[i]))
    star:SetActive(true)
  end
  self.starTmpStart.transform:SetAsFirstSibling()
  self.starTmpEnd.transform:SetAsLastSibling()
  local rate = DataCenter.ActDispatchTaskDataManager:GetTaskRateWithStarLevel(starLevel)
  self.task_rate:SetText(rate)
  local level = DataCenter.ActDispatchTaskDataManager:GetTaskLevelWithStarLevel(starLevel)
  self.task_level:SetText(level)
end

return DispatchTaskStarTipItem
