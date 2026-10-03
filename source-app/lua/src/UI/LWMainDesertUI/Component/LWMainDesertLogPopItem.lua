local LWMainDesertLogPopItem = BaseClass("LWMainDesertLogPopItem", UIBaseContainer)
local base = UIBaseContainer
local my_head_path = "root/MyHead/UIPlayerHead"
local icon_type_path = "root/TypeIcon"
local icon_build_path = "root/BuildIcon"
local text_build_path = "root/BuildIcon/BuildNum"
local icon_res_path = "root/ResIcon"
local text_res_path = "root/ResIcon/ResNum"
local enemy_content_path = "root/EnemyHead"
local first_sign_path = "root/FirstSign"
local item_path = "root/HeadItem"

function LWMainDesertLogPopItem:OnCreate()
  base.OnCreate(self)
  self.anim = self:AddComponent(UIAnimator, "")
  self.my_head = self:AddComponent(UICommonHead, my_head_path)
  self.icon_type = self:AddComponent(UIImage, icon_type_path)
  self.icon_build = self:AddComponent(UIImage, icon_build_path)
  self.text_build = self:AddComponent(UIText, text_build_path)
  self.icon_res = self:AddComponent(UIImage, icon_res_path)
  self.text_res = self:AddComponent(UIText, text_res_path)
  self.enemy_content = self:AddComponent(UIBaseContainer, enemy_content_path)
  self.first_sign = self:AddComponent(UIImage, first_sign_path)
  self.theItem = self.transform:Find(item_path).gameObject
  self.theItem:GameObjectCreatePool()
end

function LWMainDesertLogPopItem:OnDestroy()
  if self.timer then
    self.timer:Stop()
  end
  self.timer = nil
  self.enemy_content:RemoveComponents(UICommonHead)
  self.enemy_content = nil
  self.theItem:GameObjectRecycleAll()
  self.theItem = nil
  base.OnDestroy(self)
end

function LWMainDesertLogPopItem:ReInit(logData)
  self.my_head:ParseHeadInfo(logData)
  self.icon_build:SetActive(false)
  self.icon_res:SetActive(false)
  self.first_sign:SetActive(false)
  self.enemy_content:SetActive(false)
  local type = logData.type
  if type == 1 then
    self:UpdateBuild(logData)
  elseif type == 2 then
    self:UpdateEnemy(logData)
  elseif type == 3 then
    self:UpdateBuild(logData)
  elseif type == 4 then
    self:UpdateRes(logData)
  elseif type == 5 then
    self:UpdateEnemy(logData)
  elseif type == 6 then
    self:UpdateRes(logData)
  elseif type == 7 then
    self:UpdateEnemy(logData)
  elseif type == 8 then
    self:UpdateBuild(logData)
    self.first_sign:SetActive(true)
  end
  local typePath = LocalController:instance():getValue(TableName.Desert_Battle_Hero_Actions, type, "icon")
  if string.IsNullOrEmpty(typePath) then
    self.icon_type:SetActive(false)
  else
    self.icon_type:SetActive(true)
    local path = typePath
    if not string.startswith(typePath, "Assets/") then
      path = string.format(LoadPath.LWBattleFieldDesertPath, typePath)
    end
    self.icon_type:LoadSpriteAsyncWithCallback(path, function()
      if self.icon_type then
        self.icon_type:SetNativeSize()
      end
    end)
  end
end

function LWMainDesertLogPopItem:UpdateBuild(logData)
  self.icon_build:SetActive(true)
  self.text_build:SetText(logData.score)
  local status
  if logData.score > 0 then
    self.text_build:SetColorRGBA(0.4392156862745098, 0.8745098039215686, 0.9450980392156862, 1)
    status = 5
  else
    self.text_build:SetColorRGBA(0.984313725490196, 0.44313725490196076, 0.33725490196078434, 1)
    status = 4
  end
  local sprite_path = DataCenter.DragonBuildTemplateManager:GetDragonMiniMapSpritePathByStatus(logData.cityId, status)
  self.icon_build:LoadSpriteAuto(sprite_path)
end

function LWMainDesertLogPopItem:UpdateEnemy(logData)
  self.enemy_content:SetActive(true)
  self.enemy_content:RemoveComponents(UICommonHead)
  self.theItem:GameObjectRecycleAll()
  local array = logData.rightPlayerArray or {}
  local maxNum = math.min(#array, 5)
  if logData.type == 7 then
    maxNum = 1
  end
  local goItem
  for i = 1, maxNum do
    local info = array[i]
    goItem = self.theItem:GameObjectSpawn(self.enemy_content.transform)
    goItem.name = "item_" .. i
    goItem:SetActive(true)
    local headItem = self.enemy_content:AddComponent(UIBaseContainer, goItem.name)
    headItem:SetLocalScaleXYZ(0.45, 0.45, 1)
    local headIcon = headItem:AddComponent(UICommonHead, "UIPlayerHead")
    headIcon:ParseHeadInfo(info)
  end
end

function LWMainDesertLogPopItem:UpdateRes(logData)
  self.icon_res:SetActive(true)
  self.text_res:SetText(logData.score)
end

function LWMainDesertLogPopItem:PlayAnim(cb)
  if self.timer then
    self.timer:Stop()
  end
  self.timer = nil
  local animName = "start"
  self.anim:Play(animName, 0, 0)
  local ret, time = self.anim:GetAnimationReturnTime(animName)
  if ret then
    self.timer = TimerManager:GetInstance():DelayInvoke(function()
      if self.timer then
        self.timer:Stop()
      end
      self.timer = nil
      if cb then
        cb()
      end
    end, time)
  end
end

return LWMainDesertLogPopItem
