local LWUIMigrationView_GuideProcessItem = BaseClass("LWUIMigrationView_GuideProcessItem", UIBaseContainer)
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization
local text_title_path = "Ani/Title"
local img_desc_path = "Ani/group/Img%d"
local img_icon_path = img_desc_path .. "/Icon%d"
local text_desc_path = img_desc_path .. "/Text%d"
local btn_info_path = "Ani/InfoBtn"
local index_txt_path = "Ani/indexBg/indexTxt"
local ICON_BASE_PATH = "Assets/Main/Sprites/UI/LWUIMigrationIcon/"
local PATH_CHECK_START = "Assets/"

function LWUIMigrationView_GuideProcessItem:OnCreate()
  base.OnCreate(self)
  self.text_title = self:AddComponent(UIText, text_title_path)
  self.img_desc_list = {}
  self.btn_desc_list = {}
  self.text_desc_list = {}
  for i = 1, 3 do
    self.btn_desc_list[i] = self:AddComponent(UIButton, string.format(img_desc_path, i))
    self.img_desc_list[i] = self:AddComponent(UIImage, string.format(img_icon_path, i, i))
    self.text_desc_list[i] = self:AddComponent(UIText, string.format(text_desc_path, i, i))
  end
  self.btn_info = self:AddComponent(UIButton, btn_info_path)
  self.btn_info:SetOnClick(BindCallback(self, self.OnInfoClick))
  self.index_txt = self:AddComponent(UIText, index_txt_path)
end

function LWUIMigrationView_GuideProcessItem:OnDestroy()
  self.btn_desc_list = {}
  self.img_desc_list = {}
  self.text_desc_list = {}
  base.OnDestroy(self)
end

function LWUIMigrationView_GuideProcessItem:OnInfoClick()
  DataCenter.LWSoundManager:PlayEffect(SoundAssetId.SFX_UI_General_Click_1st)
  local strTip = Localization:GetString(self.tipsStr)
  local pos = self.btn_info.transform.position
  local reversal = pos.y < Screen.height / 4
  local num = reversal and 30 or -30
  UIUtil.ShowBubbleTips(strTip, self.btn_info.transform.position, 0, num, 0, nil, nil, {reversal = reversal})
end

function LWUIMigrationView_GuideProcessItem:OnDetailClick(btn, key)
  DataCenter.LWSoundManager:PlayEffect(SoundAssetId.SFX_UI_General_Click_1st)
  local strTip = Localization:GetString(key)
  local pos = self.btn_info.transform.position
  local reversal = pos.y < Screen.height / 4
  local num = reversal and 30 or -30
  UIUtil.ShowBubbleTips(strTip, btn.transform.position, 0, num, 0, nil, nil, {reversal = reversal})
end

function LWUIMigrationView_GuideProcessItem:SetData(guideData, idx)
  self.guideData = guideData
  self.index = idx
  self.text_title:SetLocalText(guideData.tittle)
  self.index_txt:SetText(idx)
  self.tipsStr = guideData.desc
  for i = 1, 3 do
    local imgPath = guideData.iconList[i]
    local img = self.img_desc_list[i]
    if string.IsNullOrEmpty(imgPath) then
      img:SetActive(false)
    else
      do
        local path = imgPath
        if not string.startswith(imgPath, PATH_CHECK_START) then
          path = ICON_BASE_PATH .. imgPath
        end
        local flag = img:LoadSpriteAsyncWithCallback(path, function()
          if img then
            img:SetNativeSize()
          end
        end)
        if not flag then
          img:SetNativeSize()
        end
        local descKey = guideData.descList[i]
        local btn = self.btn_desc_list[i]
        btn:SetOnClick(function()
          self:OnDetailClick(btn, descKey)
        end)
        local nameKey = guideData.nameList[i]
        self.text_desc_list[i]:SetLocalText(nameKey)
        img:SetActive(true)
      end
    end
  end
end

return LWUIMigrationView_GuideProcessItem
