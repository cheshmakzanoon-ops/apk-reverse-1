local UIServerNoticeView = BaseClass("UIServerNoticeView", UIBaseView)
local base = UIBaseView
local Localization = CS.GameEntry.Localization
local rapidjson = require("rapidjson")
local defaultIcon = "Assets/Main/TextureEx/UIServerNoticeIcon/zxl_banner_gonggao_npc.png"
local iconPath = "Assets/Main/TextureEx/UIServerNoticeIcon/%s.png"

function UIServerNoticeView:OnCreate()
  base.OnCreate(self)
  self:Init()
  local json = self:GetUserData()
  self:ParseJson(json)
  
  function self.__onUpdate()
    self:OnUpdate()
  end
  
  UpdateManager:GetInstance():AddUpdate(self.__onUpdate)
  self.scrollView.verticalNormalizedPosition = 1
end

function UIServerNoticeView:OnDestroy()
  if self.__onUpdate then
    UpdateManager:GetInstance():RemoveUpdate(self.__onUpdate)
    self.__onUpdate = nil
  end
  self:Destroy()
  base.OnDestroy(self)
end

function UIServerNoticeView:Init()
  local panel = self.transform:Find("Panel")
  panel.localScale = CS.UnityEngine.Vector3.one * 0.8
  panel:DOScale(CS.UnityEngine.Vector3.one, 0.2):SetEase(CS.DG.Tweening.Ease.OutBack)
  self.btnClose = panel:Find("Top/btn_close"):GetComponent(typeof(CS.UnityEngine.UI.Button))
  self.txtTop = panel:Find("Top/txt_top"):GetComponent(typeof(CS.TextMeshProUGUIEx))
  self.txtTop.text = Localization:GetString("2700004")
  self.scrollView = panel:Find("Mid/Scroll View"):GetComponent(typeof(CS.UnityEngine.UI.ScrollRect))
  self.transContent = panel:Find("Mid/Scroll View/Viewport/Content")
  self.txtDate = panel:Find("Top/txt_date"):GetComponent(typeof(CS.TextMeshProUGUIEx))
  self.txtDate.text = ""
  self.temp_h1 = self.transContent:Find("temp_h1").gameObject
  self.temp_h2 = self.transContent:Find("temp_h2").gameObject
  self.temp_h3 = self.transContent:Find("temp_h3").gameObject
  self.temp_text = self.transContent:Find("temp_text").gameObject
  self.temp_h1:SetActive(false)
  self.temp_h2:SetActive(false)
  self.temp_h3:SetActive(false)
  self.temp_text:SetActive(false)
  self.text_comps = {}
  
  function self.__onClickClose()
    self:Close()
  end
  
  self.btnClose.onClick:AddListener(self.__onClickClose)
  local line = self.transContent:Find("temp_line")
  if line then
    self.temp_line = line.gameObject
    self.temp_line:SetActive(false)
  end
  self.lineCreated = false
  local dArrow = panel:Find("Mid/Scroll View/downArrow")
  if dArrow then
    self.downArrow = dArrow.gameObject
    self.downArrow:SetActive(false)
  end
  local uArrow = panel:Find("Mid/Scroll View/upArrow")
  if uArrow then
    self.upArrow = uArrow.gameObject
    self.upArrow:SetActive(false)
  end
  self.downArrowEnable = false
  self.upArrowEnable = false
  self.scrollViewport = self.scrollView.viewport
  self.scrollContent = self.scrollView.content
  self.checkView = false
  self.scrollRectValid = false
  self.iconGo = panel:Find("Mid/bannerBg/banner")
  if self.iconGo then
    self.icon = self.iconGo:GetComponent(typeof(CS.UnityEngine.UI.RawImage))
  end
end

function UIServerNoticeView:Destroy()
  self.txtTop = nil
  self.transContent = nil
  self.txtDate = nil
  self.temp_h1 = nil
  self.temp_h2 = nil
  self.temp_h3 = nil
  self.temp_text = nil
  self.scrollView = nil
  self.text_comps = nil
  if not IsNull(self.btnClose) then
    self.btnClose.onClick:RemoveListener(self.__onClickClose)
    self.btnClose = nil
  end
  self.__onClickClose = nil
  self.temp_line = nil
  self.lineCreated = false
end

