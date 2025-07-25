-- CONFIG
--#region Config

HotPotato = SMODS.current_mod

--#endregion

-- FILE LOADING
--#region File Loading
local nativefs = NFS

local function load_file_native(path, id)
    if not path or path == "" then
        error("No path was provided to load.")
    end
    local file_path = path
    local file_content, err = NFS.read(file_path)
    if not file_content then return  nil, "Error reading file '" .. path .. "' for mod with ID '" .. SMODS.current_mod.id .. "': " .. err end
    local chunk, err = load(file_content, "=[SMODS " .. SMODS.current_mod.id .. ' "' .. path .. '"]')
    if not chunk then return nil, "Error processing file '" .. path .. "' for mod with ID '" .. SMODS.current_mod.id .. "': " .. err end
    return chunk
end
local blacklist = {
	assets = true,
	lovely = true,
	[".github"] = true,
	[".git"] = true,
	["localization"] = true
}
local function load_files(path, dirs_only)
	local info = nativefs.getDirectoryItemsInfo(path)
	for i, v in pairs(info) do
		if v.type == "directory" and not blacklist[v.name] then	
			load_files(path.."/"..v.name)
		elseif not dirs_only then
			if string.find(v.name, ".lua") then -- no X.lua.txt files or whatever unless they are also lua files
				local f, err = load_file_native(path.."/"..v.name)
				if f then f() 
				else error("error in file "..v.name..": "..err) end
			end
		end
	end
end
local path = SMODS.current_mod.path

load_files(path, true)
--#endregion
