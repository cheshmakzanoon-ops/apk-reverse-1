local UIGiftPackagePoint = BaseClass("UIGiftPackagePoint", UIBaseContainer)
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization
local UIGray = CS.UIGray
local pointCountText = "PointCountText"
local pointIcon = "PointIcon"

function UIGiftPackagePoint:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
end

function UIGiftPackagePoint:ComponentDefine()
  self.pointCountText = self:AddComponent(UIText, pointCountText)
  self.pointIcon = self:AddComponent(UIImage, pointIcon)
end

function UIGiftPackagePoint:ComponentDestroy()
  self.pointCountText = nil
  self.pointIcon = nil
end

function UIGiftPackagePoint:OnDestroy()
  self:CutAnimation()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UIGiftPackagePoint:OnEnable()
  base.OnEnable(self)
end

function UIGiftPackagePoint:OnDisable()
  base.OnDisable(self)
  self:CutAnimation()
end

function UIGiftPackagePoint:RefreshPoint(packData)
  self:CutAnimation()
  if packData then
    local point, actIds = packData:getRechargePoint()
    if point == 0 then
      self:SetActive(false)
    else
      self:SetActive(true)
      self.pointCountText:SetText(point)
      local iconPath = DefaultRechargePointIconPath
      if actIds and table.count(actIds) == 1 then
        local actBaseInfo = DataCenter.ActivityListDataManager:GetActivityDataById(actIds[1])
        if actBaseInfo and not string.IsNullOrEmpty(actBaseInfo.para) then
          iconPath = actBaseInfo.para
        end
      else
        local icons = {}
        local iconMap = {}
        for i, v in pairs(actIds) do
          local actBaseInfo = DataCenter.ActivityListDataManager:GetActivityDataById(v)
          if actBaseInfo and not string.IsNullOrEmpty(actBaseInfo.para) and not iconMap[actBaseInfo.para] then
            table.insert(icons, actBaseInfo.para)
            iconMap[actBaseInfo.para] = true
          elseif not iconMap[DefaultRechargePointIconPath] then
            table.insert(icons, DefaultRechargePointIconPath)
            iconMap[DefaultRechargePointIconPath] = true
          end
        end
        self:StartPlayAnimation(icons)
      end
      self.pointIcon:LoadSprite(DataCenter.ActivityListDataManager:GetActivityModLoadPath(LoadPath.ItemPath, iconPath))
      self.pointIcon:SetLocalScaleXYZ(0.7, 0.7, 1)
      self.pointIcon:SetNativeSize()
    end
  else
    self:SetActive(false)
  end
end

function UIGiftPackagePoint:StartPlayAnimation(icons)
  self:CutAnimation()
  self.seq = CS.DG.Tweening.DOTween.Sequence()
  for i, v in ipairs(icons) do
    self.seq:Append(self.pointIcon:DOFade(0, 0.25))
    self.seq:AppendCallback(function()
      self.pointIcon:LoadSprite(DataCenter.ActivityListDataManager:GetActivityModLoadPath(LoadPath.ItemPath, v))
      self.pointIcon:SetNativeSize()
    end)
    self.seq:Append(self.pointIcon:DOFade(1, 0.5))
    self.seq:AppendInterval(2)
  end
  self.seq:SetLoops(-1)
end

function UIGiftPackagePoint:CutAnimation()
  if self.seq then
    self.seq:Kill()
    self.seq = nil
  end
  if self.pointIcon then
    self.pointIcon:SetAlpha(1)
  end
end

return UIGiftPackagePoint
