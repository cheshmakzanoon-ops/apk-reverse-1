local UIDesertBattleDetailItem = BaseClass("UIDesertBattleDetailItem", UIBaseContainer)
local base = UIBaseContainer
local UnityRectTransform = typeof(CS.UnityEngine.RectTransform)
local big_image_path = "BigImage"
local left_path = "detail/left"
local img_path = "detail/left/img"
local raw_img_path = "detail/left/rawImg"
local title_text_path = "detail/TextScrollRect/ViewPort/TitleText"
local Scroll_Height = 220

function UIDesertBattleDetailItem:OnCreate()
  base.OnCreate(self)
  self.big_pic = self:AddComponent(UIRawImage, big_image_path)
  self.left = self:AddComponent(UIBaseContainer, left_path)
  self.small_pic_raw = self:AddComponent(UIRawImage, raw_img_path)
  self.small_pic = self:AddComponent(UIImage, img_path)
  self.title_text = self:AddComponent(UIText, title_text_path)
  self.title_rectTransform = self.transform:Find(title_text_path):GetComponent(UnityRectTransform)
end

function UIDesertBattleDetailItem:OnDestroy()
  self.small_pic_raw = nil
  self.small_pic = nil
  base.OnDestroy(self)
end

function UIDesertBattleDetailItem:ReInit(v)
  self.data = v
  self.title_text:SetLocalText(v.desc)
  local text_height = self.title_text:GetHeight()
  if v.battle_type == BattleFieldType.Desert then
    self.big_pic:LoadSpriteAuto(string.format(LoadPath.LWBattleFieldDesertTexturePath, v.big_pic))
    if string.IsNullOrEmpty(v.small_pic) then
      self.left:SetActive(false)
      self.title_rectTransform:Set_pivot(0.5, 1)
    else
      self.small_pic:SetActive(true)
      self.small_pic_raw:SetActive(false)
      local path
      if string.contains(v.small_pic, "zyf_shuomingjiemian") or string.contains(v.small_pic, "_jianzhuxiangqing_") then
        path = string.format(LoadPath.LWBattleFieldDesertDetailPath, v.small_pic)
      else
        path = string.format(LoadPath.LWBattleFieldDesertPath, v.small_pic)
      end
      self.small_pic:LoadSpriteAsyncWithCallback(path, function()
        if self.small_pic then
          self.small_pic:SetNativeSize()
          self.small_pic:SetLocalScaleXYZ(0.75, 0.75, 0.75)
        end
      end)
      if text_height > Scroll_Height then
        self.title_rectTransform:Set_pivot(0.5, 1)
      else
        self.title_rectTransform:Set_pivot(0.5, 0.5)
      end
    end
  elseif v.battle_type == BattleFieldType.WinterStorm then
    self.big_pic:LoadSpriteAuto(string.format(LoadPath.LWBattleFieldWinterTextureGuidePath, v.big_pic))
    if string.IsNullOrEmpty(v.small_pic) then
      self.left:SetActive(false)
      self.title_rectTransform:Set_pivot(0.5, 1)
    else
      self.small_pic:SetActive(true)
      self.small_pic_raw:SetActive(false)
      self.small_pic:LoadSpriteAsyncWithCallback(string.format(LoadPath.LWBattleFieldWinterDetailPath, v.small_pic), function()
        if self.small_pic then
          self.small_pic:SetNativeSize()
          self.small_pic:SetLocalScaleXYZ(0.75, 0.75, 0.75)
        end
      end)
      if text_height > Scroll_Height then
        self.title_rectTransform:Set_pivot(0.5, 1)
      else
        self.title_rectTransform:Set_pivot(0.5, 0.5)
      end
    end
  elseif v.battle_type == BattleFieldType.EpidemicZone then
    self.big_pic:LoadSpriteAuto(string.format(LoadPath.LWBattleFieldEpidemicTexture3Path, v.big_pic))
    if string.IsNullOrEmpty(v.small_pic) then
      self.left:SetActive(false)
      self.title_rectTransform:Set_pivot(0.5, 1)
    else
      self.small_pic:SetActive(false)
      self.small_pic_raw:SetActive(true)
      self.small_pic_raw:LoadSpriteAuto(string.format(LoadPath.LWBattleFieldEpidemicTexture3Path, v.small_pic), function()
        if self.small_pic_raw then
          self.small_pic_raw:SetNativeSize()
          self.small_pic_raw:SetLocalScaleXYZ(1, 1, 1)
        end
      end)
      if text_height > Scroll_Height then
        self.title_rectTransform:Set_pivot(0.5, 1)
      else
        self.title_rectTransform:Set_pivot(0.5, 0.5)
      end
    end
  elseif v.battle_type == BattleFieldType.DsbDuel then
    self.big_pic:LoadSpriteAuto(string.format(LoadPath.LWBattleFieldDsbDuelTexturePath, v.big_pic))
    if string.IsNullOrEmpty(v.small_pic) then
      self.left:SetActive(false)
      self.title_rectTransform:Set_pivot(0.5, 1)
    else
      self.small_pic:SetActive(false)
      self.small_pic_raw:SetActive(true)
      self.small_pic_raw:LoadSpriteAuto(string.format(LoadPath.LWBattleFieldDsbDuelTexturePath, v.small_pic), function()
        if self.small_pic_raw then
          self.small_pic_raw:SetNativeSize()
          self.small_pic_raw:SetLocalScaleXYZ(1, 1, 1)
        end
      end)
      if text_height > Scroll_Height then
        self.title_rectTransform:Set_pivot(0.5, 1)
      else
        self.title_rectTransform:Set_pivot(0.5, 0.5)
      end
    end
  else
    self.big_pic:LoadSpriteAuto(v.big_pic)
    if string.IsNullOrEmpty(v.small_pic) then
      self.left:SetActive(false)
      self.title_rectTransform:Set_pivot(0.5, 1)
    else
      self.small_pic:SetActive(true)
      self.small_pic_raw:SetActive(false)
      self.small_pic:LoadSpriteAsyncWithCallback(v.small_pic, function()
        if self.small_pic then
          self.small_pic:SetNativeSize()
        end
      end)
      if text_height > Scroll_Height then
        self.title_rectTransform:Set_pivot(0.5, 1)
      else
        self.title_rectTransform:Set_pivot(0.5, 0.5)
      end
    end
  end
end

return UIDesertBattleDetailItem
