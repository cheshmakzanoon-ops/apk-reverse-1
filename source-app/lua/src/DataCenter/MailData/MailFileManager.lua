local MailFileManager = BaseClass("MailFileManager")
local FileContentManager = CS.MailFileContentManager
local FoldName = "MailContents"
local UseBinary = true

function MailFileManager:__init()
  FileContentManager.InitFileManager(UseBinary)
end

function MailFileManager:__delete()
  FileContentManager.UninitFileManager()
end

function MailFileManager:GetFullName(id)
  return FoldName .. "/" .. tostring(LuaEntry.Player.uid) .. "/" .. id
end

function MailFileManager:IsFileExist(id)
  return FileContentManager.IsFileExist(self:GetFullName(id))
end

function MailFileManager:CreateNewFile(id, content, callback)
  FileContentManager.CreateFile(self:GetFullName(id), content, callback)
end

function MailFileManager:DeleteFile(id, callback)
  FileContentManager.DeleteFile(self:GetFullName(id), callback)
end

function MailFileManager:UpdateFile(id, content, callback)
  FileContentManager.CreateFile(self:GetFullName(id), content, callback)
end

function MailFileManager:GetFileContent(id, callback)
  FileContentManager.ReadFile(self:GetFullName(id), callback)
end

function MailFileManager:CreateMailDatas(list, callback)
  local count = table.length(list)
  for _, v in pairs(list) do
    self:CreateNewFile(v.uid, v.contents, function()
      count = count - 1
      if count == 0 and callback then
        callback(true)
      end
    end)
  end
end

function MailFileManager:RemoveMailDatas(uids, callback)
  local count = table.length(uids)
  for _, v in pairs(uids) do
    self:DeleteFile(v, function()
      count = count - 1
      if count == 0 and callback then
        callback()
      end
    end)
  end
end

return MailFileManager
