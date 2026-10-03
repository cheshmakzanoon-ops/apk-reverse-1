local base = UIAsyncNode
local MummyEffect = BaseClass("MummyEffect", base)
local SpriteRenderer = CS.UnityEngine.SpriteRenderer
local SuperTextMesh = CS.SuperTextMesh
local TouchObjectEventTrigger = CS.TouchObjectEventTrigger
local icon_army_path = "num/iconArmy"
local txt_army_count_path = "num/txtArmyCount"
local collider1_path = "num/Collider1"
local image_path = "num/add/Image"
local add_count_path = "num/add/Image/addCount"
local item_icon_bg_path = "num/add/Image/ItemIconBg"
local item_icon_path = "num/add/Image/ItemIconBg/ItemIcon"

function MummyEffect:OnCreate()
  base.OnCreate(self)
  local transform = self.transform
  if IsNull(transform) then
    return
  end
  transform:Set_localScale(1, 1, 1)
  transform:Set_localPosition(0, 3, 0)
  self.anim = transform:Find("num"):GetComponent(typeof(CS.SimpleAnimation))
  self.icon_army = transform:Find(icon_army_path):GetComponent(typeof(SpriteRenderer))
  self.txt_army_count = transform:Find(txt_army_count_path):GetComponent(typeof(SuperTextMesh))
  self.animAddCount = transform:Find(add_count_path):GetComponent(typeof(SuperTextMesh))
  self.animAddIcon = transform:Find(item_icon_path):GetComponent(typeof(SpriteRenderer))
  self.animAddIconBg = transform:Find(item_icon_bg_path):GetComponent(typeof(SpriteRenderer))
end

function MummyEffect:OnDestroy()
  base.OnDestroy(self)
end

function MummyEffect:ReInit(mummyConvertId, mummyConvertCount)
  local oldSoldierId = self.mummyConvertId
  local oldSoldierCount = self.mummyConvertCount
  self.mummyConvertId = mummyConvertId
  self.mummyConvertCount = mummyConvertCount
  if self:AsyncLoadDone() then
    local anim_name = "Default"
    if oldSoldierId and mummyConvertCount < oldSoldierCount then
      self.animAddCount.text = "+" .. oldSoldierCount - mummyConvertCount
      self:LayoutHorizontally()
      local _, _, showAddCount = WorldSimpleModeUtils.ShowMummyTranslate()
      if showAddCount then
        anim_name = "anim"
      else
        anim_name = "Default"
      end
    else
      anim_name = "Default"
    end
    if self.anim:IsPlaying(anim_name) then
      self.anim:Rewind(anim_name)
    else
      self.anim:Play(anim_name)
    end
    self:UpdateData()
  end
end

function MummyEffect:UpdateData()
  if IsNotNull(self.txt_army_count) and self.mummyConvertCount then
    self.txt_army_count.text = self.mummyConvertCount
    local soldierMeta = DataCenter.SoldierDataManager:GetTemplate(self.mummyConvertId)
    if soldierMeta then
      local meta = DataCenter.ResourceItemDataManager:GetResourceItemTemplate(soldierMeta.resourceItemId)
      if meta then
        local iconPath = string.format(LoadPath.UIMainBubble, meta.bubble_icon)
        self.icon_army:LoadSprite(iconPath)
        self.animAddIcon:LoadSprite(iconPath)
      end
      soldierMeta = DataCenter.SoldierDataManager:GetTemplate(DataCenter.SoldierDataManager:GetSoldierIdByLevel(soldierMeta.lv, SoldierType.Mummy))
      if soldierMeta then
        meta = DataCenter.ResourceItemDataManager:GetResourceItemTemplate(soldierMeta.resourceItemId)
        if meta then
          local iconPath = string.format(LoadPath.UIMainBubble, meta.bubble_icon)
          self.animAddIcon:LoadSprite(iconPath)
        end
      end
    end
  end
end

local SPACING = 0.5
local TXT_OFFSET_Y = -0.3

function MummyEffect:LayoutHorizontally()
  self.animAddCount:Rebuild()
  local textWidth = self.animAddCount:GetWidth()
  local spriteWidth = self.animAddIconBg.bounds.size.x
  local totalWidth = textWidth + spriteWidth + SPACING
  self.animAddIconBg.transform:Set_localPosition(totalWidth / 2 - spriteWidth / 2, 0, 0)
  self.animAddCount.transform:Set_localPosition(-totalWidth / 2 + textWidth / 2, TXT_OFFSET_Y, 0)
end

return MummyEffect