function UIServerNoticeView:ParseJson(json)
  local jsonObj = rapidjson.decode(json)
  if jsonObj == nil then
    printError("Server Notice Error! json is invalid: " .. tostring(json))
    self:Close()
    return
  end
  if type(jsonObj.date) == "string" then
    self.txtDate.text = tostring(jsonObj.date)
  else
    self.txtDate.text = tostring(jsonObj.date.text)
    self.txtDate.fontSize = jsonObj.date.fontSize or 42
  end
  local contents = jsonObj.contents
  if contents == nil then
    printError("Server Notice Error! content is nil: " .. tostring(json))
    self:Close()
    return
  end
  for _, item in ipairs(contents) do
    local func = self["CreateEntry_" .. item.style]
    if func == nil then
      printError("Server Notice Error! unknown style: " .. item.style)
      self:Close()
      return
    end
    func(self, item)
    if not self.lineCreated and item.style == "text" then
      self.lineCreated = true
      self:CreateEntry_line()
    end
  end
  local bannerIcon = jsonObj.bannericon
  if string.IsNullOrEmpty(bannerIcon) then
    if self.icon then
      self.icon:LoadSprite(defaultIcon)
      self.icon:SetNativeSize()
    end
    return
  end
  if self.icon then
    local path = string.format(iconPath, bannerIcon)
    self.icon:LoadSprite(path, defaultIcon)
    self.icon:SetNativeSize()
  end
end

function UIServerNoticeView:OnUpdate()
  local textCount = #self.text_comps
  for i = textCount, 1, -1 do
    local textComp = self.text_comps[i]
    local height = textComp.transform.rect.height
    if 0 < height then
      textComp.transform.parent.sizeDelta = CS.UnityEngine.Vector2(textComp.transform.parent.sizeDelta.x, height)
      table.remove(self.text_comps, i)
    end
  end
  if textCount == 0 and not self.checkView then
    self.checkView = true
    local viewPortSize = self.scrollViewport.rect.size.y
    local contentSize = self.scrollContent.rect.size.y
    self.scrollRectValid = viewPortSize < contentSize
  end
  local vP = self.scrollView.verticalNormalizedPosition
  self:EnableDownArrow(self.scrollRectValid and 0.1 < vP)
end

function UIServerNoticeView:Close()
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UIServerNotice)
end

function UIServerNoticeView:CreateEntry_h1(item)
  local entry = CS.UnityEngine.GameObject.Instantiate(self.temp_h1, self.transContent)
  entry:SetActive(true)
  entry:GetComponentInChildren(typeof(CS.TextMeshProUGUIEx)).text = tostring(item.text)
end

function UIServerNoticeView:CreateEntry_h2(item)
  local entry = CS.UnityEngine.GameObject.Instantiate(self.temp_h2, self.transContent)
  entry:SetActive(true)
  entry.transform:Find("dot").gameObject:SetActive(item.dot)
  entry:GetComponentInChildren(typeof(CS.TextMeshProUGUIEx)).text = tostring(item.text)
end

function UIServerNoticeView:CreateEntry_h3(item)
  local entry = CS.UnityEngine.GameObject.Instantiate(self.temp_h3, self.transContent)
  entry:SetActive(true)
  entry:GetComponentInChildren(typeof(CS.TextMeshProUGUIEx)).text = tostring(item.text)
end

function UIServerNoticeView:CreateEntry_text(item)
  local entry = CS.UnityEngine.GameObject.Instantiate(self.temp_text, self.transContent)
  entry:SetActive(true)
  local textComp = entry:GetComponentInChildren(typeof(CS.TextMeshProUGUIEx))
  textComp.text = tostring(item.text)
  table.insert(self.text_comps, textComp)
end

function UIServerNoticeView:CreateEntry_line()
  if self.temp_line then
    local entry = CS.UnityEngine.GameObject.Instantiate(self.temp_line, self.transContent)
    entry:SetActive(true)
  end
end

function UIServerNoticeView:EnableUpArrow(enable)
  if self.upArrowEnable == enable then
    return
  end
  self.upArrowEnable = enable
  if self.upArrow then
    self.upArrow:SetActive(enable)
  end
end

function UIServerNoticeView:EnableDownArrow(enable)
  if self.downArrowEnable == enable then
    return
  end
  self.downArrowEnable = enable
  if self.downArrow then
    self.downArrow:SetActive(enable)
  end
end

return UIServerNoticeView
