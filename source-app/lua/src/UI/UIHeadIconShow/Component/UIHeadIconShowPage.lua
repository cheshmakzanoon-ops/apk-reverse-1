local UIHeadIconShowPage = BaseClass("UIHeadIconShowPage", UIBaseContainer)
local base = UIBaseContainer

function UIHeadIconShowPage:OnCreate()
  base.OnCreate(self)
  self.playerData = nil
  self.loadingImg = self:AddComponent(UIImage, "imgLoading")
  self.head_img = self:AddComponent(UIPlayerHead, "")
  self.head_img:SetCustomLoadCallback(function()
    self.loadingImg:SetActive(false)
  end)
  self.loadingImg:SetActive(false)
  self.head_img:UseSystemHead()
end

function UIHeadIconShowPage:OnDestroy()
  base.OnDestroy(self)
  self.playerData = nil
end

function UIHeadIconShowPage:SetData(data, headIconType)
  self.playerData = data
  self.headIconType = headIconType
end

function UIHeadIconShowPage:ShowHeadIcon()
  local userData = self.playerData
  if not userData then
    self.loadingImg:SetActive(false)
    self.head_img:UseSystemHead()
    return
  end
  if self.headIconType == HeadIconType.Npc then
    local fullPath = userData.picVer
    self.loadingImg:SetActive(false)
    self.head_img:UseSpecifiedRes(fullPath)
  elseif userData.uid then
    if (userData.picVer == nil or userData.picVer <= 0 or userData.picVer > 1000000) and not string.IsNullOrEmpty(userData.pic) then
      self.loadingImg:SetActive(false)
    else
      self.loadingImg:SetActive(true)
    end
    self.head_img:SetBigData(userData.uid, userData.pic, userData.picVer, true)
  else
    self.loadingImg:SetActive(false)
    self.head_img:UseSystemHead()
  end
end

return UIHeadIconShowPage
